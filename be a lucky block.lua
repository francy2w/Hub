-- Load the library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/JScripter-Lua/XovaModedLib/refs/heads/main/VitaLib_Enhanced.lua"))()

-- ==========================================
-- âš™ï¸ [ SETTINGS FOR UPDATES ] âš™ï¸
-- ==========================================
local TARGET_ZONE = "base15" 
local SPAWN_POS = CFrame.new(715, 39, -2122)
local WALK_POS = Vector3.new(710, 39, -2122)
local RESPAWN_POS = CFrame.new(737, 39, -2118)
-- ==========================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Create a window with Orange theme
local Window = Library:Window({
    Title = "Be a Lucky Block | Catmio",
    SubTitle = "Made by Francy",
    Size = UDim2.new(0, 550, 0, 400),
    ToggleKey = Enum.KeyCode.RightControl,
    BbIcon = "package",
    AutoScale = true,
    Scale = 1.45,
    ExecIdentifyShown = true,
    
    Theme = {
        Accent = "#FF8C00", -- Orange
        Background = "#0D0D0D",
        Row = "#0F0F0F",
        Text = "#FFFFFF",
        SubText = "#A3A3A3"
    }
})

------------------------------------------------------------
-- Page 1: Main Hacks
------------------------------------------------------------
local MainPage = Window:NewPage({
    Title = "Main features",
    Desc = "Main features for Lucky Block",
    Icon = "settings",
    TabImage = "#FF8C00"
})

MainPage:Section("Boss & Models")

-- A) REMOVE DETECTORS
local storedParts = {}
local removeDetectors = false

MainPage:Toggle({
    Title = "Remove Bad Boss Detectors",
    Desc = "Removes detectors that are not in the target zone.",
    Value = false,
    Callback = function(value)
        removeDetectors = value
        local folder = workspace:WaitForChild("BossTouchDetectors", 5)
        if folder then
            if removeDetectors then
                storedParts = {}
                for _, obj in ipairs(folder:GetChildren()) do
                    if obj.Name ~= TARGET_ZONE then
                        table.insert(storedParts, obj)
                        obj.Parent = nil
                    end
                end
                Library:Notification({
                    Title = "Detectors Removed",
                    Desc = "Bad boss detectors have been hidden.",
                    Duration = 3,
                    Type = "Success"
                })
            else
                for _, obj in ipairs(storedParts) do
                    if obj then obj.Parent = folder end
                end
                storedParts = {}
                Library:Notification({
                    Title = "Detectors Restored",
                    Desc = "All detectors are back to normal.",
                    Duration = 3,
                    Type = "Info"
                })
            end
        end
    end
})

-- B) TELEPORT MODELS
MainPage:Button({
    Title = "Teleport All Models to End",
    Desc = "Moves all running models to the collection zone.",
    Text = "Teleport",
    Callback = function()
        local modelsFolder = workspace:WaitForChild("RunningModels", 5)
        local target = workspace:WaitForChild("CollectZones", 5):WaitForChild(TARGET_ZONE, 5)
        
        if modelsFolder and target then
            local count = 0
            for _, obj in ipairs(modelsFolder:GetChildren()) do
                if obj:IsA("Model") then
                    if obj.PrimaryPart then
                        obj:SetPrimaryPartCFrame(target.CFrame)
                        count = count + 1
                    else
                        local part = obj:FindFirstChildWhichIsA("BasePart")
                        if part then 
                            part.CFrame = target.CFrame 
                            count = count + 1
                        end
                    end
                elseif obj:IsA("BasePart") then
                    obj.CFrame = target.CFrame
                    count = count + 1
                end
            end
            Library:Notification({
                Title = "Teleport Complete",
                Desc = "Teleported " .. tostring(count) .. " models to the end.",
                Duration = 3,
                Type = "Success"
            })
        else
            Library:Notification({
                Title = "Error",
                Desc = "Could not find models or target zone.",
                Duration = 5,
                Type = "Error"
            })
        end
    end
})

MainPage:Section("Automation")

-- C) AUTO FARM
local autoFarm = false
local farmThread = nil

