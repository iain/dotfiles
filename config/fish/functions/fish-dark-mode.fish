# switch fish color scheme when dark-mode is on
function fish-dark-mode
	if dark-mode status | grep off > /dev/null
		set -U fish_color_normal normal
		set -U fish_color_command a1b56c
		set -U fish_color_quote f7ca88
		set -U fish_color_redirection 383838
		set -U fish_color_end ba8baf
		set -U fish_color_error ab4642
		set -U fish_color_selection white --bold --background=brblack
		set -U fish_color_search_match bryellow --background=brblack
		set -U fish_color_history_current --bold
		set -U fish_color_operator 7cafc2
		set -U fish_color_escape 86c1b9
		set -U fish_color_cwd green
		set -U fish_color_cwd_root red
		set -U fish_color_valid_path --underline
		set -U fish_color_autosuggestion b8b8b8
		set -U fish_color_user brgreen
		set -U fish_color_host normal
		set -U fish_color_cancel -r
		set -U fish_pager_color_completion normal
		set -U fish_pager_color_description B3A06D yellow
		set -U fish_pager_color_prefix white --bold --underline
		set -U fish_pager_color_progress brwhite --background=cyan
		set -U fish_color_match 7cafc2
		set -U fish_color_comment f7ca88
		set -U fish_color_param 383838
	else
		set -U fish_color_normal normal
		set -U fish_color_command a1b56c
		set -U fish_color_quote f7ca88
		set -U fish_color_redirection d8d8d8
		set -U fish_color_end ba8baf
		set -U fish_color_match 7cafc2
		set -U fish_pager_color_progress brwhite --background=cyan
		set -U fish_pager_color_prefix white --bold --underline
		set -U fish_pager_color_description B3A06D yellow
		set -U fish_pager_color_completion normal
		set -U fish_color_cancel -r
		set -U fish_color_host normal
		set -U fish_color_user brgreen
		set -U fish_color_autosuggestion 585858
		set -U fish_color_valid_path --underline
		set -U fish_color_cwd_root red
		set -U fish_color_cwd green
		set -U fish_color_escape 86c1b9
		set -U fish_color_operator 7cafc2
		set -U fish_color_history_current --bold
		set -U fish_color_search_match bryellow --background=brblack
		set -U fish_color_selection white --bold --background=brblack
		set -U fish_color_comment f7ca88
		set -U fish_color_error ab4642
		set -U fish_color_param d8d8d8
	end
end
