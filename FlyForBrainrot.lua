-- Load the Vita UI library

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/JScripter-Lua/XovaModedLib/refs/heads/main/VitaLib_Enhanced.lua"))()



-- =====================

-- GLOBAL VARIABLES

-- =====================



local Players = game:GetService('Players')

local Workspace = game:GetService('Workspace')

local RunService = game:GetService('RunService')

local TweenService = game:GetService('TweenService')

local ReplicatedStorage = game:GetService('ReplicatedStorage')

local UserInputService = game:GetService('UserInputService')

local LocalPlayer = Players.LocalPlayer

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local HumanoidRootPart = Character:WaitForChild('HumanoidRootPart')



-- Create the main window with Vita UI styling

local Window = Library:Window({

    Title = 'Fly For Brainrots Catmio',

    SubTitle = 'Made by Francy..',

    ToggleKey = Enum.KeyCode.RightControl, -- Default toggle key

    BbIcon = "settings", -- Default pill icon

    AutoScale = true,

    Scale = 1.0,

    ExecIdentifyShown = true,

    Theme = {

        Accent = "#FF007F", -- Default accent

        Background = "#0D0D0D",

        Row = "#0F0F0F",

        Text = "#FFFFFF",

        SubText = "#A3A3A3"

    }

})



-- --- PÃGINAS CON COLORES PERSONALIZADOS ---

local TeleportPage = Window:NewPage({

    Title = 'Teleport',

    Desc = 'Fast travel to locations',

    Icon = "map-pin",

    TabImage = "#FF4500" -- Orange Red

})

local UtilitiesPage = Window:NewPage({

    Title = 'Utilities',

    Desc = 'Altitude and utility features',

    Icon = "tool",

    TabImage = "#00BFFF" -- Deep Sky Blue

})

local CombatPage = Window:NewPage({

    Title = 'Combat',

    Desc = 'Protection evasion systems',

    Icon = "sword",

    TabImage = "#FF0000" -- Red

})

local SpeedPage = Window:NewPage({

    Title = 'Speed',

    Desc = 'Speed enhancement upgrades',

    Icon = "zap",

    TabImage = "#FFD700" -- Gold

})

local RebirthPage = Window:NewPage({

    Title = 'Rebirth',

    Desc = 'Character rebirth features',

    Icon = "refresh-cw",

    TabImage = "#32CD32" -- Lime Green

})

local FlyPage = Window:NewPage({

    Title = 'Fly',

    Desc = 'Flight and mobility features',

    Icon = "plane",

    TabImage = "#8A2BE2" -- Blue Violet

})

local ExtraToolsPage = Window:NewPage({

    Title = 'Extra Tools',

    Desc = 'Additional utilities',

    Icon = "plus-circle",

    TabImage = "#FF69B4" -- Hot Pink

})

local SettingsPage = Window:NewPage({

    Title = 'Settings',

    Desc = 'Script configuration',

    Icon = "settings",

    TabImage = "#A9A9A9" -- Dark Gray

})



local scriptState = {

    avoidActive = false,

    noclipConn = nil,

    altitudePlatform = nil,

    speedX1Active = false,

    speedX1Loop = nil,

    speedX5Active = false,

    speedX5Loop = nil,

    speedX10Active = false,

    speedX10Loop = nil,

    autoUpgradeAllSpeedActive = false,

    autoUpgradeAllSpeedLoop = nil,

    rebirthX1Active = false,

    rebirthX1Loop = nil,

    noclipActive = false,

    noclipConn2 = nil,

    autoCollectActive = false,

    autoCollectLoop = nil,

}



-- =====================

-- UTILITY FUNCTIONS

-- =====================



local function teleportToPosition(x, y, z)

    local char = LocalPlayer.Character

    local root = char and char:FindFirstChild('HumanoidRootPart')

    if not root then

        return

    end

    root.CFrame = CFrame.new(x, y, z)

    task.wait(0.5)

end



local function fireRemoteEvent(bufferString, useUnpack)

    pcall(function()

        local packet = ReplicatedStorage:WaitForChild('Libraries'):WaitForChild('Packet')

        local remoteEvent = packet:WaitForChild('RemoteEvent')



        if useUnpack then

            local args = {

                buffer.fromstring(bufferString),

            }

            remoteEvent:FireServer(unpack(args))

        else

            remoteEvent:FireServer(buffer.fromstring(bufferString))

        end

    end)

end



local function teleportToSmallServer()

    pcall(function()

        local TeleportService = game:GetService('TeleportService')

        local placeId = game.PlaceId

        TeleportService:Teleport(placeId, LocalPlayer)

    end)

end



-- =====================

-- TELEPORT PAGE

-- =====================



TeleportPage:Section('Home Location')

