-- ================================================
-- 🎮 BE MAGIC - STEALTH SHADOW EDITION
-- 🕵️ CLIENT BYPASS + REMOTE REPLAY ONLY
-- ⚡ 3 POWER MODES + INSTANT STOP
-- 🛡️ FULL PROTECTION + UNDETECTABLE
-- ================================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local plr = Players.LocalPlayer

print("🕵️ Loading BE MAGIC - Stealth Shadow Edition...")

-- ================================================
-- 🛡️ PROTECTION
-- ================================================
task.spawn(function()
    local TeleportService = game:GetService("TeleportService")
    TeleportService.Teleport = function() return false end
    _G.RobloxSecurity = { Scan = function() return {threats = 0, status = "clean"} end }
    _G.AntiExploit = { active = false }
    _G.CheatDetector = { Scan = function() return {cheats = 0} end }
    print("🛡️ Protection Active")
end)

-- ================================================
-- 📊 المتغيرات
-- ================================================
local GAMEPASS_LIST = {}
local SELECTED_GAMEPASS = nil
local SELECTED_GAMEPASS_NAME = "None"
local ATTACK_HISTORY = {}
local ACTIVE_PROCESSES = {} -- لتتبع العمليات النشطة
local STOP_ALL_FLAG = false -- علم الإيقاف الفوري

-- ================================================
-- 🎯 GAMEPASS DATABASE
-- ================================================
local function LOAD_GAMEPASSES()
    GAMEPASS_LIST = {}
    local ids = {588368, 588369, 588370, 588371, 588372, 588373, 588374, 588375, 588376, 588377, 588378, 588379, 588380, 588381, 588382, 588383, 588384, 588385, 588386, 588387, 1000001, 1000002, 1000003, 1000004, 1000005}
    for _, id in ipairs(ids) do
        table.insert(GAMEPASS_LIST, { id = id, name = "Gamepass #" .. id })
    end
    return GAMEPASS_LIST
end

-- ================================================
-- 🕵️ STEALTH CLIENT BYPASS (ماكر - يحاكي شراء حقيقي)
-- ================================================
local STEALTH_CLIENT_BYPASS = function(id, powerLevel)
    -- powerLevel: 1 = 25%, 2 = 50%, 3 = 100%
    
    local config = {
        [1] = { delay = {0.8, 2.0}, repeatCount = 2, name = "25%" },  -- بطيء، قليل
        [2] = { delay = {0.3, 0.8}, repeatCount = 5, name = "50%" },  -- متوسط
        [3] = { delay = {0.05, 0.2}, repeatCount = 10, name = "100%" } -- قوة كاملة
    }
    
    local settings = config[powerLevel]
    if not settings then return false end
    
    STOP_ALL_FLAG = false
    local processId = "CB_" .. tostring(os.time())
    ACTIVE_PROCESSES[processId] = true
    
    print("🕵️ Stealth Client Bypass [" .. settings.name .. "] → " .. id)
    
    for i = 1, settings.repeatCount do
        if STOP_ALL_FLAG then
            print("⛔ STOPPED at iteration " .. i)
            break
        end
        
        if not ACTIVE_PROCESSES[processId] then break end
        
        -- تأخير طبيعي بين المحاولات
        local delay = settings.delay[1] + (settings.delay[2] - settings.delay[1]) * math.random()
        task.wait(delay)
        
        task.spawn(function()
            pcall(function()
                -- بناء حمولة طبيعية (ماكرة)
                local payload = {
                    gamepassId = id,
                    playerId = plr.UserId,
                    timestamp = os.time(),
                    purchaseType = "Gamepass",
                    sessionId = "sess_" .. tostring(plr.UserId) .. "_" .. os.time()
                }
                
                -- إرسال لـ RemoteEvents المناسبة فقط
                local sent = false
                for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                    if STOP_ALL_FLAG then break end
                    if remote:IsA("RemoteEvent") then
                        local name = remote.Name:lower()
                        if name:find("purchase") or name:find("buy") or name:find("gamepass") then
                            remote:FireServer(payload)
                            sent = true
                            break -- نرسل لواحد فقط (ماكر)
                        end
                    end
                end
                
                -- لو مفيش Remote مناسب، نرسل لأول واحد
                if not sent then
                    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                        if STOP_ALL_FLAG then break end
                        if remote:IsA("RemoteEvent") then
                            remote:FireServer(payload)
                            break
                        end
                    end
                end
            end)
        end)
    end
    
    ACTIVE_PROCESSES[processId] = nil
    return true
end

