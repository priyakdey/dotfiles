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
    lazy = false,
    config = function()
      require("nvim-treesitter.config").setup({
        ensure_installed = {
          "c",
          "lua",
          "bash",
          "json",
          "markdown",
          "go",
          "python",
          "rust",
          "java",
          "cpp",
          "javascript",
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  ----------------------------------------------------------
  -- Indent guides + current-scope highlight
  ----------------------------------------------------------
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl", -- v3's module name is "ibl", not the repo name
    config = function()
      require("ibl").setup({
        indent = { char = "│" }, -- faint line at every indent level
        scope = {
          enabled = true,    -- the brighter line for the block you're in (treesitter)
          show_start = true, -- underline the first line of the scope
          show_end = true,   -- underline the last line of the scope
        },
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
  -- LSP config 
  ----------------------------------------------------------

  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- c/c++
      vim.lsp.config("clangd", {
        cmd = { "clangd" },
        capabilities = capabilities,
        filetypes = { "c", "cpp" },
        root_markers = { ".git", "compile_commands.json", "Makefile" },
      })

      -- go
      vim.lsp.config("gopls", {
        cmd = {"gopls"},
        capabilities = capabilities,
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        root_markers = { "go.work", "go.mod", ".git" },
        settings = {
            gopls = {
                gofumpt = true,
                usePlaceholders = true,
                analyses = {
                    unusedparams = true,
                    shadow = true,
                },
            },
        },
    })
   
    -- python
    vim.lsp.config("pylsp", {
        cmd = { "pylsp" },
        filetypes = { "python" },
        root_markers = { ".git", "pyproject.toml", "requirements.txt", "Pipfile" },
        settings = {
            pylsp = {
                plugins = {
                    pycodestyle = { enabled = false },
                    mccabe = { enabled = false },
                    mccabe = { enabled = false },
                    ruff = { enabled = true },
                    autopep8 = { enabled = false },
                    yapf = { enabled = false },
                },
            },
        },
    })

    -- enable/disable lsp
    vim.lsp.enable("clangd")
    vim.lsp.enable("gopls")
    vim.lsp.enable("pylsp")
    
    end,
  },

  ------------------------------------------------------------
  -- Auto bracket pairs 
  ------------------------------------------------------------
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
        require("nvim-autopairs").setup({
            check_ts = true, -- uses treesitter
            enable_check_bracket_line = false,
        })
    end,
  },

  ------------------------------------------------------------
  -- Block Comments 
  ------------------------------------------------------------
  {
    "numToStr/Comment.nvim",
    config = function()
        require("Comment").setup()
    end,
  },


  ------------------------------------------------------------
  -- Code completions 
  ------------------------------------------------------------
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        local cmp = require("cmp")

        cmp.setup({
            completion = {
                completeopt = "menu,menuone,noinsert",
            },
            mapping = {
                ["<C-n>"] = cmp.mapping.select_next_item(),
                ["<C-p>"] = cmp.mapping.select_prev_item(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            },
            sources = {
                { name = "nvim_lsp" },
            },
        })
    end,
   },

  ------------------------------------------------------------
  -- Mason -- used ONLY to install jdtls (the Java server).
  -- clangd / gopls / pylsp stay system-installed as before.
  -- After first launch, run:  :MasonInstall jdtls
  ------------------------------------------------------------
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  ------------------------------------------------------------
  -- Java (jdtls) -- IntelliJ-like Java support.
  -- The server is started per-buffer in the "FileType java"
  -- autocmd below (jdtls can't use vim.lsp.enable like the
  -- others -- it needs a workspace dir resolved per project).
  ------------------------------------------------------------
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
  },

})



------------------------------------------------------------
-- Go auto format / imports on save 
------------------------------------------------------------
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
        vim.lsp.buf.format( {async = false })
    end,
})

------------------------------------------------------------
-- Python auto format / imports on save 
------------------------------------------------------------
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.py",
    callback = function()
        vim.lsp.buf.format( {async = false })
    end,
})

