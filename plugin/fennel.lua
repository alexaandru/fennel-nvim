if vim.g.fennel_loader then return end

local shim = vim.api.nvim_get_runtime_file("fnl/fennel-shim/init.fnl", false)[1]
local err = function(msg) vim.notify(msg, vim.log.levels.ERROR) end

if shim then
  local ok, fennel = pcall(require, "fennel")
  if ok then
    fennel.dofile(shim)
    require("fennel-shim.plugin")("plugin")
    if vim.g.fennel_shim_ftplugin then require("fennel-shim.ftplugin") end
  else
    err "failed to load fennel, fennel shim will not work"
  end
else
  err "failed to locate fennel shim, fennel files will not work"
end
