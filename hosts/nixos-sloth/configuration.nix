{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
  ];

  networking.hostName = "nixos-sloth";
  networking.useDHCP = true;

  boot.loader.grub.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH5pJCHvA95NFEhrrxNEX0wuFUJx2v1O+ZjHMWk88NC8 nixos-sloth-deploy"
  ];

  networking.firewall.allowedTCPPorts = [ 22 ];

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      "registry-mirrors" = [ "https://docker.m.daocloud.io" ];
    };
  };

  environment.systemPackages = with pkgs; [
    nettools
    vim
    lrzsz
    wget
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05";
}
