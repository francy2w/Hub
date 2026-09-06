-- [[ CheixHub | Defeat Anime RNG (Rayfield UI) ]]
-- Original: Ouroboros Hub (ObsidianUltra / Linoria-based)
-- Converted to the Rayfield Interface Suite and renamed to CheixHub.
-- All game logic (auto-roll, auto-farm, auto-buy, evolve, prestige, etc.) is preserved.

------------------------------------------------------------
-- 1. Load Rayfield
------------------------------------------------------------
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

------------------------------------------------------------
-- 2. Services & shared state
------------------------------------------------------------
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace         = game:GetService("Workspace")
local LocalPlayer       = Players.LocalPlayer

local HubName  = "CheixHub"
local Unloaded = false

-- Element registry: holds references to all Rayfield elements by Flag name.
--   Toggle  -> Elements[flag].CurrentValue  (boolean)
--   Input   -> Elements[flag].CurrentValue  (string)
--   Dropdown-> Elements[flag].CurrentOption (table of strings)
local Elements = {}
local LiveLabels = {}

local gameName = "[UPD] Defeat Anime RNG"
pcall(function()
    local info = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
    if info and info.Name then gameName = info.Name end
end)

------------------------------------------------------------
-- 3. Window + tabs
------------------------------------------------------------
local Window = Rayfield:CreateWindow({
    Name              = HubName,
    Icon              = 0,
    LoadingTitle      = HubName,
    LoadingSubtitle   = "Defeat Anime RNG | Rayfield",
    Theme             = "Default",
    ToggleUIKeybind   = Enum.KeyCode.RightShift,
    DisableRayfieldPrompts = false,
    DisableBuildWarnings   = false,
    ConfigurationSaving = {
        Enabled   = true,
        FolderName = HubName,
        FileName  = "CheixHub_Config",
    },
    Discord = { Enabled = false },
    KeySystem = false,
})

local Tabs = {
    Main      = Window:CreateTab("Main", "layout-dashboard"),
    Farming   = Window:CreateTab("Farming", "sprout"),
    Inventory = Window:CreateTab("Inventory", "backpack"),
    Rebirth   = Window:CreateTab("Rebirth", "crown"),
    Settings  = Window:CreateTab("Settings", "settings"),
}

------------------------------------------------------------
-- 4. Remotes / Databases / data lists
------------------------------------------------------------
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents", 9e9)
local Databases    = ReplicatedStorage:WaitForChild("Databases", 9e9)

local function getRemote(name)
    local ok, r = pcall(function() return RemoteEvents:WaitForChild(name, 2) end)
    if ok and r then return r end
    return nil
end

local Remotes = {
    ConfirmedRoll      = getRemote("ConfirmedRollRequestEvent"),       CollectCash        = getRemote("CollectCashEvent"),
    ZonePurchase       = getRemote("ZonePurchaseRequestEvent"),        ZoneTravel         = getRemote("ZoneTravelRequestEvent"),
    Upgrade            = getRemote("UpgradeRequestEvent"),             PlayerAttack       = getRemote("PlayerAttackEvent"),
    BuyWeapon          = getRemote("BuyWeaponRequestFunction"),        EquipWeapon        = getRemote("EquipWeaponRequestFunction"),
    Fuse               = getRemote("FuseRequestFunction"),             EquipBest          = getRemote("EquipBestRequestFunction"),
    PickUpAll          = getRemote("PickUpAllRequestFunction"),
    GetItemInv         = getRemote("GetItemInventoryFunction"),        UsePotion          = getRemote("UsePotionRequestFunction"),
    UseAbility         = getRemote("UseAbilityRequestFunction"),       SetAutoUse         = getRemote("SetAutoUseRequestFunction"),
    SellUnits          = getRemote("SellUnitsRequestFunction"),        Evolve             = getRemote("EvolveRequestFunction"),
    ClaimEvolve        = getRemote("ClaimEvolveRequestFunction"),      ClaimDaily         = getRemote("ClaimDailyRewardFunction"),
    GetDailyStatus     = getRemote("GetDailyRewardStatusFunction"),    ClaimGroup         = getRemote("ClaimGroupRewardFunction"),
    InfiniteTowerEnter = getRemote("InfiniteTowerEnterRequestFunction"), ChallengeStart   = getRemote("ChallengeStartRequestEvent"),
    ClaimEventQuest    = getRemote("ClaimEventQuestRequestFunction"),  Prestige           = getRemote("PrestigeEvent"),
}

local UnitDatabase, WeaponsDatabase, UpgradeConfig, ZoneDatabase, InventoryConfig, XPConfig = nil, nil, nil, nil, nil, nil
pcall(function() UnitDatabase    = require(Databases:WaitForChild("UnitDatabase", 5)) end)
pcall(function() WeaponsDatabase = require(Databases:WaitForChild("WeaponsDatabase", 5)) end)
pcall(function() UpgradeConfig   = require(Databases:WaitForChild("UpgradeConfig", 5)) end)
pcall(function() ZoneDatabase    = require(Databases:WaitForChild("ZoneDatabase", 5)) end)
pcall(function() InventoryConfig = require(Databases:WaitForChild("InventoryConfig", 5)) end)
pcall(function() XPConfig        = require(Databases:WaitForChild("XPConfig", 5)) end)

