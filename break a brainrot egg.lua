local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/discoart/FluentPlus/refs/heads/main/Beta.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- [[ SETUP & CORE VARIABLES ]] --
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- [[ SETTINGS ]] --
local Options = {
    AutoBreak = false, -- Internal logic for farm eggs
    AutoTPEgg = false,
    AutoHitBigEgg = false,
    AutoHitZone2 = false,
    AutoCollect = false,
    AutoPickUp = false,
    AutoPickDivine = false,
    AutoUpgradeAll = false,
    AutoUpgradeSpecific = false,
    AutoRebirth = false,
    InstantPrompt = false,
    TargetPlatform = 1,
    FarmEggs = {
        Common = false, Rare = false, Epic = false, Legendary = false, Mythic = false,
        Secret = false, Godly = false, OG = false, Inferno = false, Divine = false,
        Emerald = false, Sapphire = false, Amethyst = false, Skibidi = false,
        Obsidian = false
    }
}

local EggOrder = {
    "Common", "Rare", "Epic", "Legendary", "Mythic", "Secret", "Godly", 
    "OG", "Inferno", "Divine", "Emerald", "Sapphire", "Amethyst", "Skibidi", "Obsidian"
}

local PickUpBlacklist = {
    "buy hammers", "buy gear", "new event!", "sign up",
    "spawn godly egg", "spawn skibidi egg", "spawn og egg", "teleport",
    "sell", "place", "upgrade", "trade"
}

local dropZoneCFrame = CFrame.new(127.0415802, 3.0075314, -59.6825866)

