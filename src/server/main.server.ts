const ReplicatedStorage = game.GetService("ReplicatedStorage")
const Players = game.GetService("Players")
const Events = ReplicatedStorage.WaitForChild("Events") as Folder
const startGame = Events.WaitForChild("startGame") as RemoteEvent
const getNewLevel = Events.WaitForChild("getNewLevel") as RemoteEvent
const addCoffee = Events.WaitForChild("addCoffee") as RemoteEvent

const startGameFunc = (player: Player, classNumber: number) => {
    const character = player.Character
    if (!character) return
    const humanoid = character.WaitForChild("Humanoid") as Humanoid
    let inst: BoolValue
    switch (classNumber) {
        case 0:
            coroutine.wrap(() => {
                let cd = game.GetService("Workspace").WaitForChild("Music").WaitForChild("Countdown") as Sound
                cd.Play()
                cd.Ended.Wait()
                humanoid.WalkSpeed = 40
                humanoid.JumpPower = 50
                inst = new Instance("BoolValue", character)
                inst.Name = "CanRevive"
                inst.Value = true
            })()
            break
        case 1:
            coroutine.wrap(() => {
                let cd = game.GetService("Workspace").WaitForChild("Music").WaitForChild("Countdown") as Sound
                cd.Play()
                cd.Ended.Wait()
                humanoid.WalkSpeed = 36
                humanoid.JumpPower = 50
                inst = new Instance("BoolValue", character)
                inst.Name = "CanRevive"
                inst.Value = true
            })()
            break
        case 2:
            coroutine.wrap(() => {
                let cd = game.GetService("Workspace").WaitForChild("Music").WaitForChild("Countdown") as Sound
                cd.Play()
                cd.Ended.Wait()
                humanoid.WalkSpeed = 36
                humanoid.JumpPower = 50
            })()
            break
        default:
            coroutine.wrap(() => {
                let cd = game.GetService("Workspace").WaitForChild("Music").WaitForChild("Countdown") as Sound
                cd.Play()
                cd.Ended.Wait()
                humanoid.WalkSpeed = 36
                humanoid.JumpPower = 50
            })()
            break
    }
    startGame.FireClient(player, classNumber)
    getNewLevel.FireClient(player)
}

startGame.OnServerEvent.Connect((player, ...args: unknown[]) => startGameFunc(player, args[0] as number))

const addCoffeeFunc = (player: Player, amount: number) => {
    addCoffee.FireClient(player, amount)
}

addCoffee.OnServerEvent.Connect((player, ...args: unknown[]) => addCoffeeFunc(player, args[0] as number))
