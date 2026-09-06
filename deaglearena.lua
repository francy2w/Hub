-- [[ Rscripts Risk Notice ]]
-- This script is not verified by rscripts.net. Deal with caution.

-- Stay safe:
--   • Never log in on unofficial Roblox sites or lookalike domains.
--   • Real Roblox links use roblox.com (check the .com ending).
--   • Treat fake Roblox login / "claim reward" pages as phishing.
-- [[ End Rscripts Risk Notice ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

_G.KillAllSettings = {
    FireRateDelay = 0.04,
    TargetPart = "Head",
    PanicHealthThreshold = 40
}

-- Flag de activación (true = encendido, false = apagado)
_G.KillAllEnabled = true

local CurrentShotTargets = {}
local DeagleController = nil

-- Creación de la interfaz flotante y arrastrable
local function CreateToggleUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "KillAllToggleGUI"
    
    local successGui = pcall(function()
        ScreenGui.Parent = game:GetService("CoreGui")
    end)
    if not successGui then
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 130, 0, 42)
    ToggleButton.Position = UDim2.new(0, 20, 0, 20)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.TextSize = 14
    ToggleButton.AutoButtonColor = false
    ToggleButton.Active = true
    ToggleButton.Parent = ScreenGui

    -- Esquinas redondeadas
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = ToggleButton

    -- Borde dinámico
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Thickness = 2
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = ToggleButton

    -- Actualización de colores e indicadores
    local function updateVisuals()
        if _G.KillAllEnabled then
            ToggleButton.Text = "KillAll: ON"
            ToggleButton.TextColor3 = Color3.fromRGB(46, 204, 113)
            UIStroke.Color = Color3.fromRGB(46, 204, 113)
        else
            ToggleButton.Text = "KillAll: OFF"
            ToggleButton.TextColor3 = Color3.fromRGB(231, 76, 60)
            UIStroke.Color = Color3.fromRGB(231, 76, 60)
        end
    end

    updateVisuals()

    -- Lógica de arrastre (compatible con Mouse y Touch)
    local dragging = false
    local dragStart = nil
    local startPos = nil
    local movedEnough = false

    ToggleButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = ToggleButton.Position
            movedEnough = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if delta.Magnitude > 6 then
                movedEnough = true
            end
            ToggleButton.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    ToggleButton.MouseButton1Click:Connect(function()
        if not movedEnough then
            _G.KillAllEnabled = not _G.KillAllEnabled
            updateVisuals()
            if not _G.KillAllEnabled then
                table.clear(CurrentShotTargets)
            end
        end
        movedEnough = false
    end)
end

pcall(CreateToggleUI)

pcall(function()
    local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")
    DeagleController = require(PlayerScripts:WaitForChild("ModuleLoader"):WaitForChild("DeagleController"))
end)

local function IsAliveAndValid(model)
    if not model or not model:IsA("Model") or model == LocalPlayer.Character then return false end
    local hum = model:FindFirstChildWhichIsA("Humanoid")
    if not hum or hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then return false end

    local rootPart = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso") or model:FindFirstChild("UpperTorso")
    if not rootPart then return false end

    if model:FindFirstChild("Dead") or model:GetAttribute("IsDead") == true then return false end
    return true
end

local function GetAllPotentialTargets()
    local targets = {}

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and IsAliveAndValid(player.Character) then
            if player.Team and player.Team == LocalPlayer.Team then continue end
            table.insert(targets, player.Character)
        end
    end

    local queue = {workspace}
    while #queue > 0 do
        local current = table.remove(queue, 1)
        for _, child in ipairs(current:GetChildren()) do
            if child:IsA("Model") and IsAliveAndValid(child) then
                if not table.find(targets, child) then
                    local p = Players:GetPlayerFromCharacter(child)
                    if not p then
                        table.insert(targets, child)
                    end
                end
            elseif child:IsA("Folder") or child.Name:lower():find("bot") or child.Name:lower():find("npc") then
                table.insert(queue, child)
            end
        end
    end

    return targets
end

local function IsTargetVisible(targetPart, myRootPart)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, targetPart.Parent}
    raycastParams.IgnoreWater = true

    local origin = myRootPart.Position
    local direction = targetPart.Position - origin

    local result = workspace:Raycast(origin, direction, raycastParams)
    return result == nil
end

