local ns_to_ms = 1e-6
local now = vim.loop.hrtime

local log = (function()
  local cache = vim.fn.stdpath("cache")
  local f = assert(io.open(cache .. "/fennel-shim.log", "a"))

  local flush
  flush = function()
    vim.defer_fn(flush, 1000)
    f:flush()
  end

  flush()

  return function(msg)
    f:write(string.format("[%s] %s\n", os.date("%F %T"), msg))
  end
end)()

local dt_msg = "%s (%.0fms)"

local function dt(msg, f, ...)
  local t1 = now()
  local out = f(...)
  local t2 = now()

  log(dt_msg:format(msg, (t2 - t1) * ns_to_ms))

  return out
end

return dt
