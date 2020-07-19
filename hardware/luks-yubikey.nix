# luks_yubikey-configuration.nix
#
# Configuration for setting up LUKS with a yubikey 2-FA

{ config, pkgs, lib, ... }: {
  boot.initrd = {
    # Minimal list of modules to use the EFI system partition and the YubiKey
    kernelModules = [ "vfat" "nls_cp437" "nls_iso8859-1" "usbhid"  ];

    luks = {
      # Crypto setup, set modules accordingly
      cryptoModules = [ "aes" "xts" "sha512"  ];

      # Enable support for the YubiKey PBA
      yubikeySupport = true;

      # Configuration to use your Luks device
      devices = [ {
        name = "nixos-enc";
        device = "/dev/by-label/nixos-enc";
        preLVM = true; # You may want to set this to false if you need to start a network service first
        yubikey = {
          slot = 2;
          twoFactor = true; # Set to false if you did not set up a user password.
          storage = {
            device = "/dev/by-label/boot";
          };
        };
      } ];
    };
  };
}
