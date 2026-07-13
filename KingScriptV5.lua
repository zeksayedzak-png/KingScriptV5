local Library = {}

Library.__index = Library

local TweenService     = game:GetService("TweenService")

local UserInputService = game:GetService("UserInputService")

local RunService       = game:GetService("RunService")

local Players          = game:GetService("Players")

local SoundService     = game:GetService("SoundService")

local Player    = Players.LocalPlayer

local PlayerGui = Player:WaitForChild("PlayerGui")

local SND_OPEN   = "rbxassetid://122954374321453"

local SND_NOTIFY = "rbxassetid://107978604605265"

local SND_CLICK  = "rbxassetid://100809160609628"

local function playSound(id)

	local s = Instance.new("Sound"); s.SoundId = id; s.Volume = 0.6; s.RollOffMaxDistance = 10000; s.Parent = SoundService; s:Play()

	game:GetService("Debris"):AddItem(s, 4)

end

local BASE_COLORS = {

	Background   = Color3.fromRGB(24,24,24),

	TextWhite    = Color3.fromRGB(235,235,235),

	TextSubtitle = Color3.fromRGB(160,160,160),

	DialogBg     = Color3.fromRGB(40,40,40),

	Border       = Color3.fromRGB(55,55,55),

	ConfigPanel  = Color3.fromRGB(24,24,24),

	TabDefault   = Color3.fromRGB(24,24,24),

	TabHover     = Color3.fromRGB(40,40,40),

	TabSelected  = Color3.fromRGB(44,44,44),

}

local SCROLL_NEUTRAL = Color3.fromRGB(90,90,90)

local THEMES = {

	Blue   = {Accent=Color3.fromRGB(35,85,170),  AccentBright=Color3.fromRGB(55,110,200),  AccentDark=Color3.fromRGB(25,65,140),  AccentDeep=Color3.fromRGB(18,50,115),  AccentGlow=Color3.fromRGB(45,95,185)},

	White  = {Accent=Color3.fromRGB(200,200,200),AccentBright=Color3.fromRGB(230,230,230), AccentDark=Color3.fromRGB(155,155,155),AccentDeep=Color3.fromRGB(115,115,115),AccentGlow=Color3.fromRGB(215,215,215)},

	Red    = {Accent=Color3.fromRGB(170,40,40),  AccentBright=Color3.fromRGB(205,60,60),   AccentDark=Color3.fromRGB(130,25,25),  AccentDeep=Color3.fromRGB(95,18,18),   AccentGlow=Color3.fromRGB(185,50,50)},

	Yellow = {Accent=Color3.fromRGB(175,148,30), AccentBright=Color3.fromRGB(212,178,48),  AccentDark=Color3.fromRGB(135,112,20), AccentDeep=Color3.fromRGB(100,83,14),  AccentGlow=Color3.fromRGB(192,162,38)},

	Grey   = {Accent=Color3.fromRGB(108,108,108),AccentBright=Color3.fromRGB(148,148,148), AccentDark=Color3.fromRGB(78,78,78),   AccentDeep=Color3.fromRGB(55,55,55),   AccentGlow=Color3.fromRGB(122,122,122)},

	Green  = {Accent=Color3.fromRGB(35,140,70),  AccentBright=Color3.fromRGB(55,175,90),   AccentDark=Color3.fromRGB(25,105,50),  AccentDeep=Color3.fromRGB(18,75,35),   AccentGlow=Color3.fromRGB(45,155,80)},

	Purple = {Accent=Color3.fromRGB(110,60,180), AccentBright=Color3.fromRGB(140,85,215),  AccentDark=Color3.fromRGB(85,45,145),  AccentDeep=Color3.fromRGB(60,30,110),  AccentGlow=Color3.fromRGB(125,70,195)},

	Pink   = {Accent=Color3.fromRGB(200,70,130), AccentBright=Color3.fromRGB(230,100,160), AccentDark=Color3.fromRGB(160,50,100), AccentDeep=Color3.fromRGB(120,35,75),  AccentGlow=Color3.fromRGB(215,85,145)},

}

local function buildAccentFromColor(accent)

	return {Accent=accent, AccentBright=accent:Lerp(Color3.new(1,1,1),0.22), AccentDark=accent:Lerp(Color3.new(0,0,0),0.10), AccentDeep=accent:Lerp(Color3.new(0,0,0),0.18), AccentGlow=accent:Lerp(Color3.new(1,1,1),0.08)}

end

local function boostColorGlobal(c, amount)

	local h, s, v = Color3.toHSV(c)

	s = math.min(1, s * (1 + amount))

	v = math.min(1, v * (1 + amount * 0.18))

	return Color3.fromHSV(h, s, v)

end

local function buildColors(themeInput)

	local C = {}

	for k,v in pairs(BASE_COLORS) do C[k]=v end

	if typeof(themeInput)=="Color3" then

		for k,v in pairs(buildAccentFromColor(themeInput)) do C[k]=boostColorGlobal(v,0.45) end

	else

		for k,v in pairs(THEMES[themeInput] or THEMES.Red) do C[k]=boostColorGlobal(v,0.45) end

	end

	return C

end

local FONT       = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)

local FONT_BOLD  = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)

local FONT_LIGHT = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular)

local TWEEN_SMOOTH = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local TWEEN_FAST   = TweenInfo.new(0.2,  Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local TWEEN_MEDIUM = TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local TWEEN_SLOW   = TweenInfo.new(0.6,  Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local MIN_SIZE      = Vector2.new(380,250)

local MAX_SIZE      = Vector2.new(900,650)

local DEFAULT_SIZE  = Vector2.new(520,380)

local HEADER_HEIGHT = 48

local BUTTON_SIZE   = 28

local BUTTON_PADDING= 6

local ICON_SIZE     = 30

local CORNER_RADIUS = 10

local INNER_CORNER  = 8

local TAB_WIDTH     = 170

local TAB_HEIGHT    = 42

local TAB_ICON_SIZE = 18

local TOPBAR_OFFSET = 18

local activeTweens = {}

local function cancelTweens(key)

	if activeTweens[key] then for _,tw in ipairs(activeTweens[key]) do tw:Cancel() end end

	activeTweens[key] = {}

end

local function playTween(key, instance, tweenInfo, props)

	local tw = TweenService:Create(instance, tweenInfo, props)

	if not activeTweens[key] then activeTweens[key] = {} end

	table.insert(activeTweens[key], tw); tw:Play(); return tw

end

local function createCorner(parent, radius)

	local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, radius or CORNER_RADIUS); c.Parent = parent; return c

end

local function createStroke(parent, color, thickness, transparency)

	local s = Instance.new("UIStroke")

	s.Color = color or Color3.fromRGB(55,55,55); s.Thickness = thickness or 1; s.Transparency = transparency or 0.5; s.Parent = parent; return s

end

local function createPadding(parent, top, right, bottom, left)

	local p = Instance.new("UIPadding")

	p.PaddingTop = UDim.new(0,top or 0); p.PaddingRight = UDim.new(0,right or 0)

	p.PaddingBottom = UDim.new(0,bottom or 0); p.PaddingLeft = UDim.new(0,left or 0); p.Parent = parent; return p

end

local function createShadow(parent)

	local s = Instance.new("ImageLabel")

	s.Name = "Shadow"; s.BackgroundTransparency = 1; s.Image = "rbxassetid://6015897843"

	s.ImageColor3 = Color3.fromRGB(0,0,0); s.ImageTransparency = 0.5; s.ScaleType = Enum.ScaleType.Slice

	s.SliceCenter = Rect.new(49,49,450,450); s.Size = UDim2.new(1,30,1,30); s.Position = UDim2.new(0,-15,0,-15); s.ZIndex = -1; s.Parent = parent; return s

end

local function startSlideText(label, container)

	local running = true

	task.spawn(function()

		task.wait(0.5)

		while running and label and label.Parent and container and container.Parent do

			local tw = label.TextBounds.X; local cw = container.AbsoluteSize.X

			if tw > cw then

				local overflow = tw - cw + 20; local duration = overflow / 30

				label.Position = UDim2.new(0,0,0,0); task.wait(1.5)

				if not running or not label.Parent then break end

				local t = TweenService:Create(label, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Position=UDim2.new(0,-overflow,0,0)}); t:Play(); t.Completed:Wait()

				if not running or not label.Parent then break end

				task.wait(1.2); label.Position = UDim2.new(0,0,0,0); task.wait(0.8)

			else label.Position = UDim2.new(0,0,0,0); task.wait(2) end

		end

	end)

	return function() running = false end

end

local function showLoadingScreen(C, onComplete)

	local gui = Instance.new("ScreenGui"); gui.Name = "NightMysticLoading"; gui.ResetOnSpawn = false

	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; gui.IgnoreGuiInset = true; gui.AutoLocalize = false; gui.DisplayOrder = 9999; gui.Parent = PlayerGui

	local overlay = Instance.new("Frame"); overlay.BackgroundColor3 = Color3.fromRGB(0,0,0); overlay.BackgroundTransparency = 1

	overlay.Size = UDim2.new(1,0,1,0); overlay.ZIndex = 1; overlay.Parent = gui

	local CW = 160

	local card = Instance.new("Frame"); card.BackgroundColor3 = BASE_COLORS.Background; card.BackgroundTransparency = 1

	card.AnchorPoint = Vector2.new(0.5,0.5); card.Size = UDim2.new(0,CW,0,CW); card.Position = UDim2.new(0.5,0,0.5,0)

	card.ClipsDescendants = false; card.ZIndex = 2; card.Parent = gui

	local function _cc(p,r) local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r or 10); c.Parent=p; return c end

	local function _cs(p,col,th,tr) local s=Instance.new("UIStroke"); s.Color=col or Color3.fromRGB(55,55,55); s.Thickness=th or 1; s.Transparency=tr or 0.5; s.Parent=p; return s end

	local function _csh(p) local s=Instance.new("ImageLabel"); s.Name="Shadow"; s.BackgroundTransparency=1; s.Image="rbxassetid://6015897843"; s.ImageColor3=Color3.fromRGB(0,0,0); s.ImageTransparency=0.5; s.ScaleType=Enum.ScaleType.Slice; s.SliceCenter=Rect.new(49,49,450,450); s.Size=UDim2.new(1,30,1,30); s.Position=UDim2.new(0,-15,0,-15); s.ZIndex=-1; s.Parent=p; return s end

	_cc(card, 18); local cardStroke = _cs(card, BASE_COLORS.Border, 1, 1)

	local cardShadow = _csh(card); cardShadow.ImageTransparency = 1

	local cardScale = Instance.new("UIScale"); cardScale.Scale = 0.72; cardScale.Parent = card

	local SPIN_SIZE = 96; local RING_R = 34; local N_TOTAL = 90; local N_VISIBLE = 52; local DOT_SIZE = 5

	local spinContainer = Instance.new("Frame"); spinContainer.BackgroundTransparency = 1

	spinContainer.AnchorPoint = Vector2.new(0.5,0.5); spinContainer.Size = UDim2.new(0,SPIN_SIZE,0,SPIN_SIZE)

	spinContainer.Position = UDim2.new(0.5,0,0.5,0); spinContainer.ZIndex = 3; spinContainer.Parent = card

	local trackRing = Instance.new("Frame"); trackRing.BackgroundTransparency = 1

	trackRing.AnchorPoint = Vector2.new(0.5,0.5); trackRing.Size = UDim2.new(0,RING_R*2+2,0,RING_R*2+2)

	trackRing.Position = UDim2.new(0.5,0,0.5,0); trackRing.ZIndex = 2; trackRing.Parent = spinContainer

	local trackStroke = Instance.new("UIStroke"); trackStroke.Color = BASE_COLORS.Border

	trackStroke.Thickness = 1.5; trackStroke.Transparency = 0.6; trackStroke.Parent = trackRing

	Instance.new("UICorner", trackRing).CornerRadius = UDim.new(1,0)

	local cx, cy = SPIN_SIZE/2, SPIN_SIZE/2

	local allSegs = {}; local headGlow1, headGlow2

	for i = 0, N_VISIBLE - 1 do

		local angle = math.rad(i * (360 / N_TOTAL))

		local px = cx + RING_R * math.sin(angle); local py = cy - RING_R * math.cos(angle)

		local t = i / (N_VISIBLE - 1)

		local segColor, segTrans, segSize

		if i == 0 then segSize = DOT_SIZE+3; segColor = Color3.new(1,1,1); segTrans = 0

		elseif t < 0.12 then local f=t/0.12; segSize=DOT_SIZE+math.round((1-f)*2); segColor=Color3.new(1,1,1):Lerp(C.AccentBright,f); segTrans=f*0.04

		elseif t < 0.4 then local f=(t-0.12)/0.28; segSize=DOT_SIZE; segColor=C.AccentBright:Lerp(C.Accent,f); segTrans=0.04+f*0.32

		elseif t < 0.68 then local f=(t-0.4)/0.28; segSize=DOT_SIZE; segColor=C.Accent:Lerp(C.AccentDark,f); segTrans=0.36+f*0.38

		else local f=(t-0.68)/0.32; segSize=math.max(3,DOT_SIZE-math.floor(f*2)); segColor=C.AccentDark; segTrans=0.74+f*0.26 end

		local seg = Instance.new("Frame"); seg.BackgroundColor3 = segColor; seg.BackgroundTransparency = segTrans; seg.BorderSizePixel = 0

		seg.Size = UDim2.new(0,segSize,0,segSize); seg.Position = UDim2.new(0,px-segSize/2,0,py-segSize/2); seg.ZIndex = 4; seg.Parent = spinContainer

		Instance.new("UICorner", seg).CornerRadius = UDim.new(1,0); table.insert(allSegs, seg)

		if i == 0 then

			local g1s = DOT_SIZE+12; headGlow1 = Instance.new("Frame"); headGlow1.BackgroundColor3 = C.AccentBright

			headGlow1.BackgroundTransparency = 0.5; headGlow1.BorderSizePixel = 0

			headGlow1.Size = UDim2.new(0,g1s,0,g1s); headGlow1.Position = UDim2.new(0.5,-g1s/2,0.5,-g1s/2)

			headGlow1.ZIndex = 3; headGlow1.Parent = seg; Instance.new("UICorner",headGlow1).CornerRadius = UDim.new(1,0)

			local g2s = DOT_SIZE+24; headGlow2 = Instance.new("Frame"); headGlow2.BackgroundColor3 = C.Accent

			headGlow2.BackgroundTransparency = 0.82; headGlow2.BorderSizePixel = 0

			headGlow2.Size = UDim2.new(0,g2s,0,g2s); headGlow2.Position = UDim2.new(0.5,-g2s/2,0.5,-g2s/2)

			headGlow2.ZIndex = 2; headGlow2.Parent = seg; Instance.new("UICorner",headGlow2).CornerRadius = UDim.new(1,0)

			task.spawn(function()

				local p1 = TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

				while headGlow1 and headGlow1.Parent do

					TweenService:Create(headGlow1,p1,{BackgroundTransparency=0.28}):Play(); task.wait(0.6)

					TweenService:Create(headGlow1,p1,{BackgroundTransparency=0.58}):Play(); task.wait(0.6)

				end

			end)

		end

	end

	task.delay(0.05, function()

		TweenService:Create(overlay, TWEEN_MEDIUM, {BackgroundTransparency=0.6}):Play()

		TweenService:Create(card, TWEEN_MEDIUM, {BackgroundTransparency=0}):Play()

		TweenService:Create(cardStroke, TWEEN_MEDIUM, {Transparency=0.45}):Play()

		TweenService:Create(cardShadow, TWEEN_SLOW, {ImageTransparency=0.45}):Play()

		TweenService:Create(cardScale, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale=1}):Play()

	end)

	local running = true

	local conn = RunService.Heartbeat:Connect(function(dt)

		if not running then return end

		spinContainer.Rotation = spinContainer.Rotation - dt * 220

	end)

	task.delay(2.8, function()

		running = false; conn:Disconnect()

		local segFade = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

		for _, seg in ipairs(allSegs) do

			TweenService:Create(seg, segFade, {BackgroundTransparency=1}):Play()

			for _, ch in ipairs(seg:GetChildren()) do

				if ch:IsA("Frame") then TweenService:Create(ch, segFade, {BackgroundTransparency=1}):Play() end

			end

		end

		TweenService:Create(trackStroke, segFade, {Transparency=1}):Play()

		local outInfo = TweenInfo.new(0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.In)

		task.delay(0.14, function()

			TweenService:Create(cardScale, outInfo, {Scale=0.82}):Play()

			TweenService:Create(card, outInfo, {BackgroundTransparency=1}):Play()

			TweenService:Create(cardStroke, outInfo, {Transparency=1}):Play()

			TweenService:Create(cardShadow, outInfo, {ImageTransparency=1}):Play()

		end)

		task.delay(0.22, function() TweenService:Create(overlay, outInfo, {BackgroundTransparency=1}):Play() end)

		task.delay(0.62, function() gui:Destroy(); if onComplete then onComplete() end end)

	end)

end

function Library.new()

	local self = setmetatable({}, Library); self._connections = {}; self._windows = {}; return self

end

