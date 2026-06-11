{ lib, ... }:
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
}