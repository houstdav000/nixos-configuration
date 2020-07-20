# configuration.nix
#
# Edit this configuration file to define what should be installed on
#  your system.  Help is available in the configuration.nix(5) man page
#  and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }: {
  # Import other configuration files
  imports = [
    ./shared.nix
    ../desktops/gnome.nix
    ../hardware/btrfs-filesystem.nix
    ../hardware/luks-yubikey.nix
    ../services/cupsd.nix
    ../services/podman.nix
    ../services/libvirtd.nix
  ];

  networking = {
    hostName = "dh-laptop2"; # Define your hostname.
    wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    interfaces.ens33.useDHCP = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    openvpn # Connectivity
  ];
}
