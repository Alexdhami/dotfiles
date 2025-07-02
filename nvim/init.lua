
-- ===================== LEADER KEY =====================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ===================== PLUGIN MANAGER (lazy.nvim) =====================
local lazypath = vim.fn.stdpath("config") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath
  })
end
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
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  {
    "neoclide/coc.nvim", -- optional: remove if only using nvim-cmp
    branch = "release"
  },
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",

  -- Treesitter
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- Statusline
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- Git
  "lewis6991/gitsigns.nvim",

  -- Harpoon
  "ThePrimeagen/harpoon",

  -- Theme
  "folke/tokyonight.nvim",

  -- Autopairs
  "windwp/nvim-autopairs",
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
lspconfig.lua_ls.setup {}

-- nvim-cmp setup
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
    ["<CR>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.confirm({ select = true })
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
  },
}

-- autopairs setup with cmp integration
require("nvim-autopairs").setup {}
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

-- gitsigns
require("gitsigns").setup()

-- harpoon
require("harpoon").setup()

-- ===================== CUSTOM KEYBINDINGS =====================
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Insert mode: jj or kk to exit
map("i", "jj", "<Esc>", opts)
map("i", "kk", "<Esc>", opts)

-- Ctrl+Backspace to delete previous word
map("i", "<C-BS>", "<C-W>", opts)

-- Ctrl+F to open search & replace in command mode
map("i", "<C-F>", "<Esc>:%s///g<Left><Left><Left>", opts)

-- Ctrl+Enter to save and run Python file
map("n", "<C-CR>", ":w<CR>:!python3 %<CR>", opts)

-- Completion menu navigation fallback
map("i", "<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true, silent = true })
map("i", "<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true, silent = true })

-- Toggle file explorer
map("n", "<C-n>", ":NvimTreeToggle<CR>", opts)

-- Alt-based window navigation
map("n", "<A-h>", "<C-w>h", opts)
map("n", "<A-l>", "<C-w>l", opts)
map("n", "<A-j>", "<C-w>j", opts)
map("n", "<A-k>", "<C-w>k", opts)

-- Auto-install specific LSPs using mason-lspconfig when in headless mode
if vim.fn.has("nvim") == 1 and #vim.api.nvim_list_uis() == 0 then
  vim.defer_fn(function()
    local mlsp = require("mason-lspconfig")
    mlsp.setup_handlers({
      function(server_name)
        require("lspconfig")[server_name].setup {}
      end
    })
    vim.cmd("MasonInstall lua-language-server pyright tsserver")
  end, 100)
end



local lspconfig = require("lspconfig")

local on_attach = function(client, bufnr)
  -- your attach code if any, or leave empty
end

local root_dir = function(fname)
  -- Always use current working directory as root
  return vim.loop.cwd()
end

lspconfig.pyright.setup {
  on_attach = on_attach,
  root_dir = root_dir,
}

lspconfig.lua_ls.setup {
  on_attach = on_attach,
  root_dir = root_dir,
}

