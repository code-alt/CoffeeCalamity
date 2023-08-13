-- Compiled with roblox-ts v2.1.1
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")
local StartGame = Events:WaitForChild("startGame")
local AddCoffee = Events:WaitForChild("addCoffee")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Lighting = game:GetService("Lighting")
local coffeeEnabled = false
local coffeeLevel = 100
local maxCoffeeLevel = 100
local RunService = game:GetService("RunService")
local CoffeeGui = PlayerGui:WaitForChild("CoffeeGui")
local CoffeeBar = CoffeeGui:WaitForChild("HoldingBar"):WaitForChild("Coffee")
local broDied = false
StartGame.OnClientEvent:Connect(function(classNumber)
	repeat
		if classNumber == 0 then
			coroutine.wrap(function()
				wait(5.459)
				coffeeEnabled = true
			end)()
			coffeeLevel = 150
			maxCoffeeLevel = 150
			break
		end
		if classNumber == 1 then
			coroutine.wrap(function()
				wait(5.459)
				coffeeEnabled = true
			end)()
			coffeeLevel = 100
			maxCoffeeLevel = 100
			break
		end
		if classNumber == 2 then
			coroutine.wrap(function()
				wait(5.459)
				coffeeEnabled = true
			end)()
			coffeeLevel = 100
			maxCoffeeLevel = 100
			break
		end
		coroutine.wrap(function()
			wait(5.459)
			coffeeEnabled = true
		end)()
		coffeeLevel = 100
		maxCoffeeLevel = 100
	until true
	for _, child in Lighting:GetChildren() do
		if child.Name == "TitleScreenBlur" then
			child:Destroy()
		end
	end
	local background = PlayerGui:WaitForChild("Background")
	background.Enabled = false
	local StartGui = PlayerGui:WaitForChild("StartGui")
	StartGui.Enabled = false
	CoffeeGui.Enabled = true
end)
RunService.RenderStepped:Connect(function(deltaTime)
	if coffeeEnabled then
		coffeeLevel -= 15 * deltaTime
		CoffeeBar.Size = UDim2.new(coffeeLevel / maxCoffeeLevel, 0, 0, 15)
	end
	if coffeeLevel <= 0 and not broDied then
		broDied = true
		coffeeEnabled = false
		CoffeeGui.Enabled = false
		local _result = LocalPlayer.Character
		if _result ~= nil then
			_result = _result:WaitForChild("Humanoid")
		end
		_result:TakeDamage(1000)
		do
			local i = 0
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					i += 1
				else
					_shouldIncrement = true
				end
				if not (i < 10) then
					break
				end
				coroutine.wrap(function()
					local sound = (game:GetService("Workspace"):WaitForChild("Music"):WaitForChild("Explosion")):Clone()
					sound.Parent = game:GetService("Workspace"):WaitForChild("Music")
					sound:Play()
					wait(3)
					sound:Destroy()
				end)()
				local explosion = Instance.new("Explosion")
				local humanoidRootPart = (LocalPlayer.Character):WaitForChild("HumanoidRootPart")
				local _position = humanoidRootPart.Position
				local _vector3 = Vector3.new(math.random(-10, 10), math.random(-10, 10), math.random(-10, 10))
				explosion.Position = _position + _vector3
				explosion.Parent = game:GetService("Workspace")
				explosion.BlastRadius = 10
				explosion.BlastPressure = 100000
				explosion.DestroyJointRadiusPercent = 0
				coroutine.wrap(function()
					wait(3)
					explosion:Destroy()
				end)()
				wait(0.2)
			end
		end
	end
end)
AddCoffee.OnClientEvent:Connect(function(amount)
	coffeeLevel += amount
	if coffeeLevel > maxCoffeeLevel then
		coffeeLevel = maxCoffeeLevel
	end
end)
