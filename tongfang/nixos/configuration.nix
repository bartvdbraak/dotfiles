{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "tongfang";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Amsterdam";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver.enable = false;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = false;
  hardware.bluetooth.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;

  nixpkgs.config.permittedInsecurePackages = [
    "electron-27.3.11"
  ];
  
  users.users.bart = {
    isNormalUser = true;
    description = "Bart van der Braak";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      vscodium-fhs
      thunderbird
      fastfetch
      wezterm
      neovim
      logseq
      element-desktop
      opentofu
      python3
      gnumake
    ];
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; with inputs; [
    inputs.zen-browser.packages."${system}".default
    firefox
    git
    vim
    wget
    curl
    fzf
  ];
  environment.variables.EDITOR = "vim";

  fonts.packages = with pkgs; [
    jetbrains-mono
  ];

  system.stateVersion = "24.05";
}
