local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Catmio | Control Europe",
    SubTitle = "Made by Francy",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "AMOLED",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Army = Window:AddTab({ Title = "Army", Icon = "shield" }),
    Cities = Window:AddTab({ Title = "Cities", Icon = "building" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "settings" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- Variables globales
local MyCountry = nil
local AutoCaptureEnabled = false

-- Funciones de utilidad
local function GetMyCountry()
    local ls = game.Players.LocalPlayer:WaitForChild("leaderstats", 5)
    if ls then
        local cv = ls:FindFirstChild("Country")
        if cv then
            MyCountry = cv.Value
            if MyCountry:find("Russian") then MyCountry = "Russia" end
            Fluent:Notify({
                Title = "Country Detected",
                Content = "Current country: " .. MyCountry,
                Duration = 5
            })
        end
    end
end

local function TryFireAll(possibleNames, args)
    for _, name in ipairs(possibleNames) do
        for i = 1, 6 do
            local remote = game.ReplicatedStorage:FindFirstChild("RemoteEvent_" .. i)
            if remote then
                pcall(function()
                    remote:FireServer(name, unpack(args))
                end)
            end
        end
    end
end

-- Army Tab
Tabs.Army:AddButton({
    Title = "Refresh Country",
    Description = "Detect your current country",
    Callback = GetMyCountry
})

Tabs.Army:AddButton({
    Title = "Spawn 5k Soldiers on All Regions",
    Description = "Spawns 5000 soldiers in every region you own",
    Callback = function()
        if not MyCountry then GetMyCountry() end
        if not MyCountry then 
            Fluent:Notify({Title = "Error", Content = "Country not detected!", Duration = 3})
            return 
        end
        local count = 0
        local names = {"CreateArmyOnTile", "PlaceTroops", "Recruit", "SpawnSoldiers", "AddArmy"}
        for _, region in ipairs(workspace.Regions:GetChildren()) do
            local c = region:FindFirstChild("Country")
            if c and c.Value == MyCountry then
                TryFireAll(names, {region, "Soldier", 5000})
                count = count + 1
                task.wait(0.35)
            end
        end
        Fluent:Notify({Title = "Spawned", Content = "Sent to " .. count .. " regions", Duration = 6})
    end
})

Tabs.Army:AddButton({
    Title = "Add 25k to All Troops",
    Description = "Adds 25,000 units to all your existing troop stacks",
    Callback = function()
        if not MyCountry then GetMyCountry() end
        if not MyCountry then 
            Fluent:Notify({Title = "Error", Content = "Country not detected!", Duration = 3})
            return 
        end
        local count = 0
        local names = {"CreateArmyOnTile", "AddToArmy", "AddUnits", "Reinforce", "SpawnSoldiers"}
        for _, soldier in ipairs(workspace.SoldiersFolder:GetChildren()) do
            local owner = soldier:FindFirstChild("Country")
            if owner and owner.Value == MyCountry then
                local current = soldier:FindFirstChild("TotalAmount")
                local amt = (current and current.Value) or 1000
                TryFireAll(names, {soldier, "Soldier", amt + 25000})
                count = count + 1
                task.wait(0.2)
            end
        end
        Fluent:Notify({Title = "Success", Content = "Added 25k to " .. count .. " troop stacks", Duration = 5})
    end
})

local AutoCaptureToggle = Tabs.Army:AddToggle("AutoCapture", {Title = "AUTO Capture + Attack", Default = false })

AutoCaptureToggle:OnChanged(function()
    AutoCaptureEnabled = Options.AutoCapture.Value
    if not AutoCaptureEnabled and MyCountry then
        local names = {"ToggleAutoCapture", "SetAutoCapture", "AutoCapture", "ToggleAuto"}
        for _, unit in ipairs(workspace.SoldiersFolder:GetChildren()) do
            local c = unit:FindFirstChild("Country")
            if c and c.Value == MyCountry then
                TryFireAll(names, {unit, false})
            end
        end
        Fluent:Notify({Title = "Auto Capture", Content = "Disabled on all troops", Duration = 4})
    end
end)

-- Cities Tab
Tabs.Cities:AddButton({
    Title = "Upgrade ALL Cities Tier",
    Description = "Increases the tier of all your cities",
    Callback = function()
        if not MyCountry then GetMyCountry() end
        if not MyCountry then return end
        local count = 0
        local names = {"DevelopTile", "Upgrade", "UpgradeCity", "LevelUp", "Develop"}
        for _, r in ipairs(workspace.Regions:GetChildren()) do
            local c = r:FindFirstChild("Country")
            if c and c.Value == MyCountry then
                TryFireAll(names, {r, "Tier"})
                count = count + 1
                task.wait(0.3)
            end
        end
        Fluent:Notify({Title = "Tier Upgrade", Content = count .. " cities upgraded", Duration = 5})
    end
})

Tabs.Cities:AddButton({
    Title = "Upgrade ALL Cities Defense",
    Description = "Increases the defense level of all your cities",
    Callback = function()
        if not MyCountry then GetMyCountry() end
        if not MyCountry then return end
        local count = 0
        local names = {"DevelopTile", "Upgrade", "UpgradeCity", "LevelUp", "Develop"}
        for _, r in ipairs(workspace.Regions:GetChildren()) do
            local c = r:FindFirstChild("Country")
            if c and c.Value == MyCountry then
                TryFireAll(names, {r, "Def"})
                count = count + 1
                task.wait(0.3)
            end
        end
        Fluent:Notify({Title = "Defense Upgrade", Content = count .. " cities upgraded", Duration = 5})
    end
})

-- Misc Tab
local SantaToggle = Tabs.Misc:AddToggle("SantaGifts", {Title = "Auto Collect Santa Gifts", Default = false })

SantaToggle:OnChanged(function()
    local state = Options.SantaGifts.Value
    if state then
        getgenv().SantaLoop = task.spawn(function()
            while true do
                for i = 1, 5 do
                    local r = game.ReplicatedStorage:FindFirstChild("RemoteEvent_" .. i)
                    if r then
                        pcall(function() r:FireServer("PickedUpSantaGift") end)
                    end
                end
                task.wait(0.15)
            end
        end)
    else
        if getgenv().SantaLoop then task.cancel(getgenv().SantaLoop) end
    end
end)

-- Bucles en segundo plano
task.spawn(function()
    task.wait(2)
    GetMyCountry()
    while true do
        if AutoCaptureEnabled and MyCountry then
            local names = {"ToggleAutoCapture", "SetAutoCapture", "AutoCapture", "ToggleAuto"}
            for _, unit in ipairs(workspace.SoldiersFolder:GetChildren()) do
                local c = unit:FindFirstChild("Country")
                if c and c.Value == MyCountry then
                    TryFireAll(names, {unit, true})
                    TryFireAll(names, {unit, true, "Attack"})
                end
            end
        end
        task.wait(0.6)
    end
end)

-- ConfiguraciÃ³n de Fluent
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("Catmio")
SaveManager:SetFolder("Catmio/main")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Catmio | Control Europe",
    Content = "Script loaded",
    Duration = 8
})

SaveManager:LoadAutoloadConfig()
