-- =====================================================
-- 💀 MOZER - THE FINAL HUNTER
-- ⚡ SUPPORTS: Gamepasses | Remotes | Scripts | 7 Attack Methods
-- 📱 FULL MOBILE UI | DRAG | MINIMIZE | ALL IN ONE
-- =====================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local plr = Players.LocalPlayer

-- =====================================================
-- المتغيرات العامة
-- =====================================================
local allGamepasses = {}
local allRemotes = {}
local allScripts = {}
local mainFrame = nil
local rightContent = nil
local miniBtn = nil
local currentTab = "Gamepasses"
local selectedRemoteForAttack = nil
local selectedRemoteName = "None"

-- =====================================================
-- 1. جلب Gamepasses الحقيقية
-- =====================================================
local function fetchGamepasses()
    allGamepasses = {}
    local gameId = game.PlaceId
    local url = "https://economy.roblox.com/v1/games/" .. gameId .. "/gamepasses?limit=100"
    
    local success, response = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    
    if success and response and response.data then
        for _, gp in ipairs(response.data) do
            table.insert(allGamepasses, {id = gp.id, name = gp.name, price = gp.price or 0})
        end
    end
    return #allGamepasses
end

-- =====================================================
-- 2. جلب الـ Remotes والأكواد
-- =====================================================
local function fetchRemotesAndScripts()
    allRemotes = {}
    allScripts = {}
    
    local function scan(container, sourcePath)
        for _, obj in pairs(container:GetChildren()) do
            if obj:IsA("LocalScript") or obj:IsA("Script") or obj:IsA("ModuleScript") then
                table.insert(allScripts, {name = obj.Name, source = obj.Source or "No source", class = obj.ClassName, path = obj:GetFullName(), ref = obj})
            end
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                local scriptsInside = {}
                for _, child in pairs(obj:GetChildren()) do
                    if child:IsA("LocalScript") or child:IsA("Script") then
                        table.insert(scriptsInside, {name = child.Name, source = child.Source or "No source", class = child.ClassName})
                        table.insert(allScripts, {name = child.Name, source = child.Source or "No source", class = child.ClassName, path = child:GetFullName(), ref = child})
                    end
                end
                table.insert(allRemotes, {name = obj.Name, path = obj:GetFullName(), className = obj.ClassName, ref = obj, scripts = scriptsInside})
            end
            scan(obj, sourcePath .. "/" .. obj.Name)
        end
    end
    
    scan(ReplicatedStorage, "ReplicatedStorage")
    scan(ServerScriptService, "ServerScriptService")
    scan(plr.PlayerGui, "PlayerGui")
    scan(workspace, "Workspace")
    return #allRemotes, #allScripts
end

-- =====================================================
-- 3. طرق الهجوم (7 Methods)
-- =====================================================
local function method1_ClientBypass(id, name)
    local payload = {gamepassId = id, playerId = plr.UserId, timestamp = os.time(), signature = HttpService:GenerateGUID(false)}
    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do if remote:IsA("RemoteEvent") then pcall(function() remote:FireServer(payload) end) end end
    pcall(function() MarketplaceService:PromptProductPurchase(plr, id) end)
    print("💀 [Method 1] Executed on: " .. name)
end

local function method2_Spam(id, name)
    local payload = {action = "spam", playerId = plr.UserId}
    for i = 1, 100 do task.spawn(function() for _, remote in pairs(ReplicatedStorage:GetDescendants()) do if remote:IsA("RemoteEvent") then pcall(function() remote:FireServer(payload) end) end end end) task.wait(0.01) end
    print("💀 [Method 2] Spam on: " .. name)
end

