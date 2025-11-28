{ lib, ... }:
{
  options.myConfig.users = {
    enable = lib.mkEnableOption "user account management";
  };

  imports = [
    ./users.nix
  ];
}