local function GetPredictedPosition(targetPart)
    local character = targetPart.Parent
    local rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")

    if rootPart and rootPart:IsA("BasePart") then
        local velocity = rootPart.AssemblyLinearVelocity
        local ping = LocalPlayer:GetNetworkPing() or 0.03
        
        local predictionCompensation = velocity * (ping * 1.85)
        return targetPart.Position + predictionCompensation
    end

    return targetPart.Position
end

local function ExecuteAutomatedSweep()
    local myChar = LocalPlayer.Character
    local myRoot = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso"))
    local myHum = myChar and myChar:FindFirstChildWhichIsA("Humanoid")
    if not myChar or not myRoot or not myHum or not DeagleController then return end

    local isVulnerable = (myHum.Health / myHum.MaxHealth * 100) <= _G.KillAllSettings.PanicHealthThreshold

    if typeof(DeagleController) == "table" then
        DeagleController.ShootCooldownUntil = 0
        DeagleController.CanShoot = true
        DeagleController.CurrentSpread = 0
        if DeagleController.WeaponStats then
            DeagleController.WeaponStats.Spread = 0
        end
    end

    table.clear(CurrentShotTargets)
    local activePool = GetAllPotentialTargets()

    table.sort(activePool, function(a, b)
        local rootA = a:FindFirstChild("HumanoidRootPart") or a:FindFirstChild("Torso")
        local rootB = b:FindFirstChild("HumanoidRootPart") or b:FindFirstChild("Torso")
        if rootA and rootB then
            return (myRoot.Position - rootA.Position).Magnitude < (myRoot.Position - rootB.Position).Magnitude
        end
        return false
    end)

    if isVulnerable then
        local targetFound = false
        for _, child in ipairs(activePool) do
            local targetPart = child:FindFirstChild(_G.KillAllSettings.TargetPart) or child:FindFirstChild("Head")
            if targetPart and IsTargetVisible(targetPart, myRoot) then
                CurrentShotTargets[targetPart] = true
                local aimPosition = GetPredictedPosition(targetPart)
                pcall(function()
                    if typeof(DeagleController.Shoot) == "function" then
                        DeagleController.Shoot(aimPosition)
                    elseif typeof(DeagleController.Fire) == "function" then
                        DeagleController.Fire(aimPosition)
                    end
                end)
                targetFound = true
                break
            end
        end
        
        if not targetFound then
            for _, child in ipairs(activePool) do
                local targetPart = child:FindFirstChild(_G.KillAllSettings.TargetPart) or child:FindFirstChild("Head")
                if targetPart then
                    CurrentShotTargets[targetPart] = true
                    local aimPosition = GetPredictedPosition(targetPart)
                    pcall(function()
                        if typeof(DeagleController.Shoot) == "function" then
                            DeagleController.Shoot(aimPosition)
                        elseif typeof(DeagleController.Fire) == "function" then
                            DeagleController.Fire(aimPosition)
                        end
                    end)
                    break
                end
            end
        end
    else
        for _, child in ipairs(activePool) do
            local targetPart = child:FindFirstChild(_G.KillAllSettings.TargetPart) or child:FindFirstChild("Head")
            if targetPart then
                CurrentShotTargets[targetPart] = true
                local aimPosition = GetPredictedPosition(targetPart)
                pcall(function()
                    if typeof(DeagleController.Shoot) == "function" then
                        DeagleController.Shoot(aimPosition)
                    elseif typeof(DeagleController.Fire) == "function" then
                        DeagleController.Fire(aimPosition)
                    end
                end)
            end
        end
    end
end

local success, DeagleShared = pcall(function()
    return require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("DeagleShared"))
end)

if success and DeagleShared and DeagleShared.Raycast then
    local oldRaycast = DeagleShared.Raycast
    DeagleShared.Raycast = function(p1, p2, p3, ...)
        if _G.KillAllEnabled then
            for targetPart, _ in pairs(CurrentShotTargets) do
                if targetPart and targetPart.Parent and IsAliveAndValid(targetPart.Parent) then
                    return {
                        Instance = targetPart,
                        Position = GetPredictedPosition(targetPart),
                        Normal = Vector3.new(0, 1, 0),
                        Material = Enum.Material.Plastic
                    }
                end
            end
        end
        return oldRaycast(p1, p2, p3, ...)
    end
end

task.spawn(function()
    while true do
        task.wait(_G.KillAllSettings.FireRateDelay)
        if _G.KillAllEnabled then
            pcall(ExecuteAutomatedSweep)
        end
    end
end)
