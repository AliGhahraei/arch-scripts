#!/usr/bin/env fish
if [ (uname) = "Linux" ]
    set_color green --bold; echo 'Upgrading fisher...'; set_color normal
    fisher update
end
nix_maintenance
