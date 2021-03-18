# libvirt-configuration.nix
#
# Uhhhh, TODO: ?

{ config, pkgs, lib, ... }: {

  environment.systemPackages = with pkgs; [
    qemu
    qemu-utils
    qemu_kvm
  ];

  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];
  virtualisation = {
    libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "suspend";
      qemuOvmf = true;
      qemuRunAsRoot = true;
    };
    lxc = {
      enable = true;
      lxcfs.enable = true;
    };
    lxd = {
      enable = true;
      recommendedSysctlSettings = true;
    };
  };
}
