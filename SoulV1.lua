-- Soul V1 | Bloodshot Red | Onyx-style Layout
-- Mutual tag detection via BillboardGui marker (replicates natively to all clients)

local Players        = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService   = game:GetService("TweenService")
local RunService     = game:GetService("RunService")
local SoundService   = game:GetService("SoundService")
local Workspace      = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local gui    = player:WaitForChild("PlayerGui")

-- ===================== CAMERA =====================
local viewConnection = nil
local function startViewing(targetPlayer)
    if viewConnection then viewConnection:Disconnect() end
    viewConnection = RunService.RenderStepped:Connect(function()
        if targetPlayer and targetPlayer.Character then
            local root = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                camera.CameraType = Enum.CameraType.Scriptable
                camera.CFrame = root.CFrame * CFrame.new(0, 3, 8)
            end
        end
    end)
end
local function stopViewing()
    if viewConnection then viewConnection:Disconnect(); viewConnection = nil end
    camera.CameraType = Enum.CameraType.Custom
end

-- ===================== BLOODSHOT RED PALETTE =====================
local BG_DARKEST  = Color3.fromRGB(28,  0,  0)
local BG_DARK     = Color3.fromRGB(45,  0,  0)
local BG_MID      = Color3.fromRGB(60,  2,  2)
local BG_CARD     = Color3.fromRGB(80,  4,  4)
local BG_NAVBAR   = Color3.fromRGB(22,  0,  0)
local RED_VIVID   = Color3.fromRGB(200,  0,  0)
local RED_BRIGHT  = Color3.fromRGB(230, 20, 20)
local RED_GLOW    = Color3.fromRGB(255, 40, 40)
local RED_STROKE  = Color3.fromRGB(160,  8,  8)
local TXT_WHITE   = Color3.new(1, 1, 1)
local TXT_MAIN    = Color3.fromRGB(255, 200, 200)
local TXT_DIM     = Color3.fromRGB(160,  70,  70)
local TXT_LABEL   = Color3.fromRGB(220,  50,  50)
local GREEN_LOADED = Color3.fromRGB(80, 255, 120)

-- Dimensions
local UI_W   = 760
local UI_H   = 480
local NAV_H  = 38
local SIDE_W = 160
local MAIN_W = UI_W - SIDE_W - 6

-- ===================== GUI ROOT =====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name            = "SoulV1"
screenGui.ResetOnSpawn    = false
screenGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
screenGui.Parent          = gui

-- ===================== SOUND =====================
local openSound = Instance.new("Sound")
openSound.SoundId = "rbxassetid://6026984224"
openSound.Volume  = 0.6
openSound.Parent  = SoundService

-- ===================== BILLBOARD TAG =====================
local function attachTag(character, tagOwner)
    local head = character:WaitForChild("Head", 10)
    if not head then return end

    local existing = head:FindFirstChild("SoulBillboard")
    if existing then existing:Destroy() end

    local billboard = Instance.new("BillboardGui")
    billboard.Name             = "SoulBillboard"
    billboard.Size             = UDim2.new(0, 220, 0, 58)
    billboard.StudsOffset      = Vector3.new(0, 2.8, 0)
    billboard.AlwaysOnTop      = false
    billboard.ResetOnSpawn     = false
    billboard.MaxDistance      = 0
    billboard.SizeOffset       = Vector2.new(0, 0)
    billboard.ClipsDescendants = false
    billboard.Adornee          = head
    billboard.Parent           = head

    -- Purple palette
    local PURPLE_BRIGHT = Color3.fromRGB(180, 0, 255)
    local PURPLE_GLOW   = Color3.fromRGB(210, 80, 255)
    local PURPLE_DIM    = Color3.fromRGB(140, 50, 200)
    local PURPLE_BG     = Color3.fromRGB(20, 5, 30)
    local PURPLE_LOGO   = Color3.fromRGB(35, 10, 50)

    -- Pill
    local tag = Instance.new("Frame")
    tag.Size                   = UDim2.new(1, 0, 1, 0)
    tag.BackgroundColor3       = PURPLE_BG
    tag.BorderSizePixel        = 0
    tag.BackgroundTransparency = 1
    tag.Active                 = true
    tag.Parent                 = billboard
    Instance.new("UICorner", tag).CornerRadius = UDim.new(0, 28)

    local tagStroke = Instance.new("UIStroke", tag)
    tagStroke.Color = PURPLE_BRIGHT; tagStroke.Thickness = 2.5; tagStroke.Transparency = 1

    -- Glow ring
    local glowRing = Instance.new("Frame")
    glowRing.Size = UDim2.new(1, 8, 1, 8); glowRing.Position = UDim2.new(0, -4, 0, -4)
    glowRing.BackgroundTransparency = 1; glowRing.BorderSizePixel = 0; glowRing.ZIndex = 0
    glowRing.Parent = tag
    Instance.new("UICorner", glowRing).CornerRadius = UDim.new(0, 32)
    local glowStroke = Instance.new("UIStroke", glowRing)
    glowStroke.Color = PURPLE_GLOW; glowStroke.Thickness = 4; glowStroke.Transparency = 1

    -- Logo box (drawn S shape)
    local logoBox = Instance.new("Frame")
    logoBox.Size = UDim2.new(0, 40, 0, 40); logoBox.Position = UDim2.new(0, 8, 0.5, -20)
    logoBox.BackgroundColor3 = PURPLE_LOGO; logoBox.BackgroundTransparency = 1
    logoBox.Parent = tag
    Instance.new("UICorner", logoBox).CornerRadius = UDim.new(0, 10)

    local function iconBar(py, color)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(0, 22, 0, 4); f.Position = UDim2.new(0, 9, 0, py)
        f.BackgroundColor3 = color; f.BorderSizePixel = 0; f.Parent = logoBox
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 2)
        return f
    end
    iconBar(8,  PURPLE_GLOW)
    local iconMid = iconBar(18, PURPLE_BRIGHT)
    iconBar(28, PURPLE_GLOW)

    local function iconVert(px, py, color)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(0, 4, 0, 14); f.Position = UDim2.new(0, px, 0, py)
        f.BackgroundColor3 = color; f.BorderSizePixel = 0; f.Parent = logoBox
        return f
    end
    iconVert(9,  8,  PURPLE_GLOW)
    iconVert(27, 18, PURPLE_BRIGHT)

    TweenService:Create(iconMid,
        TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        { BackgroundColor3 = Color3.fromRGB(255, 120, 255) }
    ):Play()

    -- Labels
    local nameLabelBaseY   = 7
    local handleLabelBaseY = 32

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -58, 0, 24); nameLabel.Position = UDim2.new(0, 54, 0, nameLabelBaseY)
    nameLabel.BackgroundTransparency = 1; nameLabel.Text = "Soul User"
    nameLabel.TextColor3 = PURPLE_GLOW; nameLabel.TextTransparency = 1
    nameLabel.TextSize = 15; nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left; nameLabel.Parent = tag

    local handleLabel = Instance.new("TextLabel")
    handleLabel.Size = UDim2.new(1, -58, 0, 18); handleLabel.Position = UDim2.new(0, 54, 0, handleLabelBaseY)
    handleLabel.BackgroundTransparency = 1
    handleLabel.Text = "@" .. (tagOwner and tagOwner.Name or "unknown")
    handleLabel.TextColor3 = PURPLE_DIM; handleLabel.TextTransparency = 1
    handleLabel.TextSize = 12; handleLabel.Font = Enum.Font.Gotham
    handleLabel.TextXAlignment = Enum.TextXAlignment.Left; handleLabel.Parent = tag

    -- Distance-proportional size scaling
    local BASE_W, BASE_H, BASE_DIST = 220, 58, 16
    local sizeConn
    sizeConn = RunService.RenderStepped:Connect(function()
        if not head.Parent then sizeConn:Disconnect(); return end
        local dist   = (camera.CFrame.Position - head.Position).Magnitude
        local factor = math.clamp(BASE_DIST / math.max(dist, 1), 0.25, 1.5)
        billboard.Size = UDim2.new(0, BASE_W * factor, 0, BASE_H * factor)
    end)

    -- Text float up/down
    local floatConn
    floatConn = RunService.Heartbeat:Connect(function()
        if not nameLabel.Parent then floatConn:Disconnect(); return end
        local o = math.sin(tick() * 1.2) * 4
        nameLabel.Position   = UDim2.new(0, 54, 0, nameLabelBaseY   + o)
        handleLabel.Position = UDim2.new(0, 54, 0, handleLabelBaseY + o)
    end)

    -- Click to teleport
    tag.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if tagOwner and tagOwner ~= player and tagOwner.Character then
                local tr = tagOwner.Character:FindFirstChild("HumanoidRootPart")
                local mr = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if tr and mr then mr.CFrame = tr.CFrame * CFrame.new(0, 0, -3) end
            end
        end
    end)

    -- Glitch
    local function startGlitch()
        local FLASH = Color3.fromRGB(255, 255, 255)
        local fastEnd = tick() + 2
        task.spawn(function()
            while tick() < fastEnd and nameLabel.Parent do
                nameLabel.TextColor3 = FLASH;       task.wait(0.03)
                nameLabel.TextColor3 = PURPLE_BRIGHT; task.wait(0.03)
                nameLabel.TextColor3 = Color3.fromRGB(100, 0, 200); task.wait(0.02)
                nameLabel.TextColor3 = PURPLE_GLOW;  task.wait(0.04)
                tagStroke.Color = Color3.fromRGB(255, 100, 255); task.wait(0.03)
                tagStroke.Color = PURPLE_BRIGHT
            end
            nameLabel.TextColor3 = PURPLE_GLOW
            tagStroke.Color = PURPLE_BRIGHT
            while nameLabel.Parent do
                task.wait(math.random(30, 80) / 10)
                if not nameLabel.Parent then break end
                for _ = 1, math.random(2, 3) do
                    nameLabel.TextColor3 = FLASH;         task.wait(0.05)
                    nameLabel.TextColor3 = PURPLE_BRIGHT; task.wait(0.05)
                    nameLabel.TextColor3 = Color3.fromRGB(100, 0, 200); task.wait(0.04)
                end
                nameLabel.TextColor3 = PURPLE_GLOW
                TweenService:Create(tagStroke, TweenInfo.new(0.1),  { Color = Color3.fromRGB(255, 160, 255) }):Play()
                task.wait(0.15)
                TweenService:Create(tagStroke, TweenInfo.new(0.4),  { Color = PURPLE_BRIGHT }):Play()
            end
        end)
    end

    -- Fade in
    local fi = TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    TweenService:Create(tag,         fi, { BackgroundTransparency = 0 }):Play()
    TweenService:Create(tagStroke,   fi, { Transparency = 0 }):Play()
    TweenService:Create(glowStroke,  fi, { Transparency = 0.6 }):Play()
    TweenService:Create(logoBox,     fi, { BackgroundTransparency = 0 }):Play()
    TweenService:Create(nameLabel,   fi, { TextTransparency = 0 }):Play()
    TweenService:Create(handleLabel, fi, { TextTransparency = 0 }):Play()
    task.delay(0.65, startGlitch)
end

-- ===================== MARKER-BASED MUTUAL TAGGING =====================
-- We plant a tiny invisible BillboardGui ("SoulV1Active") on our own Head.
-- Because BillboardGui replicates from the character to ALL clients automatically,
-- any other player who runs this script will see the marker and show our tag.
-- We do the same in reverse for them.

local MARKER_NAME = "SoulV1Active"

local function plantMarker(character)
    local head = character:WaitForChild("Head", 10)
    if not head or head:FindFirstChild(MARKER_NAME) then return end
    local marker = Instance.new("BillboardGui")
    marker.Name    = MARKER_NAME
    marker.Size    = UDim2.new(0, 0, 0, 0)
    marker.Enabled = false
    marker.Parent  = head
    -- Also show our own tag to ourselves
    attachTag(character, player)
end

if player.Character then task.spawn(plantMarker, player.Character) end
player.CharacterAdded:Connect(plantMarker)

-- Watch another player: as soon as their Head has SoulV1Active, show their tag
local function watchPlayer(p)
    if p == player then return end
    local function onCharAdded(char)
        task.spawn(function()
            local head = char:WaitForChild("Head", 10)
            if not head then return end
            if head:FindFirstChild(MARKER_NAME) then
                attachTag(char, p); return
            end
            local conn
            conn = head.ChildAdded:Connect(function(child)
                if child.Name == MARKER_NAME then
                    conn:Disconnect()
                    attachTag(char, p)
                end
            end)
            char.AncestryChanged:Connect(function()
                if not char.Parent then pcall(function() conn:Disconnect() end) end
            end)
        end)
    end
    if p.Character then onCharAdded(p.Character) end
    p.CharacterAdded:Connect(onCharAdded)
end

for _, p in ipairs(Players:GetPlayers()) do watchPlayer(p) end
Players.PlayerAdded:Connect(watchPlayer)

Players.PlayerRemoving:Connect(function(p)
    if p.Character then
        local h = p.Character:FindFirstChild("Head")
        if h then
            local bb = h:FindFirstChild("SoulBillboard")
            if bb then bb:Destroy() end
        end
    end
end)

-- ===================== REOPEN HAMBURGER BUTTON =====================
local reopenBtn = Instance.new("TextButton")
reopenBtn.Size             = UDim2.new(0, 52, 0, 52)
reopenBtn.Position         = UDim2.new(1, -62, 0.5, -26)
reopenBtn.BackgroundColor3 = BG_DARK
reopenBtn.Text             = ""
reopenBtn.Visible          = false
reopenBtn.ZIndex           = 20
reopenBtn.Parent           = screenGui
Instance.new("UICorner", reopenBtn).CornerRadius = UDim.new(0, 12)
local rbs = Instance.new("UIStroke", reopenBtn)
rbs.Color = RED_STROKE; rbs.Thickness = 2; rbs.Transparency = 0.2

local hamburgerLines = {}
for i = 0, 2 do
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0, 28, 0, 4); line.Position = UDim2.new(0, 12, 0, 13 + i * 11)
    line.BackgroundColor3 = RED_GLOW; line.BorderSizePixel = 0; line.ZIndex = 21
    line.Parent = reopenBtn
    Instance.new("UICorner", line).CornerRadius = UDim.new(0, 2)
    hamburgerLines[i] = line
end

local function flashLines()
    while reopenBtn.Visible do
        for _, l in pairs(hamburgerLines) do
            TweenService:Create(l, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { BackgroundTransparency = 0.85 }):Play()
        end
        task.wait(0.9)
        for _, l in pairs(hamburgerLines) do
            TweenService:Create(l, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { BackgroundTransparency = 0 }):Play()
        end
        task.wait(0.9)
    end
end
reopenBtn:GetPropertyChangedSignal("Visible"):Connect(function()
    if reopenBtn.Visible then task.spawn(flashLines) end
end)

-- ===================== WRAPPER =====================
local wrapper = Instance.new("Frame")
wrapper.Size = UDim2.new(0, UI_W, 0, UI_H)
wrapper.Position = UDim2.new(0.5, -UI_W/2, 0.5, -UI_H/2)
wrapper.BackgroundTransparency = 1
wrapper.ClipsDescendants = false
wrapper.Parent = screenGui

-- ===================== TOP NAVBAR =====================
local navbar = Instance.new("Frame")
navbar.Size = UDim2.new(1, 0, 0, NAV_H)
navbar.BackgroundColor3 = BG_NAVBAR
navbar.BorderSizePixel = 0; navbar.ZIndex = 5
navbar.Parent = wrapper
Instance.new("UICorner", navbar).CornerRadius = UDim.new(0, 14)
local navStroke = Instance.new("UIStroke", navbar)
navStroke.Color = RED_STROKE; navStroke.Thickness = 1.5; navStroke.Transparency = 0.3

local logoImg = Instance.new("ImageLabel")
logoImg.Size = UDim2.new(0, 26, 0, 26); logoImg.Position = UDim2.new(0, 8, 0.5, -13)
logoImg.BackgroundTransparency = 1; logoImg.Image = "rbxassetid://117235528927542"
logoImg.ImageColor3 = RED_GLOW; logoImg.ScaleType = Enum.ScaleType.Fit
logoImg.ZIndex = 6; logoImg.Parent = navbar

local navTitle = Instance.new("TextLabel")
navTitle.Size = UDim2.new(0, 80, 1, 0); navTitle.Position = UDim2.new(0, 40, 0, 0)
navTitle.BackgroundTransparency = 1; navTitle.Text = "Soul V1"
navTitle.TextColor3 = TXT_WHITE; navTitle.TextSize = 16
navTitle.Font = Enum.Font.GothamBold; navTitle.TextXAlignment = Enum.TextXAlignment.Left
navTitle.ZIndex = 6; navTitle.Parent = navbar

local navBy = Instance.new("TextLabel")
navBy.Size = UDim2.new(0, 80, 1, 0); navBy.Position = UDim2.new(0, 122, 0, 0)
navBy.BackgroundTransparency = 1; navBy.Text = "by Soul"
navBy.TextColor3 = TXT_DIM; navBy.TextSize = 12
navBy.Font = Enum.Font.Gotham; navBy.TextXAlignment = Enum.TextXAlignment.Left
navBy.ZIndex = 6; navBy.Parent = navbar

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 22, 0, 22); minimizeBtn.Position = UDim2.new(1, -28, 0.5, -11)
minimizeBtn.BackgroundColor3 = RED_GLOW; minimizeBtn.Text = ""
minimizeBtn.ZIndex = 6; minimizeBtn.Parent = navbar
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(1, 0)
local minStroke = Instance.new("UIStroke", minimizeBtn)
minStroke.Color = Color3.fromRGB(255, 120, 120); minStroke.Thickness = 1.5; minStroke.Transparency = 0.2
TweenService:Create(minimizeBtn, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    { BackgroundColor3 = RED_VIVID }):Play()

-- ===================== BODY =====================
local body = Instance.new("Frame")
body.Size = UDim2.new(1, 0, 1, -NAV_H - 4)
body.Position = UDim2.new(0, 0, 0, NAV_H + 4)
body.BackgroundTransparency = 1; body.ClipsDescendants = false
body.Parent = wrapper

-- ===================== SIDEBAR =====================
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, SIDE_W, 1, 0)
sidebar.BackgroundColor3 = BG_DARK; sidebar.BorderSizePixel = 0
sidebar.ClipsDescendants = true; sidebar.Parent = body
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 14)
local sk = Instance.new("UIStroke", sidebar)
sk.Color = RED_STROKE; sk.Thickness = 1.5; sk.Transparency = 0.3

local tabsLabel = Instance.new("TextLabel")
tabsLabel.Size = UDim2.new(1, -16, 0, 20); tabsLabel.Position = UDim2.new(0, 12, 0, 12)
tabsLabel.BackgroundTransparency = 1; tabsLabel.Text = "TABS"
tabsLabel.TextColor3 = TXT_LABEL; tabsLabel.TextSize = 10
tabsLabel.Font = Enum.Font.GothamBold; tabsLabel.TextXAlignment = Enum.TextXAlignment.Left
tabsLabel.Parent = sidebar

local sideDiv = Instance.new("Frame")
sideDiv.Size = UDim2.new(1, -16, 0, 1); sideDiv.Position = UDim2.new(0, 8, 0, 34)
sideDiv.BackgroundColor3 = RED_STROKE; sideDiv.BorderSizePixel = 0
sideDiv.BackgroundTransparency = 0.5; sideDiv.Parent = sidebar

local tabList = Instance.new("UIListLayout")
tabList.FillDirection = Enum.FillDirection.Vertical
tabList.SortOrder = Enum.SortOrder.LayoutOrder
tabList.Padding = UDim.new(0, 2); tabList.Parent = sidebar

local tabListPad = Instance.new("UIPadding")
tabListPad.PaddingTop = UDim.new(0, 40)
tabListPad.PaddingLeft = UDim.new(0, 8)
tabListPad.PaddingRight = UDim.new(0, 8)
tabListPad.Parent = sidebar

-- ===================== MAIN PANEL =====================
local mainPanel = Instance.new("Frame")
mainPanel.Size = UDim2.new(0, MAIN_W, 1, 0)
mainPanel.Position = UDim2.new(0, SIDE_W + 6, 0, 0)
mainPanel.BackgroundColor3 = BG_MID; mainPanel.BorderSizePixel = 0
mainPanel.ClipsDescendants = true; mainPanel.Parent = body
Instance.new("UICorner", mainPanel).CornerRadius = UDim.new(0, 14)
local mk = Instance.new("UIStroke", mainPanel)
mk.Color = RED_STROKE; mk.Thickness = 1.5; mk.Transparency = 0.3

local pageContainer = Instance.new("Frame")
pageContainer.Size = UDim2.new(1, 0, 1, 0)
pageContainer.BackgroundTransparency = 1
pageContainer.ClipsDescendants = true
pageContainer.Parent = mainPanel

-- ===================== HELPERS =====================
local tabs = {}

local function createPage()
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1; page.BorderSizePixel = 0
    page.ScrollBarThickness = 4; page.ScrollBarImageColor3 = RED_BRIGHT
    page.Visible = false; page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Parent = pageContainer
    return page
end

local function createTabButton(name, order)
    tabs[name] = tabs[name] or { active = false }
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40); btn.BackgroundTransparency = 1
    btn.Text = ""; btn.LayoutOrder = order; btn.Parent = sidebar

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 8, 0, 8); dot.Position = UDim2.new(0, 8, 0.5, -4)
    dot.BackgroundColor3 = TXT_DIM; dot.Parent = btn
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -28, 1, 0); lbl.Position = UDim2.new(0, 24, 0, 0)
    lbl.BackgroundTransparency = 1; lbl.Text = name
    lbl.TextColor3 = TXT_DIM; lbl.TextSize = 14
    lbl.Font = Enum.Font.Gotham; lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = btn

    tabs[name].dot = dot; tabs[name].lbl = lbl

    btn.MouseEnter:Connect(function()
        if not tabs[name].active then TweenService:Create(lbl, TweenInfo.new(0.12), { TextColor3 = TXT_MAIN }):Play() end
    end)
    btn.MouseLeave:Connect(function()
        if not tabs[name].active then TweenService:Create(lbl, TweenInfo.new(0.12), { TextColor3 = TXT_DIM }):Play() end
    end)
    return btn
