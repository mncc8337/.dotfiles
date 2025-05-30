--[[ lazy.nvim ]]--
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local lazy = require("lazy")
lazy.setup {
    { "RRethy/base16-nvim" },
    {
        "nvim-treesitter/nvim-treesitter",
        config = true,
        opts = { highlight = {enable = true} }
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" }
    },
    { "nvim-tree/nvim-web-devicons" },
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {"nvim-tree/nvim-web-devicons"},
        lazy = false, config = true
    },
    {
        "echasnovski/mini.nvim",
        version = false,
        config = function()
            require("mini.pairs").setup()
            require("mini.move").setup()
            require("mini.cursorword").setup()
            require("mini.splitjoin").setup {
                mappings = {
                    toggle=" j",
                },
            }
            require("mini.surround").setup {
                highlight_duration = 500,
                mappings = {
                    add = 'sa',
                    delete = 'sd',
                    find = 'sf',
                    find_left = 'sF',
                    highlight = 'sh',
                    replace = 'sr',
                    update_n_lines = 'sn',

                    suffix_last = 'l',
                    suffix_next = 'n',
                },

                n_lines = 20,
                respect_selection_type = false,
                search_method = 'cover',
            }
        end
    },
    {
        "akinsho/bufferline.nvim",
        dependencies = {"nvim-tree/nvim-web-devicons"},
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {"nvim-tree/nvim-web-devicons"},
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
        config = {
            indent = { char = "╎" },
        },
    },
    { "NvChad/nvim-colorizer.lua", config = true },
    {
        "kevinhwang91/nvim-ufo",
        dependencies = "kevinhwang91/promise-async",
        config = true
    },
    {
          "nvim-treesitter/nvim-treesitter",
          build = "TSUpdate",
          lazy = false,
    },
    {
        "williamboman/mason.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "williamboman/mason-lspconfig.nvim",
            "nvim-lua/plenary.nvim",
        }
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
        },
    },
    {
        "stevearc/dressing.nvim",
        opts = {
            input = {
                border = "solid",
            }
        },
        config = true,
    },

    --[[ language specific ]]--
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
        config = true
    },
    { "windwp/nvim-ts-autotag", config = true },
}

--[[ plugins configs ]]--
require("base16-colorscheme").setup()
-- bufferline and lualine must be setup after base16-colorscheme
require("bufferline").setup {
    options = {
        indicator = {
            style = "none",
        },
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
                separator = true
            }
        },
    }
}
require("lualine").setup()

require("nvim-treesitter.configs").setup {
    ensure_installed = { "c", "cpp", "python", "lua", "rust" },
    sync_install = true,
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true }
}

-- completions
local kind_icons = {
    Text = "",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "",
    Field = "󰇽",
    Variable = "󰂡",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "",
    Event = "",
    Operator = "󰆕",
    TypeParameter = "󰅲",
}
local cmp = require("cmp")
cmp.setup {
    snippet = {
        expand = function(args) vim.snippet.expand(args.body) end,
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert {
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping(
            function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif vim.snippet.active({ direction = 1 }) then
                    vim.snippet.jump(1)
                else
                    fallback()
                end
            end, { 'i', 's' }
        ),
    },
    sources = cmp.config.sources({{ name = "nvim_lsp" }}, {{ name = "buffer" }}),
    formatting = {
        format = function(_, vim_item)
            vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
            -- vim_item.menu = ({
            --     buffer = "[Buffer]",
            --     nvim_lsp = "[LSP]",
            --     luasnip = "[LuaSnip]",
            --     nvim_lua = "[Lua]",
            --     latex_symbols = "[LaTeX]",
            -- })[entry.source.name]
            return vim_item
        end
    },
}
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {{ name = "buffer" }}
})
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({{ name = "path" }}, {{ name = "cmdline" }}),
    matching = { disallow_symbol_nonprefix_matching = false }
})

-- LSP
require("mason").setup()
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require("lspconfig")
require("mason-lspconfig").setup_handlers {
    function(server_name)
        lspconfig[server_name].setup {
            capabilities = capabilities
        }
    end
}
require("mason-lspconfig").setup()
lspconfig["lua_ls"].setup {
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = {
                globals = {
                    "vim",
                    "awesome",
                    "client",
                    "tag",
                    "screen",
                }
            }
        }
    }
}
vim.diagnostic.config { virtual_text = true }

--[[ keymapping ]]--
require("mappings")

--[[ common settings ]]--
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.cmdheight = 0
vim.opt.number = true

-- vim.opt.foldmethod = "indent"
vim.opt.foldcolumn = '1'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

vim.opt.timeout = true
vim.opt.timeoutlen = 1000

vim.opt.clipboard = "unnamedplus"

vim.opt.termguicolors = true
vim.cmd.colorscheme("base16-gruvbox-dark-medium")

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undordir"

-- disable netrw to use nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- filetype options
local utils = require("utils")
utils.set_filetype_option({"c", "cpp"}, "commentstring", "// %s")
