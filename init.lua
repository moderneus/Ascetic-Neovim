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

  { "williamboman/mason.nvim", config = true },
  { "williamboman/mason-lspconfig.nvim" },
  { "neovim/nvim-lspconfig" },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
  },
})

local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

require("mason-lspconfig").setup({
  ensure_installed = { "clangd" }, 
})

lspconfig.clangd.setup({
  capabilities = capabilities,
})

vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "Hover info" })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "Rename" })

local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), 
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  window = {
    completion = {
      border = 'rounded',
      winhighlight = 'Normal:CmpPmenu,CursorLine:PmenuSel,Search:None',
      max_height = 10,
      max_width = 30,
    },
    documentation = {
      border = 'rounded',
      max_height = 10,
      max_width = 50,
    },
  },
  
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'path' },
  }, {
    { name = 'buffer' },
  }),
})

vim.diagnostic.config({
  virtual_text = {
    prefix = '●',
    spacing = 1,
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    border = 'rounded',
  },
})

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Previous error" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Next error" })
