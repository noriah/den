#!/usr/bin/env bash

kill $(ps aux | grep /usr/lib/budgie-previews | grep -v grep | awk '{print $2}')

systemctl --user start budgie-previews-creator.service budgie-previews-daemon.service
