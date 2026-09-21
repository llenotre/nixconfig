{ username, ... }:
{
  home-manager.users.${username} = {
    programs.git.userEmail = "llenotre@proton.me";
  };
}
