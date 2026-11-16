# name: Stop Docker with Colima
# icon: 🛑
# Runs in the background, as Colima takes a while; it notifies when done.
do shell script quoted form of (POSIX path of (path to home folder) & ".local/bin/colima-notify") & " stop > /dev/null 2>&1 &"
