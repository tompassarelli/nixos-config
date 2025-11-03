{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.development;
in
{
  options.myConfig.development = {
    enable = lib.mkEnableOption "development tools and programming utilities";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
    # Editor / Search
    vim                  # default general purpose text editor
    #unstable.zed-editor # open source editor
    unstable.claude-code # anthropic claude cli
    ripgrep              # search
    fd                   # find files
    unzip                # relax and decompress

    # Data Transfer & Requests
    wget                 # download things
    curl                 # test APIs, debug HTTP, pipe stuff

    # Convert images
    imagemagick          # work with images
    ghostscript          # for adobe

    # Web
    nodejs               # for webjoyers
    #ungoogled-chromium  # fallback

    # Python
    python3              # i'm a snake

    # Version Control
    gh                   # github cli
    delta                # beautiful git diffs
    ];
  };
}
