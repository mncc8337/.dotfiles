local utils = require("utils")
local map = vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- line mover
map({'n', 'i'}, "<C-Up>", function()
    utils.switch_line(-1)
end)
map({'n', 'i'}, "<C-Down>", function()
    utils.switch_line(1)
end)

-- turn off highlighting after search
map({'n'}, "<esc>", "<cmd>noh<CR>")

-- save file
map({'n'}, "<C-s>", "<cmd>w<CR>")

-- nvim-tree
map({'n'}, "<leader>t", "<cmd>NvimTreeToggle<CR>")
map({'n'}, "<leader>tt", "<cmd>NvimTreeFocus<CR>")

-- lazy
-- yeah lazy
map({'n'}, "<leader>l", "<cmd>Lazy<CR>")

-- move between windows using hjkl
map({'n'}, "<C-h>", "<cmd>wincmd h<CR>")
map({'n'}, "<C-j>", "<cmd>wincmd j<CR>")
map({'n'}, "<C-k>", "<cmd>wincmd k<CR>")
map({'n'}, "<C-l>", "<cmd>wincmd l<CR>")

-- bufferline
map({'n'}, "<Tab>", "<cmd>BufferLineCycleNext<CR>")
map({'n'}, "<C-Tab>", "<cmd>BufferLineCyclePrev<CR>")
