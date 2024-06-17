-- Telescope imports for floating windows
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local actions = require "telescope.actions"
local preview = require "telescope.previewers"
local action_state = require "telescope.actions.state"
local conf = require("telescope.config").values
local commands = require("spot.commands")
local setup = require("spot")
vim.notify = require("notify")


local M = {}
M.playlists = {}

M.display_songs = function(playlist)
  if next(M.playlists) == nil then
    M.display_playlist()
  end
  print(vim.inspect(M.playlists))
  local tracks = commands.retrieve_songs(M.playlists[playlist][1])
  local table_list = {}
  for k,_ in pairs(tracks) do
    table.insert(table_list, "Song: " .. k)
  end

  local opts = setup._dropdown_theme or {}
  pickers.new(opts, {
    prompt_title = "Songs",
    finder = finders.new_table {
      results = table_list
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local line_selection = action_state.get_selected_entry()
        local selection_value = vim.split(line_selection[1], ":")[2]

        selection_value = vim.trim(selection_value)

        vim.notify("Playing: " .. selection_value, vim.log.levels.INFO)
        commands.play_from_uri(tracks[selection_value],
                               M.playlists[playlist][2])
      end)
      return true
    end,
  }):find()
end

M.display_playlist = function()
  if next(M.playlists) == nil then
    M.playlists = commands.retrieve_playlist()
  end

  local table_list = {}
  for k,_ in pairs(M.playlists) do
    table.insert(table_list, k)
  end

  local opts = setup._dropdown_theme or {}
  pickers.new(opts, {
    prompt_title = "Playlist",
    finder = finders.new_table {
      results = table_list
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        print(vim.inspect(selection))
        M.display_songs(selection[1])
      end)
      return true
    end,
  }):find()
end

local TeleQueue = function (opts)
  opts = setup._dropdown_theme or {}
  pickers.new(opts, {
    prompt_title = "Queue",
    finder = finders.new_table{
      results = {},
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function (prompt_bufnr, _)
      actions.select_default:replace(function ()
        actions.close(prompt_bufnr)
      end)
      return true
    end,
    previewer = preview.new_buffer_previewer{
      title = "Current Queue",
      define_preview = function (self, entry, status)
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, {"Current Queue"})
      end
    }
  }):find()
end

return M
