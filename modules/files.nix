{ pkgs, identity, ... }:
{
  services.udisks2.enable = true;

  home-manager.users.${identity.username} = { pkgs, ... }: {
    services.udiskie = {
      enable = true;
      settings = {
        # workaround for
        # https://github.com/nix-community/home-manager/issues/632
        program_options = {
          # replace with your favorite file manager
          file_manager = "${pkgs.kdePackages.dolphin}/bin/dolphin";
        };
      };
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        # File manager
        "inode/directory" = [ "org.kde.dolphin.desktop" ];

        # Web browser & URLs
        "text/html" = [ "firefox.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/about" = [ "firefox.desktop" ];
        "x-scheme-handler/unknown" = [ "firefox.desktop" ];

        # Documents & PDF
        "application/pdf" = [ "firefox.desktop" ];
        "application/x-pdf" = [ "firefox.desktop" ];

        # Text & Code
        "text/plain" = [ "code.desktop" ];
        "text/markdown" = [ "code.desktop" ];
        "application/json" = [ "code.desktop" ];
        "application/xml" = [ "code.desktop" ];
        "text/xml" = [ "code.desktop" ];
        "text/x-shellscript" = [ "code.desktop" ];
        "text/x-python" = [ "code.desktop" ];
        "text/x-c" = [ "code.desktop" ];
        "text/x-c++" = [ "code.desktop" ];
        "text/x-nix" = [ "code.desktop" ];
        "application/x-yaml" = [ "code.desktop" ];
        "text/yaml" = [ "code.desktop" ];

        # Images
        "image/png" = [ "org.gnome.Loupe.desktop" ];
        "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
        "image/gif" = [ "org.gnome.Loupe.desktop" ];
        "image/webp" = [ "org.gnome.Loupe.desktop" ];
        "image/bmp" = [ "org.gnome.Loupe.desktop" ];
        "image/tiff" = [ "org.gnome.Loupe.desktop" ];
        "image/svg+xml" = [ "org.gnome.Loupe.desktop" ];
        "image/avif" = [ "org.gnome.Loupe.desktop" ];
        "image/heic" = [ "org.gnome.Loupe.desktop" ];
        "image/vnd.microsoft.icon" = [ "org.gnome.Loupe.desktop" ];

        # Audio
        "audio/mpeg" = [ "vlc.desktop" ];
        "audio/mp3" = [ "vlc.desktop" ];
        "audio/flac" = [ "vlc.desktop" ];
        "audio/wav" = [ "vlc.desktop" ];
        "audio/x-wav" = [ "vlc.desktop" ];
        "audio/ogg" = [ "vlc.desktop" ];
        "audio/aac" = [ "vlc.desktop" ];
        "audio/mp4" = [ "vlc.desktop" ];
        "audio/m4a" = [ "vlc.desktop" ];
        "audio/x-m4a" = [ "vlc.desktop" ];
        "audio/webm" = [ "vlc.desktop" ];

        # Video
        "video/mp4" = [ "vlc.desktop" ];
        "video/mkv" = [ "vlc.desktop" ];
        "video/x-matroska" = [ "vlc.desktop" ];
        "video/webm" = [ "vlc.desktop" ];
        "video/quicktime" = [ "vlc.desktop" ];
        "video/x-msvideo" = [ "vlc.desktop" ];
        "video/avi" = [ "vlc.desktop" ];
        "video/x-ms-wmv" = [ "vlc.desktop" ];
        "video/ogg" = [ "vlc.desktop" ];

        # Archives
        "application/zip" = [ "org.kde.ark.desktop" ];
        "application/x-tar" = [ "org.kde.ark.desktop" ];
        "application/x-bzip" = [ "org.kde.ark.desktop" ];
        "application/x-bzip2" = [ "org.kde.ark.desktop" ];
        "application/x-gzip" = [ "org.kde.ark.desktop" ];
        "application/x-7z-compressed" = [ "org.kde.ark.desktop" ];
        "application/x-rar" = [ "org.kde.ark.desktop" ];
        "application/x-rar-compressed" = [ "org.kde.ark.desktop" ];
        "application/x-xz" = [ "org.kde.ark.desktop" ];
        "application/x-zstd" = [ "org.kde.ark.desktop" ];
        "application/zstd" = [ "org.kde.ark.desktop" ];
      };
    };
  };
}