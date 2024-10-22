{ pkgs, inputs, config, ... }:

let
  customWallpaper = "/nix/store/fvplr8bbp5b9n2x6s21bp4nai80adk8j-wallhaven-zyerpj.jpg";
in
{
  environment.systemPackages = with pkgs; with inputs; [
    inputs.zen-browser.packages."${system}".default
    firefox
    git
    vim
    wget
    curl
    fzf
    jq
    ripgrep
    networkmanager-openvpn
    (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
    [General]
    background=${customWallpaper}
    '')
    dig
    caligula
  ];
}
