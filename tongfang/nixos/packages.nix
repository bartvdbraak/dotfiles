{ pkgs, inputs, config, ... }:

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
  ];
}
