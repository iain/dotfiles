# name: Restart Pitchfork
# icon: 🔁
# Like the pfr abbreviation: for when https://*.localhost stops answering.
do shell script "launchctl kickstart -k gui/$(id -u)/dev.mise.pitchfork"
display notification "Pitchfork restarted" with title "Pitchfork"
