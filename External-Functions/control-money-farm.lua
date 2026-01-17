local ps = game:GetService("Players")
local ts = game:GetService("TeleportService")

local p = ps.LocalPlayer
local c = workspace.CurrentCamera

-- Character
local ch = p.Character or p.CharacterAdded:Wait()
local hrp = ch:WaitForChild("HumanoidRootPart")

local is = workspace.Map.References.ItemSpawners

local a = 0

local function gpp(pp)
	if pp.Parent:IsA("Attachment") then
		return pp.Parent.Parent
	elseif pp.Parent:IsA("BasePart") then
		return pp.Parent
	end
	return nil
end

local function la(pos)
	print("Looking...")
	c.CFrame = CFrame.new(c.CFrame.Position, pos)
end

local function ap()
	local f = false

	for _, o in ipairs(is:GetDescendants()) do
		if o:IsA("ProximityPrompt") and o.Enabled then
			local pt = gpp(o)
			if pt and pt:IsA("BasePart") then
				f = true

				hrp.CFrame = pt.CFrame * CFrame.new(0, 0, -3)
				task.wait(0.15)

				la(pt.Position)
				task.wait(0.15)

				fireproximityprompt(o, o.HoldDuration or 0)
				task.wait(0.2)
			end
		end
	end

	return f
end

while true do
	local at = ap()

	if not at then
		break
	end

	a += 1
	if a >= 20 then
		break
	end

	task.wait(0.5)
end
