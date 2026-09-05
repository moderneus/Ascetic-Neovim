vim.g.mapleader = " "
vim.g.loaded_matchparen = 1

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

vim.keymap.set('i', 'jj', '<Esc>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>q', '<cmd>q<CR>', { desc = 'Quit' })
vim.keymap.set('v', '<TAB>', '>gv', { desc = 'Indent right' })
vim.keymap.set('v', '<S-TAB>', '<gv', { desc = 'Indent left' })

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" }, { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
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

require("mason-lspconfig").setup({
  automatic_installation = false,
})

vim.lsp.config('clangd', {
  cmd = {
    "/usr/bin/clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=never",
  }
})
vim.lsp.enable('clangd')

vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "Hover info" })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "Rename" })

vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Previous error" })
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end, { desc = "Next error" })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.keymap.set("n", "gq", function()
      vim.lsp.buf.format({ async = true })
    end, { buffer = args.buf, desc = "Format buffer" })
  end,
})

local bg_black        = "#000000"
local keyword_blue    = "#ffffff"
local standard_text   = "#ffffff"
local function_cyan   = "#ffffff"
local type_blue       = "#ffffff"
local comment_grey    = "#ffffff"
local string_green    = "#ffffff"

local highlights = {
  Normal            = { fg = standard_text, bg = bg_black, bold = false },
  Keyword           = { fg = keyword_blue, bold = false },
  Statement         = { fg = keyword_blue, bold = false },
  Conditional       = { fg = keyword_blue, bold = false },
  Repeat            = { fg = keyword_blue, bold = false },
  Type              = { fg = type_blue, bold = false },
  Function          = { fg = function_cyan, bold = false },
  Comment           = { fg = comment_grey, italic = true },
  String            = { fg = string_green, bold = false },
  PreProc           = { fg = keyword_blue, bold = false },
  cBlock            = { fg = standard_text, bold = false },
  Constant          = { fg = standard_text, bold = false },

  ["@operator"]         = { fg = standard_text, bold = false },
  ["@variable"]         = { fg = standard_text, bold = false },
  ["@keyword.cpp"]      = { fg = keyword_blue, bold = false },
  ["@type.builtin.cpp"] = { fg = keyword_blue, bg = type_blue, bold = false },
  ["@type.qualifier.cpp"] = { fg = keyword_blue, bold = false },

  TelescopeBorder   = { fg = "#3b4252" },
  NormalFloat       = { bg = "NONE" },
}

for group, settings in pairs(highlights) do
  vim.api.nvim_set_hl(0, group, settings)
end
