{ pkgs, identity, ... }:
let
  snip = pkgs.writeShellApplication {
    name = "snip";
    runtimeInputs = with pkgs; [
      procps
      libnotify
      slurp
      wl-screenrec
      grimblast
      wl-clipboard
      satty
      jq
      xdg-utils
      coreutils
    ];
    text = builtins.readFile ./snip.sh;
  };
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
      snip
    ];

    home.sessionVariables = {
      GRIMBLAST_EDITOR = "satty --filename";
    };

    xdg.configFile."satty/config.toml".text = ''
      [general]
      fullscreen = false
      early-exit = true
      initial-tool = "brush"
      copy-command = "wl-copy"
      annotation-size-factor = 1.0
      output-filename = "~/Pictures/Screenshots/screenshot-%Y%m%d-%H%M%S.png"
      save-after-copy = false
      default-hide-toolbars = false
    '';
  };
}