local RarityList        = {"Common","Uncommon","Rare","Epic","Legendary","Mythic","Secret","Divine","Cosmic"}
local WeaponList        = {"Katana","Zangetsu","Soul Splitter","Guts","Buster","Scissor","Sanctity","Excalibur","Death Scythe","Sun Axe","Ghoul Scythe","Rhaast","Fan","Yoru","Dark Blue Sword","Blue Greatsword","Gae Bolg","Serrated Katana","Doujima","Executioner","Starked Axe","Shogun Blade"}
local WeaponBestFirst   = {"Shogun Blade","Starked Axe","Executioner","Doujima","Serrated Katana","Gae Bolg","Blue Greatsword","Dark Blue Sword","Yoru","Fan","Rhaast","Ghoul Scythe","Sun Axe","Death Scythe","Excalibur","Sanctity","Scissor","Buster","Guts","Soul Splitter","Zangetsu","Katana"}
local ZoneList          = {"Wisteria","Fire City","Planek","Hollowed World","Sand Island","Hage","Death Castle","Candy Island","Stadium","Curse College","Shibuya","Wall Kingdom","Dungeon","Wamo","Hidden City","Shrine","Red Gate"}
local PotionList        = {"Gold Potion","Luck Potion","XP Potion"}
local QuestIdsByTier    = {Regular={"RegularBosses","RegularChallenge","RegularBuyUnits"}, Daily={"DailyBosses","DailyChallenge","DailyKills","DailyWaves"}, Event={"EventPlaytime","EventKills","EventChallenges","EventWaves"}}
local QuestTierList     = {"Regular","Daily","Event"}
local ChallengeTierList = {"Regular","Daily","Weekly"}
local EvolveList        = {"Isagi","Jinwoo","Gojo","Goku","Asta","Luffy","Reze"}
local NEVER_AUTO_DESTROY= { Mythic = true, Secret = true, Divine = true, Cosmic = true, Limited = true, Exclusive = true }

------------------------------------------------------------
-- 5. Helper functions (declared BEFORE any UI callback uses them)
------------------------------------------------------------
local Loops = {}
local function startLoop(id, fn, interval)
    if Loops[id] and Loops[id].Running then return end
    Loops[id] = { Running = true }
    task.spawn(function()
        while Loops[id] and Loops[id].Running do
            if Unloaded then break end
            local ok, err = pcall(fn)
            if not ok then warn("[" .. HubName .. "] " .. id .. " err:", err) end
            task.wait(interval or 1)
        end
    end)
end
local function stopLoop(id) if Loops[id] then Loops[id].Running = false end end

local function notify(title, desc, time)
    pcall(function() Rayfield:Notify({ Title = title, Content = desc, Duration = time or 3 }) end)
end

local function getToggle(flag)   local el = Elements[flag]; return el and el.CurrentValue or false end
local function getInput(flag)    local el = Elements[flag]; return el and el.CurrentValue or "" end
local function getDropdown(flag) local el = Elements[flag]; return (el and el.CurrentOption) or {} end

local function money() return LocalPlayer:GetAttribute("Money") or 0 end

local function selectedSet(flag)
    local opts = getDropdown(flag)
    if type(opts) == "string" then return { [opts] = true } end
    local out = {}
    if type(opts) == "table" then
        for _, v in ipairs(opts) do out[v] = true end
    end
    return out
end

local function unitRarity(name)
    if UnitDatabase and UnitDatabase[name] and UnitDatabase[name].Rarity then return UnitDatabase[name].Rarity end
    return nil
end

local function getUnitTools()
    local tools = {}
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then for _, t in ipairs(bp:GetChildren()) do if t:GetAttribute("UnitId") ~= nil then table.insert(tools, t) end end end
    return tools
end

local function unitCount()
    local n = 0
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then for _, t in ipairs(bp:GetChildren()) do if t:GetAttribute("UnitId") ~= nil then n += 1 end end end
    return n
end

local function unitCap()
    local cap = 99
    if InventoryConfig and InventoryConfig.UnitCap then cap = InventoryConfig.UnitCap end
    return cap + (LocalPlayer:GetAttribute("ExtraUnitCapacity") or 0)
end

local function findToolByName(name)
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then for _, t in ipairs(bp:GetChildren()) do if t.Name == name and t:GetAttribute("UnitId") ~= nil then return t end end end
    return nil
end

local function getOwnBase()
    local ok, bases = pcall(function() return Workspace:WaitForChild("Bases", 3) end)
    if not ok or not bases then return nil end
    for _, b in ipairs(bases:GetChildren()) do
        local o = b:FindFirstChild("Owner")
        if o and tostring(o.Value) == tostring(LocalPlayer.UserId) then return b end
    end
    return nil
end

local function getOwnPlacedUnits()
    local units = {}
    local base = getOwnBase()
    if not base then return units end
    for _, d in ipairs(base:GetDescendants()) do
        if d:IsA("Model") and string.sub(d.Name, 1, 11) == "PlacedUnit_" then table.insert(units, d) end
    end
    return units
end

local function getRollButton()
    local base = getOwnBase()
    if not base then return nil end
    local rs = base:FindFirstChild("RollStation")
    local btn = rs and rs:FindFirstChild("Button")
    local model = btn and btn:FindFirstChild("Model")
    return model and model:FindFirstChild("RollButton")
end

