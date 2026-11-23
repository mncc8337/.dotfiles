--[[ common settings ]]
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.cmdheight = 0
vim.opt.number = true
vim.diagnostic.config({ virtual_text = true })

vim.opt.foldcolumn = "1"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

vim.opt.timeout = true
vim.opt.timeoutlen = 1000

vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo"

--[[ plugins ]]

-- build steps for plugins that need them, keyed by plugin name (see :help vim.pack-events)
-- cmd: external command (argument list), :command (string), or function(ev)
-- load: packadd the plugin first (for :commands when the plugin isn't active)
local pack_build = {
    ["nvim-treesitter"] = { cmd = "TSUpdate", load = true },
}

vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        if ev.data.kind ~= "install" and ev.data.kind ~= "update" then
            return
        end
        local build = pack_build[ev.data.spec.name]
        if not build then
            return
        end
        if type(build.cmd) == "function" then
            build.cmd(ev)
        elseif type(build.cmd) == "string" then
            if build.load and not ev.data.active then
                vim.cmd.packadd(ev.data.spec.name)
            end
            vim.cmd(build.cmd)
        else
            vim.system(build.cmd, { cwd = ev.data.path }):wait()
        end
    end,
})

-- NOTE: dependencies must be listed before the plugins that need them
local function gh(x) return "https://github.com/" .. x end
vim.pack.add({
    gh("nvim-tree/nvim-web-devicons"),
    gh("RRethy/base16-nvim"),
    gh("lukas-reineke/indent-blankline.nvim"),
    gh("NvChad/nvim-colorizer.lua"),

    gh("nvim-lua/plenary.nvim"),
    gh("nvim-telescope/telescope.nvim"),
    gh("kevinhwang91/promise-async"),
    gh("kevinhwang91/nvim-ufo"),

    gh("nvim-treesitter/nvim-treesitter"),
    gh("echasnovski/mini.nvim"),

    gh("mason-org/mason.nvim"),
    gh("neovim/nvim-lspconfig"),
    gh("mason-org/mason-lspconfig.nvim"),
    gh("saghen/blink.cmp"),
    gh("stevearc/conform.nvim"),

    -- extras
    gh("keaising/im-select.nvim"),
})

require("base16-colorscheme").setup()
vim.cmd.colorscheme("base16-nord-light")

require("ibl").setup({
    indent = { char = "╎" },
})
require("colorizer").setup()
require("ufo").setup()

local function setup_treesitter()
    local ts = require("nvim-treesitter")
    local ignore_filetypes = {
        "checkhealth", "mason", "conform-info", "man", "text", "minifiles",
    }

    local function start(buf, lang)
        if not pcall(vim.treesitter.start, buf, lang) then
            return false
        end
        vim.bo[buf].indentexpr = 'v:lua.require("nvim-treesitter").indentexpr()'
        return true
    end

    ts.install({ "c", "cpp", "python" }, { max_jobs = 8 })

    vim.api.nvim_create_autocmd("FileType", {
        desc = "Enable treesitter highlighting and indentation (non-blocking)",
        callback = function(ev)
            if vim.tbl_contains(ignore_filetypes, ev.match) then
                return
            end
            local lang = vim.treesitter.language.get_lang(ev.match) or ev.match
            local buf = ev.buf

            if start(buf, lang) then
                return
            end

            -- parser not installed yet. install it, then retry on completion
            ts.install({ lang }):await(function()
                if vim.api.nvim_buf_is_valid(buf) then
                    start(buf, lang)
                end
            end)
        end,
    })
end
setup_treesitter()

require("mini.pairs").setup()
require("mini.move").setup()
require("mini.cursorword").setup()
require("mini.splitjoin").setup {
    mappings = { toggle = " j" },
}
require("mini.surround").setup {
    highlight_duration = 500,
    mappings = {
        add = "sa",
        delete = "sd",
        find = "sf",
        find_left = "sF",
        highlight = "sh",
        replace = "sr",
        update_n_lines = "sn",
        suffix_last = "l",
        suffix_next = "n",
    },
    n_lines = 20,
    respect_selection_type = false,
    search_method = "cover",
}
require("mini.files").setup()
require("mini.statusline").setup()
require("mini.diff").setup()

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "clangd", "pylsp" },
})

require("blink.cmp").setup({
    keymap = {
        preset = "none",
        ["<Enter>"] = { "accept", "fallback" },
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<C-e>"] = { "hide", "fallback" },
    },
    appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
    },
    sources = {
        default = { "lsp", "path", "snippets", "buffer" },
    },
    cmdline = {
        enabled = true,
        keymap = {
            preset = "cmdline",
            ["<Right>"] = false,
            ["<Left>"] = false,
        },
        completion = {
            list = { selection = { preselect = false } },
            menu = {
                auto_show = function(_)
                    return vim.fn.getcmdtype() == ":"
                end,
            },
            ghost_text = { enabled = true },
        },
    },
})

require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        c = { "clang-format" },
        cpp = { "clang-format" },
    },
})

require('im_select').setup({
    default_im_select  = "keyboard-us",
    default_command = "fcitx5-remote",

    -- Restore the default input method state when the following events are triggered
    -- "VimEnter" and "FocusGained" were removed for causing problems, add it by your needs
    set_default_events = { "InsertLeave", "CmdlineLeave" },

    -- Restore the previous used input method state when the following events
    -- are triggered, if you don't want to restore previous used im in Insert mode,
    -- e.g. deprecated `disable_auto_restore = 1`, just let it empty
    -- as `set_previous_events = {}`
    set_previous_events = { "InsertEnter" },

    -- Show notification about how to install executable binary when binary missed
    keep_quiet_on_no_binary = false,

    -- Async run `default_command` to switch IM or not
    async_switch_im = true
})

--[[ lsp config ]]
vim.lsp.config("*", {
    capabilities = require("blink.cmp").get_lsp_capabilities(),
})

vim.lsp.config("tinymist", {
    settings = {
        exportPdf = "onSave",
        formatterMode = "typstyle",
    }
})

vim.lsp.config("pylsp", {
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = {
                    ignore = { "E203" },
                    maxLineLength = 88,
                },
                flake8 = {
                    ignore = { "E203" },
                    maxLineLength = 88,
                },
            },
        },
    },
})

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            format = {
                enable = false,
            },
            hint = {
                enable = true,
                arrayIndex = "Disable", -- "Enable", "Auto", "Disable"
                await = true,
                paramName = "All", -- "All", "Literal", "Disable"
                paramType = true,
                semicolon = "Disable", -- "All", "SameLine", "Disable"
                setType = true,
            },
            diagnostics = {
                globals = {
                    "vim",
                    "awesome",
                    "client",
                    "tag",
                    "screen",
                },
            },
            runtime = {
                version = "LuaJIT",
            },
            workspace = {
                checkThirdParty = false,
            },
        },
    },
})

--[[ custom modules ]]
require("mappings")

local utils = require("utils")
utils.set_filetype_option({ "c", "cpp" }, "commentstring", "// %s")
