{ pkgs, identity, ... }:
{
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  programs.gamemode.enable = true;

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  hardware.graphics.enable32Bit = true;

  # Controller support
  hardware.steam-hardware.enable = true;
  services.udev.packages = with pkgs; [
    game-devices-udev-rules
  ];

  # Stop heavy windows games from crashing
  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;
    "fs.file-max" = 524288;
  };

  home-manager.users.${identity.username} = { pkgs, ... }: {
    home.packages = with pkgs; [
      lutris
      prismlauncher
    ];

    wayland.windowManager.hyprland.settings = {
      windowrulev2 = [
        # Don't sleep while gaming
        "idleinhibit fullscreen, class:^(steam_app_.*)$"
        "idleinhibit fullscreen, class:^(gamescope)$"
      ];
    };
  };
}