function Library:NewWindow(config)

	config = config or {}

	local title    = config.Title    or "Night Mystic"

	local subtitle = config.Subtitle or "Blox Fruits"

	local icon     = config.Icon     or "rbxassetid://81844334586058"

	local size     = config.Size     or DEFAULT_SIZE

	local C        = buildColors(config.Theme or "Red")

	local windowData = {

		minimized=false, maximized=false, configOpen=false, hidden=false,

		acrylicEnabled=false, acrylicOpacity=0.55, wallpaperOpacity=0.75, backgroundImageId="", customColorHex="",

		preMaxSize=nil, preMaxPos=nil, preMinSize=nil,

		dragging=false, resizing=false, destroyed=false,

		connections={}, tabs={}, selectedTab=nil,

		accentElems={}, themeCallbacks={}, titleSegments={},

		searchRegistry={}, componentRegistry={}, loadedComponentState={},

	}

	local pendingDefaults = {}

	local function regAccent(inst, prop, colorKey)

		table.insert(windowData.accentElems, {inst=inst, prop=prop, key=colorKey})

	end

	local function regTheme(cb)

		table.insert(windowData.themeCallbacks, cb)

	end

	local function registerComponent(saveId, kind, object)

		if not saveId or saveId == "" then return end

		windowData.componentRegistry[saveId] = {kind=kind, object=object}

		local pending = windowData.loadedComponentState[saveId]

		if pending ~= nil then

			table.insert(pendingDefaults, function() pcall(function() object:Set(pending) end) end)

		end

	end

	local function addGlowHover(frame, tweenKeyBase)

		createCorner(frame, 6)

		local glow = Instance.new("UIStroke"); glow.Color = C.Accent; glow.Thickness = 1; glow.Transparency = 1; glow.Parent = frame

		frame.InputBegan:Connect(function(i)

			if i.UserInputType == Enum.UserInputType.MouseMovement then

				glow.Color = C.Accent; cancelTweens(tweenKeyBase.."_glow"); playTween(tweenKeyBase.."_glow", glow, TWEEN_FAST, {Transparency=0.55})

			end

		end)

		frame.InputEnded:Connect(function(i)

			if i.UserInputType == Enum.UserInputType.MouseMovement then

				cancelTweens(tweenKeyBase.."_glow"); playTween(tweenKeyBase.."_glow", glow, TWEEN_FAST, {Transparency=1})

			end

		end)

		return glow

	end

	for _, existing in ipairs(PlayerGui:GetChildren()) do

		if existing.Name == "NightMysticUI" or existing.Name == "NightMysticFloat" or existing.Name == "NightMysticNotify" then existing:Destroy() end

	end

	local screenGui = Instance.new("ScreenGui"); screenGui.Name = "NightMysticUI"; screenGui.ResetOnSpawn = false

	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; screenGui.IgnoreGuiInset = true; screenGui.AutoLocalize = false; screenGui.Parent = PlayerGui

	local mainFrame = Instance.new("Frame"); mainFrame.Name = "Window"; mainFrame.BackgroundColor3 = C.Background

	mainFrame.Size = UDim2.new(0, size.X, 0, 0)

	mainFrame.Position = UDim2.new(0.5, -size.X/2, 0.5, TOPBAR_OFFSET - size.Y/2)

	mainFrame.BackgroundTransparency = 1; mainFrame.ClipsDescendants = true; mainFrame.Visible = false; mainFrame.Parent = screenGui

	createCorner(mainFrame, CORNER_RADIUS)

	local mainStroke = createStroke(mainFrame, Color3.fromRGB(55,55,55), 1, 1)

	local initShadow = createShadow(mainFrame); initShadow.ImageTransparency = 1

	local themeBackground = Instance.new("ImageLabel"); themeBackground.Name = "ThemeBackground"
	themeBackground.BackgroundTransparency = 1; themeBackground.Size = UDim2.new(1,0,1,0)
	themeBackground.Position = UDim2.new(0,0,0,0); themeBackground.ZIndex = 0
	themeBackground.ScaleType = Enum.ScaleType.Crop; themeBackground.ClipsDescendants = true
	themeBackground.ImageTransparency = 1 - windowData.wallpaperOpacity
	themeBackground.Visible = false; themeBackground.Image = ""
	themeBackground.Parent = mainFrame
	createCorner(themeBackground, CORNER_RADIUS)

	local blurFrame = Instance.new("Frame"); blurFrame.BackgroundColor3 = Color3.fromRGB(0,0,0); blurFrame.BackgroundTransparency = 1

	blurFrame.Size = UDim2.new(1,0,1,0); blurFrame.ZIndex = 50; blurFrame.Visible = false; blurFrame.Parent = mainFrame

	createCorner(blurFrame, CORNER_RADIUS)

	local header = Instance.new("Frame"); header.BackgroundTransparency = 1; header.Size = UDim2.new(1,0,0,HEADER_HEIGHT)

	header.BorderSizePixel = 0; header.ZIndex = 5; header.Parent = mainFrame

	local headerDivider = Instance.new("Frame"); headerDivider.BackgroundColor3 = C.Border; headerDivider.BackgroundTransparency = 0.7

	headerDivider.Size = UDim2.new(0.92,0,0,1); headerDivider.Position = UDim2.new(0.04,0,1,0); headerDivider.BorderSizePixel = 0; headerDivider.ZIndex = 6; headerDivider.Parent = header

	regAccent(headerDivider, "BackgroundColor3", "Border")

	local headerLeft = Instance.new("Frame"); headerLeft.BackgroundTransparency = 1; headerLeft.Size = UDim2.new(0.6,0,1,0); headerLeft.ZIndex = 6; headerLeft.Parent = header

	local leftLayout = Instance.new("UIListLayout"); leftLayout.FillDirection = Enum.FillDirection.Horizontal; leftLayout.VerticalAlignment = Enum.VerticalAlignment.Center

	leftLayout.Padding = UDim.new(0,8); leftLayout.SortOrder = Enum.SortOrder.LayoutOrder; leftLayout.Parent = headerLeft

	createPadding(headerLeft, 0, 0, 0, 12)

	if icon ~= "" then

		local iconImage = Instance.new("ImageLabel"); iconImage.BackgroundTransparency = 1; iconImage.Size = UDim2.new(0,ICON_SIZE,0,ICON_SIZE)

		iconImage.Image = icon; iconImage.ImageColor3 = Color3.new(1,1,1); iconImage.LayoutOrder = 1; iconImage.ZIndex = 7; iconImage.Parent = headerLeft; createCorner(iconImage, 6)

	end

	local titleContainer = Instance.new("Frame"); titleContainer.BackgroundTransparency = 1; titleContainer.Size = UDim2.new(0,200,1,0)

	titleContainer.AutomaticSize = Enum.AutomaticSize.X; titleContainer.LayoutOrder = 2; titleContainer.ZIndex = 7; titleContainer.Parent = headerLeft

	local titleVLayout = Instance.new("UIListLayout"); titleVLayout.FillDirection = Enum.FillDirection.Vertical; titleVLayout.VerticalAlignment = Enum.VerticalAlignment.Center

	titleVLayout.Padding = UDim.new(0,1); titleVLayout.SortOrder = Enum.SortOrder.LayoutOrder; titleVLayout.Parent = titleContainer

	local titleRow = Instance.new("Frame"); titleRow.BackgroundTransparency = 1; titleRow.Size = UDim2.new(1,0,0,18)

	titleRow.AutomaticSize = Enum.AutomaticSize.X; titleRow.LayoutOrder = 1; titleRow.ZIndex = 7; titleRow.Parent = titleContainer

	local titleRowLayout = Instance.new("UIListLayout"); titleRowLayout.FillDirection = Enum.FillDirection.Horizontal; titleRowLayout.VerticalAlignment = Enum.VerticalAlignment.Center

	titleRowLayout.Padding = UDim.new(0,4); titleRowLayout.SortOrder = Enum.SortOrder.LayoutOrder; titleRowLayout.Parent = titleRow

	local titleLblMain = Instance.new("TextLabel"); titleLblMain.BackgroundTransparency = 1

	titleLblMain.Size = UDim2.new(0,0,1,0); titleLblMain.AutomaticSize = Enum.AutomaticSize.X

	titleLblMain.FontFace = FONT_BOLD; titleLblMain.TextSize = 15; titleLblMain.TextXAlignment = Enum.TextXAlignment.Left

	titleLblMain.LayoutOrder = 1; titleLblMain.ZIndex = 8; titleLblMain.Text = title; titleLblMain.TextColor3 = Color3.new(1,1,1); titleLblMain.Parent = titleRow

	local titleGradient = Instance.new("UIGradient"); titleGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(1,1,1)), ColorSequenceKeypoint.new(1, C.AccentBright)}); titleGradient.Rotation = 100; titleGradient.Parent = titleLblMain

	regTheme(function() titleGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(1,1,1)), ColorSequenceKeypoint.new(1, C.AccentBright)}) end)

	local subtitleLabel = Instance.new("TextLabel"); subtitleLabel.BackgroundTransparency = 1; subtitleLabel.Size = UDim2.new(1,0,0,13)

	subtitleLabel.AutomaticSize = Enum.AutomaticSize.X; subtitleLabel.FontFace = FONT; subtitleLabel.TextSize = 11

	subtitleLabel.TextColor3 = C.TextSubtitle; subtitleLabel.TextTransparency = 0.3; subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left

	subtitleLabel.Text = subtitle; subtitleLabel.LayoutOrder = 2; subtitleLabel.ZIndex = 8; subtitleLabel.Parent = titleContainer

	regAccent(subtitleLabel, "TextColor3", "TextSubtitle")

	local headerRight = Instance.new("Frame"); headerRight.BackgroundTransparency = 1; headerRight.Size = UDim2.new(0.4,0,1,0)

	headerRight.Position = UDim2.new(0.6,0,0,0); headerRight.ZIndex = 6; headerRight.Parent = header

	local rightLayout = Instance.new("UIListLayout"); rightLayout.FillDirection = Enum.FillDirection.Horizontal; rightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right

	rightLayout.VerticalAlignment = Enum.VerticalAlignment.Center; rightLayout.Padding = UDim.new(0,BUTTON_PADDING); rightLayout.SortOrder = Enum.SortOrder.LayoutOrder; rightLayout.Parent = headerRight

	createPadding(headerRight, 0, 12, 0, 0)

	local buttonDefs = {

		{name="Config",   icon="rbxassetid://123669217353469", order=1},

		{name="Minimize", icon="rbxassetid://72319180199150",  order=2},

		{name="Maximize", icon="rbxassetid://100039729329934", order=3},

		{name="Close",    icon="rbxassetid://113006594954898", order=4},

	}

	local buttons = {}; local btnIcons = {}

	for _, def in ipairs(buttonDefs) do

		local btn = Instance.new("ImageButton"); btn.BackgroundColor3 = C.Background; btn.BackgroundTransparency = 0.5; btn.Size = UDim2.new(0,BUTTON_SIZE,0,BUTTON_SIZE)

		btn.LayoutOrder = def.order; btn.AutoButtonColor = false; btn.ZIndex = 7; btn.Parent = headerRight

		createCorner(btn, 6)

		local btnStroke = createStroke(btn, C.Border, 1, 0.6)

		regAccent(btn, "BackgroundColor3", "Background")

		regTheme(function() btnStroke.Color = C.Border end)

		local btnIcon = Instance.new("ImageLabel"); btnIcon.BackgroundTransparency = 1; btnIcon.Size = UDim2.new(0,16,0,16)

		btnIcon.Position = UDim2.new(0.5,-8,0.5,-8); btnIcon.Image = def.icon; btnIcon.ImageColor3 = C.Accent; btnIcon.ZIndex = 8; btnIcon.Parent = btn

		btnIcons[def.name] = btnIcon

		local tk = "btn_"..def.name

		table.insert(windowData.connections, btn.MouseEnter:Connect(function() cancelTweens(tk); playTween(tk, btnIcon, TWEEN_FAST, {Size=UDim2.new(0,20,0,20), Position=UDim2.new(0.5,-10,0.5,-10), ImageColor3=C.AccentBright}); playTween(tk, btn, TWEEN_FAST, {BackgroundTransparency=0.15}); playTween(tk, btnStroke, TWEEN_FAST, {Transparency=0.2, Color=C.Accent}) end))

		table.insert(windowData.connections, btn.MouseLeave:Connect(function() cancelTweens(tk); playTween(tk, btnIcon, TWEEN_FAST, {Size=UDim2.new(0,16,0,16), Position=UDim2.new(0.5,-8,0.5,-8), ImageColor3=C.Accent}); playTween(tk, btn, TWEEN_FAST, {BackgroundTransparency=0.5}); playTween(tk, btnStroke, TWEEN_FAST, {Transparency=0.6, Color=C.Border}) end))

		buttons[def.name] = btn

	end

	local statsFrame = Instance.new("Frame"); statsFrame.BackgroundTransparency = 1

	statsFrame.Size = UDim2.new(0,0,1,0); statsFrame.AutomaticSize = Enum.AutomaticSize.X

	statsFrame.AnchorPoint = Vector2.new(0.5,0); statsFrame.Position = UDim2.new(0.5,0,0,0)

	statsFrame.ZIndex = 6; statsFrame.Visible = false; statsFrame.Parent = header

	local statsLayout = Instance.new("UIListLayout"); statsLayout.FillDirection = Enum.FillDirection.Vertical

	statsLayout.VerticalAlignment = Enum.VerticalAlignment.Center; statsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	statsLayout.Padding = UDim.new(0,1); statsLayout.SortOrder = Enum.SortOrder.LayoutOrder; statsLayout.Parent = statsFrame

	local fpsLabel = Instance.new("TextLabel"); fpsLabel.BackgroundTransparency = 1; fpsLabel.Size = UDim2.new(1,0,0,0); fpsLabel.AutomaticSize = Enum.AutomaticSize.Y

	fpsLabel.FontFace = FONT_BOLD; fpsLabel.TextSize = 13; fpsLabel.TextColor3 = C.AccentBright

	fpsLabel.Text = "FPS: -"; fpsLabel.TextXAlignment = Enum.TextXAlignment.Center

	fpsLabel.LayoutOrder = 1; fpsLabel.ZIndex = 7; fpsLabel.Visible = false; fpsLabel.Parent = statsFrame

	regAccent(fpsLabel, "TextColor3", "AccentBright")

	local pingLabel = Instance.new("TextLabel"); pingLabel.BackgroundTransparency = 1; pingLabel.Size = UDim2.new(1,0,0,0); pingLabel.AutomaticSize = Enum.AutomaticSize.Y

	pingLabel.FontFace = FONT_BOLD; pingLabel.TextSize = 13; pingLabel.TextColor3 = C.AccentBright

	pingLabel.Text = "PING: -"; pingLabel.TextXAlignment = Enum.TextXAlignment.Center

	pingLabel.LayoutOrder = 2; pingLabel.ZIndex = 7; pingLabel.Visible = false; pingLabel.Parent = statsFrame

	regAccent(pingLabel, "TextColor3", "AccentBright")

	local showFpsEnabled = false; local showPingEnabled = false; local profileCardVisible = false

	local fpsCount = 0; local fpsAccum = 0

	local function updateStatsFrame()

		statsFrame.Visible = showFpsEnabled or showPingEnabled

		fpsLabel.Visible = showFpsEnabled; pingLabel.Visible = showPingEnabled

	end

	local statsConn = RunService.Heartbeat:Connect(function(dt)

		fpsCount = fpsCount + 1; fpsAccum = fpsAccum + dt

		if fpsAccum >= 0.5 then

			if showFpsEnabled then fpsLabel.Text = "FPS: "..tostring(math.floor(fpsCount/fpsAccum)) end

			if showPingEnabled then pingLabel.Text = "PING: "..tostring(math.floor(Players.LocalPlayer:GetNetworkPing()*1000)).."ms" end

			fpsCount = 0; fpsAccum = 0

		end

	end)

	table.insert(windowData.connections, statsConn)

	local SEARCH_H = 34

	local searchBar = Instance.new("Frame"); searchBar.BackgroundColor3 = C.Background; searchBar.BackgroundTransparency = 0.75

	searchBar.Size = UDim2.new(0,TAB_WIDTH,0,SEARCH_H); searchBar.Position = UDim2.new(0,0,0,HEADER_HEIGHT+1)

	searchBar.BorderSizePixel = 0; searchBar.ZIndex = 4; searchBar.ClipsDescendants = true; searchBar.Parent = mainFrame

	regAccent(searchBar, "BackgroundColor3", "Background")

	local searchIcon = Instance.new("ImageLabel"); searchIcon.BackgroundTransparency = 1; searchIcon.Size = UDim2.new(0,14,0,14)

	searchIcon.Position = UDim2.new(0,9,0.5,-7); searchIcon.Image = "rbxassetid://115739298989740"

	searchIcon.ImageColor3 = C.TextSubtitle; searchIcon.ZIndex = 5; searchIcon.Parent = searchBar

	local searchInput = Instance.new("TextBox"); searchInput.BackgroundTransparency = 1; searchInput.Size = UDim2.new(1,-32,1,0)

	searchInput.Position = UDim2.new(0,28,0,0); searchInput.FontFace = FONT; searchInput.TextSize = 11

	searchInput.TextColor3 = C.TextWhite; searchInput.PlaceholderColor3 = C.TextSubtitle; searchInput.PlaceholderText = "Search..."

	searchInput.TextXAlignment = Enum.TextXAlignment.Left; searchInput.ClearTextOnFocus = false; searchInput.Text = ""; searchInput.ZIndex = 5; searchInput.Parent = searchBar

	regAccent(searchInput, "TextColor3", "TextWhite"); regAccent(searchInput, "PlaceholderColor3", "TextSubtitle")

	local searchDivider = Instance.new("Frame"); searchDivider.BackgroundColor3 = C.Border; searchDivider.BackgroundTransparency = 0.5

	searchDivider.Size = UDim2.new(1,0,0,1); searchDivider.Position = UDim2.new(0,0,1,-1); searchDivider.BorderSizePixel = 0; searchDivider.ZIndex = 5; searchDivider.Parent = searchBar

	regAccent(searchDivider, "BackgroundColor3", "Border")

	local tabSidebar = Instance.new("ScrollingFrame"); tabSidebar.BackgroundTransparency = 1

	tabSidebar.Size = UDim2.new(0,TAB_WIDTH,1,-HEADER_HEIGHT-1-SEARCH_H); tabSidebar.Position = UDim2.new(0,0,0,HEADER_HEIGHT+1+SEARCH_H)

	tabSidebar.BorderSizePixel = 0; tabSidebar.ScrollBarThickness = 2; tabSidebar.ScrollBarImageColor3 = SCROLL_NEUTRAL

	tabSidebar.ScrollBarImageTransparency = 0.5; tabSidebar.CanvasSize = UDim2.new(0,0,0,0)

	tabSidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y; tabSidebar.ClipsDescendants = true; tabSidebar.ZIndex = 3; tabSidebar.Parent = mainFrame

	local tabListLayout = Instance.new("UIListLayout"); tabListLayout.FillDirection = Enum.FillDirection.Vertical

	tabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; tabListLayout.Padding = UDim.new(0,2)

	tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder; tabListLayout.Parent = tabSidebar

	createPadding(tabSidebar, 4, 4, 4, 4)

	local tabDivider = Instance.new("Frame"); tabDivider.BackgroundColor3 = C.Border; tabDivider.BackgroundTransparency = 0.7

	tabDivider.Size = UDim2.new(0,1,1,-HEADER_HEIGHT-12); tabDivider.Position = UDim2.new(0,TAB_WIDTH,0,HEADER_HEIGHT+6)

	tabDivider.BorderSizePixel = 0; tabDivider.ZIndex = 3; tabDivider.Parent = mainFrame

	regAccent(tabDivider, "BackgroundColor3", "Border")

	local contentFrame = Instance.new("Frame"); contentFrame.BackgroundTransparency = 1

	contentFrame.Size = UDim2.new(1,-TAB_WIDTH-1,1,-HEADER_HEIGHT); contentFrame.Position = UDim2.new(0,TAB_WIDTH+1,0,HEADER_HEIGHT)

	contentFrame.ClipsDescendants = true; contentFrame.ZIndex = 2; contentFrame.Parent = mainFrame

	local searchResultsFrame = Instance.new("ScrollingFrame"); searchResultsFrame.BackgroundTransparency = 1

	searchResultsFrame.Size = UDim2.new(1,-TAB_WIDTH-1,1,-HEADER_HEIGHT); searchResultsFrame.Position = UDim2.new(0,TAB_WIDTH+1,0,HEADER_HEIGHT)

	searchResultsFrame.Visible = false; searchResultsFrame.ZIndex = 10; searchResultsFrame.BorderSizePixel = 0

	searchResultsFrame.ScrollBarThickness = 2; searchResultsFrame.ScrollBarImageColor3 = SCROLL_NEUTRAL; searchResultsFrame.ScrollBarImageTransparency = 0.5

	searchResultsFrame.CanvasSize = UDim2.new(0,0,0,0); searchResultsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

	searchResultsFrame.ClipsDescendants = false; searchResultsFrame.Parent = mainFrame

	local srLayout = Instance.new("UIListLayout"); srLayout.FillDirection = Enum.FillDirection.Vertical; srLayout.Padding = UDim.new(0,6); srLayout.SortOrder = Enum.SortOrder.LayoutOrder; srLayout.Parent = searchResultsFrame

	createPadding(searchResultsFrame, 10, 12, 10, 12)

	local resizeHandle = Instance.new("TextButton"); resizeHandle.BackgroundTransparency = 1; resizeHandle.Size = UDim2.new(0,18,0,18)

	resizeHandle.Position = UDim2.new(1,-18,1,-18); resizeHandle.Text = ""; resizeHandle.ZIndex = 100; resizeHandle.AutoButtonColor = false; resizeHandle.Parent = mainFrame

	local resizeDots = Instance.new("Frame"); resizeDots.BackgroundTransparency = 1; resizeDots.Size = UDim2.new(1,-4,1,-4)

	resizeDots.Position = UDim2.new(0,4,0,4); resizeDots.ZIndex = 101; resizeDots.Parent = resizeHandle

	local resizeDotsList = {}

	for row = 0,2 do for col = 0,2 do if row+col >= 2 then

		local dot = Instance.new("Frame"); dot.BackgroundColor3 = C.Accent; dot.BackgroundTransparency = 0.5

		dot.Size = UDim2.new(0,2,0,2); dot.Position = UDim2.new(0,col*5,0,row*5); dot.BorderSizePixel = 0; dot.ZIndex = 102; dot.Parent = resizeDots; createCorner(dot,1)

		table.insert(resizeDotsList, dot); regAccent(dot, "BackgroundColor3", "Accent")

	end end end

	local configPanel = Instance.new("ScrollingFrame"); configPanel.BackgroundColor3 = C.ConfigPanel; configPanel.Size = UDim2.new(0,220,0,400)

	configPanel.ZIndex = 200; configPanel.ClipsDescendants = true; configPanel.Visible = false; configPanel.BorderSizePixel = 0

	configPanel.ScrollBarThickness = 2; configPanel.ScrollBarImageColor3 = SCROLL_NEUTRAL; configPanel.ScrollBarImageTransparency = 0.6

	configPanel.CanvasSize = UDim2.new(0,0,0,0); configPanel.AutomaticCanvasSize = Enum.AutomaticSize.Y; configPanel.Parent = screenGui

	createCorner(configPanel, INNER_CORNER)

	local configPanelStrokeElem = createStroke(configPanel, C.Border, 1, 0.5)

	regAccent(configPanel, "BackgroundColor3", "ConfigPanel"); regAccent(configPanelStrokeElem, "Color", "Border")

	local configPanelLayout = Instance.new("UIListLayout"); configPanelLayout.FillDirection = Enum.FillDirection.Vertical

	configPanelLayout.Padding = UDim.new(0,6); configPanelLayout.SortOrder = Enum.SortOrder.LayoutOrder; configPanelLayout.Parent = configPanel

	createPadding(configPanel, 12, 12, 40, 12)

	local configTitleLbl = Instance.new("TextLabel"); configTitleLbl.BackgroundTransparency = 1; configTitleLbl.Size = UDim2.new(1,0,0,24)

	configTitleLbl.FontFace = FONT_BOLD; configTitleLbl.TextSize = 13; configTitleLbl.TextColor3 = C.AccentBright

	configTitleLbl.TextXAlignment = Enum.TextXAlignment.Left; configTitleLbl.Text = "Settings"; configTitleLbl.LayoutOrder = 0; configTitleLbl.ZIndex = 201; configTitleLbl.Parent = configPanel

	regAccent(configTitleLbl, "TextColor3", "AccentBright")

	local configDivider = Instance.new("Frame"); configDivider.BackgroundColor3 = C.Border; configDivider.BackgroundTransparency = 0.6

	configDivider.Size = UDim2.new(1,0,0,1); configDivider.LayoutOrder = 1; configDivider.BorderSizePixel = 0; configDivider.ZIndex = 201; configDivider.Parent = configPanel

	regAccent(configDivider, "BackgroundColor3", "Border")

	local saveUISettings

	local initAcrylicOpacity = 0.55

	local opacityRow = Instance.new("Frame"); opacityRow.BackgroundColor3 = C.Background; opacityRow.BackgroundTransparency = 0.85

	opacityRow.Size = UDim2.new(1,0,0,0); opacityRow.AutomaticSize = Enum.AutomaticSize.Y

	opacityRow.LayoutOrder = 2; opacityRow.ZIndex = 201; opacityRow.Parent = configPanel

	createCorner(opacityRow, 6); createPadding(opacityRow, 10, 12, 12, 12)

	regAccent(opacityRow, "BackgroundColor3", "Background")

	local opRowLayout = Instance.new("UIListLayout"); opRowLayout.FillDirection = Enum.FillDirection.Vertical

	opRowLayout.Padding = UDim.new(0,8); opRowLayout.SortOrder = Enum.SortOrder.LayoutOrder; opRowLayout.Parent = opacityRow

	local opTopRow = Instance.new("Frame"); opTopRow.BackgroundTransparency = 1; opTopRow.Size = UDim2.new(1,0,0,18)

	opTopRow.LayoutOrder = 1; opTopRow.ZIndex = 202; opTopRow.Parent = opacityRow

	local opacityLabel = Instance.new("TextLabel"); opacityLabel.BackgroundTransparency = 1; opacityLabel.Size = UDim2.new(1,-52,1,0)

	opacityLabel.FontFace = FONT_BOLD; opacityLabel.TextSize = 11; opacityLabel.TextColor3 = C.TextWhite; opacityLabel.TextTransparency = 0

	opacityLabel.TextXAlignment = Enum.TextXAlignment.Left; opacityLabel.Text = "Opacity"; opacityLabel.ZIndex = 203; opacityLabel.Parent = opTopRow

	regAccent(opacityLabel, "TextColor3", "TextWhite")

	local opValBox = Instance.new("TextBox"); opValBox.BackgroundColor3 = Color3.fromRGB(28,28,28); opValBox.BackgroundTransparency = 0.3

	opValBox.Size = UDim2.new(0,42,0,18); opValBox.Position = UDim2.new(1,-42,0.5,-9); opValBox.FontFace = FONT; opValBox.TextSize = 11

	opValBox.TextColor3 = C.TextWhite; opValBox.TextTransparency = 0; opValBox.Text = tostring(math.floor(initAcrylicOpacity*100)).."%"; opValBox.ClearTextOnFocus = false

	opValBox.ZIndex = 203; opValBox.Parent = opTopRow; createCorner(opValBox, 5)

	regAccent(opValBox, "TextColor3", "TextWhite")

	local opBarRow = Instance.new("Frame"); opBarRow.BackgroundTransparency = 1; opBarRow.Size = UDim2.new(1,0,0,12)

	opBarRow.LayoutOrder = 2; opBarRow.ZIndex = 202; opBarRow.Parent = opacityRow

	local opacityBar = Instance.new("Frame"); opacityBar.BackgroundColor3 = Color3.fromRGB(45,45,45); opacityBar.BackgroundTransparency = 0.2

	opacityBar.Size = UDim2.new(1,0,0,4); opacityBar.Position = UDim2.new(0,0,0.5,-2); opacityBar.ZIndex = 203; opacityBar.Parent = opBarRow; createCorner(opacityBar, 2)

	local opacityFill = Instance.new("Frame"); opacityFill.BackgroundColor3 = C.Accent; opacityFill.BackgroundTransparency = 0.2

	opacityFill.Size = UDim2.new(initAcrylicOpacity,0,1,0); opacityFill.ZIndex = 204; opacityFill.Parent = opacityBar; createCorner(opacityFill, 2)

	regTheme(function() opacityFill.BackgroundColor3 = C.Accent end)

	local opacityKnob = Instance.new("Frame"); opacityKnob.BackgroundColor3 = C.TextWhite; opacityKnob.BackgroundTransparency = 0.2

	opacityKnob.Size = UDim2.new(0,12,0,12); opacityKnob.Position = UDim2.new(initAcrylicOpacity,-6,0.5,-6); opacityKnob.ZIndex = 205; opacityKnob.Parent = opacityBar; createCorner(opacityKnob, 6)

	local opacityInput = Instance.new("TextButton"); opacityInput.BackgroundTransparency = 1; opacityInput.Size = UDim2.new(1,0,1,0)

	opacityInput.Text = ""; opacityInput.ZIndex = 206; opacityInput.AutoButtonColor = false; opacityInput.Parent = opBarRow

	opacityRow.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement then cancelTweens("ophov"); playTween("ophov", opacityRow, TWEEN_FAST, {BackgroundTransparency=0.5}) end end)

	opacityRow.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement then cancelTweens("ophov"); playTween("ophov", opacityRow, TWEEN_FAST, {BackgroundTransparency=0.85}) end end)

	local function applyAcrylic()

		opValBox.Text = tostring(math.floor(windowData.acrylicOpacity*100)).."%"

		mainFrame.BackgroundTransparency = windowData.acrylicEnabled and windowData.acrylicOpacity or 0

	end

	local opacitySliding = false

	opValBox.FocusLost:Connect(function()

		local num = tonumber(opValBox.Text:match("%d+"))

		if num then

			local pct = math.clamp(num, 0, 100) / 100

			windowData.acrylicOpacity = pct; opacityFill.Size = UDim2.new(pct,0,1,0); opacityKnob.Position = UDim2.new(pct,-6,0.5,-6); applyAcrylic()

		else applyAcrylic() end

	end)

	opacityInput.InputBegan:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then

			opacitySliding = true

			local pct = math.clamp((input.Position.X-opacityBar.AbsolutePosition.X)/opacityBar.AbsoluteSize.X,0,1)

			windowData.acrylicOpacity = pct; opacityFill.Size = UDim2.new(pct,0,1,0); opacityKnob.Position = UDim2.new(pct,-6,0.5,-6); applyAcrylic()

		end

	end)

	table.insert(windowData.connections, UserInputService.InputChanged:Connect(function(input)

		if opacitySliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then

			local pct = math.clamp((input.Position.X-opacityBar.AbsolutePosition.X)/opacityBar.AbsoluteSize.X,0,1)

			windowData.acrylicOpacity = pct; opacityFill.Size = UDim2.new(pct,0,1,0); opacityKnob.Position = UDim2.new(pct,-6,0.5,-6); applyAcrylic()

		end

	end))

	table.insert(windowData.connections, UserInputService.InputEnded:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then opacitySliding = false end

	end))

	local acrylicRow = Instance.new("Frame"); acrylicRow.BackgroundColor3 = C.Background; acrylicRow.BackgroundTransparency = 0.85

	acrylicRow.Size = UDim2.new(1,0,0,34); acrylicRow.LayoutOrder = 3; acrylicRow.ZIndex = 201; acrylicRow.Parent = configPanel

	createCorner(acrylicRow, 6)

	regAccent(acrylicRow, "BackgroundColor3", "Background")

	local acrylicLabel = Instance.new("TextLabel"); acrylicLabel.BackgroundTransparency = 1; acrylicLabel.Size = UDim2.new(1,-60,0,18)

	acrylicLabel.Position = UDim2.new(0,6,0.5,-9); acrylicLabel.FontFace = FONT_BOLD; acrylicLabel.TextSize = 11; acrylicLabel.TextColor3 = C.TextWhite

	acrylicLabel.TextTransparency = 0.15; acrylicLabel.TextXAlignment = Enum.TextXAlignment.Left; acrylicLabel.Text = "Acrylic"; acrylicLabel.ZIndex = 202; acrylicLabel.Parent = acrylicRow

	regAccent(acrylicLabel, "TextColor3", "TextWhite")

	local acrylicToggle = Instance.new("TextButton"); acrylicToggle.Size = UDim2.new(0,44,0,22); acrylicToggle.Position = UDim2.new(1,-50,0.5,-11)

	acrylicToggle.BackgroundColor3 = Color3.fromRGB(50,50,50); acrylicToggle.BackgroundTransparency = 0.2; acrylicToggle.Text = ""; acrylicToggle.AutoButtonColor = false; acrylicToggle.ZIndex = 202; acrylicToggle.Parent = acrylicRow

	createCorner(acrylicToggle, 11)

	local acrylicKnob = Instance.new("Frame"); acrylicKnob.BackgroundColor3 = Color3.fromRGB(235,235,235); acrylicKnob.BackgroundTransparency = 0.2; acrylicKnob.Size = UDim2.new(0,16,0,16)

	acrylicKnob.Position = UDim2.new(0,3,0.5,-8); acrylicKnob.ZIndex = 203; acrylicKnob.Parent = acrylicToggle; createCorner(acrylicKnob, 8)

	regTheme(function() if windowData.acrylicEnabled then acrylicToggle.BackgroundColor3 = C.Accent end end)

	acrylicRow.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement then cancelTweens("acrhov"); playTween("acrhov", acrylicToggle, TWEEN_FAST, {BackgroundTransparency=0}); playTween("acrhov", acrylicKnob, TWEEN_FAST, {BackgroundTransparency=0}); playTween("acrhov", acrylicRow, TWEEN_FAST, {BackgroundTransparency=0.5}) end end)

	acrylicRow.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement then cancelTweens("acrhov"); playTween("acrhov", acrylicToggle, TWEEN_FAST, {BackgroundTransparency=0.2}); playTween("acrhov", acrylicKnob, TWEEN_FAST, {BackgroundTransparency=0.2}); playTween("acrhov", acrylicRow, TWEEN_FAST, {BackgroundTransparency=0.85}) end end)

	table.insert(windowData.connections, acrylicToggle.MouseButton1Click:Connect(function()

		if windowData.destroyed then return end

		playSound(SND_CLICK)

		windowData.acrylicEnabled = not windowData.acrylicEnabled; local on = windowData.acrylicEnabled; cancelTweens("acrylic_toggle")

		playTween("acrylic_toggle", acrylicToggle, TWEEN_FAST, {BackgroundColor3=on and C.Accent or Color3.fromRGB(50,50,50)})

		playTween("acrylic_toggle", acrylicKnob, TWEEN_FAST, {Position=on and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8)})

		playTween("acrylic_toggle", mainFrame, TWEEN_SMOOTH, {BackgroundTransparency=on and windowData.acrylicOpacity or 0})

		saveUISettings()

	end))

	local configCloseHint = Instance.new("TextLabel"); configCloseHint.BackgroundTransparency = 1; configCloseHint.Size = UDim2.new(1,0,0,20)

	configCloseHint.FontFace = FONT_LIGHT; configCloseHint.TextSize = 9; configCloseHint.TextColor3 = C.TextWhite

	configCloseHint.TextTransparency = 0.7; configCloseHint.Text = "Click outside to close"

	configCloseHint.LayoutOrder = 9999; configCloseHint.ZIndex = 201; configCloseHint.Parent = configPanel

	regAccent(configCloseHint, "TextColor3", "TextWhite")

	local themeDivider2 = Instance.new("Frame"); themeDivider2.BackgroundColor3 = C.Border; themeDivider2.BackgroundTransparency = 0.6

	themeDivider2.Size = UDim2.new(1,0,0,1); themeDivider2.LayoutOrder = 4; themeDivider2.BorderSizePixel = 0; themeDivider2.ZIndex = 201; themeDivider2.Parent = configPanel

	regAccent(themeDivider2, "BackgroundColor3", "Border")

	local currentThemeName = (typeof(config.Theme) == "Color3") and "Custom" or (config.Theme or "Red")

	local SAVE_FOLDER = "NightMystic"

	local SAVE_FILE = SAVE_FOLDER .. "/UISettings.json"

	pcall(function()
		if makefolder and not isfolder(SAVE_FOLDER) then
			makefolder(SAVE_FOLDER)
		end
	end)

	local uiSettings = {showFps=true, showPing=false, showProfile=true, theme=currentThemeName, acrylicEnabled=false, acrylicOpacity=0.55, wallpaperOpacity=0.75, backgroundImageId="", customColorHex=""}

	saveUISettings = function()

		pcall(function()

			local data = {

				showFps     = showFpsEnabled,

				showPing    = showPingEnabled,

				showProfile = profileCardVisible,

				theme       = currentThemeName,

				acrylicEnabled  = windowData.acrylicEnabled,

				acrylicOpacity  = windowData.acrylicOpacity,

				wallpaperOpacity = windowData.wallpaperOpacity,

				backgroundImageId = windowData.backgroundImageId,

				customColorHex = windowData.customColorHex,

			}

			writefile(SAVE_FILE, game:GetService("HttpService"):JSONEncode(data))

		end)

	end

	local function loadUISettings()

		local ok, result = pcall(function()

			if not isfile(SAVE_FILE) then return end

			local raw = readfile(SAVE_FILE)

			local data = game:GetService("HttpService"):JSONDecode(raw)

			if type(data) == "table" then

				if type(data.showFps)         == "boolean" then uiSettings.showFps         = data.showFps end

				if type(data.showPing)        == "boolean" then uiSettings.showPing        = data.showPing end

				if type(data.showProfile)     == "boolean" then uiSettings.showProfile     = data.showProfile end

				if type(data.theme)           == "string"  then uiSettings.theme           = data.theme end

				if type(data.acrylicEnabled)  == "boolean" then uiSettings.acrylicEnabled  = data.acrylicEnabled end

				if type(data.acrylicOpacity)  == "number"  then uiSettings.acrylicOpacity  = data.acrylicOpacity end

				if type(data.wallpaperOpacity) == "number" then uiSettings.wallpaperOpacity = data.wallpaperOpacity end

				if type(data.backgroundImageId) == "string" then uiSettings.backgroundImageId = data.backgroundImageId end

				if type(data.customColorHex) == "string" then uiSettings.customColorHex = data.customColorHex end

			end

		end)

	end

	loadUISettings()

	local configPanelStroke = configPanelStrokeElem

	local themeDropOpen = false

	local themeCurrentLabel

	local themeSwatch

	local closeConfig

	local function applyTheme(themeInput)

		currentThemeName = (typeof(themeInput) == "Color3") and "Custom" or tostring(themeInput)

		if typeof(themeInput) == "Color3" then

			local accentData = buildAccentFromColor(themeInput)

			for k, v in pairs(accentData) do C[k] = boostColorGlobal(v, 0.45) end

		else

			for k, v in pairs(THEMES[themeInput] or THEMES.Red) do C[k] = boostColorGlobal(v, 0.45) end

		end

		mainFrame.BackgroundColor3 = C.Background

		configPanel.BackgroundColor3 = C.ConfigPanel

		tabDivider.BackgroundColor3 = C.Border

		headerDivider.BackgroundColor3 = C.Border; opacityFill.BackgroundColor3 = C.Accent

		configTitleLbl.TextColor3 = C.AccentBright

		fpsLabel.TextColor3 = C.AccentBright; pingLabel.TextColor3 = C.AccentBright

		if configPanelStroke then configPanelStroke.Color = C.Border end

		for _, dot in ipairs(resizeDotsList) do dot.BackgroundColor3 = C.Accent end

		btnIcons["Config"].ImageColor3 = C.AccentDeep; btnIcons["Minimize"].ImageColor3 = C.AccentDark

		btnIcons["Maximize"].ImageColor3 = C.Accent; btnIcons["Close"].ImageColor3 = C.Accent

		for name, td in pairs(windowData.tabs) do

			td.indicator.BackgroundColor3 = C.Accent

			if windowData.selectedTab == name then

				td.titleLabel.TextColor3 = C.AccentBright; td.subtitleLabel.TextColor3 = C.Accent

				td.iconLabel.ImageColor3 = C.AccentBright; td.frame.BackgroundColor3 = C.TabSelected

			end

		end

		for _, cb in ipairs(windowData.themeCallbacks) do pcall(cb) end

		for _, ae in ipairs(windowData.accentElems) do pcall(function() ae.inst[ae.prop] = C[ae.key] end) end

		if themeCurrentLabel then themeCurrentLabel.Text = string.format("#%02X%02X%02X", math.floor(C.Accent.R*255+0.5), math.floor(C.Accent.G*255+0.5), math.floor(C.Accent.B*255+0.5)) end

		if themeSwatch then themeSwatch.BackgroundColor3 = C.Accent end

	end

	local function doThemeChangeAnim(themeName)

		if closeConfig then closeConfig() end

		cancelTweens("theme_anim")

		local fadeOut = TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In)

		playTween("theme_anim", mainFrame, fadeOut, {BackgroundTransparency=1}); playTween("theme_anim", mainStroke, fadeOut, {Transparency=1})

		local shd = mainFrame:FindFirstChild("Shadow"); if shd then playTween("theme_anim", shd, fadeOut, {ImageTransparency=1}) end

		task.delay(0.26, function()

			mainFrame.Visible = false; applyTheme(themeName)

			if themeBackground then

				if windowData.backgroundImageId and windowData.backgroundImageId ~= "" then

					themeBackground.Image = "rbxassetid://" .. windowData.backgroundImageId

					themeBackground.Visible = true

				else

					themeBackground.Visible = false

				end

				themeBackground.ImageTransparency = 1 - windowData.wallpaperOpacity

			end

			saveUISettings()

			showLoadingScreen(C, function()

				mainFrame.Visible = true; cancelTweens("theme_anim")

				playTween("theme_anim", mainFrame, TWEEN_MEDIUM, {BackgroundTransparency=windowData.acrylicEnabled and windowData.acrylicOpacity or 0})

				playTween("theme_anim", mainStroke, TWEEN_MEDIUM, {Transparency=0.6})

				local shd2 = mainFrame:FindFirstChild("Shadow"); if shd2 then playTween("theme_anim", shd2, TWEEN_SLOW, {ImageTransparency=0.5}) end

			end)

		end)

	end

	local themeDropRow = Instance.new("Frame"); themeDropRow.BackgroundTransparency = 1

	themeDropRow.Size = UDim2.new(1,0,0,0); themeDropRow.AutomaticSize = Enum.AutomaticSize.Y

	themeDropRow.LayoutOrder = 6; themeDropRow.ZIndex = 201; themeDropRow.Parent = configPanel

	local themeDropInnerLayout = Instance.new("UIListLayout"); themeDropInnerLayout.FillDirection = Enum.FillDirection.Vertical

	themeDropInnerLayout.Padding = UDim.new(0,4); themeDropInnerLayout.SortOrder = Enum.SortOrder.LayoutOrder; themeDropInnerLayout.Parent = themeDropRow

	local themeDropHeaderBox = Instance.new("Frame"); themeDropHeaderBox.BackgroundColor3 = C.Background

	themeDropHeaderBox.BackgroundTransparency = 0.85; themeDropHeaderBox.Size = UDim2.new(1,0,0,40)

	themeDropHeaderBox.LayoutOrder = 1; themeDropHeaderBox.ZIndex = 202; themeDropHeaderBox.Parent = themeDropRow

	createCorner(themeDropHeaderBox, 6); createPadding(themeDropHeaderBox, 6, 12, 6, 12)

	regAccent(themeDropHeaderBox, "BackgroundColor3", "Background")

	local themeGlow = Instance.new("UIStroke"); themeGlow.Color = C.Accent; themeGlow.Thickness = 1; themeGlow.Transparency = 1; themeGlow.Parent = themeDropHeaderBox

	regTheme(function() themeGlow.Color = C.Accent end)

	themeDropHeaderBox.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement then themeGlow.Color = C.Accent; cancelTweens("thdrophov_glow"); playTween("thdrophov_glow", themeGlow, TWEEN_FAST, {Transparency=0.55}) end end)

	themeDropHeaderBox.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement then cancelTweens("thdrophov_glow"); playTween("thdrophov_glow", themeGlow, TWEEN_FAST, {Transparency=1}) end end)

	local themeDropHeader = Instance.new("Frame"); themeDropHeader.BackgroundTransparency = 1

	themeDropHeader.Size = UDim2.new(1,0,1,0); themeDropHeader.ZIndex = 202; themeDropHeader.Parent = themeDropHeaderBox

	local themeDropTitleLabel = Instance.new("TextLabel"); themeDropTitleLabel.BackgroundTransparency = 1

	themeDropTitleLabel.Size = UDim2.new(1,-34,0,16); themeDropTitleLabel.Position = UDim2.new(0,0,0,0)

	themeDropTitleLabel.FontFace = FONT_BOLD; themeDropTitleLabel.TextSize = 11

	themeDropTitleLabel.TextColor3 = C.TextWhite; themeDropTitleLabel.TextXAlignment = Enum.TextXAlignment.Left

	themeDropTitleLabel.Text = "Theme Color"; themeDropTitleLabel.ZIndex = 203; themeDropTitleLabel.Parent = themeDropHeader

	regAccent(themeDropTitleLabel, "TextColor3", "TextWhite")

	themeCurrentLabel = Instance.new("TextLabel"); themeCurrentLabel.BackgroundTransparency = 1

	themeCurrentLabel.Size = UDim2.new(1,-34,0,12); themeCurrentLabel.Position = UDim2.new(0,0,0,16)

	themeCurrentLabel.FontFace = FONT; themeCurrentLabel.TextSize = 10; themeCurrentLabel.TextColor3 = C.TextSubtitle

	themeCurrentLabel.TextXAlignment = Enum.TextXAlignment.Left; themeCurrentLabel.Text = string.format("#%02X%02X%02X", math.floor(C.Accent.R*255+0.5), math.floor(C.Accent.G*255+0.5), math.floor(C.Accent.B*255+0.5)); themeCurrentLabel.ZIndex = 203; themeCurrentLabel.Parent = themeDropHeader

	regAccent(themeCurrentLabel, "TextColor3", "TextSubtitle")

	themeSwatch = Instance.new("Frame"); themeSwatch.BackgroundColor3 = C.Accent; themeSwatch.Size = UDim2.new(0,26,0,26)

	themeSwatch.AnchorPoint = Vector2.new(1,0.5); themeSwatch.Position = UDim2.new(1,0,0.5,0); themeSwatch.ZIndex = 203; themeSwatch.Parent = themeDropHeader

	createCorner(themeSwatch, 6); do local themeSwatchStroke = createStroke(themeSwatch, C.Border, 1, 0.3); regTheme(function() themeSwatchStroke.Color = C.Border end) end

	local themeMenuWrap = Instance.new("Frame"); themeMenuWrap.BackgroundTransparency = 1

	themeMenuWrap.Size = UDim2.new(1,0,0,0); themeMenuWrap.ClipsDescendants = true

	themeMenuWrap.LayoutOrder = 2; themeMenuWrap.ZIndex = 202; themeMenuWrap.Parent = themeDropRow

	local themeMenuInner = Instance.new("Frame"); themeMenuInner.BackgroundColor3 = Color3.fromRGB(25,25,25)

	themeMenuInner.Size = UDim2.new(1,0,0,0); themeMenuInner.AutomaticSize = Enum.AutomaticSize.Y; themeMenuInner.ZIndex = 202; themeMenuInner.Parent = themeMenuWrap

	createCorner(themeMenuInner, 8)

	do local themeMenuStroke = createStroke(themeMenuInner, C.Border, 1, 0.45); regTheme(function() themeMenuStroke.Color = C.Border end) end

	local themeMenuLayout = Instance.new("UIListLayout"); themeMenuLayout.FillDirection = Enum.FillDirection.Vertical

	themeMenuLayout.Padding = UDim.new(0,4); themeMenuLayout.SortOrder = Enum.SortOrder.LayoutOrder; themeMenuLayout.Parent = themeMenuInner

	createPadding(themeMenuInner, 5, 5, 5, 5)

	local themeMenuTotalH = 240

	local pickerH, pickerS, pickerV = C.Accent:ToHSV()

	local svBox = Instance.new("Frame"); svBox.BackgroundColor3 = Color3.fromHSV(pickerH, 1, 1)
	svBox.Size = UDim2.new(1,0,0,120); svBox.LayoutOrder = 1; svBox.ClipsDescendants = true; svBox.ZIndex = 203; svBox.Parent = themeMenuInner
	createCorner(svBox, 6)

	do
		local svWhiteOverlay = Instance.new("Frame"); svWhiteOverlay.BackgroundColor3 = Color3.new(1,1,1); svWhiteOverlay.BorderSizePixel = 0
		svWhiteOverlay.Size = UDim2.new(1,0,1,0); svWhiteOverlay.ZIndex = 204; svWhiteOverlay.Parent = svBox
		local svWhiteGrad = Instance.new("UIGradient"); svWhiteGrad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1)}); svWhiteGrad.Parent = svWhiteOverlay

		local svBlackOverlay = Instance.new("Frame"); svBlackOverlay.BackgroundColor3 = Color3.new(0,0,0); svBlackOverlay.BorderSizePixel = 0
		svBlackOverlay.Size = UDim2.new(1,0,1,0); svBlackOverlay.ZIndex = 205; svBlackOverlay.Parent = svBox
		local svBlackGrad = Instance.new("UIGradient"); svBlackGrad.Rotation = 90; svBlackGrad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(1,0)}); svBlackGrad.Parent = svBlackOverlay
	end

	local svKnob = Instance.new("Frame"); svKnob.AnchorPoint = Vector2.new(0.5,0.5); svKnob.BackgroundColor3 = Color3.new(1,1,1)
	svKnob.Size = UDim2.new(0,12,0,12); svKnob.Position = UDim2.new(pickerS,0,1-pickerV,0); svKnob.ZIndex = 207; svKnob.Parent = svBox
	createCorner(svKnob, 6); createStroke(svKnob, Color3.new(0,0,0), 2, 0.2)

	local svInputBtn = Instance.new("TextButton"); svInputBtn.BackgroundTransparency = 1; svInputBtn.Text = ""
	svInputBtn.Size = UDim2.new(1,0,1,0); svInputBtn.AutoButtonColor = false; svInputBtn.ZIndex = 208; svInputBtn.Parent = svBox

	local hueBarRow = Instance.new("Frame"); hueBarRow.BackgroundTransparency = 1; hueBarRow.Size = UDim2.new(1,0,0,18); hueBarRow.LayoutOrder = 2; hueBarRow.ZIndex = 203; hueBarRow.Parent = themeMenuInner

	local hueBarBg = Instance.new("Frame"); hueBarBg.BackgroundColor3 = Color3.new(1,1,1); hueBarBg.BorderSizePixel = 0
	hueBarBg.Size = UDim2.new(1,0,0,8); hueBarBg.Position = UDim2.new(0,0,0.5,-4); hueBarBg.ZIndex = 203; hueBarBg.Parent = hueBarRow
	createCorner(hueBarBg, 4)

	do
		local hueGrad = Instance.new("UIGradient"); hueGrad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromHSV(0,1,1)),
			ColorSequenceKeypoint.new(1/6, Color3.fromHSV(1/6,1,1)),
			ColorSequenceKeypoint.new(2/6, Color3.fromHSV(2/6,1,1)),
			ColorSequenceKeypoint.new(3/6, Color3.fromHSV(3/6,1,1)),
			ColorSequenceKeypoint.new(4/6, Color3.fromHSV(4/6,1,1)),
			ColorSequenceKeypoint.new(5/6, Color3.fromHSV(5/6,1,1)),
			ColorSequenceKeypoint.new(1, Color3.fromHSV(1,1,1)),
		}); hueGrad.Parent = hueBarBg
	end

	local hueKnob = Instance.new("Frame"); hueKnob.AnchorPoint = Vector2.new(0.5,0.5); hueKnob.BackgroundColor3 = Color3.new(1,1,1)
	hueKnob.Size = UDim2.new(0,14,0,14); hueKnob.Position = UDim2.new(pickerH,0,0.5,0); hueKnob.ZIndex = 205; hueKnob.Parent = hueBarRow
	createCorner(hueKnob, 7); createStroke(hueKnob, Color3.new(0,0,0), 2, 0.2)

	local hueInputBtn = Instance.new("TextButton"); hueInputBtn.BackgroundTransparency = 1; hueInputBtn.Text = ""
	hueInputBtn.Size = UDim2.new(1,0,1,0); hueInputBtn.AutoButtonColor = false; hueInputBtn.ZIndex = 206; hueInputBtn.Parent = hueBarRow

	local readoutFrame = Instance.new("Frame"); readoutFrame.BackgroundTransparency = 1; readoutFrame.Size = UDim2.new(1,0,0,50); readoutFrame.LayoutOrder = 3; readoutFrame.ZIndex = 203; readoutFrame.Parent = themeMenuInner
	do local readoutLayout = Instance.new("UIListLayout"); readoutLayout.Padding = UDim.new(0,2); readoutLayout.SortOrder = Enum.SortOrder.LayoutOrder; readoutLayout.Parent = readoutFrame end

	local function makeReadoutRow(order, label)
		local row = Instance.new("Frame"); row.BackgroundTransparency = 1; row.Size = UDim2.new(1,0,0,14); row.LayoutOrder = order; row.ZIndex = 203; row.Parent = readoutFrame
		local lbl = Instance.new("TextLabel"); lbl.BackgroundTransparency = 1; lbl.Size = UDim2.new(0,36,1,0); lbl.FontFace = FONT_BOLD; lbl.TextSize = 10
		lbl.TextColor3 = C.TextSubtitle; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Text = label; lbl.ZIndex = 203; lbl.Parent = row
		regAccent(lbl, "TextColor3", "TextSubtitle")
		local val = Instance.new("TextLabel"); val.BackgroundTransparency = 1; val.Size = UDim2.new(1,-36,1,0); val.Position = UDim2.new(0,36,0,0); val.FontFace = FONT; val.TextSize = 10
		val.TextColor3 = C.TextWhite; val.TextXAlignment = Enum.TextXAlignment.Left; val.ZIndex = 203; val.Parent = row
		regAccent(val, "TextColor3", "TextWhite")
		return val
	end

	local hexValueLbl = makeReadoutRow(1, "Hex")
	local rgbValueLbl = makeReadoutRow(2, "RGB")
	local hslValueLbl = makeReadoutRow(3, "HSL")

	local applyBtn = Instance.new("TextButton"); applyBtn.BackgroundColor3 = C.Accent; applyBtn.Size = UDim2.new(1,0,0,26)
	applyBtn.LayoutOrder = 4; applyBtn.FontFace = FONT_BOLD; applyBtn.TextSize = 11; applyBtn.TextColor3 = Color3.new(1,1,1)
	applyBtn.Text = "Apply"; applyBtn.AutoButtonColor = false; applyBtn.ZIndex = 203; applyBtn.Parent = themeMenuInner
	createCorner(applyBtn, 5)
	regTheme(function() applyBtn.BackgroundColor3 = C.Accent end)

	local function rgbToHsl(r,g,b)
		local mx, mn = math.max(r,g,b), math.min(r,g,b)
		local h, s, l = 0, 0, (mx+mn)/2
		local d = mx-mn
		if d ~= 0 then
			s = l > 0.5 and d/(2-mx-mn) or d/(mx+mn)
			if mx == r then h = ((g-b)/d) % 6
			elseif mx == g then h = (b-r)/d + 2
			else h = (r-g)/d + 4 end
			h = h/6
		end
		return math.floor(h*360+0.5), math.floor(s*100+0.5), math.floor(l*100+0.5)
	end

	local function updatePickerVisuals()
		local hueColor = Color3.fromHSV(pickerH, 1, 1)
		svBox.BackgroundColor3 = hueColor
		svKnob.Position = UDim2.new(pickerS,0,1-pickerV,0)
		hueKnob.Position = UDim2.new(pickerH,0,0.5,0)
		local col = Color3.fromHSV(pickerH, pickerS, pickerV)
		local r,g,b = math.floor(col.R*255+0.5), math.floor(col.G*255+0.5), math.floor(col.B*255+0.5)
		hexValueLbl.Text = string.format("#%02X%02X%02X", r, g, b)
		rgbValueLbl.Text = r..", "..g..", "..b
		local h,s,l = rgbToHsl(col.R, col.G, col.B)
		hslValueLbl.Text = h..", "..s..", "..l
	end

	updatePickerVisuals()

	local svDragging = false

	svInputBtn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			svDragging = true
			pickerS = math.clamp((input.Position.X-svBox.AbsolutePosition.X)/svBox.AbsoluteSize.X,0,1)
			pickerV = 1-math.clamp((input.Position.Y-svBox.AbsolutePosition.Y)/svBox.AbsoluteSize.Y,0,1)
			updatePickerVisuals()
		end
	end)

	table.insert(windowData.connections, UserInputService.InputChanged:Connect(function(input)
		if svDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			pickerS = math.clamp((input.Position.X-svBox.AbsolutePosition.X)/svBox.AbsoluteSize.X,0,1)
			pickerV = 1-math.clamp((input.Position.Y-svBox.AbsolutePosition.Y)/svBox.AbsoluteSize.Y,0,1)
			updatePickerVisuals()
		end
	end))

	table.insert(windowData.connections, UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			svDragging = false
		end
	end))

	local hueDragging = false

	hueInputBtn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			hueDragging = true
			pickerH = math.clamp((input.Position.X-hueBarBg.AbsolutePosition.X)/hueBarBg.AbsoluteSize.X,0,1)
			updatePickerVisuals()
		end
	end)

	table.insert(windowData.connections, UserInputService.InputChanged:Connect(function(input)
		if hueDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			pickerH = math.clamp((input.Position.X-hueBarBg.AbsolutePosition.X)/hueBarBg.AbsoluteSize.X,0,1)
			updatePickerVisuals()
		end
	end))

	table.insert(windowData.connections, UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			hueDragging = false
		end
	end))

	applyBtn.MouseButton1Click:Connect(function()
		themeDropOpen = false
		playTween("themedrop_anim", themeMenuWrap, TWEEN_FAST, {Size=UDim2.new(1,0,0,0)})
		playTween("themedrop_anim", themeDropHeaderBox, TWEEN_FAST, {BackgroundTransparency=0.85})
		local col = Color3.fromHSV(pickerH, pickerS, pickerV)
		windowData.customColorHex = string.format("#%02X%02X%02X", math.floor(col.R*255+0.5), math.floor(col.G*255+0.5), math.floor(col.B*255+0.5))
		doThemeChangeAnim(col)
	end)

	local function setPickerColor(col)
		pickerH, pickerS, pickerV = col:ToHSV()
		updatePickerVisuals()
	end

	local themeDropBtn = Instance.new("TextButton"); themeDropBtn.BackgroundTransparency = 1

	themeDropBtn.Size = UDim2.new(1,0,1,0); themeDropBtn.Text = ""; themeDropBtn.AutoButtonColor = false; themeDropBtn.ZIndex = 204; themeDropBtn.Parent = themeDropHeaderBox

	themeDropBtn.MouseButton1Click:Connect(function()

		themeDropOpen = not themeDropOpen

		if themeDropOpen then

			cancelTweens("themedrop_anim"); playTween("themedrop_anim", themeDropHeaderBox, TWEEN_FAST, {BackgroundTransparency=0.7})

			playTween("themedrop_anim", themeMenuWrap, TWEEN_SMOOTH, {Size=UDim2.new(1,0,0,themeMenuTotalH)})

		else

			cancelTweens("themedrop_anim"); playTween("themedrop_anim", themeDropHeaderBox, TWEEN_FAST, {BackgroundTransparency=0.85})

			playTween("themedrop_anim", themeMenuWrap, TWEEN_FAST, {Size=UDim2.new(1,0,0,0)})

		end

	end)

	local bgImageRow = Instance.new("Frame"); bgImageRow.BackgroundColor3 = C.Background; bgImageRow.BackgroundTransparency = 0.85
	bgImageRow.Size = UDim2.new(1,0,0,144); bgImageRow.LayoutOrder = 7; bgImageRow.ZIndex = 201; bgImageRow.Parent = configPanel
	createCorner(bgImageRow, 6)
	regAccent(bgImageRow, "BackgroundColor3", "Background")

	local bgImageTitle = Instance.new("TextLabel"); bgImageTitle.BackgroundTransparency = 1
	bgImageTitle.Size = UDim2.new(1,-12,0,16); bgImageTitle.Position = UDim2.new(0,6,0,6)
	bgImageTitle.FontFace = FONT_BOLD; bgImageTitle.TextSize = 11
	bgImageTitle.TextColor3 = C.TextWhite; bgImageTitle.TextXAlignment = Enum.TextXAlignment.Left
	bgImageTitle.Text = "Background Image"; bgImageTitle.ZIndex = 202; bgImageTitle.Parent = bgImageRow
	regAccent(bgImageTitle, "TextColor3", "TextWhite")

	local bgImageInput = Instance.new("TextBox"); bgImageInput.BackgroundColor3 = Color3.fromRGB(28,28,28)
	bgImageInput.BackgroundTransparency = 0.2
	bgImageInput.Size = UDim2.new(1,-12,0,24); bgImageInput.Position = UDim2.new(0,6,0,26)
	bgImageInput.FontFace = FONT; bgImageInput.TextSize = 11
	bgImageInput.PlaceholderText = "Enter image asset id..."
	bgImageInput.Text = ""
	bgImageInput.TextColor3 = C.TextWhite
	bgImageInput.PlaceholderColor3 = C.TextSubtitle
	bgImageInput.ClearTextOnFocus = false
	bgImageInput.ZIndex = 202; bgImageInput.Parent = bgImageRow
	createCorner(bgImageInput, 5)
	regAccent(bgImageInput, "TextColor3", "TextWhite")

	local wpOpacityLabel = Instance.new("TextLabel"); wpOpacityLabel.BackgroundTransparency = 1
	wpOpacityLabel.Size = UDim2.new(1,-54,0,14); wpOpacityLabel.Position = UDim2.new(0,6,0,58)
	wpOpacityLabel.FontFace = FONT_BOLD; wpOpacityLabel.TextSize = 10
	wpOpacityLabel.TextColor3 = C.TextWhite; wpOpacityLabel.TextXAlignment = Enum.TextXAlignment.Left
	wpOpacityLabel.Text = "Wallpaper Opacity"; wpOpacityLabel.ZIndex = 202; wpOpacityLabel.Parent = bgImageRow
	regAccent(wpOpacityLabel, "TextColor3", "TextWhite")

	local wpOpacityValueBox = Instance.new("TextBox"); wpOpacityValueBox.BackgroundColor3 = Color3.fromRGB(28,28,28)
	wpOpacityValueBox.BackgroundTransparency = 0.3
	wpOpacityValueBox.Size = UDim2.new(0,38,0,14); wpOpacityValueBox.Position = UDim2.new(1,-44,0,58)
	wpOpacityValueBox.FontFace = FONT; wpOpacityValueBox.TextSize = 10
	wpOpacityValueBox.TextColor3 = C.TextWhite
	wpOpacityValueBox.Text = tostring(math.floor(windowData.wallpaperOpacity*100)).."%"
	wpOpacityValueBox.ClearTextOnFocus = false
	wpOpacityValueBox.ZIndex = 202; wpOpacityValueBox.Parent = bgImageRow
	createCorner(wpOpacityValueBox, 4)
	regAccent(wpOpacityValueBox, "TextColor3", "TextWhite")

	local wpOpacityBar = Instance.new("Frame"); wpOpacityBar.BackgroundColor3 = Color3.fromRGB(45,45,45)
	wpOpacityBar.BackgroundTransparency = 0.2
	wpOpacityBar.Size = UDim2.new(1,-12,0,4); wpOpacityBar.Position = UDim2.new(0,6,0,78)
	wpOpacityBar.ZIndex = 202; wpOpacityBar.Parent = bgImageRow; createCorner(wpOpacityBar, 2)

	local wpOpacityFill = Instance.new("Frame"); wpOpacityFill.BackgroundColor3 = C.Accent
	wpOpacityFill.BackgroundTransparency = 0.2
	wpOpacityFill.Size = UDim2.new(windowData.wallpaperOpacity,0,1,0); wpOpacityFill.ZIndex = 203; wpOpacityFill.Parent = wpOpacityBar
	createCorner(wpOpacityFill, 2)
	regTheme(function() wpOpacityFill.BackgroundColor3 = C.Accent end)

	local wpOpacityKnob = Instance.new("Frame"); wpOpacityKnob.BackgroundColor3 = C.TextWhite
	wpOpacityKnob.BackgroundTransparency = 0.2; wpOpacityKnob.Size = UDim2.new(0,10,0,10)
	wpOpacityKnob.Position = UDim2.new(windowData.wallpaperOpacity,-5,0.5,-5); wpOpacityKnob.ZIndex = 204; wpOpacityKnob.Parent = wpOpacityBar
	createCorner(wpOpacityKnob, 5)

	local wpOpacityInput = Instance.new("TextButton"); wpOpacityInput.BackgroundTransparency = 1
	wpOpacityInput.Size = UDim2.new(1,-12,0,18); wpOpacityInput.Position = UDim2.new(0,6,0,71)
	wpOpacityInput.Text = ""; wpOpacityInput.ZIndex = 205; wpOpacityInput.AutoButtonColor = false; wpOpacityInput.Parent = bgImageRow

	local function applyWallpaperOpacity()
		wpOpacityValueBox.Text = tostring(math.floor(windowData.wallpaperOpacity*100)).."%"
		if themeBackground then themeBackground.ImageTransparency = 1 - windowData.wallpaperOpacity end
	end

	local wpOpacitySliding = false

	wpOpacityValueBox.FocusLost:Connect(function()
		local num = tonumber(wpOpacityValueBox.Text:match("%d+"))
		if num then
			local pct = math.clamp(num, 0, 100) / 100
			windowData.wallpaperOpacity = pct; wpOpacityFill.Size = UDim2.new(pct,0,1,0); wpOpacityKnob.Position = UDim2.new(pct,-5,0.5,-5)
			applyWallpaperOpacity(); saveUISettings()
		else applyWallpaperOpacity() end
	end)

	wpOpacityInput.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			wpOpacitySliding = true
			local pct = math.clamp((input.Position.X-wpOpacityBar.AbsolutePosition.X)/wpOpacityBar.AbsoluteSize.X,0,1)
			windowData.wallpaperOpacity = pct; wpOpacityFill.Size = UDim2.new(pct,0,1,0); wpOpacityKnob.Position = UDim2.new(pct,-5,0.5,-5)
			applyWallpaperOpacity(); saveUISettings()
		end
	end)

	table.insert(windowData.connections, UserInputService.InputChanged:Connect(function(input)
		if wpOpacitySliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local pct = math.clamp((input.Position.X-wpOpacityBar.AbsolutePosition.X)/wpOpacityBar.AbsoluteSize.X,0,1)
			windowData.wallpaperOpacity = pct; wpOpacityFill.Size = UDim2.new(pct,0,1,0); wpOpacityKnob.Position = UDim2.new(pct,-5,0.5,-5)
			applyWallpaperOpacity()
		end
	end))

	table.insert(windowData.connections, UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if wpOpacitySliding then wpOpacitySliding = false; saveUISettings() end
		end
	end))

	local bgSetButton = Instance.new("TextButton"); bgSetButton.BackgroundColor3 = C.Accent
	bgSetButton.Size = UDim2.new(1,-12,0,20); bgSetButton.Position = UDim2.new(0,6,1,-52)

	local bgRemoveButton = Instance.new("TextButton"); bgRemoveButton.BackgroundColor3 = Color3.fromRGB(90,90,90)
	bgRemoveButton.Size = UDim2.new(1,-12,0,20); bgRemoveButton.Position = UDim2.new(0,6,1,-28)
	bgRemoveButton.FontFace = FONT_BOLD; bgRemoveButton.TextSize = 10
	bgRemoveButton.TextColor3 = Color3.new(1,1,1)
	bgRemoveButton.Text = "Remove Background Image"
	bgRemoveButton.AutoButtonColor = false
	bgRemoveButton.ZIndex = 202; bgRemoveButton.Parent = bgImageRow
	createCorner(bgRemoveButton, 5)
	bgSetButton.FontFace = FONT_BOLD; bgSetButton.TextSize = 10
	bgSetButton.TextColor3 = Color3.new(1,1,1)
	bgSetButton.Text = "Set Image In Background"
	bgSetButton.AutoButtonColor = false
	bgSetButton.ZIndex = 202; bgSetButton.Parent = bgImageRow
	createCorner(bgSetButton, 5)

	regTheme(function()
		bgSetButton.BackgroundColor3 = C.Accent
	end)

	local function runBackgroundTransition(callback)
		if closeConfig then closeConfig() end
		cancelTweens("bg_change_anim")
		local fadeOut = TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In)

		playTween("bg_change_anim", mainFrame, fadeOut, {BackgroundTransparency=1})
		playTween("bg_change_anim", mainStroke, fadeOut, {Transparency=1})

		local shd = mainFrame:FindFirstChild("Shadow")
		if shd then
			playTween("bg_change_anim", shd, fadeOut, {ImageTransparency=1})
		end

		task.delay(0.26, function()
			mainFrame.Visible = false

			if callback then
				callback()
			end

			showLoadingScreen(C, function()
				mainFrame.Visible = true
				cancelTweens("bg_change_anim")

				playTween("bg_change_anim", mainFrame, TWEEN_MEDIUM, {
					BackgroundTransparency = windowData.acrylicEnabled and windowData.acrylicOpacity or 0
				})

				playTween("bg_change_anim", mainStroke, TWEEN_MEDIUM, {
					Transparency = 0.6
				})

				local shd2 = mainFrame:FindFirstChild("Shadow")
				if shd2 then
					playTween("bg_change_anim", shd2, TWEEN_SLOW, {
						ImageTransparency = 0.5
					})
				end
			end)
		end)
	end

	bgSetButton.MouseButton1Click:Connect(function()
		local txt = tostring(bgImageInput.Text or "")
		txt = txt:gsub("%s+", "")

		if txt ~= "" then
			local id = txt:match("%d+")

			if id then
				runBackgroundTransition(function()
					if themeBackground then
						themeBackground.Image = "rbxassetid://" .. id
						themeBackground.Visible = true
					end

					windowData.backgroundImageId = id
					uiSettings.backgroundImageId = id
					saveUISettings()
				end)
			end
		end
	end)

	bgRemoveButton.MouseButton1Click:Connect(function()
		runBackgroundTransition(function()
			if themeBackground then
				themeBackground.Image = ""
				themeBackground.Visible = false
			end

			bgImageInput.Text = ""

			windowData.backgroundImageId = ""
			uiSettings.backgroundImageId = ""
			saveUISettings()
		end)
	end)

	local statsDivider = Instance.new("Frame"); statsDivider.BackgroundColor3 = C.Border; statsDivider.BackgroundTransparency = 0.6

	statsDivider.Size = UDim2.new(1,0,0,1); statsDivider.LayoutOrder = 8; statsDivider.BorderSizePixel = 0; statsDivider.ZIndex = 201; statsDivider.Parent = configPanel

	regAccent(statsDivider, "BackgroundColor3", "Border")

	local statsSectionLabel = Instance.new("TextLabel"); statsSectionLabel.BackgroundTransparency = 1; statsSectionLabel.Size = UDim2.new(1,0,0,16)

	statsSectionLabel.FontFace = FONT; statsSectionLabel.TextSize = 11; statsSectionLabel.TextColor3 = C.TextWhite

	statsSectionLabel.TextXAlignment = Enum.TextXAlignment.Left; statsSectionLabel.Text = "Overlay"

	statsSectionLabel.LayoutOrder = 9; statsSectionLabel.ZIndex = 201; statsSectionLabel.Parent = configPanel

	regAccent(statsSectionLabel, "TextColor3", "TextWhite")

	local cfgToggleVisualSetters = {}

	local function makeConfigToggle(labelText, layoutOrder, callback, initValue)

		local row = Instance.new("Frame"); row.BackgroundColor3 = C.Background; row.BackgroundTransparency = 0.85

		row.Size = UDim2.new(1,0,0,34); row.LayoutOrder = layoutOrder; row.ZIndex = 201; row.Parent = configPanel; createCorner(row, 6)

		regAccent(row, "BackgroundColor3", "Background")

		local lbl = Instance.new("TextLabel"); lbl.BackgroundTransparency = 1; lbl.Size = UDim2.new(1,-60,0,18)

		lbl.Position = UDim2.new(0,6,0.5,-9); lbl.FontFace = FONT_BOLD; lbl.TextSize = 11; lbl.TextColor3 = C.TextWhite

		lbl.TextTransparency = 0.15; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Text = labelText; lbl.ZIndex = 202; lbl.Parent = row

		regAccent(lbl, "TextColor3", "TextWhite")

		local togBg = Instance.new("TextButton"); togBg.Size = UDim2.new(0,44,0,22); togBg.Position = UDim2.new(1,-50,0.5,-11)

		togBg.BackgroundColor3 = Color3.fromRGB(50,50,50); togBg.BackgroundTransparency = 0.2; togBg.Text = ""; togBg.AutoButtonColor = false; togBg.ZIndex = 202; togBg.Parent = row

		createCorner(togBg, 11)

		local knob = Instance.new("Frame"); knob.BackgroundColor3 = Color3.fromRGB(235,235,235)

		knob.BackgroundTransparency = 0.2; knob.Size = UDim2.new(0,16,0,16); knob.Position = UDim2.new(0,3,0.5,-8); knob.ZIndex = 203; knob.Parent = togBg; createCorner(knob, 8)

		local state = false

		local function setVisual(val)

			state = val

			togBg.BackgroundColor3 = val and C.Accent or Color3.fromRGB(50,50,50)

			knob.Position = val and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8)

		end

		cfgToggleVisualSetters[labelText] = setVisual

		local rhk = "cfghov_"..labelText

		row.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement then cancelTweens(rhk); playTween(rhk, lbl, TWEEN_FAST, {TextTransparency=0}); playTween(rhk, togBg, TWEEN_FAST, {BackgroundTransparency=0}); playTween(rhk, knob, TWEEN_FAST, {BackgroundTransparency=0}); playTween(rhk, row, TWEEN_FAST, {BackgroundTransparency=0.5}) end end)

		row.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement then cancelTweens(rhk); playTween(rhk, lbl, TWEEN_FAST, {TextTransparency=0.15}); playTween(rhk, togBg, TWEEN_FAST, {BackgroundTransparency=0.2}); playTween(rhk, knob, TWEEN_FAST, {BackgroundTransparency=0.2}); playTween(rhk, row, TWEEN_FAST, {BackgroundTransparency=0.85}) end end)

		togBg.MouseButton1Click:Connect(function()

			playSound(SND_CLICK)

			state = not state; local tKey = "cfgtog_"..labelText; cancelTweens(tKey)

			playTween(tKey, togBg, TWEEN_SMOOTH, {BackgroundColor3=state and C.Accent or Color3.fromRGB(50,50,50)})

			playTween(tKey, knob, TWEEN_SMOOTH, {Position=state and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8)}); callback(state)

			saveUISettings()

		end)

		regTheme(function() if state then togBg.BackgroundColor3 = C.Accent end end)

		if initValue then

			setVisual(true)

			task.defer(function() callback(true) end)

		end

		return row

	end

	makeConfigToggle("Show Fps", 10, function(val) showFpsEnabled = val; updateStatsFrame(); if not val then fpsLabel.Text = "FPS: -" end end, uiSettings.showFps)

	makeConfigToggle("Show Ping", 11, function(val) showPingEnabled = val; updateStatsFrame(); if not val then pingLabel.Text = "PING: -" end end, uiSettings.showPing)

	local profileDivider = Instance.new("Frame"); profileDivider.BackgroundColor3 = C.Border; profileDivider.BackgroundTransparency = 0.6

	profileDivider.Size = UDim2.new(1,0,0,1); profileDivider.LayoutOrder = 12; profileDivider.BorderSizePixel = 0; profileDivider.ZIndex = 201; profileDivider.Parent = configPanel

	regAccent(profileDivider, "BackgroundColor3", "Border")

	local profileSectionLabel = Instance.new("TextLabel"); profileSectionLabel.BackgroundTransparency = 1; profileSectionLabel.Size = UDim2.new(1,0,0,16)

	profileSectionLabel.FontFace = FONT; profileSectionLabel.TextSize = 11; profileSectionLabel.TextColor3 = C.TextWhite

	profileSectionLabel.TextXAlignment = Enum.TextXAlignment.Left; profileSectionLabel.Text = "Player"

	profileSectionLabel.LayoutOrder = 13; profileSectionLabel.ZIndex = 201; profileSectionLabel.Parent = configPanel

	regAccent(profileSectionLabel, "TextColor3", "TextWhite")

	local profileCard = Instance.new("Frame"); profileCard.BackgroundColor3 = C.Background; profileCard.BackgroundTransparency = 1

	profileCard.Size = UDim2.new(0,TAB_WIDTH,0,64); profileCard.AnchorPoint = Vector2.new(0,1); profileCard.Position = UDim2.new(0,0,1,0)

	regAccent(profileCard, "BackgroundColor3", "Background")

	profileCard.ZIndex = 4; profileCard.Visible = false; profileCard.ClipsDescendants = true; profileCard.Parent = mainFrame

	local profileTopBorder = Instance.new("Frame"); profileTopBorder.BackgroundColor3 = C.Border; profileTopBorder.BackgroundTransparency = 0.4

	profileTopBorder.Size = UDim2.new(1,0,0,1); profileTopBorder.BorderSizePixel = 0; profileTopBorder.ZIndex = 5; profileTopBorder.Parent = profileCard

	regAccent(profileTopBorder, "BackgroundColor3", "Border")

	local avatarImg = Instance.new("ImageLabel"); avatarImg.BackgroundColor3 = Color3.fromRGB(45,45,45)

	avatarImg.Size = UDim2.new(0,38,0,38); avatarImg.Position = UDim2.new(0,12,0.5,-19); avatarImg.ZIndex = 5; avatarImg.Parent = profileCard; createCorner(avatarImg, 19)

	local avatarStroke = createStroke(avatarImg, C.Border, 1.5, 0.3)

	regAccent(avatarStroke, "Color", "Border")

	local displayNameLabel = Instance.new("TextLabel"); displayNameLabel.BackgroundTransparency = 1

	displayNameLabel.Size = UDim2.new(1,-62,0,15); displayNameLabel.Position = UDim2.new(0,58,0.5,-17)

	displayNameLabel.FontFace = FONT_BOLD; displayNameLabel.TextSize = 12; displayNameLabel.TextColor3 = C.TextWhite

	displayNameLabel.TextXAlignment = Enum.TextXAlignment.Left; displayNameLabel.TextTruncate = Enum.TextTruncate.AtEnd

	displayNameLabel.Text = Player.DisplayName; displayNameLabel.ZIndex = 5; displayNameLabel.Parent = profileCard

	regAccent(displayNameLabel, "TextColor3", "TextWhite")

	local usernameLabel = Instance.new("TextLabel"); usernameLabel.BackgroundTransparency = 1

	usernameLabel.Size = UDim2.new(1,-62,0,12); usernameLabel.Position = UDim2.new(0,58,0.5,1)

	usernameLabel.FontFace = FONT; usernameLabel.TextSize = 10; usernameLabel.TextColor3 = C.AccentBright

	usernameLabel.TextTransparency = 0.1; usernameLabel.TextXAlignment = Enum.TextXAlignment.Left; usernameLabel.TextTruncate = Enum.TextTruncate.AtEnd

	usernameLabel.Text = "@"..Player.Name; usernameLabel.ZIndex = 5; usernameLabel.Parent = profileCard

	regTheme(function() usernameLabel.TextColor3 = C.AccentBright end)

	task.spawn(function()

		local ok, thumb = pcall(function() return Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size60x60) end)

		if ok and thumb then avatarImg.Image = thumb end

	end)

	local function updateProfileCard(enabled)

		profileCardVisible = enabled

		if enabled then profileCard.Visible = true; tabSidebar.Size = UDim2.new(0,TAB_WIDTH,1,-HEADER_HEIGHT-1-SEARCH_H-64)

		else profileCard.Visible = false; tabSidebar.Size = UDim2.new(0,TAB_WIDTH,1,-HEADER_HEIGHT-1-SEARCH_H) end

	end

	makeConfigToggle("Profile", 14, function(val) updateProfileCard(val) end, uiSettings.showProfile)

	local configOverlay = Instance.new("TextButton"); configOverlay.BackgroundColor3 = Color3.fromRGB(0,0,0); configOverlay.BackgroundTransparency = 1

	configOverlay.Size = UDim2.new(1,0,1,0); configOverlay.Text = ""; configOverlay.ZIndex = 195

	configOverlay.Visible = false; configOverlay.AutoButtonColor = false; configOverlay.Parent = screenGui

	local dragStart, startPos, resizeDragStart, resizeStartSize

	local function clampPosition(frame)

		local a = frame.AbsoluteSize; local ss = screenGui.AbsoluteSize; local pos = frame.Position

		local px = math.clamp(pos.X.Offset+pos.X.Scale*ss.X, -a.X+60, ss.X-60)

		local py = math.clamp(pos.Y.Offset+pos.Y.Scale*ss.Y, 0, ss.Y-HEADER_HEIGHT)

		frame.Position = UDim2.new(0,px,0,py)

	end

	local headerInput = Instance.new("TextButton"); headerInput.BackgroundTransparency = 1; headerInput.Size = UDim2.new(0.55,0,1,0)

	headerInput.Text = ""; headerInput.ZIndex = 6; headerInput.AutoButtonColor = false; headerInput.Parent = header

	table.insert(windowData.connections, headerInput.InputBegan:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then

			windowData.dragging = true; dragStart = Vector2.new(input.Position.X, input.Position.Y); startPos = mainFrame.Position

		end

	end))

	table.insert(windowData.connections, UserInputService.InputChanged:Connect(function(input)

		if windowData.dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then

			local d = Vector2.new(input.Position.X, input.Position.Y)-dragStart; local ss = screenGui.AbsoluteSize

			mainFrame.Position = UDim2.new(0, startPos.X.Offset+startPos.X.Scale*ss.X+d.X, 0, startPos.Y.Offset+startPos.Y.Scale*ss.Y+d.Y)

		end

		if windowData.resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then

			local d = Vector2.new(input.Position.X, input.Position.Y)-resizeDragStart

			mainFrame.Size = UDim2.new(0, math.clamp(resizeStartSize.X+d.X, MIN_SIZE.X, MAX_SIZE.X), 0, math.clamp(resizeStartSize.Y+d.Y, MIN_SIZE.Y, MAX_SIZE.Y))

		end

	end))

	table.insert(windowData.connections, UserInputService.InputEnded:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then

			if windowData.dragging then windowData.dragging = false; clampPosition(mainFrame) end

			if windowData.resizing then windowData.resizing = false end

		end

	end))

	table.insert(windowData.connections, resizeHandle.InputBegan:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then

			windowData.resizing = true; resizeDragStart = Vector2.new(input.Position.X, input.Position.Y); resizeStartSize = mainFrame.AbsoluteSize

		end

	end))

	local isSearching = false

	local searchStashedFrames = {}

	local function restoreSearchFrames()

		for _, s in ipairs(searchStashedFrames) do

			if s.frame and s.frame.Parent then s.frame.LayoutOrder = s.order; s.frame.Parent = s.parent end

		end

		searchStashedFrames = {}

	end

	local function selectTab(tabName)

		if windowData.selectedTab == tabName then return end; windowData.selectedTab = tabName

		if searchInput and searchInput.Text ~= "" then searchInput.Text = "" end

		if isSearching then restoreSearchFrames(); isSearching = false; searchResultsFrame.Visible = false; contentFrame.Visible = true end

		for name, td in pairs(windowData.tabs) do

			local sel = (name == tabName); local tk = "tab_select_"..name; cancelTweens(tk)

			if sel then

				playTween(tk, td.frame, TWEEN_SMOOTH, {BackgroundColor3=C.TabSelected, BackgroundTransparency=0.5})

				playTween(tk, td.indicator, TWEEN_SMOOTH, {BackgroundTransparency=0, Size=UDim2.new(0,3,0.6,0)})

				playTween(tk, td.titleLabel, TWEEN_SMOOTH, {TextColor3=C.AccentBright, TextTransparency=0})

				playTween(tk, td.subtitleLabel, TWEEN_SMOOTH, {TextColor3=C.Accent, TextTransparency=0.1})

				playTween(tk, td.iconLabel, TWEEN_SMOOTH, {ImageColor3=C.AccentBright, ImageTransparency=0})

			else

				playTween(tk, td.frame, TWEEN_SMOOTH, {BackgroundColor3=C.TabDefault, BackgroundTransparency=1})

				playTween(tk, td.indicator, TWEEN_SMOOTH, {BackgroundTransparency=1, Size=UDim2.new(0,3,0,0)})

				playTween(tk, td.titleLabel, TWEEN_SMOOTH, {TextColor3=C.TextSubtitle, TextTransparency=0.45})

				playTween(tk, td.subtitleLabel, TWEEN_SMOOTH, {TextColor3=C.TextSubtitle, TextTransparency=0.65})

				playTween(tk, td.iconLabel, TWEEN_SMOOTH, {ImageColor3=C.TextSubtitle, ImageTransparency=0.6})

			end

			if td.page then td.page.Visible = sel end

		end

	end

	local function buildSearchResults(query)

		restoreSearchFrames()

		for _, ch in ipairs(searchResultsFrame:GetChildren()) do

			if not ch:IsA("UIListLayout") and not ch:IsA("UIPadding") then ch:Destroy() end

		end

		if query == "" then isSearching = false; searchResultsFrame.Visible = false; contentFrame.Visible = true; return end

		isSearching = true; searchResultsFrame.Visible = true; contentFrame.Visible = false

		local q = query:lower(); local count = 0

		for _, entry in ipairs(windowData.searchRegistry) do

			local titleMatch = entry.title:lower():find(q, 1, true)

			local descMatch  = entry.desc ~= "" and entry.desc:lower():find(q, 1, true)

			if titleMatch or descMatch then

				count = count + 1

				local f = entry.frame

				if f and f.Parent then

					table.insert(searchStashedFrames, {frame=f, parent=f.Parent, order=f.LayoutOrder})

					f.LayoutOrder = count; f.Parent = searchResultsFrame

				end

			end

		end

		if count == 0 then

			local emptyLbl = Instance.new("TextLabel"); emptyLbl.BackgroundTransparency = 1

			emptyLbl.Size = UDim2.new(1,0,0,40); emptyLbl.LayoutOrder = 1; emptyLbl.ZIndex = 11

			emptyLbl.FontFace = FONT; emptyLbl.TextSize = 12; emptyLbl.TextColor3 = C.TextSubtitle

			emptyLbl.TextXAlignment = Enum.TextXAlignment.Center; emptyLbl.Text = "No results found"; emptyLbl.Parent = searchResultsFrame

		end

	end

	searchInput:GetPropertyChangedSignal("Text"):Connect(function() buildSearchResults(searchInput.Text) end)

	searchInput.FocusLost:Connect(function() if searchInput.Text == "" then buildSearchResults("") end end)

	local showNotify

	local color3ToHex

	local windowLoaded = false

	local notifyQueue = {}

	local NOTIFY_W = 290; local NOTIFY_MX = 18; local NOTIFY_MY = 18; local NOTIFY_GAP = 8

	local notifyGui = Instance.new("ScreenGui"); notifyGui.Name = "NightMysticNotify"; notifyGui.ResetOnSpawn = false

	notifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; notifyGui.IgnoreGuiInset = true; notifyGui.AutoLocalize = false; notifyGui.DisplayOrder = 30; notifyGui.Parent = PlayerGui

	local activeNotifs = {}; local notifyCount = 0

	color3ToHex = function(c)

		return string.format("#%02X%02X%02X", math.floor(c.R*255+0.5), math.floor(c.G*255+0.5), math.floor(c.B*255+0.5))

	end

	showNotify = function(nc)

		nc = nc or {}

		if not windowLoaded then table.insert(notifyQueue, nc); return end

		playSound(SND_NOTIFY)

		local ntitle = nc.Title or "Notification"; local ntext = nc.Text or ""

		local nicon = nc.Icon or "rbxassetid://124914698428562"; local ndur = math.max(nc.Duration or 4, 0.5)

		local richText = nc.RichText == true; local hasText = ntext ~= ""; local NH = hasText and 80 or 56

		notifyCount = notifyCount + 1; local nid = notifyCount

		for _, nd in ipairs(activeNotifs) do

			nd.targetY = nd.targetY - (NH + NOTIFY_GAP); cancelTweens(nd.posKey)

			playTween(nd.posKey, nd.frame, TWEEN_SMOOTH, {Position=UDim2.new(1,-(NOTIFY_W+NOTIFY_MX),1,nd.targetY)})

		end

		local initY = -NOTIFY_MY

		local nf = Instance.new("Frame"); nf.BackgroundColor3 = C.Background; nf.BackgroundTransparency = 0

		nf.Size = UDim2.new(0,NOTIFY_W,0,NH); nf.AnchorPoint = Vector2.new(0,1)

		nf.Position = UDim2.new(1,NOTIFY_MX+NOTIFY_W,1,initY); nf.ZIndex = 100; nf.ClipsDescendants = true; nf.Parent = notifyGui

		createCorner(nf, 10); local nStroke = createStroke(nf, C.Border, 1, 0.3)

		local nfShadow = createShadow(nf); nfShadow.ImageTransparency = 0.6

		local ICON_PANEL_W = 52

		local iconPanel = Instance.new("Frame"); iconPanel.BackgroundColor3 = C.AccentDeep; iconPanel.BackgroundTransparency = 1; iconPanel.Size = UDim2.new(0,ICON_PANEL_W,1,-3); iconPanel.Position = UDim2.new(0,0,0,0); iconPanel.BorderSizePixel = 0; iconPanel.ZIndex = 100; iconPanel.Parent = nf

		regTheme(function() if not iconPanel or not iconPanel.Parent then return end; iconPanel.BackgroundColor3 = C.AccentDeep end)

		local ICON_IMG_SIZE = 28
		local iconLbl = Instance.new("ImageLabel"); iconLbl.BackgroundTransparency = 1
		iconLbl.Size = UDim2.new(0,ICON_IMG_SIZE,0,ICON_IMG_SIZE); iconLbl.AnchorPoint = Vector2.new(0.5,0.5); iconLbl.Position = UDim2.new(0,ICON_PANEL_W/2,0.5,0); iconLbl.ScaleType = Enum.ScaleType.Fit
		local iconColor = nc.IconColor
      iconLbl.Image = nicon; iconLbl.ImageColor3 = iconColor or C.Accent; iconLbl.ZIndex = 101; iconLbl.Parent = nf

		local notifDivider = Instance.new("Frame"); notifDivider.BackgroundColor3 = C.Border; notifDivider.BackgroundTransparency = 0.25; notifDivider.BorderSizePixel = 0; notifDivider.Size = UDim2.new(0,1,1,-12); notifDivider.Position = UDim2.new(0,ICON_PANEL_W,0,6); notifDivider.ZIndex = 101; notifDivider.Parent = nf
		regTheme(function() if not notifDivider or not notifDivider.Parent then return end; notifDivider.BackgroundColor3 = C.Border end)

		local titleY = hasText and 10 or math.floor((NH-16)/2)

		local titleLbl2 = Instance.new("TextLabel"); titleLbl2.BackgroundTransparency = 1

		titleLbl2.Size = UDim2.new(1,-(ICON_PANEL_W+50),0,16); titleLbl2.Position = UDim2.new(0,ICON_PANEL_W+8,0,titleY)

		titleLbl2.FontFace = FONT_BOLD; titleLbl2.TextSize = 12; titleLbl2.TextColor3 = C.AccentBright

		titleLbl2.TextXAlignment = Enum.TextXAlignment.Left; titleLbl2.TextTruncate = Enum.TextTruncate.AtEnd

		titleLbl2.RichText = false; titleLbl2.Text = ntitle; titleLbl2.ZIndex = 101; titleLbl2.Parent = nf

		local textLbl

		if hasText then

			textLbl = Instance.new("TextLabel"); textLbl.BackgroundTransparency = 1

			textLbl.Size = UDim2.new(1,-(ICON_PANEL_W+16),0,30); textLbl.Position = UDim2.new(0,ICON_PANEL_W+8,0,28)

			textLbl.FontFace = FONT; textLbl.TextSize = 11; textLbl.TextColor3 = BASE_COLORS.TextWhite; textLbl.TextTransparency = 0.1

			textLbl.TextXAlignment = Enum.TextXAlignment.Left; textLbl.TextWrapped = true

			textLbl.RichText = richText; textLbl.Text = ntext; textLbl.ZIndex = 101; textLbl.Parent = nf

		end

		local barBg = Instance.new("Frame"); barBg.BackgroundColor3 = Color3.fromRGB(38,38,38); barBg.BackgroundTransparency = 0.2

		barBg.Size = UDim2.new(1,0,0,3); barBg.Position = UDim2.new(0,0,1,-3); barBg.ZIndex = 101; barBg.Parent = nf; createCorner(barBg, 2)

		local bar = Instance.new("Frame"); bar.BackgroundColor3 = C.Accent; bar.Size = UDim2.new(1,0,1,0); bar.ZIndex = 102; bar.Parent = barBg; createCorner(bar, 2)

		local nd = {frame=nf, targetY=initY, posKey="npos_"..nid, height=NH, iconLbl=iconLbl, titleLbl=titleLbl2, bar=bar, nStroke=nStroke}

		table.insert(activeNotifs, 1, nd)

		regTheme(function()
			if not nf or not nf.Parent then return end
			nf.BackgroundColor3 = C.Background; if not nc.IconColor then iconLbl.ImageColor3 = C.Accent end; titleLbl2.TextColor3 = C.AccentBright; bar.BackgroundColor3 = C.Accent; nStroke.Color = C.Border
			if richText and textLbl then textLbl.Text = string.gsub(ntext, 'color="#[%x]+"', 'color="' .. color3ToHex(C.Accent) .. '"') end
		end)

		local dismissed = false
		local function dismissNotif()
			if dismissed or not nf or not nf.Parent then return end
			dismissed = true
			local expiredY = nd.targetY
			for i, ndd in ipairs(activeNotifs) do if ndd.frame == nf then table.remove(activeNotifs, i); break end end
			for _, ndd in ipairs(activeNotifs) do
				if ndd.targetY < expiredY then
					ndd.targetY = ndd.targetY + (NH + NOTIFY_GAP); cancelTweens(ndd.posKey)
					playTween(ndd.posKey, ndd.frame, TWEEN_SMOOTH, {Position=UDim2.new(1,-(NOTIFY_W+NOTIFY_MX),1,ndd.targetY)})
				end
			end
			local curY = nf.Position.Y.Offset; cancelTweens("nslide_"..nid)
			local fadeOut = TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
			TweenService:Create(nf, fadeOut, {Position=UDim2.new(1,NOTIFY_MX+NOTIFY_W,1,curY), BackgroundTransparency=1}):Play()
			for _, ch in ipairs(nf:GetDescendants()) do
				if ch:IsA("TextLabel") then TweenService:Create(ch, fadeOut, {TextTransparency=1}):Play()
				elseif ch:IsA("ImageLabel") then TweenService:Create(ch, fadeOut, {ImageTransparency=1}):Play()
				elseif ch:IsA("Frame") then TweenService:Create(ch, fadeOut, {BackgroundTransparency=1}):Play()
				elseif ch:IsA("UIStroke") then TweenService:Create(ch, fadeOut, {Transparency=1}):Play() end
			end
			task.delay(0.26, function() if nf and nf.Parent then nf:Destroy() end end)
		end

		local closeBtn = Instance.new("TextButton"); closeBtn.BackgroundTransparency = 1
		closeBtn.Size = UDim2.new(0,18,0,18); closeBtn.Position = UDim2.new(1,-24,0,6)
		closeBtn.Text = "×"; closeBtn.TextSize = 16; closeBtn.FontFace = FONT_BOLD
		closeBtn.TextColor3 = C.TextWhite; closeBtn.TextTransparency = 0.3; closeBtn.ZIndex = 103; closeBtn.Parent = nf
		closeBtn.MouseEnter:Connect(function() closeBtn.TextTransparency = 0 end)
		closeBtn.MouseLeave:Connect(function() closeBtn.TextTransparency = 0.3 end)
		closeBtn.MouseButton1Click:Connect(dismissNotif)

		playTween("nslide_"..nid, nf, TWEEN_SMOOTH, {Position=UDim2.new(1,-(NOTIFY_W+NOTIFY_MX),1,initY)})

		TweenService:Create(bar, TweenInfo.new(ndur, Enum.EasingStyle.Linear), {Size=UDim2.new(0,0,1,0)}):Play()

		task.delay(ndur, dismissNotif)

	end

	local function makeDialog(question, diagKey, onYes)

		blurFrame.Visible = true; blurFrame.BackgroundTransparency = 1

		cancelTweens(diagKey); playTween(diagKey, blurFrame, TWEEN_SMOOTH, {BackgroundTransparency=0.6})

		local dg = Instance.new("Frame"); dg.BackgroundColor3 = C.DialogBg; dg.Size = UDim2.new(0,280,0,130)

		dg.Position = UDim2.new(0.5,-140,0.5,-65); dg.BackgroundTransparency = 1; dg.ZIndex = 51; dg.Parent = mainFrame

		createCorner(dg, 12); createStroke(dg, C.Border, 1, 0.4)

		local dgShadow = createShadow(dg); dgShadow.ImageTransparency = 1

		playTween(diagKey, dg, TWEEN_SMOOTH, {BackgroundTransparency=0}); playTween(diagKey, dgShadow, TWEEN_SMOOTH, {ImageTransparency=0.5})

		local ql = Instance.new("TextLabel"); ql.BackgroundTransparency = 1; ql.Size = UDim2.new(1,-20,0,50); ql.Position = UDim2.new(0,10,0,15)

		ql.FontFace = FONT; ql.TextSize = 14; ql.TextColor3 = C.TextWhite; ql.Text = question; ql.TextWrapped = true; ql.TextTransparency = 1; ql.ZIndex = 52; ql.Parent = dg

		playTween(diagKey, ql, TWEEN_SMOOTH, {TextTransparency=0})

		local brc = Instance.new("Frame"); brc.BackgroundTransparency = 1; brc.Size = UDim2.new(1,-30,0,36); brc.Position = UDim2.new(0,15,1,-52); brc.ZIndex = 52; brc.Parent = dg

		local brl = Instance.new("UIListLayout"); brl.FillDirection = Enum.FillDirection.Horizontal; brl.HorizontalAlignment = Enum.HorizontalAlignment.Center; brl.Padding = UDim.new(0,12); brl.Parent = brc

		local function mkBtn(text, order)

			local db = Instance.new("TextButton"); db.BackgroundColor3 = Color3.fromRGB(25,25,25)

			db.Size = UDim2.new(0,100,0,34); db.FontFace = FONT; db.TextSize = 13; db.TextColor3 = C.TextWhite; db.Text = text

			db.AutoButtonColor = false; db.LayoutOrder = order; db.ZIndex = 53; db.BackgroundTransparency = 1; db.TextTransparency = 1; db.Parent = brc

			createCorner(db, 8); createStroke(db, C.Border, 1, 0.6)

			playTween(diagKey, db, TWEEN_SMOOTH, {BackgroundTransparency=0, TextTransparency=0})

			local dk = diagKey.."btn_"..text

			db.MouseEnter:Connect(function() cancelTweens(dk); playTween(dk, db, TWEEN_FAST, {BackgroundColor3=Color3.fromRGB(35,35,35), Size=UDim2.new(0,106,0,36), TextColor3=C.Accent}) end)

			db.MouseLeave:Connect(function() cancelTweens(dk); playTween(dk, db, TWEEN_FAST, {BackgroundColor3=Color3.fromRGB(25,25,25), Size=UDim2.new(0,100,0,34), TextColor3=C.TextWhite}) end)

			return db

		end

		local yBtn = mkBtn("Yes", 1); local nBtn = mkBtn("No", 2)

		local function closeDg(cb)

			cancelTweens(diagKey); local outI = TweenInfo.new(0.26, Enum.EasingStyle.Quart, Enum.EasingDirection.In)

			playTween(diagKey, dg, outI, {BackgroundTransparency=1}); playTween(diagKey, ql, outI, {TextTransparency=1})

			playTween(diagKey, yBtn, outI, {BackgroundTransparency=1, TextTransparency=1}); playTween(diagKey, nBtn, outI, {BackgroundTransparency=1, TextTransparency=1})

			playTween(diagKey, blurFrame, outI, {BackgroundTransparency=1})

			if dgShadow then playTween(diagKey, dgShadow, outI, {ImageTransparency=1}) end

			task.delay(0.3, function() blurFrame.Visible = false; if dg and dg.Parent then dg:Destroy() end; if cb then cb() end end)

		end

		yBtn.MouseButton1Click:Connect(function() closeDg(function() onYes() end) end)

		nBtn.MouseButton1Click:Connect(function() closeDg(nil) end)

	end

	local function showDialog()

		makeDialog("Do you want to dismiss the window?", "dialog_close", function()

			windowData.destroyed = true

			for _, td in pairs(windowData.tabs) do if td.stopTitleSlide then td.stopTitleSlide() end; if td.stopSubSlide then td.stopSubSlide() end end

			local closeOut = TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.In)

			local windowScale = Instance.new("UIScale"); windowScale.Scale = 1; windowScale.Parent = mainFrame

			playTween("window_close", windowScale, closeOut, {Scale=0.93}); playTween("window_close", mainFrame, closeOut, {BackgroundTransparency=1})

			playTween("window_close", mainStroke, closeOut, {Transparency=1})

			task.delay(0.34, function()

				for _, c in ipairs(windowData.connections) do if typeof(c) == "RBXScriptConnection" then c:Disconnect() end end

				screenGui:Destroy(); notifyGui:Destroy()

			end)

		end)

	end

	table.insert(windowData.connections, buttons.Close.MouseButton1Click:Connect(function() if not windowData.destroyed then showDialog() end end))

	table.insert(windowData.connections, buttons.Maximize.MouseButton1Click:Connect(function()

		if windowData.destroyed then return end; cancelTweens("maximize")

		if windowData.maximized then

			windowData.maximized = false; playTween("maximize", mainFrame, TWEEN_SMOOTH, {Size=windowData.preMaxSize, Position=windowData.preMaxPos}); resizeHandle.Visible = true

		else

			windowData.preMaxSize = mainFrame.Size; windowData.preMaxPos = mainFrame.Position; windowData.maximized = true

			local ss = screenGui.AbsoluteSize; playTween("maximize", mainFrame, TWEEN_SMOOTH, {Size=UDim2.new(0,ss.X,0,ss.Y), Position=UDim2.new(0,0,0,0)}); resizeHandle.Visible = false

		end

	end))

	table.insert(windowData.connections, buttons.Minimize.MouseButton1Click:Connect(function()

		if windowData.destroyed then return end; cancelTweens("minimize")

		if windowData.minimized then

			windowData.minimized = false; contentFrame.Visible = true; tabSidebar.Visible = true; tabDivider.Visible = true; resizeHandle.Visible = true; searchBar.Visible = true

			if profileCardVisible then profileCard.Visible = true end

			playTween("minimize", mainFrame, TWEEN_SMOOTH, {Size=windowData.preMinSize})

		else

			windowData.preMinSize = mainFrame.Size; windowData.minimized = true

			playTween("minimize", mainFrame, TWEEN_SMOOTH, {Size=UDim2.new(0, mainFrame.AbsoluteSize.X, 0, HEADER_HEIGHT)})

			task.delay(0.38, function()

				if windowData.minimized then contentFrame.Visible = false; tabSidebar.Visible = false; tabDivider.Visible = false; resizeHandle.Visible = false; searchBar.Visible = false; profileCard.Visible = false end

			end)

		end

	end))

	local function getMainFrameAbsolutePosition()

		local ss = screenGui.AbsoluteSize; local p = mainFrame.Position

		return Vector2.new(p.X.Scale*ss.X+p.X.Offset, p.Y.Scale*ss.Y+p.Y.Offset)

	end

	local function openConfig()

		if windowData.configOpen then return end; windowData.configOpen = true

		local mfPos = getMainFrameAbsolutePosition(); local mfSize = mainFrame.AbsoluteSize

		configPanel.Size = UDim2.new(0,220,0,windowData.minimized and 250 or mfSize.Y)

		configPanel.Position = UDim2.new(0, mfPos.X+mfSize.X, 0, mfPos.Y)

		configPanel.BackgroundTransparency = 1; configPanel.Visible = true

		configOverlay.Visible = true; configOverlay.BackgroundTransparency = 1; cancelTweens("config")

		playTween("config", configPanel, TWEEN_SMOOTH, {Position=UDim2.new(0, mfPos.X+mfSize.X+8, 0, mfPos.Y), BackgroundTransparency=0})

		playTween("config", configOverlay, TWEEN_SMOOTH, {BackgroundTransparency=0.6})

	end

	closeConfig = function()

		if not windowData.configOpen then return end; windowData.configOpen = false; cancelTweens("config")

		local mfPos = getMainFrameAbsolutePosition(); local mfSize = mainFrame.AbsoluteSize

		local cfgOut = TweenInfo.new(0.26, Enum.EasingStyle.Quart, Enum.EasingDirection.In)

		playTween("config", configPanel, cfgOut, {Position=UDim2.new(0, mfPos.X+mfSize.X, 0, mfPos.Y), BackgroundTransparency=1})

		playTween("config", configOverlay, cfgOut, {BackgroundTransparency=1})

		task.delay(0.3, function() if not windowData.configOpen then configPanel.Visible = false; configOverlay.Visible = false end end)

	end

	table.insert(windowData.connections, buttons.Config.MouseButton1Click:Connect(function() if not windowData.destroyed then openConfig() end end))

	table.insert(windowData.connections, configOverlay.MouseButton1Click:Connect(function() closeConfig() end))

	local hidden = false

	local function toggleWindowVisible()

		if windowData.destroyed then return end

		hidden = not hidden

		mainFrame.Visible = not hidden

	end

	table.insert(windowData.connections, UserInputService.InputBegan:Connect(function(input, gp)

		if gp then return end

		if input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.LeftControl then toggleWindowVisible() end

	end))

	local floatGui = Instance.new("ScreenGui"); floatGui.Name = "NightMysticFloat"; floatGui.ResetOnSpawn = false

	floatGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; floatGui.IgnoreGuiInset = true; floatGui.AutoLocalize = false; floatGui.DisplayOrder = 10; floatGui.Parent = PlayerGui

	local floatBtn = Instance.new("TextButton"); floatBtn.BackgroundColor3 = Color3.fromRGB(18,18,18); floatBtn.BackgroundTransparency = 0

	floatBtn.Size = UDim2.new(0,50,0,50); floatBtn.AnchorPoint = Vector2.new(0,0)

	floatBtn.Position = UDim2.new(1,-70,1,-70); floatBtn.Text = ""; floatBtn.AutoButtonColor = false; floatBtn.ZIndex = 1; floatBtn.Parent = floatGui

	createCorner(floatBtn, 25)

	local floatStroke = createStroke(floatBtn, C.Accent, 1.5, 0.3); regTheme(function() floatStroke.Color = C.Accent end)

	if icon ~= "" then

		local fbIconLabel = Instance.new("ImageLabel"); fbIconLabel.BackgroundTransparency = 1

		fbIconLabel.Size = UDim2.new(1,0,1,0); fbIconLabel.Image = icon

		fbIconLabel.ImageColor3 = Color3.new(1,1,1); fbIconLabel.ScaleType = Enum.ScaleType.Crop; fbIconLabel.ZIndex = 2; fbIconLabel.Parent = floatBtn

		createCorner(fbIconLabel, 25)

	end

	local fbDragging, fbDragStart, fbStartPos, fbDragMoved = false, Vector2.new(0,0), floatBtn.Position, false
	local fbActiveInput = nil

	floatBtn.InputBegan:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then

			if fbActiveInput ~= nil then return end
			fbActiveInput = input
			fbDragging = true; fbDragMoved = false; fbDragStart = Vector2.new(input.Position.X, input.Position.Y); fbStartPos = floatBtn.Position

		end

	end)

	table.insert(windowData.connections, UserInputService.InputChanged:Connect(function(input)

		if not fbDragging or input ~= fbActiveInput then return end

		local delta = Vector2.new(input.Position.X, input.Position.Y)-fbDragStart; if delta.Magnitude > 6 then fbDragMoved = true end

		local fgSize = floatGui.AbsoluteSize; local bx = fbStartPos.X.Offset+fbStartPos.X.Scale*fgSize.X; local by = fbStartPos.Y.Offset+fbStartPos.Y.Scale*fgSize.Y

		floatBtn.Position = UDim2.new(0, math.clamp(bx+delta.X, 0, fgSize.X-50), 0, math.clamp(by+delta.Y, 0, fgSize.Y-50))

	end))

	table.insert(windowData.connections, UserInputService.InputEnded:Connect(function(input)

		if input ~= fbActiveInput then return end

		if fbDragging and not fbDragMoved then toggleWindowVisible() end

		fbDragging = false
		fbActiveInput = nil

	end))

	floatBtn.MouseEnter:Connect(function() cancelTweens("fb_hover"); playTween("fb_hover", floatBtn, TWEEN_FAST, {BackgroundTransparency=0.15}) end)

	floatBtn.MouseLeave:Connect(function() cancelTweens("fb_hover"); playTween("fb_hover", floatBtn, TWEEN_FAST, {BackgroundTransparency=0}) end)

	task.delay(0.1, function()

		playSound(SND_OPEN)

		mainFrame.Visible = true; cancelTweens("window_open")

		if uiSettings.acrylicEnabled then

			windowData.acrylicEnabled = true; windowData.acrylicOpacity = uiSettings.acrylicOpacity

			acrylicToggle.BackgroundColor3 = C.Accent; acrylicKnob.Position = UDim2.new(1,-19,0.5,-8)

			local pct = uiSettings.acrylicOpacity; opacityFill.Size = UDim2.new(pct,0,1,0); opacityKnob.Position = UDim2.new(pct,-6,0.5,-6)

			opValBox.Text = tostring(math.floor(pct*100)).."%"

			playTween("window_open", mainFrame, TWEEN_MEDIUM, {Size=UDim2.new(0,size.X,0,size.Y), BackgroundTransparency=pct})

		else

			playTween("window_open", mainFrame, TWEEN_MEDIUM, {Size=UDim2.new(0,size.X,0,size.Y), BackgroundTransparency=0})

		end

		if uiSettings.theme == "Custom" and uiSettings.customColorHex and uiSettings.customColorHex ~= "" then

			local hx = uiSettings.customColorHex:gsub("#", "")

			local r = tonumber(hx:sub(1,2), 16); local g = tonumber(hx:sub(3,4), 16); local b = tonumber(hx:sub(5,6), 16)

			if r and g and b then

				windowData.customColorHex = uiSettings.customColorHex

				local col = Color3.fromRGB(r,g,b)

				applyTheme(col)

				setPickerColor(col)

			end

		elseif uiSettings.theme ~= currentThemeName and THEMES[uiSettings.theme] then

			applyTheme(uiSettings.theme)

		end

		windowData.wallpaperOpacity = uiSettings.wallpaperOpacity

		wpOpacityFill.Size = UDim2.new(windowData.wallpaperOpacity,0,1,0); wpOpacityKnob.Position = UDim2.new(windowData.wallpaperOpacity,-5,0.5,-5)

		wpOpacityValueBox.Text = tostring(math.floor(windowData.wallpaperOpacity*100)).."%"

		if uiSettings.backgroundImageId and uiSettings.backgroundImageId ~= "" then

			windowData.backgroundImageId = uiSettings.backgroundImageId

			bgImageInput.Text = uiSettings.backgroundImageId

			if themeBackground then

				themeBackground.Image = "rbxassetid://" .. uiSettings.backgroundImageId

				themeBackground.Visible = true

			end

		end

		if themeBackground then themeBackground.ImageTransparency = 1 - windowData.wallpaperOpacity end

		playTween("window_open", mainStroke, TWEEN_MEDIUM, {Transparency=0.6}); playTween("window_open", initShadow, TWEEN_SLOW, {ImageTransparency=0.5})

		windowLoaded = true

		for _, fn in ipairs(pendingDefaults) do task.spawn(fn) end

		pendingDefaults = {}

		for i, qnc in ipairs(notifyQueue) do

			task.delay((i-1)*0.15, function() if showNotify then showNotify(qnc) end end)

		end

		notifyQueue = {}

	end)

	local sidebarOrder = 0

	local windowObj = {}

	function windowObj:T(tcArg)

		local tc = type(tcArg) == "table" and tcArg or {Title = tostring(tcArg)}

		local tabTitle    = tc.Title    or "Tab"

		local tabSubtitle = tc.Subtitle or ""

		local tabIcon     = tc.Icon     or ""

		sidebarOrder = sidebarOrder + 1

		local tabFrame = Instance.new("TextButton"); tabFrame.BackgroundColor3 = C.TabDefault; tabFrame.BackgroundTransparency = 1

		tabFrame.Size = UDim2.new(1,-8,0,TAB_HEIGHT); tabFrame.AutoButtonColor = false; tabFrame.Text = ""

		tabFrame.LayoutOrder = sidebarOrder; tabFrame.ZIndex = 4; tabFrame.Parent = tabSidebar; createCorner(tabFrame, 6)

		local indicator = Instance.new("Frame"); indicator.BackgroundColor3 = C.Accent; indicator.BackgroundTransparency = 1

		indicator.Size = UDim2.new(0,3,0,0); indicator.Position = UDim2.new(0,0,0.2,0); indicator.BorderSizePixel = 0; indicator.ZIndex = 5; indicator.Parent = tabFrame; createCorner(indicator, 2)

		regTheme(function() indicator.BackgroundColor3 = C.Accent end)

		local tabIconLabel = Instance.new("ImageLabel"); tabIconLabel.BackgroundTransparency = 1

		tabIconLabel.Size = UDim2.new(0,TAB_ICON_SIZE,0,TAB_ICON_SIZE); tabIconLabel.Position = UDim2.new(0,10,0.5,-TAB_ICON_SIZE/2)

		tabIconLabel.Image = tabIcon; tabIconLabel.ImageColor3 = C.TextSubtitle; tabIconLabel.ImageTransparency = 0.6; tabIconLabel.ZIndex = 5; tabIconLabel.Parent = tabFrame

		local textArea = Instance.new("Frame"); textArea.BackgroundTransparency = 1

		textArea.Size = UDim2.new(1,-TAB_ICON_SIZE-22,0,TAB_HEIGHT-8); textArea.Position = UDim2.new(0,TAB_ICON_SIZE+16,0.5,-(TAB_HEIGHT-8)/2)

		textArea.ClipsDescendants = true; textArea.ZIndex = 5; textArea.Parent = tabFrame

		local taLayout = Instance.new("UIListLayout"); taLayout.FillDirection = Enum.FillDirection.Vertical; taLayout.VerticalAlignment = Enum.VerticalAlignment.Center

		taLayout.Padding = UDim.new(0,0); taLayout.SortOrder = Enum.SortOrder.LayoutOrder; taLayout.Parent = textArea

		local titleClip = Instance.new("Frame"); titleClip.BackgroundTransparency = 1

		titleClip.Size = tabSubtitle ~= "" and UDim2.new(1,0,0,13) or UDim2.new(1,0,0,15)

		titleClip.ClipsDescendants = true; titleClip.LayoutOrder = 1; titleClip.ZIndex = 5; titleClip.Parent = textArea

		local tabTitleLabel = Instance.new("TextLabel"); tabTitleLabel.BackgroundTransparency = 1; tabTitleLabel.Size = UDim2.new(2,0,1,0)

		tabTitleLabel.FontFace = FONT_BOLD; tabTitleLabel.TextSize = 12; tabTitleLabel.TextColor3 = C.TextSubtitle; tabTitleLabel.TextTransparency = 0.45

		tabTitleLabel.TextXAlignment = Enum.TextXAlignment.Left; tabTitleLabel.AutomaticSize = Enum.AutomaticSize.X; tabTitleLabel.Text = tabTitle; tabTitleLabel.ZIndex = 6; tabTitleLabel.Parent = titleClip

		local subClip = Instance.new("Frame"); subClip.BackgroundTransparency = 1; subClip.Size = UDim2.new(1,0,0,11)

		subClip.ClipsDescendants = true; subClip.LayoutOrder = 2; subClip.ZIndex = 5; subClip.Visible = tabSubtitle ~= ""; subClip.Parent = textArea

		local tabSubLabel = Instance.new("TextLabel"); tabSubLabel.BackgroundTransparency = 1; tabSubLabel.Size = UDim2.new(2,0,1,0)

		tabSubLabel.FontFace = FONT_BOLD; tabSubLabel.TextSize = 9; tabSubLabel.TextColor3 = C.TextSubtitle; tabSubLabel.TextTransparency = 0.65

		tabSubLabel.TextXAlignment = Enum.TextXAlignment.Left; tabSubLabel.AutomaticSize = Enum.AutomaticSize.X; tabSubLabel.Text = tabSubtitle; tabSubLabel.ZIndex = 6; tabSubLabel.Parent = subClip

		local stopTS = startSlideText(tabTitleLabel, titleClip); local stopSS = startSlideText(tabSubLabel, subClip)

		local page = Instance.new("ScrollingFrame"); page.BackgroundTransparency = 1; page.Size = UDim2.new(1,0,1,0)

		page.Visible = false; page.ZIndex = 2; page.BorderSizePixel = 0; page.ScrollBarThickness = 2

		page.ScrollBarImageColor3 = SCROLL_NEUTRAL; page.ScrollBarImageTransparency = 0.5

		page.CanvasSize = UDim2.new(0,0,0,0); page.AutomaticCanvasSize = Enum.AutomaticSize.Y; page.Parent = contentFrame

		local pgLayout = Instance.new("UIListLayout"); pgLayout.FillDirection = Enum.FillDirection.Vertical

		pgLayout.Padding = UDim.new(0,8); pgLayout.SortOrder = Enum.SortOrder.LayoutOrder; pgLayout.Parent = page

		createPadding(page, 12, 14, 12, 12)

		local td = {frame=tabFrame, indicator=indicator, titleLabel=tabTitleLabel, subtitleLabel=tabSubLabel, iconLabel=tabIconLabel, page=page, stopTitleSlide=stopTS, stopSubSlide=stopSS}

		windowData.tabs[tabTitle] = td

		local tk = "tab_"..tabTitle

		tabFrame.MouseEnter:Connect(function()

			if windowData.selectedTab == tabTitle then return end; cancelTweens(tk.."_h")

			playTween(tk.."_h", tabFrame, TWEEN_FAST, {BackgroundColor3=C.TabHover, BackgroundTransparency=0.7})

			playTween(tk.."_h", tabTitleLabel, TWEEN_FAST, {TextTransparency=0.2}); playTween(tk.."_h", tabIconLabel, TWEEN_FAST, {ImageTransparency=0.3})

		end)

		tabFrame.MouseLeave:Connect(function()

			if windowData.selectedTab == tabTitle then return end; cancelTweens(tk.."_h")

			playTween(tk.."_h", tabFrame, TWEEN_FAST, {BackgroundColor3=C.TabDefault, BackgroundTransparency=1})

			playTween(tk.."_h", tabTitleLabel, TWEEN_FAST, {TextTransparency=0.45}); playTween(tk.."_h", tabIconLabel, TWEEN_FAST, {ImageTransparency=0.6})

		end)

		tabFrame.MouseButton1Click:Connect(function() if not windowData.destroyed then playSound(SND_CLICK); selectTab(tabTitle) end end)

		if not windowData.selectedTab then selectTab(tabTitle) end

		local pageOrder = 0

		local function registerSearch(title, desc, frame)

			table.insert(windowData.searchRegistry, {title=title, desc=desc or "", description=desc or "", frame=frame, tabName=tabTitle})

		end

		local tabObj = {}

		function tabObj:AddSection(sectionTitle)

			pageOrder = pageOrder + 1

			local sf = Instance.new("Frame"); sf.BackgroundTransparency = 1; sf.Size = UDim2.new(1,0,0,22)

			sf.LayoutOrder = pageOrder; sf.ZIndex = 3; sf.Parent = page

			local accentBar = Instance.new("Frame"); accentBar.BackgroundColor3 = C.Accent; accentBar.BackgroundTransparency = 0.35

			accentBar.Size = UDim2.new(0,2,0,14); accentBar.Position = UDim2.new(0,2,0.5,-7); accentBar.BorderSizePixel = 0; accentBar.ZIndex = 4; accentBar.Parent = sf; createCorner(accentBar, 1)

			regTheme(function() accentBar.BackgroundColor3 = C.Accent end)

			local sl = Instance.new("TextLabel"); sl.BackgroundTransparency = 1; sl.Size = UDim2.new(1,-12,1,0)

			sl.Position = UDim2.new(0,10,0,0); sl.FontFace = FONT_BOLD; sl.TextSize = 11; sl.TextColor3 = C.TextWhite; sl.TextTransparency = 0.35

			sl.TextXAlignment = Enum.TextXAlignment.Left; sl.Text = sectionTitle or ""; sl.ZIndex = 4; sl.Parent = sf

			regAccent(sl, "TextColor3", "TextWhite")

			local sObj = {}
			local function _asWrap(cfg, key)
				if not cfg then return cfg end
				if _G and _G.AutoLoadHook then
					local sv = _G.AutoLoadHook(key, nil)
					if sv ~= nil then cfg.Default = sv end
				end
				local origCb = cfg.Callback or function() end
				cfg.Callback = function(v, ...)
					if _G and _G.AutoSaveHook then _G.AutoSaveHook(key, v) end
					return origCb(v, ...)
				end
				return cfg
			end
			local function _asKey(t) return "NM_" .. tostring(t or ""):gsub("[^%w]", "_") end

			function sObj:AddToggle(cfg)

				cfg = cfg or {}

				local tTitle   = cfg.Title       or "Toggle"

				local tDesc    = cfg.Description  or ""

				local tDefault = cfg.Default      ~= nil and cfg.Default or false

				local tCb      = cfg.Callback     or function() end

				local tState   = tDefault

				pageOrder = pageOrder + 1

				local tf = Instance.new("Frame"); tf.BackgroundColor3 = C.Background; tf.BackgroundTransparency = 0.85

				if tDesc ~= "" then tf.Size = UDim2.new(1,0,0,0); tf.AutomaticSize = Enum.AutomaticSize.Y else tf.Size = UDim2.new(1,0,0,34) end; tf.LayoutOrder = pageOrder; tf.ZIndex = 3; tf.Parent = page

				addGlowHover(tf, "tog_"..tTitle..pageOrder)

				regAccent(tf, "BackgroundColor3", "Background")

				local tLabel = Instance.new("TextLabel"); tLabel.BackgroundTransparency = 1; tLabel.Size = UDim2.new(1,-60,0,18)

				if tDesc ~= "" then tLabel.Position = UDim2.new(0,6,0,8) else tLabel.AnchorPoint = Vector2.new(0,0.5); tLabel.Position = UDim2.new(0,6,0.5,0) end

				tLabel.FontFace = FONT_BOLD; tLabel.TextSize = 13; tLabel.TextColor3 = C.TextWhite; tLabel.TextTransparency = 0.15

				tLabel.TextXAlignment = Enum.TextXAlignment.Left; tLabel.Text = tTitle; tLabel.ZIndex = 4; tLabel.Parent = tf

				regAccent(tLabel, "TextColor3", "TextWhite")

				if tDesc ~= "" then

					local tDescLbl = Instance.new("TextLabel"); tDescLbl.BackgroundTransparency = 1; tDescLbl.Size = UDim2.new(1,-60,0,0); tDescLbl.AutomaticSize = Enum.AutomaticSize.Y; tDescLbl.Position = UDim2.new(0,6,0,28)

					tDescLbl.FontFace = FONT; tDescLbl.TextSize = 11; tDescLbl.TextColor3 = C.TextSubtitle; tDescLbl.TextXAlignment = Enum.TextXAlignment.Left; tDescLbl.TextWrapped = true; tDescLbl.Text = tDesc; tDescLbl.ZIndex = 4; tDescLbl.Parent = tf

					regAccent(tDescLbl, "TextColor3", "TextSubtitle")

					local _tfPad = Instance.new("UIPadding"); _tfPad.PaddingBottom = UDim.new(0,8); _tfPad.Parent = tf

				end

				local togBg = Instance.new("TextButton"); togBg.BackgroundColor3 = tState and C.Accent or Color3.fromRGB(50,50,50)

				togBg.BackgroundTransparency = 0.2; togBg.Size = UDim2.new(0,44,0,22); togBg.Position = tDesc ~= "" and UDim2.new(1,-50,0,8) or UDim2.new(1,-50,0.5,-11)

				togBg.Text = ""; togBg.AutoButtonColor = false; togBg.ZIndex = 4; togBg.Parent = tf; createCorner(togBg, 11)

				regTheme(function() if tState then togBg.BackgroundColor3 = C.Accent end end)

				local knob = Instance.new("Frame"); knob.BackgroundColor3 = C.TextWhite; knob.BackgroundTransparency = 0.2; knob.Size = UDim2.new(0,16,0,16)

				knob.Position = tState and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8); knob.ZIndex = 5; knob.Parent = togBg; createCorner(knob, 8)

				local thk = "toghov_"..tTitle..pageOrder

				tf.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement then cancelTweens(thk); playTween(thk, tLabel, TWEEN_FAST, {TextTransparency=0}); playTween(thk, togBg, TWEEN_FAST, {BackgroundTransparency=0}); playTween(thk, knob, TWEEN_FAST, {BackgroundTransparency=0}); playTween(thk, tf, TWEEN_FAST, {BackgroundTransparency=0.5}) end end)

				tf.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement then cancelTweens(thk); playTween(thk, tLabel, TWEEN_FAST, {TextTransparency=0.15}); playTween(thk, togBg, TWEEN_FAST, {BackgroundTransparency=0.2}); playTween(thk, knob, TWEEN_FAST, {BackgroundTransparency=0.2}); playTween(thk, tf, TWEEN_FAST, {BackgroundTransparency=0.85}) end end)

				local function updateToggle()

					local tKey = "toggle_"..tTitle..pageOrder; cancelTweens(tKey)

					if tState then playTween(tKey, togBg, TWEEN_SMOOTH, {BackgroundColor3=C.Accent}); playTween(tKey, knob, TWEEN_SMOOTH, {Position=UDim2.new(1,-19,0.5,-8)})

					else playTween(tKey, togBg, TWEEN_SMOOTH, {BackgroundColor3=Color3.fromRGB(50,50,50)}); playTween(tKey, knob, TWEEN_SMOOTH, {Position=UDim2.new(0,3,0.5,-8)}) end

				end

				togBg.MouseButton1Click:Connect(function()

					playSound(SND_CLICK); tState = not tState; updateToggle(); tCb(tState)

				end)

				local togObj = {}

				function togObj:Set(val) tState = val; updateToggle(); tCb(tState) end

				function togObj:Get() return tState end

				function togObj:SetTitle(t) tLabel.Text = t end

				function togObj:GetFrame() return tf end

				if tDefault then

					task.defer(function() tCb(tState) end)

				end

				registerSearch(tTitle, tDesc, tf)

				local saveId = cfg.SaveId or ("toggle:"..tabTitle..":"..tTitle)

				registerComponent(saveId, "toggle", togObj)

				return togObj

			end

			function sObj:AddSlider(cfg)

				cfg = _asWrap(cfg or {}, _asKey((cfg or {}).Title))

				local sTitle   = cfg.Title     or "Slider"

				local sMin     = cfg.Min       or 0

				local sMax     = cfg.Max       or 100

				local sDefault = math.clamp(cfg.Default or sMin, sMin, sMax)

				local sCb      = cfg.Callback  or function() end

				local sVal     = sDefault

				pageOrder = pageOrder + 1

				local sf2 = Instance.new("Frame"); sf2.BackgroundColor3 = C.Background; sf2.BackgroundTransparency = 0.85

				sf2.Size = UDim2.new(1,0,0,0); sf2.AutomaticSize = Enum.AutomaticSize.Y; sf2.LayoutOrder = pageOrder; sf2.ZIndex = 3; sf2.Parent = page

				createPadding(sf2, 10, 12, 12, 12); addGlowHover(sf2, "sl_"..sTitle..pageOrder)

				regAccent(sf2, "BackgroundColor3", "Background")

				local sfLayout = Instance.new("UIListLayout"); sfLayout.FillDirection = Enum.FillDirection.Vertical; sfLayout.Padding = UDim.new(0,8); sfLayout.SortOrder = Enum.SortOrder.LayoutOrder; sfLayout.Parent = sf2

				local topRow = Instance.new("Frame"); topRow.BackgroundTransparency = 1; topRow.Size = UDim2.new(1,0,0,18); topRow.LayoutOrder = 1; topRow.ZIndex = 4; topRow.Parent = sf2

				local slLabel = Instance.new("TextLabel"); slLabel.BackgroundTransparency = 1; slLabel.Size = UDim2.new(1,-52,1,0); slLabel.FontFace = FONT_BOLD; slLabel.TextSize = 13; slLabel.TextColor3 = C.TextWhite; slLabel.TextTransparency = 0; slLabel.TextXAlignment = Enum.TextXAlignment.Left; slLabel.Text = sTitle; slLabel.ZIndex = 5; slLabel.Parent = topRow

				regAccent(slLabel, "TextColor3", "TextWhite")

				local valBox = Instance.new("TextBox"); valBox.BackgroundColor3 = Color3.fromRGB(28,28,28); valBox.BackgroundTransparency = 0.3; valBox.Size = UDim2.new(0,42,0,18); valBox.Position = UDim2.new(1,-42,0.5,-9); valBox.FontFace = FONT; valBox.TextSize = 11; valBox.TextColor3 = C.TextWhite; valBox.TextTransparency = 0; valBox.Text = tostring(math.floor(sVal)); valBox.ClearTextOnFocus = false; valBox.ZIndex = 5; valBox.Parent = topRow; createCorner(valBox, 5)

				regAccent(valBox, "TextColor3", "TextWhite")

				local barRow = Instance.new("Frame"); barRow.BackgroundTransparency = 1; barRow.Size = UDim2.new(1,0,0,12); barRow.LayoutOrder = 2; barRow.ZIndex = 4; barRow.Parent = sf2

				local sliderBar = Instance.new("Frame"); sliderBar.BackgroundColor3 = Color3.fromRGB(45,45,45); sliderBar.BackgroundTransparency = 0.2; sliderBar.Size = UDim2.new(1,0,0,4); sliderBar.Position = UDim2.new(0,0,0.5,-2); sliderBar.ZIndex = 4; sliderBar.Parent = barRow; createCorner(sliderBar, 2)

				local iPct = (sVal-sMin)/math.max(sMax-sMin,1)

				local sliderFill = Instance.new("Frame"); sliderFill.BackgroundColor3 = C.Accent; sliderFill.BackgroundTransparency = 0.2; sliderFill.Size = UDim2.new(iPct,0,1,0); sliderFill.ZIndex = 5; sliderFill.Parent = sliderBar; createCorner(sliderFill, 2)

				regTheme(function() sliderFill.BackgroundColor3 = C.Accent end)

				local sliderKnob = Instance.new("Frame"); sliderKnob.BackgroundColor3 = C.TextWhite; sliderKnob.BackgroundTransparency = 0.2; sliderKnob.Size = UDim2.new(0,12,0,12); sliderKnob.Position = UDim2.new(iPct,-6,0.5,-6); sliderKnob.ZIndex = 6; sliderKnob.Parent = sliderBar; createCorner(sliderKnob, 6)

				local sliding = false; local shk = "slhov_"..sTitle..pageOrder

				sf2.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement then cancelTweens(shk); playTween(shk, sf2, TWEEN_FAST, {BackgroundTransparency=0.5}) end end)

				sf2.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement and not sliding then cancelTweens(shk); playTween(shk, sf2, TWEEN_FAST, {BackgroundTransparency=0.85}) end end)

				local function updateSlider(pct)

					pct = math.clamp(pct,0,1); sVal = math.floor(sMin+(sMax-sMin)*pct+0.5)

					sliderFill.Size = UDim2.new(pct,0,1,0); sliderKnob.Position = UDim2.new(pct,-6,0.5,-6); valBox.Text = tostring(sVal); sCb(sVal)

				end

				local sliderInput = Instance.new("TextButton"); sliderInput.BackgroundTransparency = 1; sliderInput.Size = UDim2.new(1,0,1,0); sliderInput.Text = ""; sliderInput.ZIndex = 7; sliderInput.AutoButtonColor = false; sliderInput.Parent = barRow

				sliderInput.InputBegan:Connect(function(i)

					if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then

						sliding = true; updateSlider(math.clamp((i.Position.X-sliderBar.AbsolutePosition.X)/sliderBar.AbsoluteSize.X,0,1))

					end

				end)

				table.insert(windowData.connections, UserInputService.InputChanged:Connect(function(i)

					if sliding and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then

						updateSlider(math.clamp((i.Position.X-sliderBar.AbsolutePosition.X)/sliderBar.AbsoluteSize.X,0,1))

					end

				end))

				table.insert(windowData.connections, UserInputService.InputEnded:Connect(function(i)

					if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then

						if sliding then playSound(SND_CLICK) end; sliding = false

					end

				end))

				valBox.FocusLost:Connect(function()

					local num = tonumber(valBox.Text)

					if num then num = math.clamp(math.floor(num),sMin,sMax); updateSlider((num-sMin)/math.max(sMax-sMin,1)) else valBox.Text = tostring(sVal) end

				end)

				local slObj = {}

				function slObj:Set(val) val = math.clamp(val,sMin,sMax); updateSlider((val-sMin)/math.max(sMax-sMin,1)) end

				function slObj:Get() return sVal end

				function slObj:GetFrame() return sf2 end

				registerSearch(sTitle, "", sf2)

				return slObj

			end

			function sObj:AddButton(cfg)

				cfg = cfg or {}

				local bTitle   = cfg.Title       or "Button"

				local bDesc    = cfg.Description  or ""

				local bIcon    = cfg.Icon         or "rbxassetid://134116239949429"

				local bCb      = cfg.Callback     or function() end

				local bConfirm = cfg.Confirmation or false

				pageOrder = pageOrder + 1

				local bf = Instance.new("TextButton"); bf.BackgroundColor3 = C.Background; bf.BackgroundTransparency = 0.85

				bf.Size = UDim2.new(1,0,0,0); bf.AutomaticSize = Enum.AutomaticSize.Y; bf.AutoButtonColor = false; bf.Text = ""

				bf.LayoutOrder = pageOrder; bf.ZIndex = 3; bf.Parent = page

				createPadding(bf, 10, 12, 10, 12); addGlowHover(bf, "btn_"..bTitle..pageOrder)

				regAccent(bf, "BackgroundColor3", "Background")

				local bfLayout = Instance.new("UIListLayout"); bfLayout.FillDirection = Enum.FillDirection.Vertical; bfLayout.Padding = UDim.new(0,1); bfLayout.SortOrder = Enum.SortOrder.LayoutOrder; bfLayout.Parent = bf

				local topRow = Instance.new("Frame"); topRow.BackgroundTransparency = 1; topRow.Size = UDim2.new(1,0,0,18); topRow.LayoutOrder = 1; topRow.ZIndex = 4; topRow.Parent = bf

				local btnTitleLabel = Instance.new("TextLabel"); btnTitleLabel.BackgroundTransparency = 1; btnTitleLabel.Size = UDim2.new(1,-44,1,0); btnTitleLabel.FontFace = FONT_BOLD; btnTitleLabel.TextSize = 13; btnTitleLabel.TextColor3 = C.TextWhite; btnTitleLabel.TextXAlignment = Enum.TextXAlignment.Left; btnTitleLabel.Text = bTitle; btnTitleLabel.ZIndex = 5; btnTitleLabel.Parent = topRow

				regAccent(btnTitleLabel, "TextColor3", "TextWhite")

				if bDesc ~= "" then

					local btnDescLabel = Instance.new("TextLabel"); btnDescLabel.BackgroundTransparency = 1; btnDescLabel.Size = UDim2.new(1,0,0,0); btnDescLabel.AutomaticSize = Enum.AutomaticSize.Y; btnDescLabel.FontFace = FONT; btnDescLabel.TextSize = 11; btnDescLabel.TextColor3 = C.TextSubtitle; btnDescLabel.TextXAlignment = Enum.TextXAlignment.Left; btnDescLabel.TextWrapped = true; btnDescLabel.Text = bDesc; btnDescLabel.LayoutOrder = 2; btnDescLabel.ZIndex = 5; btnDescLabel.RichText = true; btnDescLabel.Parent = bf

					regAccent(btnDescLabel, "TextColor3", "TextSubtitle")

				end

				local btnArrow = Instance.new("ImageLabel"); btnArrow.BackgroundTransparency = 1; btnArrow.Size = UDim2.new(0,20,0,20); btnArrow.AnchorPoint = Vector2.new(1,0.5); btnArrow.Position = UDim2.new(1,0,0.5,0); btnArrow.Image = bIcon; btnArrow.ImageColor3 = C.Accent; btnArrow.ImageTransparency = 0.2; btnArrow.ZIndex = 5; btnArrow.Parent = topRow

				regTheme(function() btnArrow.ImageColor3 = C.Accent end)

				local bthk = "btnhov_"..bTitle..pageOrder

				bf.MouseEnter:Connect(function() cancelTweens(bthk); playTween(bthk, bf, TWEEN_FAST, {BackgroundTransparency=0.5}); playTween(bthk, btnArrow, TWEEN_FAST, {ImageTransparency=0, Size=UDim2.new(0,23,0,23)}) end)

				bf.MouseLeave:Connect(function() cancelTweens(bthk); playTween(bthk, bf, TWEEN_FAST, {BackgroundTransparency=0.85}); playTween(bthk, btnArrow, TWEEN_FAST, {ImageTransparency=0.2, Size=UDim2.new(0,20,0,20)}) end)

				local function doCallback()

					local bck = "btncl_"..bTitle..pageOrder; cancelTweens(bck); playSound(SND_CLICK)

					playTween(bck, bf, TweenInfo.new(0.07, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency=0.2})

					playTween(bck, btnArrow, TweenInfo.new(0.07, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3=C.AccentBright})

					task.delay(0.14, function() cancelTweens(bck); playTween(bck, bf, TWEEN_SMOOTH, {BackgroundTransparency=0.85}); playTween(bck, btnArrow, TWEEN_SMOOTH, {ImageColor3=C.Accent}) end)

					bCb()

				end

				bf.MouseButton1Click:Connect(function()

					if windowData.destroyed then return end

					if bConfirm then makeDialog("Do you want to execute this action?", "dialog_btn"..pageOrder, function() doCallback() end) else doCallback() end

				end)

				local btnObj = {}; function btnObj:GetFrame() return bf end; function btnObj:SetTitle(t) btnTitleLabel.Text = t end

				registerSearch(bTitle, bDesc, bf)

				return btnObj

			end

			function sObj:AddDropdown(cfg)

	cfg = _asWrap(cfg or {}, _asKey((cfg or {}).Title))

	local ddTitle   = cfg.Title    or "Dropdown"

	local ddOptions = cfg.Options  or cfg.Values or cfg.List or {}

	local ddMulti   = cfg.Multiple or cfg.Multi  or false

	local ddDefault = cfg.Default   or {}

	if type(ddDefault) ~= "table" then ddDefault = {ddDefault} end

	local ddCb      = cfg.Callback  or function() end

	pageOrder = pageOrder + 1

	local selected = {}

	if ddMulti then for _, v in ipairs(ddDefault) do selected[tostring(v)] = true end

	elseif ddDefault[1] then selected[tostring(ddDefault[1])] = true end

	local isOpen = false

	local df = Instance.new("Frame"); df.BackgroundTransparency = 1; df.Size = UDim2.new(1,0,0,0); df.AutomaticSize = Enum.AutomaticSize.Y; df.LayoutOrder = pageOrder; df.ZIndex = 3; df.Parent = page

	local dfLayout = Instance.new("UIListLayout"); dfLayout.FillDirection = Enum.FillDirection.Vertical; dfLayout.Padding = UDim.new(0,4); dfLayout.SortOrder = Enum.SortOrder.LayoutOrder; dfLayout.Parent = df

	local ddHeader = Instance.new("Frame"); ddHeader.BackgroundColor3 = C.Background; ddHeader.BackgroundTransparency = 0.85; ddHeader.Size = UDim2.new(1,0,0,40); ddHeader.LayoutOrder = 1; ddHeader.ZIndex = 4; ddHeader.Parent = df

	createPadding(ddHeader, 6, 12, 6, 12); addGlowHover(ddHeader, "dd_"..ddTitle..pageOrder)

	regAccent(ddHeader, "BackgroundColor3", "Background")

	local topRow = Instance.new("Frame"); topRow.BackgroundTransparency = 1; topRow.Size = UDim2.new(1,0,1,0); topRow.ZIndex = 5; topRow.Parent = ddHeader

	local ddTitleLabel = Instance.new("TextLabel"); ddTitleLabel.BackgroundTransparency = 1; ddTitleLabel.Size = UDim2.new(1,-22,0,16); ddTitleLabel.Position = UDim2.new(0,0,0,0); ddTitleLabel.FontFace = FONT_BOLD; ddTitleLabel.TextSize = 13; ddTitleLabel.TextColor3 = C.TextWhite; ddTitleLabel.TextXAlignment = Enum.TextXAlignment.Left; ddTitleLabel.Text = ddTitle; ddTitleLabel.ZIndex = 6; ddTitleLabel.Parent = topRow

	regAccent(ddTitleLabel, "TextColor3", "TextWhite")

	local function getSelectedText()

		local parts = {}

		for _, opt in ipairs(ddOptions) do local val = type(opt)=="table" and tostring(opt.Value or opt[1]) or tostring(opt); if selected[val] then table.insert(parts, val) end end

		return #parts > 0 and table.concat(parts, ", ") or "None"

	end

	local selLabel = Instance.new("TextLabel"); selLabel.BackgroundTransparency = 1; selLabel.Size = UDim2.new(1,-22,0,12); selLabel.Position = UDim2.new(0,0,0,16); selLabel.FontFace = FONT; selLabel.TextSize = 10; selLabel.TextColor3 = C.TextSubtitle; selLabel.TextXAlignment = Enum.TextXAlignment.Left; selLabel.Text = getSelectedText(); selLabel.ZIndex = 6; selLabel.Parent = topRow

	regAccent(selLabel, "TextColor3", "TextSubtitle")

	local ddArrow = Instance.new("ImageLabel"); ddArrow.BackgroundTransparency = 1; ddArrow.Size = UDim2.new(0,14,0,14)
	ddArrow.AnchorPoint = Vector2.new(1,0.5); ddArrow.Position = UDim2.new(1,0,0.5,0); ddArrow.Image = "rbxassetid://10709790948"
	ddArrow.Rotation = 0; ddArrow.ImageColor3 = C.TextSubtitle; ddArrow.ZIndex = 6; ddArrow.Parent = topRow
	regAccent(ddArrow, "ImageColor3", "TextSubtitle")

	local menuWrap = Instance.new("Frame"); menuWrap.BackgroundTransparency = 1; menuWrap.Size = UDim2.new(1,0,0,0); menuWrap.ClipsDescendants = true; menuWrap.LayoutOrder = 2; menuWrap.ZIndex = 20; menuWrap.Parent = df

	local ddSearchWrap = Instance.new("Frame"); ddSearchWrap.BackgroundColor3 = Color3.fromRGB(20,20,20); ddSearchWrap.BackgroundTransparency = 0.2
	ddSearchWrap.Size = UDim2.new(1,0,0,26); ddSearchWrap.Position = UDim2.new(0,0,0,0); ddSearchWrap.ZIndex = 20; ddSearchWrap.Parent = menuWrap
	createCorner(ddSearchWrap, 6)

	local ddSearchIcon = Instance.new("ImageLabel"); ddSearchIcon.BackgroundTransparency = 1; ddSearchIcon.Size = UDim2.new(0,12,0,12)
	ddSearchIcon.Position = UDim2.new(0,8,0.5,-6); ddSearchIcon.Image = "rbxassetid://115739298989740"
	ddSearchIcon.ImageColor3 = C.TextSubtitle; ddSearchIcon.ZIndex = 21; ddSearchIcon.Parent = ddSearchWrap
	regAccent(ddSearchIcon, "ImageColor3", "TextSubtitle")

	local ddSearchInput = Instance.new("TextBox"); ddSearchInput.BackgroundTransparency = 1; ddSearchInput.Size = UDim2.new(1,-30,1,0)
	ddSearchInput.Position = UDim2.new(0,26,0,0); ddSearchInput.FontFace = FONT; ddSearchInput.TextSize = 11
	ddSearchInput.TextColor3 = C.TextWhite; ddSearchInput.PlaceholderColor3 = C.TextSubtitle; ddSearchInput.PlaceholderText = "Search..."
	ddSearchInput.TextXAlignment = Enum.TextXAlignment.Left; ddSearchInput.ClearTextOnFocus = false; ddSearchInput.Text = ""
	ddSearchInput.ZIndex = 21; ddSearchInput.Parent = ddSearchWrap
	regAccent(ddSearchInput, "TextColor3", "TextWhite"); regAccent(ddSearchInput, "PlaceholderColor3", "TextSubtitle")

	local menuBg = Instance.new("ScrollingFrame"); menuBg.BackgroundColor3 = Color3.fromRGB(15,15,15); menuBg.Size = UDim2.new(1,0,1,-30); menuBg.Position = UDim2.new(0,0,0,30); menuBg.CanvasSize = UDim2.new(0,0,0,0); menuBg.AutomaticCanvasSize = Enum.AutomaticSize.Y; menuBg.ScrollBarThickness = 2; menuBg.ScrollBarImageColor3 = SCROLL_NEUTRAL; menuBg.ZIndex = 20; menuBg.Parent = menuWrap; menuBg.BorderSizePixel = 0

	createCorner(menuBg, 8); local menuStroke = createStroke(menuBg, C.Border, 1, 0.45); regTheme(function() menuStroke.Color = C.Border end)

	local menuLayout = Instance.new("UIListLayout"); menuLayout.FillDirection = Enum.FillDirection.Vertical; menuLayout.Padding = UDim.new(0,5); menuLayout.SortOrder = Enum.SortOrder.LayoutOrder; menuLayout.Parent = menuBg

	createPadding(menuBg, 5, 5, 5, 5)

	local optionFrames = {}

	ddSearchInput:GetPropertyChangedSignal("Text"):Connect(function()
		local q = ddSearchInput.Text:lower()
		for _, of in ipairs(optionFrames) do
			of._frame.Visible = (q == "" or of._val:lower():find(q, 1, true) ~= nil)
		end
	end)

	local function updateVisuals()

		selLabel.Text = getSelectedText()

		for _, of in ipairs(optionFrames) do

			local isSel = selected[of._val] == true

			TweenService:Create(of._bar, TWEEN_FAST, {BackgroundTransparency=isSel and 0 or 1}):Play()

			TweenService:Create(of._frame, TWEEN_FAST, {BackgroundTransparency=isSel and 0.82 or 1, BackgroundColor3=C.Background}):Play()

			TweenService:Create(of._lbl, TWEEN_FAST, {TextColor3=isSel and C.AccentBright or C.TextWhite}):Play()

		end

	end

	local function computeMenuHeight()

		local h = 40

		for _, opt in ipairs(ddOptions) do local desc = type(opt)=="table" and (opt.Description or "") or ""; h = h + (desc~="" and 41 or 29) end

		return math.min(h, 190)

	end

	for i, opt in ipairs(ddOptions) do

		local val = type(opt)=="table" and tostring(opt.Value or opt[1]) or tostring(opt)

		local desc = type(opt)=="table" and (opt.Description or "") or ""; local isSel = selected[val] == true; local itemH = desc~="" and 36 or 24

		local optFrame = Instance.new("Frame"); optFrame.BackgroundColor3 = C.Background; optFrame.BackgroundTransparency = isSel and 0.82 or 1; optFrame.Size = UDim2.new(1,0,0,0); optFrame.AutomaticSize = Enum.AutomaticSize.Y; optFrame.LayoutOrder = i; optFrame.ZIndex = 21; optFrame.Parent = menuBg; createCorner(optFrame, 5)

		regAccent(optFrame, "BackgroundColor3", "Background")

		local bar = Instance.new("Frame"); bar.BackgroundColor3 = C.Accent; bar.BackgroundTransparency = isSel and 0 or 1; bar.Size = UDim2.new(0,2,0,20); bar.Position = UDim2.new(0,1,0,5); bar.ZIndex = 22; bar.Parent = optFrame; createCorner(bar, 1)

		regTheme(function() bar.BackgroundColor3 = C.Accent end)

		local optLbl = Instance.new("TextLabel"); optLbl.BackgroundTransparency = 1; optLbl.Size = UDim2.new(1,-14,0,13); optLbl.Position = UDim2.new(0,10,0,5); optLbl.FontFace = FONT_BOLD; optLbl.TextSize = 10; optLbl.TextColor3 = isSel and C.AccentBright or C.TextWhite; optLbl.TextXAlignment = Enum.TextXAlignment.Left; optLbl.Text = val; optLbl.ZIndex = 22; optLbl.Parent = optFrame

		regAccent(optLbl, "TextColor3", "TextWhite")

		if desc ~= "" then

			local optDesc = Instance.new("TextLabel"); optDesc.BackgroundTransparency = 1; optDesc.Size = UDim2.new(1,-14,0,0); optDesc.AutomaticSize = Enum.AutomaticSize.Y; optDesc.Position = UDim2.new(0,10,0,17); optDesc.FontFace = FONT; optDesc.TextSize = 9; optDesc.TextColor3 = C.TextSubtitle; optDesc.TextXAlignment = Enum.TextXAlignment.Left; optDesc.TextWrapped = true; optDesc.Text = desc; optDesc.ZIndex = 22; optDesc.Parent = optFrame

		end

		local optBtn = Instance.new("TextButton"); optBtn.BackgroundTransparency = 1; optBtn.Size = UDim2.new(1,0,1,0); optBtn.Text = ""; optBtn.ZIndex = 23; optBtn.AutoButtonColor = false; optBtn.Parent = optFrame

		local ohk = "ddopt_"..val..pageOrder

		optBtn.MouseEnter:Connect(function() if not selected[val] then cancelTweens(ohk); playTween(ohk, optFrame, TWEEN_FAST, {BackgroundColor3=C.Background, BackgroundTransparency=0.88}) end end)

		optBtn.MouseLeave:Connect(function() if not selected[val] then cancelTweens(ohk); playTween(ohk, optFrame, TWEEN_FAST, {BackgroundColor3=C.Background, BackgroundTransparency=1}) end end)

		optBtn.MouseButton1Click:Connect(function()

			playSound(SND_CLICK)

			if ddMulti then selected[val] = not selected[val]

			else if selected[val] then return end; for k in pairs(selected) do selected[k] = false end; selected[val] = true end

			local out = {}; for _, o in ipairs(ddOptions) do local v = type(o)=="table" and tostring(o.Value or o[1]) or tostring(o); if selected[v] then table.insert(out, v) end end

			updateVisuals(); ddCb(ddMulti and out or out[1])

		end)

		table.insert(optionFrames, {_frame=optFrame, _bar=bar, _val=val, _lbl=optLbl})

	end

	regTheme(function() for _, of in ipairs(optionFrames) do of._bar.BackgroundColor3 = C.Accent; of._lbl.TextColor3 = selected[of._val] and C.AccentBright or C.TextWhite end end)

	local mh = computeMenuHeight()

	local function openMenu() isOpen = true; cancelTweens("ddmenu_"..pageOrder); playTween("ddmenu_"..pageOrder, menuWrap, TWEEN_SMOOTH, {Size=UDim2.new(1,0,0,mh)}); playTween("ddmenu_"..pageOrder, ddHeader, TWEEN_FAST, {BackgroundTransparency=0.7}); playTween("ddmenu_"..pageOrder, ddArrow, TWEEN_FAST, {Rotation=180}) end

	local function closeMenu() isOpen = false; cancelTweens("ddmenu_"..pageOrder); playTween("ddmenu_"..pageOrder, menuWrap, TWEEN_FAST, {Size=UDim2.new(1,0,0,0)}); playTween("ddmenu_"..pageOrder, ddHeader, TWEEN_FAST, {BackgroundTransparency=0.85}); playTween("ddmenu_"..pageOrder, ddArrow, TWEEN_FAST, {Rotation=0}); ddSearchInput.Text = "" end

	local ddhk = "ddhov_"..ddTitle..pageOrder

	ddHeader.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement then cancelTweens(ddhk); if not isOpen then playTween(ddhk, ddHeader, TWEEN_FAST, {BackgroundTransparency=0.5}) end end end)

	ddHeader.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement then cancelTweens(ddhk); if not isOpen then playTween(ddhk, ddHeader, TWEEN_FAST, {BackgroundTransparency=0.85}) end end end)

	local headerBtn = Instance.new("TextButton"); headerBtn.BackgroundTransparency = 1; headerBtn.Size = UDim2.new(1,0,1,0); headerBtn.Text = ""; headerBtn.ZIndex = 7; headerBtn.AutoButtonColor = false; headerBtn.Parent = ddHeader

	headerBtn.MouseButton1Click:Connect(function() if isOpen then closeMenu() else openMenu() end end)

	local ddObj = {}

	function ddObj:Set(val)

		if ddMulti and type(val)=="table" then for k in pairs(selected) do selected[k] = false end; for _, v in ipairs(val) do selected[tostring(v)] = true end

		else for k in pairs(selected) do selected[k] = false end; selected[tostring(val)] = true end; updateVisuals()

	end

	function ddObj:Get()

		local out = {}; for _, opt in ipairs(ddOptions) do local v = type(opt)=="table" and tostring(opt.Value or opt[1]) or tostring(opt); if selected[v] then table.insert(out, v) end end; return ddMulti and out or out[1]

	end

	function ddObj:Close() closeMenu() end; function ddObj:Open() openMenu() end; function ddObj:GetFrame() return df end; function ddObj:SetTitle(t) ddTitleLabel.Text = t end

	function ddObj:Refresh(newList)

		closeMenu()

		for _, of in ipairs(optionFrames) do of._frame:Destroy() end

		optionFrames = {}

		for k in pairs(selected) do selected[k] = false end

		ddOptions = newList or {}

		for i, opt in ipairs(ddOptions) do

			local val = type(opt)=="table" and tostring(opt.Value or opt[1]) or tostring(opt)

			local desc = type(opt)=="table" and (opt.Description or "") or ""; local itemH = desc~="" and 36 or 24

			local optFrame = Instance.new("Frame"); optFrame.BackgroundColor3 = C.Background; optFrame.BackgroundTransparency = 1; optFrame.Size = UDim2.new(1,0,0,0); optFrame.AutomaticSize = Enum.AutomaticSize.Y; optFrame.LayoutOrder = i; optFrame.ZIndex = 21; optFrame.Parent = menuBg; createCorner(optFrame, 5)

			regAccent(optFrame, "BackgroundColor3", "Background")

			local bar = Instance.new("Frame"); bar.BackgroundColor3 = C.Accent; bar.BackgroundTransparency = 1; bar.Size = UDim2.new(0,2,0,20); bar.Position = UDim2.new(0,1,0,5); bar.ZIndex = 22; bar.Parent = optFrame; createCorner(bar, 1)

			regTheme(function() bar.BackgroundColor3 = C.Accent end)

			local optLbl = Instance.new("TextLabel"); optLbl.BackgroundTransparency = 1; optLbl.Size = UDim2.new(1,-14,0,13); optLbl.Position = UDim2.new(0,10,0,5); optLbl.FontFace = FONT_BOLD; optLbl.TextSize = 10; optLbl.TextColor3 = C.TextWhite; optLbl.TextXAlignment = Enum.TextXAlignment.Left; optLbl.Text = val; optLbl.ZIndex = 22; optLbl.Parent = optFrame

			regAccent(optLbl, "TextColor3", "TextWhite")

			if desc ~= "" then

				local optDesc = Instance.new("TextLabel"); optDesc.BackgroundTransparency = 1; optDesc.Size = UDim2.new(1,-14,0,0); optDesc.AutomaticSize = Enum.AutomaticSize.Y; optDesc.Position = UDim2.new(0,10,0,17); optDesc.FontFace = FONT; optDesc.TextSize = 9; optDesc.TextColor3 = C.TextSubtitle; optDesc.TextXAlignment = Enum.TextXAlignment.Left; optDesc.TextWrapped = true; optDesc.Text = desc; optDesc.ZIndex = 22; optDesc.Parent = optFrame

			end

			local optBtn = Instance.new("TextButton"); optBtn.BackgroundTransparency = 1; optBtn.Size = UDim2.new(1,0,1,0); optBtn.Text = ""; optBtn.ZIndex = 23; optBtn.AutoButtonColor = false; optBtn.Parent = optFrame

			local ohk = "ddopt_"..val..pageOrder

			optBtn.MouseEnter:Connect(function() if not selected[val] then cancelTweens(ohk); playTween(ohk, optFrame, TWEEN_FAST, {BackgroundColor3=C.Background, BackgroundTransparency=0.88}) end end)

			optBtn.MouseLeave:Connect(function() if not selected[val] then cancelTweens(ohk); playTween(ohk, optFrame, TWEEN_FAST, {BackgroundColor3=C.Background, BackgroundTransparency=1}) end end)

			optBtn.MouseButton1Click:Connect(function()

				playSound(SND_CLICK)

				if ddMulti then selected[val] = not selected[val]

				else if selected[val] then return end; for k in pairs(selected) do selected[k] = false end; selected[val] = true end

				local out = {}; for _, o in ipairs(ddOptions) do local v = type(o)=="table" and tostring(o.Value or o[1]) or tostring(o); if selected[v] then table.insert(out, v) end end

				updateVisuals(); ddCb(ddMulti and out or out[1])

			end)

			table.insert(optionFrames, {_frame=optFrame, _bar=bar, _val=val, _lbl=optLbl})

		end

		mh = computeMenuHeight()

		selLabel.Text = getSelectedText()

	end

	if ddDefault[1] ~= nil then

		task.defer(function()

			local out = {}; for _, opt in ipairs(ddOptions) do local v = type(opt)=="table" and tostring(opt.Value or opt[1]) or tostring(opt); if selected[v] then table.insert(out, v) end end

			ddCb(ddMulti and out or out[1])

		end)

	end

	registerSearch(ddTitle, "", df)

	return ddObj

