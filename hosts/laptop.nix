{ pkgs, inputs, config, identity, ... }:

{
  networking.hostName = "laptop";

  imports = [
    ../hardware-configuration.nix
    ../modules/common.nix
    ../modules/i18n.nix
    ../modules/hyprland.nix
    ../modules/waybar.nix
  ];

  home-manager.users.${identity.username} = { pkgs, ... }: {
    home.packages = with pkgs; [
      git
      vscode
      kitty
      firefox
    ];
  };
}
