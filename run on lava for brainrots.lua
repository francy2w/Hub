-- Load the library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/JScripter-Lua/XovaModedLib/refs/heads/main/VitaLib_Enhanced.lua"))()

-- Create a window with custom theme and settings
local Window = Library:Window({
    Title = "Run On Lava For Brainrots | Catmio",
    SubTitle = "Made by Francy",
    Size = UDim2.new(0, 550, 0, 400),  -- Custom size
    ToggleKey = Enum.KeyCode.RightControl,  -- Custom toggle key
    BbIcon = "settings",  -- Pill icon (auto-resolves to lucide-settings)
    AutoScale = true,  -- Auto-scale to screen size
    Scale = 1.45,  -- Base scale
    ExecIdentifyShown = true,  -- Show executor name
    
    -- Custom theme with Orange accent
    Theme = {
        Accent = "#FF8C00",  -- Dark Orange
        Background = "#0D0D0D",
        Row = "#0F0F0F",
        Text = "#FFFFFF",
        SubText = "#A3A3A3"
    }
})

------------------------------------------------------------
-- Page 1: Teleports
------------------------------------------------------------
local TeleportsPage = Window:NewPage({
    Title = "Teleports",
    Desc = "Teleport to various locations",
    Icon = "map-pin",
    TabImage = "#FF8C00"
})

TeleportsPage:Section("Locations")

local TeleportLocations = {
    home = Vector3.new(-856, 37, 47),
    uncommon = Vector3.new(-810, 37, 49),
    rare = Vector3.new(-668, 37, 2),
    epic = Vector3.new(-487, 37, -13),
    legendary = Vector3.new(-295, 37, 36),
    Mythic = Vector3.new(54, 37, -6),
    Eternal = Vector3.new(300, 37, -2),
    secret = Vector3.new(740, 37, -11),
    Celestial = Vector3.new(879, 37, -105)
}

-- Order the locations for better UI layout
local orderedLocations = {"home", "uncommon", "rare", "epic", "legendary", "Mythic", "Eternal", "secret", "Celestial"}

for _, name in ipairs(orderedLocations) do
    local coords = TeleportLocations[name]
    TeleportsPage:Button({
        Title = "Teleport " .. name:gsub("^", string.upper(name:sub(1,1))):sub(1,1) .. name:sub(2),
        Desc = "Click to teleport to " .. name,
        Text = "Go",
        Callback = function()
            local Player = game:GetService("Players").LocalPlayer
            if Player and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                Player.Character.HumanoidRootPart.CFrame = CFrame.new(coords)
                Library:Notification({
                    Title = "Teleport Success",
                    Desc = "Teleported to " .. name,
                    Duration = 3,
                    Type = "Success"
                })
            else
                Library:Notification({
                    Title = "Teleport Error",
                    Desc = "Could not teleport. Make sure you are in-game and have a character.",
                    Duration = 5,
                    Type = "Error"
                })
            end
        end
    })
end

------------------------------------------------------------
-- Page 2: Upgrades
------------------------------------------------------------
local UpgradesPage = Window:NewPage({
    Title = "Upgrades",
    Desc = "Money options and auto-buys",
    Icon = "trending-up",
    TabImage = "#FF8C00"
})

UpgradesPage:Section("Money")

UpgradesPage:Button({
    Title = "Infinite Money",
    Desc = "Activate the infinite money script",
    Text = "Activate",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/NOW-Run-on-Lava-for-Brainrots-inf-money-138716"))()
        Library:Notification({
            Title = "Infinite Money Activated",
            Desc = "The infinite money script has been executed.",
            Duration = 3,
            Type = "Success"
        })
    end
})

UpgradesPage:Section("Auto Buys")

-- Auto Buy 10 Health
local autoBuyHealthToggle = false
local healthLoop = nil

