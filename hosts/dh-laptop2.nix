# configuration.nix
#
# Edit this configuration file to define what should be installed on
#  your system.  Help is available in the configuration.nix(5) man page
#  and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }: {
  # Import other configuration files
  imports = [
    ./shared.nix
    ../desktops/kde.nix
    ../hardware/btrfs-filesystem.nix
    ../hardware/luks.nix
    ../services/cupsd.nix
    ../services/podman.nix
    ../services/libvirtd.nix
  ];

  networking = {
    hostName = "dh-laptop2"; # Define your hostname.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    interfaces = {
      enp0s20f0u4u4.useDHCP = true;
      enp1s0.useDHCP = true;
      wlp0s20f3.useDHCP = true;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    openvpn # Connectivity
  ];
}