end

local function switchTab(tabName)
    for name, data in pairs(tabs) do
        data.active = (name == tabName)
        if data.page then data.page.Visible = data.active end
        if data.dot then
            TweenService:Create(data.dot, TweenInfo.new(0.18), { BackgroundColor3 = data.active and RED_GLOW or TXT_DIM }):Play()
        end
        if data.lbl then
            TweenService:Create(data.lbl, TweenInfo.new(0.18), { TextColor3 = data.active and TXT_MAIN or TXT_DIM }):Play()
        end
    end
end

local function sectionHeader(parent, text, posY)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -24, 0, 20); lbl.Position = UDim2.new(0, 12, 0, posY)
    lbl.BackgroundTransparency = 1; lbl.Text = text
    lbl.TextColor3 = TXT_LABEL; lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamBold; lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = parent
end

local function makeCard(parent, posY, h, bg)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -24, 0, h); card.Position = UDim2.new(0, 12, 0, posY)
    card.BackgroundColor3 = bg or BG_CARD; card.Parent = parent
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)
    local s = Instance.new("UIStroke", card)
    s.Color = RED_STROKE; s.Thickness = 1; s.Transparency = 0.5
    return card
end

local function halfBtn(parent, text, col, row)
    local PAD, GAP = 12, 8
    local btnW = (MAIN_W - PAD * 2 - GAP) / 2
    local btnH = 46
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, btnW, 0, btnH)
    btn.Position = UDim2.new(0, PAD + col * (btnW + GAP), 0, 134 + row * (btnH + 6))
    btn.BackgroundColor3 = BG_CARD; btn.Text = ""; btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", btn); s.Color = RED_STROKE; s.Thickness = 1; s.Transparency = 0.5
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 9, 0, 9); dot.Position = UDim2.new(0, 12, 0.5, -4)
    dot.BackgroundColor3 = RED_GLOW; dot.Parent = btn
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -30, 1, 0); lbl.Position = UDim2.new(0, 28, 0, 0)
    lbl.BackgroundTransparency = 1; lbl.Text = text
    lbl.TextColor3 = TXT_MAIN; lbl.TextSize = 13
    lbl.Font = Enum.Font.Gotham; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = btn
    btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = RED_VIVID }):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = BG_CARD }):Play() end)
    return btn
end

-- ===================== HOME TAB =====================
local homeTabBtn = createTabButton("Home", 1)
local homePage = createPage()
tabs["Home"].page = homePage

local welcomeCard = makeCard(homePage, 12, 72, Color3.fromRGB(90, 0, 0))
welcomeCard.Size = UDim2.new(1, -24, 0, 72)

local welcomeTitle = Instance.new("TextLabel")
welcomeTitle.Size = UDim2.new(1, -20, 0, 34); welcomeTitle.Position = UDim2.new(0, 14, 0, 8)
welcomeTitle.BackgroundTransparency = 1
welcomeTitle.Text = "Welcome, " .. player.Name .. " 👋"
welcomeTitle.TextColor3 = TXT_WHITE; welcomeTitle.TextSize = 20
welcomeTitle.Font = Enum.Font.GothamBold; welcomeTitle.TextXAlignment = Enum.TextXAlignment.Left
welcomeTitle.Parent = welcomeCard

local welcomeSub = Instance.new("TextLabel")
welcomeSub.Size = UDim2.new(1, -20, 0, 22); welcomeSub.Position = UDim2.new(0, 14, 0, 42)
welcomeSub.BackgroundTransparency = 1; welcomeSub.Text = "Soul's V1 is loaded and ready. Stay safe."
welcomeSub.TextColor3 = TXT_DIM; welcomeSub.TextSize = 13
welcomeSub.Font = Enum.Font.Gotham; welcomeSub.TextXAlignment = Enum.TextXAlignment.Left
welcomeSub.Parent = welcomeCard

local INFO_Y, INFO_H = 96, 58
local iCW = math.floor((MAIN_W - 24 - 16) / 3)

local function infoCard(label, value, col, valColor)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0, iCW, 0, INFO_H)
    card.Position = UDim2.new(0, 12 + col * (iCW + 8), 0, INFO_Y)
    card.BackgroundColor3 = BG_CARD; card.Parent = homePage
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    local cs = Instance.new("UIStroke", card); cs.Color = RED_STROKE; cs.Thickness = 1; cs.Transparency = 0.5
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -10, 0, 18); lbl.Position = UDim2.new(0, 10, 0, 8)
    lbl.BackgroundTransparency = 1; lbl.Text = label
    lbl.TextColor3 = TXT_DIM; lbl.TextSize = 11
    lbl.Font = Enum.Font.Gotham; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = card
    local val = Instance.new("TextLabel")
    val.Size = UDim2.new(1, -10, 0, 26); val.Position = UDim2.new(0, 10, 0, 26)
    val.BackgroundTransparency = 1; val.Text = value
    val.TextColor3 = valColor or TXT_WHITE; val.TextSize = 16
    val.Font = Enum.Font.GothamBold; val.TextXAlignment = Enum.TextXAlignment.Left; val.Parent = card
    return val
end

infoCard("Version",  "v1",       0)
infoCard("Status",   "● Loaded", 1, GREEN_LOADED)
infoCard("Executor", "Xeno",     2)

sectionHeader(homePage, "CHANGELOG", 166)
local clCard = makeCard(homePage, 190, 86, BG_CARD)

local function clLabel(text, posY, size, color, font)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -16, 0, size); l.Position = UDim2.new(0, 12, 0, posY)
    l.BackgroundTransparency = 1; l.Text = text; l.TextColor3 = color
    l.TextSize = size == 18 and 12 or (size == 22 and 15 or 12)
    l.Font = font or Enum.Font.Gotham; l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextWrapped = true; l.Parent = clCard
end
clLabel("v1",             8,  18, RED_GLOW,  Enum.Font.GothamBold)
clLabel("Initial Release",26, 22, TXT_WHITE, Enum.Font.GothamBold)
clLabel("Welcome to my script! We have TP, fly and many more coming soon. This is a beta version — make sure to give me suggestions! My Discord is soulownsu", 50, 28, TXT_DIM, Enum.Font.Gotham)

homeTabBtn.MouseButton1Click:Connect(function() switchTab("Home") end)

-- ===================== PLAYER TAB =====================
local playerTabBtn = createTabButton("Player", 2)
local playerPage = createPage()
tabs["Player"].page = playerPage

sectionHeader(playerPage, "TARGET", 10)
local searchCard = makeCard(playerPage, 32, 64, BG_CARD)

local avatarBox = Instance.new("Frame")
avatarBox.Size = UDim2.new(0, 44, 0, 44); avatarBox.Position = UDim2.new(0, 10, 0.5, -22)
avatarBox.BackgroundColor3 = Color3.fromRGB(90, 0, 0); avatarBox.Parent = searchCard
Instance.new("UICorner", avatarBox).CornerRadius = UDim.new(0, 8)

local avatarIcon = Instance.new("TextLabel")
avatarIcon.Size = UDim2.new(1, 0, 1, 0); avatarIcon.BackgroundTransparency = 1
avatarIcon.Text = "👤"; avatarIcon.TextSize = 22
avatarIcon.Font = Enum.Font.Gotham; avatarIcon.Parent = avatarBox

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -68, 0, 26); searchBox.Position = UDim2.new(0, 62, 0, 8)
searchBox.BackgroundTransparency = 1; searchBox.PlaceholderText = "Enter player name..."
searchBox.PlaceholderColor3 = TXT_DIM; searchBox.Text = ""
searchBox.TextColor3 = TXT_MAIN; searchBox.TextSize = 14
searchBox.Font = Enum.Font.Gotham; searchBox.TextXAlignment = Enum.TextXAlignment.Left
searchBox.ClearTextOnFocus = false; searchBox.Parent = searchCard

local resultLabel = Instance.new("TextLabel")
resultLabel.Size = UDim2.new(1, -68, 0, 20); resultLabel.Position = UDim2.new(0, 62, 0, 38)
resultLabel.BackgroundTransparency = 1; resultLabel.Text = "No target selected"
resultLabel.TextColor3 = TXT_DIM; resultLabel.TextSize = 12
resultLabel.Font = Enum.Font.Gotham; resultLabel.TextXAlignment = Enum.TextXAlignment.Left
resultLabel.Parent = searchCard

local selectedTarget = nil
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local q = searchBox.Text:lower()
    selectedTarget = nil; resultLabel.TextColor3 = TXT_DIM; resultLabel.Text = "No target selected"
    if q ~= "" then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and (p.Name:lower():find(q, 1, true) or p.DisplayName:lower():find(q, 1, true)) then
                selectedTarget = p
                resultLabel.Text = p.Name .. " (" .. p.DisplayName .. ")"
                resultLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
                break
            end
        end
    end
end)

sectionHeader(playerPage, "TARGET ACTIONS", 106)

local viewBtn     = halfBtn(playerPage, "View Target",            0, 0)
local teleBtn     = halfBtn(playerPage, "Teleport to Target",     1, 0)
local bringBtn    = halfBtn(playerPage, "Bring Target to You",    0, 1)
local focusBtn    = halfBtn(playerPage, "Focus Target (Loop TP)", 1, 1)
local sitBtn      = halfBtn(playerPage, "Sit on Head",            0, 2)
local backpackBtn = halfBtn(playerPage, "Backpack Mode",          1, 2)
local clearBtn    = halfBtn(playerPage, "Clear Target",           0, 3)
local unviewBtn   = halfBtn(playerPage, "Unview",                 1, 3)

viewBtn.MouseButton1Click:Connect(function()
    if selectedTarget then
        startViewing(selectedTarget); resultLabel.Text = "Viewing: " .. selectedTarget.Name; resultLabel.TextColor3 = RED_GLOW
    else resultLabel.Text = "No valid player selected!"; resultLabel.TextColor3 = Color3.fromRGB(255, 80, 50) end
end)
unviewBtn.MouseButton1Click:Connect(function() stopViewing(); resultLabel.Text = "Camera restored."; resultLabel.TextColor3 = TXT_DIM end)
clearBtn.MouseButton1Click:Connect(function()
    stopViewing(); selectedTarget = nil; searchBox.Text = ""
    resultLabel.Text = "No target selected"; resultLabel.TextColor3 = TXT_DIM
end)

-- Teleport TO target
teleBtn.MouseButton1Click:Connect(function()
    if selectedTarget and selectedTarget.Character then
        local r = selectedTarget.Character:FindFirstChild("HumanoidRootPart")
        local m = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if r and m then
            m.CFrame = r.CFrame * CFrame.new(0, 0, -3)
            resultLabel.Text = "Teleported to " .. selectedTarget.Name
            resultLabel.TextColor3 = GREEN_LOADED
        end
    else resultLabel.Text = "No target selected!"; resultLabel.TextColor3 = Color3.fromRGB(255, 80, 50) end
end)

bringBtn.MouseButton1Click:Connect(function()
    if selectedTarget and selectedTarget.Character then
        local r = selectedTarget.Character:FindFirstChild("HumanoidRootPart")
        local m = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if r and m then r.CFrame = m.CFrame * CFrame.new(0, 0, -3) end
    end
end)

-- Sit on Head — toggle: Heartbeat CFrame lock (replicates to all clients)
local headFollowConn = nil
local sittingOnHead = false
sitBtn.MouseButton1Click:Connect(function()
    if sittingOnHead then
        -- Detach
        if headFollowConn then headFollowConn:Disconnect(); headFollowConn = nil end
        sittingOnHead = false
        local myHum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if myHum then myHum.Sit = false end
        resultLabel.Text = "Got off head"; resultLabel.TextColor3 = TXT_DIM
        return
    end

    if not selectedTarget or not selectedTarget.Character then
        resultLabel.Text = "No target selected!"; resultLabel.TextColor3 = Color3.fromRGB(255, 80, 50); return
    end

    sittingOnHead = true
    resultLabel.Text = "Sitting on " .. selectedTarget.Name .. "'s head"
    resultLabel.TextColor3 = GREEN_LOADED

    headFollowConn = RunService.Heartbeat:Connect(function()
        if not sittingOnHead then headFollowConn:Disconnect(); headFollowConn = nil; return end
        local myChar    = player.Character
        local myRoot    = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local myHum     = myChar and myChar:FindFirstChildOfClass("Humanoid")
        local tChar     = selectedTarget and selectedTarget.Character
        local tHead     = tChar and tChar:FindFirstChild("Head")
        if not myRoot or not tHead then
            if headFollowConn then headFollowConn:Disconnect(); headFollowConn = nil end
            sittingOnHead = false; return
        end
        if myHum then myHum.Sit = true end
        -- Sit directly on top of the head, matching their orientation
        myRoot.CFrame = tHead.CFrame * CFrame.new(0, tHead.Size.Y + 0.8, 0)
    end)
end)

-- Backpack Mode — toggle: Heartbeat CFrame lock on their back (replicates to all clients)
local backpackFollowConn = nil
local inBackpackMode = false
backpackBtn.MouseButton1Click:Connect(function()
    if inBackpackMode then
        -- Detach
        if backpackFollowConn then backpackFollowConn:Disconnect(); backpackFollowConn = nil end
        inBackpackMode = false
        local myHum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if myHum then myHum.Sit = false end
        resultLabel.Text = "Left backpack mode"; resultLabel.TextColor3 = TXT_DIM
        return
    end

    if not selectedTarget or not selectedTarget.Character then
        resultLabel.Text = "No target selected!"; resultLabel.TextColor3 = Color3.fromRGB(255, 80, 50); return
    end

    inBackpackMode = true
    resultLabel.Text = "Backpacking " .. selectedTarget.Name
    resultLabel.TextColor3 = GREEN_LOADED

    backpackFollowConn = RunService.Heartbeat:Connect(function()
        if not inBackpackMode then backpackFollowConn:Disconnect(); backpackFollowConn = nil; return end
        local myChar    = player.Character
        local myRoot    = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local myHum     = myChar and myChar:FindFirstChildOfClass("Humanoid")
        local tChar     = selectedTarget and selectedTarget.Character
        local tRoot     = tChar and tChar:FindFirstChild("HumanoidRootPart")
        if not myRoot or not tRoot then
            if backpackFollowConn then backpackFollowConn:Disconnect(); backpackFollowConn = nil end
            inBackpackMode = false; return
        end
        if myHum then myHum.Sit = true end
        -- Sit on their BACK: positive Z = behind them in local space, slightly up
        myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 1.0, 1.6)
    end)
end)

-- Face Bang — row 4 of the grid (below unview/clear)
local faceBangEnabled = false
local faceBangBtn = halfBtn(playerPage, "Face Bang", 0, 4)
faceBangBtn.MouseButton1Click:Connect(function()
    faceBangEnabled = not faceBangEnabled
    if faceBangEnabled then
        -- Find dot inside the button and turn green
        local dot = faceBangBtn:FindFirstChildWhichIsA("Frame")
        if dot then TweenService:Create(dot, TweenInfo.new(0.15), { BackgroundColor3 = GREEN_LOADED }):Play() end
        resultLabel.Text = "Face Bang active!"; resultLabel.TextColor3 = GREEN_LOADED
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/nomercy0000/face-fuck/refs/heads/main/mic%20up"))()
        end)
    else
        local dot = faceBangBtn:FindFirstChildWhichIsA("Frame")
        if dot then TweenService:Create(dot, TweenInfo.new(0.15), { BackgroundColor3 = RED_GLOW }):Play() end
        resultLabel.Text = "Face Bang disabled"; resultLabel.TextColor3 = TXT_DIM
        -- Clean up any GUI left by the script
        for _, g in ipairs(player.PlayerGui:GetChildren()) do
            if g.Name:lower():find("face") or g.Name:lower():find("mic") then
                pcall(function() g:Destroy() end)
            end
        end
    end
end)

playerTabBtn.MouseButton1Click:Connect(function() switchTab("Player") end)

-- ===================== ANIMATIONS TAB =====================
local animTabBtn = createTabButton("Animations", 3)
local animPage   = createPage()
tabs["Animations"].page = animPage

sectionHeader(animPage, "ANIMATIONS", 10)

-- Reanim button
local reanimBtn = Instance.new("TextButton")
reanimBtn.Size = UDim2.new(1, -24, 0, 48)
reanimBtn.Position = UDim2.new(0, 12, 0, 34)
reanimBtn.BackgroundColor3 = BG_CARD
reanimBtn.Text = ""
reanimBtn.Parent = animPage
Instance.new("UICorner", reanimBtn).CornerRadius = UDim.new(0, 10)
local reanimStroke = Instance.new("UIStroke", reanimBtn)
reanimStroke.Color = RED_STROKE; reanimStroke.Thickness = 1.5; reanimStroke.Transparency = 0.4

local reanimDot = Instance.new("Frame")
reanimDot.Size = UDim2.new(0, 10, 0, 10); reanimDot.Position = UDim2.new(0, 14, 0.5, -5)
reanimDot.BackgroundColor3 = RED_GLOW; reanimDot.Parent = reanimBtn
Instance.new("UICorner", reanimDot).CornerRadius = UDim.new(1, 0)

local reanimLbl = Instance.new("TextLabel")
reanimLbl.Size = UDim2.new(1, -36, 1, 0); reanimLbl.Position = UDim2.new(0, 32, 0, 0)
reanimLbl.BackgroundTransparency = 1; reanimLbl.Text = "Reanim (WIP)"
reanimLbl.TextColor3 = TXT_WHITE; reanimLbl.TextSize = 15
reanimLbl.Font = Enum.Font.GothamBold; reanimLbl.TextXAlignment = Enum.TextXAlignment.Left
reanimLbl.Parent = reanimBtn

local reanimSubLbl = Instance.new("TextLabel")
reanimSubLbl.Size = UDim2.new(1, -36, 0, 16); reanimSubLbl.Position = UDim2.new(0, 32, 1, -18)
reanimSubLbl.BackgroundTransparency = 1; reanimSubLbl.Text = "Load full animation replacer"
reanimSubLbl.TextColor3 = TXT_DIM; reanimSubLbl.TextSize = 11
reanimSubLbl.Font = Enum.Font.Gotham; reanimSubLbl.TextXAlignment = Enum.TextXAlignment.Left
reanimSubLbl.Parent = reanimBtn

reanimBtn.MouseEnter:Connect(function()
    TweenService:Create(reanimBtn, TweenInfo.new(0.12), { BackgroundColor3 = RED_BRIGHT }):Play()
    TweenService:Create(reanimDot, TweenInfo.new(0.12), { BackgroundColor3 = GREEN_LOADED }):Play()
end)
reanimBtn.MouseLeave:Connect(function()
    TweenService:Create(reanimBtn, TweenInfo.new(0.12), { BackgroundColor3 = BG_CARD }):Play()
    TweenService:Create(reanimDot, TweenInfo.new(0.12), { BackgroundColor3 = RED_GLOW }):Play()
end)
reanimBtn.MouseButton1Click:Connect(function()
    TweenService:Create(reanimDot, TweenInfo.new(0.1), { BackgroundColor3 = GREEN_LOADED }):Play()
    reanimLbl.Text = "Loading Reanim (WIP)..."
    reanimLbl.TextColor3 = GREEN_LOADED
    task.spawn(function()
        pcall(function()
            loadstring(game:HttpGet("https://pastebin.com/raw/eJwKJb9j"))()
        end)
        reanimLbl.Text = "Reanim (WIP)"
        reanimLbl.TextColor3 = TXT_WHITE
        TweenService:Create(reanimDot, TweenInfo.new(0.2), { BackgroundColor3 = RED_GLOW }):Play()
    end)
end)

-- Emotes button
local emotesBtn = Instance.new("TextButton")
emotesBtn.Size = UDim2.new(1, -24, 0, 48)
emotesBtn.Position = UDim2.new(0, 12, 0, 96)
emotesBtn.BackgroundColor3 = BG_CARD; emotesBtn.Text = ""; emotesBtn.Parent = animPage
Instance.new("UICorner", emotesBtn).CornerRadius = UDim.new(0, 10)
local emotesStroke = Instance.new("UIStroke", emotesBtn)
emotesStroke.Color = RED_STROKE; emotesStroke.Thickness = 1.5; emotesStroke.Transparency = 0.4

local emotesDot = Instance.new("Frame")
emotesDot.Size = UDim2.new(0, 10, 0, 10); emotesDot.Position = UDim2.new(0, 14, 0.5, -5)
emotesDot.BackgroundColor3 = RED_GLOW; emotesDot.Parent = emotesBtn
Instance.new("UICorner", emotesDot).CornerRadius = UDim.new(1, 0)

local emotesLbl = Instance.new("TextLabel")
emotesLbl.Size = UDim2.new(1, -36, 1, 0); emotesLbl.Position = UDim2.new(0, 32, 0, 0)
emotesLbl.BackgroundTransparency = 1; emotesLbl.Text = "Emotes"
emotesLbl.TextColor3 = TXT_WHITE; emotesLbl.TextSize = 15
emotesLbl.Font = Enum.Font.GothamBold; emotesLbl.TextXAlignment = Enum.TextXAlignment.Left
emotesLbl.Parent = emotesBtn

local emotesSubLbl = Instance.new("TextLabel")
emotesSubLbl.Size = UDim2.new(1, -36, 0, 16); emotesSubLbl.Position = UDim2.new(0, 32, 1, -18)
emotesSubLbl.BackgroundTransparency = 1; emotesSubLbl.Text = "Load full emote menu"
emotesSubLbl.TextColor3 = TXT_DIM; emotesSubLbl.TextSize = 11
emotesSubLbl.Font = Enum.Font.Gotham; emotesSubLbl.TextXAlignment = Enum.TextXAlignment.Left
emotesSubLbl.Parent = emotesBtn

