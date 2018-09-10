#!/bin/bash

BATTERY_LIMIT="11"
BATTERY_PATH="/sys/class/power_supply/BAT1/"

BATTERY_STATE=$(cat $BATTERY_PATH/status)
if [ "$BATTERY_STATE" == "Discharging" ]; then
   BATTERY_CHARGE=$(cat $BATTERY_PATH/capacity)
   if [ "$BATTERY_CHARGE" -lt "$BATTERY_LIMIT" ]; then
      notify-send --urgency=critical "La pila ya fue ($BATTERY_CHARGE%)" "Corre, ganapán"
   fi
fi