local function method3_LogicExploit(remoteRef, remoteName)
    if not remoteRef then print("❌ Select a Remote first") return end
    local payloads = {{action = "purchase", itemId = 1, player = plr.UserId}, {action = "give", item = "Sword", to = plr.UserId}, {Action = "Grant", UserId = plr.UserId}, {cmd = "give", args = {"Sword", plr.UserId}}}
    for _, p in ipairs(payloads) do pcall(function() if remoteRef:IsA("RemoteEvent") then remoteRef:FireServer(p) elseif remoteRef:IsA("RemoteFunction") then remoteRef:InvokeServer(p) end end) task.wait(0.05) end
    print("💀 [Method 3] Logic exploit on: " .. remoteName)
end

local function method4_Fuzzing(remoteRef, remoteName)
    if not remoteRef then print("❌ Select a Remote first") return end
    local fuzz = {nil, {}, {data = "test"}, "string", 123456, true, {a = 1, b = 2}}
    for _, p in ipairs(fuzz) do pcall(function() if remoteRef:IsA("RemoteEvent") then remoteRef:FireServer(p) elseif remoteRef:IsA("RemoteFunction") then remoteRef:InvokeServer(p) end end) task.wait(0.03) end
    print("💀 [Method 4] Fuzzing on: " .. remoteName)
end

local function method5_MITM(remoteRef, remoteName)
    if not remoteRef then print("❌ Select a Remote first") return end
    local spoofedPayload = {action = "intercepted", playerId = plr.UserId, original = "spoofed"}
    pcall(function() if remoteRef:IsA("RemoteEvent") then remoteRef:FireServer(spoofedPayload) elseif remoteRef:IsA("RemoteFunction") then remoteRef:InvokeServer(spoofedPayload) end end)
    print("💀 [Method 5] MITM on: " .. remoteName)
end

local function method6_RemoteReplay(remoteRef, remoteName)
    if not remoteRef then print("❌ Select a Remote first") return end
    local payload = {action = "replay", signature = tostring(os.time())}
    pcall(function() if remoteRef:IsA("RemoteEvent") then remoteRef:FireServer(payload) remoteRef:FireServer({payload}) remoteRef:FireServer(payload, 123) elseif remoteRef:IsA("RemoteFunction") then remoteRef:InvokeServer(payload) remoteRef:InvokeServer({payload}) end end)
    print("💀 [Method 6] Replay on: " .. remoteName)
end

local function method7_FullSiege(id, name)
    method1_ClientBypass(id, name) method2_Spam(id, name)
    print("💀 [Method 7] Full Siege on: " .. name)
end

local function executeRemote(remoteRef, remoteName)
    if not remoteRef then print("❌ No Remote selected") return end
    pcall(function() if remoteRef:IsA("RemoteEvent") then remoteRef:FireServer() elseif remoteRef:IsA("RemoteFunction") then remoteRef:InvokeServer() end end)
    print("💀 [Remote] Executed: " .. remoteName)
end

local function executeScript(scriptRef)
    if not scriptRef then return end
    pcall(function() local c = scriptRef:Clone() c.Parent = plr.Character or plr task.wait(1) c:Destroy() end)
    print("💀 [Script] Executed: " .. scriptRef.Name)
end

-- =====================================================
-- 4. بناء الواجهة (وظائف العرض)
-- =====================================================
local function clearRight()
    for _, c in pairs(rightContent:GetChildren()) do if c.Name ~= "UICorner" then c:Destroy() end end
end

