-- Compiled with roblox-ts v2.1.1
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local getNewLevel = Events:WaitForChild("getNewLevel")
local completedLevels = -1
local lastLevel
local lastLevelSize = 0
local humanoid
local makeNewRandomLevel
local Level
do
	Level = setmetatable({}, {
		__tostring = function()
			return "Level"
		end,
	})
	Level.__index = Level
	function Level.new(...)
		local self = setmetatable({}, Level)
		return self:constructor(...) or self
	end
	function Level:constructor(model)
		if model == nil then
			model = Instance.new("Model")
		end
		self.model = model:Clone()
	end
	function Level:generate()
		local levelSize = self.model:WaitForChild("LevelSize")
		local levelSizeZ = levelSize.Size.Z
		local oldLevelSize = lastLevelSize
		for _, child in self.model:GetDescendants() do
			if child:IsA("BasePart") or child:IsA("UnionOperation") then
				child.Position = Vector3.new(child.Position.X, child.Position.Y, child.Position.Z + oldLevelSize)
			end
			if child.Name == "KillPart" then
				if child:IsA("BasePart") then
					local event = child.Touched:Connect(function(part)
						if part.Parent == Players.LocalPlayer.Character and humanoid.Health > 0 then
							local _result = Players.LocalPlayer.Character
							if _result ~= nil then
								_result = _result:FindFirstChild("CanRevive")
							end
							local canRevive = _result
							local _result_1 = canRevive
							if _result_1 ~= nil then
								_result_1 = _result_1.Value
							end
							if _result_1 == true then
								local _result_2 = Players.LocalPlayer.Character
								if _result_2 ~= nil then
									_result_2 = _result_2:WaitForChild("HumanoidRootPart")
								end
								local rootPart = _result_2
								rootPart.CFrame = (self.model:FindFirstChild("Spawn")).CFrame
							else
								humanoid.Health = 0
							end
						end
					end)
				end
			end
		end
		if self.model:FindFirstChild("EndFrame") then
			local endFrame = self.model:FindFirstChild("EndFrame")
			local endPart = endFrame:FindFirstChild("EndPart")
			if endPart then
				local event
				event = endPart.Touched:Connect(function(part)
					print("DEBUG: Touched end part")
					if part.Parent == Players.LocalPlayer.Character then
						makeNewRandomLevel()
						local endPartCFrame = (endPart:WaitForChild("Part")).CFrame
						local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
						local _fn = game:GetService("TweenService")
						local _exp = endPart:WaitForChild("Part")
						local _object = {}
						local _left = "CFrame"
						local _vector3 = Vector3.new(0, 20.75, 0)
						_object[_left] = endPartCFrame + _vector3
						local endPartTween = _fn:Create(_exp, tweenInfo, _object)
						endPartTween:Play()
						endPart.CanCollide = false
					end
					event:Disconnect()
				end)
			end
		end
		self.model.Parent = game.Workspace:WaitForChild("Levels")
		lastLevel = self.model
		lastLevelSize += levelSizeZ
		if self.model:FindFirstChild("SpawnLocation") then
			(self.model:FindFirstChild("SpawnLocation")).Parent = game.Workspace
		end
	end
end
makeNewRandomLevel = function()
	local newLevel
	if completedLevels >= 8 then
		local ranModel = ReplicatedStorage:WaitForChild("Levels"):WaitForChild("Hard"):GetChildren()[math.random(1, #ReplicatedStorage:WaitForChild("Levels"):WaitForChild("Hard"):GetChildren()) - 1 + 1]
		while ranModel.Name == lastLevel.Name do
			ranModel = ReplicatedStorage:WaitForChild("Levels"):WaitForChild("Hard"):GetChildren()[math.random(1, #ReplicatedStorage:WaitForChild("Levels"):WaitForChild("Hard"):GetChildren()) - 1 + 1]
		end
		newLevel = Level.new(ranModel)
	elseif completedLevels >= 3 then
		local ranModel = ReplicatedStorage:WaitForChild("Levels"):WaitForChild("Medium"):GetChildren()[math.random(1, #ReplicatedStorage:WaitForChild("Levels"):WaitForChild("Medium"):GetChildren()) - 1 + 1]
		while ranModel.Name == lastLevel.Name do
			ranModel = ReplicatedStorage:WaitForChild("Levels"):WaitForChild("Medium"):GetChildren()[math.random(1, #ReplicatedStorage:WaitForChild("Levels"):WaitForChild("Medium"):GetChildren()) - 1 + 1]
		end
		newLevel = Level.new(ReplicatedStorage:WaitForChild("Levels"):WaitForChild("Medium"):GetChildren()[math.random(1, #ReplicatedStorage:WaitForChild("Levels"):WaitForChild("Medium"):GetChildren()) - 1 + 1])
	else
		local ranModel = ReplicatedStorage:WaitForChild("Levels"):WaitForChild("Easy"):GetChildren()[math.random(1, #ReplicatedStorage:WaitForChild("Levels"):WaitForChild("Easy"):GetChildren()) - 1 + 1]
		local th = "nil"
		if lastLevel then
			local _condition = lastLevel.Name
			if not (_condition ~= "" and _condition) then
				_condition = "nil"
			end
			th = _condition
		end
		if ranModel.Name == th then
			ranModel = ReplicatedStorage:WaitForChild("Levels"):WaitForChild("Easy"):GetChildren()[math.random(1, #ReplicatedStorage:WaitForChild("Levels"):WaitForChild("Easy"):GetChildren()) - 1 + 1]
		end
		newLevel = Level.new(ranModel)
	end
	newLevel:generate()
	completedLevels += 1
	local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
	(playerGui:WaitForChild("CoffeeGui"):WaitForChild("Count")).Text = tostring(completedLevels)
	return newLevel
end
getNewLevel.OnClientEvent:Connect(function()
	makeNewRandomLevel()
end)
local clearAll = function()
	local levelsFolder = game.Workspace:WaitForChild("Levels")
	for _, child in levelsFolder:GetChildren() do
		child:Destroy()
	end
	lastLevelSize = -46
	completedLevels = -1
end
local player = Players.LocalPlayer
player.CharacterAdded:Connect(function(character)
	humanoid = character:WaitForChild("Humanoid")
	humanoid.Died:Connect(function()
		clearAll()
		if game:GetService("Workspace"):FindFirstChild("Start") then
			game:GetService("Workspace"):WaitForChild("Start"):Destroy()
		end
		lastLevelSize = 0
		Level.new(ReplicatedStorage:WaitForChild("Levels"):WaitForChild("Start")):generate()
		lastLevel = game:GetService("Workspace"):FindFirstChild("Start")
		lastLevelSize = 0
		completedLevels = -1
	end)
end)
