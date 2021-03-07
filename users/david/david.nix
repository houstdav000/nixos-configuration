# david.nix
#
# User config for "david" user

{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/master.tar.gz;

in {

  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.david = (import ./nix-home/home.nix);

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.david = {
    isNormalUser = true;
    home = "/home/david";
    description = "David Houston";
    extraGroups = [ "wheel" "networkmanager" "audio"]; # Enable ‘sudo’ for the user.
    subUidRanges = [{ startUid = 100000; count = 65536; }];
    subGidRanges = [{ startGid = 100000; count = 65536; }];
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMNGHlmwe95TX1/5DQNqoZqiaZf6jYb7pmMGgdYaMp6t david@DH-LAPTOP2"];
  };
}
