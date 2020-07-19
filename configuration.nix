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
    ./desktops/gnome.nix
    ./hardware/btrfs-filesystem.nix
    ./hardware/luks-yubikey.nix
    ./services/libvirt.nix
    ./services/ssh.nix
    ./services/podman.nix
    ./users/david.nix
  ];

  networking.hostName = "dh-nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.ens33.useDHCP = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget vim # Default recommended
    openvpn # Connectivity
    git gnupg # General needed tools
    open-vm-tools
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

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.david = {
    packages = with pkgs; [
      git gnupg
      fish starship exa hexyl bat
      firefox thunderbird alacritty virt-manager
    ];
    isNormalUser = true;
    home = "/home/david";
    description = "David Houston";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    subUidRanges = [{ startUid = 100000; count = 65536; }];
    subGidRanges = [{ startGid = 100000; count = 65536; }];
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMNGHlmwe95TX1/5DQNqoZqiaZf6jYb7pmMGgdYaMp6t david@DH-LAPTOP2"];
    shell = pkgs.fish;
  };

  # This value determines the NixOS release from which the default
  #  settings for stateful data, like file locations and database versions
  #  on your system were taken. It‘s perfectly fine and recommended to leave
  #  this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  #  (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?
}
