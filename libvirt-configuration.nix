# libvirt-configuration.nix
#
# Uhhhh, TODO: ?

{ config, pkgs, lib, ... }: {

  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
    onShutdown = "suspend";
    qemuOvmf = true;
    qemuRunAsRoot = true;
  };
}
