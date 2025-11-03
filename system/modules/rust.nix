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
      rustc                # rust compiler
      cargo                # rust package manager
      rust-analyzer        # rust language server
      clippy               # rust linter
      rustfmt              # rust formatter
      pkg-config           # helps find system libraries during compilation
    ];
  };
}