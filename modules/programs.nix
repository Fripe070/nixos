{ pkgs, identity, inputs, ... }:
{
  home-manager.users.${identity.username} = { pkgs, ... }: {
    home.packages = with pkgs; [
      vscode
      firefox
      # File manager
      kdePackages.dolphin
    ];

    programs.kitty = {
      enable = true;
      settings = {
        confirm_os_window_close = 0;
      };
    };
  };
}
