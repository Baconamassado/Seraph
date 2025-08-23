local success, isSupported = pcall(function()
    local testMetatable = { __metatable = "Locked!" }
    local testObject = setmetatable({}, testMetatable)
    return getrawmetatable(testObject) == testMetatable
end)

if success and isSupported then
    return true
else
    return false
end
