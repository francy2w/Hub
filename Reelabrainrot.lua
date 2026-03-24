-- Load the Vita UI library

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/JScripter-Lua/XovaModedLib/refs/heads/main/VitaLib_Enhanced.lua"))()



-- =====================

-- GLOBAL VARIABLES

-- =====================



local Players = game:GetService("Players")

local Workspace = game:GetService("Workspace")

local RunService = game:GetService("RunService")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UserInputService = game:GetService("UserInputService")

local TeleportService = game:GetService("TeleportService")

local VirtualUser = game:GetService("VirtualUser")

local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")



-- Create the main window with Vita UI styling

local Window = Library:Window({

    Title = "Reel a Brainrot | Catmio",

    SubTitle = "Made by Francy https://discord.gg/RWEwAZUn4h - ",

    ToggleKey = Enum.KeyCode.RightControl, -- Default toggle key

    BbIcon = "settings", -- Default pill icon

    AutoScale = true,

    Scale = 1.0,

    ExecIdentifyShown = true,

    Theme = {

        Accent = "#FF4500", -- Hot pink

        Background = "#0D0D0D",

        Row = "#0F0F0F",

        Text = "#FFFFFF",

        SubText = "#A3A3A3"

    }

})



-- Global variables for automation

local scriptState = {

    autoCollect = false,

    autoFish = false,

    autoUpgrade = false,

    targetUpgrade = "power1",

    noclipActive = false,

    noclipConn = nil,

    flyActive = false,

    flyBV = nil,

    antiAFKActive = false,

    antiAFKLoop = nil,

    infJumpActive = false,

    infJumpConn = nil,

}



-- --- PÃGINAS CON COLORES PERSONALIZADOS ---

local AutomationPage = Window:NewPage({

    Title = "Automation",

    Desc = "Task automation",

    Icon = "play-circle", -- Lucide icon for automation

    TabImage = "#FFD700" -- Gold for Automation

})



local EconomyPage = Window:NewPage({

    Title = "Economy",

    Desc = "Shop and selling features",

    Icon = "dollar-sign", -- Lucide icon for economy

    TabImage = "#32CD32" -- Lime Green for Economy

})



local ExtraToolsPage = Window:NewPage({

    Title = "ExtraTools",

    Desc = "Player commands and movement",

    Icon = "tool", -- Lucide icon for extra tools

    TabImage = "#00BFFF" -- Deep Sky Blue for Extra Tools

})



local SettingsPage = Window:NewPage({

    Title = "Settings",

    Desc = "Configuration Options",

    Icon = "settings", -- Lucide icon for settings

    TabImage = "#A9A9A9" -- Dark Gray for Settings

})



-- =====================

-- AUTOMATION PAGE

-- =====================



AutomationPage:Section("Collector")

AutomationPage:Toggle({

    Title = "Auto-Collect All Plots",

    Desc = "Automatically collects items from all plots.",

    Value = false,

    Callback = function(value)

        scriptState.autoCollect = value

        task.spawn(function()

            while scriptState.autoCollect do

                for i = 1, 10 do

                    if not scriptState.autoCollect then break end

                    ReplicatedStorage:WaitForChild("RemoteHandler"):WaitForChild("Collect"):FireServer(("Plot") .. i)

                    task.wait(0.05)

                end

                task.wait(0.5)

            end

        end)

    end

})



AutomationPage:Section("Fishing")

AutomationPage:Toggle({

    Title = "Auto-Fish/Insta",

    Desc = "Automatically catch and reel in fish.",

    Value = false,

    Callback = function(value)

        scriptState.autoFish = value

        task.spawn(function()

            while scriptState.autoFish do

                ReplicatedStorage:WaitForChild("RemoteHandler"):WaitForChild("Fishing"):FireServer("Caught", 2)

                task.wait(0.3)

            end

        end)

    end

})



AutomationPage:Section("Targeted Upgrades")

AutomationPage:Dropdown({

    Title = "Select Upgrade Tier",

    Desc = "Choose which tier to auto-upgrade.",

    List = {"power1", "power5", "power10"},

    Value = "power1",

    Callback = function(option)

        scriptState.targetUpgrade = option

    end

})

AutomationPage:Toggle({

    Title = "Auto-Upgrade Selected",

    Desc = "Automatically buys the selected upgrade tier.",

    Value = false,

    Callback = function(value)

        scriptState.autoUpgrade = value

        task.spawn(function()

            while scriptState.autoUpgrade do

                ReplicatedStorage:WaitForChild("RemoteHandler"):WaitForChild("Upgrade"):FireServer(scriptState.targetUpgrade)

                task.wait(0.1)

            end

        end)

    end

})



-- =====================

-- ECONOMY PAGE

-- =====================



EconomyPage:Section("Selling")

