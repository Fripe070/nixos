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
}
