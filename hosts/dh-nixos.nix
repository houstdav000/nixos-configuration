# configuration.nix
#
# Edit this configuration file to define what should be installed on
#  your system.  Help is available in the configuration.nix(5) man page
#  and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }: {
  # This is in a VM, so enable Virtualisation support
  virtualisation.vmware.guest.enable = true;

  # Import other configuration files
  imports = [
    ./shared.nix
    ../desktops/gnome.nix
    ../hardware/ext4-filesystem.nix
    ../services/sshd.nix
  ];

  networking = {
    hostName = "dh-nixos"; # Define your hostname.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.

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

  # Enable CUPS to print documents.
  services.printing.enable = true;
}
