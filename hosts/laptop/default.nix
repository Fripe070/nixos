{ pkgs, inputs, config, identity, ... }:

{
  networking.hostName = "laptop";

  imports = [ ./hardware-configuration.nix ] ++ 
    (map (module: ../../modules/${module}) [
      "common.nix"
      "i18n.nix"
      "fonts.nix"
      "desktop.nix"
      "shortcuts.nix"
      "programs.nix"
      "shell.nix"
      "login.nix"
      "rice"
    ]);
  # Machine-specific configuration
  home-manager.users.${identity.username} = { pkgs, inputs, ... }: {
    wayland.windowManager.hyprland.settings = {
      monitor = ["eDP-1, 1920x1080@144, 0x0, 1.25"];
    };
  };
  
  services = {
    power-profiles-daemon.enable = true;
  };

  # Patch libfprint with support for the reader on my laptop
  nixpkgs.overlays = [
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
  ];
  services.fprintd.enable = true;
  security.pam.services = {
    sudo.fprintAuth = true;
    login.fprintAuth = true;
  };
}
