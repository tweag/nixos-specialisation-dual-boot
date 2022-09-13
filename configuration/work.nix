{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  # specialisation code
  specialisation = {
    work.configuration = {
      system.nixos.tags = ["work"];

      # CUSTOM changes for the work environment
      users.users.solene.packages = with pkgs; [chromium git emacs];
      # END CUSTOM

      boot.initrd.availableKernelModules = ["ata_generic" "uhci_hcd" "ehci_pci" "ahci" "usb_storage" "sd_mod"];
      boot.initrd.kernelModules = ["dm-snapshot"];
      boot.kernelModules = ["kvm-intel"];
      boot.extraModulePackages = [];

      fileSystems."/" = {
        device = "/dev/mapper/crypto-work";
        fsType = "ext4";
      };

      boot.initrd.luks.devices."crypto-work".device = "/dev/pool/root-work";

      fileSystems."/nix" = {
        device = "/dev/disk/by-uuid/e1918d74-4437-4435-a3a0-e26ea0e18a06";
        fsType = "ext4";
      };

      boot.initrd.luks.devices."nix-store".device = "/dev/disk/by-uuid/172de956-61b5-43d0-aa57-dcce0fe269a5";

      fileSystems."/etc/nixos" = {
        device = "/nix/config";
        fsType = "none";
        options = ["bind"];
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/fea82022-cce1-4ddb-ac56-547dc6040106";
        fsType = "ext4";
      };

      swapDevices = [];
      networking.useDHCP = lib.mkDefault true;
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
  };
}
