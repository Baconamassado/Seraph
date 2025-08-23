-- shit require test
local success, result = pcall(function()
    local femboyModule = Instance.new("ModuleScript")
    femboyModule.Source = "return 123"
    return require(femboyModule) == 123
end)

if success and result then
    return true
else
    return false
end
