{ pkgs, identity, inputs, ... }:

{
  programs.hyprland = {
    enable = true;

    withUWSM = true;
  };

  home-manager.users.${identity.username} = { pkgs, ... }: {
    wayland.windowManager.hyprland = {
      enable = true;
      # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
      package = null;
      portalPackage = null;
      # Becuase UWSM https://wiki.hypr.land/Useful-Utilities/Systemd-start/#installation
      systemd.enable = false;

      settings = {
        # TODO: Configure...
      };
    };
  };
}