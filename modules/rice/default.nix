{ pkgs, identity, inputs, lib, ... }:
let
  theme = "${pkgs.base16-schemes}/share/themes/onedark.yaml";
  inputImage = ./wallpaper.jpg;
in
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix = {
    enable = true;
    base16Scheme = theme;
    image = inputImage;
  };

  home-manager.users.${identity.username} = { pkgs, inputs, ... }: {
    gtk = {
      enable = true;
      gtk4.theme = null; 
    };

    home.pointerCursor = let 
      customCursorPkg = pkgs.stdenvNoCC.mkDerivation rec {
        pname = "hatsune-miku-cursors";
        version = "1.2.6";
        src = pkgs.fetchFromGitHub {
          owner = "supermariofps";
          repo = "hatsune-miku-windows-linux-cursors";
          rev = version;
          hash = "sha256-OQjjOc9VnxJ7tWNmpHIMzNWX6WsavAOkgPwK1XAMwtE=";
        };
        installPhase = ''
          mkdir -p $out/share/icons/miku-cursor-linux
          cp -R miku-cursor-linux/* $out/share/icons/miku-cursor-linux/
        '';
      };      
    in {
      enable = true;
      package = customCursorPkg;
      name = "miku-cursor-linux";
      size = 24;

      hyprcursor.enable = true; 
      gtk.enable = true; 
      x11.enable = true; 
    };
  };
}
