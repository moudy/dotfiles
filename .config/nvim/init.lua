local Plug = vim.fn["plug#"]
vim.call("plug#begin", "~/.config/nvim/plugged")

Plug "tpope/vim-sensible"

Plug "christoomey/vim-tmux-navigator"
Plug "nvim-lualine/lualine.nvim"
Plug "mhartington/formatter.nvim"
Plug "tpope/vim-surround"
Plug "tpope/vim-abolish"
Plug "tpope/vim-eunuch"
Plug "numToStr/Comment.nvim"
Plug "lewis6991/gitsigns.nvim"
Plug "L3MON4D3/LuaSnip"
Plug "folke/which-key.nvim"
Plug "kyazdani42/nvim-web-devicons"

Plug "nvim-lua/plenary.nvim"
Plug "nvim-telescope/telescope.nvim"
Plug("nvim-telescope/telescope-fzf-native.nvim", {["do"] = "make"})
Plug "nvim-telescope/telescope-file-browser.nvim"

-- Theme
Plug "mcchrish/zenbones.nvim"
Plug "rktjmp/lush.nvim"
Plug("embark-theme/vim", {as = "embark"})

-- Autocompletion/LSP
Plug "hrsh7th/nvim-cmp"
Plug "hrsh7th/cmp-buffer"
Plug "hrsh7th/cmp-path"
Plug "hrsh7th/cmp-nvim-lsp"
Plug "hrsh7th/cmp-cmdline"
Plug "onsails/lspkind-nvim"
Plug "williamboman/nvim-lsp-installer"
Plug "neovim/nvim-lspconfig"
Plug "nvim-lua/lsp-status.nvim"
Plug("nvim-treesitter/nvim-treesitter", {["do"] = ":TSUpdate"})
Plug "folke/trouble.nvim"
Plug "saadparwaiz1/cmp_luasnip"
Plug "rafamadriz/friendly-snippets"

vim.call("plug#end")

local cmd = vim.cmd -- to execute Vim commands e.g. cmd('pwd')
local g = vim.g -- a table to access global variables
local opt = vim.opt -- to set options

cmd "colorscheme tokyobones"

g.mapleader = " "
g.history = 10000

opt.termguicolors = true
opt.autoindent = true
opt.smartindent = true
opt.smarttab = true
opt.smartcase = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.hidden = true
opt.foldmethod = "indent"
opt.foldlevelstart = 20
opt.splitbelow = true
opt.splitright = true
-- make searches case-sensitive only if they contain upper-case characters
opt.smartcase = true
opt.inccommand = "nosplit"
opt.relativenumber = true
opt.number = true

-- For css
vim.api.nvim_exec("set iskeyword+=-", true)

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map("n", ";", ":")
map("v", ";", ":")

map("i", "jj", "<ESC>")
map("t", "jj", "<ESC>")

map("c", "%%", "<C-R>=expand('%:h').'/'<cr>")
map("", "<leader>e", ":edit %%", {noremap = false})

map("", "<leader>rr", ':%s/<c-r>=expand("<cword>")<cr>/<c-r>=expand("<cword>")<cr>/g')

-- Equalizing windows
map("", "<leader>=", "<C-W>=")

-- Find file
map("", "<leader>p", ":Telescope find_files<CR>")
map("", "<leader>k", ":Telescope<CR>")
map("n", "<leader>ff", '<cmd>lua require(\'telescope.builtin\').grep_string({search = vim.fn.expand("<cword>")})<cr>')

-- Formatting
map("n", "<leader>f", ":Format<CR>")
vim.api.nvim_exec(
  [[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.js,*.jsx,*.ts,*.tsx,*.rs,*.lua FormatWrite
augroup END
]],
  true
)

-- Last file
map("n", "<leader><leader>", "<c-^>")

cmd "autocmd TextYankPost * lua vim.highlight.on_yank {on_visual = false}"

-- Search for string (i.e. :Rg xyz)
vim.api.nvim_command([[
  command! -nargs=+ Rg lua require('telescope.builtin').grep_string({search= <q-args>})<cr>
]])

-- Like "only" but deletes other buffers
vim.api.nvim_command([[
  command Only silent! execute "%bd|e#|bd#"
]])

-- Status line
local function mode()
  local m = require("lualine.utils.mode").get_mode()

  if (string.find(m, "-")) then
    return m
  end

  return string.sub(m, 0, 1)
end

require("lualine").setup(
  {
    options = {
      theme = "nord",
      section_separators = "",
      component_separators = ""
    },
    sections = {
      lualine_a = {mode},
      lualine_b = {},
      lualine_c = {
        "filename",
        {"diagnostics", sources = {"nvim_diagnostic"}}
      },
      lualine_x = {"branch", "diff"},
      lualine_y = {},
      lualine_z = {}
    }
  }
)

