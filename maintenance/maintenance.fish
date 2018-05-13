#!/usr/bin/env fish
set_color green; echo 'Upgrading fish shell...'; set_color normal
fisher up
python3 (dirname (status -f))/maintenance.py