emotesBtn.MouseEnter:Connect(function()
    TweenService:Create(emotesBtn, TweenInfo.new(0.12), { BackgroundColor3 = RED_BRIGHT }):Play()
    TweenService:Create(emotesDot, TweenInfo.new(0.12), { BackgroundColor3 = GREEN_LOADED }):Play()
end)
emotesBtn.MouseLeave:Connect(function()
    TweenService:Create(emotesBtn, TweenInfo.new(0.12), { BackgroundColor3 = BG_CARD }):Play()
    TweenService:Create(emotesDot, TweenInfo.new(0.12), { BackgroundColor3 = RED_GLOW }):Play()
end)
emotesBtn.MouseButton1Click:Connect(function()
    TweenService:Create(emotesDot, TweenInfo.new(0.1), { BackgroundColor3 = GREEN_LOADED }):Play()
    emotesLbl.Text = "Loading Emotes..."
    emotesLbl.TextColor3 = GREEN_LOADED
    task.spawn(function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/7yd7/Hub/refs/heads/Branch/GUIS/Emotes.lua"))()
        end)
        emotesLbl.Text = "Emotes"
        emotesLbl.TextColor3 = TXT_WHITE
        TweenService:Create(emotesDot, TweenInfo.new(0.2), { BackgroundColor3 = RED_GLOW }):Play()
    end)
end)

animTabBtn.MouseButton1Click:Connect(function() switchTab("Animations") end)

-- ===================== NOTIFICATION SYSTEM =====================
local notifGui = Instance.new("ScreenGui")
notifGui.Name = "SoulNotifs"; notifGui.ResetOnSpawn = false
notifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
notifGui.DisplayOrder = 998; notifGui.Parent = gui

local notifStack = {}  -- active notification frames
local NOTIF_GAP = 8

local bellSound = Instance.new("Sound")
bellSound.SoundId = "rbxassetid://9120386954"  -- verified bell ding sound
bellSound.Volume = 1
bellSound.RollOffMaxDistance = 0
bellSound.Parent = player.PlayerGui  -- parent to PlayerGui so it always plays

local function showNotif(label, isOn)
    -- Play bell
    bellSound:Play()

    -- Shift existing notifs up
    for _, n in ipairs(notifStack) do
        local cur = n.Position
        TweenService:Create(n, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            { Position = UDim2.new(cur.X.Scale, cur.X.Offset, cur.Y.Scale, cur.Y.Offset - 58) }):Play()
    end

    local nf = Instance.new("Frame")
    nf.Size = UDim2.new(0, 0, 0, 46)  -- animates width in
    nf.Position = UDim2.new(0, 16, 1, -66)
    nf.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    nf.BackgroundTransparency = 0.05
    nf.BorderSizePixel = 0
    nf.ClipsDescendants = true
    nf.ZIndex = 50
    nf.Parent = notifGui
    Instance.new("UICorner", nf).CornerRadius = UDim.new(0, 10)
    local ns = Instance.new("UIStroke", nf)
    ns.Color = isOn and GREEN_LOADED or RED_GLOW
    ns.Thickness = 1.5; ns.Transparency = 0.2

    -- Bell icon
    local bell = Instance.new("TextLabel")
    bell.Size = UDim2.new(0, 30, 1, 0); bell.Position = UDim2.new(0, 8, 0, 0)
    bell.BackgroundTransparency = 1; bell.Text = "🔔"
    bell.TextSize = 18; bell.Font = Enum.Font.Gotham; bell.ZIndex = 51
    bell.Parent = nf

    -- Status dot
    local sdot = Instance.new("Frame")
    sdot.Size = UDim2.new(0, 8, 0, 8); sdot.Position = UDim2.new(0, 34, 0.5, -4)
    sdot.BackgroundColor3 = isOn and GREEN_LOADED or RED_GLOW
    sdot.ZIndex = 51; sdot.Parent = nf
    Instance.new("UICorner", sdot).CornerRadius = UDim.new(1, 0)

    -- Main text
    local ntitle = Instance.new("TextLabel")
    ntitle.Size = UDim2.new(1, -50, 0, 24); ntitle.Position = UDim2.new(0, 48, 0, 6)
    ntitle.BackgroundTransparency = 1
    ntitle.Text = isOn and "Activated" or "Deactivated"
    ntitle.TextColor3 = isOn and GREEN_LOADED or RED_GLOW
    ntitle.TextSize = 13; ntitle.Font = Enum.Font.GothamBold
    ntitle.TextXAlignment = Enum.TextXAlignment.Left; ntitle.ZIndex = 51
    ntitle.Parent = nf

    -- Sub text (button name)
    local nsub = Instance.new("TextLabel")
    nsub.Size = UDim2.new(1, -50, 0, 16); nsub.Position = UDim2.new(0, 48, 0, 26)
    nsub.BackgroundTransparency = 1; nsub.Text = label
    nsub.TextColor3 = TXT_DIM; nsub.TextSize = 11; nsub.Font = Enum.Font.Gotham
    nsub.TextXAlignment = Enum.TextXAlignment.Left; nsub.ZIndex = 51
    nsub.Parent = nf

    -- Slide in
    table.insert(notifStack, nf)
    TweenService:Create(nf, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Size = UDim2.new(0, 240, 0, 46) }):Play()

    -- Auto dismiss after 2.5s
    task.delay(2.5, function()
        if not nf.Parent then return end
        TweenService:Create(nf, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
            { Size = UDim2.new(0, 0, 0, 46), BackgroundTransparency = 1 }):Play()
        TweenService:Create(ns, TweenInfo.new(0.25), { Transparency = 1 }):Play()
        task.wait(0.3)
        -- Remove from stack and reposition remaining
        for i, n in ipairs(notifStack) do
            if n == nf then table.remove(notifStack, i); break end
        end
        for i, n in ipairs(notifStack) do
            local targetY = -66 - (i - 1) * 54
            TweenService:Create(n, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                { Position = UDim2.new(0, 16, 1, targetY) }):Play()
        end
        pcall(function() nf:Destroy() end)
    end)
end

-- ===================== HELPER: TOGGLE BUTTON =====================
local function makeToggle(parent, text, posY, onFn, offFn)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -24, 0, 42); row.Position = UDim2.new(0, 12, 0, posY)
    row.BackgroundColor3 = BG_CARD; row.Parent = parent
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
    local rs = Instance.new("UIStroke", row); rs.Color = RED_STROKE; rs.Thickness = 1; rs.Transparency = 0.55

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 9, 0, 9); dot.Position = UDim2.new(0, 12, 0.5, -4)
    dot.BackgroundColor3 = RED_GLOW; dot.Parent = row
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -80, 1, 0); lbl.Position = UDim2.new(0, 28, 0, 0)
    lbl.BackgroundTransparency = 1; lbl.Text = text
    lbl.TextColor3 = TXT_MAIN; lbl.TextSize = 13
    lbl.Font = Enum.Font.Gotham; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = row

    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(0, 46, 0, 22); toggleFrame.Position = UDim2.new(1, -54, 0.5, -11)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(50, 5, 5); toggleFrame.Parent = row
    Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18); knob.Position = UDim2.new(0, 2, 0.5, -9)
    knob.BackgroundColor3 = TXT_DIM; knob.Parent = toggleFrame
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local enabled = false
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundTransparency = 1; btn.Text = ""; btn.Parent = row
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            TweenService:Create(toggleFrame, TweenInfo.new(0.2), { BackgroundColor3 = RED_ACCENT }):Play()
            TweenService:Create(knob, TweenInfo.new(0.2), { Position = UDim2.new(1, -20, 0.5, -9), BackgroundColor3 = TXT_WHITE }):Play()
            TweenService:Create(dot, TweenInfo.new(0.15), { BackgroundColor3 = GREEN_LOADED }):Play()
            showNotif(text, true)
            if onFn then pcall(onFn) end
        else
            TweenService:Create(toggleFrame, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(50, 5, 5) }):Play()
            TweenService:Create(knob, TweenInfo.new(0.2), { Position = UDim2.new(0, 2, 0.5, -9), BackgroundColor3 = TXT_DIM }):Play()
            TweenService:Create(dot, TweenInfo.new(0.15), { BackgroundColor3 = RED_GLOW }):Play()
            showNotif(text, false)
            if offFn then pcall(offFn) end
        end
    end)
    return row, btn
end

-- ===================== COMBAT TAB =====================
local combatTabBtn = createTabButton("Combat", 4)
local combatPage = createPage()
tabs["Combat"].page = combatPage

sectionHeader(combatPage, "COMBAT TOOLS", 10)

local autoClickConn = nil
local autoClickActive = false
local autoClickGui = nil

makeToggle(combatPage, "Auto Click", 32,
    function()
        -- Open autoclicker popup GUI
        if autoClickGui and autoClickGui.Parent then autoClickGui:Destroy() end

        autoClickGui = Instance.new("ScreenGui")
        autoClickGui.Name = "SoulAutoClick"; autoClickGui.ResetOnSpawn = false
        autoClickGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        autoClickGui.DisplayOrder = 30; autoClickGui.Parent = player.PlayerGui

        local acFrame = Instance.new("Frame")
        acFrame.Size = UDim2.new(0, 260, 0, 160); acFrame.Position = UDim2.new(0.5,-130,0.5,-80)
        acFrame.BackgroundColor3 = Color3.fromRGB(18,18,22); acFrame.BorderSizePixel = 0
        acFrame.Parent = autoClickGui
        Instance.new("UICorner", acFrame).CornerRadius = UDim.new(0, 12)
        local acs = Instance.new("UIStroke", acFrame); acs.Color = Color3.fromRGB(139,0,0); acs.Thickness = 1.5

        -- Header
        local acHdr = Instance.new("Frame")
        acHdr.Size = UDim2.new(1,0,0,40); acHdr.BackgroundColor3 = Color3.fromRGB(10,10,14)
        acHdr.BorderSizePixel = 0; acHdr.Parent = acFrame
        Instance.new("UICorner", acHdr).CornerRadius = UDim.new(0,12)

        local acTitle = Instance.new("TextLabel")
        acTitle.Size = UDim2.new(1,-44,1,0); acTitle.Position = UDim2.new(0,14,0,0)
        acTitle.BackgroundTransparency = 1; acTitle.Text = "🖱️  Auto Clicker"
        acTitle.TextColor3 = Color3.new(1,1,1); acTitle.TextSize = 14; acTitle.Font = Enum.Font.GothamBold
        acTitle.TextXAlignment = Enum.TextXAlignment.Left; acTitle.Parent = acHdr

        local acClose = Instance.new("TextButton")
        acClose.Size = UDim2.new(0,26,0,26); acClose.Position = UDim2.new(1,-32,0.5,-13)
        acClose.BackgroundColor3 = Color3.fromRGB(80,0,0); acClose.Text = "✕"
        acClose.TextColor3 = Color3.new(1,1,1); acClose.TextSize = 13; acClose.Font = Enum.Font.GothamBold
        acClose.Parent = acHdr
        Instance.new("UICorner", acClose).CornerRadius = UDim.new(0,6)
        acClose.MouseButton1Click:Connect(function()
            if autoClickConn then autoClickConn:Disconnect(); autoClickConn = nil end
            autoClickActive = false; autoClickGui:Destroy()
        end)

        -- Status label
        local acStatus = Instance.new("TextLabel")
        acStatus.Size = UDim2.new(1,-24,0,22); acStatus.Position = UDim2.new(0,12,0,50)
        acStatus.BackgroundTransparency = 1; acStatus.Text = "Status: Inactive"
        acStatus.TextColor3 = Color3.fromRGB(160,70,70); acStatus.TextSize = 13
        acStatus.Font = Enum.Font.Gotham; acStatus.TextXAlignment = Enum.TextXAlignment.Center
        acStatus.Parent = acFrame

        -- Activate / Deactivate button
        local acBtn = Instance.new("TextButton")
        acBtn.Size = UDim2.new(1,-24,0,42); acBtn.Position = UDim2.new(0,12,0,80)
        acBtn.BackgroundColor3 = Color3.fromRGB(34,160,60); acBtn.Text = "Activate"
        acBtn.TextColor3 = Color3.new(1,1,1); acBtn.TextSize = 15; acBtn.Font = Enum.Font.GothamBold
        acBtn.Parent = acFrame
        Instance.new("UICorner", acBtn).CornerRadius = UDim.new(0,8)

        acBtn.MouseButton1Click:Connect(function()
            autoClickActive = not autoClickActive
            if autoClickActive then
                acBtn.Text = "Deactivate"
                acBtn.BackgroundColor3 = Color3.fromRGB(139,0,0)
                acStatus.Text = "Status: ● Active"
                acStatus.TextColor3 = Color3.fromRGB(80,220,100)
                autoClickConn = RunService.Heartbeat:Connect(function()
                    local VirtualUser = game:GetService("VirtualUser")
                    pcall(function()
                        VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                        VirtualUser:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    end)
                    local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
                    if tool then pcall(function() tool:Activate() end) end
                end)
            else
                acBtn.Text = "Activate"
                acBtn.BackgroundColor3 = Color3.fromRGB(34,160,60)
                acStatus.Text = "Status: Inactive"
                acStatus.TextColor3 = Color3.fromRGB(160,70,70)
                if autoClickConn then autoClickConn:Disconnect(); autoClickConn = nil end
            end
        end)

        -- Draggable
        local acd, acds, acdp = false, nil, nil
        acHdr.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                acd = true; acds = inp.Position; acdp = acFrame.Position
                inp.Changed:Connect(function() if inp.UserInputState == Enum.UserInputState.End then acd = false end end)
            end
        end)
        UserInputService.InputChanged:Connect(function(inp)
            if acd and inp.UserInputType == Enum.UserInputType.MouseMovement then
                local d = inp.Position - acds
                acFrame.Position = UDim2.new(acdp.X.Scale, acdp.X.Offset+d.X, acdp.Y.Scale, acdp.Y.Offset+d.Y)
            end
        end)
    end,
    function()
        if autoClickConn then autoClickConn:Disconnect(); autoClickConn = nil end
        autoClickActive = false
        if autoClickGui and autoClickGui.Parent then autoClickGui:Destroy() end
    end
)

makeToggle(combatPage, "Infinite Jump", 82,
    function()
        UserInputService.JumpRequest:Connect(function()
            local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    end, nil
)

makeToggle(combatPage, "No Clip", 132,
    function()
        RunService.Stepped:Connect(function()
            local char = player.Character
            if char then
                for _, p in pairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end)
    end, nil
)

-- ── HITBOX EXPANDER ──────────────────────────────────────────
sectionHeader(combatPage, "HITBOX", 184)

local hitboxSelections = {}
makeToggle(combatPage, "Hitbox Expander", 206,
    function()
        local function addHitbox(p)
            if p == player then return end
            local function onChar(char)
                task.spawn(function()
                    local root = char:WaitForChild("HumanoidRootPart", 5)
                    if not root then return end
                    -- Use SelectionBox for a clean outline with no resizing
                    local sel = Instance.new("SelectionBox")
                    sel.Adornee        = root
                    sel.Color3         = Color3.fromRGB(255, 30, 30)
                    sel.LineThickness  = 0.08
                    sel.SurfaceTransparency = 0.85
                    sel.SurfaceColor3  = Color3.fromRGB(255, 30, 30)
                    sel.Parent         = workspace
                    hitboxSelections[root] = sel
                end)
            end
            if p.Character then onChar(p.Character) end
            p.CharacterAdded:Connect(onChar)
        end
        for _, p in ipairs(Players:GetPlayers()) do addHitbox(p) end
        Players.PlayerAdded:Connect(addHitbox)
    end,
    function()
        for _, sel in pairs(hitboxSelections) do
            pcall(function() sel:Destroy() end)
        end
        hitboxSelections = {}
    end
)

-- ── AIMLOCK ───────────────────────────────────────────────────
sectionHeader(combatPage, "AIMLOCK", 258)

local aimGuiOpen = false
makeToggle(combatPage, "Aimlock", 280,
    function()
        aimGuiOpen = true
        -- Remove existing if re-toggled
        local existing = player.PlayerGui:FindFirstChild("AimGUI")
        if existing then existing:Destroy() end

        local Players2 = game:GetService("Players")
        local UIS2 = game:GetService("UserInputService")
        local RS2 = game:GetService("RunService")
        local TS2 = game:GetService("TweenService")
        local GuiService2 = game:GetService("GuiService")
        local WS2 = game:GetService("Workspace")
        local LP = Players2.LocalPlayer
        local Mouse2 = LP:GetMouse()
        local Cam2 = WS2.CurrentCamera

        local AIM_PART = "Head"
        local TEAM_CHECK = true
        local WALL_CHECK = true
        local FOV_RADIUS = 350
        local AIMLOCK_SMOOTH = 0.15
        local AimlockEnabled = false
        local SilentEnabled = false

        local fovCircle = Drawing.new("Circle")
        fovCircle.Thickness = 2
        fovCircle.NumSides = 100
        fovCircle.Radius = FOV_RADIUS
        fovCircle.Filled = false
        fovCircle.Transparency = 0.65
        fovCircle.Visible = false

        local aimGui = Instance.new("ScreenGui")
        aimGui.Name = "AimGUI"
        aimGui.ResetOnSpawn = false
        aimGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        aimGui.DisplayOrder = 25
        aimGui.Parent = player.PlayerGui

        local mainFrame = Instance.new("Frame")
        mainFrame.Size = UDim2.new(0, 320, 0, 380)
        mainFrame.Position = UDim2.new(0.5, -160, 1.2, 0)
        mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        mainFrame.BorderSizePixel = 0
        mainFrame.ClipsDescendants = true
        mainFrame.Parent = aimGui
        Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 14)
        local mStroke = Instance.new("UIStroke", mainFrame)
        mStroke.Color = Color3.fromRGB(139, 0, 0); mStroke.Thickness = 2; mStroke.Transparency = 0.3

        local titleBar = Instance.new("Frame")
        titleBar.Size = UDim2.new(1, 0, 0, 40)
        titleBar.BackgroundColor3 = Color3.fromRGB(35, 5, 5)
        titleBar.BorderSizePixel = 0; titleBar.Parent = mainFrame

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -50, 1, 0); titleLabel.Position = UDim2.new(0, 15, 0, 0)
        titleLabel.BackgroundTransparency = 1; titleLabel.Text = "🎯  Soul's Aim Control"
        titleLabel.TextColor3 = Color3.new(1, 1, 1); titleLabel.TextSize = 16
        titleLabel.Font = Enum.Font.GothamBold; titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = titleBar

        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, 28, 0, 28); closeBtn.Position = UDim2.new(1, -34, 0.5, -14)
        closeBtn.BackgroundColor3 = Color3.fromRGB(139, 0, 0); closeBtn.Text = "✕"
        closeBtn.TextColor3 = Color3.new(1,1,1); closeBtn.TextSize = 14; closeBtn.Font = Enum.Font.GothamBold
        closeBtn.Parent = titleBar
        Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
        closeBtn.MouseButton1Click:Connect(function()
            pcall(function() fovCircle:Remove() end)
            aimGui:Destroy()
        end)

        local content = Instance.new("ScrollingFrame")
        content.Size = UDim2.new(1, -20, 1, -50)
        content.Position = UDim2.new(0, 10, 0, 50)
        content.BackgroundTransparency = 1; content.BorderSizePixel = 0
        content.ScrollBarThickness = 4; content.ScrollBarImageColor3 = Color3.fromRGB(139,0,0)
        content.CanvasSize = UDim2.new(0, 0, 0, 500)
        content.Parent = mainFrame

        local function createToggle2(name, posY, default, callback)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.6, 0, 0, 35); lbl.Position = UDim2.new(0, 10, 0, posY)
            lbl.BackgroundTransparency = 1; lbl.Text = name
            lbl.TextColor3 = Color3.fromRGB(220, 180, 180); lbl.TextSize = 14
            lbl.Font = Enum.Font.GothamSemibold; lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = content

            local tog = Instance.new("TextButton")
            tog.Size = UDim2.new(0, 80, 0, 32); tog.Position = UDim2.new(1, -90, 0, posY + 1)
            tog.BackgroundColor3 = default and Color3.fromRGB(50,180,80) or Color3.fromRGB(60,0,0)
            tog.Text = default and "ON" or "OFF"
            tog.TextColor3 = Color3.new(1,1,1); tog.TextSize = 14; tog.Font = Enum.Font.GothamBold
            tog.Parent = content
            Instance.new("UICorner", tog).CornerRadius = UDim.new(0, 8)

            local en = default or false
            tog.MouseButton1Click:Connect(function()
                en = not en
                tog.Text = en and "ON" or "OFF"
                tog.BackgroundColor3 = en and Color3.fromRGB(50,180,80) or Color3.fromRGB(60,0,0)
                callback(en)
            end)
            return tog
        end

        createToggle2("Camera Aimlock (Smooth)", 10, false, function(state)
            AimlockEnabled = state
        end)
        createToggle2("Silent Aim", 55, false, function(state)
            SilentEnabled = state
        end)
        createToggle2("Team Check", 100, true, function(state)
            TEAM_CHECK = state
        end)
        createToggle2("Wall Check", 145, true, function(state)
            WALL_CHECK = state
        end)

        -- FOV slider label
        local fovLbl = Instance.new("TextLabel")
        fovLbl.Size = UDim2.new(1, -20, 0, 26); fovLbl.Position = UDim2.new(0, 10, 0, 198)
        fovLbl.BackgroundTransparency = 1; fovLbl.Text = "FOV Radius: " .. tostring(FOV_RADIUS)
        fovLbl.TextColor3 = Color3.fromRGB(255, 160, 160); fovLbl.TextSize = 13
        fovLbl.Font = Enum.Font.Gotham; fovLbl.TextXAlignment = Enum.TextXAlignment.Left
        fovLbl.Parent = content

        local function makeAdjBtn(text, posX, posY, fn)
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(0, 40, 0, 28); b.Position = UDim2.new(0, posX, 0, posY)
            b.BackgroundColor3 = Color3.fromRGB(80, 0, 0); b.Text = text
            b.TextColor3 = Color3.new(1,1,1); b.TextSize = 16; b.Font = Enum.Font.GothamBold
            b.Parent = content
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
            b.MouseButton1Click:Connect(fn)
        end

        makeAdjBtn("-", 10, 228, function()
            FOV_RADIUS = math.max(50, FOV_RADIUS - 25)
            fovLbl.Text = "FOV Radius: " .. tostring(FOV_RADIUS)
            fovCircle.Radius = FOV_RADIUS
        end)
        makeAdjBtn("+", 60, 228, function()
            FOV_RADIUS = math.min(1000, FOV_RADIUS + 25)
            fovLbl.Text = "FOV Radius: " .. tostring(FOV_RADIUS)
            fovCircle.Radius = FOV_RADIUS
        end)

        local smoothLbl = Instance.new("TextLabel")
        smoothLbl.Size = UDim2.new(1,-20,0,26); smoothLbl.Position = UDim2.new(0,10,0,268)
        smoothLbl.BackgroundTransparency = 1; smoothLbl.Text = "Smoothness: " .. string.format("%.2f", AIMLOCK_SMOOTH)
        smoothLbl.TextColor3 = Color3.fromRGB(255,160,160); smoothLbl.TextSize = 13
        smoothLbl.Font = Enum.Font.Gotham; smoothLbl.TextXAlignment = Enum.TextXAlignment.Left
        smoothLbl.Parent = content

        makeAdjBtn("-", 10, 298, function()
            AIMLOCK_SMOOTH = math.max(0.01, AIMLOCK_SMOOTH - 0.05)
            smoothLbl.Text = "Smoothness: " .. string.format("%.2f", AIMLOCK_SMOOTH)
        end)
        makeAdjBtn("+", 60, 298, function()
            AIMLOCK_SMOOTH = math.min(1, AIMLOCK_SMOOTH + 0.05)
            smoothLbl.Text = "Smoothness: " .. string.format("%.2f", AIMLOCK_SMOOTH)
        end)

        -- Closest player finder
        local function getClosest()
            local closest, minDist = nil, FOV_RADIUS
            for _, plr in ipairs(Players2:GetPlayers()) do
                if plr == LP or not plr.Character then continue end
                if TEAM_CHECK and plr.Team == LP.Team then continue end
                local char = plr.Character
                if not char:FindFirstChild(AIM_PART) then continue end
                local part = char[AIM_PART]
                local vec, onScr = Cam2:WorldToViewportPoint(part.Position)
                if not onScr then continue end
                local dist = (Vector2.new(vec.X, vec.Y) - Vector2.new(Mouse2.X, Mouse2.Y + GuiService2:GetGuiInset().Y)).Magnitude
                if dist >= minDist then continue end
                if WALL_CHECK then
                    local rp = RaycastParams.new()
                    rp.FilterDescendantsInstances = {LP.Character or game}
                    rp.FilterType = Enum.RaycastFilterType.Exclude
                    local res = WS2:Raycast(Cam2.CFrame.Position, (part.Position - Cam2.CFrame.Position).Unit * 1200, rp)
                    if not res or not res.Instance:IsDescendantOf(char) then continue end
                end
                closest = part; minDist = dist
            end
            return closest
        end

        local aimConn = RS2.RenderStepped:Connect(function()
            fovCircle.Position = Vector2.new(Mouse2.X, Mouse2.Y + GuiService2:GetGuiInset().Y)
            if not AimlockEnabled and not SilentEnabled then
                fovCircle.Visible = false; return
            end
            local tgt = getClosest()
            if tgt then
                fovCircle.Visible = true
                fovCircle.Color = SilentEnabled and Color3.fromRGB(60,255,120) or Color3.fromRGB(255,60,60)
                if AimlockEnabled then
                    local goal = CFrame.new(Cam2.CFrame.Position, tgt.Position)
                    Cam2.CFrame = Cam2.CFrame:Lerp(goal, AIMLOCK_SMOOTH)
                end
            else
                fovCircle.Visible = false
            end
        end)

        -- Clean up aimConn when GUI destroyed
        aimGui.AncestryChanged:Connect(function()
            if not aimGui.Parent then
                aimConn:Disconnect()
                pcall(function() fovCircle:Remove() end)
            end
        end)

        -- Drag
        local dragging2, dragStart2, dragPos2 = false, nil, nil
        titleBar.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging2 = true; dragStart2 = inp.Position; dragPos2 = mainFrame.Position
                inp.Changed:Connect(function() if inp.UserInputState == Enum.UserInputState.End then dragging2 = false end end)
            end
        end)
        UserInputService.InputChanged:Connect(function(inp)
            if dragging2 and inp.UserInputType == Enum.UserInputType.MouseMovement then
                local d = inp.Position - dragStart2
                mainFrame.Position = UDim2.new(dragPos2.X.Scale, dragPos2.X.Offset+d.X, dragPos2.Y.Scale, dragPos2.Y.Offset+d.Y)
            end
        end)

        -- Slide in animation
        TS2:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            { Position = UDim2.new(0.5, -160, 0.5, -190) }):Play()
    end,
    function()
        aimGuiOpen = false
        local ag = player.PlayerGui:FindFirstChild("AimGUI")
        if ag then ag:Destroy() end
    end
)

