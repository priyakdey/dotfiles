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
vim.opt.colorcolumn = "80"
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- persistent undo -- undo history survives closing the file.
-- history lives in ~/.local/state/nvim/undo/
vim.opt.undofile = true

-- more useful diffs (nvim -d):
--- ignore whitespace, use histogram algorithm, and indent heuristic.
--- https://vimways.org/2018/the-power-of-diff/
vim.opt.diffopt:append("iwhite")
vim.opt.diffopt:append("algorithm:histogram")
vim.opt.diffopt:append("indent-heuristic")

------------------------------------------------------------
-- Highlight yanked text briefly
------------------------------------------------------------

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

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

  -- jonhoo's gruvbox: base16-nvim's gruvbox-dark-hard + a few highlight tweaks.
  {
    "wincent/base16-nvim",
    lazy = false,    -- load at start
    priority = 1000, -- load first
    config = function()
      vim.cmd([[colorscheme gruvbox-dark-hard]])
      local marked = vim.api.nvim_get_hl(0, { name = "PMenu" })
      local bools = vim.api.nvim_get_hl(0, { name = 'Boolean' })
	  vim.api.nvim_set_hl(0, 'Comment', bools)
      -- doc comments (javadoc /** */, the newer ///, etc.) get their own
      -- color so they stand out from regular // comments, which got
      -- remapped to the Boolean color above. Reuse the same green as
      -- directories in the file explorer.
      local dirs = vim.api.nvim_get_hl(0, { name = 'Directory' })
      vim.api.nvim_set_hl(0, '@comment.documentation', dirs)
      vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", {
        fg = marked.fg,
        bg = marked.bg,
        ctermfg = marked.ctermfg,
        ctermbg = marked.ctermbg,
        bold = true,
      })
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
    branch = "main", -- `main` is the current rewrite; required for Neovim 0.11+
    build = ":TSUpdate",
    lazy = false,
    config = function()
      -- install the parsers we care about (async, no-op if already present)
      require("nvim-treesitter").install({
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
        "typescript",
        "tsx",
      })

      -- the `main` branch does NOT auto-enable highlighting/indent the way
      -- `master`'s setup({ highlight = { enable = true } }) did. We turn it on
      -- per-buffer: for any filetype that has a parser, start treesitter and
      -- wire up treesitter-based indentation.
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          -- vim.treesitter.start resolves the language from the filetype
          -- (e.g. sh -> bash) and errors if no parser is installed, so pcall it.
          if pcall(vim.treesitter.start, ev.buf) then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
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
          show_start = false, -- underline the first line of the scope
          show_end = false,   -- underline the last line of the scope
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
                    ruff = { enabled = true },
                    autopep8 = { enabled = false },
                    yapf = { enabled = false },
                },
            },
        },
    })

    -- typescript / javascript / react (jsx + tsx)
    -- install once:  npm install -g typescript typescript-language-server
    vim.lsp.config("ts_ls", {
        cmd = { "typescript-language-server", "--stdio" },
        capabilities = capabilities,
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
    })

    -- enable/disable lsp
    vim.lsp.enable("clangd")
    vim.lsp.enable("gopls")
    vim.lsp.enable("pylsp")
    vim.lsp.enable("ts_ls")

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
-- Per-filetype format-on-save (Go / Python) -- now handled by the
-- generic capability-gated format-on-save in the LspAttach autocmd.
-- Kept here (commented) in case you want to restore per-filetype control.
------------------------------------------------------------
--[[
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
        vim.lsp.buf.format( {async = false })
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.py",
    callback = function()
        vim.lsp.buf.format( {async = false })
    end,
})
--]]

------------------------------------------------------------
-- Formatting
--   :Format    format the current buffer
--   on save    json -> jq, yaml -> yq,
--              js/ts(x) -> project prettier if the project uses it,
--              everything else -> LSP (ruff via pylsp for Python,
--              gofmt via gopls for Go, ts_ls when no prettier)
------------------------------------------------------------
local external_formatters = {
  json = { "jq", "." },
  yaml = { "yq", "-y", "." },   -- python yq (jq wrapper): -y = YAML output
}

-- run a stdin/stdout formatter over the buffer, writing back only on change
-- so undo history and marks stay untouched when already formatted
local function run_stdin_formatter(bufnr, cmd)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local res = vim.system(cmd, {
    stdin = table.concat(lines, "\n"),
    text = true,
  }):wait()
  if res.code ~= 0 then
    vim.notify(cmd[1] .. ": " .. vim.trim(res.stderr or ""), vim.log.levels.ERROR)
    return
  end
  local out = vim.split(res.stdout, "\n")
  if out[#out] == "" then
    table.remove(out)
  end
  if not vim.deep_equal(out, lines) then
    local view = vim.fn.winsaveview()
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, out)
    vim.fn.winrestview(view)
  end
end

local prettier_filetypes = {
  javascript = true,
  javascriptreact = true,
  typescript = true,
  typescriptreact = true,
}

local prettier_config_files = {
  ".prettierrc", ".prettierrc.json", ".prettierrc.yml", ".prettierrc.yaml",
  ".prettierrc.json5", ".prettierrc.js", ".prettierrc.cjs", ".prettierrc.mjs",
  ".prettierrc.toml", "prettier.config.js", "prettier.config.cjs",
  "prettier.config.mjs",
}

