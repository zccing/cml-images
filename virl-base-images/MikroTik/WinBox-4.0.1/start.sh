#!/bin/bash
set -eu

case "${WAIT:-}" in
    ''|*[!0-9]*) ;;
    *) [ "${WAIT}" -gt 0 ] && sleep "${WAIT}" ;;
esac

export DBUS_SESSION_BUS_ADDRESS="unix:path=${HOME}/.dbus-socket"
rm -f "${HOME}/.dbus-socket"

dbus-daemon --nosyslog --fork --session --address="${DBUS_SESSION_BUS_ADDRESS}"

/usr/bin/i3 >/tmp/i3.log 2>&1 &

cd "${HOME}"

set --
[ -n "${WINBOX_TARGET:-}" ] && set -- "$@" "${WINBOX_TARGET}"
[ -n "${WINBOX_USER:-}" ] && set -- "$@" "${WINBOX_USER}"
[ -n "${WINBOX_PASS:-}" ] && set -- "$@" "${WINBOX_PASS}"
[ -n "${WINBOX_WORKSPACE:-}" ] && set -- "$@" "${WINBOX_WORKSPACE}"

/opt/winbox/WinBox "$@" >"${HOME}/winbox.log" 2>&1 &
pid="$!"

while ! xdotool search --name "WinBox" >/dev/null 2>&1; do
    if ! kill -0 "$pid" 2>/dev/null; then
        echo "WinBox exited early, see ${HOME}/winbox.log" >&2
        wait "$pid"
    fi
    sleep 1
done

echo "READY" >/dev/console || true
sleep 1
i3-msg fullscreen >/dev/null 2>&1 || true

wait "$pid"