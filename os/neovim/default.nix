{
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
          # harpoon
          # undotree
          # vim-fugitive
          # nvim-cmp
          # cmp-buffer
          # cmp-path
          # cmp_luasnip
          # cmp-nvim-lsp
          # cmp-nvim-lua
          # luasnip
          # friendly-snippets
          # surround-nvim
        ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    nil
    rustfmt
    rust-analyzer
    cargo
    lua-language-server
    ripgrep
    ghc
    haskell-language-server
    # java-language-server
    # asm-lsp
    # bash-language-server
    # ccls
  ];
}
