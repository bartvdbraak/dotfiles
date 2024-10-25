# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

let
  yt6801Overlay = (final: prev: {
    yt6801-driver = import ./yt6801-driver.nix {
      inherit (pkgs) lib stdenv fetchurl kernel bc nukeReferences;
    };
  });
in
{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];
  nixpkgs.overlays = [ yt6801Overlay ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ pkgs.yt6801-driver ];
  environment.systemPackages = with pkgs; [ yt6801-driver ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/c7cf28c3-5744-45cc-8a81-456d24e44b7a";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/CEF6-7DAA";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