combatTabBtn.MouseButton1Click:Connect(function() switchTab("Combat") end)

-- ===================== VISUAL TAB =====================
local visualTabBtn = createTabButton("Visual", 5)
local visualPage = createPage()
tabs["Visual"].page = visualPage

sectionHeader(visualPage, "VISUAL TOOLS", 10)

local espConn = nil
local espBillboards = {}
makeToggle(visualPage, "Player ESP", 32,
    function()
        local function addESP(p)
            if p == player then return end
            local function onChar(char)
                task.spawn(function()
                    local head = char:WaitForChild("Head", 5)
                    if not head then return end
                    local bb = Instance.new("BillboardGui")
                    bb.Name = "SoulESP"; bb.Size = UDim2.new(0, 100, 0, 30)
                    bb.StudsOffset = Vector3.new(0, 3.5, 0); bb.AlwaysOnTop = true
                    bb.Adornee = head; bb.Parent = head
                    local nl = Instance.new("TextLabel")
                    nl.Size = UDim2.new(1,0,1,0); nl.BackgroundTransparency = 1
                    nl.Text = p.Name; nl.TextColor3 = RED_GLOW
                    nl.TextSize = 13; nl.Font = Enum.Font.GothamBold; nl.Parent = bb
                    table.insert(espBillboards, bb)
                end)
            end
            if p.Character then onChar(p.Character) end
            p.CharacterAdded:Connect(onChar)
        end
        for _, p in ipairs(Players:GetPlayers()) do addESP(p) end
        Players.PlayerAdded:Connect(addESP)
    end,
    function()
        for _, bb in pairs(espBillboards) do pcall(function() bb:Destroy() end) end
        espBillboards = {}
    end
)

makeToggle(visualPage, "Full Bright", 82,
    function()
        local lighting = game:GetService("Lighting")
        lighting.Brightness = 10; lighting.ClockTime = 14
        lighting.FogEnd = 100000; lighting.GlobalShadows = false
    end,
    function()
        local lighting = game:GetService("Lighting")
        lighting.Brightness = 1; lighting.ClockTime = 14
        lighting.FogEnd = 100000; lighting.GlobalShadows = true
    end
)

makeToggle(visualPage, "Hide GUI", 132,
    function() screenGui.Enabled = false end,
    function() screenGui.Enabled = true end
)

-- SAD button — auto types in Roblox chat
local sadBtn = Instance.new("TextButton")
sadBtn.Size = UDim2.new(1, -24, 0, 42); sadBtn.Position = UDim2.new(0, 12, 0, 182)
sadBtn.BackgroundColor3 = BG_CARD; sadBtn.Text = ""; sadBtn.Parent = visualPage
Instance.new("UICorner", sadBtn).CornerRadius = UDim.new(0, 8)
local sadStroke = Instance.new("UIStroke", sadBtn)
sadStroke.Color = RED_STROKE; sadStroke.Thickness = 1; sadStroke.Transparency = 0.55

local sadDot = Instance.new("Frame")
sadDot.Size = UDim2.new(0, 9, 0, 9); sadDot.Position = UDim2.new(0, 12, 0.5, -4)
sadDot.BackgroundColor3 = RED_GLOW; sadDot.Parent = sadBtn
Instance.new("UICorner", sadDot).CornerRadius = UDim.new(1, 0)

local sadLbl = Instance.new("TextLabel")
sadLbl.Size = UDim2.new(1, -30, 1, 0); sadLbl.Position = UDim2.new(0, 28, 0, 0)
sadLbl.BackgroundTransparency = 1; sadLbl.Text = "SAD"
sadLbl.TextColor3 = TXT_MAIN; sadLbl.TextSize = 13
sadLbl.Font = Enum.Font.Gotham; sadLbl.TextXAlignment = Enum.TextXAlignment.Left
sadLbl.Parent = sadBtn

sadBtn.MouseEnter:Connect(function()
    TweenService:Create(sadBtn, TweenInfo.new(0.12), { BackgroundColor3 = RED_BRIGHT }):Play()
    TweenService:Create(sadDot, TweenInfo.new(0.12), { BackgroundColor3 = GREEN_LOADED }):Play()
end)
sadBtn.MouseLeave:Connect(function()
    TweenService:Create(sadBtn, TweenInfo.new(0.12), { BackgroundColor3 = BG_CARD }):Play()
    TweenService:Create(sadDot, TweenInfo.new(0.12), { BackgroundColor3 = RED_GLOW }):Play()
end)

sadBtn.MouseButton1Click:Connect(function()
    showNotif("SAD", true)
    task.spawn(function()
        -- Send first message
        local ok1, err1 = pcall(function()
            game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
                :FindFirstChild("SayMessageRequest"):FireServer("Soul V1 Script  in beta version right now", "All")
        end)
        -- Fallback: use TextChatService (newer games)
        if not ok1 then
            pcall(function()
                local tcs = game:GetService("TextChatService")
                local channel = tcs.TextChannels:FindFirstChild("RBXGeneral")
                    or tcs.TextChannels:FindFirstChildOfClass("TextChannel")
                if channel then channel:SendAsync("Soul V1 Script  in beta version right now") end
            end)
        end

        task.wait(4)

        -- Send second message
        local ok2, err2 = pcall(function()
            game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
                :FindFirstChild("SayMessageRequest"):FireServer("join our comns  QGrXsqqbDc", "All")
        end)
        if not ok2 then
            pcall(function()
                local tcs = game:GetService("TextChatService")
                local channel = tcs.TextChannels:FindFirstChild("RBXGeneral")
                    or tcs.TextChannels:FindFirstChildOfClass("TextChannel")
                if channel then channel:SendAsync("join our comns  QGrXsqqbDc") end
            end)
        end
    end)
end)

visualTabBtn.MouseButton1Click:Connect(function() switchTab("Visual") end)

-- ===================== BOOSTS TAB =====================
local boostsTabBtn = createTabButton("Boosts", 8)
local boostsPage = createPage()
tabs["Boosts"].page = boostsPage

sectionHeader(boostsPage, "PLAYER BOOSTS", 10)

-- Helper: create a floating popup panel
local function makeBoostPopup(title, currentVal, minVal, maxVal, defaultVal, applyFn)
    local bGui = Instance.new("ScreenGui")
    bGui.Name="SoulBoostPopup"; bGui.ResetOnSpawn=false
    bGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    bGui.DisplayOrder=60; bGui.Parent=gui

    local bp = Instance.new("Frame")
    bp.Size=UDim2.new(0,300,0,200); bp.Position=UDim2.new(0.5,-150,0.5,-100)
    bp.BackgroundColor3=Color3.fromRGB(18,18,22); bp.BorderSizePixel=0; bp.Parent=bGui
    Instance.new("UICorner", bp).CornerRadius=UDim.new(0,12)
    local bps=Instance.new("UIStroke",bp); bps.Color=Color3.fromRGB(139,0,0); bps.Thickness=1.5

    local bHeader=Instance.new("Frame")
    bHeader.Size=UDim2.new(1,0,0,42); bHeader.BackgroundColor3=Color3.fromRGB(10,10,14)
    bHeader.BorderSizePixel=0; bHeader.ZIndex=2; bHeader.Parent=bp
    Instance.new("UICorner",bHeader).CornerRadius=UDim.new(0,12)

    local bTitle=Instance.new("TextLabel")
    bTitle.Size=UDim2.new(1,-44,1,0); bTitle.Position=UDim2.new(0,14,0,0)
    bTitle.BackgroundTransparency=1; bTitle.Text=title
    bTitle.TextColor3=TXT_WHITE; bTitle.TextSize=14; bTitle.Font=Enum.Font.GothamBold
    bTitle.TextXAlignment=Enum.TextXAlignment.Left; bTitle.ZIndex=3; bTitle.Parent=bHeader

    local bClose=Instance.new("TextButton")
    bClose.Size=UDim2.new(0,26,0,26); bClose.Position=UDim2.new(1,-32,0.5,-13)
    bClose.BackgroundColor3=Color3.fromRGB(80,0,0); bClose.Text="✕"
    bClose.TextColor3=TXT_WHITE; bClose.TextSize=13; bClose.Font=Enum.Font.GothamBold
    bClose.ZIndex=3; bClose.Parent=bHeader
    Instance.new("UICorner",bClose).CornerRadius=UDim.new(0,6)
    bClose.MouseButton1Click:Connect(function() bGui:Destroy() end)

    -- Current value display
    local valLbl=Instance.new("TextLabel")
    valLbl.Size=UDim2.new(1,-24,0,28); valLbl.Position=UDim2.new(0,12,0,52)
    valLbl.BackgroundTransparency=1; valLbl.Text="Value: "..tostring(currentVal)
    valLbl.TextColor3=TXT_MAIN; valLbl.TextSize=14; valLbl.Font=Enum.Font.GothamBold
    valLbl.TextXAlignment=Enum.TextXAlignment.Center; valLbl.ZIndex=2; valLbl.Parent=bp

    -- Slider bar bg
    local sliderBg=Instance.new("Frame")
    sliderBg.Size=UDim2.new(1,-40,0,10); sliderBg.Position=UDim2.new(0,20,0,90)
    sliderBg.BackgroundColor3=Color3.fromRGB(40,40,50); sliderBg.BorderSizePixel=0; sliderBg.ZIndex=2; sliderBg.Parent=bp
    Instance.new("UICorner",sliderBg).CornerRadius=UDim.new(1,0)

    local sliderFill=Instance.new("Frame")
    local initPct = (currentVal - minVal) / (maxVal - minVal)
    sliderFill.Size=UDim2.new(initPct,0,1,0); sliderFill.BackgroundColor3=RED_GLOW
    sliderFill.BorderSizePixel=0; sliderFill.ZIndex=3; sliderFill.Parent=sliderBg
    Instance.new("UICorner",sliderFill).CornerRadius=UDim.new(1,0)

    local sliderKnob=Instance.new("Frame")
    sliderKnob.Size=UDim2.new(0,18,0,18); sliderKnob.BackgroundColor3=TXT_WHITE
    sliderKnob.Position=UDim2.new(initPct,-9,0.5,-9); sliderKnob.ZIndex=4; sliderKnob.Parent=sliderBg
    Instance.new("UICorner",sliderKnob).CornerRadius=UDim.new(1,0)

    local draggingSlider = false
    sliderKnob.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 then draggingSlider=true end
    end)
    sliderBg.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 then draggingSlider=true end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 then draggingSlider=false end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if draggingSlider and inp.UserInputType==Enum.UserInputType.MouseMovement then
            local sliderAbs = sliderBg.AbsolutePosition
            local sliderW   = sliderBg.AbsoluteSize.X
            local rel = math.clamp((inp.Position.X - sliderAbs.X) / sliderW, 0, 1)
            local val = math.floor(minVal + rel * (maxVal - minVal))
            sliderFill.Size = UDim2.new(rel, 0, 1, 0)
            sliderKnob.Position = UDim2.new(rel, -9, 0.5, -9)
            valLbl.Text = "Value: " .. tostring(val)
            pcall(function() applyFn(val) end)
        end
    end)

    -- Quick preset buttons
    local presets = {
        { "Default", defaultVal },
        { "Fast",    math.floor(maxVal * 0.4) },
        { "Max",     maxVal },
    }
    for i, pr in ipairs(presets) do
        local pb = Instance.new("TextButton")
        pb.Size=UDim2.new(0,80,0,32); pb.Position=UDim2.new(0, 12+(i-1)*90, 0, 118)
        pb.BackgroundColor3=BG_CARD; pb.Text=pr[1]
        pb.TextColor3=TXT_MAIN; pb.TextSize=13; pb.Font=Enum.Font.Gotham
        pb.ZIndex=2; pb.Parent=bp
        Instance.new("UICorner",pb).CornerRadius=UDim.new(0,8)
        local pv = pr[2]
        pb.MouseButton1Click:Connect(function()
            local rel2 = math.clamp((pv-minVal)/(maxVal-minVal),0,1)
            sliderFill.Size=UDim2.new(rel2,0,1,0)
            sliderKnob.Position=UDim2.new(rel2,-9,0.5,-9)
            valLbl.Text="Value: "..tostring(pv)
            pcall(function() applyFn(pv) end)
        end)
        pb.MouseEnter:Connect(function() TweenService:Create(pb,TweenInfo.new(0.12),{BackgroundColor3=RED_BRIGHT}):Play() end)
        pb.MouseLeave:Connect(function() TweenService:Create(pb,TweenInfo.new(0.12),{BackgroundColor3=BG_CARD}):Play() end)
    end

    -- Reset button
    local resetBtn=Instance.new("TextButton")
    resetBtn.Size=UDim2.new(1,-24,0,36); resetBtn.Position=UDim2.new(0,12,0,158)
    resetBtn.BackgroundColor3=Color3.fromRGB(60,0,0); resetBtn.Text="↺  Reset to Default ("..tostring(defaultVal)..")"
    resetBtn.TextColor3=TXT_WHITE; resetBtn.TextSize=13; resetBtn.Font=Enum.Font.GothamSemibold
    resetBtn.ZIndex=2; resetBtn.Parent=bp
    Instance.new("UICorner",resetBtn).CornerRadius=UDim.new(0,8)
    resetBtn.MouseButton1Click:Connect(function()
        local rel3=(defaultVal-minVal)/(maxVal-minVal)
        sliderFill.Size=UDim2.new(rel3,0,1,0)
        sliderKnob.Position=UDim2.new(rel3,-9,0.5,-9)
        valLbl.Text="Value: "..tostring(defaultVal)
        pcall(function() applyFn(defaultVal) end)
    end)
    resetBtn.MouseEnter:Connect(function() TweenService:Create(resetBtn,TweenInfo.new(0.12),{BackgroundColor3=RED_BRIGHT}):Play() end)
    resetBtn.MouseLeave:Connect(function() TweenService:Create(resetBtn,TweenInfo.new(0.12),{BackgroundColor3=BG_CARD}):Play() end)

    -- Draggable
    local bdragging,bdragStart,bdragPos=false,nil,nil
    bHeader.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 then
            bdragging=true; bdragStart=inp.Position; bdragPos=bp.Position
            inp.Changed:Connect(function() if inp.UserInputState==Enum.UserInputState.End then bdragging=false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if bdragging and inp.UserInputType==Enum.UserInputType.MouseMovement then
            local d=inp.Position-bdragStart
            bp.Position=UDim2.new(bdragPos.X.Scale,bdragPos.X.Offset+d.X,bdragPos.Y.Scale,bdragPos.Y.Offset+d.Y)
        end
    end)
end

-- Speed button
local speedPopup = nil
local speedBtn = Instance.new("TextButton")
speedBtn.Size=UDim2.new(0.5,-16,0,42); speedBtn.Position=UDim2.new(0,12,0,32)
speedBtn.BackgroundColor3=BG_CARD; speedBtn.Text=""; speedBtn.Parent=boostsPage
Instance.new("UICorner",speedBtn).CornerRadius=UDim.new(0,8)
local sss=Instance.new("UIStroke",speedBtn); sss.Color=RED_STROKE; sss.Thickness=1; sss.Transparency=0.55
local speedDot=Instance.new("Frame"); speedDot.Size=UDim2.new(0,9,0,9); speedDot.Position=UDim2.new(0,10,0.5,-4)
speedDot.BackgroundColor3=RED_GLOW; speedDot.Parent=speedBtn
Instance.new("UICorner",speedDot).CornerRadius=UDim.new(1,0)
local speedLbl=Instance.new("TextLabel"); speedLbl.Size=UDim2.new(1,-28,1,0); speedLbl.Position=UDim2.new(0,24,0,0)
speedLbl.BackgroundTransparency=1; speedLbl.Text="⚡ Player Speed"
speedLbl.TextColor3=TXT_MAIN; speedLbl.TextSize=13; speedLbl.Font=Enum.Font.Gotham
speedLbl.TextXAlignment=Enum.TextXAlignment.Left; speedLbl.Parent=speedBtn
speedBtn.MouseEnter:Connect(function() TweenService:Create(speedBtn,TweenInfo.new(0.12),{BackgroundColor3=RED_BRIGHT}):Play() end)
speedBtn.MouseLeave:Connect(function() TweenService:Create(speedBtn,TweenInfo.new(0.12),{BackgroundColor3=BG_CARD}):Play() end)
speedBtn.MouseButton1Click:Connect(function()
    if speedPopup and speedPopup.Parent then speedPopup:Destroy(); return end
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    local cur = hum and hum.WalkSpeed or 16
    makeBoostPopup("⚡ Player Speed", cur, 1, 300, 16, function(v)
        local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = v end
    end)
    speedPopup = gui:FindFirstChild("SoulBoostPopup")
end)

