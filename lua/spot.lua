local commands = require("spot.commands")
local M = {}

M._dropdown_theme = {}
M._devices = {}

M.setup = function (opts)
  M._dropdown_theme = opts
  M._devices = commands.retrieve_devices()
end

return M
