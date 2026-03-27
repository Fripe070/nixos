{ pkgs, identity, inputs, ... }:

{
  programs.hyprland = {
    enable = true;
    # Enable the Universal Wayland Session Manager
    withUWSM = true;
  };
  programs.xwayland.enable = true;

  # Login manager
  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "gameoflife";
    };
  };

  home-manager.users.${identity.username} = { pkgs, ... }: {
    wayland.windowManager.hyprland = {
      enable = true;
      # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
      package = null;
      portalPackage = null;
      # Turn off the built-in systemd integration, since we reply on UWSM
      systemd.enable = false;

      settings = {
        "$mod" = "SUPER";
        # TODO: Configure...
        general =  {
          resize_on_border = true;
          gap_out = 5;
          gap_in = 3;
        };
        bind = [
          "$mod, Q, killactive,"
          "$mod, T, exec, kitty"
          "$mod SHIFT, E, exec, uwsm stop"
          "$mod, L, exec, hyprlock --immediate"
        ];
        exec-once = [
        ];
      };
    };
    home.sessionVariables = {
      # Hint Electron apps to use Wayland
      NIXOS_OZONE_WL = "1";
    };
    # nako for notifications
    services.mako = {
      enable = true;
    };
    
    programs.waybar = {
      enable = true;
      settings.main = {
        modules-left = [
          "hyprland/workspaces"
          "cpu"
          "memory"
        ];
      };
    };

    # hyprlock for screen locking (we need both this and ly because yes)
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          hide_cursor = true;
        };

        background = {
          path = "screenshot";
          blur_passes = 2;
          blur_size = 5;
        };

        label = {
          text = "cmd[update:1000] date +%-I:%M";
          font_size = 100;
          font_family = "JetBrains Mono Extrabold";
          position = "0, 200";
          halign = "center";
          valign = "center";
        };
      };
    };
  };
}