local function showGamepasses()
    clearRight()
    local scroll = Instance.new("ScrollingFrame", rightContent)
    scroll.Size = UDim2.new(1, -10, 1, -10)
    scroll.Position = UDim2.new(0, 5, 0, 5)
    scroll.BackgroundColor3 = Color3.fromRGB(8, 8, 15)
    scroll.ScrollBarThickness = 4
    Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 10)
    
    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0, 5)
    
    for _, gp in ipairs(allGamepasses) do
        local card = Instance.new("Frame", scroll)
        card.Size = UDim2.new(1, -10, 0, 80)
        card.BackgroundColor3 = Color3.fromRGB(20, 10, 10)
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
        
        local nameLabel = Instance.new("TextLabel", card)
        nameLabel.Size = UDim2.new(1, -140, 0, 22)
        nameLabel.Position = UDim2.new(0, 8, 0, 5)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = "🎮 " .. gp.name
        nameLabel.TextColor3 = Color3.fromRGB(255, 150, 100)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 11
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local priceLabel = Instance.new("TextLabel", card)
        priceLabel.Size = UDim2.new(1, -140, 0, 16)
        priceLabel.Position = UDim2.new(0, 8, 0, 28)
        priceLabel.BackgroundTransparency = 1
        priceLabel.Text = "💰 " .. gp.price .. " Robux"
        priceLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        priceLabel.Font = Enum.Font.Gotham
        priceLabel.TextSize = 10
        
        local idLabel = Instance.new("TextLabel", card)
        idLabel.Size = UDim2.new(1, -140, 0, 16)
        idLabel.Position = UDim2.new(0, 8, 0, 46)
        idLabel.BackgroundTransparency = 1
        idLabel.Text = "🆔 ID: " .. gp.id
        idLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
        idLabel.Font = Enum.Font.Gotham
        idLabel.TextSize = 9
        
        local copyBtn = Instance.new("TextButton", card)
        copyBtn.Size = UDim2.new(0, 40, 0, 28)
        copyBtn.Position = UDim2.new(1, -130, 0, 8)
        copyBtn.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
        copyBtn.Text = "📋"
        copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        copyBtn.Font = Enum.Font.GothamBold
        copyBtn.TextSize = 14
        Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 6)
        copyBtn.MouseButton1Click:Connect(function() setclipboard(tostring(gp.id)) copyBtn.Text = "✓" copyBtn.BackgroundColor3 = Color3.fromRGB(0,150,0) task.delay(1, function() if copyBtn then copyBtn.Text = "📋" copyBtn.BackgroundColor3 = Color3.fromRGB(60,20,20) end end) end)
        
        local m1 = Instance.new("TextButton", card)
        m1.Size = UDim2.new(0, 40, 0, 28)
        m1.Position = UDim2.new(1, -85, 0, 8)
        m1.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
        m1.Text = "1"
        m1.TextColor3 = Color3.fromRGB(255,255,255)
        m1.Font = Enum.Font.GothamBold
        m1.TextSize = 14
        Instance.new("UICorner", m1).CornerRadius = UDim.new(0, 6)
        m1.MouseButton1Click:Connect(function() method1_ClientBypass(gp.id, gp.name) m1.BackgroundColor3 = Color3.fromRGB(0,150,0) task.delay(0.5, function() if m1 then m1.BackgroundColor3 = Color3.fromRGB(80,20,20) end end) end)
        
        local m6 = Instance.new("TextButton", card)
        m6.Size = UDim2.new(0, 40, 0, 28)
        m6.Position = UDim2.new(1, -40, 0, 8)
        m6.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
        m6.Text = "6"
        m6.TextColor3 = Color3.fromRGB(255,255,255)
        m6.Font = Enum.Font.GothamBold
        m6.TextSize = 14
        Instance.new("UICorner", m6).CornerRadius = UDim.new(0, 6)
        m6.MouseButton1Click:Connect(function() method6_RemoteReplay(gp.id, gp.name) m6.BackgroundColor3 = Color3.fromRGB(0,150,0) task.delay(0.5, function() if m6 then m6.BackgroundColor3 = Color3.fromRGB(80,20,20) end end) end)
    end
    
    local count = Instance.new("TextLabel", scroll)
    count.Size = UDim2.new(1, -10, 0, 25)
    count.Position = UDim2.new(0, 5, 0, 5)
    count.BackgroundTransparency = 1
    count.Text = "💀 GAMEPASSES: " .. #allGamepasses
    count.TextColor3 = Color3.fromRGB(255, 50, 50)
    count.Font = Enum.Font.GothamBold
    count.TextSize = 12
    
    local function update() scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 50) end
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(update)
    task.wait(0.05) update()
