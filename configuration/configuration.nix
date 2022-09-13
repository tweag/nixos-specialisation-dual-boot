{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./work.nix
    ./private.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;

  # for old computers with MBR
  boot.loader.grub.device = "/dev/sda";

  # to prevent a boot issue with LVM+LUKS
  boot.initrd.preLVMCommands = "lvm vgchange -ay";

  # some wifi cards may not work without it
  hardware.enableRedistributableFirmware = true;

  networking.hostName = "tweag-x1";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "fr_FR.UTF-8";
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # simple setup with i3
  services.xserver = {
    displayManager.sddm.enable = true;
    enable = true;
    layout = "fr";
    libinput.enable = true;
    windowManager.i3.enable = true;
  };

  # declaring a shared user between the two contexts
  users.users.solene = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = ["wheel" "networkmanager" "sudo"];
  };

  environment.systemPackages = with pkgs; [
    git
    kakoune
  ];

  services.openssh.enable = true;

  system.stateVersion = "22.05";
}
