-- By x7bokab
-- Remote Spy for Seraph

local SimpleRemoteSpy = {}

local hooked = false
local oldNamecall

function SimpleRemoteSpy.Start(onEventFired)
    if hooked then return end
    hooked = true

    local mt = getrawmetatable(game)
    setreadonly(mt, false)

    oldNamecall = oldNamecall or mt.__namecall

    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()

        if method == "FireServer" or method == "InvokeServer" then
            local args = { ... }
            task.spawn(function()
                pcall(onEventFired, self, method, args)
            end)
        end

        return oldNamecall(self, ...)
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