EconomyPage:Button({

    Title = "Sell All (Except Legendary)",

    Desc = "Sells everything except Legendary.",

    Text = "SELL",

    Callback = function()

        local args = {

            {

                Legendary = false,

                Rare = true,

                Mythic = true,

                Epic = true,

                Uncommon = true,

                Secret = true

            }

        }

        ReplicatedStorage:WaitForChild("RemoteHandler"):WaitForChild("SellMultiple"):FireServer(unpack(args))

    end

})



EconomyPage:Section("Buying")

EconomyPage:Button({

    Title = "Buy All Fishing Rods (2-18)",

    Desc = "Purchases all available fishing rods.",

    Text = "BUY RODS",

    Callback = function()

        for i = 2, 18 do

            local args = {"Buy", "FishingRod" .. i}

            ReplicatedStorage:WaitForChild("RemoteHandler"):WaitForChild("FishingRod"):FireServer(unpack(args))

            task.wait(0.1)

        end

    end

})



-- =====================

-- EXTRATOOLS PAGE

-- =====================



ExtraToolsPage:Section("Player Commands")

ExtraToolsPage:Input({

    Title = "Target Player",

    Desc = "Enter player name for commands",

    Value = "",

    Callback = function(text) _G.TargetPlayer = text end

})

ExtraToolsPage:Button({

    Title = "Kill Player",

    Desc = "Set target player's health to 0",

    Text = "KILL",

    Callback = function()

        if _G.TargetPlayer and Players:FindFirstChild(_G.TargetPlayer) then

            Players[_G.TargetPlayer].Character.Humanoid.Health = 0

        end

    end

})

ExtraToolsPage:Button({

    Title = "Teleport to Player",

    Desc = "Teleport to the target player's location",

    Text = "TP TO",

    Callback = function()

        if _G.TargetPlayer and Players:FindFirstChild(_G.TargetPlayer) and Players[_G.TargetPlayer].Character then

            LocalPlayer.Character.HumanoidRootPart.CFrame = Players[_G.TargetPlayer].Character.HumanoidRootPart.CFrame

        end

    end

})

ExtraToolsPage:Button({

    Title = "Bring Player",

    Desc = "Bring the target player to your location",

    Text = "BRING",

    Callback = function()

        if _G.TargetPlayer and Players:FindFirstChild(_G.TargetPlayer) and Players[_G.TargetPlayer].Character then

            Players[_G.TargetPlayer].Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame

        end

    end

})



ExtraToolsPage:Section("Movement")

ExtraToolsPage:Slider({

    Title = "WalkSpeed",

    Min = 16,

    Max = 500,

    Rounding = 0,

    Value = 16,

    Callback = function(value) LocalPlayer.Character.Humanoid.WalkSpeed = value end

})

ExtraToolsPage:Slider({

    Title = "JumpPower",

    Min = 50,

    Max = 1000,

    Rounding = 0,

    Value = 50,

    Callback = function(value) LocalPlayer.Character.Humanoid.JumpPower = value end

})

ExtraToolsPage:Toggle({

    Title = "Noclip",

    Desc = "Toggle collision with environment",

    Value = false,

    Callback = function(value)

        scriptState.noclipActive = value

        if scriptState.noclipConn then scriptState.noclipConn:Disconnect() end

        if value then

            scriptState.noclipConn = RunService.Stepped:Connect(function()

                if scriptState.noclipActive and LocalPlayer.Character then

                    for _, v in pairs(LocalPlayer.Character:GetDescendants()) do

                        if v:IsA("BasePart") then v.CanCollide = false end

                    end

                end

            end)

        else

            if LocalPlayer.Character then

                for _, v in pairs(LocalPlayer.Character:GetDescendants()) do

                    if v:IsA("BasePart") then v.CanCollide = true end

                end

            end

        end

    end

})

ExtraToolsPage:Toggle({

    Title = "Fly",

    Desc = "Enable free flight mode",

    Value = false,

    Callback = function(value)

        scriptState.flyActive = value

        local char = LocalPlayer.Character

        if char then

            local hum = char:FindFirstChildOfClass("Humanoid")

            if hum then

                hum.PlatformStand = value

                if value then

                    local bv = Instance.new("BodyVelocity", char.HumanoidRootPart)

                    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

                    bv.Velocity = Vector3.new(0,0,0)

                    scriptState.flyBV = bv

                    task.spawn(function()

                        while scriptState.flyActive do

                            local mv = Vector3.new(0,0,0)

                            local cf = Workspace.CurrentCamera.CFrame

                            if UserInputService:IsKeyDown(Enum.KeyCode.W) then mv = mv + cf.lookVector end

                            if UserInputService:IsKeyDown(Enum.KeyCode.S) then mv = mv - cf.lookVector end

                            if UserInputService:IsKeyDown(Enum.KeyCode.A) then mv = mv - cf.rightVector end

                            if UserInputService:IsKeyDown(Enum.KeyCode.D) then mv = mv + cf.rightVector end

                            scriptState.flyBV.Velocity = mv * 100

                            task.wait()

                        end

                        if scriptState.flyBV then scriptState.flyBV:Destroy() end

                    end)

                else

                    if scriptState.flyBV then scriptState.flyBV:Destroy() scriptState.flyBV = nil end

                end

            end

        end

    end

})