end

local function showRemotes()
    clearRight()
    local scroll = Instance.new("ScrollingFrame", rightContent)
    scroll.Size = UDim2.new(1, -10, 1, -10)
    scroll.Position = UDim2.new(0, 5, 0, 5)
    scroll.BackgroundColor3 = Color3.fromRGB(8, 8, 15)
    scroll.ScrollBarThickness = 4
    Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 10)
    
    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0, 5)
    
    for _, remote in ipairs(allRemotes) do
        local card = Instance.new("Frame", scroll)
        card.Size = UDim2.new(1, -10, 0, 100 + (#remote.scripts * 28))
        card.BackgroundColor3 = Color3.fromRGB(20, 10, 10)
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
        
        local nameLabel = Instance.new("TextLabel", card)
        nameLabel.Size = UDim2.new(1, -120, 0, 22)
        nameLabel.Position = UDim2.new(0, 8, 0, 5)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = "📡 " .. remote.name .. " (" .. remote.className .. ")"
        nameLabel.TextColor3 = Color3.fromRGB(255, 150, 100)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 11
        
        local pathLabel = Instance.new("TextLabel", card)
        pathLabel.Size = UDim2.new(1, -120, 0, 30)
        pathLabel.Position = UDim2.new(0, 8, 0, 28)
        pathLabel.BackgroundTransparency = 1
        pathLabel.Text = remote.path
        pathLabel.TextColor3 = Color3.fromRGB(140, 140, 160)
        pathLabel.Font = Enum.Font.Gotham
        pathLabel.TextSize = 8
        pathLabel.TextWrapped = true
        
        local selectBtn = Instance.new("TextButton", card)
        selectBtn.Size = UDim2.new(0, 55, 0, 28)
        selectBtn.Position = UDim2.new(1, -62, 0, 5)
        selectBtn.BackgroundColor3 = Color3.fromRGB(100, 20, 20)
        selectBtn.Text = "SELECT"
        selectBtn.TextColor3 = Color3.fromRGB(255,255,255)
        selectBtn.Font = Enum.Font.GothamBold
        selectBtn.TextSize = 9
        Instance.new("UICorner", selectBtn).CornerRadius = UDim.new(0, 6)
        selectBtn.MouseButton1Click:Connect(function() selectedRemoteForAttack = remote.ref selectedRemoteName = remote.name selectBtn.BackgroundColor3 = Color3.fromRGB(0,150,0) selectBtn.Text = "✓ SEL" task.delay(1, function() if selectBtn then selectBtn.BackgroundColor3 = Color3.fromRGB(100,20,20) selectBtn.Text = "SELECT" end end) print("💀 Selected Remote: " .. remote.name) end)
        
        local invokeBtn = Instance.new("TextButton", card)
        invokeBtn.Size = UDim2.new(0, 50, 0, 28)
        invokeBtn.Position = UDim2.new(1, -62, 0, 38)
        invokeBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
        invokeBtn.Text = "INVOKE"
        invokeBtn.TextColor3 = Color3.fromRGB(255,255,255)
        invokeBtn.Font = Enum.Font.GothamBold
        invokeBtn.TextSize = 8
        Instance.new("UICorner", invokeBtn).CornerRadius = UDim.new(0, 6)
        invokeBtn.MouseButton1Click:Connect(function() executeRemote(remote.ref, remote.name) invokeBtn.BackgroundColor3 = Color3.fromRGB(0,150,0) task.delay(0.5, function() if invokeBtn then invokeBtn.BackgroundColor3 = Color3.fromRGB(80,20,20) end end) end)
        
        local yOff = 60
        for _, scr in ipairs(remote.scripts) do
            local sf = Instance.new("Frame", card)
            sf.Size = UDim2.new(1, -20, 0, 26)
            sf.Position = UDim2.new(0, 10, 0, yOff)
            sf.BackgroundColor3 = Color3.fromRGB(25, 15, 15)
            Instance.new("UICorner", sf).CornerRadius = UDim.new(0, 6)
            
            local sl = Instance.new("TextLabel", sf)
            sl.Size = UDim2.new(1, -80, 1, 0)
            sl.Position = UDim2.new(0, 8, 0, 0)
            sl.BackgroundTransparency = 1
            sl.Text = "📜 " .. scr.name
            sl.TextColor3 = Color3.fromRGB(200,200,100)
            sl.Font = Enum.Font.Gotham
            sl.TextSize = 9
            
            local cp = Instance.new("TextButton", sf)
            cp.Size = UDim2.new(0, 45, 0, 22)
            cp.Position = UDim2.new(1, -52, 0, 2)
            cp.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
            cp.Text = "COPY"
            cp.TextColor3 = Color3.fromRGB(255,255,255)
            cp.Font = Enum.Font.GothamBold
            cp.TextSize = 8
            Instance.new("UICorner", cp).CornerRadius = UDim.new(0, 6)
            cp.MouseButton1Click:Connect(function() setclipboard(scr.source) cp.Text = "✓" cp.BackgroundColor3 = Color3.fromRGB(0,150,0) task.delay(1, function() if cp then cp.Text = "COPY" cp.BackgroundColor3 = Color3.fromRGB(60,20,20) end end) end)
            
            yOff = yOff + 28
        end
        
        local copyPath = Instance.new("TextButton", card)
        copyPath.Size = UDim2.new(0, 50, 0, 24)
        copyPath.Position = UDim2.new(1, -62, 0, yOff + 5)
        copyPath.BackgroundColor3 = Color3.fromRGB(50, 20, 20)
        copyPath.Text = "📋"
        copyPath.TextColor3 = Color3.fromRGB(255,255,255)
        copyPath.Font = Enum.Font.GothamBold
        copyPath.TextSize = 12
        Instance.new("UICorner", copyPath).CornerRadius = UDim.new(0, 6)
        copyPath.MouseButton1Click:Connect(function() setclipboard(remote.path) copyPath.Text = "✓" copyPath.BackgroundColor3 = Color3.fromRGB(0,150,0) task.delay(1, function() if copyPath then copyPath.Text = "📋" copyPath.BackgroundColor3 = Color3.fromRGB(50,20,20) end end) end)
    end
    
    local count = Instance.new("TextLabel", scroll)
    count.Size = UDim2.new(1, -10, 0, 25)
    count.Position = UDim2.new(0, 5, 0, 5)
    count.BackgroundTransparency = 1
    count.Text = "💀 REMOTES: " .. #allRemotes
    count.TextColor3 = Color3.fromRGB(255, 50, 50)
    count.Font = Enum.Font.GothamBold
    count.TextSize = 12
    
    local function update() scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 50) end
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(update)
    task.wait(0.05) update()
end

local function showScripts()
    clearRight()
    local scroll = Instance.new("ScrollingFrame", rightContent)
    scroll.Size = UDim2.new(1, -10, 1, -10)
    scroll.Position = UDim2.new(0, 5, 0, 5)
    scroll.BackgroundColor3 = Color3.fromRGB(8, 8, 15)
    scroll.ScrollBarThickness = 4
    Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 10)
    
    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0, 5)
    
    for _, scr in ipairs(allScripts) do
        local card = Instance.new("Frame", scroll)
        card.Size = UDim2.new(1, -10, 0, 75)
        card.BackgroundColor3 = Color3.fromRGB(20, 10, 10)
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
        
        local nameLabel = Instance.new("TextLabel", card)
        nameLabel.Size = UDim2.new(1, -120, 0, 22)
        nameLabel.Position = UDim2.new(0, 8, 0, 5)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = "📜 " .. scr.name .. " (" .. scr.class .. ")"
        nameLabel.TextColor3 = Color3.fromRGB(255, 150, 100)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 11
        
        local pathLabel = Instance.new("TextLabel", card)
        pathLabel.Size = UDim2.new(1, -120, 0, 30)
        pathLabel.Position = UDim2.new(0, 8, 0, 28)
        pathLabel.BackgroundTransparency = 1
        pathLabel.Text = scr.path
        pathLabel.TextColor3 = Color3.fromRGB(140, 140, 160)
        pathLabel.Font = Enum.Font.Gotham
        pathLabel.TextSize = 8
        pathLabel.TextWrapped = true
        
        local copyBtn = Instance.new("TextButton", card)
        copyBtn.Size = UDim2.new(0, 50, 0, 28)
        copyBtn.Position = UDim2.new(1, -110, 0, 5)
        copyBtn.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
        copyBtn.Text = "COPY"
        copyBtn.TextColor3 = Color3.fromRGB(255,255,255)
        copyBtn.Font = Enum.Font.GothamBold
        copyBtn.TextSize = 9
        Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 6)
        copyBtn.MouseButton1Click:Connect(function() setclipboard(scr.source) copyBtn.Text = "✓" copyBtn.BackgroundColor3 = Color3.fromRGB(0,150,0) task.delay(1, function() if copyBtn then copyBtn.Text = "COPY" copyBtn.BackgroundColor3 = Color3.fromRGB(60,20,20) end end) end)
        
        local execBtn = Instance.new("TextButton", card)
        execBtn.Size = UDim2.new(0, 55, 0, 28)
        execBtn.Position = UDim2.new(1, -52, 0, 5)
        execBtn.BackgroundColor3 = Color3.fromRGB(100, 20, 20)
        execBtn.Text = "EXEC"
        execBtn.TextColor3 = Color3.fromRGB(255,255,255)
        execBtn.Font = Enum.Font.GothamBold
        execBtn.TextSize = 9
        Instance.new("UICorner", execBtn).CornerRadius = UDim.new(0, 6)
        execBtn.MouseButton1Click:Connect(function() executeScript(scr.ref) execBtn.BackgroundColor3 = Color3.fromRGB(0,150,0) task.delay(0.5, function() if execBtn then execBtn.BackgroundColor3 = Color3.fromRGB(100,20,20) end end) end)
    end
    
    local count = Instance.new("TextLabel", scroll)
    count.Size = UDim2.new(1, -10, 0, 25)
    count.Position = UDim2.new(0, 5, 0, 5)
    count.BackgroundTransparency = 1
    count.Text = "💀 SCRIPTS: " .. #allScripts
    count.TextColor3 = Color3.fromRGB(255, 50, 50)
    count.Font = Enum.Font.GothamBold
    count.TextSize = 12
    
    local function update() scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 50) end
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(update)
    task.wait(0.05) update()
