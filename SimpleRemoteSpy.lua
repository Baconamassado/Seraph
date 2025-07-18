local SimpleRemoteSpy = {}

local hooked = false
local oldNamecall

function SimpleRemoteSpy.Start(onEventFired)
    if hooked then return end
    hooked = true

    local mt = getrawmetatable(game)
    setreadonly(mt, false)

    oldNamecall = mt.__namecall

    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local success, ret = pcall(oldNamecall, self, ...)

        if method == "FireServer" or method == "InvokeServer" then
            local args = {...}
            task.spawn(function()
                pcall(function()
                    onEventFired(self, method, args)
                end)
            end)
        end

        if success then
            return ret
        else
            error(ret)
        end
    end)

    setreadonly(mt, true)
end

function SimpleRemoteSpy.Stop()
    if not hooked then return end
    hooked = false

    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    mt.__namecall = oldNamecall
    setreadonly(mt, true)
end

return SimpleRemoteSpy
