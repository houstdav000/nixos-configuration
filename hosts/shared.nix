# shared.nix
#
# Shared configuration

{ config, pkgs, lib, ... }: {
  boot.plymouth.enable = true;

  boot.kernelParams = [
    "quiet"
    "vga=current"
  ];

  # Use the systemd-boot EFI boot loader.

  networking = {
    enableIPv6 = true;
    useDHCP = false;

    networkmanager.enable = true;

    firewall = {
      enable = true;
      package = pkgs.iptables-nftables-compat;
      allowPing = true;
    };
  };

  # Set your time zone
  time.timeZone = "America/New_York";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    nftables
    git
    gnupg
    neovim
    neofetch
    htop
    nixos-grub2-theme
    nixos-icons
    openvpn
    openconnect
  ];

  # Some programs need SUID wrappers, can be configured further or are
  #  started in user sessions.
  programs =
    {
      vim.defaultEditor = true;
      tmux.enable = true;
      mtr.enable = true;
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };

  # Enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;

}
