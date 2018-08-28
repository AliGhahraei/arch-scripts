#!/usr/bin/env fish
set_color green --bold; echo 'Upgrading fish shell...'; set_color normal
fisher up --quiet
python3 (dirname (status -f))/maintenance.py
