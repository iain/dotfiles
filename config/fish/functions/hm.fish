function hm --description 'herdr machine, addressing machines by label instead of profile ID'
  if test (count $argv) -eq 0
    command herdr machine list
    return
  end

  # Only these subcommands take a profile ID, and always as the last argument.
  if contains -- $argv[1] enable disable rename remove; and test (count $argv) -gt 1
    set -l target $argv[-1]
    if not string match -qr '^[0-9a-f]{32}$' -- $target
      set -l id (command herdr machine list --json | jq -r --arg label $target '.[] | select(.label == $label) | .id')
      if test -z "$id"
        echo "hm: no machine labelled '$target'" >&2
        return 1
      end
      set argv[-1] $id
    end
  end

  command herdr machine $argv
end
