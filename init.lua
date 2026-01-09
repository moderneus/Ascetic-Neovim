vim.g.mapleader = " "
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
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
    'bluz71/vim-moonfly-colors',
    priority = 1000,
    config = function()
        vim.cmd("colorscheme moonfly")
    end
  },
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
  {
    'neovim/nvim-lspconfig',
    config = function()
      require('lspconfig').clangd.setup({
        cmd = { "clangd", "--header-insertion=never", "--completion-style=detailed", "--function-arg-placeholders=0" },
        on_attach = function(_, bufnr)
          local opts = { buffer = bufnr }
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        end
      })
    end
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path', 'hrsh7th/cmp-cmdline', 'L3MON4D3/LuaSnip' },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback() end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
        }),
        window = {
	  completion = {
            border = "rounded",
            max_height = 10,
            max_width = 50,
	  },
          documentation= cmp.config.disable,
        },
      })
      cmp.setup.cmdline('/', { mapping = cmp.mapping.preset.cmdline(), sources = { { name = 'buffer' } } })
      cmp.setup.cmdline(':', { mapping = cmp.mapping.preset.cmdline(), sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } }) })
    end
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = function() require("nvim-autopairs").setup({}) end
  },
})
