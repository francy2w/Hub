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

local LocalPlayer = Players.LocalPlayer

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")



-- Create the main window with Vita UI styling

local Window = Library:Window({

    Title = "Hyper Speed Runner | Catmio",

    SubTitle = "Made by Francy",

    ToggleKey = Enum.KeyCode.RightControl, -- Default toggle key

    BbIcon = "settings", -- Default pill icon

    AutoScale = true,

    Scale = 1.0,

    ExecIdentifyShown = true,

    Theme = {

        Accent = "#FF4500", -- Green accent for speed theme

        Background = "#0D0D0D",

        Row = "#0F0F0F",

        Text = "#FFFFFF",

        SubText = "#A3A3A3"

    }

})



-- --- PÃGINAS CON COLORES PERSONALIZADOS ---

local MainPage = Window:NewPage({

    Title = "Main",

    Desc = "Core Exploits",

    Icon = "activity", -- Lucide icon for activity/speed

    TabImage = "#00FF00" -- Green for Main Page

})



local RebirthPage = Window:NewPage({

    Title = "Rebirth",

    Desc = "Rebirth Automation",

    Icon = "refresh-cw", -- Lucide icon for rebirth

    TabImage = "#32CD32" -- Lime Green for Rebirth Page

})



local UtilitiesPage = Window:NewPage({

    Title = "Utilities",

    Desc = "Extra Tools and Settings",

    Icon = "tool", -- Lucide icon for tools

    TabImage = "#00BFFF" -- Deep Sky Blue for Utilities Page

})



local SettingsPage = Window:NewPage({

    Title = "Settings",

    Desc = "Configuration Options",

    Icon = "settings", -- Lucide icon for settings

    TabImage = "#A9A9A9" -- Dark Gray for Settings Page

})



-- =====================

-- SCRIPT STATE VARIABLES

-- =====================

local scriptState = {

    infSpeedActive = false,

    infMoneyActive = false,

    autoRebirthActive = false,

    autoRebirthLoop = nil,

    tpToolActive = false,

    tpToolInstance = nil,

}



-- =====================

-- MAIN PAGE

-- =====================



MainPage:Section("Player Exploits")



-- INF SPEED

MainPage:Toggle({

    Title = "Inf Speed",

    Desc = "StepTaken loop for infinite speed",

    Value = false,

    Callback = function(value)

        scriptState.infSpeedActive = value

        if value then

            task.spawn(function()

                while scriptState.infSpeedActive do

                    local args = {

                        1000000000000000000000,

                        false

                    }

                    ReplicatedStorage

                        :WaitForChild("Remotes")

                        :WaitForChild("StepTaken")

                        :FireServer(unpack(args))

                    task.wait(0.1)

                end

            end)

        end

    end

})



-- INF WINS (MONEY)

MainPage:Toggle({

    Title = "Inf Wins (Money)",

    Desc = "TP loop for infinite money/wins",

    Value = false,

    Callback = function(value)

        scriptState.infMoneyActive = value

        if value then

            task.spawn(function()

                local plr = LocalPlayer

                while scriptState.infMoneyActive do

                    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then

                        plr.Character.HumanoidRootPart.CFrame = CFrame.new(2, 4, -9072)

                    end

                    task.wait(1)

                end

            end)

        end

    end

})



-- WALK SPEED

MainPage:Slider({

    Title = "Walk Speed",

    Min = 16,

    Max = 100,

    Rounding = 1,

    Value = 16,

    Callback = function(value)

        LocalPlayer.Character.Humanoid.WalkSpeed = value

    end

})



-- WELCOME MESSAGE

MainPage:Paragraph({

    Title = "Welcome Message",

    Desc = "Hello! Welcome to the script. Use the toggles to enable features.",

    Icon = "info" -- Using Lucide info icon

})



-- BANNER (Original asset ID used, Vita UI supports asset IDs for banners)

MainPage:Banner("rbxassetid://125411502674016")



-- =====================

-- REBIRTH PAGE

-- =====================



RebirthPage:Section("Rebirth Automation")



RebirthPage:Toggle({

    Title = "Auto Rebirth",

    Desc = "Automatically perform rebirths",

    Value = false,

    Callback = function(value)

        scriptState.autoRebirthActive = value

        if scriptState.autoRebirthActive then

            scriptState.autoRebirthLoop = task.spawn(function()

                while scriptState.autoRebirthActive do

                    local args = {"free"}

                    ReplicatedStorage

                        :WaitForChild("Remotes")

                        :WaitForChild("RequestRebirth")

                        :FireServer(unpack(args))

                    task.wait(5)

                end

            end)

        else

            if scriptState.autoRebirthLoop then

                task.cancel(scriptState.autoRebirthLoop)

                scriptState.autoRebirthLoop = nil

            end

        end

    end

})



-- =====================

-- UTILITIES PAGE

-- =====================



UtilitiesPage:Section("Tools")



UtilitiesPage:Toggle({

    Title = "TP Tool",

    Desc = "Give/Remove Teleport Tool to Backpack",

    Value = false,

    Callback = function(value)

        scriptState.tpToolActive = value

        if value then

            local Tool = Instance.new("Tool")

            Tool.Name = "TP Tool"

            Tool.RequiresHandle = false

            Tool.Parent = LocalPlayer.Backpack

            Tool.Activated:Connect(function()

                local mouse = LocalPlayer:GetMouse()

                if mouse.Hit then

                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0,5,0))

                end

            end)

            scriptState.tpToolInstance = Tool

        else

            if scriptState.tpToolInstance then

                scriptState.tpToolInstance:Destroy()

                scriptState.tpToolInstance = nil

            end

        end

    end

})



-- =====================

-- SETTINGS PAGE

-- =====================



SettingsPage:Section("Script Information")

SettingsPage:Paragraph({

    Title = "Developer",

    Desc = "Francy | Catmio"

})

SettingsPage:Paragraph({

    Title = "Version",

    Desc = "idkk"

})

SettingsPage:Paragraph({

    Title = "Last Updated",

    Desc = "2026-03-24"

})



SettingsPage:Section("Global Settings")

SettingsPage:Paragraph({

    Title = "Anti AFK",

    Desc = "Automatically disables player idling."

})



-- =====================

-- GLOBAL SCRIPT LOGIC (outside UI elements)

-- =====================



-- Anti AFK (always active, not a UI toggle)

local plr = LocalPlayer

for _, connection in pairs(getconnections(plr.Idled)) do

    connection:Disable()

end



print("mew")
