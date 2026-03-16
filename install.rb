#!/usr/bin/env ruby
# frozen_string_literal: true

# Symlinks config files from this repo into ~/.config and rc files into ~/

require "fileutils"
require "optparse"
require "pathname"

DOTFILES_DIR = Pathname.new(__dir__ || abort("Cannot determine script directory"))
CONFIG_SRC   = DOTFILES_DIR / "config"
CONFIG_DEST  = Pathname.new(Dir.home) / ".config"
RC_SRC       = DOTFILES_DIR / "rc"
CLAUDE_SRC   = DOTFILES_DIR / "claude"
CLAUDE_DEST  = Pathname.new(Dir.home) / ".claude"
HOME         = Pathname.new(Dir.home)

SKIP = %w[config.local.example].freeze

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: #{$PROGRAM_NAME} [options]"
  opts.on("-n", "--dry-run", "Show what would be done without making changes") { options[:dry_run] = true }
end.parse!

dry_run = options[:dry_run]
counts = { linked: 0, skipped: 0, backed_up: 0 }

def symlink(src, dest, dry_run:, counts:)
  if dest.symlink?
    if dest.realpath == src.realpath
      puts "  skip #{dest} (already linked)"
      counts[:skipped] += 1
      return
    else
      puts "  #{dry_run ? "[dry-run] would remove" : "removing"} old symlink #{dest} -> #{dest.readlink}"
      dest.delete unless dry_run
    end
  elsif dest.exist?
    backup = Pathname.new("#{dest}.backup")
    if backup.exist?
      abort "ERROR: #{backup} already exists, not overwriting. Remove it manually and re-run."
    end
    puts "  #{dry_run ? "[dry-run] would back up" : "backing up"} #{dest} -> #{backup}"
    FileUtils.mv(dest, backup) unless dry_run
    counts[:backed_up] += 1
  end

  puts "  #{dry_run ? "[dry-run] would link" : "linked"} #{dest} -> #{src}"
  unless dry_run
    FileUtils.mkdir_p(dest.dirname)
    FileUtils.ln_s(src, dest)
  end
  counts[:linked] += 1
end

unless CONFIG_SRC.directory?
  abort "ERROR: #{CONFIG_SRC} not found. Run this script from the dotfiles directory."
end

files = Dir.glob("**/*", base: CONFIG_SRC).sort
files.select! { |f| (CONFIG_SRC / f).file? }
files.reject! { |f| SKIP.include?(Pathname.new(f).basename.to_s) }

if files.empty?
  abort "No config files found in #{CONFIG_SRC}."
end

puts dry_run ? "Dry run — no changes will be made:\n\n" : "Installing config symlinks:\n\n"

files.each do |relative|
  src  = CONFIG_SRC / relative
  dest = CONFIG_DEST / relative
  symlink(src, dest, dry_run: dry_run, counts: counts)
end

# claude/ files are symlinked into ~/.claude/
if CLAUDE_SRC.directory?
  claude_files = Dir.glob("**/*", base: CLAUDE_SRC).sort
  claude_files.select! { |f| (CLAUDE_SRC / f).file? }

  unless claude_files.empty?
    puts "\n"
    claude_files.each do |relative|
      src  = CLAUDE_SRC / relative
      dest = CLAUDE_DEST / relative
      symlink(src, dest, dry_run: dry_run, counts: counts)
    end
  end
end

# rc/ files are symlinked into ~/ with a dot prefix (rc/vimrc -> ~/.vimrc)
if RC_SRC.directory?
  rc_files = Dir.glob("*", base: RC_SRC).sort
  rc_files.select! { |f| (RC_SRC / f).file? }

  unless rc_files.empty?
    puts "\n"
    rc_files.each do |name|
      src  = RC_SRC / name
      dest = HOME / ".#{name}"
      symlink(src, dest, dry_run: dry_run, counts: counts)
    end
  end
end

puts "\nDone. #{counts[:linked]} linked, #{counts[:skipped]} skipped, #{counts[:backed_up]} backed up."
