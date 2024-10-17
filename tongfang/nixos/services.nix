{ pkgs, ... }:

{
  # X11 is disabled, but we're using SDDM with Wayland
  services.xserver.enable = false;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Audio system with PipeWire
  # Enable PipeWire and ALSA support
  services.pipewire = {
    enable = true;
    alsa.enable = true;       # Enable ALSA support
    alsa.support32Bit = true; # Support for 32-bit applications
    pulse.enable = true;      # Enable PulseAudio compatibility layer
  };
  
  # Enable libinput for input device handling
  services.libinput.enable = true;

  # Enable security-related service for realtime audio tasks
  security.rtkit.enable = true;

  # Steam, Tailscale, and other services
  programs.steam.enable = true;
  services.tailscale.enable = true;

  # Environment variables
  environment.variables = {
    EDITOR = "vim";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    NIXOS_OZONE_WL = "1";
  };

  # Printing and Bluetooth
  # Disable browsed: https://discourse.nixos.org/t/newly-announced-vulnerabilities-in-cups
  services.printing.enable = true;
  services.printing.browsed.enable = false;
  hardware.bluetooth.enable = true;
}
