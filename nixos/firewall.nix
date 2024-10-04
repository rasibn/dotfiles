{...}:
# {
#   # Open ports in the firewall.
#   networking.firewall.enable = true;
#   # networking.firewall.allowedTCPPorts = [ 3000 ];
#   # networking.firewall.allowedUDPPorts = [ 3000 ];
#   # Or disable the firewall altogether.
#   # networking.firewall.enable = false;
# }
{
  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];
    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];
  };
}
