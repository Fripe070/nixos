{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      inter
      nerd-fonts.jetbrains-mono
      twemoji-color-font
      noto-fonts
      noto-fonts-cjk-sans
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = [ "Inter" "Twitter Color Emoji" "Noto Sans" ];
        serif = [ "Noto Serif" "Twitter Color Emoji" ];
        monospace = [ "JetBrains Mono Nerd Font" "Twitter Color Emoji" "Noto Sans" ];
        emoji = [ "Twitter Color Emoji" ];
      };
    };
  };
}