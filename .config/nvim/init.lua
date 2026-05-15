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

-- disable netrw to use nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

--[[ lazy.nvim bootstrap ]]
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

--[[ plugins ]]
require("lazy").setup({
    {
        "RRethy/base16-nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("base16-colorscheme").setup()
            vim.cmd.colorscheme("base16-nord-light")
        end,
    },

    {
        "akinsho/bufferline.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                indicator = { style = "none" },
                diagnostics = "nvim_lsp",
                diagnostics_indicator = function(count, level)
                    local icon = level:match("error") and " " or " "
                    return " " .. icon .. count
                end,
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = "File Explorer",
                        text_align = "center",
                        separator = true,
                    },
                },
            },
        },
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = true,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {
            indent = { char = "╎" },
        },
    },
    { "NvChad/nvim-colorizer.lua", config = true },
    {
        "stevearc/dressing.nvim",
        opts = { input = { border = "solid" } },
    },
    { "nvim-tree/nvim-web-devicons" },

    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        lazy = false,
        config = true,
    },
    {
        "kevinhwang91/nvim-ufo",
        dependencies = "kevinhwang91/promise-async",
        config = true,
    },

    {
        -- straight up copying from
        -- https://www.reddit.com/r/neovim/comments/1pndf9e/my_new_nvimtreesitter_configuration_for_the_main/
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        branch = "main",
        build = ":TSUpdate",
        config = function()
            local ts = require("nvim-treesitter")

            local parsers_loaded = {}
            local parsers_pending = {}
            local parsers_failed = {}

            local ns = vim.api.nvim_create_namespace("treesitter.async")

            local function start(buf, lang)
                local ok = pcall(vim.treesitter.start, buf, lang)
                if ok then
                    vim.bo[buf].indentexpr = 'v:lua.require("nvim-treesitter").indentexpr()'
                end
                return ok
            end

            vim.api.nvim_create_autocmd("User", {
                pattern = "LazyDone",
                once = true,
                callback = function()
                    ts.install({
                        "c",
                        "cpp",
                        "python",
                    }, {
                        max_jobs = 8,
                    })
                end,
            })

            vim.api.nvim_set_decoration_provider(ns, {
                on_start = vim.schedule_wrap(function()
                    if #parsers_pending == 0 then
                        return false
                    end
                    for _, data in ipairs(parsers_pending) do
                        if vim.api.nvim_buf_is_valid(data.buf) then
                            if start(data.buf, data.lang) then
                                parsers_loaded[data.lang] = true
                            else
                                parsers_failed[data.lang] = true
                            end
                        end
                    end
                    parsers_pending = {}
                end),
            })

            local group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true })

            local ignore_filetypes = {
                "checkhealth",
                "lazy",
                "lazy_backdrop",
                "mason",
                "NvimTree",
                "conform-info",
                "man",
            }

            vim.api.nvim_create_autocmd("FileType", {
                group = group,
                desc = "Enable treesitter highlighting and indentation (non-blocking)",
                callback = function(event)
                    if vim.tbl_contains(ignore_filetypes, event.match) then
                        return
                    end

                    local lang = vim.treesitter.language.get_lang(event.match) or event.match
                    local buf = event.buf

                    if parsers_failed[lang] then
                        return
                    end

                    if parsers_loaded[lang] then
                        start(buf, lang)
                    else
                        table.insert(parsers_pending, { buf = buf, lang = lang })
                    end

                    ts.install({ lang })
                end,
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        opts = {
            max_lines = 4,
            multiline_threshold = 2,
        },
    },

    {
        "echasnovski/mini.nvim",
        version = false,
        config = function()
            require("mini.pairs").setup()
            require("mini.move").setup()
            require("mini.cursorword").setup()
            require("mini.splitjoin").setup({
                mappings = { toggle = " j" },
            })
            require("mini.surround").setup({
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
            })
        end,
    },

    {
        "mason-org/mason-lspconfig.nvim",
        opts = {
            ensure_installed = { "clangd", "pylsp" },
        },
        dependencies = {
            {
                "mason-org/mason.nvim",
                opts = {},
            },
            "neovim/nvim-lspconfig",
        },
    },
    {
        "saghen/blink.cmp",
        version = "*",
        opts = {
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
        },
    },
    {
        "stevearc/conform.nvim",
        cmd = { "ConformInfo" },
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "isort", "black" },
                c = { "clang-format" },
                cpp = { "clang-format" },
            },
        },
    },

    -- extras
    {
        "OXY2DEV/markview.nvim",
        lazy = false,
    },
    {
        "windwp/nvim-ts-autotag",
        config = true,
    },
})

--[[ lsp config ]]
vim.lsp.config("*", {
    capabilities = require("blink.cmp").get_lsp_capabilities(),
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
