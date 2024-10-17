{ config, pkgs, ... }:

{
  users.users.bart = {
    isNormalUser = true;
    description = "Bart van der Braak";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      vscodium
      thunderbird
      fastfetch
      wezterm
      neovim
      logseq
      element-desktop
      opentofu
      python3
      gnumake
      spotify
    ];
  };

  nixpkgs.config.permittedInsecurePackages = [
    # Workaround for electron dependency in Logseq
    "electron-27.3.11"
  ];
}
