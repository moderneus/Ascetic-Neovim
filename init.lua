vim.g.mapleader = " "
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true 
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = false
vim.opt.laststatus = 0
vim.opt.showmode = false
vim.opt.ruler = false
vim.opt.fillchars = { eob = " " }
vim.opt.wrap = false
vim.opt.termguicolors = true

vim.g.loaded_matchparen = 1

vim.keymap.set('i', 'jj', '<Esc>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = 'Quit' })
vim.keymap.set('v', '<TAB>', '>gv', { desc = 'Indent right' })
vim.keymap.set('v', '<S-TAB>', '<gv', { desc = 'Indent left' })

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath }) end
vim.opt.rtp:prepend(lazypath)

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
        layout_config = { width = 0.8, height = 0.3, anchor = "N" },
      })
      telescope.setup({ defaults = minimal_opts })
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<C-p>', function() builtin.find_files(minimal_opts) end)
      vim.keymap.set('n', '<leader>ff', function() builtin.find_files(minimal_opts) end)
      vim.keymap.set('n', '<leader>fg', function() builtin.live_grep(minimal_opts) end)
    end
  },

  { "williamboman/mason.nvim", config = true },
  { "williamboman/mason-lspconfig.nvim" },
  { "neovim/nvim-lspconfig" },
})

local lspconfig = require('lspconfig')

require("mason-lspconfig").setup({
	automatic_installation = false,
})

require('lspconfig').clangd.setup({
  cmd = {
    "/usr/bin/clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=never",
  }
})

vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "Hover info" })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "Rename" })

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Previous error" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Next error" })

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        vim.keymap.set("n", "gq", function()
            vim.lsp.buf.format({ async = true })
        end, { buffer = args.buf })
    end,
})

local bg_white        = "#ffffff"
local keyword_blue    = "#2700ff"
local standard_text   = "#000000"
local function_cyan   = "#2DB2B5"
local type_blue       = "#2700ff"
local comment_grey    = "#586e75"
local string_green    = "#4BAD2A"

vim.api.nvim_set_hl(0, "Normal", { fg = standard_text, bg = bg_white, bold = true })
vim.api.nvim_set_hl(0, "Keyword", { fg = keyword_blue, bold = true })
vim.api.nvim_set_hl(0, "Statement", { fg = keyword_blue, bold = true })
vim.api.nvim_set_hl(0, "Conditional", { fg = keyword_blue, bold = true })
vim.api.nvim_set_hl(0, "Repeat", { fg = keyword_blue, bold = true })
vim.api.nvim_set_hl(0, "Type", { fg = type_blue, bold = true })
vim.api.nvim_set_hl(0, "Function", { fg = function_cyan, bold = true })
vim.api.nvim_set_hl(0, "Comment", { fg = comment_grey, italic = true })
vim.api.nvim_set_hl(0, "String", { fg = string_green, bold = true })

vim.api.nvim_set_hl(0, "@keyword.cpp", { fg = keyword_blue, bold = true })
vim.api.nvim_set_hl(0, "@type.builtin.cpp", { fg = keyword_blue, bg = type_blue })
vim.api.nvim_set_hl(0, "@type.qualifier.cpp", { fg = keyword_blue, bold = true })

vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#3b4252" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
