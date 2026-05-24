local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/discoart/FluentPlus/refs/heads/main/Beta.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Slime RNG | Catmio",
    SubTitle = "by Catmio",
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
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- Fartez global variables initialization
_G.AutoRoll = false;
_G.AttackEnemies = false;
_G.AutoShootSlime = false;
_G.EquipBest = false;
_G.AutoLoot = false;
_G.AutoUnlockZone = false;
_G.AutoTpZone = false;
_G.AutoUpgrade = false;
_G.AutoRebirth = false;
_G.AutoRecipe = false;
_G.IsTeleporting = false;
_G.InfJump = false;
_G.SpeedBoost = false;
_G.SpeedValue = 50;
_G.JumpBoost = false;
_G.JumpPower = 100;
_G.NoClip = false;

-- Fartez helper functions and variables
local v0=game:GetService("Players");
local v1=game:GetService("TweenService");
local v2=game:GetService("RunService");
local v3=game:GetService("UserInputService");
local v4=game:GetService("VirtualUser");
local v5=game:GetService("VirtualInputManager");
local v6=game:GetService("ReplicatedStorage");
local v7=v0.LocalPlayer;
local v8=v7:WaitForChild("PlayerGui");
local v9=pcall(function() return gethui(); end) and gethui() or v8;

local v10;
local v11={};
local v12;

task.spawn(function()
    pcall(function()
        v12=require(v6:WaitForChild("Packages", 5):WaitForChild("DataService", 5)).client;
        v10=v6:WaitForChild("Packages", 5):WaitForChild("_Index", 5):WaitForChild("leifstout_networker@0.3.1", 5):WaitForChild("networker", 5):WaitForChild("_remotes", 5):WaitForChild("UpgradeService", 5):WaitForChild("RemoteFunction", 5);
        local v270=require(v6.Source.Features.Upgrades.UpgradeTree);
        for v290, v291 in pairs(v270) do
            for v310, v311 in pairs(v291) do
                if v311.id then
                    table.insert(v11, v311.id);
                end
            end
        end
    end);
end);

local function v14()
    local v136=1;
    pcall(function()
        if(v12 and(type(v12.get)=="function"))then
            local v312=v12:get("maxZone")or v12:get("furthestZone");
            if v312 then
                v136=tonumber(v312);
            end
        end
    end);
    return v136 or 1;
end

local v15=nil;
local v16=nil;

local function v17(v137, v138)
    local v139=v7.Character and v7.Character:FindFirstChild("HumanoidRootPart");
    if not v139 then
        return;
    end
    local v140=(v139.Position-v137.Position).Magnitude;
    if(v140<5)then
        if v15 then
            v15:Cancel();
            v15=nil;
        end
        v139.CFrame=v137;
        return;
    end
    if(v16 and((v16-v137.Position).Magnitude<5)and v15 and(v15.PlaybackState==Enum.PlaybackState.Playing))then
        return;
    end
    v16=v137.Position;
    local v142=v139:FindFirstChild("AntiGravity");
    if not v142 then
        v142=Instance.new("BodyVelocity");
        v142.Name="AntiGravity";
        v142.MaxForce=Vector3.new(0, 100000, 0);
        v142.Velocity=Vector3.zero;
        v142.Parent=v139;
    end
    v138=v138 or 200;
    local v143=TweenInfo.new(v140/v138, Enum.EasingStyle.Linear);
    if v15 then
        v15:Cancel();
    end
    v15=v1:Create(v139, v143,{CFrame=v137});
    v15.Completed:Connect(function()
        if v142 then
            v142:Destroy();
        end
        v15=nil;
    end);
    v15:Play();
end

local function v18()
    if v15 then
        v15:Cancel();
        v15=nil;
    end
    local v144=v7.Character and v7.Character:FindFirstChild("HumanoidRootPart");
    if v144 then
        local v298=v144:FindFirstChild("AntiGravity");
        if v298 then
            v298:Destroy();
        end
    end
end

local function v19(v145)
    local v146=0;
    pcall(function()
        local v271=workspace:FindFirstChild("Zones");
        if v271 then
            local v313=v271:FindFirstChild(tostring(v145))or v271:FindFirstChild("Zone" .. tostring(v145));
            if v313 then
                local v331=v313:FindFirstChild("POI")or v313:FindFirstChild("PlayerSpawn")or v313:FindFirstChild("Spawn");
                local v332=nil;
                if v331 then
                    if v331:IsA("BasePart")then
                        v332=v331;
                    else
                        v332=v331:FindFirstChildWhichIsA("BasePart", true);
                    end
                end
                if v332 then
                    local v352=v7.Character and v7.Character:FindFirstChild("HumanoidRootPart");
                    if v352 then
                        _G.IsTeleporting=true;
                        v18();
                        local v359=v332.CFrame+Vector3.new(0, 5, 0);
                        local v360=(v352.Position-v359.Position).Magnitude;
                        v146=v360/200;
                        v17(v359, 200);
                    end
                end
            end
        end
    end);
    return v146;
