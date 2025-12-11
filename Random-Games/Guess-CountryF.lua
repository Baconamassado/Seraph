-- Eu fiz essa porra no editor do executor mesmo fodase
local P,R=game:GetService("Players"),game:GetService("ReplicatedStorage")
local pl,F=P.LocalPlayer,P.LocalPlayer.PlayerGui.GameUI.REFERENCED__GameUIFrame.TopFlag.FlagImage
local M=require(R.Packages.GameData.Flags)
local Airflow = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/4lpaca-pin/Airflow/refs/heads/main/src/source.luau"))();
local UserInputService = game:GetService("UserInputService")

local Config={
    autoSolve=false,    
    solveDelay=0        
}


local Window = Airflow:Init({
	Name = "Country auto guesser",
	Keybind = "LeftAlt",
	Logo = nil,
  Scale = UDim2.new(0.0655, 337, 0.0655, (UserInputService.TouchEnabled and 227) or 259),
	Highlight = Color3.fromRGB(163, 128, 216),
	Resizable = true,
	UnlockMouse = false,
	IconSize = 20,
});

local Ez = Window:DrawTab({
	Name = "Solver",
	Icon = "file"
});

local aa = Ez:AddSection({
	Name = "Solver",
	Position = "left",
});

aa:AddToggle({
	Name = "Auto solver",
	Default = false,
	Callback = function(v)
        print(v)
        Config.autoSolve = v
    end
})

aa:AddTextbox({
	Name = "Solve delay", 
	Numeric = true,
	Placeholder = "0",
	Default = "0",
	Finished = true,
	Callback = Config.solveDelay,
})

local bb = Airflow:DrawList({
	Name = "Country",
	Icon = nil
});

local dp = bb:AddFrame({
	Key = "C",
	Value = "Awaiting..."
});

local function id(s) return s:match("%d+") end

local function findCountry(i)
	for d,l in pairs(M) do
		for _,v in ipairs(l) do
			if tostring(v.ImageId)==tostring(i) then return v.CountryName,d end
		end
	end
end

local function update()
    local c, d = findCountry(id(F.Image))
    if c then
        dp:SetValue(c .. " (" .. d .. ")")
        if Config.autoSolve then
            task.spawn(function()
                task.wait(Config.solveDelay)
                R.Packages.Knit.Services.FlagsService.RF.Solve:InvokeServer(c)
            end)
        end
    else
        dp:SetValue("Country not found")
    end
end


update()
F:GetPropertyChangedSignal("Image"):Connect(update)