-- [[ WINDOW ]] --
local Window = Fluent:CreateWindow({
    Title = "Catmio",
    SubTitle = "Break a Brainrot Egg!",
    TabWidth = 120,
    Size = UDim2.fromOffset(450, 350),
    Acrylic = false,
    Theme = "AMOLED",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Egg = Window:AddTab({ Title = "Egg", Icon = "egg" }),
    Collect = Window:AddTab({ Title = "Collect", Icon = "coins" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- [[ UI PLACEMENT ]] --

-- Main Tab
local AutoTPToggle = Tabs.Main:AddToggle("AutoTP", {Title = "Tp To selected Eggs from Egg Tab", Default = false})
AutoTPToggle:OnChanged(function() Options.AutoTPEgg = AutoTPToggle.Value end)

local AutoHitVaultToggle = Tabs.Main:AddToggle("AutoHitVault", {Title = "Auto Hit Vault Eggs", Default = false})
AutoHitVaultToggle:OnChanged(function() Options.AutoHitBigEgg = AutoHitVaultToggle.Value end)

local AutoHitZone2Toggle = Tabs.Main:AddToggle("AutoHitZone2", {Title = "Fast Auto Hit Egg", Default = false})
AutoHitZone2Toggle:OnChanged(function() Options.AutoHitZone2 = AutoHitZone2Toggle.Value end)

local AutoPickUpToggle = Tabs.Main:AddToggle("AutoPickUp", {Title = "Auto Pick Up", Default = false})
AutoPickUpToggle:OnChanged(function() Options.AutoPickUp = AutoPickUpToggle.Value end)

local AutoPickDivineToggle = Tabs.Main:AddToggle("AutoPickDivine", {Title = "Auto Pick Up (Divine)", Default = false})
AutoPickDivineToggle:OnChanged(function() Options.AutoPickDivine = AutoPickDivineToggle.Value end)

local InstantPromptToggle = Tabs.Main:AddToggle("InstantPrompt", {Title = "Instant pick up (No Delay)", Default = false})
InstantPromptToggle:OnChanged(function() Options.InstantPrompt = InstantPromptToggle.Value end)

-- Helper: Get Safe Zone
local function GetSafeZoneCFrame()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            for _, ui in pairs(v:GetChildren()) do
                if ui:IsA("SurfaceGui") or ui:IsA("BillboardGui") then
                    for _, txt in pairs(ui:GetDescendants()) do
                        if txt:IsA("TextLabel") and txt.Text:lower():find("safe zone") then
                            return v.CFrame * CFrame.new(0, 5, 0)
                        end
                    end
                end
            end
            if v.Name:lower():find("safe") and v.Name:lower():find("zone") then
                return v.CFrame * CFrame.new(0, 5, 0)
            end
        end
    end
    return nil
end

Tabs.Main:AddButton({
    Title = "Tp To Safe Zone",
    Callback = function()
        pcall(function()
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local sz = GetSafeZoneCFrame()
                if sz then hrp.CFrame = sz end
            end
        end)
    end
})

Tabs.Main:AddButton({
    Title = "Unlock Zones",
    Callback = function()
        pcall(function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    local isWall = false
                    local vName = v.Name:lower()
                    if not vName:find("safe") and not vName:find("vault") then
                        if vName:find("door") or vName:find("wall") or vName:find("zone") or vName:find("glass") then isWall = true end
                        for _, ui in pairs(v:GetChildren()) do
                            if ui:IsA("SurfaceGui") or ui:IsA("BillboardGui") then
                                for _, txt in pairs(ui:GetDescendants()) do
                                    if txt:IsA("TextLabel") then
                                        local t = txt.Text:lower()
                                        if not t:find("safe") and not t:find("vault") and (t:find("unlock") or t:find("zone") or t:find("open") or t:find("v.i.p")) then isWall = true end
                                    end
                                end
                            end
                        end
                    end
                    if isWall then v:Destroy() end
                end
            end
        end)
    end
})

-- Egg Tab
for _, eggName in ipairs(EggOrder) do
    local EggToggle = Tabs.Egg:AddToggle("Farm"..eggName, {Title = "Farm " .. eggName, Default = false})
    EggToggle:OnChanged(function() Options.FarmEggs[eggName] = EggToggle.Value end)
end

-- Collect Tab
local AutoCollectToggle = Tabs.Collect:AddToggle("AutoCollect", {Title = "Auto Collect Money (1-60)", Default = false})
AutoCollectToggle:OnChanged(function() Options.AutoCollect = AutoCollectToggle.Value end)

local AutoUpgradeAllToggle = Tabs.Collect:AddToggle("AutoUpgradeAll", {Title = "Auto Upgrade All(1-30)", Default = false})
AutoUpgradeAllToggle:OnChanged(function() Options.AutoUpgradeAll = AutoUpgradeAllToggle.Value end)

local AutoUpgradeSpecificToggle = Tabs.Collect:AddToggle("AutoUpgradeSpecific", {Title = "Upgrade Specific", Default = false})
AutoUpgradeSpecificToggle:OnChanged(function() Options.AutoUpgradeSpecific = AutoUpgradeSpecificToggle.Value end)

local PlatformInput = Tabs.Collect:AddInput("TargetPlatform", {
    Title = "Platform Number(1-30)",
    Default = "1",
    Placeholder = "Enter number...",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            Options.TargetPlatform = math.clamp(num, 1, 30)
        end
    end
})

local AutoRebirthToggle = Tabs.Collect:AddToggle("AutoRebirth", {Title = "Auto Rebirth", Default = false})
AutoRebirthToggle:OnChanged(function() Options.AutoRebirth = AutoRebirthToggle.Value end)

-- [[ LOGIC ]] --

-- Instant Prompt
task.spawn(function()
    while task.wait(0.5) do
        if Options.InstantPrompt then
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ProximityPrompt") then
                        v.HoldDuration = 0
                    end
                end
            end)
        end
    end
end)

-- Auto Hit Specific Eggs & Auto TP
task.spawn(function()
    local KnitRemote = nil
    while task.wait(0.2) do
        local anySpecific = false
        local activeTargetEggs = {}
        for eggName, isActive in pairs(Options.FarmEggs) do 
            if isActive then 
                table.insert(activeTargetEggs, string.lower(eggName))
                anySpecific = true
            end 
        end
        
        if anySpecific and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                if not KnitRemote then KnitRemote = ReplicatedStorage.Packages.Knit.Services.EggSpawnerService.RF.RequestHitEgg end
                if not KnitRemote then return end
                
                local uuidsToHit = {}
                local hrp = player.Character.HumanoidRootPart
                local targetFound = false
                
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Model") and v.Name:find("-") and #v.Name == 36 then
                        local isTarget = false
                        for _, desc in pairs(v:GetDescendants()) do
                            if desc:IsA("TextLabel") or desc:IsA("StringValue") then
                                local txt = desc:IsA("TextLabel") and string.lower(desc.Text) or string.lower(desc.Value)
                                for _, rarity in ipairs(activeTargetEggs) do
                                    if string.find(txt, rarity) then isTarget = true; break end
                                end
                            end
                            if isTarget then break end
                        end
                        
                        if isTarget then
                            local part = v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")
                            if part then
                                if Options.AutoTPEgg and not targetFound then
                                    hrp.CFrame = part.CFrame * CFrame.new(0, 3, 0)
                                    targetFound = true
                                end
                                if (part.Position - hrp.Position).Magnitude <= 100 then
                                    table.insert(uuidsToHit, v.Name)
                                end
                            end
                        end
                    end
                end
                
                if #uuidsToHit > 0 then
                    pcall(function() KnitRemote:InvokeServer(uuidsToHit) end)
                end
            end)
        end
    end
end)

-- Auto Hit Vault
task.spawn(function()
    local VaultRemote = nil
    RunService.Heartbeat:Connect(function()
        if Options.AutoHitBigEgg then
            pcall(function()
                if not VaultRemote then VaultRemote = ReplicatedStorage.Packages.Knit.Services.EggVaultService.RF.RequestHitVaultEgg end
                if VaultRemote then task.spawn(function() VaultRemote:InvokeServer() end) end
            end)
        end
    end)
end)

-- Auto Hit Zone 2
task.spawn(function()
    local KnitRemote = nil
    local cachedUUIDs = {}
    
    task.spawn(function()
        while task.wait(0.2) do
            if Options.AutoHitZone2 and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                pcall(function()
                    local temp = {}
                    local hrp = player.Character.HumanoidRootPart
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("Model") and v.Name:find("-") and #v.Name == 36 then
                            local part = v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")
                            if part and (part.Position - hrp.Position).Magnitude <= 100 then
                                table.insert(temp, v.Name)
                            end
                        end
                    end
                    cachedUUIDs = temp
                end)
            end
        end
    end)

    RunService.Heartbeat:Connect(function()
        if Options.AutoHitZone2 then
            pcall(function()
                if not KnitRemote then KnitRemote = ReplicatedStorage.Packages.Knit.Services.EggSpawnerService.RF.RequestHitEgg end
                if KnitRemote and #cachedUUIDs > 0 then
                    task.spawn(function() KnitRemote:InvokeServer(cachedUUIDs) end)
                end
            end)
        end
    end)
end)

-- Auto Collect
task.spawn(function()
    local CollectRemote = nil
    while task.wait(0.5) do
        if Options.AutoCollect then
            pcall(function()
                if not CollectRemote then CollectRemote = ReplicatedStorage.Packages.Knit.Services.BaseService.RF.RequestPlatformCollect end
                if CollectRemote then
                    for i = 1, 60 do
                        task.spawn(function() pcall(function() CollectRemote:InvokeServer(i) end) end)
                    end
                end
            end)
        end
    end
end)

-- Auto Upgrade
task.spawn(function()
    local UpgradeRemote = nil
    while task.wait(0.2) do
        if Options.AutoUpgradeAll or Options.AutoUpgradeSpecific then
            pcall(function()
                if not UpgradeRemote then UpgradeRemote = ReplicatedStorage.Packages.Knit.Services.BaseService.RF.RequestPlatformUpgrade end
                if UpgradeRemote then
                    if Options.AutoUpgradeAll then
                        for i = 1, 30 do
                            task.spawn(function() pcall(function() UpgradeRemote:InvokeServer(i) end) end)
                        end
                    elseif Options.AutoUpgradeSpecific then
                        task.spawn(function() pcall(function() UpgradeRemote:InvokeServer(Options.TargetPlatform) end) end)
                    end
                end
            end)
        end
    end
end)

-- Auto Rebirth
task.spawn(function()
    local RebirthRemote = nil
    while task.wait(1.5) do
        if Options.AutoRebirth then
            pcall(function()
                if not RebirthRemote then RebirthRemote = ReplicatedStorage.Packages.Knit.Services.RebirthService.RF.RequestRebirth end
                if RebirthRemote then RebirthRemote:InvokeServer() end
            end)
        end
    end
end)

-- Auto Pick Up Logic
local function isCarrying()
    if PlayerGui then
        for _, gui in pairs(PlayerGui:GetDescendants()) do
            if (gui:IsA("TextButton") or gui:IsA("ImageButton")) and gui.Visible then
                local btnText = gui:IsA("TextButton") and gui.Text:lower() or ""
                local btnName = gui.Name:lower()
                if btnText:find("drop") or btnName:find("drop") then
                    return true
                end
            end
        end
    end
    return false
end

task.spawn(function()
    while task.wait(0.2) do
        if Options.AutoPickUp and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                if isCarrying() then return end
                local hrp = player.Character.HumanoidRootPart
                local hasGrabbed = false 
                
                for _, v in pairs(workspace:GetDescendants()) do
                    if hasGrabbed then break end 
                    if v:IsA("ProximityPrompt") then
                        local text = (v.ActionText .. " " .. v.ObjectText .. " " .. v.Name):lower()
                        local isBlacklisted = false
                        for _, word in ipairs(PickUpBlacklist) do
                            if text:find(word) then isBlacklisted = true; break end
                        end
                        if not isBlacklisted and text:find("pick up") and not text:find("pickup") then
                            local part = v:FindFirstAncestorWhichIsA("BasePart")
                            if part and (part.Position - hrp.Position).Magnitude <= 15 then
                                fireproximityprompt(v)
                                hasGrabbed = true 
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Pick Divine Logic
task.spawn(function()
    while task.wait(0.3) do
        if Options.AutoPickDivine and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                local hrp = player.Character.HumanoidRootPart
                if isCarrying() then 
                    hrp.CFrame = dropZoneCFrame
                    Options.AutoPickDivine = false 
                    AutoPickDivineToggle:SetValue(false)
                    return 
                end

                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ProximityPrompt") then
                        local text = (v.ActionText .. " " .. v.ObjectText .. " " .. v.Name):lower()
                        local isBlacklisted = false
                        for _, word in ipairs(PickUpBlacklist) do
                            if text:find(word) then isBlacklisted = true; break end
                        end
                        
                        if not isBlacklisted and text:find("pick up") and not text:find("pickup") then
                            local isDivine = false
                            local p = v.Parent
                            for i=1, 4 do
                                if p and p ~= workspace then
                                    for _, desc in pairs(p:GetDescendants()) do
                                        if desc:IsA("TextLabel") and desc.Text:upper():find("DIVINE") then
                                            isDivine = true; break
                                        end
                                    end
                                    p = p.Parent
                                end
                                if isDivine then break end
                            end
                            
                            if isDivine then
                                local part = v:FindFirstAncestorWhichIsA("BasePart") or v.Parent
                                if part and part:IsA("BasePart") and (part.Position - hrp.Position).Magnitude <= 15 then
                                    fireproximityprompt(v)
                                    task.wait(0.4)
                                    if isCarrying() then
                                        hrp.CFrame = dropZoneCFrame
                                        Options.AutoPickDivine = false 
                                        AutoPickDivineToggle:SetValue(false)
                                    end
                                    return 
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- [[ SETTINGS ]] --
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
InterfaceManager:SetFolder("Catmio")
SaveManager:SetFolder("Catmio/Configs")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
Fluent:Notify({
    Title = "Catmio",
    Content = "Script loaded successfully!",
    Duration = 5
})
SaveManager:LoadAutoloadConfig()
-- #############################################
-- ## BOTÓN EXTERNO (ARRIBA DERECHA + DRAG)   ##
-- #############################################

local function createExternalToggleButton()

    -- evitar duplicados
    if PlayerGui:FindFirstChild("CatmioToggleUI") then
        PlayerGui.CatmioToggleUI:Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CatmioToggleUI"
    screenGui.Parent = PlayerGui
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local button = Instance.new("ImageButton")
    button.Name = "ToggleButton"
    button.Parent = screenGui
    button.Size = UDim2.fromOffset(50, 50)

    local cam = workspace.CurrentCamera
    local GuiService = game:GetService("GuiService")

    -- 🔥 POSICIÓN ARRIBA DERECHA REAL (SAFE AREA)
    local inset = GuiService:GetGuiInset()
    local padding = 10

    button.Position = UDim2.fromOffset(
        cam.ViewportSize.X - button.Size.X.Offset - padding,
        inset.Y + padding
    )

    button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    button.BorderSizePixel = 0
    button.Image = "rbxassetid://10709791437"
    button.ImageColor3 = Color3.fromRGB(255, 255, 255)
    button.ScaleType = Enum.ScaleType.Fit
    button.BackgroundTransparency = 0.2

    Instance.new("UICorner", button).CornerRadius = UDim.new(1, 0)

    local stroke = Instance.new("UIStroke", button)
    stroke.Color = Color3.fromRGB(255,255,255)
    stroke.Thickness = 1.5

    -- #############################################
    -- TOOLTIP
    -- #############################################

    local tooltip = Instance.new("TextLabel")
    tooltip.Parent = button
    tooltip.Size = UDim2.fromOffset(120, 20)
    tooltip.Position = UDim2.new(0.5, -60, -0.5, -25)
    tooltip.BackgroundTransparency = 0.4
    tooltip.BackgroundColor3 = Color3.fromRGB(0,0,0)
    tooltip.TextColor3 = Color3.fromRGB(255,255,255)
    tooltip.Text = "Hide / Show UI"
    tooltip.Font = Enum.Font.GothamSemibold
    tooltip.TextSize = 12
    tooltip.Visible = false
    Instance.new("UICorner", tooltip).CornerRadius = UDim.new(0,6)

    button.MouseEnter:Connect(function()
        tooltip.Visible = true
    end)

    button.MouseLeave:Connect(function()
        tooltip.Visible = false
    end)

    -- #############################################
    -- TOGGLE UI
    -- #############################################

    local uiVisible = true

    button.MouseButton1Click:Connect(function()
        uiVisible = not uiVisible

        pcall(function()
            if uiVisible then
                if Window.Maximize then
                    Window:Maximize()
                end
            else
                if Window.Minimize then
                    Window:Minimize()
                end
            end
        end)

        pcall(function()
            if Window.Root then
                Window.Root.Visible = uiVisible
            end
        end)

        button.ImageColor3 = uiVisible and Color3.fromRGB(255,255,255) or Color3.fromRGB(180,180,180)
    end)

    -- #############################################
    -- DRAG PERFECTO (PC + MOBILE)
    -- #############################################

    local dragging = false
    local dragStart
    local startPos

    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 
        or input.UserInputType == Enum.UserInputType.Touch then
            
            dragging = true
            dragStart = input.Position
            startPos = button.AbsolutePosition

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end

        if input.UserInputType == Enum.UserInputType.MouseMovement 
        or input.UserInputType == Enum.UserInputType.Touch then
            
            local delta = input.Position - dragStart
            local cam = workspace.CurrentCamera

            local newX = math.clamp(
                startPos.X + delta.X,
                0,
                cam.ViewportSize.X - button.AbsoluteSize.X
            )

            local newY = math.clamp(
                startPos.Y + delta.Y,
                inset.Y,
                cam.ViewportSize.Y - button.AbsoluteSize.Y
            )

            button.Position = UDim2.fromOffset(newX, newY)
        end
    end)
end

createExternalToggleButton()
