local success, result = pcall(function()
    local object = { success = false }
    
    table.freeze(object)
    setreadonly(object, false)
    object.success = true
    
    return object.success == true
end)

local tableModificationSupported = success and result

if tableModificationSupported then
    return true
else
    return false
end