local function getStandUnits()
    local out = {}
    local base = getOwnBase()
    if not base then return out end
    local rs = base:FindFirstChild("RollStation")
    if not rs then return out end
    for _, m in ipairs(rs:GetChildren()) do
        if m:IsA("Model") and m.Name ~= "Button" and m.Name ~= "pity" then
            local prompt = nil
            for _, d in ipairs(m:GetDescendants()) do
                if d:IsA("ProximityPrompt") and d.ActionText == "Collect" then prompt = d break end
            end
            if prompt then
                local price = nil
                if UnitDatabase and UnitDatabase[m.Name] and UnitDatabase[m.Name].Price then price = UnitDatabase[m.Name].Price end
                table.insert(out, { model = m, name = m.Name, prompt = prompt, price = price })
            end
        end
    end
    return out
end

local function parsePrice(str)
    if not str then return 100000 end
    local s = tostring(str):upper():gsub(",", ""):gsub("¥", ""):gsub("%$", ""):gsub(" ", "")
    local mult = 1
    local suf = s:sub(-1)
    if suf == "K" then mult = 1000 s = s:sub(1, -2)
    elseif suf == "M" then mult = 1000000 s = s:sub(1, -2)
    elseif suf == "B" then mult = 1000000000 s = s:sub(1, -2) end
    local n = tonumber(s)
    if not n then return 100000 end
    return math.floor(n * mult)
end

local function maxBuyPrice() return parsePrice(getInput("MaxBuyPrice")) end

local function mythicOnStand()
    local ok, g = pcall(function() return LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("RollMythicWarningGui") end)
    return ok and g and g.Enabled == true
end

local function weaponPrice(name)
    if WeaponsDatabase and WeaponsDatabase[name] and WeaponsDatabase[name].Price then return WeaponsDatabase[name].Price end
    return nil
end

local function statPrice(statKey)
    if not UpgradeConfig then return nil end
    local cfg = UpgradeConfig[statKey]
    if not cfg then return nil end
    local lvl = LocalPlayer:GetAttribute(statKey) or 0
    if cfg.MaxLevel and lvl >= cfg.MaxLevel then return nil end
    if cfg.Prices then return cfg.Prices[lvl + 1] end
    if cfg.BasePrice and cfg.GrowthRate then return math.floor(cfg.BasePrice * (cfg.GrowthRate ^ (lvl - (cfg.ExponentOffset or 0)))) end
    return nil
end

local function nextZonePrice()
    if not ZoneDatabase then return nil, nil end
    local cur = LocalPlayer:GetAttribute("Zone")
    local idx = nil
    for i, z in ipairs(ZoneDatabase) do
        if z.Name == cur or z.DisplayName == cur then idx = i break end
    end
    if not idx then return nil, nil end
    local nxt = ZoneDatabase[idx + 1]
    if not nxt then return nil, nil end
    return nxt.Price, (nxt.DisplayName or nxt.Name)
end

local function prestigeRequired()
    local p = LocalPlayer:GetAttribute("Prestige") or 0
    if XPConfig and XPConfig.RequiredLevelForPrestige then
        local ok, v = pcall(function() return XPConfig.RequiredLevelForPrestige(p) end)
        if ok and v then return v end
    end
    if p < 5 then return 10 + p * 5 end
    return 35 + (p - 5) * 3
end

