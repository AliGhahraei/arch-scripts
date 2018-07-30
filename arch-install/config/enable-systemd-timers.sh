sudo wifi-menu
systemctl enable netctl-auto@wlp2s0
systemctl --user enable maintenance.timer
systemctl --user enable battery.timer