end

local function showAttack()
    clearRight()
    
    local targetFrame = Instance.new("Frame", rightContent)
    targetFrame.Size = UDim2.new(0.9, 0, 0, 50)
    targetFrame.Position = UDim2.new(0.05, 0, 0.05, 0)
    targetFrame.BackgroundColor3 = Color3.fromRGB(20, 10, 10)
    Instance.new("UICorner", targetFrame).CornerRadius = UDim.new(0, 8)
    
    local targetLabel = Instance.new("TextLabel", targetFrame)
    targetLabel.Size = UDim2.new(1, -10, 1, 0)
    targetLabel.Position = UDim2.new(0, 5, 0, 0)
    targetLabel.BackgroundTransparency = 1
    targetLabel.Text = "🎯 Selected Remote: " .. selectedRemoteName
    targetLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    targetLabel.Font = Enum.Font.GothamBold
    targetLabel.TextSize = 12
    
    local methods = {
        {name = "1 - Client Bypass", color = Color3.fromRGB(80,20,20), func = function() method1_ClientBypass(0, selectedRemoteName) end},
        {name = "2 - Spam", color = Color3.fromRGB(80,20,20), func = function() method2_Spam(0, selectedRemoteName) end},
        {name = "3 - Logic Exploit", color = Color3.fromRGB(80,20,20), func = function() method3_LogicExploit(selectedRemoteForAttack, selectedRemoteName) end},
        {name = "4 - Fuzzing", color = Color3.fromRGB(80,20,20), func = function() method4_Fuzzing(selectedRemoteForAttack, selectedRemoteName) end},
        {name = "5 - MITM", color = Color3.fromRGB(80,20,20), func = function() method5_MITM(selectedRemoteForAttack, selectedRemoteName) end},
        {name = "6 - Remote Replay", color = Color3.fromRGB(80,20,20), func = function() method6_RemoteReplay(selectedRemoteForAttack, selectedRemoteName) end},
        {name = "7 - Full Siege", color = Color3.fromRGB(100,20,20), func = function() method7_FullSiege(0, selectedRemoteName) end}
    }
    
    for i, m in ipairs(methods) do
        local btn = Instance.new("TextButton", rightContent)
        btn.Size = UDim2.new(0.85, 0, 0, 45)
        btn.Position = UDim2.new(0.075, 0, 0.2 + (i-1) * 0.12, 0)
        btn.BackgroundColor3 = m.color
        btn.Text = m.name
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        btn.MouseButton1Click:Connect(function() if selectedRemoteForAttack or i == 1 or i == 2 or i == 7 then m.func() btn.BackgroundColor3 = Color3.fromRGB(0,150,0) task.delay(0.5, function() if btn then btn.BackgroundColor3 = m.color end end) else print("❌ Select a Remote from 'REMOTES' tab first") end end)
    end
