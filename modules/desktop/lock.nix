{ lib, identity, ... }:
{
  services.displayManager.ly = {
    enable = true;
    settings = {
      tty = lib.mkForce 7;
      bigclock = true;
      blank_password = true;
      hide_borders = true;
    };
  };
  # Prevent The kernel from printing into ly
  boot.kernelParams = [ "console=tty1"];

  home-manager.users.${identity.username} = { pkgs, inputs, ... }: {
    # Screen locking (this and my display manager can't be the same because... linux)
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          hide_cursor = true;
        };
      };
    };
  };
}