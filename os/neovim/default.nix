{
  pkgs-unstable,
  pkgs,
  # TODO: depend on global color
  ...
}:

{
  environment.variables.EDITOR = "nvim";

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    configure = {
      customLuaRC = builtins.readFile ./init.lua;
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
          nvim-treesitter.withAllGrammars
          nvim-lspconfig
          render-markdown-nvim
          telescope-nvim
          telescope-file-browser-nvim
          plenary-nvim # dependency for telescope-file-browser
          vim-sleuth
          undotree
        ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    nil
    rustfmt
    pkgs-unstable.rust-analyzer
    pkgs-unstable.cargo
    lua-language-server
    ripgrep
    ghc
    haskell-language-server
    bash-language-server
  ];
}
