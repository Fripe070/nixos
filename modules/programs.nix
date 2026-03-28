{ pkgs, identity, inputs, ... }:
{
  home-manager.users.${identity.username} = { pkgs, ... }: {
    home.packages = with pkgs; [
      vscode
      kitty
      firefox
    ];
  };
}