end

local function v128()
    local v260=v7.Character and v7.Character:FindFirstChild("HumanoidRootPart");
    if not v260 then
        return nil;
    end
    local v261=nil;
    local v262=300;
    pcall(function()
        for v302, v303 in ipairs(workspace:GetChildren())do
            local v304=nil;
            if(v303.Name=="Enemies")then
                v304=v303;
            elseif v303.Name:match("^Gameplay")then
                v304=v303:FindFirstChild("Enemies");
            end
            if v304 then
                for v333, v334 in ipairs(v304:GetChildren())do
                    if v334:IsA("Model")then
                        local v353=v334:FindFirstChild("HumanoidRootPart")or v334:FindFirstChildWhichIsA("BasePart");
                        local v354=v334:FindFirstChildOfClass("Humanoid");
                        if(v353 and(not v354 or(v354.Health>0)))then
                            local v361=(v353.Position-v260.Position).Magnitude;
                            if(v361<v262)then
                                v262=v361;
                                v261=v353;
                            end
                        end
                    end
                end
            end
        end
    end);
    return v261;
end

local v129={};
local v130=v6.Packages._Index["leifstout_networker@0.3.1"].networker._remotes.SlimeGunService.RemoteFunction;
local v131={};

local function v132()
    table.clear(v131);
    for v285, v286 in ipairs(workspace:GetChildren())do
        if(v286.Name=="Enemies")then
            table.insert(v131, v286);
        elseif v286.Name:match("^Gameplay")then
            local v342=v286:FindFirstChild("Enemies");
            if v342 then
                table.insert(v131, v342);
            end
        end
    end
end
v132();

local v133;
local v134;

local function v135()
    if(v133 and v133.Parent and v134 and v134.Parent)then
        local v306=v133:FindFirstChildOfClass("Humanoid");
        if(not v306 or(v306.Health>0))then
            return tonumber(v133.Name)or v133:GetAttribute("id")or v133:GetAttribute("Id")or v133.Name;
        end
    end
    local v264=v7.Character;
    if not v264 then
        return nil;
    end
    local v265=v264:FindFirstChild("HumanoidRootPart");
    if not v265 then
        return nil;
    end
    local v266;
    local v267;
    local v268=math.huge;
    for v287, v288 in ipairs(v131)do
        for v307, v308 in ipairs(v288:GetChildren())do
            local v309=v308:FindFirstChild("HumanoidRootPart")or v308.PrimaryPart;
            if v309 then
                local v328=v308:FindFirstChildOfClass("Humanoid");
                if(not v328 or(v328.Health>0))then
                    local v351=(v309.Position-v265.Position).Magnitude;
                    if(v351<v268)then
                        v268=v351;
                        v266=v308;
                        v267=v309;
                    end
                end
            end
        end
    end
    v133=v266;
    v134=v267;
    if v266 then
        return tonumber(v266.Name)or v266:GetAttribute("id")or v266:GetAttribute("Id")or v266.Name;
    end
end

