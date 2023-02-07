require("rob-3.remap")
require("rob-3.set")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

require("lazy").setup({
	"folke/tokyonight.nvim",
	{
		"nvim-treesitter/nvim-treesitter",
		build = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	},
	"mbbill/undotree",
	"tpope/vim-fugitive",
	"farmergreg/vim-lastplace",
	"kylechui/nvim-surround",
	"airblade/vim-gitgutter",
	"norcalli/nvim-colorizer.lua",
	"NMAC427/guess-indent.nvim",
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
	},
	{
		'VonHeikemen/lsp-zero.nvim',
		dependencies = {
			-- LSP Support
			{'neovim/nvim-lspconfig'},
			{'williamboman/mason.nvim'},
			{'williamboman/mason-lspconfig.nvim'},

			-- Autocompletion
			{'hrsh7th/nvim-cmp'},
			{'hrsh7th/cmp-buffer'},
			{'hrsh7th/cmp-path'},
			{'saadparwaiz1/cmp_luasnip'},
			{'hrsh7th/cmp-nvim-lsp'},
			{'hrsh7th/cmp-nvim-lua'},

			-- Snippets
			{'L3MON4D3/LuaSnip'},
			{'rafamadriz/friendly-snippets'},
		}
	},
	'windwp/nvim-autopairs',
	{
		"themaxmarchuk/tailwindcss-colors.nvim",
		-- load only on require("tailwindcss-colors")
		module = "tailwindcss-colors",
		-- run the setup function after plugin is loaded 
		config = function ()
			-- pass config options here (or nothing to defaults)
			require("tailwindcss-colors").setup()
		end
	},
	"github/copilot.vim",
	{ 'weilbith/nvim-code-action-menu',
		cmd = 'CodeActionMenu',
	},
	{ 'ibhagwan/fzf-lua' }
}, 
{
  ui = {
    icons = {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
})

-- undotree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- colorscheme
require("tokyonight").setup({
	on_highlights = function (hl, c)
		hl.EndOfBuffer = {
			fg = c.dark3
		}
	end
})
vim.cmd.colorscheme("tokyonight")

-- lsp config
local lsp = require("lsp-zero")
lsp.preset("lsp-compe")
lsp.setup()

--vim.diagnostic.config({
--  virtual_text = true,
--  signs = true,
--  update_in_insert = false,
--  underline = true,
--  severity_sort = false,
--  float = true,
--})

local cmp = require("cmp")
local cmp_config = lsp.defaults.cmp_config()
cmp_config.preselect = 'none'
cmp_config.completion.completeopt = "menu,menuone,noinsert,noselect"
cmp_config.mapping["<C-Space>"] = cmp_config.mapping["<C-e>"]
--cmp_config.mapping['<C-e>'] = cmp.mapping({ i = cmp.mapping.close(), c = cmp.mapping.close() })
--cmp_config.mapping["<C-l>"] = cmp.mapping.confirm({ select = false })
cmp_config.mapping["<Tab>"] = nil
cmp_config.mapping["<S-Tab>"] = nil
--cmp_config.mapping["<CR>"] = nil
cmp_config.mapping["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), {'i','c'})
cmp_config.mapping["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), {'i','c'})
cmp_config.experimental = { ghost_text = false }
cmp_config.sources = {
	{ name = "path" },
	{ name = "nvim_lsp", keyword_length = 1 },
	{ name = "buffer", keyword_length = 1 },
	{ name = "luasnip", keyword_length = 2 },
}
cmp.setup(cmp_config)

-- nvim-autopairs
local npairs = require("nvim-autopairs")
npairs.setup({
	check_ts = true,
	break_undo = false,
})
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")
cmp.event:on(
	"confirm_done",
	cmp_autopairs.on_confirm_done()
)

-- nvim-surround
require("nvim-surround").setup({})

-- telescope
--local telescope = require("telescope")
--telescope.setup{
	--defaults = {
		--file_ignore_patterns = { "COMMIT_EDITMSG" },
		--preview = false
	--}
--}
--local builtin = require("telescope.builtin")
--vim.keymap.set("n", "<leader>f", builtin.find_files, {})
--vim.keymap.set("n", "<leader>g", builtin.live_grep, {})
--vim.keymap.set("n", "<leader>p", builtin.oldfiles, {})
--vim.keymap.set("n", "<leader>gs", builtin.grep_string, {})
--telescope.load_extension("fzf")
vim.keymap.set("n", "<leader>f", "<cmd>lua require('fzf-lua').files()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>g", "<cmd>lua require('fzf-lua').live_grep_native()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>p", "<cmd>lua require('fzf-lua').oldfiles()<CR>", { noremap = true, silent = true })

-- greatest remap ever
vim.keymap.set("x", "<leader>p", "\"_dP")

-- next greatest remap ever : asbjornHaland
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

-- treesitter
require("nvim-treesitter.configs").setup {
	-- A list of parser names, or "all"
	ensure_installed = {},

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer
	auto_install = true,

	-- List of parsers to ignore installing (for "all")
	ignore_install = {},

	highlight = {
		-- `false` will disable the whole extension
		enable = true,

		-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
		-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
		-- the name of the parser)
		-- list of language that will be disabled
		disable = {},

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on "syntax" being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = {"gitcommit", "markdown"},
	},
	indent = {
		enable = true,
		disable = { "python" }
	},
}
require("nvim-surround").setup({})
require("guess-indent").setup()
require("colorizer").setup()

-- latex
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "*.tex" },
	callback = function()
		vim.cmd(":call jobstart(['pdflatex', expand('%')])")
	end
})
vim.api.nvim_create_user_command("Format", function() vim.lsp.buf.format() end, {})

-- tailwind colors
local nvim_lsp = require("lspconfig")

local on_attach = function(client, bufnr)
	-- other stuff
	require("tailwindcss-colors").buf_attach(bufnr)
end

nvim_lsp["tailwindcss"].setup({
	-- other settings
	on_attach = on_attach,
})
nvim_lsp.pyright.setup({})
