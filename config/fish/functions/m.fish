function m
	if [ -n "$argv[1]" ]
		mvim --remote-silent $argv
	else
		mvim --remote-tab-silent .
	end
end
