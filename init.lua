vim.g.mapleader = " "
vim.opt.tabstop = 8
vim.opt.shiftwidth = 8
vim.opt.softtabstop = 8
vim.opt.expandtab = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = false
vim.opt.laststatus = 0
vim.opt.showmode = false
vim.opt.ruler = false
vim.opt.fillchars = { eob = " " }
vim.opt.wrap = false

vim.g.loaded_matchparen = 1

vim.keymap.set('i', 'jj', '<Esc>', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Save file' })

vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = 'Quit' })

vim.keymap.set('v', '<TAB>', '>gv', { desc = 'Indent right' })

vim.keymap.set('v', '<S-TAB>', '<gv', { desc = 'Indent left' })
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#3b4252" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
vim.api.nvim_set_hl(0, "CmpBorder", { fg = "#808080" })

require("lazy").setup({
  { 
    'nvim-telescope/telescope.nvim', 
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local telescope = require('telescope')
      local themes = require('telescope.themes')
      local minimal_opts = themes.get_dropdown({
        previewer = false,
        prompt_title = false,
        results_title = false,
        layout_config = { width = 0.6, height = 0.4, anchor = "N" },
      })
      telescope.setup({ defaults = minimal_opts })
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<C-p>', function() builtin.find_files(minimal_opts) end)
      vim.keymap.set('n', '<leader>ff', function() builtin.find_files(minimal_opts) end)
      vim.keymap.set('n', '<leader>fg', function() builtin.live_grep(minimal_opts) end)
    end
  },
})
