{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.rust;
in
{
  options.myConfig.rust = {
    enable = lib.mkEnableOption "Rust development toolchain";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      unstable.rustc       # rust compiler (from unstable for latest version)
      unstable.cargo       # rust package manager (from unstable)
      unstable.rust-analyzer  # rust language server (from unstable)
      unstable.clippy      # rust linter (from unstable)
      unstable.rustfmt     # rust formatter (from unstable)
      pkg-config           # helps find system libraries during compilation
      gcc                  # C compiler (needed for building Rust dependencies)
    ];
  };
}