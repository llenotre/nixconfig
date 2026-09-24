{ username, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit username; };
    backupFileExtension = "hm-bak";

    users.${username} = {
      home.stateVersion = "26.05";

      xdg.configFile."noctalia/brightness.toml".text = ''
        [brightness]
        enable_ddcutil = true
      '';

      services.flameshot = {
        enable = true;
        settings = {
          General = {
            useGrimAdapter = true;
            disabledGrimWarning = true;
          };
        };
      };

      programs.git = {
        enable = true;
        settings.user.name = "llenotre";
      };
    };
  };
}
