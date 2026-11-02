{ lib, pkgs, identity, ... }:

{
  home-manager.users.${identity.username} = {
    home.packages = [
      pkgs.hyprpicker
    ];

    wayland.windowManager.hyprland.extraLuaFiles.binds = ./hyprland/binds.lua;
  };
}
