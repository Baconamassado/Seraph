-- script podre que eu fiz com chat gpt pra pegar coisa de um jogo randola chamado hack battles (me arrependi porque o jogo é um lixo e perdi tempo)
repeat task.wait() until game:IsLoaded()

local folder
repeat
	task.wait()
	folder = workspace:FindFirstChild("ImportantParts", true)
until folder
repeat task.wait() until #folder:GetDescendants() > 8

local removed = 0
local kept = 0

for _, obj in ipairs(folder:GetDescendants()) do
	if obj:IsA("BasePart") then
		local touch = obj:FindFirstChildOfClass("TouchTransmitter")
		if touch then
			local name = obj.Name:lower()

			if name:find("jump") or name:find("teleport") then
				kept += 1
			else
				obj:Destroy()
				removed += 1
			end
		end
	end
end

print("[TouchCleaner] Removidos:", removed, "| Mantidos:", kept)


workspace.FallenPartsDestroyHeight = -math.huge

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer

-------------------------------------------------
-- SERVER HOP CONFIG
-------------------------------------------------

local MAX_PLAYERS_SERVER = 3
local HOP_INTERVAL = 300 -- 5 minutos

-------------------------------------------------
-- SERVER HOP STATE
-------------------------------------------------

local lastHop = os.clock()
local hopping = false
local visited = {}

-------------------------------------------------
-- UTILS
-------------------------------------------------

local function getHumanoid()
	local char = player.Character
	if not char then return end
	return char:FindFirstChildOfClass("Humanoid")
end

-------------------------------------------------
-- FIND LOW PLAYER SERVER
-------------------------------------------------

local function findLowServer(cursor)
	local url =
		"https://games.roblox.com/v1/games/"
		.. game.PlaceId
		.. "/servers/Public?sortOrder=Asc&limit=100"
		.. (cursor and "&cursor=" .. cursor or "")

	local data = HttpService:JSONDecode(game:HttpGet(url))

	for _, server in ipairs(data.data) do
		if server.playing <= MAX_PLAYERS_SERVER and not visited[server.id] then
			return server.id
		end
	end

	return data.nextPageCursor
end

-------------------------------------------------
-- SERVER HOP
-------------------------------------------------

local function serverHop(reason)
	if hopping then return end
	hopping = true

	warn("[SERVER HOP]", reason)

	local cursor = nil

	while true do
		local result = findLowServer(cursor)

		if type(result) == "string" then
			visited[result] = true
			TeleportService:TeleportToPlaceInstance(
				game.PlaceId,
				result,
				player
			)
			return
		else
			cursor = result
			if not cursor then
				visited = {}
				cursor = nil
			end
		end

		task.wait(0.4)
	end
end


local player = Players.LocalPlayer

-------------------------------------------------
-- CONFIG
-------------------------------------------------

local MAX_TIME_PER_COIN = 1 -- segundos
local MIN_TWEEN_TIME = 0.2
local MAX_TWEEN_TIME = 0.8

-------------------------------------------------
-- Utils
-------------------------------------------------

local function getChar()
	return player.Character or player.CharacterAdded:Wait()
end

local function getHRP()
	return getChar():WaitForChild("HumanoidRootPart")
end

-------------------------------------------------
-- NOCLIP + ANTI-GRAVIDADE
-------------------------------------------------

RunService.Stepped:Connect(function()
	local char = player.Character
	if not char then return end
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = false
			part.AssemblyLinearVelocity = Vector3.zero
		end
	end
end)

local function expandHitboxDown(hitbox)
	if not hitbox:IsA("BasePart") then return end

	local expand = 35
	local size = hitbox.Size

	hitbox.Anchored = false
	hitbox.CanCollide = false
	hitbox.CanTouch = true
	hitbox.Size = Vector3.new(size.X + expand, size.Y + expand, size.Z + expand)
	hitbox.CFrame = hitbox.CFrame * CFrame.new(0, -expand / 2, 0)
end

local function getClosestCoin()
	local folder = workspace:FindFirstChild("ActiveCoins")
	if not folder then return nil end

	local hrp = getHRP()
	local closest, closestDist

	for _, coin in ipairs(folder:GetChildren()) do
		if coin:IsA("BasePart") then
			local dist = (coin.Position - hrp.Position).Magnitude
			if not closestDist or dist < closestDist then
				closest = coin
				closestDist = dist
			end
		end
	end

	return closest, closestDist
end


local function tpToCoin(coin)
	local hrp = getHRP()
	if not hrp or not coin then return end

	local start = os.clock()

	while coin.Parent == workspace.ActiveCoins do
		if os.clock() - start >= MAX_TIME_PER_COIN then
			break
		end

		hrp.CFrame = coin.CFrame * CFrame.new(0, 1.5, 0)
		RunService.Heartbeat:Wait()
	end
end


local function tweenUntilCollected(coin)
	local hrp = getHRP()
	local startTime = os.clock()

	local hitbox = coin:FindFirstChild("MagnetHitbox") or coin
	expandHitboxDown(hitbox)

	while coin.Parent == workspace.ActiveCoins do
		local elapsed = os.clock() - startTime
		if elapsed >= MAX_TIME_PER_COIN then
			break -- ⏱️ timeout REAL
		end

		local dist = (coin.Position - hrp.Position).Magnitude

		local tweenTime = math.clamp(
			0.2,
			0.1,
			0.3
		)

		-- nunca criar tween que passe do tempo restante
		local remaining = MAX_TIME_PER_COIN - elapsed
		tweenTime = math.min(tweenTime, remaining)

		local tween = TweenService:Create(
			hrp,
			TweenInfo.new(tweenTime, Enum.EasingStyle.Linear),
			{ CFrame = coin.CFrame * CFrame.new(0, 1.5, 0) }
		)

		tween:Play()

		local finished = false
		tween.Completed:Once(function()
			finished = true
		end)

		while not finished do
			if os.clock() - startTime >= MAX_TIME_PER_COIN then
				tween:Cancel()
				return
			end
			RunService.Heartbeat:Wait()
		end
	end
end

-------------------------------------------------
-- Loop principal AFK
-------------------------------------------------

task.spawn(function()
	while true do
		local coin = getClosestCoin()
		if coin then
			tpToCoin(coin)
		end
		task.wait(0.1)
	end
end)

-------------------------------------------------
-- AUTO SERVER HOP CHECK
-------------------------------------------------

task.spawn(function()
	while true do
		local hum = getHumanoid()

		if hum and hum.Health > 0 and hum.Health < 50 then
			lastHop = os.clock()
			serverHop("Vida abaixo de 50")
		end

		-- ⏱️ Intervalo de tempo → hop
		if os.clock() - lastHop >= HOP_INTERVAL then
			lastHop = os.clock()
			serverHop("Intervalo de 5 minutos")
		end

		task.wait(1)
	end
end)

task.wait(1)
for _, obj in ipairs(folder:GetDescendants()) do
	if obj:IsA("BasePart") then
		local touch = obj:FindFirstChildOfClass("TouchTransmitter")
		if touch then
			local name = obj.Name:lower()

			if name:find("jump") or name:find("teleport") then
				kept += 1
			else
				print('Destruindo')
				obj:Destroy()
			end
		end
	end
end
