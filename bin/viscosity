#!/usr/bin/env bash
# Usage: viscosity [command] [vpn]
#
# Connect/disconnect from a VPN using Viscosity.app on OS X.
#
# Help:
#   viscosity connect               Connect to all VPNs
#   viscosity connect "My VPN"      Connect to the VPN named "My VPN"
#   viscosity disconnect            Disconnect from all VPNs
#   viscosity disconnect "My VPN"   Disconnect from the VPN named "My VPN"
#   viscosity status                Show connection status for all VPNs
#   viscosity status "My VPN"       Show connection status of the VPN named "My VPN"
#   viscosity help                  Show this help message

[[ "${DEBUG}" ]] && set -x

case "${1}" in
  ""|-h|--help|help)
    sed -ne '/^#/!q;s/.\{1,2\}//;1d;p' < "${0}"
    exit
    ;;
  connect|disconnect)
    if [[ -z "${2}" ]]; then
      osascript -e "tell application \"Viscosity\" to ${1}all"
    else
      osascript -e "tell application \"Viscosity\" to ${1} \"${2}\""
    fi
    ;;
  status)
    if [[ "${2}" ]]; then
      osascript -e "tell application \"Viscosity\" to return state of (connections where name is \"${2}\")"
    else
      osascript -e '
        tell application "Viscosity"
          set output to ""
          set i to 0
          repeat with _conn in connections
            set i to i + 1
            set _vpn to name of _conn
            set _state to state of _conn
            set output to output & _vpn & ": " & _state
            if i < count of connections
              set output to output & "\n"
            end if
          end repeat
          output
        end tell
      '
    fi
    ;;
  *)
    echo "Invalid command ${1}"
    exit 1
    ;;
esac
