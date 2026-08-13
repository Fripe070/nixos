{ identity, ... }:
{  
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";

    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    #LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
  };
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "se";
    variant = "nodeadkeys";
  };
  # Keyboard layout for hyprland
  home-manager.users.${identity.username}.wayland.windowManager.hyprland.settings.input.kb_layout = "se";
  # Configure console keymap
  console.keyMap = "sv-latin1";
}
