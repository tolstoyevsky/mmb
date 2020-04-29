#!/bin/sh

ALLOWED=${ALLOWED:="192.168.*.*"}

AUTH=${AUTH:=true}

LOGIN=${LOGIN:="cusdeb"}

PASSWORD=${PASSWORD:="cusdeb"}

PORT=${PORT:=8003}

if ${AUTH}; then
    transmission-daemon --auth --foreground --username ${LOGIN} --password ${PASSWORD} --port ${PORT} --allowed "${ALLOWED}"
else
    transmission-daemon --foreground --port ${PORT} --allowed "${ALLOWED}"
fi

