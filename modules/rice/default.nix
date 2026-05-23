{ pkgs, identity, inputs, lib, ... }:
let
  theme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
  inputImage = ./wallpaper.jpg;
in
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix = {
    enable = true;
    base16Scheme = theme;
    image = inputImage;
  };

  home-manager.users.${identity.username} = { ... }: {
  };
}