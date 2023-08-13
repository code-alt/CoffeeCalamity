const ReplicatedStorage: ReplicatedStorage =
  game.GetService("ReplicatedStorage");
const Events: Folder = ReplicatedStorage.WaitForChild("Events") as Folder;
const Players: Players = game.GetService("Players");
const RunService = game.GetService("RunService");
const getNewLevel: RemoteEvent = Events.WaitForChild(
  "getNewLevel"
) as RemoteEvent;
let completedLevels: number = -1;
let lastLevel: Model;
let lastLevelSize = 0;
let humanoid: Humanoid;
class Level {
  model: Instance;
  constructor(model: Instance = new Instance("Model")) {
    this.model = model.Clone();
  }
generate() {
    const levelSize = this.model.WaitForChild("LevelSize") as BasePart;
    const levelSizeZ = levelSize.Size.Z;
    const oldLevelSize = lastLevelSize;
    for (const child of this.model.GetDescendants()) {
        if (child.IsA("BasePart") || child.IsA("UnionOperation")) {
            child.Position = new Vector3(
                child.Position.X,
                child.Position.Y,
                child.Position.Z + oldLevelSize
            );
        }
        if (child.Name === "KillPart") {
            if (child.IsA("BasePart")) {
                const event = child.Touched.Connect((part: BasePart) => {
                    if (part.Parent === Players.LocalPlayer.Character && humanoid.Health > 0) {
                        const canRevive = Players.LocalPlayer.Character?.FindFirstChild("CanRevive") as BoolValue;
                        if (canRevive?.Value === true) {
                            const rootPart = Players.LocalPlayer.Character?.WaitForChild("HumanoidRootPart") as BasePart;
                            rootPart.CFrame = (this.model.FindFirstChild("Spawn") as BasePart).CFrame;
                        } else {
                            humanoid.Health = 0;
                        }
                    }
                });
            }
        }
    }
    if (this.model.FindFirstChild("EndFrame")) {
      const endFrame = this.model.FindFirstChild("EndFrame") as Model;
      const endPart = endFrame.FindFirstChild("EndPart") as BasePart;
      if (endPart) {
        let event = endPart.Touched.Connect((part: BasePart) => {
            print("DEBUG: Touched end part")
          if (part.Parent === Players.LocalPlayer.Character) {
            makeNewRandomLevel();
            const endPartCFrame = (endPart.WaitForChild("Part") as BasePart)
              .CFrame;
            const tweenInfo = new TweenInfo(
              1.5,
              Enum.EasingStyle.Bounce,
              Enum.EasingDirection.Out
            );
            const endPartTween = game
              .GetService("TweenService")
              .Create(endPart.WaitForChild("Part") as BasePart, tweenInfo, {
                CFrame: endPartCFrame.add(new Vector3(0, 20.75, 0)),
              });
            endPartTween.Play();
            endPart.CanCollide = false;
          }
          event.Disconnect();
        });
      }
    }
    this.model.Parent = game.Workspace.WaitForChild("Levels");
    lastLevel = this.model as Model;
    lastLevelSize += levelSizeZ;
    if (this.model.FindFirstChild("SpawnLocation")) {
        (this.model.FindFirstChild("SpawnLocation") as SpawnLocation).Parent = game.Workspace;
    }
  }
}

const makeNewRandomLevel = () => {
    let newLevel;
    if (completedLevels >= 8) {
        let ranModel = ReplicatedStorage.WaitForChild("Levels").WaitForChild("Hard").GetChildren()[math.random(1, ReplicatedStorage.WaitForChild("Levels").WaitForChild("Hard").GetChildren().size()) - 1] as Model;
        while (ranModel.Name === lastLevel.Name) {
            ranModel = ReplicatedStorage.WaitForChild("Levels").WaitForChild("Hard").GetChildren()[math.random(1, ReplicatedStorage.WaitForChild("Levels").WaitForChild("Hard").GetChildren().size()) - 1] as Model;
        }
        newLevel = new Level(
            ranModel
        );
    } else if (completedLevels >= 3) {
        let ranModel = ReplicatedStorage.WaitForChild("Levels").WaitForChild("Medium").GetChildren()[math.random(1, ReplicatedStorage.WaitForChild("Levels").WaitForChild("Medium").GetChildren().size()) - 1] as Model;
        while (ranModel.Name === lastLevel.Name) {
            ranModel = ReplicatedStorage.WaitForChild("Levels").WaitForChild("Medium").GetChildren()[math.random(1, ReplicatedStorage.WaitForChild("Levels").WaitForChild("Medium").GetChildren().size()) - 1] as Model;
        }
        newLevel = new Level(
            ReplicatedStorage.WaitForChild("Levels")
                .WaitForChild("Medium")
                .GetChildren()[math.random(1, ReplicatedStorage.WaitForChild("Levels").WaitForChild("Medium").GetChildren().size()) - 1] as Model
        );
    } else {
        let ranModel = ReplicatedStorage.WaitForChild("Levels").WaitForChild("Easy").GetChildren()[math.random(1, ReplicatedStorage.WaitForChild("Levels").WaitForChild("Easy").GetChildren().size()) - 1] as Model;
        let th = "nil"
        if (lastLevel) {
            th = lastLevel.Name || "nil"
        }
        if (ranModel.Name === th) {
            ranModel = ReplicatedStorage.WaitForChild("Levels").WaitForChild("Easy").GetChildren()[math.random(1, ReplicatedStorage.WaitForChild("Levels").WaitForChild("Easy").GetChildren().size()) - 1] as Model;
        }
        newLevel = new Level(
            ranModel
        );
    }
    newLevel.generate();
    completedLevels++;
    const playerGui = Players.LocalPlayer.WaitForChild("PlayerGui") as PlayerGui;
    (playerGui.WaitForChild("CoffeeGui").WaitForChild("Count") as TextLabel).Text = tostring(completedLevels);
    return newLevel;
};

getNewLevel.OnClientEvent.Connect(() => {
  makeNewRandomLevel();
});

const clearAll = () => {
  const levelsFolder = game.Workspace.WaitForChild("Levels") as Folder;
  for (const child of levelsFolder.GetChildren()) {
    child.Destroy();
  }
  lastLevelSize = -46;
  completedLevels = -1;
};
const player = Players.LocalPlayer as Player;

player.CharacterAdded.Connect((character) => {
    humanoid = character.WaitForChild("Humanoid") as Humanoid;

    humanoid.Died.Connect(() => {
        clearAll();
        if (game.GetService("Workspace").FindFirstChild("Start")) game.GetService("Workspace").WaitForChild("Start").Destroy();
        lastLevelSize = 0;
        new Level(ReplicatedStorage.WaitForChild("Levels").WaitForChild("Start")).generate();
        lastLevel = game.GetService("Workspace").FindFirstChild("Start") as Model;
        lastLevelSize = 0;
        completedLevels = -1;
    });

});