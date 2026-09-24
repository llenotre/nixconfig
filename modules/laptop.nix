{ pkgs, username, ... }:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # External monitors expose no sysfs backlight, so their brightness is only
  # reachable over DDC/CI
  hardware.i2c.enable = true;
  users.users.${username}.extraGroups = [ "i2c" ];
  environment.systemPackages = [ pkgs.ddcutil ];
}
