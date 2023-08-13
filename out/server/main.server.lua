-- Compiled with roblox-ts v2.1.1
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Events = ReplicatedStorage:WaitForChild("Events")
local startGame = Events:WaitForChild("startGame")
local getNewLevel = Events:WaitForChild("getNewLevel")
local addCoffee = Events:WaitForChild("addCoffee")
local startGameFunc = function(player, classNumber)
	local character = player.Character
	if not character then
		return nil
	end
	local humanoid = character:WaitForChild("Humanoid")
	local inst
	repeat
		if classNumber == 0 then
			coroutine.wrap(function()
				local cd = game:GetService("Workspace"):WaitForChild("Music"):WaitForChild("Countdown")
				cd:Play()
				cd.Ended:Wait()
				humanoid.WalkSpeed = 40
				humanoid.JumpPower = 50
				inst = Instance.new("BoolValue", character)
				inst.Name = "CanRevive"
				inst.Value = true
			end)()
			break
		end
		if classNumber == 1 then
			coroutine.wrap(function()
				local cd = game:GetService("Workspace"):WaitForChild("Music"):WaitForChild("Countdown")
				cd:Play()
				cd.Ended:Wait()
				humanoid.WalkSpeed = 36
				humanoid.JumpPower = 50
				inst = Instance.new("BoolValue", character)
				inst.Name = "CanRevive"
				inst.Value = true
			end)()
			break
		end
		if classNumber == 2 then
			coroutine.wrap(function()
				local cd = game:GetService("Workspace"):WaitForChild("Music"):WaitForChild("Countdown")
				cd:Play()
				cd.Ended:Wait()
				humanoid.WalkSpeed = 36
				humanoid.JumpPower = 50
			end)()
			break
		end
		coroutine.wrap(function()
			local cd = game:GetService("Workspace"):WaitForChild("Music"):WaitForChild("Countdown")
			cd:Play()
			cd.Ended:Wait()
			humanoid.WalkSpeed = 36
			humanoid.JumpPower = 50
		end)()
		break
	until true
	startGame:FireClient(player, classNumber)
	getNewLevel:FireClient(player)
end
startGame.OnServerEvent:Connect(function(player, ...)
	local args = { ... }
	return startGameFunc(player, args[1])
end)
local addCoffeeFunc = function(player, amount)
	addCoffee:FireClient(player, amount)
end
addCoffee.OnServerEvent:Connect(function(player, ...)
	local args = { ... }
	return addCoffeeFunc(player, args[1])
end)