-- Jump button
local jumpPopup = nil
local jumpBtn = Instance.new("TextButton")
jumpBtn.Size=UDim2.new(0.5,-16,0,42); jumpBtn.Position=UDim2.new(0.5,4,0,32)
jumpBtn.BackgroundColor3=BG_CARD; jumpBtn.Text=""; jumpBtn.Parent=boostsPage
Instance.new("UICorner",jumpBtn).CornerRadius=UDim.new(0,8)
local jss=Instance.new("UIStroke",jumpBtn); jss.Color=RED_STROKE; jss.Thickness=1; jss.Transparency=0.55
local jumpDot=Instance.new("Frame"); jumpDot.Size=UDim2.new(0,9,0,9); jumpDot.Position=UDim2.new(0,10,0.5,-4)
jumpDot.BackgroundColor3=RED_GLOW; jumpDot.Parent=jumpBtn
Instance.new("UICorner",jumpDot).CornerRadius=UDim.new(1,0)
local jumpLbl=Instance.new("TextLabel"); jumpLbl.Size=UDim2.new(1,-28,1,0); jumpLbl.Position=UDim2.new(0,24,0,0)
jumpLbl.BackgroundTransparency=1; jumpLbl.Text="🦘 Jump Power"
jumpLbl.TextColor3=TXT_MAIN; jumpLbl.TextSize=13; jumpLbl.Font=Enum.Font.Gotham
jumpLbl.TextXAlignment=Enum.TextXAlignment.Left; jumpLbl.Parent=jumpBtn
jumpBtn.MouseEnter:Connect(function() TweenService:Create(jumpBtn,TweenInfo.new(0.12),{BackgroundColor3=RED_BRIGHT}):Play() end)
jumpBtn.MouseLeave:Connect(function() TweenService:Create(jumpBtn,TweenInfo.new(0.12),{BackgroundColor3=BG_CARD}):Play() end)
jumpBtn.MouseButton1Click:Connect(function()
    if jumpPopup and jumpPopup.Parent then jumpPopup:Destroy(); return end
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    local cur = hum and hum.JumpPower or 50
    makeBoostPopup("🦘 Jump Power", cur, 1, 500, 50, function(v)
        local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if h then
            -- Support both old JumpPower and new JumpHeight API
            pcall(function() h.UseJumpPower = true end)
            pcall(function() h.JumpPower = v end)
            -- Also set JumpHeight for games using new system (JumpHeight ≈ JumpPower²/196)
            pcall(function() h.JumpHeight = (v * v) / 196 end)
        end
    end)
    jumpPopup = gui:FindFirstChild("SoulBoostPopup")
end)

boostsTabBtn.MouseButton1Click:Connect(function() switchTab("Boosts") end)

-- ===================== MISC TAB =====================
local miscTabBtn = createTabButton("Misc", 6)
miscTabBtn.Visible = false
local miscPage = createPage()
tabs["Misc"].page = miscPage

-- MOVEMENT & PHYSICS section
sectionHeader(miscPage, "MOVEMENT & PHYSICS", 10)

local flyConn, flyBV, flyBG = nil, nil, nil
local flySpeed = 60
local flyAnimTrack = nil
local flySpeedGui = nil

local SUPERMAN_ANIM_ID = "rbxassetid://13964536279"

local function openFlySpeedGui()
    if flySpeedGui and flySpeedGui.Parent then flySpeedGui:Destroy(); return end
    flySpeedGui = Instance.new("ScreenGui")
    flySpeedGui.Name = "SoulFlySpeed"; flySpeedGui.ResetOnSpawn = false
    flySpeedGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    flySpeedGui.DisplayOrder = 55; flySpeedGui.Parent = gui

    local fp = Instance.new("Frame")
    fp.Size = UDim2.new(0,300,0,190); fp.Position = UDim2.new(0.5,-150,0.5,-95)
    fp.BackgroundColor3 = Color3.fromRGB(18,18,22); fp.BorderSizePixel=0; fp.Parent=flySpeedGui
    Instance.new("UICorner",fp).CornerRadius=UDim.new(0,12)
    local fps2=Instance.new("UIStroke",fp); fps2.Color=Color3.fromRGB(139,0,0); fps2.Thickness=1.5

    local fh=Instance.new("Frame")
    fh.Size=UDim2.new(1,0,0,52); fh.BackgroundColor3=Color3.fromRGB(10,10,14)
    fh.BorderSizePixel=0; fh.ZIndex=2; fh.Parent=fp
    Instance.new("UICorner",fh).CornerRadius=UDim.new(0,12)

    local ftitle=Instance.new("TextLabel")
    ftitle.Size=UDim2.new(1,-44,0,26); ftitle.Position=UDim2.new(0,14,0,4)
    ftitle.BackgroundTransparency=1; ftitle.Text="🦸 Soul's Superman Fly"
    ftitle.TextColor3=TXT_WHITE; ftitle.TextSize=14; ftitle.Font=Enum.Font.GothamBold
    ftitle.TextXAlignment=Enum.TextXAlignment.Left; ftitle.ZIndex=3; ftitle.Parent=fh

    local fsubtitle=Instance.new("TextLabel")
    fsubtitle.Size=UDim2.new(1,-44,0,16); fsubtitle.Position=UDim2.new(0,14,0,30)
    fsubtitle.BackgroundTransparency=1; fsubtitle.Text="Made by Soul"
    fsubtitle.TextColor3=Color3.fromRGB(160,70,70); fsubtitle.TextSize=11; fsubtitle.Font=Enum.Font.Gotham
    fsubtitle.TextXAlignment=Enum.TextXAlignment.Left; fsubtitle.ZIndex=3; fsubtitle.Parent=fh

    local fclose=Instance.new("TextButton")
    fclose.Size=UDim2.new(0,26,0,26); fclose.Position=UDim2.new(1,-32,0.5,-13)
    fclose.BackgroundColor3=Color3.fromRGB(80,0,0); fclose.Text="✕"
    fclose.TextColor3=TXT_WHITE; fclose.TextSize=13; fclose.Font=Enum.Font.GothamBold
    fclose.ZIndex=3; fclose.Parent=fh
    Instance.new("UICorner",fclose).CornerRadius=UDim.new(0,6)
    fclose.MouseButton1Click:Connect(function() flySpeedGui:Destroy() end)

    local fValLbl=Instance.new("TextLabel")
    fValLbl.Size=UDim2.new(1,-24,0,26); fValLbl.Position=UDim2.new(0,12,0,62)
    fValLbl.BackgroundTransparency=1; fValLbl.Text="Speed: "..tostring(flySpeed)
    fValLbl.TextColor3=TXT_MAIN; fValLbl.TextSize=14; fValLbl.Font=Enum.Font.GothamBold
    fValLbl.TextXAlignment=Enum.TextXAlignment.Center; fValLbl.ZIndex=2; fValLbl.Parent=fp

    local fSliderBg=Instance.new("Frame")
    fSliderBg.Size=UDim2.new(1,-40,0,10); fSliderBg.Position=UDim2.new(0,20,0,88)
    fSliderBg.BackgroundColor3=Color3.fromRGB(40,40,50); fSliderBg.BorderSizePixel=0; fSliderBg.ZIndex=2; fSliderBg.Parent=fp
    Instance.new("UICorner",fSliderBg).CornerRadius=UDim.new(1,0)

    local pct0=(flySpeed-10)/(300-10)
    local fFill=Instance.new("Frame")
    fFill.Size=UDim2.new(pct0,0,1,0); fFill.BackgroundColor3=RED_GLOW
    fFill.BorderSizePixel=0; fFill.ZIndex=3; fFill.Parent=fSliderBg
    Instance.new("UICorner",fFill).CornerRadius=UDim.new(1,0)

    local fKnob=Instance.new("Frame")
    fKnob.Size=UDim2.new(0,18,0,18); fKnob.BackgroundColor3=TXT_WHITE
    fKnob.Position=UDim2.new(pct0,-9,0.5,-9); fKnob.ZIndex=4; fKnob.Parent=fSliderBg
    Instance.new("UICorner",fKnob).CornerRadius=UDim.new(1,0)

    local fDrag=false
    fKnob.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then fDrag=true end end)
    fSliderBg.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then fDrag=true end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then fDrag=false end end)
    UserInputService.InputChanged:Connect(function(i)
        if fDrag and i.UserInputType==Enum.UserInputType.MouseMovement then
            local rel=math.clamp((i.Position.X-fSliderBg.AbsolutePosition.X)/fSliderBg.AbsoluteSize.X,0,1)
            flySpeed=math.floor(10+rel*(300-10))
            fFill.Size=UDim2.new(rel,0,1,0); fKnob.Position=UDim2.new(rel,-9,0.5,-9)
            fValLbl.Text="Speed: "..tostring(flySpeed)
        end
    end)

    local presets={{"Slow",20},{"Normal",60},{"Fast",150},{"Max",300}}
    for i,pr in ipairs(presets) do
        local pb=Instance.new("TextButton")
        pb.Size=UDim2.new(0,64,0,30); pb.Position=UDim2.new(0,12+(i-1)*68,0,110)
        pb.BackgroundColor3=BG_CARD; pb.Text=pr[1]
        pb.TextColor3=TXT_MAIN; pb.TextSize=11; pb.Font=Enum.Font.Gotham
        pb.ZIndex=2; pb.Parent=fp
        Instance.new("UICorner",pb).CornerRadius=UDim.new(0,8)
        local pv=pr[2]
        pb.MouseButton1Click:Connect(function()
            flySpeed=pv
            local r=(pv-10)/(300-10)
            fFill.Size=UDim2.new(r,0,1,0); fKnob.Position=UDim2.new(r,-9,0.5,-9)
            fValLbl.Text="Speed: "..tostring(pv)
        end)
        pb.MouseEnter:Connect(function() TweenService:Create(pb,TweenInfo.new(0.12),{BackgroundColor3=RED_BRIGHT}):Play() end)
        pb.MouseLeave:Connect(function() TweenService:Create(pb,TweenInfo.new(0.12),{BackgroundColor3=BG_CARD}):Play() end)
    end

    local resetF=Instance.new("TextButton")
    resetF.Size=UDim2.new(1,-24,0,34); resetF.Position=UDim2.new(0,12,0,148)
    resetF.BackgroundColor3=Color3.fromRGB(60,0,0); resetF.Text="↺  Reset to Default (60)"
    resetF.TextColor3=TXT_WHITE; resetF.TextSize=13; resetF.Font=Enum.Font.GothamSemibold
    resetF.ZIndex=2; resetF.Parent=fp
    Instance.new("UICorner",resetF).CornerRadius=UDim.new(0,8)
    resetF.MouseButton1Click:Connect(function()
        flySpeed=60
        local r=(60-10)/(300-10)
        fFill.Size=UDim2.new(r,0,1,0); fKnob.Position=UDim2.new(r,-9,0.5,-9)
        fValLbl.Text="Speed: 60"
    end)
    resetF.MouseEnter:Connect(function() TweenService:Create(resetF,TweenInfo.new(0.12),{BackgroundColor3=RED_BRIGHT}):Play() end)
    resetF.MouseLeave:Connect(function() TweenService:Create(resetF,TweenInfo.new(0.12),{BackgroundColor3=BG_CARD}):Play() end)

    local fd,fds,fdp=false,nil,nil
    fh.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            fd=true; fds=i.Position; fdp=fp.Position
            i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then fd=false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if fd and i.UserInputType==Enum.UserInputType.MouseMovement then
            local d=i.Position-fds
            fp.Position=UDim2.new(fdp.X.Scale,fdp.X.Offset+d.X,fdp.Y.Scale,fdp.Y.Offset+d.Y)
        end
    end)
end

makeToggle(miscPage, "Superman Fly", 32,
    function()
        -- Listen for the new GUI the INSTANT it's added to PlayerGui
        local patchConn
        patchConn = player.PlayerGui.ChildAdded:Connect(function(g)
            if not g:IsA("ScreenGui") then return end
            -- Give it a moment to fully build its children
            task.wait(0.15)
            patchConn:Disconnect()

            local T = {
                {"rapiariep Menu",      "Soul's Superman Gui"},
                {"rapiariep",           "Soul"},
                {"Sistem",              "System"},
                {"Gn Atin",             "Settings"},
                {"Teleport Pemain",     "Player Teleport"},
                {"Iseng",               "Extras"},
                {"Terbang Superman",    "Superman Fly"},
                {"Kecepatan Superman",  "Fly Speed"},
                {"Kecepatan Lari",      "Sprint Speed"},
                {"Tembus Tembok",       "No Clip"},
                {"Tukang Lompat",       "Infinite Jump"},
                {"Tampilkan Koordinat", "Show Coordinates"},
                {"Safe Landing",        "Safe Landing"},
                {"Lari",                "Sprint"},
                {"Pilih Pemain",        "Select Player"},
                {"Teleport ke Pemain",  "Teleport to Player"},
                {"Teleport ke Saya",    "Teleport to Me"},
                {"Ikuti Pemain",        "Follow Player"},
                {"Berhenti Ikuti",      "Stop Following"},
                {"Semua Pemain",        "All Players"},
                {"Buat Bola",           "Spawn Ball"},
                {"Buat Kotak",          "Spawn Box"},
                {"Hapus Semua",         "Remove All"},
                {"Ledakkan",            "Explode"},
                {"Lempar",              "Fling"},
                {"Injak Kepala",        "Head Sit"},
                {"Ikut Punggung",       "Backpack Mode"},
                {"Jatuhkan",            "Drop"},
                {"Ganggu",              "Annoy"},
                {"Bahasa",              "Language"},
                {"Indonesia",           "English"},
                {"Simpan",              "Save"},
                {"Aktif",               "Active"},
                {"Nonaktif",            "Inactive"},
                {"Nyala",               "On"},
                {"Mati",                "Off"},
                {"Tombol",              "Button"},
                {"tombol",              "button"},
                {"Pemain",              "Player"},
                {"Kecepatan",           "Speed"},
                {"Terbang",             "Fly"},
                {"Koordinat",           "Coordinates"},
                {"Berhenti",            "Stop"},
                {"Mulai",               "Start"},
                {"Keluar",              "Close"},
                {"Tutup",               "Close"},
                {"Cari",                "Search"},
                {"Ya",                  "Yes"},
                {"Tidak",               "No"},
                {"Semua",               "All"},
                {"Saya",                "Me"},
            }

            -- Purple + crimson red palette
            local P_BG     = Color3.fromRGB(18,  5,  30)
            local P_PANEL  = Color3.fromRGB(28, 10,  48)
            local P_CARD   = Color3.fromRGB(40, 14,  68)
            local P_BTN    = Color3.fromRGB(90,  0, 170)
            local P_ACCENT = Color3.fromRGB(150,  0, 255)
            local P_BRIGHT = Color3.fromRGB(190, 90, 255)
            local P_TEXT   = Color3.fromRGB(225, 185, 255)
            local P_DIM    = Color3.fromRGB(155, 105, 205)
            local CRIMSON  = Color3.fromRGB(139,  0,   0)
            local WHITE    = Color3.new(1, 1, 1)

            -- Translate text
            for _, d in ipairs(g:GetDescendants()) do
                if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
                    pcall(function()
                        for _, pair in ipairs(T) do
                            d.Text = d.Text:gsub(pair[1], pair[2])
                        end
                    end)
                end
            end

            -- Also catch any text added AFTER (e.g. dynamic labels)
            g.DescendantAdded:Connect(function(d)
                if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
                    task.wait(0.05)
                    pcall(function()
                        for _, pair in ipairs(T) do
                            d.Text = d.Text:gsub(pair[1], pair[2])
                        end
                    end)
                end
            end)

            -- Theme everything purple/crimson
            for _, d in ipairs(g:GetDescendants()) do
                pcall(function()
                    if d:IsA("Frame") or d:IsA("ScrollingFrame") then
                        if d.BackgroundTransparency >= 1 then return end
                        local r = d.BackgroundColor3.R * 255
                        local gr = d.BackgroundColor3.G * 255
                        local b = d.BackgroundColor3.B * 255
                        if r < 45 and gr < 45 and b < 45 then
                            d.BackgroundColor3 = P_BG
                        elseif r < 75 then
                            d.BackgroundColor3 = P_PANEL
                        else
                            d.BackgroundColor3 = P_CARD
                        end
                    elseif d:IsA("TextButton") then
                        if d.BackgroundTransparency < 1 then
                            -- Active/toggled buttons → crimson, inactive → purple
                            local r = d.BackgroundColor3.R * 255
                            d.BackgroundColor3 = (r > 50) and CRIMSON or P_BTN
                        end
                        d.TextColor3 = WHITE
                        d.Font = Enum.Font.GothamSemibold
                    elseif d:IsA("TextLabel") then
                        d.TextColor3 = P_TEXT
                    elseif d:IsA("TextBox") then
                        if d.BackgroundTransparency < 1 then
                            d.BackgroundColor3 = P_PANEL
                        end
                        d.TextColor3 = WHITE
                        d.PlaceholderColor3 = P_DIM
                    elseif d:IsA("UIStroke") then
                        d.Color = P_ACCENT
                    elseif d:IsA("ImageLabel") or d:IsA("ImageButton") then
                        d.ImageColor3 = P_BRIGHT
                    elseif d:IsA("ScrollingFrame") then
                        d.ScrollBarImageColor3 = P_ACCENT
                    end
                end)
            end
        end)

        -- Load the fly script AFTER the listener is connected
        pcall(function()
            loadstring(game:HttpGet("https://pastebin.com/raw/uxGd6Y83"))()
        end)
    end,
    function()
        -- Destroy the external GUI on toggle off
        local SOUL_GUIS = {
            "SoulV1","SoulKeySystem","SoulJerkCredit",
            "SoulAutoClick","SoulAnimChanger","SoulFlySpeed","SoulBoostPopup","SoulShaders"
        }
        for _, g in ipairs(player.PlayerGui:GetChildren()) do
            if g:IsA("ScreenGui") then
                local isSoul = false
                for _, n in ipairs(SOUL_GUIS) do if g.Name == n then isSoul = true; break end end
                if not isSoul then pcall(function() g:Destroy() end) end
            end
        end
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end
    end
)

makeToggle(miscPage, "Infinite Baseplate", 82,
    function()
        -- Hook ChildAdded BEFORE loadstring so we catch the GUI instantly
        local bpConn
        bpConn = player.PlayerGui.ChildAdded:Connect(function(g)
            if not g:IsA("ScreenGui") then return end
            task.wait(0.15)
            bpConn:Disconnect()

            local RED_BG     = Color3.fromRGB(20,  2,  2)
            local RED_PANEL  = Color3.fromRGB(35,  4,  4)
            local RED_CARD   = Color3.fromRGB(55,  6,  6)
            local RED_BTN    = Color3.fromRGB(139,  0,  0)
            local RED_BRIGHT = Color3.fromRGB(200, 10, 10)
            local RED_ACCENT = Color3.fromRGB(160,  0,  0)
            local RED_TEXT   = Color3.fromRGB(255, 180, 180)
            local RED_DIM    = Color3.fromRGB(200, 100, 100)
            local WHITE      = Color3.new(1, 1, 1)

            -- Rebrand + translate
            local T = {
                {"EmptyTools",   "SOUL Tools"},
                {"Empty Tools",  "SOUL Tools"},
                {"emptytools",   "SOUL Tools"},
                {"empty tools",  "SOUL Tools"},
                {"LikelySmith",  "Soul"},
                {"likelysmith",  "Soul"},
                {"Made by",      "Made by Soul"},
            }

            for _, d in ipairs(g:GetDescendants()) do
                if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
                    pcall(function()
                        for _, pair in ipairs(T) do
                            d.Text = d.Text:gsub(pair[1], pair[2])
                        end
                    end)
                end
            end

            -- Also catch dynamically added text
            g.DescendantAdded:Connect(function(d)
                if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
                    task.wait(0.05)
                    pcall(function()
                        for _, pair in ipairs(T) do
                            d.Text = d.Text:gsub(pair[1], pair[2])
                        end
                    end)
                end
            end)

            -- Theme everything red
            for _, d in ipairs(g:GetDescendants()) do
                pcall(function()
                    if d:IsA("Frame") or d:IsA("ScrollingFrame") then
                        if d.BackgroundTransparency >= 1 then return end
                        local r = d.BackgroundColor3.R * 255
                        local gr = d.BackgroundColor3.G * 255
                        local b = d.BackgroundColor3.B * 255
                        if r < 45 and gr < 45 and b < 45 then
                            d.BackgroundColor3 = RED_BG
                        elseif r < 80 then
                            d.BackgroundColor3 = RED_PANEL
                        else
                            d.BackgroundColor3 = RED_CARD
                        end
                    elseif d:IsA("TextButton") then
                        if d.BackgroundTransparency < 1 then
                            d.BackgroundColor3 = RED_BTN
                        end
                        d.TextColor3 = WHITE
                        d.Font = Enum.Font.GothamSemibold
                    elseif d:IsA("TextLabel") then
                        d.TextColor3 = RED_TEXT
                    elseif d:IsA("TextBox") then
                        if d.BackgroundTransparency < 1 then
                            d.BackgroundColor3 = RED_PANEL
                        end
                        d.TextColor3 = WHITE
                        d.PlaceholderColor3 = RED_DIM
                    elseif d:IsA("UIStroke") then
                        d.Color = RED_ACCENT
                    elseif d:IsA("ImageLabel") or d:IsA("ImageButton") then
                        d.ImageColor3 = RED_BRIGHT
                    elseif d:IsA("ScrollingFrame") then
                        d.ScrollBarImageColor3 = RED_ACCENT
                    end
                end)
            end
        end)

        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/likelysmith/EmptyTools/main/script"))()
        end)
    end,
    function()
        -- Destroy the EmptyTools/SOUL Tools GUI on toggle off
        local SOUL_GUIS = {
            "SoulV1","SoulKeySystem","SoulJerkCredit",
            "SoulAutoClick","SoulAnimChanger","SoulFlySpeed","SoulBoostPopup"
        }
        for _, g in ipairs(player.PlayerGui:GetChildren()) do
            if g:IsA("ScreenGui") then
                local isSoul = false
                for _, n in ipairs(SOUL_GUIS) do if g.Name == n then isSoul = true; break end end
                if not isSoul then pcall(function() g:Destroy() end) end
            end
        end
    end
)