end

-- =====================================================
-- 5. السحب والواجهة الرئيسية
-- =====================================================
local function makeDraggable(frame)
    local dragging, dragStart, startPos = false
    frame.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = i.Position
            startPos = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = i.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    frame.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

local function buildUI()
    local old = plr.PlayerGui:FindFirstChild("FinalHunter")
    if old then old:Destroy() end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FinalHunter"
    screenGui.Parent = plr.PlayerGui
    screenGui.ResetOnSpawn = false
    
    mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Size = UDim2.new(0, 480, 0, 540)
    mainFrame.Position = UDim2.new(0.5, -240, 0.15, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(8, 0, 0)
    mainFrame.BorderSizePixel = 0
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 14)
    
    local titleBar = Instance.new("Frame", mainFrame)
    titleBar.Size = UDim2.new(1, 0, 0, 45)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
    Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 14)
    
    local dragIcon = Instance.new("TextLabel", titleBar)
    dragIcon.Size = UDim2.new(0, 40, 1, 0)
    dragIcon.Position = UDim2.new(0, 5, 0, 0)
    dragIcon.BackgroundTransparency = 1
    dragIcon.Text = "☰"
    dragIcon.TextColor3 = Color3.fromRGB(200, 0, 0)
    dragIcon.Font = Enum.Font.Gotham
    dragIcon.TextSize = 24
    
    local title = Instance.new("TextLabel", titleBar)
    title.Size = UDim2.new(0.7, 0, 1, 0)
    title.Position = UDim2.new(0, 50, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "💀 FINAL HUNTER 💀"
    title.TextColor3 = Color3.fromRGB(255, 0, 0)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    
    local minimizeBtn = Instance.new("TextButton", titleBar)
    minimizeBtn.Size = UDim2.new(0, 38, 0, 38)
    minimizeBtn.Position = UDim2.new(1, -45, 0, 3)
    minimizeBtn.Text = "✕"
    minimizeBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
    minimizeBtn.BackgroundTransparency = 1
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.TextSize = 22
    
    local tabBar = Instance.new("Frame", mainFrame)
    tabBar.Size = UDim2.new(1, 0, 0, 40)
    tabBar.Position = UDim2.new(0, 0, 0, 45)
    tabBar.BackgroundTransparency = 1
    
    local tabs = {
        {name = "💀 GAMEPASSES", color = Color3.fromRGB(30,0,0), page = showGamepasses},
        {name = "📡 REMOTES", color = Color3.fromRGB(20,0,0), page = showRemotes},
        {name = "📜 SCRIPTS", color = Color3.fromRGB(20,0,0), page = showScripts},
        {name = "⚔️ ATTACK", color = Color3.fromRGB(20,0,0), page = showAttack}
    }
    
    local tabButtons = {}
    for i, t in ipairs(tabs) do
        local btn = Instance.new("TextButton", tabBar)
        btn.Size = UDim2.new(0.25, -5, 1, 0)
        btn.Position = UDim2.new((i-1) * 0.25 + 0.02, 0, 0, 0)
        btn.BackgroundColor3 = t.color
        btn.Text = t.name
        btn.TextColor3 = Color3.fromRGB(200, 100, 100)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        btn.MouseButton1Click:Connect(function()
            for _, b in ipairs(tabButtons) do b.BackgroundColor3 = Color3.fromRGB(20,0,0) end
            btn.BackgroundColor3 = Color3.fromRGB(30,0,0)
            t.page()
        end)
        tabButtons[i] = btn
    end
    
    rightContent = Instance.new("Frame", mainFrame)
    rightContent.Size = UDim2.new(1, -20, 1, -105)
    rightContent.Position = UDim2.new(0, 10, 0, 95)
    rightContent.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
    Instance.new("UICorner", rightContent).CornerRadius = UDim.new(0, 12)
    
    makeDraggable(mainFrame)
    
    minimizeBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
        if miniBtn then miniBtn.Visible = true end
    end)
    
    showGamepasses()