-- Formatting
local prettier = function()
  return {
    exe = "prettier",
    args = {"--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))},
    stdin = true
  }
end

require("formatter").setup(
  {
    filetype = {
      javascript = {prettier},
      javascriptreact = {prettier},
      typescript = {prettier},
      typescriptreact = {prettier},
      graphql = {prettier},
      lua = {
        function()
          return {
            exe = "luafmt",
            args = {"--indent-count", 2, "--stdin"},
            stdin = true
          }
        end
      }
    }
  }
)

local lsp_installer = require("nvim-lsp-installer")
local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Include the servers you want to have installed by default below
local servers = {
  "tsserver",
  "graphql",
  "eslint",
  "efm",
  "sumneko_lua"
}

for _, name in pairs(servers) do
  local server_is_found, server = lsp_installer.get_server(name)
  if server_is_found and not server:is_installed() then
    print("Installing " .. name)
    server:install()
  end
end

local enhance_server_opts = {
  -- Provide settings that should only apply to the "eslintls" server
  ["eslint"] = function(opts)
    opts.settings = {
      format = {
        enable = true
      },
      codeActionOnSave = {
        enable = true,
        mode = "all"
      }
    }
  end,
  ["sumneko_lua"] = function(opts)
    opts.settings = {
      Lua = {
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {"vim"}
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false
        }
      }
    }
  end
}

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  -- Mappings.
  local opts = {noremap = true, silent = true}

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap("n", "<leader>ne", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
  buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
end

-- Register a handler that will be called for each installed server when it's ready (i.e. when installation is finished
-- or if the server is already installed).
lsp_installer.on_server_ready(
  function(server)
    -- Specify the default options which we'll use to setup all servers
    local opts = {
      on_attach = on_attach,
      capabilities = capabilities
    }

    if enhance_server_opts[server.name] then
      -- Enhance the default opts with the server-specific ones
      enhance_server_opts[server.name](opts)
    end

    -- This setup() function will take the provided server configuration and decorate it with the necessary properties
    -- before passing it onwards to lspconfig.
    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    server:setup(opts)
  end
)

-- Configure LSP
local luasnip = require("luasnip")
local cmp = require("cmp")
local lspkind = require("lspkind")

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup {
  completion = {
    completeopt = "menu,menuone,noinsert"
  },
  formatting = {
    format = lspkind.cmp_format({with_text = true, maxwidth = 50})
  },
  sources = {
    {name = "nvim_lua"},
    {name = "nvim_lsp"},
    {name = "luasnip"},
    {name = "buffer", keyword_length = 2},
    {name = "path"}
  },
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({select = true}),
    -- ["<CR>"] = cmp.mapping.confirm {
    --   behavior = cmp.ConfirmBehavior.Replace,
    --   select = true
    -- },
    ["<Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ["<S-Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  }
  --     experimental = {
  --       native_menu = false,
  --       ghost_text = true
  --     }
}

-- Setup LSP servers
-- local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
--
-- local sumneko_root_path = os.getenv("HOME") .. "/projects/lua-language-server"
-- local sumneko_binary
-- if vim.fn.has("mac") == 1 then
--   sumneko_binary = sumneko_root_path .. "/bin/lua-language-server"
-- elseif vim.fn.has("unix") == 1 then
--   sumneko_binary = sumneko_root_path .. "/bin/Linux/lua-language-server"
-- else
--   print("Unsupported system for sumneko")
-- end
--
-- local runtime_path = vim.split(package.path, ";")
-- table.insert(runtime_path, "lua/?.lua")
-- table.insert(runtime_path, "lua/?/init.lua")
--
-- local langservers = {
--   "tsserver",
--   "graphql",
--   "eslint",
--   "sumneko_lua",
--   "cssls"
-- }
--
-- local lspconfig = require("lspconfig")
--
-- -- Use an on_attach function to only map the following keys
-- -- after the language server attaches to the current buffer
-- local on_attach = function(client, bufnr)
--   local function buf_set_keymap(...)
--     vim.api.nvim_buf_set_keymap(bufnr, ...)
--   end
--
--   -- Mappings.
--   local opts = {noremap = true, silent = true}
--
--   -- See `:help vim.lsp.*` for documentation on any of the below functions
--   buf_set_keymap("n", "<leader>ne", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
--   buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
-- end
--
-- for _, server in ipairs(langservers) do
--   if server == "sumneko_lua" then
--     lspconfig[server].setup {
--       on_attach = on_attach,
--       cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
--       settings = {
--         Lua = {
--           runtime = {
--             -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
--             version = "LuaJIT",
--             -- Setup your lua path
--             path = runtime_path
--           },
--           diagnostics = {
--             -- Get the language server to recognize the `vim` global
--             globals = {"vim"}
--           },
--           workspace = {
--             -- Make the server aware of Neovim runtime files
--             library = vim.api.nvim_get_runtime_file("", true),
--             checkThirdParty = false
--           },
--           -- Do not send telemetry data containing a randomized but unique identifier
--           telemetry = {
--             enable = false
--           }
--         }
--       }
--     }
--   else
--     lspconfig[server].setup {
--       on_attach = on_attach,
--       capabilities = capabilities
--     }
--   end
-- end

-- Configure Telescope
local telescope = require("telescope")

telescope.setup(
  {
    defaults = {
      sorting_strategy = "ascending",
      layout_strategy = "flex",
      layout_config = {
        horizontal = {
          prompt_position = "top",
          preview_width = 0.55
        },
        vertical = {
          mirror = false
        }
      }
    }
  }
)

telescope.load_extension("fzf")
telescope.load_extension("file_browser")

-- Setup other plugins
require("Comment").setup()
require("gitsigns").setup()
require("which-key").setup()
require("nvim-web-devicons").setup()
require("trouble").setup(
  {
    auto_open = false,
    auto_close = false,
    use_lsp_diagnostic_signs = false
  }
)
require("nvim-treesitter.configs").setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false
  }
}
