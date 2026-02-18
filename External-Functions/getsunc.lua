local e = identifyexecutor and identifyexecutor() or getexecutorname and getexecutorname() or "Unknown"
e = e:gsub(" ", "%%20")

local u = "https://weao.xyz/api/status/exploits/" .. e
local r = request or http_request or syn and syn.request

if not r then
    return nil
end

local res = r({
    Url = u,
    Method = "GET",
    Headers = {
        ["User-Agent"] = "WEAO-3PService"
    }
})

if not res or not res.Body then
    return nil
end

local h = game:GetService("HttpService")
local d = h:JSONDecode(res.Body)

return d.suncPercentage
