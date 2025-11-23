-- Primeira versão de teste - Carregar com getcustomasset ( ou sla como escreve )


local function baixarIm(url, f)
    local path = "Seraph/Universal" .. "/" .. f

    local data = game:HttpGet(url)

    writefile(path, data)

    return path
end

return baixarIm
