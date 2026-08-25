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

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          # Avoid starting the lockscreen twice
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
          inhibit_sleep = 3;
        };
        listener = [
          {
            timeout = 300;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 330;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            timeout = 1800;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
  };
}