makeToggle(miscPage, "Speed Boost", 132,
    function()
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 80 end
    end,
    function()
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 16 end
    end
)

-- Click Teleport: press F to teleport to mouse position
local clickTeleportConn = nil
local mouse = player:GetMouse()
makeToggle(miscPage, "Click Teleport  [F]", 182,
    function()
        clickTeleportConn = UserInputService.InputBegan:Connect(function(inp, gp)
            if gp then return end
            if inp.KeyCode == Enum.KeyCode.F then
                local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if not myRoot then return end
                local unitRay = camera:ScreenPointToRay(mouse.X, mouse.Y)
                local rayParams = RaycastParams.new()
                rayParams.FilterDescendantsInstances = { player.Character }
                rayParams.FilterType = Enum.RaycastFilterType.Exclude
                local result = workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000, rayParams)
                if result then
                    myRoot.CFrame = CFrame.new(result.Position + Vector3.new(0, 3, 0))
                end
            end
        end)
    end,
    function()
        if clickTeleportConn then clickTeleportConn:Disconnect(); clickTeleportConn = nil end
    end
)

makeToggle(miscPage, "Infinite Zoom", 232,
    function() camera.FieldOfView = 90 end,
    function() camera.FieldOfView = 70 end
)

-- TOOLS section
sectionHeader(miscPage, "TOOLS", 292)

local antiAfkConn = nil
makeToggle(miscPage, "Anti-AFK", 314,
    function()
        -- Bypass Roblox AFK kick: fire VirtualUser input every 15s AND catch Idled event
        local vu = game:GetService("VirtualUser")
        -- Hook the Idled event (fires at ~3 min idle, kicks at ~20 min)
        antiAfkConn = player.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0, 0), camera.CFrame)
            task.wait(0.1)
            vu:Button2Up(Vector2.new(0, 0), camera.CFrame)
        end)
        -- Also run a background loop every 15s to keep the session alive
        task.spawn(function()
            while antiAfkConn do
                vu:Button2Down(Vector2.new(0, 0), camera.CFrame)
                task.wait(0.1)
                vu:Button2Up(Vector2.new(0, 0), camera.CFrame)
                task.wait(15)
            end
        end)
    end,
    function()
        if antiAfkConn then antiAfkConn:Disconnect(); antiAfkConn = nil end
    end
)

makeToggle(miscPage, "Player Speed Boost", 364,
    function()
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 60 end
    end,
    function()
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 16 end
    end
)

makeToggle(miscPage, "Jerk (equip tool)", 414,
    function()
        pcall(function()
            loadstring(game:HttpGet("https://pastebin.com/raw/r35KeBfP"))()
        end)
        -- Destroy any credit GUI left by the script
        task.wait(0.3)
        for _, g in ipairs(player.PlayerGui:GetChildren()) do
            if g:IsA("ScreenGui") then
                for _, d in ipairs(g:GetDescendants()) do
                    if d:IsA("TextLabel") and (d.Text:lower():find("sai") or d.Text:lower():find("skondo")) then
                        pcall(function() g:Destroy() end); break
                    end
                end
            end
        end
    end,
    function() end
)

makeToggle(miscPage, "Anti-AFK (Fakeout)", 464,
    function()
        local vu = game:GetService("VirtualUser")
        task.spawn(function()
            while task.wait(60) do
                vu:Button2Down(Vector2.new(0,0), camera.CFrame)
                task.wait(0.1)
                vu:Button2Up(Vector2.new(0,0), camera.CFrame)
            end
        end)
    end, nil
)

-- SYSTEM section
sectionHeader(miscPage, "SYSTEM", 524)

local rejoinBtn = Instance.new("TextButton")
rejoinBtn.Size = UDim2.new(1, -24, 0, 42); rejoinBtn.Position = UDim2.new(0, 12, 0, 546)
rejoinBtn.BackgroundColor3 = BG_CARD; rejoinBtn.Text = ""; rejoinBtn.Parent = miscPage
Instance.new("UICorner", rejoinBtn).CornerRadius = UDim.new(0, 8)
local rjDot = Instance.new("Frame"); rjDot.Size = UDim2.new(0,9,0,9); rjDot.Position = UDim2.new(0,12,0.5,-4)
rjDot.BackgroundColor3 = RED_GLOW; rjDot.Parent = rejoinBtn; Instance.new("UICorner",rjDot).CornerRadius = UDim.new(1,0)
local rjLbl = Instance.new("TextLabel"); rjLbl.Size = UDim2.new(1,-30,1,0); rjLbl.Position = UDim2.new(0,28,0,0)
rjLbl.BackgroundTransparency=1; rjLbl.Text="Rejoin Server"; rjLbl.TextColor3=TXT_MAIN; rjLbl.TextSize=13
rjLbl.Font=Enum.Font.Gotham; rjLbl.TextXAlignment=Enum.TextXAlignment.Left; rjLbl.Parent=rejoinBtn
rejoinBtn.MouseButton1Click:Connect(function()
    local TeleportService = game:GetService("TeleportService")
    TeleportService:Teleport(game.PlaceId, player)
end)
rejoinBtn.MouseEnter:Connect(function() TweenService:Create(rejoinBtn, TweenInfo.new(0.12), { BackgroundColor3 = RED_BRIGHT }):Play() end)
rejoinBtn.MouseLeave:Connect(function() TweenService:Create(rejoinBtn, TweenInfo.new(0.12), { BackgroundColor3 = BG_CARD }):Play() end)

local unloadBtn = Instance.new("TextButton")
unloadBtn.Size = UDim2.new(1, -24, 0, 42); unloadBtn.Position = UDim2.new(0, 12, 0, 596)
unloadBtn.BackgroundColor3 = BG_CARD; unloadBtn.Text = ""; unloadBtn.Parent = miscPage
Instance.new("UICorner", unloadBtn).CornerRadius = UDim.new(0, 8)
local ulDot = Instance.new("Frame"); ulDot.Size = UDim2.new(0,9,0,9); ulDot.Position = UDim2.new(0,12,0.5,-4)
ulDot.BackgroundColor3 = RED_GLOW; ulDot.Parent = unloadBtn; Instance.new("UICorner",ulDot).CornerRadius = UDim.new(1,0)
local ulLbl = Instance.new("TextLabel"); ulLbl.Size = UDim2.new(1,-30,1,0); ulLbl.Position = UDim2.new(0,28,0,0)
ulLbl.BackgroundTransparency=1; ulLbl.Text="Unload Script"; ulLbl.TextColor3=TXT_MAIN; ulLbl.TextSize=13
ulLbl.Font=Enum.Font.Gotham; ulLbl.TextXAlignment=Enum.TextXAlignment.Left; ulLbl.Parent=unloadBtn
unloadBtn.MouseButton1Click:Connect(function()
    stopViewing()
    screenGui:Destroy()
end)
unloadBtn.MouseEnter:Connect(function() TweenService:Create(unloadBtn, TweenInfo.new(0.12), { BackgroundColor3 = RED_BRIGHT }):Play() end)
unloadBtn.MouseLeave:Connect(function() TweenService:Create(unloadBtn, TweenInfo.new(0.12), { BackgroundColor3 = BG_CARD }):Play() end)

miscTabBtn.MouseButton1Click:Connect(function() switchTab("Misc") end)

-- ===================== EXTERNAL TAB =====================
local externalTabBtn = createTabButton("External", 7)
local externalPage = createPage()
tabs["External"].page = externalPage

sectionHeader(externalPage, "EXTERNAL SCRIPTS", 10)

local function extBtn(text, posY, fn)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -24, 0, 42); btn.Position = UDim2.new(0, 12, 0, posY)
    btn.BackgroundColor3 = BG_CARD; btn.Text = ""; btn.Parent = externalPage
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", btn); s.Color = RED_STROKE; s.Thickness = 1; s.Transparency = 0.55
    local dot = Instance.new("Frame"); dot.Size = UDim2.new(0,9,0,9); dot.Position = UDim2.new(0,12,0.5,-4)
    dot.BackgroundColor3 = Color3.fromRGB(255, 200, 0); dot.Parent = btn
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)
    local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(1,-30,1,0); lbl.Position = UDim2.new(0,28,0,0)
    lbl.BackgroundTransparency=1; lbl.Text=text; lbl.TextColor3=TXT_MAIN; lbl.TextSize=13
    lbl.Font=Enum.Font.Gotham; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Parent=btn
    btn.MouseButton1Click:Connect(function() pcall(fn) end)
    btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = RED_BRIGHT }):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = BG_CARD }):Play() end)
end

extBtn("Infinite Yield", 32, function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)
extBtn("Dex Explorer", 82, function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
end)
extBtn("Dark Dex", 132, function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/GreenDaMom/DarkDex-v3/main/dark.lua"))()
end)

externalTabBtn.MouseButton1Click:Connect(function() switchTab("External") end)

-- ===================== EXTRA TAB =====================
local extraTabBtn = createTabButton("Extra", 9)
local extraPage = createPage()
tabs["Extra"].page = extraPage

-- Small label inside the tab page
local extraInfoLbl = Instance.new("TextLabel")
extraInfoLbl.Size = UDim2.new(1, -24, 0, 40); extraInfoLbl.Position = UDim2.new(0, 12, 0, 16)
extraInfoLbl.BackgroundTransparency = 1
extraInfoLbl.Text = "Click the Extra tab again to open Command List"
extraInfoLbl.TextColor3 = TXT_DIM; extraInfoLbl.TextSize = 12; extraInfoLbl.Font = Enum.Font.Gotham
extraInfoLbl.TextXAlignment = Enum.TextXAlignment.Center; extraInfoLbl.TextWrapped = true
extraInfoLbl.Parent = extraPage

-- Command list popup
local cmdListGui = nil

local CMDS = {
    { name = ";sfly",         desc = "Toggle Superman Fly"           },
    { name = ";baseplate",    desc = "Toggle Infinite Baseplate"     },
    { name = ";speed",        desc = "Toggle Speed Boost"            },
    { name = ";noclip",       desc = "Toggle No Clip"                },
    { name = ";zoom",         desc = "Toggle Infinite Zoom"          },
    { name = ";teleport",     desc = "Click Teleport [F]"            },
    { name = ";afk",          desc = "Toggle Anti-AFK"               },
    { name = ";aimlock",      desc = "Toggle Aimlock"                },
    { name = ";hitbox",       desc = "Toggle Hitbox Expander"        },
    { name = ";autoclicker",  desc = "Toggle Auto Clicker"           },
    { name = ";infijump",     desc = "Toggle Infinite Jump"          },
    { name = ";esp",          desc = "Toggle Player ESP"             },
    { name = ";fullbright",   desc = "Toggle Full Bright"            },
    { name = ";hidegui",      desc = "Toggle Hide GUI"               },
    { name = ";sad",          desc = "Send Soul V1 chat ad"          },
    { name = ";facebang",     desc = "Toggle Face Bang"              },
    { name = ";fpson",        desc = "FPS Boost ON"                  },
    { name = ";fpsoff",       desc = "FPS Boost OFF"                 },
    { name = ";mute",         desc = "Mute all sounds"               },
    { name = ";unmute",       desc = "Unmute all sounds"             },
    { name = ";day",          desc = "Set time to daytime"           },
    { name = ";night",        desc = "Set time to night"             },
    { name = ";sunrise",      desc = "Set time to sunrise"           },
    { name = ";sunset",       desc = "Set time to sunset"            },
    { name = ";fog",          desc = "Add thick fog"                 },
    { name = ";clearfog",     desc = "Remove all fog"                },
    { name = ";lowgrav",      desc = "Low gravity (5)"               },
    { name = ";nograv",       desc = "Zero gravity (space)"          },
    { name = ";highgrav",     desc = "High gravity (400)"            },
    { name = ";normgrav",     desc = "Normal gravity (196.2)"        },
    { name = ";invis",        desc = "Make yourself invisible"       },
    { name = ";vis",          desc = "Make yourself visible"         },
    { name = ";freeze",       desc = "Freeze character in place"     },
    { name = ";unfreeze",     desc = "Unfreeze character"            },
    { name = ";god",          desc = "God mode - lock health at max" },
    { name = ";fling",        desc = "Fling yourself into the air"   },
    { name = ";explode",      desc = "Explosion at your position"    },
    { name = ";spin",         desc = "Spin your character 360°"      },
    { name = ";reset",        desc = "Reset your character"          },
    { name = ";rejoin",       desc = "Rejoin current server"         },
    { name = ";fp",           desc = "Lock to first person"          },
    { name = ";fc",           desc = "Free camera zoom"              },
    { name = ";maxjump",      desc = "Max jump power (500)"          },
    { name = ";resetjump",    desc = "Reset jump power (50)"         },
    { name = ";spawn",        desc = "Teleport to map spawn"         },
    { name = ";disco",        desc = "Disco lighting flash"          },
    { name = ";sky pink",     desc = "Set sky to pink"               },
    { name = ";sky red",      desc = "Set sky to red"                },
    { name = ";sky blue",     desc = "Set sky to blue"               },
    { name = ";sky purple",   desc = "Set sky to purple"             },
    { name = ";sky green",    desc = "Set sky to green"              },
    { name = ";sky orange",   desc = "Set sky to orange"             },
    { name = ";sky yellow",   desc = "Set sky to yellow"             },
    { name = ";sky cyan",     desc = "Set sky to cyan"               },
    { name = ";sky black",    desc = "Set sky to black"              },
    { name = ";sky white",    desc = "Set sky to white"              },
    { name = ";sky galaxy",   desc = "Set sky to galaxy purple"      },
    { name = ";sky reset",    desc = "Reset sky to default"          },
    { name = ";help",         desc = "Show this command list"        },
}

local function openCmdList()
    -- Toggle off if already open
    if cmdListGui and cmdListGui.Parent then
        cmdListGui:Destroy(); cmdListGui = nil; return
    end

    cmdListGui = Instance.new("ScreenGui")
    cmdListGui.Name = "SoulCmdList"; cmdListGui.ResetOnSpawn = false
    cmdListGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    cmdListGui.DisplayOrder = 45; cmdListGui.Parent = player.PlayerGui

    -- Card
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0, 300, 0, 0)  -- animates to full height
    card.Position = UDim2.new(0, 20, 0.5, -260)
    card.BackgroundColor3 = Color3.fromRGB(16, 3, 3)
    card.BorderSizePixel = 0; card.ClipsDescendants = true
    card.ZIndex = 10; card.Parent = cmdListGui
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)
    local cStroke = Instance.new("UIStroke", card)
    cStroke.Color = Color3.fromRGB(139, 0, 0); cStroke.Thickness = 1.5

    -- Header
    local hdr = Instance.new("Frame")
    hdr.Size = UDim2.new(1, 0, 0, 44)
    hdr.BackgroundColor3 = Color3.fromRGB(25, 4, 4)
    hdr.BorderSizePixel = 0; hdr.ZIndex = 11; hdr.Parent = card
    Instance.new("UICorner", hdr).CornerRadius = UDim.new(0, 12)

    -- Header icon + title
    local hIcon = Instance.new("TextLabel")
    hIcon.Size = UDim2.new(0, 30, 1, 0); hIcon.Position = UDim2.new(0, 10, 0, 0)
    hIcon.BackgroundTransparency = 1; hIcon.Text = "≡"
    hIcon.TextColor3 = RED_GLOW; hIcon.TextSize = 22; hIcon.Font = Enum.Font.GothamBold
    hIcon.ZIndex = 12; hIcon.Parent = hdr

    local hTitle = Instance.new("TextLabel")
    hTitle.Size = UDim2.new(1, -80, 1, 0); hTitle.Position = UDim2.new(0, 42, 0, 0)
    hTitle.BackgroundTransparency = 1; hTitle.Text = "Command List"
    hTitle.TextColor3 = Color3.new(1, 1, 1); hTitle.TextSize = 16; hTitle.Font = Enum.Font.GothamBold
    hTitle.TextXAlignment = Enum.TextXAlignment.Left; hTitle.ZIndex = 12; hTitle.Parent = hdr

    local hClose = Instance.new("TextButton")
    hClose.Size = UDim2.new(0, 26, 0, 26); hClose.Position = UDim2.new(1, -32, 0.5, -13)
    hClose.BackgroundColor3 = Color3.fromRGB(100, 0, 0); hClose.Text = "×"
    hClose.TextColor3 = Color3.new(1,1,1); hClose.TextSize = 18; hClose.Font = Enum.Font.GothamBold
    hClose.ZIndex = 12; hClose.Parent = hdr
    Instance.new("UICorner", hClose).CornerRadius = UDim.new(0, 6)
    hClose.MouseButton1Click:Connect(function() cmdListGui:Destroy(); cmdListGui = nil end)

    -- Scrollable list
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -12, 1, -52); scroll.Position = UDim2.new(0, 6, 0, 50)
    scroll.BackgroundTransparency = 1; scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 3; scroll.ScrollBarImageColor3 = Color3.fromRGB(139, 0, 0)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0); scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.ZIndex = 11; scroll.Parent = card

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder; layout.Padding = UDim.new(0, 2)
    layout.Parent = scroll
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 4); pad.PaddingBottom = UDim.new(0, 6)
    pad.PaddingLeft = UDim.new(0, 2); pad.PaddingRight = UDim.new(0, 2)
    pad.Parent = scroll

    for i, cmd in ipairs(CMDS) do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 52); row.LayoutOrder = i
        row.BackgroundColor3 = Color3.fromRGB(28, 5, 5)
        row.BackgroundTransparency = 0; row.BorderSizePixel = 0
        row.ZIndex = 12; row.Parent = scroll
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

        local cmdLbl = Instance.new("TextLabel")
        cmdLbl.Size = UDim2.new(1, -14, 0, 26); cmdLbl.Position = UDim2.new(0, 12, 0, 5)
        cmdLbl.BackgroundTransparency = 1; cmdLbl.Text = cmd.name
        cmdLbl.TextColor3 = Color3.new(1,1,1); cmdLbl.TextSize = 14; cmdLbl.Font = Enum.Font.GothamBold
        cmdLbl.TextXAlignment = Enum.TextXAlignment.Left; cmdLbl.ZIndex = 13; cmdLbl.Parent = row

        local descLbl = Instance.new("TextLabel")
        descLbl.Size = UDim2.new(1, -14, 0, 18); descLbl.Position = UDim2.new(0, 12, 0, 28)
        descLbl.BackgroundTransparency = 1; descLbl.Text = cmd.desc
        descLbl.TextColor3 = TXT_DIM; descLbl.TextSize = 11; descLbl.Font = Enum.Font.Gotham
        descLbl.TextXAlignment = Enum.TextXAlignment.Left; descLbl.ZIndex = 13; descLbl.Parent = row
    end

    -- Animate open
    local targetH = math.min(#CMDS * 54 + 60, 520)
    TweenService:Create(card, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Size = UDim2.new(0, 300, 0, targetH) }):Play()

    -- Draggable
    local dragging2, dragStart2, dragPos2 = false, nil, nil
    hdr.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging2 = true; dragStart2 = inp.Position; dragPos2 = card.Position
            inp.Changed:Connect(function() if inp.UserInputState == Enum.UserInputState.End then dragging2 = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging2 and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local d = inp.Position - dragStart2
            card.Position = UDim2.new(dragPos2.X.Scale, dragPos2.X.Offset+d.X, dragPos2.Y.Scale, dragPos2.Y.Offset+d.Y)
        end
    end)
end

extraTabBtn.MouseButton1Click:Connect(function()
    switchTab("Extra")
    openCmdList()
end)

-- ===================== DRAG =====================
local dragging, dragStart, startPos
navbar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = wrapper.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        wrapper.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

-- ===================== MINIMIZE / REOPEN =====================
local function doMinimize()
    openSound:Play()
    TweenService:Create(wrapper, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        { Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0) }):Play()
    task.delay(0.28, function() wrapper.Visible = false; reopenBtn.Visible = true end)
end
local function doReopen()
    reopenBtn.Visible = false; wrapper.Visible = true
    wrapper.Size = UDim2.new(0, 0, 0, 0); wrapper.Position = UDim2.new(0.5, 0, 0.5, 0)
    openSound:Play()
    TweenService:Create(wrapper, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Size = UDim2.new(0, UI_W, 0, UI_H), Position = UDim2.new(0.5, -UI_W/2, 0.5, -UI_H/2) }):Play()
end
minimizeBtn.MouseButton1Click:Connect(doMinimize)
reopenBtn.MouseButton1Click:Connect(doReopen)

-- ===================== G KEYBIND =====================
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.G then
        if wrapper.Visible then doMinimize() else doReopen() end
    end
end)

print("Soul V1 loaded!")

-- ===================== CHAT COMMAND SYSTEM =====================
-- Type ;command in Roblox chat to trigger features
-- Commands are intercepted client-side and NOT sent to other players

local chatCommandPrefix = ";"

local CHAT_COMMANDS = {
    -- MISC / Movement
    ["sfly"]        = function() end, -- handled by toggle click below
    ["baseplate"]   = function() end,
    ["speed"]       = function() end,
    ["noclip"]      = function() end,
    ["zoom"]        = function() end,
    ["teleport"]    = function() end,
    ["afk"]         = function() end,
    -- Combat
    ["aimlock"]     = function() end,
    ["hitbox"]      = function() end,
    ["autoclicker"] = function() end,
    ["infijump"]    = function() end,
    -- Visual
    ["esp"]         = function() end,
    ["fullbright"]  = function() end,
    ["hidegui"]     = function() end,
    ["sad"]         = function() end,
    -- Player
    ["facebang"]    = function() end,
    -- Help
    ["help"]        = function() end,
}

