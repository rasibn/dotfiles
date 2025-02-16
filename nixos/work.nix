{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    turso-cli
    bitwarden-cli
    bruno
    nodePackages.rollup
    jetbrains.idea-ultimate
    bws
    sqlite
    sqlx-cli
    cargo-shuttle
    usql
    vue-language-server
    sea-orm-cli
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
