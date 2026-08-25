{ pkgs, identity, ... }:
{
  home-manager.users.${identity.username} = { pkgs, ... }: {
    # Permission granting UI
    services.hyprpolkitagent.enable = true;

    # On Screen Display for audio/brightness, also used for controlling it
    services.swayosd.enable = true;

    # Notifications
    services.swaync.enable = true;

    # Clipboard history
    services.cliphist = {
      enable = true;
      allowImages = true;
    };

    # GUI for Network Manager
    services.network-manager-applet.enable = true;

    home.packages = with pkgs; [
      # Bluetooth UI
      overskride
      # Brightness control
      brightnessctl
      # Audio control 
      pavucontrol
      # Media control (play, pause, etc)
      playerctl
    ];
  };
}
