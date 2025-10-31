{ pkgs, identity, inputs, ... }:

{
  programs.waybar.enable = true;

  home-manager.users.${identity.username} = { pkgs, ... }: {
    programs.waybar.settings.main = {
    };
  };
}