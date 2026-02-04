-- esse script usa a api do weao (https://weao.xyz)
local hs = game:GetService("HttpService")

local r =
    syn and syn.request or
    request or
    http_request or
    fluxus and fluxus.request

if not r then
    error("Executor does not support request")
end

local en = (identifyexecutor and identifyexecutor()) or "Unknown"

print("Detected executor:", en)

local function wr(u)
    local rs = r({
        Url = u,
        Method = "GET",
        Headers = {
            ["User-Agent"] = "WEAO-3PService"
        }
    })

    if not rs or rs.StatusCode ~= 200 then
        error("Request failed: " .. tostring(rs and rs.StatusCode))
    end

    return hs:JSONDecode(rs.Body)
end

local function ne(n)
    n = string.lower(n)
    n = string.gsub(n, "%s+", "")
    return n
end

local ean = ne(en)

local ed = wr("https://weao.xyz/api/status/exploits/" .. ean)

local srv = ed.rbxversion
local ev = ed.version

print("Executor version:", ev)
print("Supported Roblox version:", srv)

local vd = wr("https://weao.xyz/api/versions/current")

local crv = vd.Windows

print("Current Roblox version:", crv)

local iu = srv == crv

return {
    executor = en,
    executorVersion = ev,
    supportedRobloxVersion = srv,
    currentRobloxVersion = crv,
    updated = iu
}
