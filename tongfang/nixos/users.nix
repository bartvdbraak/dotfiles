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
      go-task
      opentofu
      python3
      gnumake
      spotify
      _1password-gui
      nodejs_22
      corepack_22
      azure-cli
      sops
      blender
    ];
  };

  nixpkgs.config.permittedInsecurePackages = [
    # Workaround for electron dependency in Logseq
    "electron-27.3.11"
  ];
}
