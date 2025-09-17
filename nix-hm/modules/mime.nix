{
  config,
  pkgs,
  ...
}: let
  firefoxDesktop = "firefox.desktop";
  transmissionDesktop = "transmission-gtk.desktop";
  nvimDesktop = "nvim.desktop";
  fehDesktop = "feh.desktop";
  mpvDesktop = "mpv.desktop";
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
      "text/html" = [firefoxDesktop];
      "x-scheme-handler/http" = [firefoxDesktop];
      "x-scheme-handler/https" = [firefoxDesktop];
      "x-scheme-handler/about" = [firefoxDesktop];
      "x-scheme-handler/unknown" = [firefoxDesktop];
      "x-scheme-handler/chrome" = [firefoxDesktop];
      "application/x-extension-htm" = [firefoxDesktop];
      "application/x-extension-html" = [firefoxDesktop];
      "application/x-extension-shtml" = [firefoxDesktop];
      "application/xhtml+xml" = [firefoxDesktop];
      "application/x-extension-xhtml" = [firefoxDesktop];
      "application/x-extension-xht" = [firefoxDesktop];

      # Torrent magnet links
      "x-scheme-handler/magnet" = [transmissionDesktop];

      # Images → open in feh (fallback to firefox second)
      "image/png" = [fehDesktop firefoxDesktop];
      "image/jpeg" = [fehDesktop firefoxDesktop];
      "image/gif" = [fehDesktop firefoxDesktop];
      "image/webp" = [fehDesktop firefoxDesktop];
      "image/svg+xml" = [firefoxDesktop]; # svg better in browser

      # Video / media → mpv
      "video/mp4" = [mpvDesktop];
      "video/x-matroska" = [mpvDesktop];
      "video/webm" = [mpvDesktop];
      "audio/mpeg" = [mpvDesktop];
      "audio/flac" = [mpvDesktop];

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
      "image/png" = [fehDesktop firefoxDesktop];
      "image/jpeg" = [fehDesktop firefoxDesktop];
      "text/plain" = [nvimDesktop];
      "text/markdown" = [nvimDesktop];
    };
  };
}
