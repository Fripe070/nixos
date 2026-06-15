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
        general =  {
          layout = "dwindle";
          resize_on_border = true;
          gaps_out = 3;
          gaps_in = 3;
        };
        dwindle = {
          preserve_split = true; # I want to ahndle it myself
        };
        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };
        # Scrolling for people who aren't freaks
        input.touchpad.natural_scroll = true;
        
        xwayland = {
          # Solves some issues of applications being low resolution
          force_zero_scaling = true;
        };

        animation = [
          "fade, 0"
          "windows, 1, 1, default, slide"
          "workspaces, 1, 2, default, slidefade"
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
    
    # Enable the Hyprland Polkit Agent for handling authentication
    services.hyprpolkitagent.enable = true;
    
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;
          modules-left = [ "hyprland/workspaces" "hyprland/submap" ];
          modules-center = [ "hyprland/window" ];
          modules-right = [ "cpu" "memory" "battery" "pulseaudio" "network" "tray" "clock" ];

          "clock" = {
            format = "{:%T}";
            interval = 1;
            "tooltip-format" = "<big>{:%a w%W %Y}</big>\n<tt>{calendar}</tt>";
            calendar = {
              format = {
                today = "<b><u>{}</u></b>";
                weekday = "<b>{}</b>";
              };
            };
          };
        };
      };
    };

    # hyprlock for screen locking (we need both this and ly because yes)
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          hide_cursor = true;
        };
      };
    };

    imports =  [inputs.vicinae.homeManagerModules.default ];
    services.vicinae = {
      enable = true;
      package = inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.default;
      systemd = {
        enable = true;
        autoStart = true;
        environment = {
          USE_LAYER_SHELL = 1;
        };
      };
      settings = {
        close_on_focus_loss = true;
        pop_to_root_on_close = true;
        telemetry.system_info = false;
        launcher_window = {
          layer_shell = {
            enabled = true;
            keyboard_interactivity = "on_demand";
            layer = "top";
          };
        };
      };
    };
  };
}