TeleportPage:Button({

    Title = 'Teleport Home',

    Desc = 'Teleport to your home base',

    Text = 'TP',

    Callback = function()

        teleportToPosition(-1.98, 10.33, 44.24)

    end,

})

TeleportPage:Section('OG Area')

TeleportPage:Button({

    Title = 'Teleport OG Area',

    Desc = 'Teleport to the Original Gangster Area',

    Text = 'TP',

    Callback = function()

        teleportToPosition(-219.23, 50072.6, -12.62)

    end,

})

TeleportPage:Section('Divine Area')

TeleportPage:Button({

    Title = 'Teleport Divine Area',

    Desc = 'Teleport to the Divine Area',

    Text = 'TP',

    Callback = function()

        teleportToPosition(-237.94, 25063.23, -44.38)

    end,

})

TeleportPage:Section('Secret Area')

TeleportPage:Button({

    Title = 'Teleport Secret Area',

    Desc = 'Teleport to the Secret Area',

    Text = 'TP',

    Callback = function()

        teleportToPosition(-232.18, 15063.23, -34.28)

    end,

})

TeleportPage:Section('Ascendant')

TeleportPage:Button({

    Title = 'Teleport Ascendant',

    Desc = 'Teleport to the Ascendant Area',

    Text = 'TP',

    Callback = function()

        teleportToPosition(-266, 100061, -28)

    end,

})



-- =====================

-- UTILITIES PAGE

-- =====================



UtilitiesPage:Section('Altitude Control')



local altitudeToggle

altitudeToggle = UtilitiesPage:Toggle({

    Title = 'Keep Altitude',

    Desc = 'Maintain current altitude',

    Value = false,

    Callback = function(state)

        if state then

            local char = LocalPlayer.Character

            local root = char and char:FindFirstChild('HumanoidRootPart')

            if not root then return end



            local playerY = root.Position.Y - 3

            local platform = Instance.new('Part')

            platform.Name = 'AltitudePlatform'

            platform.Size = Vector3.new(10000, 1, 10000)

            platform.CFrame = CFrame.new(0, playerY, 0)

            platform.Anchored = true

            platform.CanCollide = true

            platform.Transparency = 1

            platform.CanTouch = false

            platform.CastShadow = false

            platform.Locked = true

            platform.Parent = Workspace

            scriptState.altitudePlatform = platform

        else

            if scriptState.altitudePlatform then

                scriptState.altitudePlatform:Destroy()

                scriptState.altitudePlatform = nil

            end

        end

    end,

})



UtilitiesPage:Section('Auto Collect')



local autoCollectToggle

autoCollectToggle = UtilitiesPage:Toggle({

    Title = 'Auto Collect Near',

    Desc = 'Automatically collect items via ProximityPrompt',

    Value = false,

    Callback = function(state)

        scriptState.autoCollectActive = state

        if scriptState.autoCollectActive then

            scriptState.autoCollectLoop = task.spawn(function()

                while scriptState.autoCollectActive do

                    local char = LocalPlayer.Character

                    local root = char and char:FindFirstChild('HumanoidRootPart')



                    if root then

                        for _, prompt in ipairs(Workspace:GetDescendants()) do

                            if prompt:IsA('ProximityPrompt') and prompt.Enabled then

                                local parent = prompt.Parent

                                if parent and parent:IsA('BasePart') then

                                    local distance = (root.Position - parent.Position).Magnitude

                                    if distance <= (prompt.MaxActivationDistance or 15) then

                                        fireRemoteEvent('\20&\0\1239c01c8f2-d1af-4df5-b2a8-9ae62662b7fa\125', true)

                                        prompt:InputHoldBegin()

                                        task.wait(1)

                                        prompt:InputHoldEnd()

                                    end

                                end

                            end

                        end

                    end

                    task.wait(0.5)

                end

            end)

        else

            if scriptState.autoCollectLoop then

                pcall(function()

                    task.cancel(scriptState.autoCollectLoop)

                end)

                scriptState.autoCollectLoop = nil

            end

        end

    end,

})



-- =====================

-- COMBAT PAGE

-- =====================



CombatPage:Section('Protector Evasion')



local avoidProtectorsToggle

