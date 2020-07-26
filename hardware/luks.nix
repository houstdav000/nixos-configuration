# luks.nix
#
# Configuration for setting up LUKS with passphrase login

{ config, pkgs, lib, ... }: {
  boot.initrd = {
    kernelModules = [ "vfat" "nls_cp437" ];

    luks = {
      cryptoModules = [ "aes" "xts" "sha512" ];

      devices = [ {
        name = "nixos-enc";
        device = "/dev/by-label/nixos-enc";
        preLVM = true;
      } ];
    };
  };
}
