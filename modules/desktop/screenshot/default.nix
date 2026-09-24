{ pkgs, identity, ... }:

let
  snip = pkgs.writers.writeNuBin "snip" (builtins.readFile ./snip.nu);
in
{
  home-manager.users.${identity.username} = { pkgs, ... }: {
    home.packages = with pkgs; [
      grimblast
      slurp
      satty
      wl-screenrec
      wl-clipboard
      libnotify
      nushell
      procps
      xdg-utils
      snip
    ];

    home.sessionVariables = {
      GRIMBLAST_EDITOR = "satty --filename";
    };

    xdg.configFile."satty/config.toml".text = ''
      [general]
      fullscreen = false
      floating-hack = true
      early-exit = true
      initial-tool = "brush"
      copy-command = "wl-copy"
      save-after-copy = false
    '';
  };
}
