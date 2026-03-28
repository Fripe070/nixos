{ pkgs, identity, ... }:

{
  home-manager.users.${identity.username} = { pkgs, ... }: {
    programs = {
      # My shell of choice
      fish = {
        enable = true;
        # start hyprland on boot
        shellInit = "hyprland";
      };
      # Nix helper
      nh = {
        enable = true;
        flake = /home/${identity.username}/nixos;
      };
      # z command as an improved cd
      zoxide.enable = true;

      git = {
        enable = true;
        #settings = {
        #  user = {
        #    email = identity.email;
        #    name = identity.displayName;
        #  };
        #  init.defaultBranch = "main";
        #};
      };
      gh = {
        enable = true;
        gitCredentialHelper.enable = true;
      };
    };
  };
}