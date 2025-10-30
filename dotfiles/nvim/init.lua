-- Enable folding
vim.opt.foldmethod = "expr"

-- #region folding function
function GetNixFold(lnum)
  local line = vim.fn.getline(lnum)
  if line:match("^%s*#region") then
    return ">1"
  elseif line:match("^%s*#endregion") then
    return "<1"
  end
  return "="
end

vim.opt.foldexpr = "v:lua.GetNixFold(v:lnum)"

-- Auto-apply for .nix files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "nix",
  callback = function()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "v:lua.GetNixFold(v:lnum)"
  end,
})

-- Set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- LSP setup for Rust
vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function()
    vim.lsp.start({
      name = "rust-analyzer",
      cmd = {"rust-analyzer"},
      root_dir = vim.fs.dirname(vim.fs.find({"Cargo.toml", ".git"}, {upward = true})[1]),
    })
  end,
})

-- LSP keybindings
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>f", function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})