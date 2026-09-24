{ pkgs, identity, inputs, ... }:
{
  home-manager.users.${identity.username} = { pkgs, inputs, ... }: {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      style = builtins.readFile ./style.css;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 34;
          spacing = 0;

          modules-left = [
            "clock"
            "custom/notification"
            "network"
            "bluetooth"
            "tray"
            "idle_inhibitor"
          ];
          modules-center = [
            "hyprland/workspaces"
          ];
          modules-right = [
            "custom/recorder"
            "privacy"
            "pulseaudio"
            "battery"
            "cpu"
            "memory"
            "disk"
          ];

          "clock" = {
            format = "{:%H:%M:%S}";
            interval = 1;
            tooltip-format = "{:%A, %d %B %Y}";
          };

          "custom/notification" = {
            format = "{icon}";
            format-icons = {
              notification                = "󱅫";
              none                        = "󰂚";
              dnd-notification            = "󱅫";
              dnd-none                    = "󰂛";
              inhibited-notification      = "󱅫";
              inhibited-none              = "󰂚";
              dnd-inhibited-notification  = "󱅫";
              dnd-inhibited-none          = "󰂛";
            };
            tooltip = false;

            exec-if = "which swaync-client";
            exec = "swaync-client -swb";
            return-type = "json";
            escape = true;
            on-click = "swaync-client -t -sw";
            on-click-right = "swaync-client -d -sw"; # dnd
          };

          "network" = {
            format-icons = ["󰤯 " "󰤟 " "󰤢 " "󰤥 " "󰤨 "];
            format-wifi     = "{essid:.10} {icon}";
            format-ethernet = "{ipaddr} 󰈀 ";
            format-linked   = "No IP 󰈀 ";
            format-disconnected = "󰀝 ";

            tooltip-format-wifi = "SSID: {essid} ({icon}{signalStrength}%) {frequency}GHz\nIP: {ipaddr}\nGateway: {gwaddr}";
            tooltip-format-ethernet = "Ethernet: {ifname}\nIP: {ipaddr}\nGateway: {gwaddr}";
            tooltip-format-disconnected = "Network disconnected";

            on-click = "uwsm app -t service -- kitty -e nmtui";
          };

          "bluetooth" = {
            format = "󰂯";
            format-disabled = "󰂲";
            format-connected         = "󰂱 {device_alias:.10}";
            format-connected-battery = "󰂱 {device_alias:.10} {icon}{device_battery_percentage}%";
            format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];

            tooltip-format = "{controller_alias}\t{controller_address}\n{num_connections} connected";
            tooltip-format-connected = "{controller_alias}\t{controller_address}\n{num_connections} connected\n\n{device_enumerate}";
            tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
            tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{icon} {device_battery_percentage}%";

            on-click = "uwsm app -t service -- overskride";
          };

          "tray" = {
            icon-size = 15;
            spacing = 8;
          };

          "idle_inhibitor" = {
            format = "{icon}";
            format-icons = {
              activated = "󰅶";
              deactivated = "󰾪";
            };
            tooltip = true;
            tooltip-format-activated = "Idle inhibitor: active (screen kept awake)";
            tooltip-format-deactivated = "Idle inhibitor: inactive";
          };


          "hyprland/workspaces" = {
            persistent-workspaces = {
              "*" = 5;
            };
            show-special = true;
            special-visible-only = true;
          };


          "custom/recorder" = {
            format = "{}";
            exec-if = "pgrep -x wl-screenrec";
            exec = ''
              echo '{"text": "󰑋 REC","tooltip":"Recording in progress\nClick to stop"}'
            '';
            return-type = "json";
            interval = 1;
            on-click = "snip stop";
          };

          "privacy" = {
            icon-spacing = 6;
            icon-size = 0; # auto
            modules = [
              { type = "screenshare"; }
              #{ type = "audio-out"; }
              { type = "audio-in"; }
              { type = "location"; }
            ];
          };

          "pulseaudio" = {
            format = "{icon}{volume}%";
            format-icons = {
              default = [ " " " " " " "  " ];
              default-muted = " ";
              headphone = "󰋋 ";
              headphone-muted = "󰟎 ";
              headset = "󰋋 ";
              headset-muted = "󰟎 ";
            };
            tooltip-format = "{desc} ({volume}%)";
            on-click = "uwsm app -t service -- pavucontrol";
            on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            reverse-scrolling = true;
          };

          "battery" = {
            states = {
              good = 80;
              warning = 30;
              critical = 15;
            };
            format = "{icon} {capacity}%";
            format-charging = "󰂄 {capacity}%";
            format-plugged = "󰚥 {capacity}%";
            format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
            tooltip-format = "{timeTo} ({capacity}%)\nHealth: {health}%";
          };

          "cpu" = {
            interval = 5;
            states = {
              warning = 60;
              critical = 90;
            };
            format = " {usage}%";
            tooltip = true;
            on-click = "uwsm app -t service -- kitty -e btop";
          };

          "memory" = {
            interval = 5;
            states = {
              warning = 60;
              critical = 90;
            };
            format = " {used:0.1f}G";
            tooltip-format = "RAM: {used:0.1f}GiB / {total:0.1f}GiB ({percentage}%)\nSwap: {swapUsed:0.1f}GiB / {swapTotal:0.1f}GiB";
            on-click = "uwsm app -t service -- kitty -e btop";
          };

          "disk" = {
            format = " {percentage_used}%";
          };
        };
      };
    };
  };
}
