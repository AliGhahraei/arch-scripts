# Version Control
VC="$HOME/g/scripts/config-files"
EMACS_VC="$VC/emacs"

EMACS_DEST="$HOME/.emacs.d/"
EMACS_CONFIG_DEST="$EMACS_DEST/config/"

mkdir -p $EMACS_CONFIG_DEST

ln -sf $EMACS_VC/init.el $EMACS_DEST
ln -sf $EMACS_VC/packages.el $EMACS_CONFIG_DEST
ln -sf $EMACS_VC/base.el $EMACS_CONFIG_DEST

ln -sf $VC/.bash_profile $HOME
ln -sf $VC/.bashrc $HOME
ln -sf $VC/.zprofile $HOME
ln -sf $VC/.zshrc $HOME
ln -sf $VC/.zsh_plugins $HOME
ln -sf $VC/.profile $HOME

ln -sf $VC/.taskrc $HOME

if [[ "$(uname)" == "Linux" ]]; then
	XORG_CONF=/etc/X11/xorg.conf.d/
	XMONAD="$HOME/.xmonad/"
	DUNST="$HOME/.config/dunst/"

	mkdir -p $XMONAD
	mkdir -p $DUNST

	sudo ln -sf $VC/70-synaptics.conf $XORG_CONF
	ln -sf $VC/xmonad.hs $XMONAD
	ln -sf $VC/dunstrc $DUNST
	ln -sf $VC/.xinitrc $HOME
	ln -sf $VC/.Xresources $HOME
	ln -sf $VC/.asoundrc $HOME
fi
