-- Segunda versão de teste


local function baixarIm(url, f, customPath)
    local basePath = customPath or "Seraph/Universal"
    local path = basePath .. "/" .. f

    local data = game:HttpGet(url)
    writefile(path, data)

    return path
end

return baixarIm
