# name: Start Docker with Colima
# icon: 🐳
# Runs in the background, as Colima takes a while; it notifies when done.
do shell script quoted form of (POSIX path of (path to home folder) & ".local/bin/colima-notify") & " start > /dev/null 2>&1 &"
