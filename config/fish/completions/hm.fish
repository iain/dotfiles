complete -c hm -f

complete -c hm -n __fish_use_subcommand -a list -d 'List saved SSH machines'
complete -c hm -n __fish_use_subcommand -a add -d 'Prepare a remote Herdr server and save it'
complete -c hm -n __fish_use_subcommand -a rename -d 'Rename a saved SSH machine'
complete -c hm -n __fish_use_subcommand -a remove -d 'Remove a saved SSH machine'
complete -c hm -n __fish_use_subcommand -a enable -d 'Enable a saved SSH machine'
complete -c hm -n __fish_use_subcommand -a disable -d 'Disable a saved SSH machine'

complete -c hm -n '__fish_seen_subcommand_from list' -l json -d 'Print as JSON'
complete -c hm -n '__fish_seen_subcommand_from rename' -l label -r -d 'New label'

# Offer disabled machines to enable, enabled ones to disable, and any to the rest.
complete -c hm -n '__fish_seen_subcommand_from enable' -a '(command herdr machine list --json | jq -r ".[] | select(.enabled | not) | .label + \"\t\" + .target")'
complete -c hm -n '__fish_seen_subcommand_from disable' -a '(command herdr machine list --json | jq -r ".[] | select(.enabled) | .label + \"\t\" + .target")'
complete -c hm -n '__fish_seen_subcommand_from rename remove' -a '(command herdr machine list --json | jq -r ".[] | .label + \"\t\" + .target")'
