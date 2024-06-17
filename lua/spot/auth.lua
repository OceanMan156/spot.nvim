local curl = require("plenary.curl")
local encodedClient = os.getenv("clientCredentials")
local clientRefreshtoken = os.getenv("clientRefreshtoken")

local function getAuth()
 local url = "https://accounts.spotify.com/api/token"
  local res = curl.post(url, {
    headers = {
      Authorization = "Basic " .. encodedClient
    },
    body = {
      grant_type = "refresh_token",
      refresh_token = clientRefreshtoken,
    }
  })
  return vim.fn.json_decode(res.body).access_token
end

local function getRefreshToken()
 local url = "https://accounts.spotify.com/api/token"
  local res = curl.post(url, {
    headers = {
      Authorization = "Basic " .. encodedClient
    },
    body = {
      grant_type = "authorization_code",
      code = "",
      redirect_uri = "https://example.com/callback"
    }
  })
  print(res.body)
end

return {
  getAuth = getAuth,
  getRefreshToken = getRefreshToken
}
