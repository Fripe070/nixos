{ lib, pkgs, identity, ... }:

let
  toggleLayout = pkgs.writers.writeNuBin "hypr-toggle-layout" ''
    def main [] {
      let ws = (hyprctl activeworkspace -j | complete)
      if $ws.exit_code != 0 or ($ws.stdout | str trim | is-empty) { return }

      let data = ($ws.stdout | from json)
      let id = $data.id?
      if ($id == null) { return }

      let current = ($data.tiledLayout? | default "")
      let new_layout = if $current == "dwindle" { "scrolling" } else { "dwindle" }

      hyprctl keyword workspace $"($id), layout:($new_layout)"
      notify-send -a "Hyprland" -u low -t 1000 \
        -h boolean:transient:true \
        -h string:x-canonical-private-synchronous:hypr-layout \
        "Layout Switched" $"Workspace ($id) layout set to ($new_layout)"
    }
  '';
  toggleScratchpad = pkgs.writers.writeNuBin "hypr-toggle-scratchpad" ''
    def main [] {
      let mon = (hyprctl monitors -j | from json | filter { |m| ($m.focused? | default false) == true } | get -i 0)
      let is_open = (($mon.specialWorkspace?.name? | default "") | is-not-empty)

      if $is_open {
        hyprctl dispatch togglespecialworkspace
      } else {
        let count = (hyprctl clients -j | from json | filter { |c| $c.workspace?.name? == "special:special" } | length)
        if $count > 0 {
          hyprctl dispatch togglespecialworkspace
        } else {
          notify-send -a "Hyprland" -u low -t 1000 -h boolean:transient:true "Scratchpad" "Scratchpad is empty"
        }
      }
    }
  '';
  toggleWindowScratchpad = pkgs.writers.writeNuBin "hypr-toggle-window-scratchpad" ''
    def main [dir?: string] {
      let win = (hyprctl activewindow -j | complete)
      if $win.exit_code != 0 or ($win.stdout | str trim | is-empty) { return }

      let data = ($win.stdout | from json)
      let ws_name = ($data.workspace?.name? | default "")

      if $ws_name == "special:special" {
        let special_windows = (hyprctl clients -j | from json | filter { |c| $c.workspace?.name? == "special:special" })
        let remaining = ($special_windows | filter { |c| $c.address != $data.address } | length)

        hyprctl dispatch movetoworkspacesilent "e+0"
        if $remaining == 0 {
          hyprctl dispatch togglespecialworkspace
        }
      } else {
        hyprctl dispatch movetoworkspacesilent "special"
        notify-send -a "Hyprland" -u low -t 1000 -h boolean:transient:true "Scratchpad" "Window stashed in scratchpad"
      }
    }
  '';
