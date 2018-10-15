#!/usr/bin/env fish
set_color green --bold; echo 'Upgrading fish shell...'; set_color normal
fisher self-update
fisher
python3 (dirname (status -f))/maintenance.py
