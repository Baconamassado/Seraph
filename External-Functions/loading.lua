local ts = game:GetService("TweenService")
local p = game:GetService("Players")
local pl = p.LocalPlayer
local pg = pl:WaitForChild("PlayerGui")
local NEON_WHITE = Color3.fromRGB(230, 255, 255)
local NEON_BLACK = Color3.fromRGB(6, 6, 6)
local ACCENT = Color3.fromRGB(120, 255, 240)
local sg = Instance.new("ScreenGui")
sg.Name = "LoadingUI"
sg.ResetOnSpawn = false
sg.Parent = pg
local m = Instance.new("Frame")
m.Name = "Main"
m.Parent = sg
m.AnchorPoint = Vector2.new(0.5, 0.5)
m.Position = UDim2.new(0.5, 0, 0.5, 60)
m.Size = UDim2.new(0, 360, 0, 78)
m.BackgroundColor3 = NEON_BLACK
m.BackgroundTransparency = 1
m.BorderSizePixel = 0
local mC = Instance.new("UICorner"); mC.Parent = m; mC.CornerRadius = UDim.new(0, 14)
local mS = Instance.new("UIStroke"); mS.Parent = m; mS.Color = ACCENT; mS.Transparency = 0.6; mS.Thickness = 1
local ttl = Instance.new("TextLabel")
ttl.Name = "Title"
ttl.Parent = m
ttl.AnchorPoint = Vector2.new(0, 0)
ttl.Position = UDim2.new(0, 16, 0, 10)
ttl.Size = UDim2.new(1, -32, 0, 22)
ttl.BackgroundTransparency = 1
ttl.Text = "Carregando..."
ttl.TextColor3 = NEON_WHITE
ttl.Font = Enum.Font.Gotham
ttl.TextSize = 16
ttl.TextXAlignment = Enum.TextXAlignment.Left
ttl.TextTransparency = 1
local sub = Instance.new("TextLabel")
sub.Name = "Sub"
sub.Parent = m
sub.AnchorPoint = Vector2.new(0, 0)
sub.Position = UDim2.new(0, 16, 0, 32)
sub.Size = UDim2.new(1, -32, 0, 16)
sub.BackgroundTransparency = 1
sub.Text = "Aguarde..."
sub.TextColor3 = Color3.fromRGB(180, 255, 250)
sub.Font = Enum.Font.Gotham
sub.TextSize = 12
sub.TextXAlignment = Enum.TextXAlignment.Left
sub.TextTransparency = 1
local bg = Instance.new("Frame")
bg.Name = "BarBg"
bg.Parent = m
bg.AnchorPoint = Vector2.new(0, 0)
bg.Position = UDim2.new(0, 14, 0, 50)
bg.Size = UDim2.new(1, -28, 0, 16)
bg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
bg.BackgroundTransparency = 0.05
bg.BorderSizePixel = 0
local bgC = Instance.new("UICorner"); bgC.Parent = bg; bgC.CornerRadius = UDim.new(0, 8)
local bgS = Instance.new("UIStroke"); bgS.Parent = bg; bgS.Color = ACCENT; bgS.Transparency = 0.75; bgS.Thickness = 1
local bar = Instance.new("Frame")
bar.Name = "Bar"
bar.Parent = bg
bar.AnchorPoint = Vector2.new(0, 0)
bar.Position = UDim2.new(0, 0, 0, 0)
bar.Size = UDim2.new(0, 0, 1, 0)
bar.BackgroundColor3 = NEON_WHITE
bar.BorderSizePixel = 0
local barC = Instance.new("UICorner"); barC.Parent = bar; barC.CornerRadius = UDim.new(0, 8)
local barG = Instance.new("UIGradient"); barG.Parent = bar
barG.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.0, NEON_BLACK),
    ColorSequenceKeypoint.new(1.0, NEON_WHITE),
}
barG.Rotation = 0
local barS = Instance.new("UIStroke"); barS.Parent = bar; barS.Color = ACCENT; barS.Transparency = 0.4; barS.Thickness = 1.5
local appearTI = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local progressTI = TweenInfo.new(0.45, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
local disappearTI = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local loaded = false
local function appear()
    local targetPos = UDim2.new(0.5, 0, 0.5, 0)
    ts:Create(m, appearTI, {Position = targetPos}):Play()
    ts:Create(m, TweenInfo.new(0.45), {BackgroundTransparency = 0.12}):Play()
    ts:Create(ttl, TweenInfo.new(0.45), {TextTransparency = 0}):Play()
    ts:Create(sub, TweenInfo.new(0.55), {TextTransparency = 0}):Play()
end
local function hideAndDestroy()
    local outPos = UDim2.new(0.5, 0, 0.5, 80)
    local t1 = ts:Create(m, disappearTI, {Position = outPos, BackgroundTransparency = 1})
    t1:Play()
    t1.Completed:Wait()
    loaded = true
    if sg and sg.Parent then
        sg:Destroy()
    end
end
local function setProgress(p, duration)
    p = math.clamp(p, 0, 1)
    local targetSize = UDim2.new(p, 0, 1, 0)
    local t = ts:Create(bar, duration and TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.Out) or progressTI, {Size = targetSize})
    t:Play()
end
local function waitforloading()
    while not loaded do
        task.wait()
    end
end
spawn(function()
    appear()
    task.wait(0.3)
    local factor = 0.12
    local currentValue = 0
    while currentValue < 1 do
        currentValue = math.min(currentValue + factor, 1)
        setProgress(currentValue)
        if currentValue >= 1 then break end
        task.wait(0.28)
    end
    setProgress(1, 0.45)
    task.wait(0.5)
    hideAndDestroy()
end)
return {
    waitforloading = waitforloading,
    SetProgress = setProgress,
    Show = appear,
    Hide = hideAndDestroy,
    Gui = sg
}