MainPage:Toggle({
    Title = "Auto Farm Brainrots",
    Desc = "Automatically spawns and teleports your models.",
    Value = false,
    Callback = function(value)
        autoFarm = value
        if autoFarm then
            farmThread = task.spawn(function()
                while autoFarm do
                    local char = player.Character or player.CharacterAdded:Wait()
                    local root = char:WaitForChild("HumanoidRootPart", 5)
                    local humanoid = char:WaitForChild("Humanoid", 5)
                    local modelsFolder = workspace:WaitForChild("RunningModels", 5)
                    local target = workspace:WaitForChild("CollectZones", 5):WaitForChild(TARGET_ZONE, 5)
                    
                    if not root or not humanoid or not modelsFolder or not target then 
                        task.wait(1)
                        continue 
                    end
                    
                    -- Teleport to spawn and move
                    root.CFrame = SPAWN_POS
                    task.wait(0.3)
                    humanoid:MoveTo(WALK_POS)
                    
                    -- Wait for owned model
                    local ownedModel = nil
                    local startTime = tick()
                    repeat
                        task.wait(0.3)
                        for _, obj in ipairs(modelsFolder:GetChildren()) do
                            if obj:IsA("Model") and obj:GetAttribute("OwnerId") == player.UserId then
                                ownedModel = obj
                                break
                            end
                        end
                    until ownedModel ~= nil or not autoFarm or (tick() - startTime > 10)
                    
                    if not autoFarm or not ownedModel then continue end
                    
                    -- Teleport model to target
                    if ownedModel.PrimaryPart then
                        ownedModel:SetPrimaryPartCFrame(target.CFrame)
                    else
                        local part = ownedModel:FindFirstChildWhichIsA("BasePart")
                        if part then part.CFrame = target.CFrame end
                    end
                    
                    task.wait(0.7)
                    
                    -- Secondary teleport for safety
                    if ownedModel and ownedModel.Parent == modelsFolder then
                        if ownedModel.PrimaryPart then
                            ownedModel:SetPrimaryPartCFrame(target.CFrame * CFrame.new(0, -5, 0))
                        else
                            local part = ownedModel:FindFirstChildWhichIsA("BasePart")
                            if part then part.CFrame = target.CFrame * CFrame.new(0, -5, 0) end
                        end
                    end
                    
                    -- Wait for model to finish
                    repeat task.wait(0.3) until not autoFarm or (ownedModel == nil or ownedModel.Parent ~= modelsFolder)
                    if not autoFarm then break end
                    
                    -- Wait for respawn
                    local oldChar = player.Character
                    repeat task.wait(0.2) until not autoFarm or (player.Character ~= oldChar and player.Character ~= nil)
                    if not autoFarm then break end
                    
                    task.wait(0.4)
                    local newChar = player.Character
                    local newRoot = newChar:WaitForChild("HumanoidRootPart", 5)
                    if newRoot then
                        newRoot.CFrame = RESPAWN_POS
                    end
                    task.wait(2.1)
                end
            end)
            Library:Notification({
                Title = "Auto Farm Enabled",
                Desc = "Starting the brainrot farm loop.",
                Duration = 3,
                Type = "Info"
            })
        else
            if farmThread then
                task.cancel(farmThread)
                farmThread = nil
            end
            Library:Notification({
                Title = "Auto Farm Disabled",
                Desc = "Farm loop stopped.",
                Duration = 3,
                Type = "Info"
            })
        end
    end
})

------------------------------------------------------------
-- Page 2: Settings
------------------------------------------------------------
local SettingsPage = Window:NewPage({
    Title = "Settings",
    Desc = "UI and script configuration",
    Icon = "settings",
    TabImage = "#FF8C00"
})

SettingsPage:Section("UI Configuration")

Library:AddSizeSlider(SettingsPage)

SettingsPage:Button({
    Title = "Unload Script",
    Desc = "Completely removes the UI and stops all loops.",
    Text = "Unload",
    Callback = function()
        autoFarm = false
        removeDetectors = false
        if farmThread then task.cancel(farmThread) end
        Library:Destroy()
    end
})

-- Final notification
Library:Notification({
    Title = "Script Loaded",
    Desc = "Catmio is ready. Press RightControl to toggle.",
    Duration = 5,
    Type = "Success"
})

print("Catmio Loaded")