UpgradesPage:Toggle({
    Title = "Auto Buy 10 Health (0.1s)",
    Desc = "Enable/disable automatic purchase of 10 health every 0.1 seconds.",
    Value = false,
    Callback = function(value)
        autoBuyHealthToggle = value
        if autoBuyHealthToggle then
            healthLoop = spawn(function()
                while autoBuyHealthToggle do
                    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("acecateer_knit@1.7.2"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("UpgradesService"):WaitForChild("RE"):WaitForChild("X10HealthButtonClicked"):FireServer()
                    wait(0.1)
                end
            end)
            Library:Notification({
                Title = "Auto Buy Health",
                Desc = "Auto buy 10 health enabled.",
                Duration = 2,
                Type = "Info"
            })
        else
            if healthLoop then
                task.cancel(healthLoop)
                healthLoop = nil
            end
            Library:Notification({
                Title = "Auto Buy Health",
                Desc = "Auto buy 10 health disabled.",
                Duration = 2,
                Type = "Info"
            })
        end
    end
})

UpgradesPage:Button({
    Title = "Buy 10 Health",
    Desc = "Purchase 10 health once.",
    Text = "Buy",
    Callback = function()
        game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("acecateer_knit@1.7.2"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("UpgradesService"):WaitForChild("RE"):WaitForChild("X10HealthButtonClicked"):FireServer()
        Library:Notification({
            Title = "Health Purchased",
            Desc = "Successfully bought 10 health.",
            Duration = 2,
            Type = "Success"
        })
    end
})

-- Auto Buy 1 Speed
local autoBuySpeedToggle = false
local speedLoop = nil

UpgradesPage:Toggle({
    Title = "Auto Buy 1 Speed (0.1s)",
    Desc = "Enable/disable automatic purchase of 1 speed every 0.1 seconds.",
    Value = false,
    Callback = function(value)
        autoBuySpeedToggle = value
        if autoBuySpeedToggle then
            speedLoop = spawn(function()
                while autoBuySpeedToggle do
                    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("acecateer_knit@1.7.2"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("UpgradesService"):WaitForChild("RE"):WaitForChild("SpeedButtonClicked"):FireServer()
                    wait(0.1)
                end
            end)
            Library:Notification({
                Title = "Auto Buy Speed",
                Desc = "Auto buy 1 speed enabled.",
                Duration = 2,
                Type = "Info"
            })
        else
            if speedLoop then
                task.cancel(speedLoop)
                speedLoop = nil
            end
            Library:Notification({
                Title = "Auto Buy Speed",
                Desc = "Auto buy 1 speed disabled.",
                Duration = 2,
                Type = "Info"
            })
        end
    end
})

UpgradesPage:Button({
    Title = "Buy 1 Speed",
    Desc = "Purchase 1 speed once.",
    Text = "Buy",
    Callback = function()
        game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("acecateer_knit@1.7.2"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("UpgradesService"):WaitForChild("RE"):WaitForChild("SpeedButtonClicked"):FireServer()
        Library:Notification({
            Title = "Speed Purchased",
            Desc = "Successfully bought 1 speed.",
            Duration = 2,
            Type = "Success"
        })
    end
})

------------------------------------------------------------
-- Page 3: Player
------------------------------------------------------------
local PlayerPage = Window:NewPage({
    Title = "Player",
    Desc = "Player movement settings",
    Icon = "user",
    TabImage = "#FF8C00"
})

PlayerPage:Section("Movement")

-- Walkspeed Slider
local defaultWalkspeed = 16 -- Roblox default walkspeed
PlayerPage:Slider({
    Title = "Walk Speed",
    Min = 0,
    Max = 100,
    Rounding = 1,
    Value = defaultWalkspeed,
    Callback = function(value)
        local Player = game:GetService("Players").LocalPlayer
        if Player and Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
            Player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = value
        end
    end
})

-- Fly Boost Toggle
local flyBoostToggle = false
local flyLoop = nil

PlayerPage:Toggle({
    Title = "Fly Boost",
    Desc = "Enable/disable flight mode.",
    Value = false,
    Callback = function(value)
        flyBoostToggle = value
        local Player = game:GetService("Players").LocalPlayer
        if Player and Player.Character then
            local Humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
            local HumanoidRootPart = Player.Character:FindFirstChild("HumanoidRootPart")

            if Humanoid and HumanoidRootPart then
                if flyBoostToggle then
                    Humanoid.PlatformStand = true
                    flyLoop = game:GetService("RunService").RenderStepped:Connect(function()
                        local Camera = game:GetService("Workspace").CurrentCamera
                        local moveSpeed = 2 -- Base fly speed

                        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Camera.CFrame.LookVector * moveSpeed
                        end
                        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame - Camera.CFrame.LookVector * moveSpeed
                        end
                        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame - Camera.CFrame.RightVector * moveSpeed
                        end
                        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Camera.CFrame.RightVector * moveSpeed
                        end
                        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Vector3.new(0, moveSpeed, 0)
                        end
                        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then
                            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame - Vector3.new(0, moveSpeed, 0)
                        end
                    end)
                    Library:Notification({
                        Title = "Fly Boost Enabled",
                        Desc = "Use WASD to move, Space to go up, Ctrl to go down.",
                        Duration = 5,
                        Type = "Info"
                    })
                else
                    if flyLoop then
                        flyLoop:Disconnect()
                        flyLoop = nil
                    end
                    Humanoid.PlatformStand = false
                    Library:Notification({
                        Title = "Fly Boost Disabled",
                        Desc = "Flight mode turned off.",
                        Duration = 2,
                        Type = "Info"
                    })
                end
            else
                Library:Notification({
                    Title = "Fly Boost Error",
                    Desc = "Could not activate flight. Ensure you have a valid character.",
                    Duration = 5,
                    Type = "Error"
                })
            end
        end
    end
})

-- Final notification
Library:Notification({
    Title = "UI Loaded",
    Desc = "Press RightControl to open/close the UI.",
    Duration = 5,
    Type = "Success"
})

print("Run On Lava For Brainrots UI Loaded!")
print("Press RightControl to toggle UI")
