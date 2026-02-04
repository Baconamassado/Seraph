-- Provavelmente vai ser subistituido pelo loading (que vai dar um proposito pra ele em vez de só demorar mais pra carregar)
-- realmente subistituido pelo loading, mas vou deixar ai pra possiveis utilidades futuras


local function baixarIm(url, f, customPath)
    local basePath = customPath or "Seraph/Universal"
    local path = basePath .. "/" .. f

    local data = game:HttpGet(url)
    writefile(path, data)

    return path
end

return baixarIm
