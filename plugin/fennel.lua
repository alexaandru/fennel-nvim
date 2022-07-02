if vim.g.fennel_shim_loaded then return end

local dt = require"fennel-shim.util"
local shim = vim.api.nvim_get_runtime_file("fnl/fennel-shim/init.fnl", false)[1]

if shim then
  local fennel = dt("loaded fennel lib", require, "fennel")
  dt("loaded fennel-shim", fennel.dofile, shim)
  require("fennel-shim.plugin").load()
else
  vim.notify("failed to locate fennel shim, fennel files will not work", vim.log.levels.ERROR)
end

vim.g.fennel_shim_loaded = true
