#!/usr/bin/env bash
set -euo pipefail

open_file_manager() {
  local target="$1"
  if command -v dolphin >/dev/null 2>&1; then
    dolphin --select "$target"
  elif command -v busctl >/dev/null 2>&1; then
    busctl --user call org.freedesktop.FileManager1 /org/freedesktop/FileManager1 \
      org.freedesktop.FileManager1 ShowItems as 1 "file://$target" s ""
  else
    xdg-open "$(dirname "$target")"
  fi
}

handle_saved() {
  local target="$1"
  local kind="$2"
  local actions=(-A "default=Open" -A "folder=Show in folder")
  local app_name icon title

  if [ "$kind" = "screenshot" ]; then
    app_name="Snipping Tool"
    icon="$target"
    title="Screenshot copied"
    actions+=(-A "edit=Annotate")
  else
    app_name="Screen Recorder"
    icon="video-x-generic"
    title="Recording saved & copied"
  fi

  local action
  action=$(notify-send -t 5000 -a "$app_name" -i "$icon" "${actions[@]}" \
    "$title" "$(basename "$target")" || true)

  case "$action" in
    default) xdg-open "$target" ;;
    folder)  open_file_manager "$target" ;;
    edit)    satty --filename "$target" ;;
  esac
}

capture_screenshot() {
  local dir="${XDG_PICTURES_DIR:-$HOME/Pictures}/Screenshots"
  local file
  file="$dir/screenshot-$(date +%Y%m%d-%H%M%S).png"
  mkdir -p "$dir"

  grimblast --freeze save area "$file" || exit 0
  [ -f "$file" ] || exit 0

  wl-copy --type image/png < "$file"
  handle_saved "$file" "screenshot"
}

toggle_recording() {
  if pkill --signal SIGINT -x wl-screenrec; then
    exit 0
  fi

  local dir="${XDG_VIDEOS_DIR:-$HOME/Videos}/Recordings"
  local output
  output="$dir/recording-$(date +%Y%m%d-%H%M%S).mp4"
  mkdir -p "$dir"

  local rects geom
  rects=$(hyprctl clients -j | jq -r '.[] | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' 2>/dev/null || true)
  if [ -n "$rects" ]; then
    geom=$(echo "$rects" | slurp -o) || exit 0
  else
    geom=$(slurp -o) || exit 0
  fi

  notify-send -t 2500 -a "Screen Recorder" -i media-record \
    "Recording started" "Selected area. Press Super+Shift+R or click status bar to stop."
  wl-screenrec -g "$geom" -f "$output" || true

  if [ -f "$output" ]; then
    wl-copy -t text/uri-list "file://$output"
    handle_saved "$output" "record"
  fi
}

stop_recording() {
  pkill --signal SIGINT -x wl-screenrec || true
}

case "${1:-screenshot}" in
  screenshot|screen|image) capture_screenshot ;;
  record|rec|video)        toggle_recording ;;
  stop)                    stop_recording ;;
  *)
    echo "Usage: snip [screenshot|record|stop]" >&2
    exit 1
    ;;
esac
