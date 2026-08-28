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

  home-manager.users.${identity.username} = { config, pkgs, inputs, ... }: {
    gtk.enable = true;
    
    # Fix dolphin
    xdg.configFile."kdeglobals" = {
      enable = true;
      text =
        ''
          [UiSettings]
          ColorScheme=*
        '';
    };

    programs.hyprlock.settings = with config.lib.stylix.colors; {
      general = {
        hide_cursor = true;
        immediate_render = true;
      };

      label = [
        {
          text = "$TIME";
          font_size = 96;
          font_family = config.stylix.fonts.monospace.name;
          position = "0, 80";
        }
        {
          text = "cmd[update:1000] date '+%A · %d %B'";
          font_family = config.stylix.fonts.monospace.name;
          position = "0, 0";
        }
      ];

      "input-field" = {
        size = "350, 42";
        position = "0, -50";
        outline_thickness = 1;
        dots_size = 0.4;
        dots_text_format = "*";
        font_family = config.stylix.fonts.monospace.name;
        fade_on_empty = false;
        rounding = 0;
        check_text = "checking...";
        fail_text = "$FAIL - try again";
        capslock_color = "rgb(${base0A})";
        numlock_color = "rgb(${base0B})";
        bothlock_color = "rgb(${base0E})";
      };
    };

    wayland.windowManager.hyprland.settings = {
      animation = [
        "fade, 0"
        "windows, 1, 1, default, slide"
        "workspaces, 1, 2, default, slidefade"
      ];
      decoration = {
        active_opacity = 1.0;
        inactive_opacity = 0.92;
      };
    };

    programs.kitty.settings = {
      cursor_trail = 5;
      cursor_trail_decay = "0.05 0.15";
    };
  };
}
