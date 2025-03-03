# Edit this configuration file to define what should be installed on your system.  Help 
# is available in the configuration.nix(5) man page and in the NixOS manual (accessible 
# by running ‘nixos-help’).

{ config, pkgs, lib, ... }:


{  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.UTF-8";

  i18n.extraLocaleSettings = {
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "fr";
    variant = "azerty";
  };

  # Configure console keymap
  console.keyMap = "fr";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.benzeze = {
    isNormalUser = true;
    description = "Benzeze";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kate
      thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;
  programs.firefox.policies = {
	ExtensionSettings = with builtins;
	  let extension = shortId: uuid: {
	    name = uuid;
	    value = {
		install_url = "https://addons.mozilla.org/fr-FR/firefox/downloads/latest/${shortId}/latest.xpi";
		installation_mode = "normal_installed";
	    };
	  };
	  in listToAttrs [
		(extension "ublock-origin" "uBlock0@raymondhill.net")
		(extension "bitwarden-password-manager" "{446900e4-71c2-419f-a6a7-df9c091e268b}")
		];
	  };

  systemd.services.onlyofficeShortcut = {
    description = "Créer un raccourci OnlyOffice sur le bureau";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    serviceConfig = {
	Type = "oneshot";
	ExecStart = "/run/current-system/sw/bin/ln -s /run/current-system/sw/share/applications/onlyoffice-desktopeditors.desktop /home/benzeze/Bureau/'Only Office'";  
      };
   };
  
  systemd.services.picocryptShortcut = {
    description = "Créer un raccourci Picocrypt sur le bureau";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    serviceConfig = {
	Type = "oneshot";
	ExecStart = "/run/current-system/sw/bin/ln -s /run/current-system/sw/share/applications/Picocrypt.desktop /home/benzeze/Bureau/Picocrypt";
      };
   };

systemd.services.daily-script = {
	description = "Exécution quotidienne du script de maj de la config";
	serviceConfig = {
		Type = "oneshot";
		ExecStart = "/run/current-system/sw/bin/sh /etc/nixos/majauto.sh";
		};
	};

 #Configurer le timer pour exécuter le service tous les jours à 7h00
	systemd.timers.daily-script = {
	wantedBy = [ "timers.target" ];
	partOf = [ "daily-script.service" ];
	timerConfig = {
		OnCalendar = "07:00:00";
		Persistent = true;
		};
	};
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true; 

environment.systemPackages=with pkgs; [
       vim # Do not forget to add an editor to edit configuration.nix! The Nano >
       wget
      iptables
       git
       curlWithGnuTls
       gccgo14      
       libgccjit
       haskellPackages.pcre2
       pcre2
       gnumake  
      # onlyoffice-desktopeditors
      # openvpn3
      # zed-editor
      # kanidm_1_5
      # picocrypt 
       ocamlPackages.ssl
       libz
       dig
       sudo
       unzip
       binutils
      # myPackage
  ];

    	networking.firewall = {
	   enable = true;
	   allowedTCPPorts = [ 80 443 22 ];
	   allowedUDPPorts = [ 53 ];
	   extraCommands = ''
	iptables -A nixos-fw -m state --state ESTABLISHED,RELATED -j nixos-fw-accept
      	'';
	};
system.stateVersion = "24.11";
}
