-- init.lua or in a Lua config file loaded by init.vim

-- Basic settings
vim.o.nocompatible = true
vim.o.showmatch = true
vim.o.ignorecase = true
vim.o.mouse = ""  -- empty string instead of ""

-- Search settings
vim.o.hlsearch = false
vim.o.incsearch = true
vim.o.smartcase = true

-- Tab and indent settings
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.autoindent = true

-- UI settings
-- vim.o.number = false  -- commented out in original
vim.o.wildmode = "longest,list"
vim.o.colorcolumn = ""  -- empty string instead of vim.go.cc
vim.o.ruler = true
vim.o.modeline = true
vim.o.modelines = 2
vim.o.laststatus = 0
vim.o.title = true
vim.o.titlelen = 70
vim.o.titlestring = "term:%{$USER}@%{expand(hostname())}:VIM:%t:%{expand(\"%:p:h\")}:%M"

-- Performance
vim.o.ttyfast = true

-- Clipboard
vim.o.clipboard = "unnamedplus"

-- Filetype handling
vim.cmd("filetype plugin indent on")
vim.cmd("syntax on")
vim.cmd("filetype plugin on")

-- Key mappings
-- F11 for paste toggle
vim.api.nvim_set_keymap('n', '<F11>', ':set invpaste paste?<CR>', {noremap = true, silent = false})
vim.api.nvim_set_keymap('i', '<F11>', '<C-O>:set invpaste<CR>', {noremap = true, silent = false})

-- F10 for hlsearch toggle
vim.api.nvim_set_keymap('n', '<F10>', ':set hls!<bar>set hls?<CR>', {noremap = true, silent = false})

-- Leader mappings
local leader = "\\"  -- default leader key

-- Other mappings
vim.api.nvim_set_keymap('n', 'gf', ':e <cfile><cr>', {noremap = true, silent = false})
vim.api.nvim_set_keymap('n', '<F12>', ':w !copy<CR><CR>', {noremap = true, silent = false})

-- Leader mappings for copying and executing
-- \c copy
vim.api.nvim_set_keymap('v', leader .. 'c', ":'<,'>w !copy <CR><CR>", {noremap = true, silent = false})
-- \x execute in shell
vim.api.nvim_set_keymap('n', leader .. 'x', ':.w !bash<CR>', {noremap = true, silent = false})

-- -- Plugin manager setup (using vim-plug)
-- vim.cmd([[
--   call plug#begin('~/.local/share/nvim/site/plugged')
--   Plug 'mustache/vim-mustache-handlebars'
--   Plug 'towolf/vim-helm'
--   Plug 'tpope/vim-fugitive'
--   Plug 'airblade/vim-gitgutter'
--   Plug 'nvim-lua/plenary.nvim'
--   Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.2' }
--   Plug 'smartpde/telescope-recent-files'
--   Plug 'khaveesh/vim-fish-syntax'
--   Plug 'hashivim/vim-terraform'
--   Plug 'vim-syntastic/syntastic'
--   Plug 'preservim/nerdcommenter'
--   Plug 'neomake/neomake'
--   Plug 'chrisbra/Colorizer'
--   call plug#end()
-- ]])

-- -- Neomake configuration
-- vim.cmd("call neomake#configure#automake('w')")

-- Shell configuration
if string.match(vim.o.shell, "fish$") then
  vim.o.shell = "sh"
end

-- Source additional color configuration
vim.cmd("source ~/.config/nvim/mycolor.vim")

-- Custom commands
vim.cmd([[
  command! -range=% Squote <line1>,<line2>s/\([^\S]\+\)$/ '\1'/g
  command! Squotef %s/\([^\S]\+\)$/ '\1'/g
  command! -range=% Quote <line1>,<line2>s/\([^\S]\+\)$/ "\1"/g
  command! Quotef %s/\([^\S]\+\)$/ "\1"/g
  command! -range=% Quoteall <line1>,<line2>s/\(\S\+\)/"\1"/g
  command! Quoteallf %s/\(\S\+\)/"\1"/g
  command! -range=% Squoteall <line1>,<line2>s/\(\S\+\)/'\1'/g
  command! Squoteallf %s/\(\S\+\)/'\1'/g
  command! Spacesf %s/\s\+$//g
  command! -range=% Spaces <line1>,<line2>s/\s\+$//g
]])

vim.o.shada = "'100,<50,s10,h,%100"

