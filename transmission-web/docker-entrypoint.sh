#!/bin/sh

if ${AUTH}; then
    transmission-daemon --auth --foreground --username ${LOGIN} --password ${PASSWORD} --port ${PORT} --allowed "${ALLOWED}"
else
    transmission-daemon --foreground --port ${PORT} --allowed "${ALLOWED}"
fi

