local function iLoveFemboy()
    return "I love femboys"
end

local iDontLoveFemboy = newcclosure(iLoveFemboy)

if iDontLoveFemboy() ~= iLoveFemboy() then
    return false
elseif iDontLoveFemboy == iLoveFemboy then
    return false
elseif not iscclosure(iDontLoveFemboy) then
    return false
else
    return true
end