-- Map command name → the toggle button to simulate a click on
-- We store toggle state trackers so we can flip them
local cmdToggleMap = {}

-- Helper: simulate clicking a toggle by name
local function fireToggle(name)
    local btn = cmdToggleMap[name]
    if btn then btn:Fire() end
end

-- We use BindableEvents to trigger each toggle from chat
-- Each toggle registers itself here after creation
local function registerChatCmd(cmdName, clickFn)
    local be = Instance.new("BindableEvent")
    be.Event:Connect(clickFn)
    CHAT_COMMANDS[cmdName] = be
end

-- Build command list for ;help
local helpLines = {
    "═══ Soul V1 Commands ═══",
    ";sfly       — Superman Fly",
    ";baseplate  — Infinite Baseplate",
    ";speed      — Speed Boost",
    ";noclip     — No Clip",
    ";zoom       — Infinite Zoom",
    ";teleport   — Click Teleport [F]",
    ";afk        — Anti-AFK",
    ";aimlock    — Aimlock",
    ";hitbox     — Hitbox Expander",
    ";autoclicker— Auto Clicker",
    ";infijump   — Infinite Jump",
    ";esp        — Player ESP",
    ";fullbright — Full Bright",
    ";hidegui    — Hide GUI",
    ";sad        — SAD (chat msg)",
    ";facebang   — Face Bang",
    ";help       — Show commands",
}

-- Show help as a small GUI for 9 seconds
local function showHelpNotif()
    -- Remove existing help GUI if open
    local existing = player.PlayerGui:FindFirstChild("SoulHelpGui")
    if existing then existing:Destroy() end

    local helpGui = Instance.new("ScreenGui")
    helpGui.Name = "SoulHelpGui"
    helpGui.ResetOnSpawn = false
    helpGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    helpGui.DisplayOrder = 997
    helpGui.Parent = player.PlayerGui

    local card = Instance.new("Frame")
    card.Size = UDim2.new(0, 260, 0, 0)  -- height animates in
    card.Position = UDim2.new(0, 16, 0.5, -180)
    card.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
    card.BackgroundTransparency = 0
    card.BorderSizePixel = 0
    card.ClipsDescendants = true
    card.ZIndex = 10
    card.Parent = helpGui
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)
    local cs = Instance.new("UIStroke", card)
    cs.Color = Color3.fromRGB(139, 0, 0); cs.Thickness = 1.5

    -- Header
    local hdr = Instance.new("Frame")
    hdr.Size = UDim2.new(1, 0, 0, 36)
    hdr.BackgroundColor3 = Color3.fromRGB(30, 4, 4)
    hdr.BorderSizePixel = 0; hdr.ZIndex = 11; hdr.Parent = card
    Instance.new("UICorner", hdr).CornerRadius = UDim.new(0, 12)

    local hdrLbl = Instance.new("TextLabel")
    hdrLbl.Size = UDim2.new(1, -12, 1, 0); hdrLbl.Position = UDim2.new(0, 12, 0, 0)
    hdrLbl.BackgroundTransparency = 1; hdrLbl.Text = "⚡  Soul V1 — Commands"
    hdrLbl.TextColor3 = Color3.new(1, 1, 1); hdrLbl.TextSize = 13
    hdrLbl.Font = Enum.Font.GothamBold; hdrLbl.TextXAlignment = Enum.TextXAlignment.Left
    hdrLbl.ZIndex = 12; hdrLbl.Parent = hdr

    -- Command list
    local commands = {
        { cmd = ";sfly",        desc = "Superman Fly"       },
        { cmd = ";baseplate",   desc = "Infinite Baseplate" },
        { cmd = ";speed",       desc = "Speed Boost"        },
        { cmd = ";noclip",      desc = "No Clip"            },
        { cmd = ";zoom",        desc = "Infinite Zoom"      },
        { cmd = ";teleport",    desc = "Click Teleport"     },
        { cmd = ";afk",         desc = "Anti-AFK"           },
        { cmd = ";aimlock",     desc = "Aimlock"            },
        { cmd = ";hitbox",      desc = "Hitbox Expander"    },
        { cmd = ";autoclicker", desc = "Auto Clicker"       },
        { cmd = ";infijump",    desc = "Infinite Jump"      },
        { cmd = ";esp",         desc = "Player ESP"         },
        { cmd = ";fullbright",  desc = "Full Bright"        },
        { cmd = ";hidegui",     desc = "Hide GUI"           },
        { cmd = ";sad",         desc = "SAD Chat"           },
        { cmd = ";facebang",    desc = "Face Bang"          },
        { cmd = ";help",        desc = "Show this menu"     },
    }

    local rowH = 24
    local totalH = 36 + (#commands * rowH) + 10

    for i, c in ipairs(commands) do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -16, 0, rowH)
        row.Position = UDim2.new(0, 8, 0, 36 + (i-1) * rowH + 4)
        row.BackgroundTransparency = i % 2 == 0 and 0.85 or 1
        row.BackgroundColor3 = Color3.fromRGB(30, 4, 4)
        row.BorderSizePixel = 0; row.ZIndex = 11; row.Parent = card
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 4)

        local cmdLbl = Instance.new("TextLabel")
        cmdLbl.Size = UDim2.new(0, 110, 1, 0); cmdLbl.Position = UDim2.new(0, 6, 0, 0)
        cmdLbl.BackgroundTransparency = 1; cmdLbl.Text = c.cmd
        cmdLbl.TextColor3 = Color3.fromRGB(255, 120, 120); cmdLbl.TextSize = 11
        cmdLbl.Font = Enum.Font.GothamBold; cmdLbl.TextXAlignment = Enum.TextXAlignment.Left
        cmdLbl.ZIndex = 12; cmdLbl.Parent = row

        local descLbl = Instance.new("TextLabel")
        descLbl.Size = UDim2.new(1, -116, 1, 0); descLbl.Position = UDim2.new(0, 116, 0, 0)
        descLbl.BackgroundTransparency = 1; descLbl.Text = c.desc
        descLbl.TextColor3 = Color3.fromRGB(200, 200, 210); descLbl.TextSize = 11
        descLbl.Font = Enum.Font.Gotham; descLbl.TextXAlignment = Enum.TextXAlignment.Left
        descLbl.ZIndex = 12; descLbl.Parent = row
    end

    -- Animate card open
    TweenService:Create(card, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Size = UDim2.new(0, 260, 0, totalH) }):Play()

    -- Auto-dismiss after 9 seconds
    task.delay(9, function()
        if not card.Parent then return end
        TweenService:Create(card, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
            { Size = UDim2.new(0, 260, 0, 0), BackgroundTransparency = 1 }):Play()
        TweenService:Create(cs, TweenInfo.new(0.4), { Transparency = 1 }):Play()
        task.wait(0.45)
        pcall(function() helpGui:Destroy() end)
    end)
end

-- Command state tracker (which commands are currently active)
local cmdActive = {}

local actions = {
    ["sfly"]        = function() cmdActive["sfly"] = not cmdActive["sfly"]; if cmdActive["sfly"] then pcall(function() loadstring(game:HttpGet("https://pastebin.com/raw/uxGd6Y83"))() end); showNotif("Superman Fly", true) else local h=player.Character and player.Character:FindFirstChildOfClass("Humanoid"); if h then h.PlatformStand=false end; showNotif("Superman Fly", false) end end,
    ["baseplate"]   = function() cmdActive["baseplate"] = not cmdActive["baseplate"]; if cmdActive["baseplate"] then pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/likelysmith/EmptyTools/main/script"))() end); showNotif("Infinite Baseplate", true) else showNotif("Infinite Baseplate", false) end end,
    ["speed"]       = function() cmdActive["speed"] = not cmdActive["speed"]; local h=player.Character and player.Character:FindFirstChildOfClass("Humanoid"); if cmdActive["speed"] then if h then h.WalkSpeed=80 end; showNotif("Speed Boost", true) else if h then h.WalkSpeed=16 end; showNotif("Speed Boost", false) end end,
    ["noclip"]      = function() cmdActive["noclip"] = not cmdActive["noclip"]; if cmdActive["noclip"] then RunService.Stepped:Connect(function() if not cmdActive["noclip"] then return end; local c=player.Character; if c then for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end end); showNotif("No Clip", true) else showNotif("No Clip", false) end end,
    ["zoom"]        = function() cmdActive["zoom"] = not cmdActive["zoom"]; if cmdActive["zoom"] then camera.FieldOfView=90; showNotif("Infinite Zoom", true) else camera.FieldOfView=70; showNotif("Infinite Zoom", false) end end,
    ["teleport"]    = function() cmdActive["teleport"] = not cmdActive["teleport"]; showNotif("Click Teleport [F]", cmdActive["teleport"]) end,
    ["afk"]         = function() cmdActive["afk"] = not cmdActive["afk"]; if cmdActive["afk"] then local vu=game:GetService("VirtualUser"); player.Idled:Connect(function() if cmdActive["afk"] then vu:Button2Down(Vector2.new(0,0),camera.CFrame); task.wait(0.1); vu:Button2Up(Vector2.new(0,0),camera.CFrame) end end); showNotif("Anti-AFK", true) else showNotif("Anti-AFK", false) end end,
    ["infijump"]    = function() cmdActive["infijump"] = not cmdActive["infijump"]; if cmdActive["infijump"] then UserInputService.JumpRequest:Connect(function() if not cmdActive["infijump"] then return end; local h=player.Character and player.Character:FindFirstChildOfClass("Humanoid"); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end); showNotif("Infinite Jump", true) else showNotif("Infinite Jump", false) end end,
    ["fullbright"]  = function() cmdActive["fullbright"] = not cmdActive["fullbright"]; local l=game:GetService("Lighting"); if cmdActive["fullbright"] then l.Brightness=10; l.ClockTime=14; l.FogEnd=100000; l.GlobalShadows=false; showNotif("Full Bright", true) else l.Brightness=1; l.GlobalShadows=true; showNotif("Full Bright", false) end end,
    ["hidegui"]     = function() cmdActive["hidegui"] = not cmdActive["hidegui"]; screenGui.Enabled = not cmdActive["hidegui"]; showNotif("Hide GUI", cmdActive["hidegui"]) end,
    ["sad"]         = function() showNotif("SAD", true); task.spawn(function() pcall(function() game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents"):FindFirstChild("SayMessageRequest"):FireServer("Soul V1 Script  in beta version right now","All") end); task.wait(4); pcall(function() game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents"):FindFirstChild("SayMessageRequest"):FireServer("join our comns  QGrXsqqbDc","All") end) end) end,
    ["facebang"]    = function() cmdActive["facebang"] = not cmdActive["facebang"]; if cmdActive["facebang"] then pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/nomercy0000/face-fuck/refs/heads/main/mic%20up"))() end); showNotif("Face Bang", true) else showNotif("Face Bang", false) end end,
    ["aimlock"]     = function() cmdActive["aimlock"] = not cmdActive["aimlock"]; showNotif("Aimlock", cmdActive["aimlock"]) end,
    ["hitbox"]      = function() cmdActive["hitbox"] = not cmdActive["hitbox"]; showNotif("Hitbox Expander", cmdActive["hitbox"]) end,
    ["autoclicker"] = function() cmdActive["autoclicker"] = not cmdActive["autoclicker"]; showNotif("Auto Clicker", cmdActive["autoclicker"]) end,
    ["esp"]         = function() cmdActive["esp"] = not cmdActive["esp"]; showNotif("Player ESP", cmdActive["esp"]) end,
    -- FPS
    ["fpson"]       = function() for _,v in ipairs(workspace:GetDescendants()) do pcall(function() if v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then v.Enabled=false elseif v:IsA("Beam") or v:IsA("Trail") then v.Enabled=false elseif v:IsA("Texture") or v:IsA("Decal") then v.Transparency=1 end end) end; local l=game:GetService("Lighting"); l.GlobalShadows=false; for _,e in ipairs(l:GetChildren()) do if e:IsA("PostEffect") then e.Enabled=false end end; pcall(function() settings().Rendering.QualityLevel=Enum.QualityLevel.Level01 end); showNotif("FPS Boost ON", true) end,
    ["fpsoff"]      = function() for _,v in ipairs(workspace:GetDescendants()) do pcall(function() if v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then v.Enabled=true elseif v:IsA("Beam") or v:IsA("Trail") then v.Enabled=true elseif v:IsA("Texture") or v:IsA("Decal") then v.Transparency=0 end end) end; local l=game:GetService("Lighting"); l.GlobalShadows=true; for _,e in ipairs(l:GetChildren()) do if e:IsA("PostEffect") then e.Enabled=true end end; pcall(function() settings().Rendering.QualityLevel=Enum.QualityLevel.Automatic end); showNotif("FPS Boost OFF", true) end,
    -- Sound
    ["mute"]        = function() for _,v in ipairs(workspace:GetDescendants()) do if v:IsA("Sound") then pcall(function() v.Volume=0 end) end end; showNotif("Muted All Sounds", true) end,
    ["unmute"]      = function() for _,v in ipairs(workspace:GetDescendants()) do if v:IsA("Sound") then pcall(function() v.Volume=1 end) end end; showNotif("Unmuted All Sounds", true) end,
    -- Time
    ["day"]         = function() game:GetService("Lighting").ClockTime=14; showNotif("Daytime", true) end,
    ["night"]       = function() game:GetService("Lighting").ClockTime=0;  showNotif("Night", true) end,
    ["sunrise"]     = function() game:GetService("Lighting").ClockTime=6;  showNotif("Sunrise", true) end,
    ["sunset"]      = function() game:GetService("Lighting").ClockTime=18; showNotif("Sunset", true) end,
    ["fog"]         = function() local l=game:GetService("Lighting"); l.FogEnd=80; l.FogStart=0; l.FogColor=Color3.fromRGB(200,200,200); showNotif("Fog ON", true) end,
    ["clearfog"]    = function() local l=game:GetService("Lighting"); l.FogEnd=100000; l.FogStart=0; showNotif("Fog Cleared", true) end,
    -- Gravity
    ["lowgrav"]     = function() workspace.Gravity=5;     showNotif("Low Gravity", true) end,
    ["nograv"]      = function() workspace.Gravity=0;     showNotif("Zero Gravity", true) end,
    ["highgrav"]    = function() workspace.Gravity=400;   showNotif("High Gravity", true) end,
    ["normgrav"]    = function() workspace.Gravity=196.2; showNotif("Normal Gravity", true) end,
    -- Character
    ["invis"]       = function() local c=player.Character; if not c then return end; for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") or p:IsA("Decal") then p.Transparency=1 end end; showNotif("Invisible", true) end,
    ["vis"]         = function() local c=player.Character; if not c then return end; for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.Transparency=0 end; if p:IsA("Decal") then p.Transparency=0 end end; showNotif("Visible", true) end,
    ["freeze"]      = function() local r=player.Character and player.Character:FindFirstChild("HumanoidRootPart"); if r then r.Anchored=true end; showNotif("Frozen", true) end,
    ["unfreeze"]    = function() local r=player.Character and player.Character:FindFirstChild("HumanoidRootPart"); if r then r.Anchored=false end; showNotif("Unfrozen", true) end,
    ["god"]         = function() RunService.Heartbeat:Connect(function() local h=player.Character and player.Character:FindFirstChildOfClass("Humanoid"); if h then h.Health=h.MaxHealth end end); showNotif("God Mode ON", true) end,
    ["fling"]       = function() local r=player.Character and player.Character:FindFirstChild("HumanoidRootPart"); if not r then return end; local bv=Instance.new("BodyVelocity"); bv.MaxForce=Vector3.new(1e5,1e5,1e5); bv.Velocity=Vector3.new(math.random(-80,80),200,math.random(-80,80)); bv.Parent=r; game:GetService("Debris"):AddItem(bv,0.2); showNotif("Flung!", true) end,
    ["explode"]     = function() local r=player.Character and player.Character:FindFirstChild("HumanoidRootPart"); if not r then return end; local e=Instance.new("Explosion"); e.Position=r.Position; e.BlastRadius=20; e.BlastPressure=0; e.Parent=workspace; showNotif("Explode!", true) end,
    ["spin"]        = function() local r=player.Character and player.Character:FindFirstChild("HumanoidRootPart"); if not r then return end; task.spawn(function() for _=1,60 do r.CFrame=r.CFrame*CFrame.Angles(0,math.rad(6),0); task.wait(0.01) end end); showNotif("Spin!", true) end,
    ["reset"]       = function() local h=player.Character and player.Character:FindFirstChildOfClass("Humanoid"); if h then h.Health=0 end; showNotif("Reset Character", true) end,
    ["rejoin"]      = function() game:GetService("TeleportService"):Teleport(game.PlaceId, player) end,
    ["fp"]          = function() player.CameraMaxZoomDistance=0.5; showNotif("First Person", true) end,
    ["fc"]          = function() player.CameraMaxZoomDistance=400; showNotif("Free Camera", true) end,
    ["maxjump"]     = function() local h=player.Character and player.Character:FindFirstChildOfClass("Humanoid"); if h then pcall(function() h.UseJumpPower=true end); h.JumpPower=500 end; showNotif("Max Jump", true) end,
    ["resetjump"]   = function() local h=player.Character and player.Character:FindFirstChildOfClass("Humanoid"); if h then pcall(function() h.UseJumpPower=true end); h.JumpPower=50 end; showNotif("Reset Jump", true) end,
    ["spawn"]       = function() local sp=workspace:FindFirstChildOfClass("SpawnLocation"); local r=player.Character and player.Character:FindFirstChild("HumanoidRootPart"); if sp and r then r.CFrame=sp.CFrame+Vector3.new(0,5,0) end; showNotif("Goto Spawn", true) end,
    ["disco"]       = function() local cols={Color3.fromRGB(255,0,0),Color3.fromRGB(0,255,0),Color3.fromRGB(0,0,255),Color3.fromRGB(255,255,0),Color3.fromRGB(255,0,255),Color3.fromRGB(0,255,255)}; task.spawn(function() local l=game:GetService("Lighting"); for _=1,30 do l.Ambient=cols[math.random(#cols)]; l.OutdoorAmbient=cols[math.random(#cols)]; task.wait(0.15) end; l.Ambient=Color3.fromRGB(70,70,70); l.OutdoorAmbient=Color3.fromRGB(70,70,70) end); showNotif("Disco!", true) end,
    -- Sky colours
    ["sky pink"]    = function() local l=game:GetService("Lighting"); l.FogColor=Color3.fromRGB(255,150,200); l.FogEnd=500; l.Ambient=Color3.fromRGB(220,80,160);  l.OutdoorAmbient=Color3.fromRGB(220,80,160);  showNotif("Pink Sky", true) end,
    ["sky red"]     = function() local l=game:GetService("Lighting"); l.FogColor=Color3.fromRGB(180,0,0);     l.FogEnd=500; l.Ambient=Color3.fromRGB(120,0,0);      l.OutdoorAmbient=Color3.fromRGB(120,0,0);      showNotif("Red Sky", true) end,
    ["sky blue"]    = function() local l=game:GetService("Lighting"); l.FogColor=Color3.fromRGB(0,100,220);   l.FogEnd=500; l.Ambient=Color3.fromRGB(0,50,140);     l.OutdoorAmbient=Color3.fromRGB(0,50,140);     showNotif("Blue Sky", true) end,
    ["sky purple"]  = function() local l=game:GetService("Lighting"); l.FogColor=Color3.fromRGB(100,0,200);   l.FogEnd=500; l.Ambient=Color3.fromRGB(60,0,130);     l.OutdoorAmbient=Color3.fromRGB(60,0,130);     showNotif("Purple Sky", true) end,
    ["sky green"]   = function() local l=game:GetService("Lighting"); l.FogColor=Color3.fromRGB(0,180,80);    l.FogEnd=500; l.Ambient=Color3.fromRGB(0,100,40);     l.OutdoorAmbient=Color3.fromRGB(0,100,40);     showNotif("Green Sky", true) end,
    ["sky orange"]  = function() local l=game:GetService("Lighting"); l.FogColor=Color3.fromRGB(255,120,30);  l.FogEnd=500; l.Ambient=Color3.fromRGB(200,60,0);     l.OutdoorAmbient=Color3.fromRGB(200,60,0);     showNotif("Orange Sky", true) end,
    ["sky yellow"]  = function() local l=game:GetService("Lighting"); l.FogColor=Color3.fromRGB(255,220,50);  l.FogEnd=500; l.Ambient=Color3.fromRGB(220,150,0);    l.OutdoorAmbient=Color3.fromRGB(220,150,0);    showNotif("Yellow Sky", true) end,
    ["sky cyan"]    = function() local l=game:GetService("Lighting"); l.FogColor=Color3.fromRGB(0,210,230);   l.FogEnd=500; l.Ambient=Color3.fromRGB(0,130,160);    l.OutdoorAmbient=Color3.fromRGB(0,130,160);    showNotif("Cyan Sky", true) end,
    ["sky black"]   = function() local l=game:GetService("Lighting"); l.FogColor=Color3.fromRGB(8,8,12);      l.FogEnd=500; l.Ambient=Color3.fromRGB(4,4,8);        l.OutdoorAmbient=Color3.fromRGB(4,4,8);        showNotif("Black Sky", true) end,
    ["sky white"]   = function() local l=game:GetService("Lighting"); l.FogColor=Color3.fromRGB(230,240,255); l.FogEnd=500; l.Ambient=Color3.fromRGB(180,200,240);  l.OutdoorAmbient=Color3.fromRGB(180,200,240);  showNotif("White Sky", true) end,
    ["sky galaxy"]  = function() local l=game:GetService("Lighting"); l.FogColor=Color3.fromRGB(20,0,60);     l.FogEnd=500; l.Ambient=Color3.fromRGB(10,0,40);      l.OutdoorAmbient=Color3.fromRGB(10,0,40);      showNotif("Galaxy Sky", true) end,
    ["sky reset"]   = function() local l=game:GetService("Lighting"); l.FogColor=Color3.fromRGB(191,197,200); l.FogEnd=100000; l.FogStart=0; l.Ambient=Color3.fromRGB(70,70,70); l.OutdoorAmbient=Color3.fromRGB(70,70,70); l.GlobalShadows=true; l.Brightness=1; l.ClockTime=14; showNotif("Sky Reset", true) end,
}

-- The actual command handler
local function handleChatCommand(msg)
    local trimmed = msg:lower():gsub("^"..chatCommandPrefix, ""):gsub("^%s+", ""):gsub("%s+$", "")
    if trimmed == "help" then showHelpNotif(); return true end
    local action = actions[trimmed] or actions[trimmed:match("^(%S+)")]
    if action then action(); return true end
    return false
end

-- Hook into chat: intercept before message is sent
-- Works for both legacy and TextChatService
task.spawn(function()
    -- Method 1: Legacy chat (most games)
    pcall(function()
        local chatGui = player.PlayerGui:WaitForChild("BubbleChat", 3)
                     or player.PlayerGui:WaitForChild("Chat", 3)
        local chatFrame = chatGui and chatGui:FindFirstChildWhichIsA("Frame", true)
        if chatFrame then
            local chatBox = chatFrame:FindFirstChildWhichIsA("TextBox", true)
            if chatBox then
                chatBox.FocusLost:Connect(function(enter)
                    if enter then
                        local msg = chatBox.Text
                        if msg:sub(1,1) == chatCommandPrefix then
                            handleChatCommand(msg)
                            chatBox.Text = ""
                        end
                    end
                end)
            end
        end
    end)

    -- Method 2: TextChatService (newer games)
    pcall(function()
        local tcs = game:GetService("TextChatService")
        if tcs.ChatVersion == Enum.ChatVersion.TextChatService then
            tcs.SendingMessage:Connect(function(msg)
                if msg.Text:sub(1,1) == chatCommandPrefix then
                    handleChatCommand(msg.Text)
                end
            end)
        end
    end)
end)

-- Also hook UserInputService for Enter key chat detection as fallback
local chatActive = false
UserInputService.InputBegan:Connect(function(inp, gp)
    if inp.KeyCode == Enum.KeyCode.Slash or inp.KeyCode == Enum.KeyCode.Return then
        -- Check if a chatbox is focused
        local focused = UserInputService:GetFocusedTextBox()
        if focused then
            focused.FocusLost:Connect(function(enter)
                if enter then
                    local msg = focused.Text
                    if msg:sub(1,1) == chatCommandPrefix then
                        if handleChatCommand(msg) then
                            task.wait(0.05)
                            pcall(function() focused.Text = "" end)
                        end
                    end
                end
            end)
        end
    end
end)

-- ===================== KEY SYSTEM =====================
-- All GUI is built above. Now hide the wrapper and show the key screen.
wrapper.Visible = false

local VALID_KEY     = "key12345"
local PERM_KEY      = "key123455667@"
-- 2-day expiry: store first-use timestamp in a DataStore-free way using os.time()
-- We encode the expiry as seconds from Unix epoch. 2 days = 172800 seconds.
local KEY_DURATION  = 172800  -- 2 days in seconds
local KEY_STORE_NAME = "SoulV1_KeyExpiry"

-- Try to read stored expiry from a hidden IntValue in PlayerGui
local function getStoredExpiry()
    local store = player.PlayerGui:FindFirstChild(KEY_STORE_NAME)
    if store and store:IsA("IntValue") then
        return store.Value
    end
    return nil
end

local function setStoredExpiry(ts)
    local store = player.PlayerGui:FindFirstChild(KEY_STORE_NAME)
    if not store then
        store = Instance.new("IntValue")
        store.Name = KEY_STORE_NAME
        store.Parent = player.PlayerGui
    end
    store.Value = ts
end

local function isKeyExpired()
    local expiry = getStoredExpiry()
    if not expiry or expiry == 0 then return false end -- not yet set
    return os.time() > expiry
end

local keyGui = Instance.new("ScreenGui")
keyGui.Name           = "SoulKeySystem"
keyGui.ResetOnSpawn   = false
keyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
keyGui.DisplayOrder   = 999
keyGui.Parent         = gui

-- Dark overlay
local ksOverlay = Instance.new("Frame")
ksOverlay.Size = UDim2.new(1, 0, 1, 0)
ksOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ksOverlay.BackgroundTransparency = 0.5
ksOverlay.BorderSizePixel = 0
ksOverlay.Parent = keyGui

-- Card
local ksCard = Instance.new("Frame")
ksCard.Size             = UDim2.new(0, 320, 0, 0)
ksCard.Position         = UDim2.new(0.5, -160, 0.5, -110)
ksCard.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
ksCard.BorderSizePixel  = 0
ksCard.ClipsDescendants = true
ksCard.ZIndex           = 2
ksCard.Parent           = keyGui
Instance.new("UICorner", ksCard).CornerRadius = UDim.new(0, 12)
local ksStroke = Instance.new("UIStroke", ksCard)
ksStroke.Color = Color3.fromRGB(139, 0, 0); ksStroke.Thickness = 1.5; ksStroke.Transparency = 0.3

-- Header
local ksHeader = Instance.new("Frame")
ksHeader.Size = UDim2.new(1, 0, 0, 52)
ksHeader.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
ksHeader.BorderSizePixel = 0; ksHeader.ZIndex = 3; ksHeader.Parent = ksCard

local ksHeaderDiv = Instance.new("Frame")
ksHeaderDiv.Size = UDim2.new(1, 0, 0, 1); ksHeaderDiv.Position = UDim2.new(0, 0, 1, 0)
ksHeaderDiv.BackgroundColor3 = Color3.fromRGB(139, 0, 0); ksHeaderDiv.BorderSizePixel = 0
ksHeaderDiv.ZIndex = 3; ksHeaderDiv.Parent = ksHeader

local ksTitleLbl = Instance.new("TextLabel")
ksTitleLbl.Size = UDim2.new(1, -16, 0, 26); ksTitleLbl.Position = UDim2.new(0, 16, 0, 8)
ksTitleLbl.BackgroundTransparency = 1; ksTitleLbl.Text = "SOUL'S GUI"
ksTitleLbl.TextColor3 = Color3.new(1, 1, 1); ksTitleLbl.TextSize = 17
ksTitleLbl.Font = Enum.Font.GothamBold; ksTitleLbl.TextXAlignment = Enum.TextXAlignment.Left
ksTitleLbl.ZIndex = 4; ksTitleLbl.Parent = ksHeader

local ksSubLbl = Instance.new("TextLabel")
ksSubLbl.Size = UDim2.new(1, -16, 0, 16); ksSubLbl.Position = UDim2.new(0, 16, 0, 32)
ksSubLbl.BackgroundTransparency = 1; ksSubLbl.Text = "Key System   ·   by Soul"
ksSubLbl.TextColor3 = Color3.fromRGB(120, 120, 140); ksSubLbl.TextSize = 11
ksSubLbl.Font = Enum.Font.Gotham; ksSubLbl.TextXAlignment = Enum.TextXAlignment.Left
ksSubLbl.ZIndex = 4; ksSubLbl.Parent = ksHeader

-- Body
local ksBody = Instance.new("Frame")
ksBody.Size = UDim2.new(1, 0, 1, -52); ksBody.Position = UDim2.new(0, 0, 0, 52)
ksBody.BackgroundTransparency = 1; ksBody.ZIndex = 3; ksBody.Parent = ksCard

local ksCheckLbl = Instance.new("TextLabel")
ksCheckLbl.Size = UDim2.new(1, -24, 0, 22); ksCheckLbl.Position = UDim2.new(0, 12, 0, 14)
ksCheckLbl.BackgroundTransparency = 1; ksCheckLbl.Text = "Checking whitelist..."
ksCheckLbl.TextColor3 = Color3.fromRGB(160, 160, 180); ksCheckLbl.TextSize = 13
ksCheckLbl.Font = Enum.Font.Gotham; ksCheckLbl.TextXAlignment = Enum.TextXAlignment.Left
ksCheckLbl.TextTransparency = 1; ksCheckLbl.ZIndex = 4; ksCheckLbl.Parent = ksBody

local ksWhitelistLbl = Instance.new("TextLabel")
ksWhitelistLbl.Size = UDim2.new(1, -24, 0, 22); ksWhitelistLbl.Position = UDim2.new(0, 12, 0, 40)
ksWhitelistLbl.BackgroundTransparency = 1
ksWhitelistLbl.Text = "✓  Whitelisted — Enter your key below"
ksWhitelistLbl.TextColor3 = Color3.fromRGB(80, 220, 100); ksWhitelistLbl.TextSize = 13
ksWhitelistLbl.Font = Enum.Font.GothamSemibold; ksWhitelistLbl.TextXAlignment = Enum.TextXAlignment.Left
ksWhitelistLbl.TextTransparency = 1; ksWhitelistLbl.ZIndex = 4; ksWhitelistLbl.Parent = ksBody

-- Key input box
local ksInputBg = Instance.new("Frame")
ksInputBg.Size = UDim2.new(1, -24, 0, 40); ksInputBg.Position = UDim2.new(0, 12, 0, 70)
ksInputBg.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
ksInputBg.BorderSizePixel = 0; ksInputBg.ZIndex = 4; ksInputBg.Parent = ksBody
Instance.new("UICorner", ksInputBg).CornerRadius = UDim.new(0, 8)
local ksInputStroke = Instance.new("UIStroke", ksInputBg)
ksInputStroke.Color = Color3.fromRGB(80, 80, 100); ksInputStroke.Thickness = 1.5; ksInputStroke.Transparency = 0.3

local ksKeyBox = Instance.new("TextBox")
ksKeyBox.Size = UDim2.new(1, -16, 1, 0); ksKeyBox.Position = UDim2.new(0, 8, 0, 0)
ksKeyBox.BackgroundTransparency = 1
ksKeyBox.PlaceholderText = "Insert key here..."
ksKeyBox.PlaceholderColor3 = Color3.fromRGB(90, 90, 110)
ksKeyBox.Text = ""
ksKeyBox.TextColor3 = Color3.new(1, 1, 1); ksKeyBox.TextSize = 14
ksKeyBox.Font = Enum.Font.Gotham; ksKeyBox.ClearTextOnFocus = false
ksKeyBox.TextXAlignment = Enum.TextXAlignment.Left
ksKeyBox.ZIndex = 5; ksKeyBox.Parent = ksInputBg

-- Submit button
local ksSubmitBtn = Instance.new("TextButton")
ksSubmitBtn.Size = UDim2.new(1, -24, 0, 38); ksSubmitBtn.Position = UDim2.new(0, 12, 0, 118)
ksSubmitBtn.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
ksSubmitBtn.Text = "Submit Key"
ksSubmitBtn.TextColor3 = Color3.new(1, 1, 1); ksSubmitBtn.TextSize = 14
ksSubmitBtn.Font = Enum.Font.GothamBold
ksSubmitBtn.ZIndex = 4; ksSubmitBtn.Parent = ksBody
Instance.new("UICorner", ksSubmitBtn).CornerRadius = UDim.new(0, 8)
ksSubmitBtn.MouseEnter:Connect(function()
    TweenService:Create(ksSubmitBtn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(200, 10, 10) }):Play()
end)
ksSubmitBtn.MouseLeave:Connect(function()
    TweenService:Create(ksSubmitBtn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(139, 0, 0) }):Play()
end)

