{ pkgs, inputs, config, identity, ... }:

{
  networking.hostName = "laptop";

  imports = [ ./hardware-configuration.nix ] ++ 
    (map (module: ../../modules/${module}) [
      "common.nix"
      "i18n.nix"
      "fonts.nix"
      "desktop.nix"
      "shortcuts.nix"
      "programs.nix"
      "shell.nix"
    ]);
  # Machine-specific configuration
  home-manager.users.${identity.username} = { pkgs, inputs, ... }: {
    wayland.windowManager.hyprland.settings = {
      monitor = ["eDP-1, 1920x1080@144, 0x0, 1.25"];
    };
  };
}
