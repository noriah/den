#!/usr/bin/env bash

# because pipewire/wireplumber/budgie combo seems to break my audio time re-log

sleep 4; # kill me

# wpctl set-default $(wpctl status | grep "System Output" | sed 's/*//' | awk '{print $2}' | cut -d. -f1)
# wpctl set-default $(wpctl status | grep "Main System Mic" | sed 's/*//' | awk '{print $2}' | cut -d. -f1)

pactl set-default-source system_source
pactl set-default-sink system_sink
