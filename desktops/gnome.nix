# gnome-configuration.nix
#
# Gnome Desktop Manager Definition and configuration file

{ config, pkgs, lib, ... }: {

  services.xserver = {
    enable = true;
    autorun = true;
    layout = "us";
    desktopManager.gnome3.enable = true;
    displayManager = {
      defaultSession = "gnome";
      gdm = {
        enable = true;
        autoLogin = {
          enable = true;
          delay = 0;
          user = "david";
        };
        autoSuspend = true;
        debug = false;
        wayland = true;
      };
      hiddenUsers = [ "nobody" ];
    };
    libinput = {
      enable = true;
      accelProfile = "adaptive";
      disableWhileTyping = false;
      middleEmulation = false;
      naturalScrolling = false;
      scrollMethod = "twofinger";
      tapping = true;
    };
    terminateOnReset = true;
    useGlamor = true;
    videoDrivers = [ "intel" "vmware" "modesetting" ];
  };

  hardware.opengl.driSupport32Bit = true;
}
