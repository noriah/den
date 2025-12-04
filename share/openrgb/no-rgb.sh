#!/usr/bin/env sh

OPENRGB=/usr/bin/openrgb

NUM_DEVICES=$(${OPENRGB} --client 127.0.0.1:6742 --list-devices | grep -E '^[0-9]+: ' | wc -l)

for i in $(seq 0 $(($NUM_DEVICES - 1))); do
  ${OPENRGB} --client 127.0.0.1:6742 --device $i --mode static --color 000000
done
