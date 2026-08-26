{ lib, identity, ... }:
{
  # I use hyprland, and thus also 
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

      "SUPER, RETURN,  Terminal, exec, uwsm app -- kitty"
      "SUPER, B,       Browser, exec, uwsm app -- firefox"
      "SUPER SHIFT, B, Private browser, exec, uwsm app -- firefox --private-window"

      # A lot of the below is copied from omarchy
      
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
      "SUPER ALT, RIGHT, Increase window width,  resizeactive, 100 0"
      "SUPER ALT, DOWN,  Increase window height, resizeactive, 0 100"
      "SUPER ALT, LEFT,  Decrease window width,  resizeactive, -100 0"
      "SUPER ALT, UP,    Decrease window height, resizeactive, 0 -100"

      # Workspaces
      # TAB between workspaces
      "SUPER, TAB,       Next workspace,     workspace, e+1"
      "SUPER SHIFT, TAB, Previous workspace, workspace, e-1"
    ] ++ lib.concatMap (
      workspace:
      let
        nr = toString workspace;
        key = if workspace == 10 then "0" else nr;
      in
      [
        # Switch workspaces with SUPER + [1-9; 0]
        "SUPER, ${key}, Switch to workspace ${nr}, workspace, ${nr}"
        # Move window to a workspace with SUPER + SHIFT + [1-9; 0]
        "SUPER SHIFT, ${key}, Move window to workspace ${nr}, movetoworkspace, ${nr}"
        # Move window to a workspace without switching to it
        "SUPER CTRL SHIFT, ${key}, Move window silently to workspace ${nr}, movetoworkspacesilent, ${nr}"
      ]
    ) (lib.range 1 10);

    bindm = [
      # Window controls
      "SUPER, mouse:272, movewindow"   # Left mouse
      "SUPER, mouse:273, resizewindow" # Right mouse
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
    ];

    # format: "fingers, direction, action, options"
    gesture = [
      "3, horizontal, workspace" # 3-finger swipe to switch workspace
    ];
  };
}
