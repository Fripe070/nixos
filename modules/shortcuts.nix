{ identity, ... }:
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
      "SUPER, W,       Close active window, killactive,"
      "SUPER SHIFT, W, Force kill active window, forcekillactive,"
      "SUPER, L,       Lock the screen, exec, hyprlock"
      "SUPER, SPACE,   Application launcher, exec, uwsm app -- vicinae toggle"
      "SUPER, RETURN,  Terminal, exec, uwsm app -- kitty"
      "SUPER, B,       Browser, exec, uwsm app -- firefox"
      "SUPER SHIFT, B, Private browser, exec, uwsm app -- firefox --private-window"

      # Most of the below is copied from omarchy
      
      # Window management
      "SUPER, J, Toggle window split, layoutmsg, togglesplit"
      "SUPER, K, Swap window split, layoutmsg, swapsplit"
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
      # Switch workspaces with SUPER + [1-9; 0]
      "SUPER, 1, Switch to workspace 1, workspace, 1"
      "SUPER, 2, Switch to workspace 2, workspace, 2"
      "SUPER, 3, Switch to workspace 3, workspace, 3"
      "SUPER, 4, Switch to workspace 4, workspace, 4"
      "SUPER, 5, Switch to workspace 5, workspace, 5"
      "SUPER, 6, Switch to workspace 6, workspace, 6"
      "SUPER, 7, Switch to workspace 7, workspace, 7"
      "SUPER, 8, Switch to workspace 8, workspace, 8"
      "SUPER, 9, Switch to workspace 9, workspace, 9"
      "SUPER, 0, Switch to workspace 10, workspace, 10"
      # Move window to a workspace with SUPER + SHIFT + [1-9; 0]
      "SUPER SHIFT, 1, Move window to workspace 1, movetoworkspace, 1"
      "SUPER SHIFT, 2, Move window to workspace 2, movetoworkspace, 2"
      "SUPER SHIFT, 3, Move window to workspace 3, movetoworkspace, 3"
      "SUPER SHIFT, 4, Move window to workspace 4, movetoworkspace, 4"
      "SUPER SHIFT, 5, Move window to workspace 5, movetoworkspace, 5"
      "SUPER SHIFT, 6, Move window to workspace 6, movetoworkspace, 6"
      "SUPER SHIFT, 7, Move window to workspace 7, movetoworkspace, 7"
      "SUPER SHIFT, 8, Move window to workspace 8, movetoworkspace, 8"
      "SUPER SHIFT, 9, Move window to workspace 9, movetoworkspace, 9"
      "SUPER SHIFT, 0, Move window to workspace 10, movetoworkspace, 10"
      # Move window to a workspace without switching to it
      "SUPER CTRL SHIFT, 1, Move window silently to workspace 1, movetoworkspacesilent, 1"
      "SUPER CTRL SHIFT, 2, Move window silently to workspace 2, movetoworkspacesilent, 2"
      "SUPER CTRL SHIFT, 3, Move window silently to workspace 3, movetoworkspacesilent, 3"
      "SUPER CTRL SHIFT, 4, Move window silently to workspace 4, movetoworkspacesilent, 4"
      "SUPER CTRL SHIFT, 5, Move window silently to workspace 5, movetoworkspacesilent, 5"
      "SUPER CTRL SHIFT, 6, Move window silently to workspace 6, movetoworkspacesilent, 6"
      "SUPER CTRL SHIFT, 7, Move window silently to workspace 7, movetoworkspacesilent, 7"
      "SUPER CTRL SHIFT, 8, Move window silently to workspace 8, movetoworkspacesilent, 8"
      "SUPER CTRL SHIFT, 9, Move window silently to workspace 9, movetoworkspacesilent, 9"
      "SUPER CTRL SHIFT, 0, Move window silently to workspace 10, movetoworkspacesilent, 10"
    ];

    bindm = [
      "SUPER, mouse:272, movewindow"   # Left mouse
      "SUPER, mouse:273, resizewindow" # Right mouse
    ];

    # format: "fingers, direction, action, options"
    gesture = [
      "3, horizontal, workspace" # 3-finger swipe to switch workspace
    ];
  };
}
