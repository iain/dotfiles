# switch fish color scheme when dark-mode is on
function fish-dark-mode
	if dark-mode status | grep -q off
		set --universal ayu_variant light && ayu_load_theme > /dev/null
	else
		set --universal ayu_variant mirage && ayu_load_theme > /dev/null
	end
end
