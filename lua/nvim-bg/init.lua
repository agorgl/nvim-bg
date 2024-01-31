local M = {}

local function send_osc(osc)
  --vim.fn.chansend(vim.v.stderr, osc)
  vim.api.nvim_chan_send(vim.v.stderr, osc)
end

function M.set_background(color)
  local osc = string.format("\x1b]11;%s\x07", color)
  send_osc(osc)
end

function M.reset_background()
  local osc = "\x1b]111;\x07"
  send_osc(osc)
end

function M.match_background()
  local color = vim.api.nvim_get_hl_by_name("Normal", true).background
  if color then
    color = string.format("#%X", color)
    M.set_background(color)
  end
end

function M.setup(opts)
  local group = vim.api.nvim_create_augroup("nvim_bg", { clear = true })
  vim.api.nvim_create_autocmd("ColorScheme", { group = group, callback = M.match_background })
  vim.api.nvim_create_autocmd("VimLeavePre", { group = group, callback = M.reset_background })
  M.match_background()
end

return M
