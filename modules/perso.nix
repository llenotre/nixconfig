{ username, ... }:
{
  home-manager.users.${username} = {
    programs.git.settings.user.email = "llenotre@proton.me";
  };
}
