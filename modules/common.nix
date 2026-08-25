{ identity, inputs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
      "https://vicinae.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
    ];
  };

  boot.loader = {
    efi.canTouchEfiVariables = true;
    timeout = 5;
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
  };

  # Permission control, allowing applications to ask for higher permissions
  security.polkit.enable = true;

  users.users.${identity.username} = {
    isNormalUser = true;
    description = identity.displayName;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs identity; };
    users.${identity.username} = {
      home.stateVersion = "25.05";
    };
    backupFileExtension = "hm-backup";
  };

  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}