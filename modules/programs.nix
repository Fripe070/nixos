{ pkgs, identity, inputs, ... }:
{
  home-manager.users.${identity.username} = { pkgs, ... }: {
    home.packages = with pkgs; [
      firefox
      # File manager
      kdePackages.dolphin

      vscode
      inputs.nixvim.packages.x86_64-linux.default
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
  };
}