ExtraToolsPage:Button({

    Title = "Rejoin Server",

    Desc = "Teleport to the current game server",

    Text = "REJOIN",

    Callback = function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end

})

ExtraToolsPage:Button({

    Title = "Respawn",

    Desc = "Force your character to respawn",

    Text = "RESPAWN",

    Callback = function() LocalPlayer:LoadCharacter() end

})

ExtraToolsPage:Toggle({

    Title = "Anti-AFK",

    Desc = "Prevent being kicked for inactivity",

    Value = false,

    Callback = function(value)

        scriptState.antiAFKActive = value

        if scriptState.antiAFKLoop then task.cancel(scriptState.antiAFKLoop) end

        if value then

            scriptState.antiAFKLoop = task.spawn(function()

                while scriptState.antiAFKActive do

                    VirtualUser:CaptureController()

                    VirtualUser:ClickButton2(Vector2.new())

                    task.wait(30)

                end

            end)

        end

    end

})

ExtraToolsPage:Button({

    Title = "BTools",

    Desc = "Get building tools in your backpack",

    Text = "GET",

    Callback = function()

        Instance.new("HopperBin", LocalPlayer.Backpack).BinType = 4

        Instance.new("HopperBin", LocalPlayer.Backpack).BinType = 3

        Instance.new("HopperBin", LocalPlayer.Backpack).BinType = 2

    end

})

ExtraToolsPage:Toggle({

    Title = "Infinite Jump",

    Desc = "Allow continuous jumping",

    Value = false,

    Callback = function(value)

        scriptState.infJumpActive = value

        if scriptState.infJumpConn then scriptState.infJumpConn:Disconnect() end

        if value then

            scriptState.infJumpConn = UserInputService.JumpRequest:Connect(function()

                if scriptState.infJumpActive then LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end

            end)

        end

    end

})

ExtraToolsPage:Button({

    Title = "Fullbright",

    Desc = "Set lighting to full brightness",

    Text = "ON",

    Callback = function()

        Lighting.Brightness = 2

        Lighting.ClockTime = 14

        Lighting.FogEnd = 100000

        Lighting.GlobalShadows = false

    end

})



ExtraToolsPage:Section("Spy Tools")

ExtraToolsPage:Button({

    Title = "Load Remote Spy",

    Desc = "Load SimpleSpy for remote event monitoring",

    Text = "LOAD",

    Callback = function()

        loadstring(game:HttpGet("https://raw.githubusercontent.com/78n/SimpleSpy/main/SimpleSpySource.lua"))()

    end

})

ExtraToolsPage:Button({

    Title = "Load Silent Spy",

    Desc = "Load Silent Spy / Hydroxide-like script",

    Text = "LOAD",

    Callback = function()

        loadstring(game:HttpGet("https://raw.githubusercontent.com/Upbolt/Hydroxide/revision/oh-spy.lua"))()

    end

})



ExtraToolsPage:Section("Extra Commands")

ExtraToolsPage:Button({Title = "God Mode", Desc = "Set health to infinite", Text = "ENABLE", Callback = function() LocalPlayer.Character.Humanoid.MaxHealth = math.huge; LocalPlayer.Character.Humanoid.Health = math.huge end})

ExtraToolsPage:Button({Title = "Invisibility", Desc = "Make your character invisible", Text = "ENABLE", Callback = function() LocalPlayer.Character.LowerTorso.Root:Destroy() end})

ExtraToolsPage:Button({Title = "Unlock Fps", Desc = "Set FPS cap to 999", Text = "RUN", Callback = function() setfpscap(999) end})

ExtraToolsPage:Button({Title = "Destroy UI", Desc = "Destroy the current UI", Text = "DESTROY", Callback = function() Library:Destroy() end})



-- =====================

-- SETTINGS PAGE (Empty in original, adding placeholder)

-- =====================



SettingsPage:Section("Script Information")

SettingsPage:Paragraph({

    Title = "Developer",

    Desc = "Francy | Catmio"

})

SettingsPage:Paragraph({

    Title = "Version",

    Desc = "idk but join discord"

})

SettingsPage:Paragraph({

    Title = "Discord",

    Desc = "https://discord.gg/RWEwAZUn4h"

})



-- Finalize

Window:SelectPage(AutomationPage)



print("i like cats")

print("and dogs")
