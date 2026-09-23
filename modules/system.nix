{ config, pkgs, username, hostname, ... }:
{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  time.timeZone = "Europe/Paris";
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "fr_FR.UTF-8";
      LC_IDENTIFICATION = "fr_FR.UTF-8";
      LC_MEASUREMENT = "fr_FR.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
      LC_NAME = "fr_FR.UTF-8";
      LC_NUMERIC = "fr_FR.UTF-8";
      LC_PAPER = "fr_FR.UTF-8";
      LC_TELEPHONE = "fr_FR.UTF-8";
      LC_TIME = "fr_FR.UTF-8";
    };
  };

  users.users.${username} = {
    isNormalUser = true;
    description = "Luc Lenôtre";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      alacritty
      btop
      clang
      claude-code
      curl
      direnv
      discord
      elfutils
      git
      gnome-calculator
      gnumake
      signal-desktop
      vim
      xxd
      zed-editor
    ];
  };

  # Sway's own dependencies come from programs.sway.extraPackages, which is
  # left at its default. Overriding that option replaces the list rather than
  # extending it, so anything extra belongs here instead.
  environment.systemPackages = with pkgs; [
    loupe
    wl-clipboard
  ];

  # Sway config
  environment.etc."sway/config.d/50-local.conf".text = ''
    # Disable swaybar to replace it with noctalia's bar
    bar bar-0 {
      mode invisible
      status_command true
    }

    # Sway does not read the xorg keyboard config, so mirror it here
    input * {
      xkb_layout ${config.services.xserver.xkb.layout}
      xkb_options ${config.services.xserver.xkb.options}
    }

    input type:touchpad {
      # finger tap to click: 1 finger left, 2 fingers right, 3 fingers middle.
      tap_button_map lrm
      # suppress the touchpad briefly after each keystroke
      dwt enabled
    }

    # Application shortcuts
    bindsym $mod+t exec ${pkgs.alacritty}/bin/alacritty
    bindsym --no-warn $mod+Return exec ${pkgs.alacritty}/bin/alacritty
    bindsym --no-warn $mod+b exec ${config.programs.firefox.finalPackage}/bin/firefox
    bindsym $mod+c exec ${pkgs.gnome-calculator}/bin/gnome-calculator
    bindsym XF86Calculator exec ${pkgs.gnome-calculator}/bin/gnome-calculator
    # $mod+b was the horizontal split; keep it reachable under Shift.
    bindsym $mod+Shift+b splith

    bindsym --no-warn $mod+d exec ${config.programs.noctalia.package}/bin/noctalia msg panel-toggle launcher
    bindsym --release Super_L exec ${config.programs.noctalia.package}/bin/noctalia msg panel-toggle launcher
  '';

  programs = {
    firefox.enable = true;
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
    # Wayland shell: bar, launcher, notifications, polkit agent, OSDs
    noctalia = {
      enable = true;
      systemd.enable = true;
      # NetworkManager, bluetooth, UPower and a power profile daemon
      recommendedServices.enable = true;
    };
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking = {
    hostName = hostname;
    networkmanager.enable = true;
  };

  services = {
    # Use Wayland
    xserver = {
      enable = false;
      # Keyboard layout
      xkb = {
        layout = "us";
        options = "caps:escape_shifted_compose,compose:ralt";
      };
    };

    gnome.gnome-keyring.enable = true;

    # Enable CUPS to print documents.
    printing.enable = true;
    # Enable sound with pipewire
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
  security.rtkit.enable = true;
}
