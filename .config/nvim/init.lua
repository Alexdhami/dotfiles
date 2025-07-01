
-- ===================== LEADER KEY =====================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ===================== PLUGIN MANAGER (lazy.nvim) =====================
local lazypath = vim.fn.stdpath("config") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- File Explorer
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- Fuzzy Finder
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- LSP Support
  "neovim/nvim-lspconfig",
  { "williamboman/mason.nvim", build = ":MasonUpdate" },
  "williamboman/mason-lspconfig.nvim",

  -- Autocompletion
  "hrsh7th/cmp-nvim-lsp",
 "hrsh7th/nvim-cmp",
{
  "neoclide/coc.nvim",
  branch = "release"
},
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",

  -- Treesitter (Syntax highlighting)
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- Statusline
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- Git indicators
  "lewis6991/gitsigns.nvim",

  -- Harpoon (ThePrimeagen's quick nav)
  "ThePrimeagen/harpoon",

  -- Theme
  "folke/tokyonight.nvim",
})

-- ===================== BASIC SETTINGS =====================
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"
vim.o.clipboard = "unnamedplus"
vim.o.termguicolors = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2

-- ===================== COLORS =====================
vim.cmd("colorscheme tokyonight")

-- ===================== PLUGIN SETUP =====================

-- nvim-tree
require("nvim-tree").setup()

-- lualine
require("lualine").setup {
  options = { theme = "tokyonight" }
}

-- treesitter
require("nvim-treesitter.configs").setup {
  highlight = { enable = true },
  indent = { enable = true }
}

-- mason
require("mason").setup()
require("mason-lspconfig").setup()

-- LSP
local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup {}  -- Example LSP (Lua language server)

-- cmp setup
local cmp = require("cmp")
local luasnip = require("luasnip")
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
  },
}

-- gitsigns
require("gitsigns").setup()

-- harpoon
require("harpoon").setup()

-- ===================== CUSTOM KEYBINDINGS =====================
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Insert mode: jj or kk to exit insert mode
map("i", "jj", "<Esc>", opts)
map("i", "kk", "<Esc>", opts)

-- Ctrl+Backspace to delete previous word
map("i", "<C-BS>", "<C-W>", opts)

-- Ctrl+F to open search & replace in command mode
map("i", "<C-F>", "<Esc>:%s///g<Left><Left><Left>", opts)

-- Enter key: confirm popup if visible (for CoC-style behavior)
-- If using nvim-cmp (you are), it’s already handled in cmp.mapping above

-- Ctrl+Enter to save and run Python file (Normal mode)
map("n", "<C-CR>", ":w<CR>:!python3 %<CR>", opts)

-- Tab / Shift-Tab in insert mode: completion menu navigation
-- Already set in cmp.mapping above, but if you'd like to reinforce manually:
map("i", "<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true, silent = true })
map("i", "<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true, silent = true })

-- Ctrl+n to toggle file explorer
map("n", "<C-n>", ":NvimTreeToggle<CR>", opts)

-- Easier window navigation with Alt+h/j/k/l
map("n", "<A-h>", "<C-w>h", opts)
map("n", "<A-l>", "<C-w>l", opts)
map("n", "<A-j>", "<C-w>j", opts)
map("n", "<A-k>", "<C-w>k", opts)
