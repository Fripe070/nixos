{ pkgs, identity, inputs, ... }:
{
  programs.hyprland = {
    enable = true;
    # Enable the Universal Wayland Session Manager
    withUWSM = true;
  };

  # X compatibility
  programs.xwayland.enable = true;

  home-manager.users.${identity.username} = { pkgs, inputs, ... }: {
    wayland.windowManager.hyprland = {
      enable = true;
      # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
      package = null;
      portalPackage = null;
      # Turn off the built-in systemd integration, since we rely on UWSM
      systemd.enable = false;

      settings = {
        general =  {
          layout = "dwindle";
          resize_on_border = true;
          gaps_out = 3;
          gaps_in = 3;
        };
        dwindle = {
          preserve_split = true; # I want to handle it myself
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
      };
    };
    
    home.sessionVariables = {
      # Hint Electron apps to use Wayland
      NIXOS_OZONE_WL = "1";
    };
  };
}
