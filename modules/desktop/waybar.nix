{ pkgs, identity, inputs, ... }:
{
  home-manager.users.${identity.username} = { pkgs, inputs, ... }: {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;
          modules-left = [ "hyprland/workspaces" "hyprland/submap" ];
          modules-center = [ "hyprland/window" ];
          modules-right = [ "custom/recorder" "cpu" "memory" "battery" "pulseaudio" "network" "tray" "clock" ];

          "custom/recorder" = {
            format = "🔴 REC";
            interval = 1;
            exec = "pgrep -x wl-screenrec >/dev/null && echo '{\"text\":\"🔴 REC\",\"tooltip\":\"Click to stop recording\",\"class\":\"recording\"}' || echo ''";
            return-type = "json";
            on-click = "snip stop";
          };

          "clock" = {
            format = "{:%T}";
            interval = 1;
            "tooltip-format" = "<big>{:%a w%W %Y}</big>\n<tt>{calendar}</tt>";
            calendar = {
              format = {
                today = "<b><u>{}</u></b>";
                weekday = "<b>{}</b>";
              };
            };
          };
        };
      };
    };
  };
}
