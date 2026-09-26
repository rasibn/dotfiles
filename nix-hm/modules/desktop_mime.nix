{
  config,
  pkgs,
  ...
}: let
  braveDesktop = "brave-browser.desktop";
  transmissionDesktop = "transmission-gtk.desktop";
  nvimDesktop = "nvim.desktop";
  fehDesktop = "feh.desktop";
  mpvDesktop = "mpv.desktop";
  foliateDesktop = "com.github.johnfactotum.Foliate.desktop";
  zathuraDesktop = "org.pwmt.zathura.desktop";
in {
  xdg.desktopEntries.nvim = {
    name = "Neovim";
    genericName = "Text Editor";
    comment = "Edit text files in Neovim";
    exec = "ghostty -e nvim %F";
    terminal = false;
    type = "Application";
    categories = ["Utility" "TextEditor"];
    mimeType = ["text/plain" "text/markdown" "application/x-shellscript" "text/x-python" "text/x-go" "text/x-c" "text/x-c++" "text/x-java" "application/json" "application/x-yaml" "application/x-nix"];
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Browsing / HTML
      "text/html" = [braveDesktop];
      "x-scheme-handler/http" = [braveDesktop];
      "x-scheme-handler/https" = [braveDesktop];
      "x-scheme-handler/about" = [braveDesktop];
      "x-scheme-handler/unknown" = [braveDesktop];
      "x-scheme-handler/chrome" = [braveDesktop];
      "application/x-extension-htm" = [braveDesktop];
      "application/x-extension-html" = [braveDesktop];
      "application/x-extension-shtml" = [braveDesktop];
      "application/xhtml+xml" = [braveDesktop];
      "application/x-extension-xhtml" = [braveDesktop];
      "application/x-extension-xht" = [braveDesktop];

      # Torrent magnet links
      "x-scheme-handler/magnet" = [transmissionDesktop];

      # Images → open in feh (fallback to Brave second)
      "image/png" = [fehDesktop braveDesktop];
      "image/jpeg" = [fehDesktop braveDesktop];
      "image/gif" = [fehDesktop braveDesktop];
      "image/webp" = [fehDesktop braveDesktop];
      "image/svg+xml" = [braveDesktop]; # svg better in browser

      # Video / media → mpv
      "video/mp4" = [mpvDesktop];
      "video/x-matroska" = [mpvDesktop];
      "video/webm" = [mpvDesktop];
      "audio/mpeg" = [mpvDesktop];
      "audio/flac" = [mpvDesktop];

      # PDF → Zathura (fallback to Brave)
      "application/pdf" = [zathuraDesktop braveDesktop];

      # EPUB → Foliate
      "application/epub+zip" = [foliateDesktop];

      # Text / code → Neovim
      "text/plain" = [nvimDesktop];
      "text/markdown" = [nvimDesktop];
      "application/x-shellscript" = [nvimDesktop];
      "application/json" = [nvimDesktop];
      "application/x-yaml" = [nvimDesktop];
      "application/x-nix" = [nvimDesktop];
    };
    # Also register them as associations so they show up in chooser
    associations.added = {
      "image/png" = [fehDesktop braveDesktop];
      "image/jpeg" = [fehDesktop braveDesktop];
      "text/plain" = [nvimDesktop];
      "text/markdown" = [nvimDesktop];
    };
  };
}