end

			function sObj:AddInput(cfg)

				cfg = _asWrap(cfg or {}, _asKey((cfg or {}).Title))

				local tbTitle    = cfg.Title       or "Text"

				local tbPlaceholder = cfg.PlaceHolder or cfg.Placeholder or "Type here..."

				local tbMaxLen   = cfg.MaxLength   or 200

				local tbCb       = cfg.Callback    or function() end

				local tbDefault  = cfg.Default     or ""

				pageOrder = pageOrder + 1

				local tf = Instance.new("Frame"); tf.BackgroundColor3 = C.Background; tf.BackgroundTransparency = 0.85

				tf.Size = UDim2.new(1,0,0,0); tf.AutomaticSize = Enum.AutomaticSize.Y; tf.LayoutOrder = pageOrder; tf.ZIndex = 3; tf.Parent = page

				createPadding(tf, 10, 12, 12, 12); addGlowHover(tf, "tb_"..tbTitle..pageOrder)

				regAccent(tf, "BackgroundColor3", "Background")

				local tfLayout = Instance.new("UIListLayout"); tfLayout.FillDirection = Enum.FillDirection.Vertical; tfLayout.Padding = UDim.new(0,8); tfLayout.SortOrder = Enum.SortOrder.LayoutOrder; tfLayout.Parent = tf

				local topRow = Instance.new("Frame"); topRow.BackgroundTransparency = 1; topRow.Size = UDim2.new(1,0,0,16); topRow.LayoutOrder = 1; topRow.ZIndex = 4; topRow.Parent = tf

				local titleLbl = Instance.new("TextLabel"); titleLbl.BackgroundTransparency = 1; titleLbl.Size = UDim2.new(1,-50,1,0); titleLbl.FontFace = FONT_BOLD; titleLbl.TextSize = 13; titleLbl.TextColor3 = C.TextWhite; titleLbl.TextTransparency = 0; titleLbl.TextXAlignment = Enum.TextXAlignment.Left; titleLbl.Text = tbTitle; titleLbl.ZIndex = 5; titleLbl.Parent = topRow

				regAccent(titleLbl, "TextColor3", "TextWhite")

				local countLbl = Instance.new("TextLabel"); countLbl.BackgroundTransparency = 1; countLbl.Size = UDim2.new(0,46,1,0); countLbl.Position = UDim2.new(1,-46,0,0); countLbl.FontFace = FONT; countLbl.TextSize = 10; countLbl.TextColor3 = C.TextSubtitle; countLbl.TextTransparency = 0.3; countLbl.TextXAlignment = Enum.TextXAlignment.Right; countLbl.Text = "0/"..tbMaxLen; countLbl.ZIndex = 5; countLbl.Parent = topRow

				regAccent(countLbl, "TextColor3", "TextSubtitle")

				local lineWrap = Instance.new("Frame"); lineWrap.BackgroundTransparency = 1; lineWrap.Size = UDim2.new(1,0,0,22); lineWrap.LayoutOrder = 2; lineWrap.ZIndex = 4; lineWrap.Parent = tf

				local lineUnder = Instance.new("Frame"); lineUnder.BackgroundColor3 = C.Border; lineUnder.BackgroundTransparency = 0.3; lineUnder.Size = UDim2.new(1,0,0,1); lineUnder.Position = UDim2.new(0,0,1,-1); lineUnder.BorderSizePixel = 0; lineUnder.ZIndex = 4; lineUnder.Parent = lineWrap

				regAccent(lineUnder, "BackgroundColor3", "Border")

				local lineFill = Instance.new("Frame"); lineFill.BackgroundColor3 = C.Accent; lineFill.BackgroundTransparency = 1; lineFill.Size = UDim2.new(0,0,1,0); lineFill.BorderSizePixel = 0; lineFill.ZIndex = 5; lineFill.Parent = lineUnder

				regTheme(function() lineFill.BackgroundColor3 = C.Accent end)

				local inputClip = Instance.new("Frame"); inputClip.BackgroundTransparency = 1; inputClip.Size = UDim2.new(1,0,0,18); inputClip.Position = UDim2.new(0,0,0,0); inputClip.ClipsDescendants = true; inputClip.ZIndex = 5; inputClip.Parent = lineWrap

				local tbInput = Instance.new("TextBox"); tbInput.BackgroundTransparency = 1; tbInput.Size = UDim2.new(1,0,1,0); tbInput.FontFace = FONT; tbInput.TextSize = 12; tbInput.TextColor3 = C.TextWhite; tbInput.PlaceholderColor3 = C.TextSubtitle; tbInput.PlaceholderText = tbPlaceholder; tbInput.TextXAlignment = Enum.TextXAlignment.Left; tbInput.Text = tbDefault; tbInput.ClearTextOnFocus = false; tbInput.TextTruncate = Enum.TextTruncate.AtEnd; tbInput.ZIndex = 6; tbInput.Parent = inputClip

				regAccent(tbInput, "TextColor3", "TextWhite"); regAccent(tbInput, "PlaceholderColor3", "TextSubtitle")

				countLbl.Text = #tbDefault.."/"..tbMaxLen

				local focused = false

				local function onFocus()

					focused = true; cancelTweens("tb_focus_"..pageOrder)

					playTween("tb_focus_"..pageOrder, lineFill, TWEEN_SMOOTH, {Size=UDim2.new(1,0,1,0), BackgroundTransparency=0})

					playTween("tb_focus_"..pageOrder, titleLbl, TWEEN_FAST, {TextColor3=C.AccentBright, TextTransparency=0})

					playTween("tb_focus_"..pageOrder, countLbl, TWEEN_FAST, {TextTransparency=0})

					playTween("tb_focus_"..pageOrder, tf, TWEEN_FAST, {BackgroundTransparency=0.5})

				end

				local function onUnfocus()

					focused = false; cancelTweens("tb_focus_"..pageOrder)

					playTween("tb_focus_"..pageOrder, lineFill, TWEEN_SMOOTH, {Size=UDim2.new(0,0,1,0), BackgroundTransparency=1})

					playTween("tb_focus_"..pageOrder, titleLbl, TWEEN_FAST, {TextColor3=C.TextWhite, TextTransparency=0})

					playTween("tb_focus_"..pageOrder, countLbl, TWEEN_FAST, {TextTransparency=0.3})

					playTween("tb_focus_"..pageOrder, tf, TWEEN_FAST, {BackgroundTransparency=0.85})

				end

				tbInput.Focused:Connect(onFocus)

				tbInput.FocusLost:Connect(function() onUnfocus(); playSound(SND_CLICK); tbCb(tbInput.Text) end)

				tbInput:GetPropertyChangedSignal("Text"):Connect(function()

					local txt = tbInput.Text

					if #txt > tbMaxLen then txt = string.sub(txt, 1, tbMaxLen); tbInput.Text = txt end

					countLbl.Text = #txt.."/"..tbMaxLen

					local pct = math.clamp(#txt/tbMaxLen, 0, 1)

					if pct > 0.85 then countLbl.TextColor3 = Color3.fromRGB(200,80,80)

					elseif pct > 0.6 then countLbl.TextColor3 = C.AccentBright

					else countLbl.TextColor3 = C.TextSubtitle end

				end)

				tf.InputBegan:Connect(function(i)

					if i.UserInputType == Enum.UserInputType.MouseMovement and not focused then

						cancelTweens("tbhov_"..pageOrder); playTween("tbhov_"..pageOrder, tf, TWEEN_FAST, {BackgroundTransparency=0.65}); playTween("tbhov_"..pageOrder, lineUnder, TWEEN_FAST, {BackgroundTransparency=0})

					end

				end)

				tf.InputEnded:Connect(function(i)

					if i.UserInputType == Enum.UserInputType.MouseMovement and not focused then

						cancelTweens("tbhov_"..pageOrder); playTween("tbhov_"..pageOrder, tf, TWEEN_FAST, {BackgroundTransparency=0.85}); playTween("tbhov_"..pageOrder, lineUnder, TWEEN_FAST, {BackgroundTransparency=0.3})

					end

				end)

				local tbObj = {}

				function tbObj:Get() return tbInput.Text end

				function tbObj:Set(v) local s = string.sub(tostring(v), 1, tbMaxLen); tbInput.Text = s; countLbl.Text = #s.."/"..tbMaxLen; tbCb(s) end

				function tbObj:GetFrame() return tf end

				function tbObj:SetTitle(t) titleLbl.Text = t end

				function tbObj:SetPlaceholder(p) tbInput.PlaceholderText = p end

				registerSearch(tbTitle, "", tf)

				return tbObj

			end

			function sObj:AddTextbox(cfg) return self:AddInput(cfg) end

			function sObj:AddParagraph(cfg)

				cfg = cfg or {}

				local pcTitle   = cfg.Title       or "Info"

				local pcContent = cfg.Content     or cfg.Description or cfg.Desc or ""

				pageOrder = pageOrder + 1

				local pf = Instance.new("Frame"); pf.BackgroundColor3 = C.Background; pf.BackgroundTransparency = 0.85

				pf.Size = UDim2.new(1,0,0,0); pf.AutomaticSize = Enum.AutomaticSize.Y; pf.LayoutOrder = pageOrder; pf.ZIndex = 3; pf.Parent = page

				createPadding(pf, 10, 12, 10, 12); addGlowHover(pf, "para_"..pcTitle..pageOrder)

				regAccent(pf, "BackgroundColor3", "Background")

				local phk = "parahov_"..pcTitle..pageOrder

				pf.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement then cancelTweens(phk); playTween(phk, pf, TWEEN_FAST, {BackgroundTransparency=0.5}) end end)

				pf.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement then cancelTweens(phk); playTween(phk, pf, TWEEN_FAST, {BackgroundTransparency=0.85}) end end)

				local pl = Instance.new("UIListLayout"); pl.FillDirection = Enum.FillDirection.Vertical; pl.Padding = UDim.new(0,4); pl.SortOrder = Enum.SortOrder.LayoutOrder; pl.Parent = pf

				local hr = Instance.new("Frame"); hr.BackgroundTransparency = 1; hr.Size = UDim2.new(1,0,0,24); hr.LayoutOrder = 1; hr.ZIndex = 4; hr.Parent = pf

				if (cfg.Icon or "") ~= "" then

					local ic = Instance.new("ImageLabel"); ic.BackgroundTransparency = 1; ic.Size = UDim2.new(0,22,0,22); ic.Position = UDim2.new(0,0,0,1); ic.Image = cfg.Icon; ic.ImageColor3 = C.Accent; ic.ZIndex = 5; ic.Parent = hr

					regTheme(function() ic.ImageColor3 = C.Accent end)

				end

				local tl = Instance.new("TextLabel"); tl.BackgroundTransparency = 1

				tl.Size = UDim2.new(1,(cfg.Icon or "")~="" and -30 or 0,1,0); tl.Position = UDim2.new(0,(cfg.Icon or "")~="" and 28 or 0,0,0)

				tl.FontFace = FONT_BOLD; tl.TextSize = 13; tl.TextColor3 = C.TextWhite; tl.TextXAlignment = Enum.TextXAlignment.Left; tl.Text = pcTitle; tl.ZIndex = 5; tl.Parent = hr

				regAccent(tl, "TextColor3", "TextWhite")

				local dl = Instance.new("TextLabel"); dl.BackgroundTransparency = 1; dl.Size = UDim2.new(1,0,0,0)

				dl.AutomaticSize = Enum.AutomaticSize.Y; dl.FontFace = FONT; dl.TextSize = 12; dl.TextColor3 = C.TextSubtitle

				dl.TextXAlignment = Enum.TextXAlignment.Left; dl.TextWrapped = true; dl.Text = pcContent; dl.LayoutOrder = 2; dl.ZIndex = 5; dl.RichText = true; dl.Parent = pf

				regAccent(dl, "TextColor3", "TextSubtitle")

				local po = {}; function po:SetTitle(t) tl.Text = t end; function po:SetContent(d) dl.Text = d end; function po:SetDescription(d) dl.Text = d end; function po:SetDesc(d) dl.Text = d end

				function po:GetDescriptionLabel() return dl end; function po:GetFrame() return pf end

				registerSearch(pcTitle, pcContent, pf)

				return po

			end

			function sObj:AddSeperator(args)

				pageOrder = pageOrder + 1

				local hasText = args and args ~= ""

				local sep = Instance.new("Frame"); sep.BackgroundTransparency = 1; sep.Size = UDim2.new(1,0,0, hasText and 30 or 16); sep.LayoutOrder = pageOrder; sep.ZIndex = 3; sep.Parent = page

				if hasText then

					local sepLbl = Instance.new("TextLabel"); sepLbl.BackgroundTransparency = 1; sepLbl.Size = UDim2.new(1,0,0,18)

					sepLbl.Position = UDim2.new(0,0,0,0)

					sepLbl.FontFace = FONT_BOLD; sepLbl.TextSize = 13; sepLbl.TextColor3 = Color3.new(1,1,1); sepLbl.TextTransparency = 0

					sepLbl.TextXAlignment = Enum.TextXAlignment.Center; sepLbl.Text = args; sepLbl.ZIndex = 6; sepLbl.Parent = sep

				end

				local lineY = hasText and UDim2.new(0,0,1,-3) or UDim2.new(0,0,0.5,-1)

				local lineMain = Instance.new("Frame"); lineMain.BackgroundColor3 = C.Accent; lineMain.BackgroundTransparency = 0

				lineMain.Size = UDim2.new(1,0,0,1); lineMain.Position = lineY; lineMain.BorderSizePixel = 0; lineMain.ZIndex = 5; lineMain.Parent = sep

				local gradMain = Instance.new("UIGradient")

				gradMain.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(0.08,0), NumberSequenceKeypoint.new(0.92,0), NumberSequenceKeypoint.new(1,1)})

				gradMain.Rotation = 0; gradMain.Parent = lineMain

				local glowOuter = Instance.new("Frame"); glowOuter.BackgroundColor3 = C.Accent; glowOuter.BackgroundTransparency = 0.55

				glowOuter.Size = UDim2.new(1,0,0,5); glowOuter.AnchorPoint = Vector2.new(0,0.5); glowOuter.Position = UDim2.new(0,0,0.5,0); glowOuter.BorderSizePixel = 0; glowOuter.ZIndex = 4; glowOuter.Parent = lineMain

				local gradOuter = Instance.new("UIGradient")

				gradOuter.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(0.12,0.5), NumberSequenceKeypoint.new(0.5,0.3), NumberSequenceKeypoint.new(0.88,0.5), NumberSequenceKeypoint.new(1,1)})

				gradOuter.Rotation = 0; gradOuter.Parent = glowOuter

				local glowInner = Instance.new("Frame"); glowInner.BackgroundColor3 = C.AccentBright; glowInner.BackgroundTransparency = 0.3

				glowInner.Size = UDim2.new(0.4,0,0,3); glowInner.AnchorPoint = Vector2.new(0.5,0.5); glowInner.Position = UDim2.new(0.5,0,0.5,0); glowInner.BorderSizePixel = 0; glowInner.ZIndex = 6; glowInner.Parent = lineMain

				local gradInner = Instance.new("UIGradient")

				gradInner.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(0.3,0.2), NumberSequenceKeypoint.new(0.5,0), NumberSequenceKeypoint.new(0.7,0.2), NumberSequenceKeypoint.new(1,1)})

				gradInner.Rotation = 0; gradInner.Parent = glowInner

				regTheme(function() lineMain.BackgroundColor3 = C.Accent; glowOuter.BackgroundColor3 = C.Accent; glowInner.BackgroundColor3 = C.AccentBright end)

			end

			function sObj:AddDiscord(nameArg, linkArg)

				local dcTitle  = nameArg or "Discord Server"

				local dcLink   = linkArg or ""

				local dcIcon   = ""

				local dcBanner = ""

				local dcDesc   = ""

				local dcBtn    = "Join Server"

				if type(nameArg) == "table" then

					dcTitle  = nameArg.Title  or nameArg.Name or "Discord Server"

					dcLink   = nameArg.Link   or ""

					dcIcon   = nameArg.Icon   or ""

					dcBanner = nameArg.Banner  or ""

					dcDesc   = nameArg.Description or ""

					dcBtn    = nameArg.Button  or "Join Server"

				end

				pageOrder = pageOrder + 1

				local BANNER_H = 80; local ICON_SZ = 48; local ICON_OVL = ICON_SZ/2

				local cleanCode = dcLink:match("discord%.gg/([^%?#/]+)") or dcLink:match("discord%.com/invite/([^%?#/]+)") or dcLink

				local keyBase = "dinv_"..pageOrder

				local cf = Instance.new("Frame"); cf.BackgroundColor3 = C.Background; cf.BackgroundTransparency = 0.85; cf.Size = UDim2.new(1,0,0,0); cf.AutomaticSize = Enum.AutomaticSize.Y; cf.LayoutOrder = pageOrder; cf.ZIndex = 3; cf.ClipsDescendants = false; cf.Parent = page

				createCorner(cf, INNER_CORNER); local cfStroke = createStroke(cf, C.Border, 1, 0.5); regAccent(cf, "BackgroundColor3", "Background"); regAccent(cfStroke, "Color", "Border")

				local cfLayout = Instance.new("UIListLayout"); cfLayout.FillDirection = Enum.FillDirection.Vertical; cfLayout.Padding = UDim.new(0,0); cfLayout.SortOrder = Enum.SortOrder.LayoutOrder; cfLayout.Parent = cf

				local bannerContainer = Instance.new("Frame"); bannerContainer.BackgroundTransparency = 1; bannerContainer.Size = UDim2.new(1,0,0,BANNER_H); bannerContainer.ClipsDescendants = false; bannerContainer.LayoutOrder = 1; bannerContainer.ZIndex = 4; bannerContainer.Parent = cf

				local bannerFrame = Instance.new("Frame"); bannerFrame.BackgroundColor3 = Color3.fromRGB(28,28,32); bannerFrame.Size = UDim2.new(1,0,0,BANNER_H+INNER_CORNER); bannerFrame.ClipsDescendants = true; bannerFrame.ZIndex = 4; bannerFrame.Parent = bannerContainer; createCorner(bannerFrame, INNER_CORNER)

				if dcBanner ~= "" then

					local bannerImg = Instance.new("ImageLabel"); bannerImg.BackgroundTransparency = 1; bannerImg.Size = UDim2.new(1,0,1,0); bannerImg.Image = dcBanner; bannerImg.ScaleType = Enum.ScaleType.Crop; bannerImg.ZIndex = 5; bannerImg.Parent = bannerFrame

				end

				local accentBarDiv = Instance.new("Frame"); accentBarDiv.BackgroundColor3 = C.Accent; accentBarDiv.BackgroundTransparency = 0.45; accentBarDiv.Size = UDim2.new(1,0,0,2); accentBarDiv.Position = UDim2.new(0,0,1,-2); accentBarDiv.BorderSizePixel = 0; accentBarDiv.ZIndex = 6; accentBarDiv.Parent = bannerFrame

				regTheme(function() accentBarDiv.BackgroundColor3 = C.Accent end)

				local iconBg = Instance.new("Frame"); iconBg.BackgroundColor3 = Color3.fromRGB(36,36,40); iconBg.Size = UDim2.new(0,ICON_SZ,0,ICON_SZ); iconBg.Position = UDim2.new(0,14,0,BANNER_H-ICON_OVL); iconBg.ZIndex = 8; iconBg.Parent = bannerContainer; createCorner(iconBg, 10); createStroke(iconBg, C.Border, 1.5, 0.3)

				if dcIcon ~= "" then

					local iconImg = Instance.new("ImageLabel"); iconImg.BackgroundTransparency = 1; iconImg.Size = UDim2.new(1,0,1,0); iconImg.Image = dcIcon; iconImg.ScaleType = Enum.ScaleType.Crop; iconImg.ZIndex = 9; iconImg.Parent = iconBg; createCorner(iconImg, 10)

				end

				local bodySection = Instance.new("Frame"); bodySection.BackgroundTransparency = 1; bodySection.Size = UDim2.new(1,0,0,0); bodySection.AutomaticSize = Enum.AutomaticSize.Y; bodySection.LayoutOrder = 2; bodySection.ZIndex = 3; bodySection.Parent = cf

				createPadding(bodySection, ICON_OVL+8, 12, 12, 12)

				local bodyLayout = Instance.new("UIListLayout"); bodyLayout.FillDirection = Enum.FillDirection.Vertical; bodyLayout.Padding = UDim.new(0,4); bodyLayout.SortOrder = Enum.SortOrder.LayoutOrder; bodyLayout.Parent = bodySection

				local titleLblDc = Instance.new("TextLabel"); titleLblDc.BackgroundTransparency = 1; titleLblDc.Size = UDim2.new(1,0,0,15); titleLblDc.LayoutOrder = 1; titleLblDc.ZIndex = 5; titleLblDc.FontFace = FONT_BOLD; titleLblDc.TextSize = 13; titleLblDc.TextColor3 = C.TextWhite; titleLblDc.TextXAlignment = Enum.TextXAlignment.Left; titleLblDc.TextTruncate = Enum.TextTruncate.AtEnd; titleLblDc.Text = dcTitle; titleLblDc.Parent = bodySection

				regAccent(titleLblDc, "TextColor3", "TextWhite")

				if dcDesc ~= "" then

					local descLbl = Instance.new("TextLabel"); descLbl.BackgroundTransparency = 1; descLbl.Size = UDim2.new(1,0,0,0); descLbl.AutomaticSize = Enum.AutomaticSize.Y; descLbl.LayoutOrder = 2; descLbl.ZIndex = 5; descLbl.FontFace = FONT; descLbl.TextSize = 11; descLbl.TextColor3 = C.TextSubtitle; descLbl.TextXAlignment = Enum.TextXAlignment.Left; descLbl.TextWrapped = true; descLbl.Text = dcDesc; descLbl.Parent = bodySection

					regAccent(descLbl, "TextColor3", "TextSubtitle")

				end

				local membersRow = Instance.new("Frame"); membersRow.BackgroundTransparency = 1; membersRow.Size = UDim2.new(1,0,0,14); membersRow.LayoutOrder = 3; membersRow.ZIndex = 5; membersRow.Parent = bodySection

				local membersLayout = Instance.new("UIListLayout"); membersLayout.FillDirection = Enum.FillDirection.Horizontal; membersLayout.VerticalAlignment = Enum.VerticalAlignment.Center; membersLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left; membersLayout.Padding = UDim.new(0,10); membersLayout.SortOrder = Enum.SortOrder.LayoutOrder; membersLayout.Parent = membersRow

				local function makeStat(dotColor, order, isOnline)

					local wrap = Instance.new("Frame"); wrap.BackgroundTransparency = 1; wrap.Size = UDim2.new(0,0,1,0); wrap.AutomaticSize = Enum.AutomaticSize.X; wrap.LayoutOrder = order; wrap.ZIndex = 6; wrap.Parent = membersRow

					local wrapLL = Instance.new("UIListLayout"); wrapLL.FillDirection = Enum.FillDirection.Horizontal; wrapLL.VerticalAlignment = Enum.VerticalAlignment.Center; wrapLL.Padding = UDim.new(0,4); wrapLL.SortOrder = Enum.SortOrder.LayoutOrder; wrapLL.Parent = wrap

					local dot = Instance.new("Frame"); dot.BackgroundColor3 = dotColor; dot.BackgroundTransparency = 0; dot.Size = UDim2.new(0,7,0,7); dot.LayoutOrder = 1; dot.ZIndex = 7; dot.Parent = wrap; createCorner(dot, 4)

					if isOnline then regTheme(function() dot.BackgroundColor3 = C.Accent end) end

					local lbl = Instance.new("TextLabel"); lbl.BackgroundTransparency = 1; lbl.Size = UDim2.new(0,0,1,0); lbl.AutomaticSize = Enum.AutomaticSize.X; lbl.FontFace = FONT_BOLD; lbl.TextSize = 10; lbl.TextColor3 = C.TextSubtitle; lbl.TextTransparency = 0.2; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Text = "..."; lbl.LayoutOrder = 2; lbl.ZIndex = 7; lbl.Parent = wrap

					regAccent(lbl, "TextColor3", "TextSubtitle")

					return lbl

				end

				local onlineLbl = makeStat(C.Accent, 1, true); local totalLbl = makeStat(Color3.fromRGB(120,120,120), 2, false)

				local divider = Instance.new("Frame"); divider.BackgroundColor3 = C.Border; divider.BackgroundTransparency = 0.6; divider.Size = UDim2.new(1,0,0,1); divider.BorderSizePixel = 0; divider.LayoutOrder = 4; divider.ZIndex = 5; divider.Parent = bodySection

				regAccent(divider, "BackgroundColor3", "Border")

				local joinBtnBox = Instance.new("Frame"); joinBtnBox.BackgroundColor3 = C.Background; joinBtnBox.BackgroundTransparency = 0.55; joinBtnBox.Size = UDim2.new(1,0,0,32); joinBtnBox.LayoutOrder = 5; joinBtnBox.ZIndex = 5; joinBtnBox.Parent = bodySection; createCorner(joinBtnBox, 6)

				regAccent(joinBtnBox, "BackgroundColor3", "Background")

				local joinBtnStroke = createStroke(joinBtnBox, C.Accent, 1.5, 1); regTheme(function() joinBtnStroke.Color = C.Accent end)

				local joinBtn = Instance.new("TextButton"); joinBtn.BackgroundTransparency = 1; joinBtn.Size = UDim2.new(1,0,1,0); joinBtn.Text = dcBtn; joinBtn.FontFace = FONT_BOLD; joinBtn.TextSize = 12; joinBtn.TextColor3 = Color3.fromRGB(255,255,255); joinBtn.TextXAlignment = Enum.TextXAlignment.Center; joinBtn.TextYAlignment = Enum.TextYAlignment.Center; joinBtn.AutoButtonColor = false; joinBtn.ZIndex = 6; joinBtn.Parent = joinBtnBox

				joinBtn.MouseEnter:Connect(function() cancelTweens(keyBase.."_jh"); playTween(keyBase.."_jh", joinBtnBox, TWEEN_FAST, {BackgroundTransparency=0}); playTween(keyBase.."_jh", joinBtnStroke, TWEEN_FAST, {Transparency=0}) end)

				joinBtn.MouseLeave:Connect(function() cancelTweens(keyBase.."_jh"); playTween(keyBase.."_jh", joinBtnBox, TWEEN_FAST, {BackgroundTransparency=0.55}); playTween(keyBase.."_jh", joinBtnStroke, TWEEN_FAST, {Transparency=1}) end)

				joinBtn.MouseButton1Click:Connect(function()

					if dcLink == "" then return end; playSound(SND_CLICK)

					pcall(function() setclipboard(dcLink) end)

					pcall(function() game:GetService("GuiService"):SetClipboard(dcLink) end)

					if showNotify then showNotify({Title="Copied!", Text="Discord link copied to clipboard.", Duration=2.5}) end

				end)

				task.spawn(function()

					local function fmt(n) n = tonumber(n); if not n then return "N/A" end; if n >= 1000000 then return string.format("%.1fM", n/1000000) elseif n >= 1000 then return string.format("%.1fk", n/1000) else return tostring(n) end end

					local requestFunc

					if syn and syn.request then requestFunc = syn.request elseif http and http.request then requestFunc = http.request else local ok, r = pcall(function() return request end); if ok and type(r)=="function" then requestFunc = r end end

					while onlineLbl and onlineLbl.Parent and totalLbl and totalLbl.Parent do

						if cleanCode ~= "" and dcLink ~= "" and requestFunc then

							local ok, result = pcall(function()

								return requestFunc({Url="https://discord.com/api/v9/invites/"..cleanCode.."?with_counts=true", Method="GET"})

							end)

							if ok and result and result.StatusCode == 200 then

								local ok2, data = pcall(function() return game:GetService("HttpService"):JSONDecode(result.Body) end)

								if ok2 and data then

									if onlineLbl and onlineLbl.Parent then onlineLbl.Text = fmt(data.approximate_presence_count or 0).." Online" end

									if totalLbl  and totalLbl.Parent  then totalLbl.Text  = fmt(data.approximate_member_count or 0).." Members" end

								end

							end

						end

						task.wait(30)

					end

				end)

				registerSearch(dcTitle, "", cf)

			end

			function sObj:AddDropdownWithHoldTime(cfg)
				cfg = cfg or {}
				local ddTitle   = cfg.Title or "Skills"
				local ddOptions = cfg.Options or cfg.Values or {}
				local ddDefault = cfg.Default or {}
				if type(ddDefault) ~= "table" then ddDefault = {ddDefault} end
				local ddCb      = cfg.Callback or function() end
				local htCb      = cfg.HoldTimeCallback or function() end
				local defHold   = cfg.DefaultHoldTime or 0.5
				pageOrder = pageOrder + 1
				local selected = {}
				local holdTimes = {}
				for _, v in ipairs(ddDefault) do selected[tostring(v)] = true end
				for _, v in ipairs(ddOptions) do holdTimes[tostring(v)] = defHold end
				local isOpen = false
				local df = Instance.new("Frame"); df.BackgroundTransparency = 1; df.Size = UDim2.new(1,0,0,0); df.AutomaticSize = Enum.AutomaticSize.Y; df.LayoutOrder = pageOrder; df.ZIndex = 3; df.Parent = page
				local dfLayout = Instance.new("UIListLayout"); dfLayout.FillDirection = Enum.FillDirection.Vertical; dfLayout.Padding = UDim.new(0,4); dfLayout.SortOrder = Enum.SortOrder.LayoutOrder; dfLayout.Parent = df
				local ddHeader = Instance.new("Frame"); ddHeader.BackgroundColor3 = C.Background; ddHeader.BackgroundTransparency = 0.85; ddHeader.Size = UDim2.new(1,0,0,40); ddHeader.LayoutOrder = 1; ddHeader.ZIndex = 4; ddHeader.Parent = df
				createPadding(ddHeader, 6, 12, 6, 12); addGlowHover(ddHeader, "ddht_"..ddTitle..pageOrder)
				regAccent(ddHeader, "BackgroundColor3", "Background")
				local topRow = Instance.new("Frame"); topRow.BackgroundTransparency = 1; topRow.Size = UDim2.new(1,0,1,0); topRow.ZIndex = 5; topRow.Parent = ddHeader
				local ddTitleLabel = Instance.new("TextLabel"); ddTitleLabel.BackgroundTransparency = 1; ddTitleLabel.Size = UDim2.new(1,-22,0,16); ddTitleLabel.Position = UDim2.new(0,0,0,0); ddTitleLabel.FontFace = FONT_BOLD; ddTitleLabel.TextSize = 13; ddTitleLabel.TextColor3 = C.TextWhite; ddTitleLabel.TextXAlignment = Enum.TextXAlignment.Left; ddTitleLabel.Text = ddTitle; ddTitleLabel.ZIndex = 6; ddTitleLabel.Parent = topRow
				regAccent(ddTitleLabel, "TextColor3", "TextWhite")
				local function getSelText() local p = {} for _,o in ipairs(ddOptions) do local v=tostring(o); if selected[v] then table.insert(p,v.."("..tostring(holdTimes[v]).."s)") end end; return #p>0 and table.concat(p,", ") or "None" end
				local selLabel = Instance.new("TextLabel"); selLabel.BackgroundTransparency = 1; selLabel.Size = UDim2.new(1,-22,0,12); selLabel.Position = UDim2.new(0,0,0,16); selLabel.FontFace = FONT; selLabel.TextSize = 10; selLabel.TextColor3 = C.TextSubtitle; selLabel.TextXAlignment = Enum.TextXAlignment.Left; selLabel.Text = getSelText(); selLabel.ZIndex = 6; selLabel.Parent = topRow
				regAccent(selLabel, "TextColor3", "TextSubtitle")
				local ddArrow = Instance.new("ImageLabel"); ddArrow.BackgroundTransparency = 1; ddArrow.Size = UDim2.new(0,14,0,14)
				ddArrow.AnchorPoint = Vector2.new(1,0.5); ddArrow.Position = UDim2.new(1,0,0.5,0); ddArrow.Image = "rbxassetid://10709790948"
				ddArrow.Rotation = 0; ddArrow.ImageColor3 = C.TextSubtitle; ddArrow.ZIndex = 6; ddArrow.Parent = topRow
				regAccent(ddArrow, "ImageColor3", "TextSubtitle")
				local menuWrap = Instance.new("Frame"); menuWrap.BackgroundTransparency = 1; menuWrap.Size = UDim2.new(1,0,0,0); menuWrap.ClipsDescendants = true; menuWrap.LayoutOrder = 2; menuWrap.ZIndex = 20; menuWrap.Parent = df
				local menuBg = Instance.new("ScrollingFrame"); menuBg.BackgroundColor3 = Color3.fromRGB(15,15,15); menuBg.Size = UDim2.new(1,0,1,0); menuBg.CanvasSize = UDim2.new(0,0,0,0); menuBg.AutomaticCanvasSize = Enum.AutomaticSize.Y; menuBg.ScrollBarThickness = 2; menuBg.ScrollBarImageColor3 = SCROLL_NEUTRAL; menuBg.ZIndex = 20; menuBg.Parent = menuWrap; menuBg.BorderSizePixel = 0
				createCorner(menuBg, 8); local menuStroke = createStroke(menuBg, C.Border, 1, 0.45); regTheme(function() menuStroke.Color = C.Border end)
				local menuLayout = Instance.new("UIListLayout"); menuLayout.FillDirection = Enum.FillDirection.Vertical; menuLayout.Padding = UDim.new(0,5); menuLayout.SortOrder = Enum.SortOrder.LayoutOrder; menuLayout.Parent = menuBg
				createPadding(menuBg, 5, 5, 5, 5)
				local optionFrames = {}
				local function fireCallback()
					local out = {}; for _,o in ipairs(ddOptions) do local v=tostring(o); if selected[v] then table.insert(out,v) end end
					ddCb(out, holdTimes)
				end
				local function updateVisuals()
					selLabel.Text = getSelText()
					for _,of in ipairs(optionFrames) do
						local isSel = selected[of._val] == true
						TweenService:Create(of._bar, TWEEN_FAST, {BackgroundTransparency=isSel and 0 or 1}):Play()
						TweenService:Create(of._frame, TWEEN_FAST, {BackgroundTransparency=isSel and 0.82 or 1, BackgroundColor3=C.Background}):Play()
						TweenService:Create(of._lbl, TWEEN_FAST, {TextColor3=isSel and C.AccentBright or C.TextWhite}):Play()
					end
				end
				for i, opt in ipairs(ddOptions) do
					local val = tostring(opt)
					local isSel = selected[val] == true
					local optFrame = Instance.new("Frame"); optFrame.BackgroundColor3 = C.Background; optFrame.BackgroundTransparency = isSel and 0.82 or 1; optFrame.Size = UDim2.new(1,0,0,30); optFrame.LayoutOrder = i; optFrame.ZIndex = 21; optFrame.Parent = menuBg; createCorner(optFrame, 5)
					regAccent(optFrame, "BackgroundColor3", "Background")
					local bar = Instance.new("Frame"); bar.BackgroundColor3 = C.Accent; bar.BackgroundTransparency = isSel and 0 or 1; bar.Size = UDim2.new(0,2,1,-8); bar.Position = UDim2.new(0,1,0,4); bar.ZIndex = 22; bar.Parent = optFrame; createCorner(bar, 1)
					regTheme(function() bar.BackgroundColor3 = C.Accent end)
					local optLbl = Instance.new("TextLabel"); optLbl.BackgroundTransparency = 1; optLbl.Size = UDim2.new(0.5,-14,0,13); optLbl.Position = UDim2.new(0,10,0,8); optLbl.FontFace = FONT_BOLD; optLbl.TextSize = 11; optLbl.TextColor3 = isSel and C.AccentBright or C.TextWhite; optLbl.TextXAlignment = Enum.TextXAlignment.Left; optLbl.Text = val; optLbl.ZIndex = 22; optLbl.Parent = optFrame
					regAccent(optLbl, "TextColor3", "TextWhite")
					local htWrap = Instance.new("Frame"); htWrap.BackgroundColor3 = Color3.fromRGB(20,20,20); htWrap.BackgroundTransparency = 0.4; htWrap.Size = UDim2.new(0,70,0,22); htWrap.Position = UDim2.new(1,-76,0,4); htWrap.ZIndex = 22; htWrap.Parent = optFrame; createCorner(htWrap, 4)
					local htLabel = Instance.new("TextLabel"); htLabel.BackgroundTransparency = 1; htLabel.Size = UDim2.new(0,30,1,0); htLabel.Position = UDim2.new(0,4,0,0); htLabel.FontFace = FONT; htLabel.TextSize = 9; htLabel.TextColor3 = C.TextSubtitle; htLabel.Text = "Hold:"; htLabel.ZIndex = 23; htLabel.Parent = htWrap
					regAccent(htLabel, "TextColor3", "TextSubtitle")
					local htBox = Instance.new("TextBox"); htBox.BackgroundTransparency = 1; htBox.Size = UDim2.new(0,32,1,0); htBox.Position = UDim2.new(0,32,0,0); htBox.FontFace = FONT_BOLD; htBox.TextSize = 11; htBox.TextColor3 = C.TextWhite; htBox.PlaceholderText = "0.5"; htBox.Text = tostring(defHold); htBox.ClearTextOnFocus = false; htBox.ZIndex = 24; htBox.Parent = htWrap
					regAccent(htBox, "TextColor3", "TextWhite")
					do
						local capturedVal = val
						htBox.FocusLost:Connect(function()
							local n = tonumber(htBox.Text)
							if n and n >= 0 and n <= 30 then
								holdTimes[capturedVal] = n
								htCb(capturedVal, n)
								selLabel.Text = getSelText()
								if _G and _G.AutoSaveHook then _G.AutoSaveHook("NM_HT_"..ddTitle.."_"..capturedVal, n) end
							else
								htBox.Text = tostring(holdTimes[capturedVal] or defHold)
							end
						end)
						if _G and _G.AutoLoadHook then
							local sv = _G.AutoLoadHook("NM_HT_"..ddTitle.."_"..capturedVal, nil)
							if sv then holdTimes[capturedVal] = sv; htBox.Text = tostring(sv) end
						end
					end
					local optBtn = Instance.new("TextButton"); optBtn.BackgroundTransparency = 1; optBtn.Size = UDim2.new(0.5,0,1,0); optBtn.Text = ""; optBtn.ZIndex = 23; optBtn.AutoButtonColor = false; optBtn.Parent = optFrame
					do
						local capturedVal = val
						local ohk = "ddhtopt_"..capturedVal..pageOrder
						optBtn.MouseEnter:Connect(function() if not selected[capturedVal] then cancelTweens(ohk); playTween(ohk, optFrame, TWEEN_FAST, {BackgroundColor3=C.Background, BackgroundTransparency=0.88}) end end)
						optBtn.MouseLeave:Connect(function() if not selected[capturedVal] then cancelTweens(ohk); playTween(ohk, optFrame, TWEEN_FAST, {BackgroundColor3=C.Background, BackgroundTransparency=1}) end end)
						optBtn.MouseButton1Click:Connect(function()
							playSound(SND_CLICK)
							selected[capturedVal] = not selected[capturedVal]
							updateVisuals(); fireCallback()
						end)
					end
					table.insert(optionFrames, {_frame=optFrame, _bar=bar, _val=val, _lbl=optLbl})
				end
				regTheme(function() for _,of in ipairs(optionFrames) do of._bar.BackgroundColor3 = C.Accent; of._lbl.TextColor3 = selected[of._val] and C.AccentBright or C.TextWhite end end)
				local mh = math.min(10 + #ddOptions * 34, 180)
				local function openMenu() isOpen=true; cancelTweens("ddhtmenu_"..pageOrder); playTween("ddhtmenu_"..pageOrder, menuWrap, TWEEN_SMOOTH, {Size=UDim2.new(1,0,0,mh)}); playTween("ddhtmenu_"..pageOrder, ddHeader, TWEEN_FAST, {BackgroundTransparency=0.7}); playTween("ddhtmenu_"..pageOrder, ddArrow, TWEEN_FAST, {Rotation=180}) end
				local function closeMenu() isOpen=false; cancelTweens("ddhtmenu_"..pageOrder); playTween("ddhtmenu_"..pageOrder, menuWrap, TWEEN_FAST, {Size=UDim2.new(1,0,0,0)}); playTween("ddhtmenu_"..pageOrder, ddHeader, TWEEN_FAST, {BackgroundTransparency=0.85}); playTween("ddhtmenu_"..pageOrder, ddArrow, TWEEN_FAST, {Rotation=0}) end
				local ddhk = "ddhthov_"..ddTitle..pageOrder
				ddHeader.InputBegan:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseMovement then cancelTweens(ddhk); if not isOpen then playTween(ddhk, ddHeader, TWEEN_FAST, {BackgroundTransparency=0.5}) end end end)
				ddHeader.InputEnded:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseMovement then cancelTweens(ddhk); if not isOpen then playTween(ddhk, ddHeader, TWEEN_FAST, {BackgroundTransparency=0.85}) end end end)
				local headerBtn = Instance.new("TextButton"); headerBtn.BackgroundTransparency = 1; headerBtn.Size = UDim2.new(1,0,1,0); headerBtn.Text = ""; headerBtn.ZIndex = 7; headerBtn.AutoButtonColor = false; headerBtn.Parent = ddHeader
				headerBtn.MouseButton1Click:Connect(function() if isOpen then closeMenu() else openMenu() end end)
				local ddObj = {}
				function ddObj:GetSelected() local out={} for _,o in ipairs(ddOptions) do local v=tostring(o); if selected[v] then table.insert(out,v) end end; return out end
				function ddObj:GetHoldTime(skill) return holdTimes[tostring(skill)] or defHold end
				function ddObj:GetAll() local out={} for _,o in ipairs(ddOptions) do local v=tostring(o); out[v]={selected=selected[v]==true, holdTime=holdTimes[v] or defHold} end; return out end
				function ddObj:Close() closeMenu() end
				function ddObj:Open() openMenu() end
				task.defer(function() fireCallback() end)
				registerSearch(ddTitle, "", df)
				return ddObj
			end

			return sObj

		end

		return tabObj

	end

	function windowObj:Notify(nc)

		if showNotify then showNotify(nc) end

	end

	return windowObj

end

return Library