-- Selling helper (used by Auto Sell toggle and Sell Once button)
local function sellSelected()
    if not Remotes.SellUnits then notify("Sell", "Remote missing", 2) return 0 end
    local want = selectedSet("SellRarities")
    local ids = {}
    for _, tool in ipairs(getUnitTools()) do
        if tool:GetAttribute("Equipped") == true or tool:GetAttribute("Locked") == true then continue end
        local r = unitRarity(tool.Name)
        if r and want[r] then table.insert(ids, tool) end
    end
    if #ids == 0 then notify("Sell", "No sellable units match (equipped and locked are skipped)", 2) return 0 end
    local ok, res = pcall(function() return Remotes.SellUnits:InvokeServer(ids) end)
    notify("Sell", ok and ("Sent " .. #ids .. " units, server: " .. tostring(res)) or "Sell rejected", 3)
    return #ids
end

-- Roll state and helpers (used by AutoRoll toggle and Manual buttons)
local rollState = { returnPos = nil, warned = false, poorWarned = false }

local function collectWantedOnce()
    local stands = getStandUnits()
    local keep   = selectedSet("KeepRarities")
    local cap    = maxBuyPrice()
    local cash   = money()
    local bought, waiting, precious = 0, 0, 0
    for _, s in ipairs(stands) do
        local r = unitRarity(s.name)
        if not r or NEVER_AUTO_DESTROY[r] then
            precious += 1
        elseif keep[r] and s.price and s.price <= cap then
            if cash >= s.price then
                local ok = pcall(function() fireproximityprompt(s.prompt) end)
                if ok then cash = cash - s.price bought += 1 end
            else
                waiting += 1
            end
        end
    end
    return bought, waiting, precious, #stands
end

local function doRollTick()
    if mythicOnStand() then
        if not rollState.warned then
            rollState.warned = true
            notify("Auto Roll", "Mythic+ waiting on stand: collect it manually, rolling paused", 5)
        end
        return
    end
    rollState.warned = false
    if unitCount() >= unitCap() then
        notify("Auto Roll", "Inventory full (" .. unitCap() .. "), rolling paused", 4)
        stopLoop("AutoRoll")
        if Elements.AutoRoll then pcall(function() Elements.AutoRoll:Set(false) end) end
        return
    end
    local bought, waiting, precious, total = collectWantedOnce()
    if precious > 0 then
        notify("Auto Roll", "Rare unit on stand: collect it manually, rolling paused", 5)
        return
    end
    if waiting > 0 then
        if not rollState.poorWarned then
            rollState.poorWarned = true
            notify("Auto Roll", "Wanted unit on stand but short on cash: waiting", 4)
        end
        return
    end
    rollState.poorWarned = false
    if bought > 0 then return end
    if total > 0 then
        if Remotes.ConfirmedRoll then pcall(function() Remotes.ConfirmedRoll:FireServer() end) end
        return
    end
    local rb = getRollButton()
    if not rb then return end
    local pp = rb:FindFirstChild("ProximityPrompt")
    if not pp then return end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp and (hrp.Position - rb.CFrame.Position).Magnitude > 18 then
        hrp.CFrame = rb.CFrame + Vector3.new(0, 3, 4)
        task.wait(0.6)
    end
    pcall(function() fireproximityprompt(pp) end)
end

-- Anti-AFK helper
local function setAntiAFK(enabled)
    if enabled then
        stopLoop("AntiAFKJump")
        task.spawn(function()
            while getToggle("AntiAFK") and not Unloaded do
                if Unloaded then break end
                pcall(function()
                    local ping = getRemote("AntiAfkActivityPingEvent")
                    if ping then ping:FireServer() end
                    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum.Jump = true
                        hum:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
                for i = 1, 300 do
                    if not getToggle("AntiAFK") or Unloaded then break end
                    task.wait(1)
                end
            end
        end)
        notify("Anti-AFK", "Enabled (jump every 5m)", 2)
    else
        stopLoop("AntiAFKJump")
        notify("Anti-AFK", "Disabled", 2)
    end
end

------------------------------------------------------------
-- 6. UI builder wrappers
------------------------------------------------------------
local function makeToggle(parent, flag, name, default, callback)
    local el = parent:CreateToggle({
        Name          = name,
        CurrentValue  = default,
        Flag          = flag,
        Callback      = function(value) callback(value) end,
    })
    Elements[flag] = el
    return el
end

local function makeDropdown(parent, flag, name, values, default, multi, callback)
    local currentOpt
    if type(default) == "table" then
        currentOpt = {}
        for _, v in ipairs(default) do table.insert(currentOpt, v) end
    else
        currentOpt = { values[1] }
    end
    local el = parent:CreateDropdown({
        Name            = name,
        Options         = values,
        CurrentOption   = currentOpt,
        MultipleOptions = multi and true or false,
        Flag            = flag,
        Callback        = function(opts) if callback then callback(opts) end end,
    })
    Elements[flag] = el
    return el
end

local function makeInput(parent, flag, name, default, placeholder, callback)
    local el = parent:CreateInput({
        Name                    = name,
        CurrentValue            = default,
        PlaceholderText         = placeholder,
        RemoveTextAfterFocusLost= false,
        Flag                    = flag,
        Callback                = function(text) if callback then callback(text) end end,
    })
    Elements[flag] = el
    return el
end

local function makeButton(parent, name, fn)
    return parent:CreateButton({ Name = name, Callback = fn })
end

local function makeLabel(parent, text)
    return parent:CreateLabel(text)
end

local function makeDivider(parent)
    return parent:CreateDivider()
end

------------------------------------------------------------
-- 7. Tab: Main
------------------------------------------------------------
do
    Tabs.Main:CreateSection("Info")
    makeLabel(Tabs.Main, "Game: " .. gameName)
    makeLabel(Tabs.Main, "Hub: " .. HubName .. " (Rayfield UI)")
    makeLabel(Tabs.Main, "Press RightShift to toggle UI")

    makeDivider(Tabs.Main)
    local SessionLabel = Tabs.Main:CreateLabel("Session: 00:00")
    LiveLabels.Session = SessionLabel
    task.spawn(function()
        local s = 0
        while not Unloaded do
            task.wait(1); s += 1
            pcall(function() SessionLabel:Set(string.format("Session: %02d:%02d", math.floor(s / 60), s % 60)) end)
        end
    end)

    Tabs.Main:CreateSection("Quick Status")
    makeLabel(Tabs.Main, "Live attributes from server.")
    local cashLabel  = Tabs.Main:CreateLabel("Cash: ...")
    local lvlLabel   = Tabs.Main:CreateLabel("Level: ...")
    local unitLabel  = Tabs.Main:CreateLabel("Units: ...")
    LiveLabels.Cash, LiveLabels.Level, LiveLabels.Units = cashLabel, lvlLabel, unitLabel
    task.spawn(function()
        while not Unloaded do
            task.wait(1)
            pcall(function()
                cashLabel:SetText("Cash: " .. tostring(money()))
                lvlLabel:SetText("Level: " .. tostring(LocalPlayer:GetAttribute("Level") or 0) ..
                                 " | Prestige: " .. tostring(LocalPlayer:GetAttribute("Prestige") or 0))
                unitLabel:SetText("Units: " .. unitCount() .. "/" .. unitCap() ..
                                  " | Shards: " .. tostring(LocalPlayer:GetAttribute("TraitShardCount") or 0))
            end)
        end
    end)
end

------------------------------------------------------------
-- 8. Tab: Farming
------------------------------------------------------------
do
    Tabs.Farming:CreateSection("Income (Resource Collecting)")
    makeToggle(Tabs.Farming, "AutoCollectCash", "Auto Collect Cash", false,
        function(v)
            if v then
                startLoop("AutoCollectCash", function()
                    if Remotes.CollectCash then Remotes.CollectCash:FireServer() end
                end)
            else stopLoop("AutoCollectCash") end
        end)
    makeToggle(Tabs.Farming, "AutoFarmWaves", "Auto Farm Waves", false,
        function(v)
            if v then
                startLoop("AutoFarmWaves", function()
                    if Remotes.PlayerAttack then Remotes.PlayerAttack:FireServer() end
                    if Remotes.CollectCash then pcall(function() Remotes.CollectCash:FireServer() end) end
                end)
            else stopLoop("AutoFarmWaves") end
        end)
    makeLabel(Tabs.Farming, "Cash is server-owned (Player:GetAttribute('Money')).")
    makeButton(Tabs.Farming, "Collect Once", function()
        if Remotes.CollectCash then Remotes.CollectCash:FireServer() end
        notify("Collect Cash", "Fired once", 1)
    end)

    makeDivider(Tabs.Farming)

    Tabs.Farming:CreateSection("Quests & Challenges")
    makeDropdown(Tabs.Farming, "QuestTiers", "Quest Tiers", QuestTierList, QuestTierList, true, nil)
    makeToggle(Tabs.Farming, "AutoCompleteQuests", "Auto Complete Quests", false,
        function(v)
            if v then
                startLoop("AutoCompleteQuests", function()
                    if not Remotes.ClaimEventQuest then return end
                    local tiers = selectedSet("QuestTiers")
                    for tier, _ in pairs(tiers) do
                        for _, qid in ipairs(QuestIdsByTier[tier] or {}) do
                            pcall(function() Remotes.ClaimEventQuest:InvokeServer(qid) end)
                        end
                    end
                end)
            else stopLoop("AutoCompleteQuests") end
        end)
    makeDropdown(Tabs.Farming, "ChallengeTiers", "Challenge Tiers", ChallengeTierList, ChallengeTierList, true, nil)
    makeToggle(Tabs.Farming, "AutoCompleteChallenges", "Auto Complete Challenges", false,
        function(v)
            if v then
                startLoop("AutoCompleteChallenges", function()
                    if not Remotes.ChallengeStart then return end
                    local tiers = selectedSet("ChallengeTiers")
                    local n = 0
                    for _ in pairs(tiers) do n += 1 end
                    if n == 0 then
                        pcall(function() Remotes.ChallengeStart:InvokeServer("Regular") end)
                    else
                        for tier, _ in pairs(tiers) do
                            pcall(function() Remotes.ChallengeStart:InvokeServer(tier) end)
                        end
                    end
                end)
            else stopLoop("AutoCompleteChallenges") end
        end)
    makeToggle(Tabs.Farming, "AutoEnterInfiniteTower", "Auto Enter Infinite Tower", false,
        function(v)
            if v then
                startLoop("AutoEnterInfiniteTower", function()
                    if Remotes.InfiniteTowerEnter then
                        pcall(function() Remotes.InfiniteTowerEnter:InvokeServer() end)
                    end
                end)
            else stopLoop("AutoEnterInfiniteTower") end
        end)

    makeDivider(Tabs.Farming)

    Tabs.Farming:CreateSection("Rewards")
    makeToggle(Tabs.Farming, "AutoClaimDailyRewards", "Auto Claim Daily Rewards", false,
        function(v)
            if v then
                startLoop("AutoClaimDailyRewards", function()
                    if Remotes.ClaimDaily and Remotes.GetDailyStatus then
                        local ok, st = pcall(function() return Remotes.GetDailyStatus:InvokeServer() end)
                        local day = (ok and type(st) == "table" and st.NextDay) or 1
                        pcall(function() Remotes.ClaimDaily:InvokeServer(day) end)
                    end
                end)
            else stopLoop("AutoClaimDailyRewards") end
        end)
    makeToggle(Tabs.Farming, "AutoClaimGroupRewards", "Auto Claim Group Rewards", false,
        function(v)
            if v then
                startLoop("AutoClaimGroupRewards", function()
                    if Remotes.ClaimGroup then pcall(function() Remotes.ClaimGroup:InvokeServer() end) end
                end)
            else stopLoop("AutoClaimGroupRewards") end
        end)
    makeButton(Tabs.Farming, "Claim Daily Now", function()
        if Remotes.ClaimDaily and Remotes.GetDailyStatus then
            local ok, st = pcall(function() return Remotes.GetDailyStatus:InvokeServer() end)
            local day = (ok and type(st) == "table" and st.NextDay) or 1
            pcall(function() Remotes.ClaimDaily:InvokeServer(day) end)
            notify("Daily", "Claim attempted (day " .. tostring(day) .. ")")
        end
    end)
    makeButton(Tabs.Farming, "Claim Group Now", function()
        if Remotes.ClaimGroup then
            pcall(function() Remotes.ClaimGroup:InvokeServer() end)
            notify("Group", "Claim attempted")
        end
    end)

    makeDivider(Tabs.Farming)

    Tabs.Farming:CreateSection("Selling")
    makeDropdown(Tabs.Farming, "SellRarities", "Sell Rarities", RarityList, RarityList, true, nil)
    makeToggle(Tabs.Farming, "AutoSellUnits", "Auto Sell Units", false,
        function(v)
            if v then
                startLoop("AutoSellUnits", function() sellSelected() end, 3)
            else stopLoop("AutoSellUnits") end
        end)
    makeLabel(Tabs.Farming, "Sells real unit tools (UnitId), never equipped or locked. Server returns true or false.")
    makeButton(Tabs.Farming, "Sell Selected Once", function() sellSelected() end)
end

------------------------------------------------------------
-- 9. Tab: Inventory
------------------------------------------------------------
do
    Tabs.Inventory:CreateSection("Auto Roll")
    makeToggle(Tabs.Inventory, "AutoRoll", "Auto Roll (Station)", false,
        function(v)
            if v then
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                rollState.returnPos = (hrp and hrp.CFrame) or nil
                rollState.warned = false
                rollState.poorWarned = false
                startLoop("AutoRoll", doRollTick, 3)
                notify("Auto Roll", "Started at your station")
            else
                stopLoop("AutoRoll")
                if rollState.returnPos then
                    local char2 = LocalPlayer.Character
                    local hrp2 = char2 and char2:FindFirstChild("HumanoidRootPart")
                    if hrp2 then pcall(function() hrp2.CFrame = rollState.returnPos end) end
                    rollState.returnPos = nil
                end
                notify("Auto Roll", "Stopped", 2)
            end
        end)
    makeDropdown(Tabs.Inventory, "KeepRarities", "Keep Rarities", RarityList, RarityList, true, nil)
    makeInput(Tabs.Inventory, "MaxBuyPrice", "Max Buy Price", "100000", "e.g. 50000, 1M, 2.5M", nil)
    makeLabel(Tabs.Inventory, "Wanted but short on cash waits. Mythic+ is never auto-destroyed.")

    makeDivider(Tabs.Inventory)

    Tabs.Inventory:CreateSection("Roll Manual")
    makeButton(Tabs.Inventory, "Roll Once", function()
        local rb = getRollButton()
        local pp = rb and rb:FindFirstChild("ProximityPrompt")
        if pp then
            pcall(function() fireproximityprompt(pp) end)
            notify("Roll", "Pressed", 1)
        else
            notify("Roll", "Station not found", 2)
        end
    end)
    makeButton(Tabs.Inventory, "Collect Wanted Once", function()
        local bought, waiting, precious, total = collectWantedOnce()
        if precious > 0 then notify("Collect", "Rare unit on stand: collect manually", 4)
        elseif waiting > 0 then notify("Collect", "Short on cash", 3)
        elseif bought > 0 then notify("Collect", "Bought " .. bought, 2)
        else notify("Collect", total > 0 and "Nothing wanted on stand" or "Stand empty", 2) end
    end)
    makeButton(Tabs.Inventory, "Go To Station", function()
        local rb = getRollButton()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if rb and hrp then hrp.CFrame = rb.CFrame + Vector3.new(0, 3, 4) end
    end)
    makeLabel(Tabs.Inventory, "Keep list plus price cap decide every buy. Gamepass events need a pass you do not own.")

    makeDivider(Tabs.Inventory)

    Tabs.Inventory:CreateSection("Weapon Shop")
    makeDropdown(Tabs.Inventory, "BuyWeapons", "Weapons to Buy", WeaponList, WeaponList, true, nil)
    makeToggle(Tabs.Inventory, "AutoBuyWeapons", "Auto Buy Weapons", false,
        function(v)
            if v then
                startLoop("AutoBuyWeapons", function()
                    if not Remotes.BuyWeapon then return end
                    local cash = money()
                    local sel = selectedSet("BuyWeapons")
                    for weapon, _ in pairs(sel) do
                        local price = weaponPrice(weapon)
                        if price and cash >= price then
                            local ok, res = pcall(function() return Remotes.BuyWeapon:InvokeServer(weapon) end)
                            if ok and res == true then cash = money() end
                        end
                        task.wait(0.2)
                    end
                end)
            else stopLoop("AutoBuyWeapons") end
        end)

    makeDivider(Tabs.Inventory)

    Tabs.Inventory:CreateSection("Equipping")
    makeToggle(Tabs.Inventory, "AutoEquipBestWeapon", "Auto Equip Best Weapon", false,
        function(v)
            if v then
                startLoop("AutoEquipBestWeapon", function()
                    if not Remotes.EquipWeapon then return end
                    for _, w in ipairs(WeaponBestFirst) do
                        local ok, res = pcall(function() return Remotes.EquipWeapon:InvokeServer(w) end)
                        if ok and res == true then break end
                    end
                end)
            else stopLoop("AutoEquipBestWeapon") end
        end)
    makeButton(Tabs.Inventory, "Equip Best Now", function()
        if not Remotes.EquipWeapon then return end
        for _, w in ipairs(WeaponBestFirst) do
            local ok, res = pcall(function() return Remotes.EquipWeapon:InvokeServer(w) end)
            if ok and res == true then notify("Equip", "Equipped " .. w) return end
        end
        notify("Equip", "No owned weapon equipped", 2)
    end)

    makeDivider(Tabs.Inventory)

    Tabs.Inventory:CreateSection("Unit Management")
    makeToggle(Tabs.Inventory, "AutoEquipBestUnits", "Auto Equip Best Units", false,
        function(v)
            if v then
                startLoop("AutoEquipBestUnits", function()
                    if Remotes.EquipBest then pcall(function() Remotes.EquipBest:InvokeServer() end) end
                end)
            else stopLoop("AutoEquipBestUnits") end
        end)
    makeButton(Tabs.Inventory, "Pick Up Placed Units", function()
        if Remotes.PickUpAll then
            local ok, res = pcall(function() return Remotes.PickUpAll:InvokeServer() end)
            notify("Pick Up", tostring(res))
        end
    end)
    makeButton(Tabs.Inventory, "Fuse Duplicates", function()
        if not Remotes.Fuse then return end
        local fused = 0
        local byName = {}
        for _, t in ipairs(getUnitTools()) do byName[t.Name] = byName[t.Name] or {} table.insert(byName[t.Name], t) end
        for name, list in pairs(byName) do
            if #list >= 2 then
                local ok, res = pcall(function() return Remotes.Fuse:InvokeServer(list[1], 1) end)
                if ok and res == true then fused += 1 end
                task.wait(0.3)
            end
        end
        notify("Fuse", fused > 0 and ("Fused " .. fused) or "No duplicates found")
    end)
    makeDropdown(Tabs.Inventory, "EvolveTargets", "Evolve Targets", EvolveList, EvolveList, true, nil)
    makeButton(Tabs.Inventory, "Start Evolve", function()
        if not Remotes.Evolve then return end
        local sel = selectedSet("EvolveTargets")
        for name, _ in pairs(sel) do
            local tool = findToolByName(name)
            if tool then
                local ok, res = pcall(function() return Remotes.Evolve:InvokeServer(tool) end)
                notify("Evolve " .. name, tostring(res), 3)
            else
                notify("Evolve " .. name, "no unit owned", 2)
            end
            task.wait(0.3)
        end
    end)
    makeButton(Tabs.Inventory, "Claim Evolve", function()
        if Remotes.ClaimEvolve then
            local ok, res = pcall(function() return Remotes.ClaimEvolve:InvokeServer() end)
            notify("Claim Evolve", tostring(res))
        end
    end)
    makeLabel(Tabs.Inventory, "Fuse needs 2+ copies of one unit. Evolve needs copies plus materials. Rerolling is manual in the Trait UI.")

    makeDivider(Tabs.Inventory)

    Tabs.Inventory:CreateSection("Stat Upgrades")
    makeToggle(Tabs.Inventory, "AutoUpgradeAll", "Auto Upgrade All Stats", false,
        function(v)
            if v then
                startLoop("AutoUpgradeAll", function()
                    if not (Remotes.Upgrade and UpgradeConfig) then return end
                    local cash = money()
                    local bestKey, bestPrice = nil, nil
                    for statKey, cfg in pairs(UpgradeConfig) do
                        if type(cfg) == "table" then
                            local price = statPrice(statKey)
                            if price and cash >= price and (not bestPrice or price < bestPrice) then
                                bestKey, bestPrice = statKey, price
                            end
                        end
                    end
                    if bestKey then
                        pcall(function() Remotes.Upgrade:FireServer(bestKey) end)
                        if LiveLabels.LastUpgrade then
                            pcall(function()
                                LiveLabels.LastUpgrade:SetText("Last: " .. bestKey .. " (" .. tostring(bestPrice) .. ")")
                            end)
                        end
                    end
                end)
            else stopLoop("AutoUpgradeAll") end
        end)
    local lastBoughtLabel = Tabs.Inventory:CreateLabel("Last: none")
    LiveLabels.LastUpgrade = lastBoughtLabel
    makeLabel(Tabs.Inventory, "Covers every stat in the tree, including ones with no manual button. Never fires when short on cash.")

    makeDivider(Tabs.Inventory)

    Tabs.Inventory:CreateSection("Zones")
    makeToggle(Tabs.Inventory, "AutoPurchaseZones", "Auto Purchase Zones", false,
        function(v)
            if v then
                startLoop("AutoPurchaseZones", function()
                    if not Remotes.ZonePurchase then return end
                    local price = nextZonePrice()
                    if price and money() >= price then
                        pcall(function() Remotes.ZonePurchase:FireServer() end)
                    end
                end, 3)
            else stopLoop("AutoPurchaseZones") end
        end)
    local zoneLabel = Tabs.Inventory:CreateLabel("Next: ...")
    LiveLabels.NextZone = zoneLabel
    makeDropdown(Tabs.Inventory, "TravelZones", "Travel Destination", ZoneList, { ZoneList[1] }, false, nil)
    makeButton(Tabs.Inventory, "Travel Now", function()
        if not (Remotes.ZoneTravel and Elements.TravelZones) then return end
        local v = Elements.TravelZones.CurrentOption
        local zone = (type(v) == "table" and v[1]) or ZoneList[1]
        pcall(function() Remotes.ZoneTravel:FireServer(zone) end)
        notify("Travel", tostring(zone), 2)
    end)
    task.spawn(function()
        while not Unloaded do
            task.wait(2)
            pcall(function()
                local price, name = nextZonePrice()
                if price then
                    zoneLabel:SetText("Next: " .. tostring(name) .. " (" .. tostring(price) .. ", you: " .. tostring(money()) .. ")")
                else
                    zoneLabel:SetText("Next: maxed or unknown")
                end
            end)
        end
    end)

    makeDivider(Tabs.Inventory)

    Tabs.Inventory:CreateSection("Consumables & Abilities")
    makeDropdown(Tabs.Inventory, "PotionTypes", "Potions", PotionList, PotionList, true, nil)
    makeToggle(Tabs.Inventory, "AutoUsePotions", "Auto Use Potions", false,
        function(v)
            if v then
                startLoop("AutoUsePotions", function()
                    if not (Remotes.UsePotion and Remotes.GetItemInv) then return end
                    local ok, inv = pcall(function() return Remotes.GetItemInv:InvokeServer() end)
                    if not ok or type(inv) ~= "table" then return end
                    local sel = selectedSet("PotionTypes")
                    for potion, _ in pairs(sel) do
                        if (inv[potion] or 0) > 0 then
                            pcall(function() Remotes.UsePotion:InvokeServer(potion) end)
                            task.wait(0.2)
                        end
                    end
                end)
            else stopLoop("AutoUsePotions") end
        end)
    makeToggle(Tabs.Inventory, "AutoUseOnPlaced", "Auto-Use Abilities on Placed Units", false,
        function(v)
            if v then
                startLoop("AutoUseOnPlaced", function()
                    if not Remotes.SetAutoUse then return end
                    for _, u in ipairs(getOwnPlacedUnits()) do
                        pcall(function() Remotes.SetAutoUse:InvokeServer(u, true) end)
                    end
                end)
            else
                if Remotes.SetAutoUse then
                    for _, u in ipairs(getOwnPlacedUnits()) do
                        pcall(function() Remotes.SetAutoUse:InvokeServer(u, false) end)
                    end
                end
                stopLoop("AutoUseOnPlaced")
            end
        end)
    makeButton(Tabs.Inventory, "Use All Abilities", function()
        if not Remotes.UseAbility then return end
        local n = 0
        for _, u in ipairs(getOwnPlacedUnits()) do
            local ok, res = pcall(function() return Remotes.UseAbility:InvokeServer(u) end)
            if ok and res then n += 1 end
        end
        notify("Abilities", "Used " .. n, 2)
    end)
end

------------------------------------------------------------
-- 10. Tab: Rebirth
------------------------------------------------------------
do
    Tabs.Rebirth:CreateSection("Prestige")
    local gateLabel = Tabs.Rebirth:CreateLabel("...")
    LiveLabels.PrestigeGate = gateLabel
    makeButton(Tabs.Rebirth, "Prestige Now", function()
        local need = prestigeRequired()
        local lvl = LocalPlayer:GetAttribute("Level") or 0
        if lvl < need then notify("Prestige", "Need level " .. need .. " (you: " .. lvl .. ")", 3) return end
        if Remotes.Prestige then
            Remotes.Prestige:FireServer()
            notify("Prestige", "Fired at level " .. lvl)
        end
    end)
    makeToggle(Tabs.Rebirth, "AutoPrestige", "Auto Prestige", false,
        function(v)
            if v then
                startLoop("AutoPrestige", function()
                    local need = prestigeRequired()
                    if (LocalPlayer:GetAttribute("Level") or 0) >= need and Remotes.Prestige then
                        Remotes.Prestige:FireServer()
                    end
                end)
            else stopLoop("AutoPrestige") end
        end)

    makeDivider(Tabs.Rebirth)

    Tabs.Rebirth:CreateSection("Info")
    makeLabel(Tabs.Rebirth, "Prestige resets progress for permanent rewards. Formula: level 10 plus 5 per early prestige.")
    task.spawn(function()
        while not Unloaded do
            task.wait(1)
            pcall(function()
                gateLabel:SetText("Need Lv " .. prestigeRequired() ..
                    " | You: Lv " .. tostring(LocalPlayer:GetAttribute("Level") or 0) ..
                    " P" .. tostring(LocalPlayer:GetAttribute("Prestige") or 0))
            end)
        end
    end)
end

------------------------------------------------------------
-- 11. Tab: Settings
------------------------------------------------------------
do
    Tabs.Settings:CreateSection("System")
    makeToggle(Tabs.Settings, "AntiAFK", "Anti-AFK", true,
        function(v) setAntiAFK(v) end)
    makeLabel(Tabs.Settings, "Enabled by default. Uses AntiAfkActivityPingEvent + Humanoid jump.")

    makeDivider(Tabs.Settings)

    Tabs.Settings:CreateSection("Menu")
    makeLabel(Tabs.Settings, "Menu Keybind: RightShift")
    makeLabel(Tabs.Settings, "Configuration auto-saved by Rayfield to: " .. HubName .. "/ .")

    makeDivider(Tabs.Settings)

    makeButton(Tabs.Settings, "Unload Hub", function()
        Unloaded = true
        for k, _ in pairs(Loops) do Loops[k].Running = false end
        pcall(function() Rayfield:Destroy() end)
    end)
end

-- Kick off Anti-AFK if it defaulted to on
task.defer(function()
    task.wait(0.5)
    if Elements.AntiAFK then setAntiAFK(Elements.AntiAFK.CurrentValue) end
end)

------------------------------------------------------------
-- 12. Final
------------------------------------------------------------
Rayfield:LoadConfiguration()
Rayfield:Notify({
    Title   = HubName,
    Content = gameName .. " loaded! Press RightShift",
    Duration= 4,
})
