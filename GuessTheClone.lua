-- Load the Vita UI library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/JScripter-Lua/XovaModedLib/refs/heads/main/VitaLib_Enhanced.lua"))()

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- SETTINGS
local SETTINGS = {
    PlayerColor = Color3.fromRGB(255,165,0),
    NPCColor = Color3.fromRGB(0,0,0),
    TextSize = 16,
    ESPEnabled = false,
    ESPNotified = false,

    WalkSpeed = 16,
    JumpPower = 50,
    InfJump = false,

    OriginalPos = nil
}

-- UI
local Window = Library:Window({
    Title = "Guess The Clone | Vita UI",
    SubTitle = "Made by Francy - Migrated to Vita UI",
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

-- --- PÃGINAS CON COLORES PERSONALIZADOS ---
local MainPage = Window:NewPage({
    Title = "Main",
    Desc = "ESP Features",
    Icon = "eye", -- Lucide icon for ESP
    TabImage = "#FF4500" -- Orange Red for Main Page (ESP)
})

local PlayerPage = Window:NewPage({
    Title = "Player",
    Desc = "Movement and Safe Spot",
    Icon = "user", -- Lucide icon for Player
    TabImage = "#00BFFF" -- Deep Sky Blue for Player Page
})

local SettingsPage = Window:NewPage({
    Title = "Settings",
    Desc = "Configuration Options",
    Icon = "settings", -- Lucide icon for settings
    TabImage = "#A9A9A9" -- Dark Gray for Settings Page
})

-- =====================
-- ESP ORIGINAL
-- =====================

local function createESP(model, color)
    if not model or model:FindFirstChild("UltimateESP") then return end

    local root = model:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "UltimateESP"
    highlight.FillColor = color
    highlight.FillTransparency = 0.4
    highlight.OutlineColor = Color3.new(1,1,1)
    highlight.Parent = model

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0,200,0,50)
    billboard.AlwaysOnTop = true
    billboard.Adornee = model:FindFirstChild("Head") or root
    billboard.Parent = model

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.TextColor3 = color
    label.TextStrokeTransparency = 0
    label.TextSize = SETTINGS.TextSize
    label.Font = Enum.Font.RobotoMono
    label.Parent = billboard

    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not SETTINGS.ESPEnabled or not model.Parent then
            highlight:Destroy()
            billboard:Destroy()
            connection:Disconnect()
            return
        end

        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if myRoot then
            local dist = (myRoot.Position - root.Position).Magnitude
            label.Text = model.Name.."\n["..math.floor(dist).."m]"
        end
    end)
end

local function setupESP(obj)
    local hum = obj:FindFirstChildOfClass("Humanoid")
    if hum then
        local plr = Players:GetPlayerFromCharacter(obj)
        if plr then
            if plr ~= LocalPlayer then
                createESP(obj, SETTINGS.PlayerColor)
            end
        else
            createESP(obj, SETTINGS.NPCColor)
        end
    end
end

MainPage:Section("ESP")

MainPage:Toggle({
    Title = "Enable ESP",
    Desc = "Highlight players and NPCs",
    Value = false,
    Callback = function(v)
        SETTINGS.ESPEnabled = v

        if v then
            if not SETTINGS.ESPNotified then
                MainPage:Paragraph({
                    Title = "ESP Info",
                    Desc = "Orange = Players | Dark = NPCs"
                })
                SETTINGS.ESPNotified = true
            end

            for _,obj in ipairs(workspace:GetDescendants()) do
                task.spawn(setupESP, obj)
            end
        end
    end
})

workspace.DescendantAdded:Connect(function(obj)
    if SETTINGS.ESPEnabled then
        task.delay(0.1, setupESP, obj)
    end
end)

-- =====================
-- MOVEMENT
-- =====================

PlayerPage:Section("Movement")

PlayerPage:Slider({
    Title="Walk Speed",
    Desc="Adjust your character's walking speed",
    Min=16,
    Max=300,
    Rounding=1,
    Value=16,
    Callback=function(v) SETTINGS.WalkSpeed=v end
})

PlayerPage:Slider({
    Title="Jump Power",
    Desc="Adjust your character's jumping power",
    Min=50,
    Max=500,
    Rounding=1,
    Value=50,
    Callback=function(v) SETTINGS.JumpPower=v end
})

PlayerPage:Toggle({
    Title="Infinite Jump",
    Desc="Enable continuous jumping",
    Value=false,
    Callback=function(v) SETTINGS.InfJump=v end
})

