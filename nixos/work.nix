{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    turso-cli
    bitwarden-cli
    bruno
    nodePackages.rollup
    bws
    sqlite
    sqlx-cli
    cargo-shuttle
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