avoidProtectorsToggle = CombatPage:Toggle({

    Title = 'Avoid Protectors',

    Desc = 'Enable noclip to avoid protectors',

    Value = false,

    Callback = function(state)

        scriptState.avoidActive = state

        if scriptState.avoidActive then

            local char = LocalPlayer.Character

            local root = char and char:FindFirstChild('HumanoidRootPart')



            if root then

                root.CFrame = root.CFrame - Vector3.new(0, 6, 0)

            end



            LocalPlayer.CameraMinZoomDistance = 0

            LocalPlayer.CameraMaxZoomDistance = 128

            scriptState.noclipConn = RunService.Stepped:Connect(function()

                local c = LocalPlayer.Character

                if not c then return end

                for _, part in ipairs(c:GetDescendants()) do

                    if part:IsA('BasePart') then

                        part.CanCollide = false

                    end

                end

            end)

        else

            if scriptState.noclipConn then

                scriptState.noclipConn:Disconnect()

                scriptState.noclipConn = nil

            end

            local char = LocalPlayer.Character

            if char then

                for _, part in ipairs(char:GetDescendants()) do

                    if part:IsA('BasePart') then

                        part.CanCollide = true

                    end

                end

            end

            LocalPlayer.CameraMinZoomDistance = 0.5

            LocalPlayer.CameraMaxZoomDistance = 128

        end

    end,

})



-- =====================

-- SPEED PAGE

-- =====================



SpeedPage:Section('Speed Upgrade X1')



local speedX1Button

speedX1Button = SpeedPage:Button({

    Title = 'Speed Upgrade X1',

    Desc = 'Activate Speed Upgrade X1',

    Text = 'OFF',

    Callback = function()

        scriptState.speedX1Active = not scriptState.speedX1Active

        if scriptState.speedX1Active then

            if scriptState.speedX1Loop then pcall(function() scriptState.speedX1Loop:Close() end) end

            scriptState.speedX1Loop = task.spawn(function()

                while scriptState.speedX1Active do

                    fireRemoteEvent('\18\1', true)

                    task.wait(0.5)

                end

            end)

        else

            if scriptState.speedX1Loop then pcall(function() scriptState.speedX1Loop:Close() end) scriptState.speedX1Loop = nil end

        end

    end,

})



SpeedPage:Section('Speed Upgrade X5')



local speedX5Button

speedX5Button = SpeedPage:Button({

    Title = 'Speed Upgrade X5',

    Desc = 'Activate Speed Upgrade X5',

    Text = 'OFF',

    Callback = function()

        scriptState.speedX5Active = not scriptState.speedX5Active

        if scriptState.speedX5Active then

            if scriptState.speedX5Loop then pcall(function() scriptState.speedX5Loop:Close() end) end

            scriptState.speedX5Loop = task.spawn(function()

                while scriptState.speedX5Active do

                    fireRemoteEvent('\18\5', true)

                    task.wait(0.5)

                end

            end)

        else

            if scriptState.speedX5Loop then pcall(function() scriptState.speedX5Loop:Close() end) scriptState.speedX5Loop = nil end

        end

    end,

})



SpeedPage:Section('Speed Upgrade X10')



local speedX10Button

speedX10Button = SpeedPage:Button({

    Title = 'Speed Upgrade X10',

    Desc = 'Activate Speed Upgrade X10',

    Text = 'OFF',

    Callback = function()

        scriptState.speedX10Active = not scriptState.speedX10Active

        if scriptState.speedX10Active then

            if scriptState.speedX10Loop then pcall(function() scriptState.speedX10Loop:Close() end) end

            scriptState.speedX10Loop = task.spawn(function()

                while scriptState.speedX10Active do

                    fireRemoteEvent('\18\n', true)

                    task.wait(0.5)

                end

            end)

        else

            if scriptState.speedX10Loop then pcall(function() scriptState.speedX10Loop:Close() end) scriptState.speedX10Loop = nil end

        end

    end,

})



SpeedPage:Section('Auto Upgrade All Speed')



local autoUpgradeAllSpeedButton

autoUpgradeAllSpeedButton = SpeedPage:Button({

    Title = 'Auto Upgrade All Speed',

    Desc = 'Automatically upgrade all speed levels',

    Text = 'OFF',

    Callback = function()

        scriptState.autoUpgradeAllSpeedActive = not scriptState.autoUpgradeAllSpeedActive

        if scriptState.autoUpgradeAllSpeedActive then

            if scriptState.autoUpgradeAllSpeedLoop then pcall(function() scriptState.autoUpgradeAllSpeedLoop:Close() end) end

            scriptState.autoUpgradeAllSpeedLoop = task.spawn(function()

                while scriptState.autoUpgradeAllSpeedActive do

                    pcall(function()

                        fireRemoteEvent('\18\1', true)

                        task.wait(0.2)

                        fireRemoteEvent('\18\5', true)

                        task.wait(0.2)

                        fireRemoteEvent('\18\n', true)

                        task.wait(0.4)

                    end)

                end

            end)

        else

            if scriptState.autoUpgradeAllSpeedLoop then pcall(function() scriptState.autoUpgradeAllSpeedLoop:Close() end) scriptState.autoUpgradeAllSpeedLoop = nil end

        end

    end,

})