------------------------------------------------------------
-- Java (jdtls) -- starts the server per java buffer
------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    callback = function()
        local ok, jdtls = pcall(require, "jdtls")
        if not ok then
            return
        end

        -- locate project root (multi-module aware)
        local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
        local root_dir = require("jdtls.setup").find_root(root_markers)
        if not root_dir then
            return
        end

        -- per-project workspace so projects don't clobber each other
        local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
        local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls/workspace/" .. project_name

        -- prefer the Mason-installed launcher, fall back to PATH
        local mason_jdtls = vim.fn.stdpath("data") .. "/mason/bin/jdtls"
        local jdtls_bin = (vim.fn.executable(mason_jdtls) == 1) and mason_jdtls or "jdtls"

        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        jdtls.start_or_attach({
            cmd = { jdtls_bin, "-data", workspace_dir },
            root_dir = root_dir,
            capabilities = capabilities,
            settings = {
                java = {
                    signatureHelp = { enabled = true },
                    completion = {
                        favoriteStaticMembers = {
                            "org.junit.jupiter.api.Assertions.*",
                            "org.mockito.Mockito.*",
                            "java.util.Objects.requireNonNull",
                        },
                        importOrder = { "java", "javax", "com", "org" },
                    },
                    -- never collapse imports into wildcards (com.foo.*)
                    sources = {
                        organizeImports = {
                            starThreshold = 9999,
                            staticStarThreshold = 9999,
                        },
                    },
                    -- code generation (getters/setters/equals/toString)
                    codeGeneration = {
                        toString = {
                            template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                        },
                        useBlocks = true,
                    },
                },
            },
            init_options = {
                bundles = {},
            },
        })

        -- Java-only keymaps (in addition to the global LspAttach ones)
        local opts = { buffer = true }
        vim.keymap.set("n", "<leader>oi", jdtls.organize_imports, opts)
        vim.keymap.set("n", "<leader>ev", jdtls.extract_variable, opts)
        vim.keymap.set("n", "<leader>ec", jdtls.extract_constant, opts)
        vim.keymap.set("n", "<leader>em", jdtls.extract_method, opts)
        vim.keymap.set("v", "<leader>em", function()
            jdtls.extract_method(true)
        end, opts)
    end,
})

------------------------------------------------------------
-- Java auto format on save
------------------------------------------------------------
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.java",
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

------------------------------------------------------------
-- Diagnostic Configuration
------------------------------------------------------------
vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    underline = true,
    update_in_insert = false,
})


------------------------------------------------------------
-- Telescope shortcuts
------------------------------------------------------------

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files)
vim.keymap.set("n", "<leader>fg", builtin.live_grep)
vim.keymap.set("n", "<leader>fb", builtin.buffers)
vim.keymap.set("n", "<leader>fr", builtin.oldfiles)

------------------------------------------------------------
-- File explorer
------------------------------------------------------------

vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>")

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
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })

------------------------------------------------------------
-- Scratch buffer (VSCode-style "new untitled file")
--   :Scratch        jump to the one shared scratch buffer
--   :Save <path>    write current buffer to disk and adopt it
------------------------------------------------------------
local scratch_buf = nil

local function open_scratch()
  -- reuse the existing scratch buffer if it's still around
  if scratch_buf and vim.api.nvim_buf_is_valid(scratch_buf) then
    vim.api.nvim_set_current_buf(scratch_buf)
    return
  end

  -- nvim_create_buf(listed=true, scratch=true):
  --   scratch=true already sets buftype=nofile, bufhidden=hide, swapfile=off
  scratch_buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_buf_set_name(scratch_buf, "[Scratch]")
  vim.bo[scratch_buf].filetype = "markdown"
  vim.api.nvim_set_current_buf(scratch_buf)
end

vim.api.nvim_create_user_command(
  "Scratch",
  open_scratch,
  { desc = "Open the shared scratch buffer" }
)

vim.api.nvim_create_user_command("Save", function(opts)
  local path = vim.fn.fnamemodify(opts.args, ":p")     -- expand ~ and relative paths
  vim.cmd("write " .. vim.fn.fnameescape(path))         -- write contents to disk
  vim.cmd("edit "  .. vim.fn.fnameescape(path))         -- re-open as a real file buffer
end, { nargs = 1, complete = "file", desc = "Save current buffer to a path" })

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
    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float)

    vim.keymap.set("n", "<Esc>", function()
        -- close all floating windows
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local config = vim.api.nvim_win_get_config(win)
            if config.relative ~= "" then
                vim.api.nvim_win_close(win, false)
            end
        end
    end)

    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  end,
})

------------------------------------------------------------
-- Man page lookup
------------------------------------------------------------
vim.keymap.set("n", "<leader>m", ":Man ")


------------------------------------------------------------
-- Toggle Comment
------------------------------------------------------------
-- normal mode
vim.keymap.set("n", "<leader>/", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment" })

-- visual mode
vim.keymap.set("v", "<leader>/", function()
  local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
  vim.api.nvim_feedkeys(esc, "nx", false)
  require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, { desc = "Toggle comment (visual)" })


-- restore terminal cursor on exit
vim.cmd([[
    augroup RestoreCursorShapeOnExit
        autocmd!
        autocmd VimLeave * set guicursor=a:ver1
    augroup END
]])

