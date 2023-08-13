-- Compiled with roblox-ts v2.1.1
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")
local StartGame = Events:WaitForChild("startGame")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Lighting = game:GetService("Lighting")
local createBlurAndScreens = function()
	local blur = Instance.new("BlurEffect", Lighting)
	blur.Size = 24
	blur.Name = "TitleScreenBlur"
	local background = PlayerGui:WaitForChild("Background")
	background.Enabled = true
	local StartGui = PlayerGui:WaitForChild("StartGui")
	StartGui.Enabled = true
	local CoffeeGui = PlayerGui:WaitForChild("CoffeeGui")
	CoffeeGui.Enabled = false
end
createBlurAndScreens()
LocalPlayer.CharacterRemoving:Connect(function()
	createBlurAndScreens()
end)