-- Status/error label
local ksStatusLbl = Instance.new("TextLabel")
ksStatusLbl.Size = UDim2.new(1, -24, 0, 20); ksStatusLbl.Position = UDim2.new(0, 12, 0, 164)
ksStatusLbl.BackgroundTransparency = 1; ksStatusLbl.Text = ""
ksStatusLbl.TextColor3 = Color3.fromRGB(255, 70, 70); ksStatusLbl.TextSize = 11
ksStatusLbl.Font = Enum.Font.Gotham; ksStatusLbl.TextXAlignment = Enum.TextXAlignment.Center
ksStatusLbl.ZIndex = 4; ksStatusLbl.Parent = ksBody

-- Auth success label
local ksAuthLbl = Instance.new("Frame")
ksAuthLbl.Size = UDim2.new(1, -24, 0, 38); ksAuthLbl.Position = UDim2.new(0, 12, 0, 118)
ksAuthLbl.BackgroundColor3 = Color3.fromRGB(34, 160, 60)
ksAuthLbl.BackgroundTransparency = 1; ksAuthLbl.ZIndex = 4; ksAuthLbl.Parent = ksBody
ksAuthLbl.Visible = false
Instance.new("UICorner", ksAuthLbl).CornerRadius = UDim.new(0, 8)

local ksAuthText = Instance.new("TextLabel")
ksAuthText.Size = UDim2.new(1, 0, 1, 0); ksAuthText.BackgroundTransparency = 1
ksAuthText.Text = "✓  Authenticated"; ksAuthText.TextColor3 = Color3.new(1, 1, 1)
ksAuthText.TextSize = 14; ksAuthText.Font = Enum.Font.GothamBold
ksAuthText.ZIndex = 5; ksAuthText.Parent = ksAuthLbl

-- Key submit logic
-- Helper: launch the main GUI after successful auth
local function _showMainGui()
    wrapper.Visible = true
    wrapper.Size = UDim2.new(0, 0, 0, 0)
    wrapper.Position = UDim2.new(0.5, 0, 1.5, 0)
    sidebar.Size = UDim2.new(0, 0, 1, 0)
    mainPanel.Size = UDim2.new(0, 0, 1, 0)
    navbar.Size = UDim2.new(1, 0, 0, 0)
    openSound:Play()
    TweenService:Create(wrapper, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Size = UDim2.new(0, UI_W, 0, UI_H), Position = UDim2.new(0.5, -UI_W/2, 0.5, -UI_H/2) }):Play()
    task.delay(0.28, function()
        TweenService:Create(navbar, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            { Size = UDim2.new(1, 0, 0, NAV_H) }):Play()
    end)
    task.delay(0.38, function()
        TweenService:Create(sidebar, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            { Size = UDim2.new(0, SIDE_W, 1, 0) }):Play()
    end)
    task.delay(0.52, function()
        TweenService:Create(mainPanel, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            { Size = UDim2.new(0, MAIN_W, 1, 0) }):Play()
        task.delay(0.2, function() switchTab("Home") end)
    end)
end

local function doTryKey()
    local entered = ksKeyBox.Text:gsub("%s+", "")

    -- ── PERMANENT KEY ────────────────────────────────────────
    if entered == PERM_KEY then
        ksStatusLbl.Text = ""
        ksSubmitBtn.Visible = false
        ksInputBg.Visible = false

        -- Show special permanent access label
        local permLbl = Instance.new("TextLabel")
        permLbl.Size = UDim2.new(1,-24,0,42); permLbl.Position = UDim2.new(0,12,0,116)
        permLbl.BackgroundColor3 = Color3.fromRGB(80,0,180)
        permLbl.BackgroundTransparency = 0
        permLbl.Text = "👑  Granted Permanent Access"
        permLbl.TextColor3 = Color3.new(1,1,1); permLbl.TextSize = 14
        permLbl.Font = Enum.Font.GothamBold
        permLbl.TextXAlignment = Enum.TextXAlignment.Center
        permLbl.ZIndex = 4; permLbl.Parent = ksBody
        Instance.new("UICorner", permLbl).CornerRadius = UDim.new(0,8)

        -- Purple glow pulse on the label
        TweenService:Create(permLbl, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 2, true),
            { BackgroundColor3 = Color3.fromRGB(140,0,255) }):Play()

        task.wait(1.6)
        starActive = false
        local fo = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        TweenService:Create(ksOverlay, fo, { BackgroundTransparency = 1 }):Play()
        TweenService:Create(ksCard,    fo, { BackgroundTransparency = 1 }):Play()
        for _, d in ipairs(ksCard:GetDescendants()) do
            if d:IsA("TextLabel") or d:IsA("TextButton") then TweenService:Create(d, fo, { TextTransparency = 1 }):Play() end
            if d:IsA("Frame") then TweenService:Create(d, fo, { BackgroundTransparency = 1 }):Play() end
        end
        task.wait(0.5); keyGui:Destroy()
        _showMainGui()
        return
    end

    -- ── TEMPORARY KEY (2-day expiry) ─────────────────────────
    if entered == VALID_KEY then
        -- Check if already expired
        if isKeyExpired() then
            ksStatusLbl.Text = "✗  Key expired (2-day limit reached)."
            ksStatusLbl.TextColor3 = Color3.fromRGB(255, 60, 60)
            TweenService:Create(ksInputBg, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(60,10,10) }):Play()
            task.wait(0.3)
            TweenService:Create(ksInputBg, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(28,28,34) }):Play()
            return
        end

        -- Set expiry on first use (if not already set)
        if not getStoredExpiry() or getStoredExpiry() == 0 then
            setStoredExpiry(os.time() + KEY_DURATION)
        end

        ksStatusLbl.Text = ""
        ksSubmitBtn.Visible = false
        ksInputBg.Visible = false
        ksAuthLbl.Visible = true
        TweenService:Create(ksAuthLbl, TweenInfo.new(0.3), { BackgroundTransparency = 0 }):Play()

        task.wait(1.2)
        starActive = false
        local fo = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        TweenService:Create(ksOverlay, fo, { BackgroundTransparency = 1 }):Play()
        TweenService:Create(ksCard,    fo, { BackgroundTransparency = 1 }):Play()
        for _, d in ipairs(ksCard:GetDescendants()) do
            if d:IsA("TextLabel") or d:IsA("TextButton") then TweenService:Create(d, fo, { TextTransparency = 1 }):Play() end
            if d:IsA("Frame") then TweenService:Create(d, fo, { BackgroundTransparency = 1 }):Play() end
        end
        task.wait(0.5); keyGui:Destroy()
        _showMainGui()
    else
        ksStatusLbl.Text = "✗  Invalid key. Try again."
        TweenService:Create(ksInputBg, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(60,10,10) }):Play()
        task.wait(0.3)
        TweenService:Create(ksInputBg, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(28,28,34) }):Play()
    end
end

ksSubmitBtn.MouseButton1Click:Connect(doTryKey)
ksKeyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then doTryKey() end
end)

-- ── GLITCH PURPLE STARS ──────────────────────────────────────
-- Spawn floating ★ symbols that glitch in colour and position behind the card
local starActive = true
local STAR_COLORS = {
    Color3.fromRGB(180, 0, 255),
    Color3.fromRGB(210, 80, 255),
    Color3.fromRGB(255, 0, 200),
    Color3.fromRGB(140, 0, 255),
    Color3.fromRGB(255, 100, 255),
    Color3.fromRGB(100, 0, 200),
}

local function spawnStar()
    local star = Instance.new("TextLabel")
    star.Size              = UDim2.new(0, 24, 0, 24)
    star.BackgroundTransparency = 1
    star.Text              = "★"
    star.TextSize          = math.random(14, 28)
    star.Font              = Enum.Font.GothamBold
    star.TextColor3        = STAR_COLORS[math.random(#STAR_COLORS)]
    star.TextTransparency  = 0
    star.ZIndex            = 1  -- behind card (card is ZIndex 2)
    -- Random position across the full screen
    star.Position = UDim2.new(
        math.random(0, 100) / 100, 0,
        math.random(0, 100) / 100, 0
    )
    star.Parent = keyGui

    -- Glitch loop for this star: random colour flicker + jitter
    task.spawn(function()
        while star.Parent and starActive do
            -- Colour glitch
            star.TextColor3 = STAR_COLORS[math.random(#STAR_COLORS)]

            -- Random jitter in position
            local jx = math.random(-6, 6)
            local jy = math.random(-6, 6)
            local baseX = star.Position.X.Scale
            local baseY = star.Position.Y.Scale
            star.Position = UDim2.new(baseX, jx, baseY, jy)

            -- Occasionally flash transparent
            if math.random(1, 4) == 1 then
                star.TextTransparency = 0.7
                task.wait(0.05)
                star.TextTransparency = 0
            end

            -- Slow float upward
            TweenService:Create(star,
                TweenInfo.new(math.random(4, 9), Enum.EasingStyle.Linear),
                { Position = UDim2.new(baseX, jx, baseY - 0.15, jy) }
            ):Play()

            task.wait(math.random(8, 20) / 100)
        end
        if star.Parent then star:Destroy() end
    end)

    -- Auto destroy after lifetime
    local lifetime = math.random(5, 12)
    task.delay(lifetime, function()
        if star.Parent then
            TweenService:Create(star, TweenInfo.new(0.5), { TextTransparency = 1 }):Play()
            task.wait(0.5)
            pcall(function() star:Destroy() end)
        end
    end)
end

-- Spawn initial batch of stars
task.spawn(function()
    for _ = 1, 25 do
        spawnStar()
        task.wait(0.08)
    end
    -- Keep spawning new stars while key GUI is open
    while starActive and keyGui.Parent do
        task.wait(math.random(3, 7) / 10)
        spawnStar()
    end
end)

-- Stop spawning stars when key GUI is destroyed
keyGui.AncestryChanged:Connect(function()
    if not keyGui.Parent then
        starActive = false
    end
end)

-- Animate card open sequence
task.spawn(function()
    TweenService:Create(ksCard, TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Size = UDim2.new(0, 320, 0, 200) }):Play()
    task.wait(0.5)
    TweenService:Create(ksCheckLbl, TweenInfo.new(0.3), { TextTransparency = 0 }):Play()
    task.wait(1.2)
    ksCheckLbl.Text = "✓  Connected to Soul's Gui"
    ksCheckLbl.TextColor3 = Color3.fromRGB(80, 220, 100)
    TweenService:Create(ksWhitelistLbl, TweenInfo.new(0.3), { TextTransparency = 0 }):Play()
    task.wait(0.4)
    TweenService:Create(ksInputBg,   TweenInfo.new(0.25), {}):Play()
    TweenService:Create(ksSubmitBtn, TweenInfo.new(0.25), {}):Play()
    ksKeyBox:CaptureFocus()
end)
