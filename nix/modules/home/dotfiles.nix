{ config, ... }:

let
  link = config.lib.file.mkOutOfStoreSymlink;
  dir = "/home/zoc/dotfiles";
in
{
  home.file = {
    ".config/nvim".source = link "${dir}/nvim";
    ".config/niri".source = link "${dir}/niri";
    ".config/matugen".source = link "${dir}/matugen";
    ".config/fastfetch".source = link "${dir}/fastfetch";
    ".config/fish".source = link "${dir}/fish";
    ".config/kitty".source = link "${dir}/kitty";
    ".config/ghostty".source = link "${dir}/ghostty";
    ".config/zed".source = link "${dir}/zed";
    ".config/zellij".source = link "${dir}/zellij";
    ".config/mimeapps.list".source = link "${dir}/mimeapps.list";
    ".config/quickshell".source = link "${dir}/quickshell";
  };
}
