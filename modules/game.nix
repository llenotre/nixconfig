{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.prismlauncher
    pkgs.r2modman
  ];

  programs.steam.enable = true;
}
