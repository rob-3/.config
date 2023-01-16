require("rob-3.remap")
require("rob-3.set")

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
cmp_config.mapping["<C-Space>"] = cmp_config.mapping["<C-e>"]
--cmp_config.mapping['<C-e>'] = cmp.mapping({ i = cmp.mapping.close(), c = cmp.mapping.close() })
--cmp_config.mapping["<C-l>"] = cmp.mapping.confirm({ select = false })
cmp_config.mapping["<Tab>"] = nil
cmp_config.mapping["<S-Tab>"] = nil
--cmp_config.mapping["<CR>"] = nil
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
local telescope = require("telescope")
telescope.setup{
	defaults = {
		file_ignore_patterns = { "COMMIT_EDITMSG" }
	}
}
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>f", builtin.find_files, {})
vim.keymap.set("n", "<leader>g", builtin.live_grep, {})
vim.keymap.set("n", "<leader>p", builtin.oldfiles, {})
telescope.load_extension("fzf")

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