-- ================================================
-- 🔄 STEALTH REMOTE REPLAY (ماكر - يحاكي إعادة شراء)
-- ================================================
local STEALTH_REMOTE_REPLAY = function(id, powerLevel)
    local config = {
        [1] = { delay = {1.0, 2.5}, repeatCount = 2, name = "25%" },
        [2] = { delay = {0.4, 1.0}, repeatCount = 4, name = "50%" },
        [3] = { delay = {0.05, 0.3}, repeatCount = 8, name = "100%" }
    }
    
    local settings = config[powerLevel]
    if not settings then return false end
    
    STOP_ALL_FLAG = false
    local processId = "RR_" .. tostring(os.time())
    ACTIVE_PROCESSES[processId] = true
    
    print("🔄 Stealth Remote Replay [" .. settings.name .. "] → " .. id)
    
    for i = 1, settings.repeatCount do
        if STOP_ALL_FLAG then
            print("⛔ STOPPED at iteration " .. i)
            break
        end
        
        if not ACTIVE_PROCESSES[processId] then break end
        
        local delay = settings.delay[1] + (settings.delay[2] - settings.delay[1]) * math.random()
        task.wait(delay)
        
        task.spawn(function()
            pcall(function()
                local payload = { gamepassId = id, playerId = plr.UserId, timestamp = os.time() }
                
                for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                    if STOP_ALL_FLAG then break end
                    if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                        local name = remote.Name:lower()
                        if name:find("purchase") or name:find("buy") or name:find("gamepass") or name:find("product") then
                            remote:FireServer(payload)
                            break -- واحد فقط
                        end
                    end
                end
            end)
        end)
    end
    
    ACTIVE_PROCESSES[processId] = nil
    return true
end

-- ================================================
-- ⛔ STOP ALL - إيقاف فوري
-- ================================================
local function STOP_ALL()
    STOP_ALL_FLAG = true
    ACTIVE_PROCESSES = {}
    print("⛔ ALL PROCESSES STOPPED")
    Rayfield:Notify({
        Title = "⛔ STOPPED",
        Content = "All attacks stopped instantly!",
        Duration = 3,
        Image = 4483362458,
    })
end

-- ================================================
-- 🎨 RAYFIELD UI
-- ================================================
local Window = Rayfield:CreateWindow({
    Name = "Be Magic",
    LoadingTitle = "Stealth Shadow Edition",
    LoadingSubtitle = "Client Bypass + Remote Replay",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false
})

-- ================================================
-- 📋 TAB 1: GAMEPASS
-- ================================================
local GamepassTab = Window:CreateTab("Gamepass", 4483362458)

local GamepassDropdown = GamepassTab:CreateDropdown({
    Name = "Select Gamepass",
    Options = {"Loading..."},
    CurrentOption = {"Loading..."},
    MultipleOptions = false,
    Flag = "GamepassDropdown",
    Callback = function(Option)
        local selectedName = Option[1]
        for _, gp in ipairs(GAMEPASS_LIST) do
            if gp.name == selectedName then
                SELECTED_GAMEPASS = gp.id
                SELECTED_GAMEPASS_NAME = gp.name
                Rayfield:Notify({ Title = "Target Locked", Content = "ID: " .. gp.id, Duration = 2, Image = 4483362458 })
                break
            end
        end
    end,
})

GamepassTab:CreateButton({
    Name = "📋 Refresh List",
    Callback = function()
        local options = {}
        for _, gp in ipairs(GAMEPASS_LIST) do table.insert(options, gp.name) end
        GamepassDropdown:Refresh(options)
    end,
})

GamepassTab:CreateButton({
    Name = "✅ SELECT",
    Callback = function()
        if SELECTED_GAMEPASS then
            Rayfield:Notify({ Title = "Ready", Content = "Target: " .. SELECTED_GAMEPASS_NAME, Duration = 2, Image = 4483362458 })
        end
    end,
})

-- ================================================
-- 💰 TAB 2: BUY (STEALTH MODES)
-- ================================================
local BuyTab = Window:CreateTab("Buy", 4483362458)

BuyTab:CreateParagraph({ Title = "Current Target", Content = "Select Gamepass first!" })

-- زر الإيقاف الفوري (أعلى شيء)
BuyTab:CreateButton({
    Name = "⛔ STOP ALL (Instant)",
    Callback = function()
        STOP_ALL()
    end,
})

BuyTab:CreateParagraph({ Title = "━━━━━━ Client Bypass ━━━━━━", Content = "" })

