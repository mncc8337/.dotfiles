local map = vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- replaced by mini.move
-- -- line mover
-- local utils = require("utils")
-- map({'n', 'i'}, "<C-Up>", function()
--     utils.switch_line(-1)
-- end)
-- map({'n', 'i'}, "<C-Down>", function()
--     utils.switch_line(1)
-- end)

-- turn off highlighting after search
map({ "n" }, "<esc>", vim.cmd.noh)

-- save file
map({ "n" }, "<C-s>", vim.cmd.w, { desc = "Save current file" })

-- move between windows using hjkl
map({ "n" }, "<C-h>", "<cmd>wincmd h<CR>", { desc = "To left window" })
map({ "n" }, "<C-j>", "<cmd>wincmd j<CR>", { desc = "To down window" })
map({ "n" }, "<C-k>", "<cmd>wincmd k<CR>", { desc = "To up window" })
map({ "n" }, "<C-l>", "<cmd>wincmd l<CR>", { desc = "To right window" })
-- resize windows using hjkl
map({ "n" }, "<C-A-h>", "<cmd>wincmd <<CR>", { desc = "Descease width of current window" })
map({ "n" }, "<C-A-j>", "<cmd>wincmd -<CR>", { desc = "Decrease height of current window" })
map({ "n" }, "<C-A-k>", "<cmd>wincmd +<CR>", { desc = "Increase height of current window" })
map({ "n" }, "<C-A-l>", "<cmd>wincmd ><CR>", { desc = "Increase width of current window" })

map({ "t" }, "<Esc><Esc><Esc>", "<C-\\><C-n>", { desc = "Leave terminal mode" })

-- telescope
local telescope_builtin = require("telescope.builtin")
map({ "n" }, "<C-f><C-f>", telescope_builtin.find_files, { desc = "Find files" })
map({ "n" }, "<C-f><C-g>", telescope_builtin.live_grep, { desc = "Live grep" })
map({ "n" }, "<C-f><C-b>", telescope_builtin.buffers, { desc = "List all buffers" })
map({ "n" }, "<leader>gc", telescope_builtin.git_commits, { desc = "Git checkout commits" })
map({ "n" }, "<leader>gst", telescope_builtin.git_status, { desc = "Git status" })

-- mini
local minidiff = require("mini.diff")
map({ "n" }, "<leader>gd", minidiff.toggle_overlay, { desc = "Toggle diff overlay" })
local minifiles = require("mini.files")
map({ "n" }, "<leader>t", minifiles.open, { desc = "Open files" })

-- formatter
map({ "n", "v" }, "<leader>fff", require("conform").format, { desc = "Format code" })

map({ "n" }, "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map({ "n" }, "K", vim.lsp.buf.hover, { desc = "Show definition" })
-- map({'n'}, "<leader>vws", vim.lsp.buf.workspace_symbol)
map({ "n" }, "<leader>vd", vim.diagnostic.open_float, { desc = "Open diagnostic" })
map({ "n" }, "[d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
map({ "n" }, "]d", vim.diagnostic.goto_prev, { desc = "Go to prev diagnostic" })
map({ "n" }, "<leader>vca", vim.lsp.buf.code_action, { desc = "Show code action" })
map({ "n" }, "<leader>vrr", vim.lsp.buf.references, { desc = "Show all references" })
map({ "n" }, "<leader>vrn", vim.lsp.buf.rename, { desc = "LSP rename" })