UserInputService.JumpRequest:Connect(function()
    if SETTINGS.InfJump then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState("Jumping") end
    end
end)

-- =====================
-- SAFE SPOT PRO (TEXTO PERFECTO)
-- =====================

local cubeFolder = nil

local function createWall(size, cf, parent, text)
    local p = Instance.new("Part")
    p.Size = size
    p.CFrame = cf
    p.Anchored = true
    p.CanCollide = true
    p.Color = Color3.new(0,0,0)
    p.Material = Enum.Material.SmoothPlastic
    p.Parent = parent

    if text then
        local gui = Instance.new("SurfaceGui")
        gui.Parent = p
        gui.Face = Enum.NormalId.Front
        gui.CanvasSize = Vector2.new(1000,1000)

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1,0,1,0)
        frame.BackgroundTransparency = 1
        frame.Parent = gui

        local layout = Instance.new("UIListLayout")
        layout.Parent = frame
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.VerticalAlignment = Enum.VerticalAlignment.Center
        layout.Padding = UDim.new(0,20)

        -- CATMIO
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(0.8,0,0.35,0)
        title.BackgroundTransparency = 1
        title.Text = "Catmio"
        title.TextColor3 = Color3.fromRGB(255,165,0)
        title.TextScaled = true
        title.Font = Enum.Font.GothamBold
        title.TextStrokeTransparency = 0
        title.Parent = frame

        -- DISCORD
        local discord = Instance.new("TextLabel")
        discord.Size = UDim2.new(0.9,0,0.2,0)
        discord.BackgroundTransparency = 1
        discord.Text = "discord.gg/cq9GkRKX2V"
        discord.TextColor3 = Color3.fromRGB(255,255,255)
        discord.TextScaled = true
        discord.Font = Enum.Font.GothamMedium
        discord.TextStrokeTransparency = 0.3
        discord.Parent = frame
    end
end

local function enableCube()
    local char = LocalPlayer.Character
    if not char then return end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    SETTINGS.OriginalPos = root.CFrame

    local center = root.CFrame + Vector3.new(0,1000,0)
    root.CFrame = center

    cubeFolder = Instance.new("Folder", workspace)
    cubeFolder.Name = "SafeSpotCube"

    local s = 20
    local t = 2

    createWall(Vector3.new(s+t,t,s+t), center*CFrame.new(0,-s/2-t/2,0), cubeFolder)
    createWall(Vector3.new(s+t,t,s+t), center*CFrame.new(0,s/2+t/2,0), cubeFolder)

    createWall(Vector3.new(s+t,s+t,t), center*CFrame.new(0,0,s/2+t/2), cubeFolder,true)
    createWall(Vector3.new(s+t,s+t,t), center*CFrame.new(0,0,-s/2-t/2), cubeFolder,true)
    createWall(Vector3.new(t,s+t,s+t), center*CFrame.new(-s/2-t/2,0,0), cubeFolder,true)
    createWall(Vector3.new(t,s+t,s+t), center*CFrame.new(s/2+t/2,0,0), cubeFolder,true)
end

local function disableCube()
    local char = LocalPlayer.Character
    if char and SETTINGS.OriginalPos then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then root.CFrame = SETTINGS.OriginalPos end
    end

    SETTINGS.OriginalPos = nil

    if cubeFolder then
        cubeFolder:Destroy()
        cubeFolder = nil
    end
end

PlayerPage:Section("Safe Spot")

PlayerPage:Toggle({
    Title="TP Safe Spot",
    Desc="Teleport to a safe, enclosed area",
    Value=false,
    Callback=function(v)
        if v then enableCube() else disableCube() end
    end
})

-- =====================
-- LOOP
-- =====================

RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = SETTINGS.WalkSpeed
            hum.JumpPower = SETTINGS.JumpPower
        end
    end
end)

-- =====================
-- SETTINGS PAGE
-- =====================

SettingsPage:Section("Script Information")
SettingsPage:Paragraph({
    Title = "Game",
    Desc = "Guess The Clone"
})
SettingsPage:Paragraph({
    Title = "Developer",
    Desc = "Francy | Catmio"
})
SettingsPage:Paragraph({
    Title = "Version",
    Desc = "idk again prob v1"
})
SettingsPage:Paragraph({
    Title = "Discord",
    Desc = "discord.gg/cq9GkRKX2V"
})

-- Finalize
Window:SelectPage(MainPage)

print("Press", Window.ToggleKey or "RightControl", "to toggle UI")
