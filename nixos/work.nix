{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    turso-cli
    bitwarden-cli
    bws
    sqlite
    usql
    air
    # slack
    # aws-sam-cli
    # awscli2
    # cargo-lambda
    # gnumake
    # cmake
    # firebase-tools
  ];
}
