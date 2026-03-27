{ identity, inputs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

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
  };

  # Enable networking
  networking.networkmanager.enable = true;

  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}