-- prettier command for this buffer, or nil when the project doesn't use
-- prettier (no config file and no "prettier" key in package.json) -- the
-- caller then falls through to LSP formatting (ts_ls)
local function prettier_cmd(bufnr)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  if fname == "" then
    return nil
  end
  local dir = vim.fs.dirname(fname)

  local has_config = #vim.fs.find(prettier_config_files, { path = dir, upward = true }) > 0
  if not has_config then
    local pkg = vim.fs.find("package.json", { path = dir, upward = true })[1]
    if pkg then
      local ok, decoded = pcall(vim.json.decode, table.concat(vim.fn.readfile(pkg), "\n"))
      has_config = ok and type(decoded) == "table" and decoded.prettier ~= nil
    end
  end
  if not has_config then
    return nil
  end

  -- prefer the project's own prettier so versions/plugins match the repo
  local nm = vim.fs.find("node_modules", { path = dir, upward = true, type = "directory" })[1]
  local local_bin = nm and (nm .. "/.bin/prettier")
  if local_bin and vim.fn.executable(local_bin) == 1 then
    return { local_bin, "--stdin-filepath", fname }
  end
  if vim.fn.executable("prettier") == 1 then
    return { "prettier", "--stdin-filepath", fname }
  end
  vim.notify("project uses prettier but it isn't installed; falling back to LSP formatting",
    vim.log.levels.WARN)
  return nil
end

local function format_buffer(bufnr, opts)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  opts = opts or {}

  local cmd = external_formatters[vim.bo[bufnr].filetype]
  if cmd then
    if vim.fn.executable(cmd[1]) ~= 1 then
      vim.notify(cmd[1] .. " not installed, cannot format", vim.log.levels.WARN)
      return
    end
    run_stdin_formatter(bufnr, cmd)
    return
  end

  if prettier_filetypes[vim.bo[bufnr].filetype] then
    local prettier = prettier_cmd(bufnr)
    if prettier then
      run_stdin_formatter(bufnr, prettier)
      return
    end
  end

  local clients = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/formatting" })
  if #clients == 0 then
    if opts.verbose then
      vim.notify("no formatter available for this buffer", vim.log.levels.WARN)
    end
    return
  end
  vim.lsp.buf.format({ async = false, bufnr = bufnr })
end

vim.api.nvim_create_user_command("Format", function()
  format_buffer(nil, { verbose = true })
end, { desc = "Format the current buffer" })

-- Format-on-save for every buffer; format_buffer no-ops when the buffer
-- has neither an external formatter nor an LSP that can format.
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("FormatOnSave", {}),
  callback = function(ev)
    format_buffer(ev.buf)
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
                    -- format on save uses google-java-format's rules (2-space
                    -- indent) via the Eclipse profile XML, so nvim matches
                    -- Spotless/google-java-format in CI.
                    format = {
                        settings = {
                            url = vim.fn.expand("~/.config/nvim/eclipse-java-google-style.xml"),
                            profile = "GoogleStyle",
                        },
                    },
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
-- Java auto format on save -- now handled by the generic
-- capability-gated format-on-save in the LspAttach autocmd.
------------------------------------------------------------
--[[
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.java",
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})
--]]

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
-- Keep search results centered on screen
------------------------------------------------------------
vim.keymap.set("n", "n", "nzz", { silent = true })
vim.keymap.set("n", "N", "Nzz", { silent = true })
vim.keymap.set("n", "*", "*zz", { silent = true })
vim.keymap.set("n", "#", "#zz", { silent = true })
vim.keymap.set("n", "g*", "g*zz", { silent = true })

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
--   :SScratch       open it in a horizontal split
--   :VScratch       open it in a vertical split
--   :Save <path>    write current buffer to disk and adopt it
------------------------------------------------------------
local scratch_buf = nil

local function open_scratch(split)
  -- reuse the existing scratch buffer if it's still around
  if not (scratch_buf and vim.api.nvim_buf_is_valid(scratch_buf)) then
    -- nvim_create_buf(listed=true, scratch=true):
    --   scratch=true already sets buftype=nofile, bufhidden=hide, swapfile=off
    scratch_buf = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_buf_set_name(scratch_buf, "[Scratch]")
    vim.bo[scratch_buf].filetype = "markdown"
  end

  if split then
    vim.cmd(split)
  end
  vim.api.nvim_set_current_buf(scratch_buf)
end

vim.api.nvim_create_user_command("Scratch", function()
  open_scratch()
end, { desc = "Open the shared scratch buffer" })

vim.api.nvim_create_user_command("SScratch", function()
  open_scratch("split")
end, { desc = "Open the shared scratch buffer in a horizontal split" })

vim.api.nvim_create_user_command("VScratch", function()
  open_scratch("vsplit")
end, { desc = "Open the shared scratch buffer in a vertical split" })

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

    -- Format-on-save lives in the global FormatOnSave BufWritePre autocmd
    -- (see the Formatting section), which falls back to LSP formatting here.
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

