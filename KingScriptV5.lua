-- =====================================================
-- 🛡️ ANTI-LAG SYSTEM + MONITOR
-- =====================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer

-- =====================================================
-- واجهة سوداء بسيطة (قابلة للسحب)
-- =====================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AntiLagUI"
ScreenGui.Parent = LocalPlayer.PlayerGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.5, -150, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0.8, 0, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🛡️ Anti-Lag System"
TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 3)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.Parent = TitleBar

-- زر ON/OFF
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 40)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.25, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
ToggleBtn.Text = "🟢 Anti-Lag ON"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14
ToggleBtn.Parent = MainFrame
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 10)

-- زر تنظيف يدوي
local CleanBtn = Instance.new("TextButton")
CleanBtn.Size = UDim2.new(0.8, 0, 0, 35)
CleanBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
CleanBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
CleanBtn.Text = "🧹 Clean Parts Now"
CleanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CleanBtn.Font = Enum.Font.GothamBold
CleanBtn.TextSize = 13
CleanBtn.Parent = MainFrame
Instance.new("UICorner", CleanBtn).CornerRadius = UDim.new(0, 10)

-- نص الحالة
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.9, 0, 0, 30)
StatusLabel.Position = UDim2.new(0.05, 0, 0.85, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "✅ System Ready"
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.Parent = MainFrame

-- =====================================================
-- المتغيرات
-- =====================================================
local isActive = true
local connections = {}

-- =====================================================
-- السحب باللمس
-- =====================================================
local UIS = game:GetService("UserInputService")
local dragData = {dragging = false, startPos = nil, startMouse = nil}

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragData.dragging = true
        dragData.startPos = MainFrame.Position
        dragData.startMouse = Vector2.new(input.Position.X, input.Position.Y)
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragData.dragging then
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = Vector2.new(input.Position.X, input.Position.Y) - dragData.startMouse
            MainFrame.Position = UDim2.new(0, dragData.startPos.X.Offset + delta.X, 0, dragData.startPos.Y.Offset + delta.Y)
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragData.dragging = false
    end
end)

-- =====================================================
-- نظام مكافحة التعلق
-- =====================================================
local function safeLoop(callback, interval)
    interval = interval or 0.1
    task.spawn(function()
        while isActive do
            task.wait(interval)
            pcall(callback)
        end
    end)
end

-- تنظيف الأجزاء الزائدة
local function cleanParts()
    local count = 0
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("Part") and part.Parent == workspace and part.Anchored == false then
            if part:GetMass() > 1000 then
                part:Destroy()
                count = count + 1
            end
        end
    end
    if count > 0 then
        StatusLabel.Text = "🧹 تم حذف " .. count .. " جزء ثقيل"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    end
end

-- مراقبة الأجزاء الجديدة
local function monitorNewParts()
    local conn = workspace.DescendantAdded:Connect(function(part)
        if isActive and part:IsA("Part") and part.Anchored == false then
            if part:GetMass() > 800 then
                Debris:AddItem(part, 5)
            end
        end
    end)
    table.insert(connections, conn)
end

-- =====================================================
-- تشغيل النظام
-- =====================================================
local function startAntiLag()
    isActive = true
    monitorNewParts()
    safeLoop(cleanParts, 15)
    StatusLabel.Text = "🟢 Anti-Lag Active"
    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    ToggleBtn.Text = "🟢 Anti-Lag ON"
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
end

local function stopAntiLag()
    isActive = false
    for _, conn in pairs(connections) do
        pcall(conn.Disconnect, conn)
    end
    connections = {}
    StatusLabel.Text = "🔴 Anti-Lag OFF"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    ToggleBtn.Text = "🔴 Anti-Lag OFF"
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
end

-- =====================================================
-- أزرار التحكم
-- =====================================================
ToggleBtn.MouseButton1Click:Connect(function()
    if isActive then
        stopAntiLag()
    else
        startAntiLag()
    end
end)

CleanBtn.MouseButton1Click:Connect(function()
    StatusLabel.Text = "⏳ جاري التنظيف..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    cleanParts()
    StatusLabel.Text = "✅ تم التنظيف!"
    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- =====================================================
-- بدء التشغيل
-- =====================================================
startAntiLag()
print("🛡️ Anti-Lag System is running!")
