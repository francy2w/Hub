local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/discoart/FluentPlus/refs/heads/main/Beta.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local EggsFolder = workspace:WaitForChild("EggRenderModels")

-- REMOTES
local HitEvent = ReplicatedStorage.Packages.Knit.Services.EggSpawnerService.RF.RequestHitEgg
local CollectEvent = ReplicatedStorage.Packages.Knit.Services.BaseService.RF.RequestPlatformCollect
local UpgradeEvent = ReplicatedStorage.Packages.Knit.Services.BaseService.RF.RequestPlatformUpgrade

-- WINDOW
local Window = Fluent:CreateWindow({
    Title = "Break a brainrot egg | Catmio",
    SubTitle = "Made by Francy",
    TabWidth = 120,
    Size = UDim2.fromOffset(420,320),
    Acrylic = false,
    Theme = "AMOLED",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- MINIMIZER
Fluent:CreateMinimizer({
    Icon = "home",
    Size = UDim2.fromOffset(100,40),
    Position = UDim2.new(0,20,0,20)
})

-- TABS
local Tabs = {
    Main = Window:AddTab({
        Title = "Main",
        Icon = "home"
    }),

    Settings = Window:AddTab({
        Title = "Settings",
        Icon = "settings"
    })
}

-- EGG FUNCTIONS
local function getEggPosition(egg)
    local render = egg:FindFirstChild("RenderModel")
    if not render then return nil end

    if render:IsA("Model") then
        local part = render.PrimaryPart or render:FindFirstChildWhichIsA("BasePart", true)
        if part then
            return part.Position
        end
    elseif render:IsA("BasePart") then
        return render.Position
    end
end

local function getClosestEgg()
    local char = player.Character
    if not char then return nil end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local closest = nil
    local shortest = math.huge

    for _, egg in pairs(EggsFolder:GetChildren()) do
        local pos = getEggPosition(egg)

        if pos then
            local dist = (root.Position - pos).Magnitude

            if dist < shortest then
                shortest = dist
                closest = egg
            end
        end
    end

    return closest
end

-- AUTO HIT
local AutoHit = false

local HitToggle = Tabs.Main:AddToggle("AutoHit", {
    Title = "Auto Hit Eggs",
    Default = false
})

HitToggle:OnChanged(function()
    AutoHit = HitToggle.Value

    if AutoHit then
        task.spawn(function()
            while AutoHit do
                local egg = getClosestEgg()

                if egg then
                    pcall(function()
                        HitEvent:InvokeServer({
                            egg.Name,
                            "RenderModel"
                        })
                    end)
                end

                task.wait(0.1)
            end
        end)
    end
end)

-- AUTO COLLECT
local AutoCollect = false

local CollectToggle = Tabs.Main:AddToggle("AutoCollect", {
    Title = "Auto Collect Money",
    Default = false
})

CollectToggle:OnChanged(function()
    AutoCollect = CollectToggle.Value

    if AutoCollect then
        task.spawn(function()
            while AutoCollect do
                for i = 1,16 do
                    pcall(function()
                        CollectEvent:InvokeServer(i)
                    end)

                    task.wait(0.05)
                end

                task.wait(1)
            end
        end)
    end
end)

-- AUTO UPGRADE
local AutoUpgrade = false

local UpgradeToggle = Tabs.Main:AddToggle("AutoUpgrade", {
    Title = "Auto Upgrade Plot",
    Default = false
})

UpgradeToggle:OnChanged(function()
    AutoUpgrade = UpgradeToggle.Value

    if AutoUpgrade then
        task.spawn(function()
            while AutoUpgrade do
                for i = 1,16 do
                    pcall(function()
                        UpgradeEvent:InvokeServer(i)
                    end)

                    task.wait(0.05)
                end

                task.wait(1)
            end
        end)
    end
end)

-- TELEPORT SAFE ZONE
Tabs.Main:AddButton({
    Title = "Teleport Safe Zone",
    Callback = function()
        local char = player.Character

        if char and char:FindFirstChild("HumanoidRootPart") then
            local safe = workspace.World.Map.FloorDisplay
            char.HumanoidRootPart.CFrame = safe.CFrame + Vector3.new(0,5,0)
        end
    end
})

-- UNLOCK LUCKY ZONE
Tabs.Main:AddButton({
    Title = "Unlock Lucky Zone",
    Callback = function()
        local wall = workspace.World:FindFirstChild("PurchaseWall_Zone2")

        if wall then
            wall:Destroy()
        end
    end
})

-- SETTINGS
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()

InterfaceManager:SetFolder("Catmio")
SaveManager:SetFolder("Catmio/GameConfig")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Loaded",
    Content = "Auto Farm Loaded Successfully!",
    Duration = 5
})

SaveManager:LoadAutoloadConfig()
