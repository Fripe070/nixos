{ pkgs, identity, ... }:

let
  snip = pkgs.writeShellScriptBin "snip" ''
    exec ${pkgs.nushell}/bin/nu ${./snip.nu} "$@"
  '';
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
