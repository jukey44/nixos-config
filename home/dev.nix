{ pkgs, ... }: {
  programs.zed-editor = {
    enable = true;
    extensions = [ "nix" "toml" ];
    userSettings = {
      load_direnv = "shell_hook";
      lsp.rust-analyzer.initialization_options.check.command = "clippy";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
