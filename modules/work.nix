{ username, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    clever-tools
    slack
  ];

  services = {
    osquery = {
      enable = true;
      flags = {
        flagfile = "/etc/osquery/osquery.flags";
      };
    };

    clamav.daemon.enable = true;
    clamav.daemon.settings = {
      OnAccessExcludeUname="clamav";
      OnAccessIncludePath="/home/${username}/Downloads";
      VirusEvent="/usr/bin/clamav-notify-cc.sh";
    };
    clamav.updater.enable = true;
  };
  systemd.services = {
    clamav-freshclam.wants = [ "network-online.target" ];
    clamav-daemon = {
      path = [ pkgs.bash pkgs.nix pkgs.coreutils-full pkgs.hostname pkgs.curl ];
      serviceConfig = pkgs.lib.mkForce {
        ExecStart = "${pkgs.clamav}/bin/clamd";
        ExecReload = "${pkgs.coreutils}/bin/kill -USR2 $MAINPID";
        User = "clamav";
        Group = "clamav";
        StateDirectory = "clamav";
        RuntimeDirectory = "clamav";
        PrivateNetwork = "no";
      };
    };
    clamav-clamonacc = {
      enable = true;
      path = [ pkgs.nix pkgs.bash ];
      unitConfig = {
        Description="ClamAV daemon for on-access scanning";
        Wants="network-online.target";
        After="network-online.target syslog.target";
        Requires="clamav-daemon.service";
      };
      serviceConfig = {
        Type="simple";
        ExecStartPre="${pkgs.bash}/bin/bash -c \"while [ ! -S /run/clamav/clamd.ctl ]; do sleep 1; done\"";
        ExecStart="${pkgs.clamav}/bin/clamonacc --foreground --stream --move=/root/quarantine";
        Restart="on-failure";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
