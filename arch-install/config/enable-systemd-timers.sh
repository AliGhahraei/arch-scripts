#!/usr/bin/env bash
INTERFACE="${INTERFACE:-wlo1}"

systemctl enable netctl-auto@$INTERFACE
systemctl --user enable maintenance.timer
systemctl --user enable battery.timer
