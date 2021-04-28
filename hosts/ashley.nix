{ config, pkgs, ... }: {
  imports = [
    ./shared.nix
    ../hardware/ashley.nix
    ../services/podman.nix
    ../services/sshd.nix
  ];

  boot = {
    loader = {
      grub = {
        enable = true;
        version = 2;
        device = "/dev/sda";
      };

    };
    kernel.sysctl = {
      "kernel.unprivileged_userns_clone" = "1";
    };
    kernelPackages = pkgs.linuxPackages_latest_hardened;
  };

  networking = {
    hostName = "ashley";
    interfaces = {
      enp2s0.useDHCP = true;
    };
  };

  users.mutableUsers = false;
  users.users.root = {
    hashedPassword = "$6$paNcgqe0JBE3W$u1CwTahnW5wMlfxkzTApWJdYyncnDWa6XLhr0GucM2DYPeQw/Tyv2mo8HtJw/OcMxhjK7SkGfJtCGz/80wlxS0";
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL5LI8aGsOSdSD/WNHZBE7+cXQ82KR6zqSaL3yt311X8" ];
  };
}
