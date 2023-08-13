const ReplicatedStorage: ReplicatedStorage =
  game.GetService("ReplicatedStorage");
const Events: Folder = ReplicatedStorage.WaitForChild("Events") as Folder;
const StartGame: RemoteEvent = Events.WaitForChild("startGame") as RemoteEvent;
const AddCoffee: RemoteEvent = Events.WaitForChild("addCoffee") as RemoteEvent;
const Players: Players = game.GetService("Players");
const LocalPlayer: Player = Players.LocalPlayer;
const PlayerGui: PlayerGui = LocalPlayer.WaitForChild("PlayerGui") as PlayerGui;
const Lighting: Lighting = game.GetService("Lighting");
let coffeeEnabled: boolean = false;
let coffeeLevel = 100;
let maxCoffeeLevel = 100;
const RunService = game.GetService("RunService");

const CoffeeGui = PlayerGui.WaitForChild("CoffeeGui") as ScreenGui;
const CoffeeBar = CoffeeGui.WaitForChild("HoldingBar").WaitForChild(
  "Coffee"
) as Frame;

let broDied = false;

StartGame.OnClientEvent.Connect((classNumber: number) => {
  switch (classNumber) {
    case 0:
      coroutine.wrap(() => {
        wait(5.459)
        coffeeEnabled = true;
      })()
      coffeeLevel = 150;
      maxCoffeeLevel = 150;
      break;
    case 1:
      coroutine.wrap(() => {
        wait(5.459)
        coffeeEnabled = true;
      })()
      coffeeLevel = 100;
      maxCoffeeLevel = 100;
      break;
    case 2:
      coroutine.wrap(() => {
        wait(5.459)
        coffeeEnabled = true;
      })()
      coffeeLevel = 100;
      maxCoffeeLevel = 100;
      break;
    default:
      coroutine.wrap(() => {
        wait(5.459)
        coffeeEnabled = true;
      })()
      coffeeLevel = 100;
      maxCoffeeLevel = 100;
  }

  for (const child of Lighting.GetChildren()) {
    if (child.Name === "TitleScreenBlur") {
      child.Destroy();
    }
  }
  const background = PlayerGui.WaitForChild("Background") as ScreenGui;
  background.Enabled = false;
  const StartGui = PlayerGui.WaitForChild("StartGui") as ScreenGui;
  StartGui.Enabled = false;
  CoffeeGui.Enabled = true;
});

RunService.RenderStepped.Connect((deltaTime: number) => {
  if (coffeeEnabled) {
    coffeeLevel -= 15 * deltaTime;
    CoffeeBar.Size = new UDim2(coffeeLevel / maxCoffeeLevel, 0, 0, 15);
  }
  if (coffeeLevel <= 0 && !broDied) {
    broDied = true;
    coffeeEnabled = false;
    CoffeeGui.Enabled = false;
    (LocalPlayer.Character?.WaitForChild("Humanoid") as Humanoid).TakeDamage(
      1000
    );
    for (let i = 0; i < 10; i++) {
      coroutine.wrap(() => {
        let sound = (game
          .GetService("Workspace")
          .WaitForChild("Music")
          .WaitForChild("Explosion") as Sound).Clone()
        sound.Parent = game.GetService("Workspace").WaitForChild("Music")
        sound.Play()
        wait(3)
        sound.Destroy()
      })();
      const explosion = new Instance("Explosion");
      const humanoidRootPart = (LocalPlayer.Character as Model).WaitForChild(
        "HumanoidRootPart"
      ) as BasePart;
      explosion.Position = humanoidRootPart.Position.add(new Vector3(math.random(-10, 10), math.random(-10, 10), math.random(-10, 10)));
      explosion.Parent = game.GetService("Workspace");
      explosion.BlastRadius = 10;
      explosion.BlastPressure = 100000;
      explosion.DestroyJointRadiusPercent = 0;
      coroutine.wrap(() => {
        wait(3);
        explosion.Destroy();
      })();
      wait(0.2)
    }
  }
});

AddCoffee.OnClientEvent.Connect((amount: number) => {
  coffeeLevel += amount;
  if (coffeeLevel > maxCoffeeLevel) {
    coffeeLevel = maxCoffeeLevel;
  }
})