const ReplicatedStorage: ReplicatedStorage = game.GetService("ReplicatedStorage")
const Events: Folder = ReplicatedStorage.WaitForChild("Events") as Folder
const StartGame: RemoteEvent = Events.WaitForChild("startGame") as RemoteEvent
const Players: Players = game.GetService("Players")
const LocalPlayer: Player = Players.LocalPlayer
const PlayerGui: PlayerGui = LocalPlayer.WaitForChild("PlayerGui") as PlayerGui
const Lighting: Lighting = game.GetService("Lighting")

const createBlurAndScreens = () => {
    let blur: BlurEffect = new Instance("BlurEffect", Lighting)
    blur.Size = 24
    blur.Name = "TitleScreenBlur"
    const background = PlayerGui.WaitForChild("Background") as ScreenGui
    background.Enabled = true
    const StartGui = PlayerGui.WaitForChild("StartGui") as ScreenGui
    StartGui.Enabled = true
    const CoffeeGui = PlayerGui.WaitForChild("CoffeeGui") as ScreenGui
    CoffeeGui.Enabled = false
};

createBlurAndScreens()

LocalPlayer.CharacterRemoving.Connect(() => {
    createBlurAndScreens()
})
