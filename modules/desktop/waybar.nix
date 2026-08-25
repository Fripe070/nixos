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
          modules-right = [ "cpu" "memory" "battery" "pulseaudio" "network" "tray" "clock" ];

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
