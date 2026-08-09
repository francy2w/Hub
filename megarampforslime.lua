local CoreGui           = game:GetService("CoreGui")
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Limpiar ejecuciones anteriores
for _, name in ipairs({ "ToraScript", "Velvet", "DirtLib", "Material", "SlimeHub", "Rayfield" }) do
    local old = CoreGui:FindFirstChild(name)
    if old then old:Destroy() end
end

-- ============================================================
--  Cargar Rayfield
-- ============================================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ============================================================
--  Crear ventana
-- ============================================================
local Window = Rayfield:CreateWindow({
    Name              = "MEGA RAMP FOR SLIME",
    LoadingTitle      = "MEGA RAMP FOR SLIME",
    LoadingSubtitle   = "by Francyii",
    ShowText          = "Slime",
    Theme             = "Default",
    ToggleUIKeybind   = Enum.KeyCode.RightShift,

    DisableRayfieldPrompts = false,
    DisableBuildWarnings   = false,

    ConfigurationSaving = {
        Enabled   = false,
        FolderName = nil,
        FileName   = "MegaRampForSlime",
    },
    Discord = {
        Enabled  = false,
        Invite   = "noinvitelink",
        RememberJoins = true,
    },
    KeySystem = false,
})

-- ============================================================
--  Pestaña principal
-- ============================================================
local Tab     = Window:CreateTab("Main", "rocket")
local Section = Tab:CreateSection("Main")

-- ============================================================
--  Funciones del juego
-- ============================================================
LastZone = function()
    spawn(function()
        _G.LastZone = true
        while _G.LastZone do
            task.wait()
            pcall(function()
                local player = Players.LocalPlayer
                local char   = player.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end

                hrp.CFrame = workspace.Progetto.CarSpawn.CFrame
                task.wait(1)

                local carModel
                for _, child in ipairs(workspace:GetChildren()) do
                    if string.find(child.Name, player.Name .. "_Auto") then
                        carModel = child
                        break
                    end
                end

                if carModel then
                    carModel:SetPrimaryPartCFrame(workspace.Progetto.JumpCar.CFrame)
                    task.wait(0.2)
                    carModel:SetPrimaryPartCFrame(workspace.Progetto.Checkpoints["92"].CFrame)
                    task.wait(0.2)
                    carModel:SetPrimaryPartCFrame(CFrame.new(-21, 3, 2101))
                    task.wait(1)

                    local openBoxRemote = ReplicatedStorage.Remotes.OpenBoxClick
                    for _ = 1, 10 do
                        openBoxRemote:FireServer()
                    end
                    task.wait()
                end
            end)
        end
    end)
end

Equip = function()
    spawn(function()
        _G.Equip = true
        while _G.Equip do
            task.wait()
            pcall(function()
                local remote = ReplicatedStorage.Remotes.EquipBestInventory
                remote:FireServer()
                task.wait(2)
            end)
        end
    end)
end

-- ============================================================
--  Toggles
-- ============================================================
Tab:CreateToggle({
    Name         = "Instant LastZone",
    CurrentValue = false,
    Flag         = "LastZone",
    Callback = function(state)
        _G.LastZone = state
        Rayfield:Notify({
            Title   = "LastZone",
            Content = state and "On" or "Off",
            Duration = 3,
        })
        if state then LastZone() end
    end,
})

Tab:CreateToggle({
    Name         = "Equip Best",
    CurrentValue = false,
    Flag         = "Equip",
    Callback = function(state)
        _G.Equip = state
        Rayfield:Notify({
            Title   = "Equip Best",
            Content = state and "On" or "Off",
            Duration = 3,
        })
        if state then Equip() end
    end,
})

-- ============================================================
--  Botón para copiar canal de YouTube
-- ============================================================
Tab:CreateButton({
    Name = "▶  YouTube: Francyii",
    Callback = function()
        if setclipboard then
            setclipboard("https://youtube.com/@Francyii")
            Rayfield:Notify({
                Title   = "Copied",
                Content = "thanks",
                Duration = 3,
            })
        else
            Rayfield:Notify({
                Title   = "YouTube",
                Content = "@Francyii",
                Duration = 4,
            })
        end
    end,
})
