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

  virtualisation = {
    oci-containers = {
      backend = "podman";

      containers = {
        "embyserver" = {
          autoStart = true;
          image = "emby/embyserver:latest";
          ports = [
            "8096:8096"
            "8920:8920"
          ];
          volumes = [
            "/config/emby:/config"
            "/mnt/share:/mnt"
          ];
        };

        "samba" = {
          autoStart = true;
          cmd = [
            "-n"
            "-p"
            "-u public;password"
            "-s nas;/share;yes;no;yes;all;no;"
          ];
          environment = {
            TZ = "EST5EDT";
          };
          extraOptions = [
            "--network=host"
          ];
          image = "dperson/samba:latest";
          ports = [
            # Samba Ports
            "139:139"
            "445:445"

            # nmbd Ports
            "137:137/udp"
            "138:138/udp"
          ];
          volumes = [
            "/mnt/share:/share"
          ];
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    139
    445
    8096
    8920
  ];

  networking.firewall.allowedUDPPorts = [
    137
    138
  ];
}