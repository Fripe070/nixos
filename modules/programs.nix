{ pkgs, identity, inputs, ... }:
{
  home-manager.users.${identity.username} = { config, pkgs, ... }: {
    imports =  [ inputs.nixvim.homeModules.default ];

    home.packages = with pkgs; [
      firefox
      vscode
      zed

      kdePackages.dolphin # file manager
      kdePackages.ark     # archive manager

      loupe               # image viewer
      vlc                 # video/media viewer

      gimp                # image editor
      krita               # other image editor
      inkscape            # vector graphics

      yt-dlp
    ];
    
    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "code";
      TERMINAL = "kitty";
    };

    programs.kitty = {
      enable = true;
      settings = {
        confirm_os_window_close = 0;
      };
    };

    programs.nixvim = {
      enable = true;

      opts = {
        number = true;
        relativenumber = true;
      };

      plugins = {
        treesitter = {
          enable = true;
          grammarPackages = with config.programs.nixvim.plugins.treesitter.package.passthru.builtGrammars; [
            nix
            markdown
            markdown_inline
            json
            regex
            asm
          ];
          settings = {
            highlight.enable = true;
            indent.enable = true;
          };
        };
      };
    };
  };
}
