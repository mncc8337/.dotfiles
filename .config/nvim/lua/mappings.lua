local utils = require("utils")
local map = vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- line mover
-- replaced by mini.move
-- map({'n', 'i'}, "<C-Up>", function()
--     utils.switch_line(-1)
-- end)
-- map({'n', 'i'}, "<C-Down>", function()
--     utils.switch_line(1)
-- end)

-- turn off highlighting after search
map({'n'}, "<esc>", vim.cmd.noh)

-- save file
map({'n'}, "<C-s>", vim.cmd.w)

-- nvim-tree
map({'n'}, "<leader>t", vim.cmd.NvimTreeToggle)
map({'n'}, "<leader>tt", vim.cmd.NvimTreeFocus)

-- move between windows using hjkl
map({'n'}, "<C-h>", "<cmd>wincmd h<CR>")
map({'n'}, "<C-j>", "<cmd>wincmd j<CR>")
map({'n'}, "<C-k>", "<cmd>wincmd k<CR>")
map({'n'}, "<C-l>", "<cmd>wincmd l<CR>")

map({'n'}, "<leader>gs", vim.cmd.Git)

-- bufferline
map({'n'}, "<Tab>", vim.cmd.BufferLineCycleNext)
map({'n'}, "<C-Tab>", vim.cmd.BufferLineCyclePrev)

map({'n'}, "gd", vim.lsp.buf.definition)
map({'n'}, "K", vim.lsp.buf.hover)
-- map({'n'}, "<leader>vws", vim.lsp.buf.workspace_symbol)
-- map({'n'}, "<leader>vd", vim.diagnostic.open_float)
map({'n'}, "[d", vim.diagnostic.goto_next)
map({'n'}, "]d", vim.diagnostic.goto_prev)
map({'n'}, "<leader>vca", vim.lsp.buf.code_action)
map({'n'}, "<leader>vrr", vim.lsp.buf.references)
map({'n'}, "<leader>vrn", vim.lsp.buf.rename)