in
{
  home-manager.users.${identity.username}.wayland.windowManager.hyprland.settings = {
    # https://wiki.hypr.land/Configuring/Binds/
    /*l (locked)	          Will also work when an input inhibitor (e.g. a lockscreen) is active.
      r	(release)           Will trigger on release of a key.
      c	(click)             Will trigger on release of a key or button as long as the mouse cursor stays inside binds:drag_threshold.
      g	(drag)              Will trigger on release of a key or button as long as the mouse cursor moves outside binds:drag_threshold.
      o	(long press)        Will trigger on long press of a key.
      e	(repeat)            Will repeat when held.
      n	(non-consuming)     Key/mouse events will be passed to the active window in addition to triggering the dispatcher.
      m	(mouse)             Rely on mouse movement.
      t	(transparent)       Cannot be shadowed by other binds.
      i	(ignore mods)       Will ignore modifiers.
      s	(separate)          Will arbitrarily combine keys between each mod/key, see Keysym combos.
      d	(has description)   Will allow you to write a description for your bind.
      p	(bypass)            Bypasses the app's requests to inhibit keybinds.
      u	(submap universal)  Will be active no matter the submap.
      k	(per-device)        Allow binds to be set per device.*/

    bindd = [
      "SUPER, SPACE,   Application launcher, exec, uwsm app -- vicinae toggle"
      "SUPER, N,       Notification history, exec, swaync-client --toggle-panel"
      "SUPER, L,       Lock the screen, exec, loginctl lock-session"
      "SUPER SHIFT, L, Switch between dwindle and scrolling layout, exec, ${toggleLayout}/bin/hypr-toggle-layout"

      "SUPER, RETURN,  Terminal, exec, uwsm app -- kitty"
      "SUPER, B,       Browser, exec, uwsm app -- firefox"
      "SUPER SHIFT, B, Private browser, exec, uwsm app -- firefox --private-window"

      ", Print,        Screenshot,       exec, snip screenshot"
      "SHIFT, Print,   Record selection, exec, snip record"
      "SUPER, Escape,  Stop recording,   exec, snip stop"

      "SUPER, W,       Close active window,      killactive,"
      "SUPER SHIFT, W, Force kill active window, forcekillactive,"
      # Window Movement
      "SUPER, J, Toggle window split, layoutmsg, togglesplit"
      "SUPER, K, Swap window split,   layoutmsg, swapsplit"
      "SUPER, T, Toggle window floating/tiling, togglefloating,"
      "SUPER, F, Maximize, fullscreen, 1"
      "SUPER SHIFT, F, Full screen, fullscreen, 0"
      # Move focus with SUPER + arrow keys
      "SUPER, LEFT,   Move window focus left,  movefocus, l"
      "SUPER, RIGHT,  Move window focus right, movefocus, r"
      "SUPER, UP,     Move window focus up,    movefocus, u"
      "SUPER, DOWN,   Move window focus down,  movefocus, d"
      # Swap active window with the one next to it with SUPER + SHIFT + arrow keys
      "SUPER SHIFT, LEFT,  Swap window to the left,  swapwindow, l"
      "SUPER SHIFT, RIGHT, Swap window to the right, swapwindow, r"
      "SUPER SHIFT, UP,    Swap window up,           swapwindow, u"
      "SUPER SHIFT, DOWN,  Swap window down,         swapwindow, d"
      # Resize active window
      "SUPER CTRL, RIGHT, Increase window width,  resizeactive, 100 0"
      "SUPER CTRL, DOWN,  Increase window height, resizeactive, 0 100"
      "SUPER CTRL, LEFT,  Decrease window width,  resizeactive, -100 0"
      "SUPER CTRL, UP,    Decrease window height, resizeactive, 0 -100"

      # Workspaces
      "SUPER, S, Toggle special workspace, exec, ${toggleScratchpad}/bin/hypr-toggle-scratchpad"
      "SUPER CTRL, S, Move window in/out of special workspace, exec, ${toggleWindowScratchpad}/bin/hypr-toggle-window-scratchpad"
    ] ++ lib.concatMap (
      workspace: let
        nr = toString workspace;
        key = if workspace == 10 then "0" else nr;
      in [
        # Switch workspaces with SUPER + [1-9; 0]
        "SUPER, ${key}, Switch to workspace ${nr}, workspace, ${nr}"
        # Move window to a workspace
        "SUPER SHIFT, ${key}, Move window to workspace ${nr}, movetoworkspace, ${nr}"
        # Move window to a workspace without following
        "SUPER CTRL SHIFT, ${key}, Move window silently to workspace ${nr}, movetoworkspacesilent, ${nr}"
      ]
    ) (lib.range 1 10);

    bindm = [
      # Window controls
      "SUPER, mouse:272, movewindow"   # Left mouse
      "SUPER, mouse:273, resizewindow" # Right mouse
      "SUPER ALT, mouse:272, movewindow" # Drag into or out of groups
    ];

    # Repeat while held + works while locked + description
    bindeld = [
      ", XF86AudioRaiseVolume, Increase volume, exec, swayosd-client --output-volume raise"
      ", XF86AudioLowerVolume, Decrease volume, exec, swayosd-client --output-volume lower"

      ", XF86MonBrightnessUp, Increase brightness, exec, swayosd-client --brightness raise"
      ", XF86MonBrightnessDown, Decrease brightness, exec, swayosd-client --brightness lower"
    ];
    # Works while locked + description
    bindld = [
      ", XF86AudioMute, Toggle mute, exec, swayosd-client --output-volume mute-toggle"
      ", XF86AudioMicMute, Toggle microphone mute, exec, swayosd-client --input-volume mute-toggle"

      ", XF86AudioPlay, Play/Pause media, exec, swayosd-client --playerctl play-pause"
      ", XF86AudioPause, Play/Pause media, exec, swayosd-client --playerctl play-pause"
      ", XF86AudioNext, Next track, exec, swayosd-client --playerctl next"
      ", XF86AudioPrev, Previous track, exec, swayosd-client --playerctl prev"
      ", XF86AudioStop, Stop media, exec, swayosd-client --playerctl stop"
    ];

    # format: "fingers, direction, action, options"
    gesture = [
      "3, horizontal, workspace" # 3-finger swipe to switch workspace
    ];
  };
}
