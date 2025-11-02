{ config, lib, pkgs, ... }:

{
  # Rust development toolchain
  environment.systemPackages = with pkgs; [
    rustc                # rust compiler
    cargo                # rust package manager
    rust-analyzer        # rust language server
    clippy               # rust linter
    rustfmt              # rust formatter
    pkg-config           # helps find system libraries during compilation
  ];
}