do
    local MainSection = Tabs.Main:AddSection("Main Options")
    local SettingsSection = Tabs.Settings:AddSection("General Settings")

    -- Main Tab Controls
    MainSection:AddToggle("AutoRoll", {Title = "Auto Roll", Default = _G.AutoRoll }):OnChanged(function(Value) _G.AutoRoll = Value end)
    MainSection:AddToggle("AttackEnemies", {Title = "Attack Enemies", Default = _G.AttackEnemies }):OnChanged(function(Value) _G.AttackEnemies = Value end)
    MainSection:AddToggle("AutoShootSlime", {Title = "Auto Shoot Slime", Default = _G.AutoShootSlime }):OnChanged(function(Value) _G.AutoShootSlime = Value end)
    MainSection:AddToggle("EquipBest", {Title = "Equip Best", Default = _G.EquipBest }):OnChanged(function(Value) _G.EquipBest = Value end)
    MainSection:AddToggle("AutoLoot", {Title = "Auto Loot", Default = _G.AutoLoot }):OnChanged(function(Value) _G.AutoLoot = Value end)
    MainSection:AddToggle("AutoUnlockZone", {Title = "Auto Unlock Zone", Default = _G.AutoUnlockZone }):OnChanged(function(Value) _G.AutoUnlockZone = Value end)
    MainSection:AddToggle("AutoTpZone", {Title = "Auto TP Zone", Default = _G.AutoTpZone }):OnChanged(function(Value) _G.AutoTpZone = Value end)
    MainSection:AddToggle("AutoUpgrade", {Title = "Auto Buy Upgrades", Default = _G.AutoUpgrade }):OnChanged(function(Value) _G.AutoUpgrade = Value end)
    MainSection:AddToggle("AutoRebirth", {Title = "Auto Rebirth", Default = _G.AutoRebirth }):OnChanged(function(Value) _G.AutoRebirth = Value end)
    MainSection:AddToggle("AutoRecipe", {Title = "Auto Recipe", Default = _G.AutoRecipe }):OnChanged(function(Value) _G.AutoRecipe = Value end)

    -- Settings Tab Controls
    SettingsSection:AddButton({
        Title = "Boost FPS (Delete Decor)",
        Description = "Removes decorative elements to improve performance.",
        Callback = function()
            pcall(function()
                local v282=workspace:FindFirstChild("Zones");
                if v282 then
                    for v316, v317 in ipairs(v282:GetChildren())do
                        local v318=v317:FindFirstChild("decor")or v317:FindFirstChild("Decor");
                        if v318 then
                            v318:Destroy();
                        end
                    end
                end
            end);
        end
    })
    SettingsSection:AddToggle("InfJump", {Title = "Infinite Jump", Default = _G.InfJump }):OnChanged(function(Value) _G.InfJump = Value end)
    SettingsSection:AddToggle("SpeedBoost", {Title = "Speed Boost", Default = _G.SpeedBoost }):OnChanged(function(Value) _G.SpeedBoost = Value end)
    SettingsSection:AddSlider("SpeedValue", {
        Title = "Walk Speed",
        Default = _G.SpeedValue,
        Min = 16,
        Max = 200,
        Rounding = 1,
    }):OnChanged(function(Value) _G.SpeedValue = Value end)
    SettingsSection:AddToggle("JumpBoost", {Title = "Jump Boost", Default = _G.JumpBoost }):OnChanged(function(Value) _G.JumpBoost = Value end)
    SettingsSection:AddSlider("JumpPower", {
        Title = "Jump Power",
        Default = _G.JumpPower,
        Min = 50,
        Max = 500,
        Rounding = 1,
    }):OnChanged(function(Value) _G.JumpPower = Value end)
    SettingsSection:AddToggle("NoClip", {Title = "NoClip", Default = _G.NoClip }):OnChanged(function(Value) _G.NoClip = Value end)

    -- Fartez task.spawn loops
    task.spawn(function()
        while task.wait(0.1)do
            if _G.SpeedBoost and v7.Character and v7.Character:FindFirstChildOfClass("Humanoid") then
                v7.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = _G.SpeedValue;
            end
            if _G.JumpBoost and v7.Character and v7.Character:FindFirstChildOfClass("Humanoid") then
                v7.Character:FindFirstChildOfClass("Humanoid").UseJumpPower = true;
                v7.Character:FindFirstChildOfClass("Humanoid").JumpPower = _G.JumpPower;
            end
            if _G.NoClip and v7.Character then
                for _, part in ipairs(v7.Character:GetDescendants())do
                    if part:IsA("BasePart")then
                        part.CanCollide = false;
                    end
                end
            end
        end
    end);

    v3.JumpRequest:Connect(function()
        pcall(function()
            if(_G.InfJump and v7.Character)then
                local v314=v7.Character:FindFirstChildOfClass("Humanoid");
                if v314 then
                    v314:ChangeState(Enum.HumanoidStateType.Jumping);
                end
            end
        end);
    end);

    task.spawn(function()
        while task.wait(0.5)do
            if _G.AutoRoll then
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Packages", 2):WaitForChild("_Index", 2):WaitForChild("leifstout_networker@0.3.1", 2):WaitForChild("networker", 2):WaitForChild("_remotes", 2):WaitForChild("RollService", 2):WaitForChild("RemoteFunction", 2):InvokeServer("requestRoll");
                end);
            end
            if _G.EquipBest then
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Packages", 2):WaitForChild("_Index", 2):WaitForChild("leifstout_networker@0.3.1", 2):WaitForChild("networker", 2):WaitForChild("_remotes", 2):WaitForChild("InventoryService", 2):WaitForChild("RemoteFunction", 2):InvokeServer("requestEquipBest");
                end);
            end
        end
    end);

    task.spawn(function()
        while task.wait(3)do
            if _G.AutoRebirth then
                pcall(function()
                    game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("leifstout_networker@0.3.1").networker._remotes.RebirthService.RemoteFunction:InvokeServer("requestRebirth");
                end);
            end
        end
    end);

    task.spawn(function()
        while task.wait(1)do
            if(_G.AutoUpgrade and v10 and(#v11>0))then
                for v321, v322 in ipairs(v11)do
                    if not _G.AutoUpgrade then
                        break;
                    end
                    task.spawn(function()
                        pcall(function()
                            v10:InvokeServer("requestUnlock", v322);
                        end);
                    end)
                    if((v321%3)==0)then
                        task.wait();
                    end
                end
            end
        end
    end);

    task.spawn(function()
        while task.wait(1)do
            if(_G.AutoRecipe and not _G.IsTeleporting)then
                pcall(function()
                    local v323=v7.Character and v7.Character:FindFirstChild("HumanoidRootPart");
                    local v324=workspace:FindFirstChild("Zones");
                    if(v323 and v324)then
                        local v346=v14();
                        for v355=1, v346 do
                            if not v129[v355]then
                                local v362=v324:FindFirstChild(tostring(v355))or v324:FindFirstChild("Zone" .. tostring(v355));
                                if v362 then
                                    local v368=v362:FindFirstChild("Recipe");
                                    if v368 then
                                        local v373=(v368:IsA("BasePart")and v368)or v368:FindFirstChildWhichIsA("BasePart", true);
                                        if v373 then
                                            _G.IsTeleporting=true;
                                            v18();
                                            local v377=(v323.Position-v373.Position).Magnitude;
                                            v17(v373.CFrame, 200);
                                            task.wait((v377/200)+1.5);
                                            pcall(function()
                                                local v379=v368:GetAttribute("id")or v368:GetAttribute("RecipeId")or v368.Name;
                                                if(v379=="Recipe")then
                                                    v379="sweetie";
                                                end
                                                local v380={[1]="requestClaimRecipe",[2]=v379,[3]=v368};
                                                game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("leifstout_networker@0.3.1").networker._remotes.CraftingService.RemoteFunction:InvokeServer(unpack(v380));
                                                local v381=v368:FindFirstChildWhichIsA("ProximityPrompt", true);
                                                if v381 then
                                                    fireproximityprompt(v381);
                                                end
                                            end);
                                            v129[v355]=true;
                                            task.wait(1);
                                            _G.IsTeleporting=false;
                                        end
                                    end
                                end
                            end
                        end
                    end
                end);
            end
        end
    end);

    task.spawn(function()
        while task.wait(1)do
            if _G.AutoUnlockZone then
                pcall(function()
                    game:GetService("ReplicatedStorage").Packages._Index["leifstout_networker@0.3.1"].networker._remotes.ZonesService.RemoteFunction:InvokeServer("requestPurchaseZone");
                end);
            end
        end
    end);

    task.spawn(function()
        local v263=v14();
        while task.wait(1)do
            if _G.AutoTpZone then
                local v315=v14();
                if(v315>v263)then
                    v263=v315;
                    _G.IsTeleporting=true;
                    v18();
                    local v338=v19(v315);
                    if(v338 and(v338>0))then
                        task.wait(v338+1.5);
                    else
                        task.wait(2);
                    end
                    _G.IsTeleporting=false;
                end
            else
                v263=v14();
            end
        end
    end);

    task.spawn(function()
        while task.wait(0.1)do
            if _G.IsTeleporting then
                continue;
            end
            pcall(function()
                local v305=v7.Character and v7.Character:FindFirstChild("HumanoidRootPart");
                if v305 then
                    if _G.AttackEnemies then
                        local v347=v128();
                        if v347 then
                            v17(v347.CFrame*CFrame.new(0, 4, 3), 150);
                        end
                    end
                    if _G.AutoLoot then
                        local v348=workspace:FindFirstChild("Loot");
                        if v348 then
                            local v356=v348:GetChildren();
                            if(#v356>0)then
                                local v363=nil;
                                local v364=nil;
                                local v365=300;
                                for v369, v370 in ipairs(v356)do
                                    local v371=v370:FindFirstChild("HumanoidRootPart")or v370:FindFirstChildWhichIsA("BasePart");
                                    if v371 then
                                        local v374=(v371.Position-v305.Position).Magnitude;
                                        if(v374<v365)then
                                            v365=v374;
                                            v363=v370;
                                            v364=v371;
                                        end
                                    end
                                end
                                if(v363 and v364)then
                                    v17(v364.CFrame+Vector3.new(0, 2, 0), 150);
                                    pcall(function()
                                        local v375=v363:GetAttribute("id")or v363:GetAttribute("Id")or v363:GetAttribute("LootId")or v363.Name;
                                        local v376={[1]="requestCollect",[2]=v375};
                                        game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("leifstout_networker@0.3.1").networker._remotes.LootService.RemoteFunction:InvokeServer(unpack(v376));
                                    end);
                                end
                            end
                        end
                    end
                end
            end);
        end
    end);

    task.spawn(function()
        while task.wait(0.01)do
            if _G.AutoShootSlime then
                pcall(function()
                    local v325=v7.Character and v7.Character:FindFirstChild("HumanoidRootPart");
                    if not v325 then
                        return;
                    end
                    local v326=nil;
                    local v327=math.huge;
                    for v339, v340 in ipairs(workspace:GetChildren())do
                        local v341=nil;
                        if(v340.Name=="Enemies")then
                            v341=v340;
                        elseif v340.Name:match("^Gameplay")then
                            v341=v340:FindFirstChild("Enemies");
                        end
                        if v341 then
                            for v357, v358 in ipairs(v341:GetChildren())do
                                if v358:IsA("Model")then
                                    local v366=v358:FindFirstChild("HumanoidRootPart")or v358:FindFirstChildWhichIsA("BasePart");
                                    local v367=v358:FindFirstChildOfClass("Humanoid");
                                    if(v366 and(not v367 or(v367.Health>0)))then
                                        local v372=(v366.Position-v325.Position).Magnitude;
                                        if(v372<v327)then
                                            v327=v372;
                                            v326=tonumber(v358.Name)or v358:GetAttribute("id")or v358.Name;
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if v326 then
                        local v349={[1]="tryFireSlimeGun",[2]=v326};
                        local v350=game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("leifstout_networker@0.3.1", 2).networker._remotes.SlimeGunService.RemoteFunction;
                        v350:InvokeServer(unpack(v349));
                    end
                end);
            end
        end
    end);

    task.spawn(function()
        while true do
            if not _G.AutoShootSlime then
                task.wait(0.1);
                continue;
            end
            local v289=v135();
            if v289 then
                pcall(function()
                    v130:InvokeServer("tryFireSlimeGun", v289);
                    task.wait(0.015);
                    v130:InvokeServer("tryFireSlimeGun", v289);
                end);
            end
            v2.Heartbeat:Wait();
        end
    end);

    task.spawn(function()
        pcall(function()
            if getconnections then
                for v329, v330 in pairs(getconnections(v7.Idled))do
                    v330:Disable();
                end
            end
        end);
        while task.wait(600)do
            pcall(function()
                v4:CaptureController();
                v4:ClickButton2(Vector2.new());
            end);
        end
    end);

    v7.Idled:Connect(function()
        pcall(function()
            v4:CaptureController();
            v4:ClickButton2(Vector2.new());
            v5:SendKeyEvent(true, Enum.KeyCode.RightShift, false, game);
            task.wait(0.1);
            v5:SendKeyEvent(false, Enum.KeyCode.RightShift, false, game);
        end);
    end);
end

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Slime RNG | Catmio",
    Content = "The script has been loaded.",
    Duration = 8
})

SaveManager:LoadAutoloadConfig()


-- [[ TOGGLE BUTTON FLOTANTE INTEGRADO Y MODIFICADO ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CatmioToggleGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 9999
ScreenGui.Parent = v9 

local toggleBtn = Instance.new("ImageButton", ScreenGui)
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 15, 0, 150)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0) 
toggleBtn.Image = "rbxthumb://type=Asset&id=10670510726&w=150&h=150"
toggleBtn.Active = true

Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0.5, 0)
local btnStroke = Instance.new("UIStroke", toggleBtn)
btnStroke.Color = Color3.fromRGB(35, 35, 35) 
btnStroke.Thickness = 2.5

-- Lógica para arrastrar el botón (Draggable)
local dragging, dragInput, dragStart, startPos
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
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

toggleBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)

v3.InputChanged:Connect(function(input) 
    if input == dragInput and dragging then update(input) end
end)

-- Acción al clickear: Muestra u oculta la interfaz de Fluent
toggleBtn.MouseButton1Click:Connect(function()
    if Window.Root then
        Window.Root.Visible = not Window.Root.Visible
    end
end)
