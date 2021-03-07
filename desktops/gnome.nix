# gnome-configuration.nix
#
# Gnome Desktop Manager Definition and configuration file

{ config, pkgs, lib, ... }: {

  environment.systemPackages = with pkgs.gnome3; [
    gnome-tweaks
  ];

  services.xserver = {
    enable = true;
    autorun = true;
    layout = "us";
    desktopManager.gnome3.enable = true;
    displayManager = {
      defaultSession = "gnome";
      gdm = {
        enable = true;
        autoSuspend = true;
        debug = false;
        wayland = true;
      };
      autoLogin = {
        enable = true;
        user = "david";
      };
      hiddenUsers = [ "nobody" ];
    };
    libinput = {
      enable = true;
      touchpad = {
        disableWhileTyping = true;
        tapping = true;
        naturalScrolling = false;
        middleEmulation = false;
        accelProfile = "flat";
        scrollMethod = "twofinger";
      };
    };
    terminateOnReset = true;
    useGlamor = true;
    videoDrivers = [ "intel" "vmware" "modesetting" ];
  };

  hardware.opengl.driSupport32Bit = true;

  programs.gnupg.agent.pinentryFlavor = "gnome3";
}
