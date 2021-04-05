# switch fish color scheme when dark-mode is on
function fish-dark-mode
	if dark-mode status | grep off > /dev/null
		theme_gruvbox light hard
	else
		theme_gruvbox dark hard
	end
end
