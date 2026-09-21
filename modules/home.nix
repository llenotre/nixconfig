{ username, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit username; };
    backupFileExtension = "hm-bak";

    users.${username} = {
      home.stateVersion = "26.05";

      programs.git = {
        enable = true;
        userName = "llenotre";
      };
    };
  };
}
