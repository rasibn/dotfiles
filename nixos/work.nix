{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    turso-cli
    bitwarden-cli
    caddy
    bws
    sqlite
    usql
    air
    # slack
    # aws-sam-cli
    # awscli2
    # cargo-lambda
    # cmake
    # firebase-tools
  ];
}
