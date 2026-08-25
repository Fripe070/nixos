{ pkgs, identity, inputs, lib, ... }:
let
  theme = "${pkgs.base16-schemes}/share/themes/onedark.yaml";
  inputImage = ./wallpaper.jpg;
in
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix = {
    enable = true;
    autoEnable = true;

    base16Scheme = theme;
    image = inputImage;

    cursor = let 
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
          mkdir -p $out/share/icons/hatsune-miku-cursors
          cp -R miku-cursor-linux/* $out/share/icons/hatsune-miku-cursors/
        '';
      };      
    in {
      package = customCursorPkg;
      name = "hatsune-miku-cursors";
      size = 24;
    }; 

    fonts = {
      serif = {
        package = pkgs.texlivePackages.playfair;
        name = "Playfair Display";
      };
      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
      };
      # => 󱄅
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrains Mono Nerd Font";
      };
      # 😀
      emoji = {
        package = pkgs.twemoji-color-font;
        name = "Twitter Color Emoji";
      };

      sizes = {
        terminal = 14;
      };
    };
  };

  home-manager.users.${identity.username} = { pkgs, inputs, ... }: {
    gtk = {
      enable = true;
      gtk4.theme = null; 
    };
    
    # Fix dolphin
    xdg.configFile."kdeglobals" = {
      enable = true;
      text =
        ''
          [UiSettings]
          ColorScheme=*
        '';
    };

    wayland.windowManager.hyprland.settings = {
      animation = [
        "fade, 0"
        "windows, 1, 1, default, slide"
        "workspaces, 1, 2, default, slidefade"
      ];
    };
  };
}
