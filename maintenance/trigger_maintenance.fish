#!/usr/bin/env fish
set_color green --bold; echo 'Upgrading fish shell...'; set_color normal
fisher self-update
fisher
nix_maintenance
