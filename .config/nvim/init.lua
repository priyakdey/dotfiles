---------------------------------------------------------
-- ▗▖ ▖        ▗  ▖ ▝           ▗▄          ▗▀  ▝      --
-- ▐▚ ▌ ▄▖  ▄▖ ▝▖▗▘▗▄  ▗▄▄     ▗▘ ▘ ▄▖ ▗▗▖ ▗▟▄ ▗▄   ▄▄ --
-- ▐▐▖▌▐▘▐ ▐▘▜  ▌▐  ▐  ▐▐▐     ▐   ▐▘▜ ▐▘▐  ▐   ▐  ▐▘▜ --
-- ▐ ▌▌▐▀▀ ▐ ▐  ▚▞  ▐  ▐▐▐     ▐   ▐ ▐ ▐ ▐  ▐   ▐  ▐ ▐ --
-- ▐ ▐▌▝▙▞ ▝▙▛  ▐▌ ▗▟▄ ▐▐▐      ▚▄▘▝▙▛ ▐ ▐  ▐  ▗▟▄ ▝▙▜ --
--                                                  ▖▐ --
--                                                  ▝▘ --
---------------------------------------------------------

vim.g.mapleader = " "
vim.g.maplocalleader = " "

------------------------------------------------------------
-- Editor options
------------------------------------------------------------

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.updatetime = 200
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.opt.colorcolumn = "100"
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

------------------------------------------------------------
-- Restore cursor position
------------------------------------------------------------

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

------------------------------------------------------------
-- Bootstrap lazy.nvim
------------------------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

------------------------------------------------------------
-- Plugins
------------------------------------------------------------

require("lazy").setup({

  ----------------------------------------------------------
  -- Theme
  ----------------------------------------------------------

  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      require("gruvbox").setup({
        contrast = "hard",
      })
      vim.cmd.colorscheme("gruvbox")
    end,
  },

  ----------------------------------------------------------
  -- Icons
  ----------------------------------------------------------

  { "nvim-tree/nvim-web-devicons" },

  ----------------------------------------------------------
  -- Statusline
  ----------------------------------------------------------

  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          theme = "gruvbox",
          globalstatus = true,
        },
      })
    end,
  },

  ----------------------------------------------------------
  -- File explorer
  ----------------------------------------------------------

  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      require("nvim-tree").setup({
        view = { width = 35 },
      })
    end,
  },

  ----------------------------------------------------------
  -- Telescope fuzzy finder
  ----------------------------------------------------------

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require("telescope")

      telescope.setup({
        defaults = {
          layout_config = {
            prompt_position = "top",
          },
          sorting_strategy = "ascending",
        },
      })

      telescope.load_extension("fzf")
    end,
  },

  ----------------------------------------------------------
  -- Treesitter
  ----------------------------------------------------------

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = {
          "c",
          "lua",
          "bash",
          "json",
          "markdown",
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  ----------------------------------------------------------
  -- Git signs
  ----------------------------------------------------------

  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  ----------------------------------------------------------
  -- LSP config (clangd)
  ----------------------------------------------------------

  {
    "neovim/nvim-lspconfig",
    config = function()

      vim.lsp.config("clangd", {
        cmd = { "clangd" },
        filetypes = { "c", "cpp" },
        root_markers = { ".git", "compile_commands.json", "Makefile" },
      })

      vim.lsp.enable("clangd")

    end,
  },

})

------------------------------------------------------------
-- Telescope shortcuts
------------------------------------------------------------

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files)
vim.keymap.set("n", "<leader>fg", builtin.live_grep)
vim.keymap.set("n", "<leader>fb", builtin.buffers)
vim.keymap.set("n", "<leader>fr", builtin.oldfiles)

vim.keymap.set("n", "<C-p>", builtin.find_files)

------------------------------------------------------------
-- File explorer
------------------------------------------------------------

vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>")
vim.keymap.set("n", "<C-e>", "<cmd>NvimTreeToggle<CR>")

------------------------------------------------------------
-- Window navigation
------------------------------------------------------------

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

------------------------------------------------------------
-- Save / quit
------------------------------------------------------------

vim.keymap.set("n", "<C-s>", "<cmd>w<CR>")
vim.keymap.set("n", "<C-q>", "<cmd>q<CR>")

------------------------------------------------------------
-- LSP keymaps
------------------------------------------------------------

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = { buffer = ev.buf }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)

    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  end,
})

------------------------------------------------------------
-- Man page lookup
------------------------------------------------------------

vim.keymap.set("n", "<leader>m", ":Man ")

-- restore terminal cursor on exit
vim.cmd([[
    augroup RestoreCursorShapeOnExit
        autocmd!
        autocmd VimLeave * set guicursor=a:ver1
    augroup END
]])

