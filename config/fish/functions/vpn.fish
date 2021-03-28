function vpn
	echo "Connecting to '$argv[1]' profile in Tunnelblick, this might take a while"
	osascript -e 'tell application "Tunnelblick"' -e 'disconnect all' -e 'end tell' > /dev/null
	osascript -e 'tell application "Tunnelblick"' -e 'connect "'"$argv[1]"'"' -e 'end tell' > /dev/null
end
