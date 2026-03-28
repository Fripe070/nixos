{ pkgs, identity, inputs, ... }:
{
  programs.hyprland = {
    enable = true;
    # Enable the Universal Wayland Session Manager
    withUWSM = true;
  };
  programs.xwayland.enable = true;

  home-manager.users.${identity.username} = { pkgs, inputs, ... }: {
    wayland.windowManager.hyprland = {
      enable = true;
      # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
      package = null;
      portalPackage = null;
      # Turn off the built-in systemd integration, since we reply on UWSM
      systemd.enable = false;

      settings = {
        "$mod" = "SUPER";
        bind = [
          # Close the current window
          "$mod, Q, killactive,"
          # Open the terminal
          "$mod, T, exec, kitty"
          # Open the launcher
          "$mod, SPACE, exec, uwsm app -- vicinae toggle"
          # Locks the screen
          "$mod, L, exec, hyprlock --immediate"
          # Stops the session
          "$mod SHIFT, E, exec, uwsm stop"
        ];

        general =  {
          resize_on_border = true;
          gaps_out = 3;
          gaps_in = 3;
        };
        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };

        exec-once = [
          "waybar"
        ];
        
        xwayland = {
          # Solves some issues of applications being low reselution
          force_zero_scaling = true;
        };
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

      imports = [
        inputs.vicinae.homeManagerModules.default
      ];
      services.vicinae = {
      enable = true;
      systemd = {
        enable = true;
        autoStart = true;
        environment = {
          USE_LAYER_SHELL = 1;
        };
      };
    };
  };
}