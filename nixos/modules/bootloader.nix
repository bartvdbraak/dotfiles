{ pkgs,  ... }:

{
  # Bootloader options
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 2;
  boot.initrd.enable = true;
  boot.initrd.systemd.enable = true;
  boot.consoleLogLevel = 3;
  boot.plymouth = {
    enable = true;
    font = "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf";
    themePackages = [ pkgs.nixos-bgrt-plymouth ];
    theme = "nixos-bgrt";
  };
}