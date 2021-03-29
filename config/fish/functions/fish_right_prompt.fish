function fish_right_prompt
	fish-dark-mode &
  switch "$fish_key_bindings"
      case fish_hybrid_key_bindings fish_vi_key_bindings
          set keymap "$fish_bind_mode"
      case '*'
          set keymap insert
  end
	set -x STARSHIP_CONFIG ~/.dotfiles/config/starship-right.toml
  set -l starship_duration "$CMD_DURATION$cmd_duration"
  "/usr/local/bin/starship" prompt \
     --keymap=$keymap \
     --cmd-duration=$starship_duration \
     --jobs=(count (jobs -p))
end
