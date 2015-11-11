#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <sink id/name>" >&2
    echo "Valid sinks:" >&2
    pactl list short sinks >&2
    exit 1
fi

NEW_SINK="$1"

pactl set-default-sink "$NEW_SINK"

pactl list short sink-inputs|while read STREAM; do
    STREAM_ID=$(echo $STREAM|cut '-d ' -f1)
    #echo "moving stream $STREAM_ID"
    pactl move-sink-input "$STREAM_ID" "$NEW_SINK"
done