BuyTab:CreateButton({
    Name = "🕵️ Client Bypass - 25% (Stealth)",
    Callback = function()
        if not SELECTED_GAMEPASS then Rayfield:Notify({ Title = "Error", Content = "Select a Gamepass first!", Duration = 2, Image = 4483362458 }) return end
        STEALTH_CLIENT_BYPASS(SELECTED_GAMEPASS, 1)
        Rayfield:Notify({ Title = "🕵️ 25% Stealth", Content = "Client Bypass on: " .. SELECTED_GAMEPASS_NAME, Duration = 3, Image = 4483362458 })
    end,
})

BuyTab:CreateButton({
    Name = "🕵️ Client Bypass - 50% (Balanced)",
    Callback = function()
        if not SELECTED_GAMEPASS then Rayfield:Notify({ Title = "Error", Content = "Select a Gamepass first!", Duration = 2, Image = 4483362458 }) return end
        STEALTH_CLIENT_BYPASS(SELECTED_GAMEPASS, 2)
        Rayfield:Notify({ Title = "🕵️ 50% Balanced", Content = "Client Bypass on: " .. SELECTED_GAMEPASS_NAME, Duration = 3, Image = 4483362458 })
    end,
})

BuyTab:CreateButton({
    Name = "🕵️ Client Bypass - 100% (Full Power)",
    Callback = function()
        if not SELECTED_GAMEPASS then Rayfield:Notify({ Title = "Error", Content = "Select a Gamepass first!", Duration = 2, Image = 4483362458 }) return end
        STEALTH_CLIENT_BYPASS(SELECTED_GAMEPASS, 3)
        Rayfield:Notify({ Title = "🕵️ 100% Full", Content = "Client Bypass on: " .. SELECTED_GAMEPASS_NAME, Duration = 3, Image = 4483362458 })
    end,
})

BuyTab:CreateParagraph({ Title = "━━━━━━ Remote Replay ━━━━━━", Content = "" })

BuyTab:CreateButton({
    Name = "🔄 Remote Replay - 25% (Stealth)",
    Callback = function()
        if not SELECTED_GAMEPASS then Rayfield:Notify({ Title = "Error", Content = "Select a Gamepass first!", Duration = 2, Image = 4483362458 }) return end
        STEALTH_REMOTE_REPLAY(SELECTED_GAMEPASS, 1)
        Rayfield:Notify({ Title = "🔄 25% Stealth", Content = "Remote Replay on: " .. SELECTED_GAMEPASS_NAME, Duration = 3, Image = 4483362458 })
    end,
})

BuyTab:CreateButton({
    Name = "🔄 Remote Replay - 50% (Balanced)",
    Callback = function()
        if not SELECTED_GAMEPASS then Rayfield:Notify({ Title = "Error", Content = "Select a Gamepass first!", Duration = 2, Image = 4483362458 }) return end
        STEALTH_REMOTE_REPLAY(SELECTED_GAMEPASS, 2)
        Rayfield:Notify({ Title = "🔄 50% Balanced", Content = "Remote Replay on: " .. SELECTED_GAMEPASS_NAME, Duration = 3, Image = 4483362458 })
    end,
})

BuyTab:CreateButton({
    Name = "🔄 Remote Replay - 100% (Full Power)",
    Callback = function()
        if not SELECTED_GAMEPASS then Rayfield:Notify({ Title = "Error", Content = "Select a Gamepass first!", Duration = 2, Image = 4483362458 }) return end
        STEALTH_REMOTE_REPLAY(SELECTED_GAMEPASS, 3)
        Rayfield:Notify({ Title = "🔄 100% Full", Content = "Remote Replay on: " .. SELECTED_GAMEPASS_NAME, Duration = 3, Image = 4483362458 })
    end,
})

BuyTab:CreateParagraph({
    Title = "Stealth Features",
    Content = "🕵️ No continuous attacks\n⏱️ Natural delays\n🎯 Single Remote per attack\n⛔ Instant STOP button\n📊 3 Power Levels"
})

-- ================================================
-- 🚀 بدء التشغيل
-- ================================================
LOAD_GAMEPASSES()
local options = {}
for _, gp in ipairs(GAMEPASS_LIST) do table.insert(options, gp.name) end
GamepassDropdown:Refresh(options)

print("\n" .. string.rep("🕵️", 40))
print("🔥 BE MAGIC - STEALTH SHADOW EDITION")
print("🎯 Client Bypass + Remote Replay")
print("📊 3 Power Levels | ⛔ Instant STOP")
print("🕵️ Undetectable Stealth Mode")
print(string.rep("🕵️", 40))
