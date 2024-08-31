killall -q waybar
while pgrep -u $UID -x waybar >/dev/null; do sleep 1; done

if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m waybar &
  done
else
  waybar &
fi
