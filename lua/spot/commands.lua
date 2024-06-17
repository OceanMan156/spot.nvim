local auth = require("spot.auth")
local curl = require("plenary.curl")

-- Telescope imports for floating windows
vim.notify = require("notify")
SELECTED_DEVICE = ""

local M = {}

local function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

M.play = function ()
  local token = auth.getAuth()
  local url = "https://api.spotify.com/v1/me/player/play?device_id=" .. SELECTED_DEVICE
  local res = curl.put(url, {
    headers = {
      Authorization = "Bearer " .. token,
      content_type = "application/json",
    },
    body = ""
  })

  if res['status'] ~= 204 then
    vim.notify("Failed to play track")
  end
end

M.play_from_uri = function (Uri, playlisturi)
  local token = auth.getAuth()
  local jsonUri = {uri = Uri}
  local json = {context_uri = playlisturi, position_ms = 0, offset = jsonUri}
  local url = "https://api.spotify.com/v1/me/player/play?device_id=" .. SELECTED_DEVICE
  local res = curl.put(url, {
    headers = {
      Authorization = "Bearer " .. token,
      content_type = "application/json",
    },
    body = vim.fn.json_encode(json)
  })

  if res['status'] ~= 204 then
    vim.notify("Failed to play track")
  end
end

M.pause = function ()
  local token = auth.getAuth()
  local url = "https://api.spotify.com/v1/me/player/pause"
  local res = curl.put(url, {
    headers = {
      Authorization = "Bearer " .. token,
    },
    body = vim.fn.json_encode("")
  })

  if res['status'] ~= 204 then
    vim.notify("Failed to get pause track")
  end
end

-- NOT WORKING
local function AddtoQueue(track)
  local line = vim.trim(vim.api.nvim_get_current_line())
  if line[1] == "-" then
    local token = auth.getAuth()
    local url = "https://api.spotify.com/v1/me/player/queue?uri=" .. track
    local res = curl.post(url, {
      headers = {
        Authorization = "Bearer " .. token,
      },
    })
    print(res.body)
  end
end

M.next = function ()
  local token = auth.getAuth()
  local url = "https://api.spotify.com/v1/me/player/next"
  local res = curl.post(url, {
    headers = {
      Authorization = "Bearer " .. token,
    },
  })

  if res['status'] ~= 204 then
    vim.notify("Failed to skip track")
  end
end

M.retrieve_songs = function (playlist_id)
  local token = auth.getAuth()
  local url = "https://api.spotify.com/v1/playlists/" .. playlist_id .. "/tracks"
  local res = curl.get(url, {
    headers = {
      Authorization = "Bearer " .. token,
    },
  })

  if res['status'] ~= 200 then
    vim.notify("Failed to get songs in playlist")
  end

  local tr = vim.fn.json_decode(res.body)
  local tracks = {}

  for i, _ in ipairs(tr.items) do
    tracks[tr.items[i].track.name] = tr.items[i].track.uri
  end

  return tracks
end

-- Get Playlist once rather than everytime
M.retrieve_playlist = function ()
  local token = auth.getAuth()
  local url = "https://api.spotify.com/v1/me/playlists"
  local res = curl.get(url, {
    headers = {
      Authorization = "Bearer " .. token,
    },
  })

  if res['status'] ~= 200 then
    vim.notify("Failed to get user playlist")
  end

  local pl = vim.fn.json_decode(res.body)
  local playlists = {}

  for i, _ in ipairs(pl.items) do
    playlists[pl.items[i].name] = {pl.items[i].id, pl.items[i].uri}
  end

  if next(playlists) == nil then
    vim.notify("No Playlist found", vim.log.levels.ERROR)
  end

  return playlists
end

M.retrieve_devices = function ()
  local token = auth.getAuth()
  local url = "https://api.spotify.com/v1/me/player/devices"
  local res = curl.get(url, {
    headers = {
      Authorization = "Bearer " .. token,
    },
  })

  if res['status'] ~= 200 then
    vim.notify("Failed to get available devices")
  end

  local dev = vim.fn.json_decode(res.body)
  local devices = {}

  for i, _ in ipairs(dev.devices) do
    devices[dev.devices[i].name] = dev.devices[i].id
  end

  if next(devices) == nil then
    vim.notify("No device found", vim.log.levels.ERROR)
  end

  -- Set default device
  for k,_ in pairs(devices) do
    SELECTED_DEVICE = devices[k]
    break
  end
end

return M

