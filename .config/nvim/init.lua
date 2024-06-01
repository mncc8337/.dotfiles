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
    -- {
    --     "nvim-treesitter/nvim-treesitter",
    --     build = ":TSUpdate",
    -- },
    { 'echasnovski/mini.nvim', version = false },
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {"nvim-tree/nvim-web-devicons"},
        lazy = false
    },
    {
        "akinsho/bufferline.nvim",
        dependencies = {"nvim-tree/nvim-web-devicons"}
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {"nvim-tree/nvim-web-devicons"}
    },
    {"NvChad/nvim-colorizer.lua"},
    {"RRethy/base16-nvim"},
}

--[[ plugins setup ]]--
require('base16-colorscheme').setup(require("scsman"))
require("nvim-tree").setup()
require("colorizer").setup()
require("bufferline").setup {
    options = {
        offsets = {
            {
                filetype = "NvimTree",
                text = "File Explorer",
                text_align = "center",
                separator = true
            }
        }
    }
}
require("lualine").setup()
-- mini-nvim
require("mini.pairs").setup()
require("mini.move").setup()
require("mini.surround").setup {
    highlight_duration = 500,
    mappings = {
        add = 'sa', -- Add surrounding in Normal and Visual modes
        delete = 'sd', -- Delete surrounding
        find = 'sf', -- Find surrounding (to the right)
        find_left = 'sF', -- Find surrounding (to the left)
        highlight = 'sh', -- Highlight surrounding
        replace = 'sr', -- Replace surrounding
        update_n_lines = 'sn', -- Update `n_lines`

        suffix_last = 'l', -- Suffix to search with "prev" method
        suffix_next = 'n', -- Suffix to search with "next" method
    },

    -- Number of lines within which surrounding is searched
    n_lines = 20,
    respect_selection_type = false,
    search_method = 'cover',
}

-- require("nvim-treesitter.configs").setup {
--     ensure_installed = { "c", "lua", "cpp", "python" },
--     sync_install = false,
--     auto_install = false,
--     highlight = {
--         enable = true,
--         disable = {},
--     }
-- }

--[[ keymapping ]]--
require("mappings")

--[[ common settings ]]--
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.opt.cmdheight = 0

vim.opt.number = true

vim.opt.timeout = true
vim.opt.timeoutlen = 1000

vim.opt.clipboard = "unnamedplus"

vim.opt.termguicolors = true
-- vim.cmd.colorscheme "base16-gruvbox-dark-medium"

-- disable netrw to use nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- filetype options
local utils = require("utils")
utils.set_filetype_option({"c", "cpp"}, "commentstring", "// %s")
