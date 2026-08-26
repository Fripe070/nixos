{ lib, pkgs, inputs, config, identity, ... }:
{
  networking.hostName = "laptop";

  imports = [ ./hardware-configuration.nix ] ++ 
    (map (module: ../../modules/${module}) [
      "common.nix"
      "i18n.nix"
      "connectivity.nix"
      "audio.nix"
      "desktop"
      "programs.nix"
      "shell.nix"
      "files.nix"
    ]);

  # Machine-specific configuration

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
    HandleLidSwitchDocked = "ignore";
  };
  
  home-manager.users.${identity.username} = { pkgs, inputs, ... }: {
    # Full systemctl suspend on laptop specifically
    services.hypridle.settings.listener = lib.mkAfter [{
      timeout = 1800;
      on-timeout = "systemctl suspend";
    }];

    wayland.windowManager.hyprland.settings = {
      monitor = ["eDP-1, 1920x1080@144, 0x0, 1.25"];
    };
  };
  
  services = {
    tlp.enable = true;
    thermald.enable = true;
  };

  # Patch libfprint with support for the reader on my laptop
  /*nixpkgs.overlays = [
    (final: prev: {
      libfprint = prev.libfprint.overrideAttrs (oldAttrs: {
        # Replace entirely with the PR branch
        src = final.fetchgit {
          url = "https://gitlab.freedesktop.org/libfprint/libfprint.git";
          rev = "refs/merge-requests/554/head";
          hash = "sha256-/DhkBcDe/Jg5MrcK99vvlNHgnKbZd/ikTxZmPqkqAVM="; 
        };
        # no default nixpkgs patches 
        patches = [];
        # no tests 
        doCheck = false;
      });
    })
  ];*/
  services.fprintd.enable = true;
  security.pam.services = {
    sudo.fprintAuth = true;
    ly.fprintAuth = false;
    hyprlock.fprintAuth = false;
  };
}
