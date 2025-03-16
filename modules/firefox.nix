{ config, lib, pkgs, ... }:

{
  options.custom.firefox = {
    enable = lib.mkOption {
      default = false;
      example = true;
    };
  };

  config = lib.mkIf config.custom.firefox.enable {
    programs.firefox = {
      enable = true;
      preferences = {
        "media.ffmpeg.vaapi.enabled" = true;
        "media.rdd-ffmpeg.enabled" = true;
        "media.av1.enabled" = true;
        "gfx.x11-egl.force-enabled" = true;
        "widget.dmabuf.force-enabled" = true;
        "gfx.webrender.enabled" = true;
        "layers.acceleration.force-enabled" = true;
      };
    };
  };
}
