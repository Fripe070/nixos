{ pkgs, identity, inputs, ... }:
{
  home-manager.users.${identity.username} = { pkgs, ... }: {
    home.packages = with pkgs; [
      firefox
      # File manager
      kdePackages.dolphin

      vscode
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

      colorschemes.catppuccin.enable = true;
      plugins.lualine.enable = true;
    };
  };
}
