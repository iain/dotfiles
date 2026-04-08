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
HOME         = Pathname.new(Dir.home)

SKIP = %w[config.local.example].freeze

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: #{$PROGRAM_NAME} [options]"
  opts.on("-n", "--dry-run", "Show what would be done without making changes") { options[:dry_run] = true }
  opts.on("-y", "--yes", "Answer yes to all prompts") { options[:yes] = true }
  opts.on("--[no-]macos", "Run macOS defaults (auto-detected on macOS)") { |v| options[:macos] = v }
  opts.on("--[no-]brew", "Run brew bundle (auto-detected when Brewfile present)") { |v| options[:brew] = v }
  opts.on("--[no-]fish", "Set fish as default shell") { |v| options[:fish] = v }
end.parse!

dry_run = options[:dry_run]
counts = { linked: 0, skipped: 0, backed_up: 0 }

def prompt?(question, options)
  return true if options[:yes]
  print "#{question} [y/N] "
  $stdin.gets&.strip&.downcase == "y"
end

def symlink(src, dest, dry_run:, counts:)
  if dest.symlink?
    if dest.realpath == src.realpath
      puts "  skip #{dest} (already linked)"
      counts[:skipped] += 1
      return
    else
      backup = Pathname.new("#{dest}.backup")
      abort "ERROR: #{backup} already exists, not overwriting. Remove it manually and re-run." if backup.exist?
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

# Create vim directories for swap, backup, and undo
%w[swap tmp undo].each do |dir|
  vim_dir = HOME / ".vim" / dir
  if vim_dir.directory?
    puts "  skip #{vim_dir} (already exists)"
  elsif dry_run
    puts "  [dry-run] would create #{vim_dir}"
  else
    FileUtils.mkdir_p(vim_dir)
    puts "  created #{vim_dir}"
  end
end

# Create local config files if they don't exist
git_local = CONFIG_DEST / "git" / "config.local"
if git_local.exist?
  puts "\n  skip #{git_local} (already exists)"
else
  puts "\nSetting up git identity (#{git_local})..."
  if dry_run
    puts "  [dry-run] would create #{git_local}"
  else
    print "  Git name: "
    git_name = $stdin.gets&.strip || ""
    print "  Git email: "
    git_email = $stdin.gets&.strip || ""
    print "  SSH signing key path [~/.ssh/id_ed25519.pub]: "
    git_key = $stdin.gets&.strip
    git_key = "~/.ssh/id_ed25519.pub" if git_key.nil? || git_key.empty?

    FileUtils.mkdir_p(git_local.dirname)
    git_local.write(<<~CONFIG)
      [user]
        email = #{git_email}
        name = #{git_name}
        signingKey = #{git_key}
    CONFIG
    puts "  created #{git_local}"
  end
end

ssh_config = HOME / ".ssh" / "config"
if ssh_config.exist?
  puts "  skip #{ssh_config} (already exists)"
else
  if dry_run
    puts "  [dry-run] would create #{ssh_config}"
  else
    FileUtils.mkdir_p(ssh_config.dirname, mode: 0700)
    ssh_config.write(<<~CONFIG)
      Host *
        AddKeysToAgent yes
        UseKeychain yes
        IdentityFile ~/.ssh/id_ed25519
    CONFIG
    FileUtils.chmod(0600, ssh_config)
    puts "  created #{ssh_config}"
  end
end

fish_local = CONFIG_DEST / "fish" / "config.local.fish"
if fish_local.exist?
  puts "  skip #{fish_local} (already exists)"
else
  if dry_run
    puts "  [dry-run] would create #{fish_local}"
  else
    FileUtils.mkdir_p(fish_local.dirname)
    fish_local.write(<<~CONFIG)
      # Local fish config — secrets and machine-specific settings
      # This file is not checked into git.
    CONFIG
    puts "  created #{fish_local}"
  end
end

puts "\nSymlinks: #{counts[:linked]} linked, #{counts[:skipped]} skipped, #{counts[:backed_up]} backed up."

# Install Homebrew if missing
unless system("command -v brew > /dev/null 2>&1")
  if prompt?("Homebrew is not installed. Install it?", options)
    puts "\nInstalling Homebrew..."
    if dry_run
      puts "  [dry-run] would install Homebrew"
    else
      system("bash", "-c", '$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)') || warn("WARNING: Homebrew installation had errors")
    end
  end
end

# Brew bundle
run_brew = if options.key?(:brew)
  options[:brew]
elsif (DOTFILES_DIR / "Brewfile").file? && system("command -v brew > /dev/null 2>&1")
  prompt?("Install Homebrew packages?", options)
else
  false
end

if run_brew
  brewfile = DOTFILES_DIR / "Brewfile"
  puts "\nInstalling Homebrew packages from #{brewfile}..."
  if dry_run
    puts "  [dry-run] would run: brew bundle --file=#{brewfile}"
  else
    system("brew", "bundle", "--file=#{brewfile}") || warn("WARNING: brew bundle had errors")
  end
end

# macOS defaults
run_macos = if options.key?(:macos)
  options[:macos]
elsif RUBY_PLATFORM.include?("darwin")
  prompt?("Apply macOS defaults?", options)
else
  false
end

if run_macos
  macos_script = DOTFILES_DIR / "macos.sh"
  if macos_script.file?
    puts "\nApplying macOS defaults from #{macos_script}..."
    if dry_run
      puts "  [dry-run] would run: bash #{macos_script}"
    else
      system("bash", macos_script.to_s) || warn("WARNING: macos.sh had errors")
    end
  else
    puts "\nSkipping macOS defaults (#{macos_script} not found)."
  end
end

# Set fish as default shell
fish_path = "/opt/homebrew/bin/fish"
run_fish = if options.key?(:fish)
  options[:fish]
elsif File.executable?(fish_path) && ENV.fetch("SHELL", "") != fish_path
  prompt?("Set fish as default shell?", options)
else
  false
end

if run_fish && File.executable?(fish_path)
  shells = File.read("/etc/shells")
  unless shells.include?(fish_path)
    puts "\nAdding #{fish_path} to /etc/shells..."
    if dry_run
      puts "  [dry-run] would add #{fish_path} to /etc/shells"
    else
      system("sudo", "sh", "-c", "echo '#{fish_path}' >> /etc/shells") || warn("WARNING: could not add fish to /etc/shells")
    end
  end

  current_shell = ENV.fetch("SHELL", "")
  if current_shell != fish_path
    puts "\nSetting fish as default shell..."
    if dry_run
      puts "  [dry-run] would run: chsh -s #{fish_path}"
    else
      system("chsh", "-s", fish_path) || warn("WARNING: could not set default shell")
    end
  else
    puts "\n  skip default shell (already fish)"
  end
end

puts "\nAll done."