end

-- =====================================================
-- 6. زر التصغير
-- =====================================================
local function createMinimizeButton()
    local gui = Instance.new("ScreenGui")
    gui.Name = "MinimizeBtn"
    gui.Parent = plr.PlayerGui
    gui.ResetOnSpawn = false
    
    miniBtn = Instance.new("TextButton", gui)
    miniBtn.Size = UDim2.new(0, 65, 0, 65)
    miniBtn.Position = UDim2.new(0.03, 0, 0.75, 0)
    miniBtn.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
    miniBtn.Text = "M"
    miniBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
    miniBtn.Font = Enum.Font.FredokaOne
    miniBtn.TextSize = 34
    miniBtn.Visible = false
    Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0, 14)
    
    task.spawn(function() while true do local h = tick() % 5 / 5 miniBtn.TextColor3 = Color3.fromHSV(h, 1, 1) task.wait(0.15) end end)
    
    miniBtn.MouseButton1Click:Connect(function()
        local f = plr.PlayerGui:FindFirstChild("FinalHunter")
        if f and f:FindFirstChildWhichIsA("Frame") then f:FindFirstChildWhichIsA("Frame").Visible = true miniBtn.Visible = false
        else buildUI() miniBtn.Visible = false end
    end)
    makeDraggable(miniBtn)
end

-- =====================================================
-- 7. التشغيل
-- =====================================================
fetchGamepasses()
fetchRemotesAndScripts()
createMinimizeButton()
buildUI()

print("\n💀 =====================================================")
print("💀 MOZER - THE FINAL HUNTER")
print("💀 Gamepasses: " .. #allGamepasses)
print("💀 Remotes: " .. #allRemotes)
print("💀 Scripts: " .. #allScripts)
print("💀 =====================================================")
print("💀 4 TABS: GAMEPASSES | REMOTES | SCRIPTS | ATTACK")
print("💀 On REMOTES: SELECT a target, then go to ATTACK")
print("💀 7 Attack Methods available")
print("💀 =====================================================")
