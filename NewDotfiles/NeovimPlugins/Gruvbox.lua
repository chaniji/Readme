-- ~/.config/nvim/lua/plugins/colorscheme.lua
return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    opts = {},
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
}
