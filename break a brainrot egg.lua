local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/discoart/FluentPlus/refs/heads/main/Beta.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Catmio",
    SubTitle = "Break a Brainrot Egg!",
    Search = true,
    Icon = "home",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl,
    UserInfo = true,
    UserInfoTop = false,
    UserInfoTitle = game:GetService("Players").LocalPlayer.DisplayName,
    UserInfoSubtitle = "User",
    UserInfoSubtitleColor = Color3.fromRGB(71, 123, 255)
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Egg = Window:AddTab({ Title = "EGG", Icon = "egg" }),
    Collect = Window:AddTab({ Title = "Collect", Icon = "box" }),
    Update = Window:AddTab({ Title = "Update", Icon = "refresh-cw" }),
    Details = Window:AddTab({ Title = "Details", Icon = "info" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- [[ 1. SETUP & CORE VARIABLES (LITERAL FROM FARTEX) ]] --
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

_G.AutoBreak = false
_G.AutoTPEgg = false 
_G.AutoHitBigEgg = false 
_G.AutoHitZone2 = false 
_G.AutoCollect = false
_G.AutoPickUp = false 
_G.AutoPickDivine = false 
_G.AutoTpSafeZone = false 
_G.AutoUpgradeAll = false
_G.AutoUpgradeSpecific = false
_G.AutoRebirth = false 
_G.InstantPrompt = false 
_G.TargetPlatform = 1 

_G.FarmEggs = {
    Common = false, Rare = false, Epic = false, Legendary = false, Mythic = false,
    Secret = false, Godly = false, OG = false, Inferno = false, Divine = false,
    Emerald = false, Sapphire = false, Amethyst = false, Skibidi = false,
    Obsidian = false
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

-- [[ 2. DRAGGABLE TOGGLE BUTTON (LITERAL FROM FARTEX STYLE) ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CatmioToggleGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 9999
-- Use gethui() if available for safety, else PlayerGui
local SafeParent = (pcall(function() return gethui() end) and gethui()) or PlayerGui
ScreenGui.Parent = SafeParent

local toggleBtn = Instance.new("ImageButton", ScreenGui)
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 15, 0, 150)
toggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
toggleBtn.Image = "rbxthumb://type=Asset&id=10670510726&w=150&h=150"
toggleBtn.Active = true
toggleBtn.Draggable = true -- Legacy draggable property

Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0.5, 0)
local btnStroke = Instance.new("UIStroke", toggleBtn)
btnStroke.Color = Color3.fromRGB(4, 203, 41)
btnStroke.Thickness = 2.5

-- Modern Draggable Logic (More stable than .Draggable)
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    toggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = toggleBtn.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

toggleBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

toggleBtn.MouseButton1Click:Connect(function()
    -- Fluent's Window visibility toggle
    -- Note: Fluent usually handles its own visibility, but we can force it or use the MinimizeKey
    -- For a literal "Hide/Show", we toggle the Window's visibility if possible or use the library's internal state
    if Window.Root then
        Window.Root.Visible = not Window.Root.Visible
    end
end)

-- [[ 3. UI SECTIONS (FLUENT STRUCTURE) ]] --

do
    local MainSection = Tabs.Main:AddSection("Main Automation")

    MainSection:AddToggle("AutoBreak", {Title = "Auto Break Eggs", Default = _G.AutoBreak}):OnChanged(function(Value) _G.AutoBreak = Value end)
    MainSection:AddToggle("AutoTPEgg", {Title = "Auto TP to Egg", Default = _G.AutoTPEgg}):OnChanged(function(Value) _G.AutoTPEgg = Value end)
    MainSection:AddToggle("AutoHitBigEgg", {Title = "Auto Hit Big Egg (Vault)", Default = _G.AutoHitBigEgg}):OnChanged(function(Value) _G.AutoHitBigEgg = Value end)
    MainSection:AddToggle("AutoHitZone2", {Title = "Auto Hit Zone 2", Default = _G.AutoHitZone2}):OnChanged(function(Value) _G.AutoHitZone2 = Value end)
    MainSection:AddToggle("AutoCollect", {Title = "Auto Collect", Default = _G.AutoCollect}):OnChanged(function(Value) _G.AutoCollect = Value end)
    MainSection:AddToggle("AutoPickUp", {Title = "Auto Pick Up", Default = _G.AutoPickUp}):OnChanged(function(Value) _G.AutoPickUp = Value end)
    MainSection:AddToggle("AutoPickDivine", {Title = "Auto Pick Up Divine", Default = _G.AutoPickDivine}):OnChanged(function(Value) _G.AutoPickDivine = Value end)
    MainSection:AddToggle("AutoTpSafeZone", {Title = "Auto TP to Safe Zone", Default = _G.AutoTpSafeZone}):OnChanged(function(Value) _G.AutoTpSafeZone = Value end)
    MainSection:AddToggle("AutoUpgradeAll", {Title = "Auto Upgrade All", Default = _G.AutoUpgradeAll}):OnChanged(function(Value) _G.AutoUpgradeAll = Value end)
    MainSection:AddToggle("AutoUpgradeSpecific", {Title = "Auto Upgrade Specific", Default = _G.AutoUpgradeSpecific}):OnChanged(function(Value) _G.AutoUpgradeSpecific = Value end)
    
    MainSection:AddSlider("TargetPlatform", {
        Title = "Target Platform",
        Description = "Platform for specific upgrade",
        Default = _G.TargetPlatform,
        Min = 1,
        Max = 30,
        Rounding = 1,
        Callback = function(Value) _G.TargetPlatform = Value end
    })

    MainSection:AddToggle("AutoRebirth", {Title = "Auto Rebirth", Default = _G.AutoRebirth}):OnChanged(function(Value) _G.AutoRebirth = Value end)
    MainSection:AddToggle("InstantPrompt", {Title = "Instant Proximity Prompt", Default = _G.InstantPrompt}):OnChanged(function(Value) _G.InstantPrompt = Value end)

    local EggSection = Tabs.Egg:AddSection("Egg Farming")
    for _, eggName in ipairs(EggOrder) do
        EggSection:AddToggle("FarmEgg" .. eggName, {Title = "Farm " .. eggName, Default = _G.FarmEggs[eggName]}):OnChanged(function(Value)
            _G.FarmEggs[eggName] = Value
        end)
    end

    Tabs.Collect:AddSection("Collect"):AddParagraph({Title = "Collect", Content = "Auto Collect and Pick Up are in the Main tab."})
    Tabs.Update:AddSection("Update"):AddParagraph({Title = "Update", Content = "No updates available."})
    Tabs.Details:AddSection("Details"):AddParagraph({Title = "Details", Content = "Did you knew in catmio we like cats?."})
end

-- [[ 4. LOGIC (LITERAL FROM FARTEX) ]] --

local function TripleTP(targetCFrame)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        for i = 1, 3 do
            hrp.CFrame = targetCFrame
            task.wait(0.01)
        end
    end
end

local function GetSafeZoneCFrame()
    return dropZoneCFrame
end

-- à¸¥à¸¹à¸› AUTO DROP
task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoTpSafeZone and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                local isCarrying = false
                if PlayerGui then
                    for _, gui in pairs(PlayerGui:GetDescendants()) do
                        if (gui:IsA("TextButton") or gui:IsA("ImageButton")) and gui.Visible then
                            local btnText = gui:IsA("TextButton") and gui.Text:lower() or ""
                            local btnName = gui.Name:lower()
                            if btnText:find("drop") or btnName:find("drop") then
                                isCarrying = true; break
                            end
                        end
                    end
                end
                
                if isCarrying then
                    local szCFrame = GetSafeZoneCFrame()
                    if szCFrame then
                        local hrp = player.Character.HumanoidRootPart
                        if (hrp.Position - szCFrame.Position).Magnitude > 20 then
                            TripleTP(szCFrame)
                        end
                    end
                end
            end)
        end
    end
end)

-- à¸¥à¸š Delay à¸à¸²à¸£à¸à¸” ProximityPrompt 
task.spawn(function()
    while task.wait(0.5) do
        if _G.InstantPrompt then
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

-- ðŸ¥š LOGIC: AUTO HIT EGG ALL & AUTO TP EGG
task.spawn(function()
    local KnitRemote = nil
    while task.wait(0.1) do
        local anySpecific = false
        local activeTargetEggs = {}
        for eggName, isActive in pairs(_G.FarmEggs) do 
            if isActive then 
                table.insert(activeTargetEggs, string.lower(eggName))
                anySpecific = true
            end 
        end
        
        if (_G.AutoBreak or anySpecific) and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                if not KnitRemote then KnitRemote = game:GetService("ReplicatedStorage").Packages.Knit.Services.EggSpawnerService.RF.RequestHitEgg end
                if not KnitRemote then return end
                
                local uuidsToHit = {}
                local hrp = player.Character.HumanoidRootPart
                local targetFound = false
                
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Model") and v.Name:find("-") and #v.Name == 36 then
                        local isTarget = false
                        
                        if _G.AutoBreak then
                            isTarget = true
                        end
                        
                        if not isTarget and anySpecific then
                            for _, desc in pairs(v:GetDescendants()) do
                                if desc:IsA("TextLabel") or desc:IsA("StringValue") then
                                    local txt = desc:IsA("TextLabel") and string.lower(desc.Text) or string.lower(desc.Value)
                                    for _, rarity in ipairs(activeTargetEggs) do
                                        if string.find(txt, rarity) then
                                            isTarget = true
                                            break
                                        end
                                    end
                                end
                                if isTarget then break end
                            end
                        end
                        
                        if isTarget then
                            local part = v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")
                            if part then
                                if _G.AutoTPEgg and not targetFound then
                                    TripleTP(part.CFrame * CFrame.new(0, 3, 0))
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
                    for _, uuid in ipairs(uuidsToHit) do
                        task.spawn(function() 
                            pcall(function() 
                                KnitRemote:InvokeServer({uuid}) 
                            end) 
                        end)
                    end
                end
            end)
        end
    end
end)

-- ðŸ’¥ LOGIC: AUTO HIT EGG VAULT (FASTEST MODE)
task.spawn(function()
    local VaultRemote = nil
    while task.wait() do
        if _G.AutoHitBigEgg then
            pcall(function()
                if not VaultRemote then 
                    VaultRemote = game:GetService("ReplicatedStorage").Packages.Knit.Services.EggVaultService.RF.RequestHitVaultEgg 
                end
                
                if VaultRemote then 
                    task.spawn(function() pcall(function() VaultRemote:InvokeServer() end) end)
                    task.spawn(function() pcall(function() VaultRemote:InvokeServer() end) end)
                end
            end)
        end
    end
end)

-- âš”ï¸ LOGIC: AUTO HIT ZONE 2 (FASTEST MODE)
task.spawn(function()
    local KnitRemote = nil
    local cachedUUIDs = {}
    
    task.spawn(function()
        while task.wait(0.1) do
            if _G.AutoHitZone2 and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                pcall(function()
                    local tempUUIDs = {}
                    local hrp = player.Character.HumanoidRootPart
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("Model") and v.Name:find("-") and #v.Name == 36 then
                            local part = v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")
                            if part and (part.Position - hrp.Position).Magnitude <= 150 then
                                table.insert(tempUUIDs, v.Name)
                            end
                        end
                    end
                    cachedUUIDs = tempUUIDs
                end)
            end
        end
    end)

    while task.wait() do
        if _G.AutoHitZone2 and #cachedUUIDs > 0 then
            pcall(function()
                if not KnitRemote then 
                    KnitRemote = game:GetService("ReplicatedStorage").Packages.Knit.Services.EggSpawnerService.RF.RequestHitEgg 
                end
                
                if KnitRemote then
                    for _, uuid in ipairs(cachedUUIDs) do
                        task.spawn(function() 
                            pcall(function() 
                                KnitRemote:InvokeServer({uuid}) 
                            end) 
                        end)
                    end
                end
            end)
        end
    end
end)

-- ðŸ’° LOGIC: AUTO COLLECT 
task.spawn(function()
    local CollectRemote = nil
    while task.wait(0.5) do
        if _G.AutoCollect then
            pcall(function()
                if not CollectRemote then CollectRemote = game:GetService("ReplicatedStorage").Packages.Knit.Services.BaseService.RF.RequestPlatformCollect end
                if CollectRemote then
                    for i = 1, 60 do
                        task.spawn(function() pcall(function() CollectRemote:InvokeServer(i) end) end)
                    end
                end
            end)
        end
    end
end)

-- â¬†ï¸ LOGIC: AUTO UPGRADE 
task.spawn(function()
    local UpgradeRemote = nil
    while task.wait(0.2) do
        if _G.AutoUpgradeAll or _G.AutoUpgradeSpecific then
            pcall(function()
                if not UpgradeRemote then UpgradeRemote = game:GetService("ReplicatedStorage").Packages.Knit.Services.BaseService.RF.RequestPlatformUpgrade end
                if UpgradeRemote then
                    if _G.AutoUpgradeAll then
                        for i = 1, 30 do
                            task.spawn(function() pcall(function() UpgradeRemote:InvokeServer(i) end) end)
                        end
                    elseif _G.AutoUpgradeSpecific then
                        task.spawn(function() pcall(function() UpgradeRemote:InvokeServer(_G.TargetPlatform) end) end)
                    end
                end
            end)
        end
    end
end)

-- â™»ï¸ LOGIC: AUTO REBIRTH
task.spawn(function()
    local RebirthRemote = nil
    while task.wait(1.5) do
        if _G.AutoRebirth then
            pcall(function()
                if not RebirthRemote then RebirthRemote = game:GetService("ReplicatedStorage").Packages.Knit.Services.RebirthService.RF.RequestRebirth end
                if RebirthRemote then RebirthRemote:InvokeServer() end
            end)
        end
    end
end)

-- ðŸ–ï¸ LOGIC: AUTO PICK UP
task.spawn(function()
    while task.wait(0.2) do
        if _G.AutoPickUp and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                local isCarrying = false
                if PlayerGui then
                    for _, gui in pairs(PlayerGui:GetDescendants()) do
                        if (gui:IsA("TextButton") or gui:IsA("ImageButton")) and gui.Visible then
                            local btnText = gui:IsA("TextButton") and gui.Text:lower() or ""
                            local btnName = gui.Name:lower()
                            if btnText:find("drop") or btnName:find("drop") then
                                isCarrying = true; break
                            end
                        end
                    end
                end
                
                if isCarrying then return end

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
                        if not isBlacklisted and (text:find("pick") or text:find("up")) then
                            local part = v:FindFirstAncestorWhichIsA("BasePart")
                            if part and (part.Position - hrp.Position).Magnitude <= 15 then
                                fireproximityprompt(v)
                                hasGrabbed = true 
                            end
                        end
                    end
                    
                    if v:IsA("BillboardGui") and not hasGrabbed then
                        local allText = ""
                        local hasPickUpText = false
                        for _, txt in pairs(v:GetDescendants()) do
                            if txt:IsA("TextLabel") then
                                local tLower = txt.Text:lower()
                                allText = allText .. " " .. tLower
                                if tLower:find("pick") or tLower:find("up") then
                                    hasPickUpText = true
                                end
                            end
                        end
                        local isBlacklisted = false
                        for _, word in ipairs(PickUpBlacklist) do
                            if allText:find(word) then isBlacklisted = true; break end
                        end
                        if hasPickUpText and not isBlacklisted then
                            local part = v.Adornee or v:FindFirstAncestorWhichIsA("BasePart")
                            if part and (part.Position - hrp.Position).Magnitude <= 15 then
                                for _, btn in pairs(v:GetDescendants()) do
                                    if (btn:IsA("TextButton") or btn:IsA("ImageButton")) then
                                        if getconnections then
                                            for _, conn in pairs(getconnections(btn.MouseButton1Click)) do
                                                conn:Fire()
                                                hasGrabbed = true 
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ðŸ’Ž LOGIC: AUTO PICK UP à¹€à¸‰à¸žà¸²à¸° DIVINE
task.spawn(function()
    while task.wait(0.3) do 
        if _G.AutoPickDivine and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                local isCarrying = false
                if PlayerGui then
                    for _, gui in pairs(PlayerGui:GetDescendants()) do
                        if (gui:IsA("TextButton") or gui:IsA("ImageButton")) and gui.Visible then
                            local btnText = gui:IsA("TextButton") and gui.Text:lower() or ""
                            local btnName = gui.Name:lower()
                            if btnText:find("drop") or btnName:find("drop") then
                                isCarrying = true; break
                            end
                        end
                    end
                end
                
                local hrp = player.Character.HumanoidRootPart

                if isCarrying then 
                    local szCFrame = GetSafeZoneCFrame()
                    if szCFrame and (hrp.Position - szCFrame.Position).Magnitude > 20 then
                        TripleTP(szCFrame)
                        task.wait(0.5) 
                    end
                    return 
                end

                local brainrotsFolder = workspace:FindFirstChild("Brainrots")
                if not brainrotsFolder then return end

                local hasGrabbed = false 
                
                local function grabItem(targetUI, targetPart)
                    local targetPos = targetPart.CFrame * CFrame.new(0, 2, 0)
                    TripleTP(targetPos)
                    
                    pcall(function()
                        player.Character.Humanoid:MoveTo(hrp.Position + Vector3.new(0.5, 0, 0.5))
                    end)
                    
                    task.wait(0.21)
                    hrp.Velocity = Vector3.zero
                    
                    if targetUI:IsA("ProximityPrompt") then
                        fireproximityprompt(targetUI)
                        hasGrabbed = true
                    elseif targetUI:IsA("BillboardGui") then
                        for _, btn in pairs(targetUI:GetDescendants()) do
                            if (btn:IsA("TextButton") or btn:IsA("ImageButton")) then
                                if getconnections then
                                    for _, conn in pairs(getconnections(btn.MouseButton1Click)) do
                                        conn:Fire()
                                        hasGrabbed = true 
                                        break
                                    end
                                end
                            end
                            if hasGrabbed then break end
                        end
                    end
                    
                    if hasGrabbed then
                        task.wait(0.5) 
                    end
                end

                for _, v in pairs(brainrotsFolder:GetDescendants()) do
                    if hasGrabbed then break end 
                    
                    local isDivine = false
                    local itemPart = nil

                    if v:IsA("ProximityPrompt") then
                        local parentObj = v:FindFirstAncestorOfClass("Model") or v:FindFirstAncestorWhichIsA("BasePart")
                        if parentObj then
                            for _, child in pairs(parentObj:GetDescendants()) do
                                if child:IsA("TextLabel") and child.Text:upper():find("DIVINE") then
                                    isDivine = true; break
                                end
                            end
                        end
                        if isDivine then itemPart = v:FindFirstAncestorWhichIsA("BasePart") end

                    elseif v:IsA("BillboardGui") then
                        local allText = ""
                        for _, txt in pairs(v:GetDescendants()) do
                            if txt:IsA("TextLabel") then
                                local tUpper = txt.Text:upper()
                                if tUpper:find("DIVINE") then isDivine = true end
                                allText = allText .. " " .. txt.Text:lower()
                            end
                        end
                        if isDivine and (allText:find("pick") or allText:find("up")) then
                            itemPart = v.Adornee or v:FindFirstAncestorWhichIsA("BasePart")
                        end
                    end
                    
                    if isDivine and itemPart then
                        grabItem(v, itemPart)
                    end
                end
            end)
        end
    end
end)

-- [[ 5. FINALIZE (FLUENT STRUCTURE) ]] --
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
Fluent:Notify({
    Title = "Catmio",
    Content = "The script has been loaded.",
    Duration = 8
})
SaveManager:LoadAutoloadConfig()
