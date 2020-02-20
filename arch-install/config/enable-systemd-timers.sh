#!/usr/bin/env bash
INTERFACE="${INTERFACE:-wlo1}"

sudo wifi-menu
systemctl enable netctl-auto@$INTERFACE
systemctl --user enable maintenance.timer
systemctl --user enable battery.timer
