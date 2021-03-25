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
    ../services/libvirtd.nix
    ../services/cupsd.nix
    ../services/podman.nix
  ];

  boot = {
    # Harden the kernel, but still allow unprivileged namespaces
    kernel.sysctl =
      {
        "kernel.unprivileged_userns_clone" = "1";
      };
    kernelPackages = pkgs.linuxPackages_latest_hardened;
    kernelParams = [
      "intel_iommu=on"
    ];
  };

  networking = {
    hostName = "dh-laptop2"; # Define your hostname.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    interfaces = {
      #enp0s20f0u4u4.useDHCP = true;
      enp1s0.useDHCP = true;
      wlp0s20f3.useDHCP = true;
    };
  };

  services.tlp.enable = true;
}
