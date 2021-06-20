cd ~/g/scripts

if [ -n "$(git status --porcelain)" ]; then
	UNCLEAN_DIR_MSG="Commit your configs! Workdir was not clean."

	if [[ "$(uname)" == "Darwin" ]]; then
		osascript -e "display notification \"$UNCLEAN_DIR_MSG\""
	else
		notify-send --urgency=critical "$UNCLEAN_DIR_MSG"
	fi
fi

rsync --progress --delete -r -e "ssh -i ~/.ssh/id_rsa" --exclude-from "$(dirname ${BASH_SOURCE[0]})/exclude-list" --delete-excluded "$HOME" root@ali:~/backup/

if [[ "$(uname)" == "Darwin" ]]; then
	osascript -e 'display notification "Backup finished"'
else
	notify-send "Backup finished" -t 0
fi
