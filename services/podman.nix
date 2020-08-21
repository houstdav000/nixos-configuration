# podman.nix
#
# Podman configuration

{ config, pkgs, lib, ... }: {
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
}
