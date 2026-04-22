{ pkgs, inputs, config, identity, ... }:

{
  networking.hostName = "laptop";

  imports = [
    ../hardware-configuration.nix
    ../modules/common.nix
    ../modules/i18n.nix
    ../modules/fonts.nix
    ../modules/desktop.nix
    ../modules/shortcuts.nix
    ../modules/programs.nix
    ../modules/shell.nix
  ];
  # Machine-specific configuration
  home-manager.users.${identity.username} = { pkgs, inputs, ... }: {
    wayland.windowManager.hyprland.settings = {
      monitor = ["eDP-1, 1920x1080@144, 0x0, 1.25"];
    };
  };
}
