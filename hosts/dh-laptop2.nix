# configuration.nix
#
# Edit this configuration file to define what should be installed on
#  your system.  Help is available in the configuration.nix(5) man page
#  and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }: {
  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Import other configuration files
  imports = [
    # Include the results of the hardware scan.
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
    useDHCP = false;
    interfaces.ens33.useDHCP = true;
  };


  # Set your time zone.
  time.timeZone = "America/New_York";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget vim # Default recommended
    openvpn # Connectivity
    git gnupg # General needed tools
    tmux fish neofetch htop
    nixos-grub2-theme nixos-icons
  ];

  # Some programs need SUID wrappers, can be configured further or are
  #  started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gnome3";
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
}
