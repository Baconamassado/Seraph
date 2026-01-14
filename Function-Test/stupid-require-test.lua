local function t()
    local m = Instance.new("ModuleScript")
    m.Name = "__require_test"
    m.Source = 'return "femboy > tomboy"'

    local ok, v = pcall(require, module)

    m:Destroy()

    return ok and v == "femboy > tomboy"
end

return t()
