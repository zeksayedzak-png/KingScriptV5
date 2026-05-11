-- ================================================
-- 🎮 BE MAGIC - ORIGINAL EDITION
-- ⚡ CLIENT BYPASS + REMOTE REPLAY ONLY
-- 🛡️ FULL PROTECTION + ⛔ INSTANT STOP
-- ================================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")
local plr = Players.LocalPlayer

print("⚡ Loading BE MAGIC - Original Edition...")

-- ================================================
-- 🛡️ PROTECTION (ORIGINAL - UNTOUCHED)
-- ================================================
task.spawn(function()
    local TeleportService = game:GetService("TeleportService")
    TeleportService.Teleport = function() return false end
    _G.RobloxSecurity = { Scan = function() return {threats = 0, status = "clean"} end }
    _G.AntiExploit = { active = false }
    _G.CheatDetector = { Scan = function() return {cheats = 0} end }
    print("🛡️ Full Protection Active")
end)

-- ================================================
-- ⛔ INSTANT STOP SYSTEM
-- ================================================
local STOP_ALL_FLAG = false

local function STOP_ALL_ATTACKS()
    STOP_ALL_FLAG = true
    print("⛔ ALL ATTACKS STOPPED INSTANTLY")
    Rayfield:Notify({
        Title = "⛔ STOPPED",
        Content = "All attacks stopped instantly!",
        Duration = 3,
        Image = 4483362458,
    })
end

-- ================================================
-- 📊 المتغيرات
-- ================================================
local GAMEPASS_LIST = {}
local SELECTED_GAMEPASS = nil
local SELECTED_GAMEPASS_NAME = "None"
local ATTACK_HISTORY = {}

-- ================================================
-- 🎯 GAMEPASS DATABASE (ORIGINAL - UNTOUCHED)
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
-- ⚔️ 2 EXPLOIT METHODS (ORIGINAL - UNTOUCHED)
-- ================================================
local ARSENAL = {

    -- 1. Client Bypass (الأصلي - لم يمس)
    ClientBypass = function(id)
        STOP_ALL_FLAG = false
        local payload = { gamepassId = id, playerId = plr.UserId, timestamp = os.time(), purchaseType = "Gamepass" }
        for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
            if STOP_ALL_FLAG then print("⛔ Client Bypass stopped"); break end
            if remote:IsA("RemoteEvent") then
                pcall(function() remote:FireServer(payload) end)
            end
        end
        return true
    end,

    -- 2. Remote Spy & Replay (الأصلي - لم يمس)
    RemoteReplay = function(id)
        STOP_ALL_FLAG = false
        local payload = { gamepassId = id, playerId = plr.UserId, timestamp = os.time() }
        for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
            if STOP_ALL_FLAG then print("⛔ Remote Replay stopped"); break end
            if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                pcall(function()
                    remote:FireServer(payload)
                    remote:FireServer({payload})
                    remote:FireServer(id)
                end)
            end
        end
        return true
    end
}

-- ================================================
-- 🎮 تنفيذ الهجوم (ORIGINAL - UNTOUCHED)
-- ================================================
local function ExecuteAttack(methodName, methodFunc, productId, productName)
    if not productId then
        Rayfield:Notify({ Title = "Error", Content = "Select a Gamepass first!", Duration = 2, Image = 4483362458 })
        return
    end

    local success = methodFunc(productId)

    if success then
        ATTACK_HISTORY[productId] = os.time()
        Rayfield:Notify({ Title = "✅ Attack Sent", Content = methodName .. " on: " .. productName, Duration = 4, Image = 4483362458 })
    end
end

-- ================================================
-- 🎨 RAYFIELD UI
-- ================================================
local Window = Rayfield:CreateWindow({
    Name = "Be Magic",
    LoadingTitle = "Be Magic - Original Edition",
    LoadingSubtitle = "Client Bypass + Remote Replay",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false
})

-- ================================================
-- 📋 TAB 1: GAMEPASS (ORIGINAL - UNTOUCHED)
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
-- 💰 TAB 2: BUY (2 METHODS + STOP)
-- ================================================
local BuyTab = Window:CreateTab("Buy", 4483362458)

BuyTab:CreateParagraph({ Title = "Current Target", Content = "Select Gamepass first!" })

-- ⛔ زر الإيقاف الفوري
BuyTab:CreateButton({
    Name = "⛔ STOP ALL (Instant)",
    Callback = function()
        STOP_ALL_ATTACKS()
    end,
})

BuyTab:CreateParagraph({ Title = "━━━━━━━━━━━━━━━━━━━━", Content = "" })

BuyTab:CreateButton({
    Name = "🕵️ Client Bypass",
    Callback = function()
        ExecuteAttack("Client Bypass", ARSENAL.ClientBypass, SELECTED_GAMEPASS, SELECTED_GAMEPASS_NAME)
    end,
})

BuyTab:CreateButton({
    Name = "🔄 Remote Spy & Replay",
    Callback = function()
        ExecuteAttack("Remote Replay", ARSENAL.RemoteReplay, SELECTED_GAMEPASS, SELECTED_GAMEPASS_NAME)
    end,
})

BuyTab:CreateParagraph({ Title = "Features", Content = "⚡ 2 Methods\n🛡️ Protected\n⛔ Instant Stop\n🔧 Original Code Untouched" })

-- ================================================
-- 🚀 بدء التشغيل
-- ================================================
LOAD_GAMEPASSES()
local options = {}
for _, gp in ipairs(GAMEPASS_LIST) do table.insert(options, gp.name) end
GamepassDropdown:Refresh(options)

print("\n" .. string.rep("⚡", 40))
print("🔥 BE MAGIC - ORIGINAL EDITION")
print("🎯 Client Bypass + Remote Replay")
print("⛔ Instant STOP Active")
print("🛡️ Protected + Original Code")
print(string.rep("⚡", 40))
