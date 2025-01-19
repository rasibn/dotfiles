{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    turso-cli
    bitwarden-cli
    bruno
    caddy
    bws
    sqlite
    usql
    vue-language-server
    air
    delve
    gdlv
    # slack
    # aws-sam-cli
    # awscli2
    # cargo-lambda
    # cmake
    # firebase-tools
  ];
}
