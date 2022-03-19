function starship_prompt
	set -l exit_code $status
	switch "$fish_key_bindings"
		case fish_hybrid_key_bindings fish_vi_key_bindings
			set keymap "$fish_bind_mode"
		case '*'
			set keymap insert
	end
	# Account for changes in variable name between v2.7 and v3.0
	set -l starship_duration "$CMD_DURATION$cmd_duration"
	echo -n " "
	"/opt/homebrew/bin/starship" prompt --status=$exit_code --keymap=$keymap --cmd-duration=$starship_duration --jobs=(count (jobs -p))
end