-- =====================

-- REBIRTH PAGE

-- =====================



RebirthPage:Section('Auto Rebirth')



local rebirthX1Button

rebirthX1Button = RebirthPage:Button({

    Title = 'Auto Rebirth X1',

    Desc = 'Automatically perform Rebirth X1',

    Text = 'OFF',

    Callback = function()

        scriptState.rebirthX1Active = not scriptState.rebirthX1Active

        if scriptState.rebirthX1Active then

            if scriptState.rebirthX1Loop then pcall(function() scriptState.rebirthX1Loop:Close() end) end

            scriptState.rebirthX1Loop = task.spawn(function()

                while scriptState.rebirthX1Active do

                    fireRemoteEvent('\16', true)

                    task.wait(2)

                end

            end)

        else

            if scriptState.rebirthX1Loop then pcall(function() scriptState.rebirthX1Loop:Close() end) scriptState.rebirthX1Loop = nil end

        end

    end,

})



RebirthPage:Section('Manual Rebirth')

RebirthPage:Button({

    Title = 'Manual Rebirth X1',

    Desc = 'Perform a single Rebirth X1',

    Text = 'GO',

    Callback = function()

        fireRemoteEvent('\16', true)

    end,

})



-- =====================

-- FLY PAGE

-- =====================



FlyPage:Section('Fly Boost')

FlyPage:Button({

    Title = 'Fly Boost',

    Desc = 'Load Universal Script Fly v3',

    Text = 'LOAD',

    Callback = function()

        pcall(function()

            loadstring(game:HttpGet('https://rawscripts.net/raw/Universal-Script-Fly-v3-102059'))()

        end)

    end,

})



-- =====================

-- EXTRA TOOLS PAGE

-- =====================



ExtraToolsPage:Section('Server Jump')

ExtraToolsPage:Button({

    Title = 'Jump to Another Server',

    Desc = 'Teleport to a smaller server',

    Text = 'GO',

    Callback = function()

        teleportToSmallServer()

    end,

})



ExtraToolsPage:Section('Noclip')



local noclipToggle

noclipToggle = ExtraToolsPage:Toggle({

    Title = 'Noclip',

    Desc = 'Toggle noclip functionality',

    Value = false,

    Callback = function(state)

        scriptState.noclipActive = state

        if scriptState.noclipActive then

            scriptState.noclipConn2 = RunService.Stepped:Connect(function()

                local c = LocalPlayer.Character

                if not c then return end

                for _, part in ipairs(c:GetDescendants()) do

                    if part:IsA('BasePart') then

                        part.CanCollide = false

                    end

                end

            end)

        else

            if scriptState.noclipConn2 then scriptState.noclipConn2:Disconnect() scriptState.noclipConn2 = nil end

            local char = LocalPlayer.Character

            if char then

                for _, part in ipairs(char:GetDescendants()) do

                    if part:IsA('BasePart') then part.CanCollide = true end

                end

            end

        end

    end,

})



ExtraToolsPage:Section('SilentSpy')

ExtraToolsPage:Button({

    Title = 'SilentSpy Loader',

    Desc = 'Load the SilentSpy script',

    Text = 'LOAD',

    Callback = function()

        pcall(function()

            loadstring(game:HttpGet('https://rawscripts.net/raw/Universal-Script-25Bullets-SilentSpy-73291'))()

        end)

    end,

})



-- =====================

-- SETTINGS PAGE

-- =====================



SettingsPage:Section('Script Information')

SettingsPage:Paragraph({ Title = 'Developer', Desc = 'Francy2468' })

SettingsPage:Paragraph({ Title = 'Version', Desc = '6.0 Professional Final' })

SettingsPage:Paragraph({ Title = 'Last Updated', Desc = '2026-03-15' })



SettingsPage:Section('Community')

SettingsPage:Paragraph({ Title = 'Join our Discord', Desc = 'Join our Discord for support and updates' })

SettingsPage:Paragraph({ Title = 'Discord Link', Desc = 'https://discord.gg/cq9GkRKX2V' })



-- =====================

-- CLEANUP & MONITORING

-- =====================



LocalPlayer.CharacterAdded:Connect(function(newChar)

    Character = newChar

    HumanoidRootPart = Character:WaitForChild('HumanoidRootPart')

    if scriptState.avoidActive then

        scriptState.avoidActive = false

        if scriptState.noclipConn then scriptState.noclipConn:Disconnect() scriptState.noclipConn = nil end

    end

    if scriptState.noclipActive then

        scriptState.noclipActive = false

        if scriptState.noclipConn2 then scriptState.noclipConn2:Disconnect() scriptState.noclipConn2 = nil end

    end

end)



print("hi!")
