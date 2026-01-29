local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local Lighting = game:GetService("Lighting")
local MarketplaceService = game:GetService("MarketplaceService")

local FOLDER_NAME = "NEBULA Script"
local FILE_NAME = "Settings.json"
local FULL_PATH = FOLDER_NAME .. "/" .. FILE_NAME

if _G.DefaultWalkSpeed == nil then
    _G.DefaultWalkSpeed = 16
    task.spawn(function()
        local char = Player.Character or Player.CharacterAdded:Wait()
        local hum = char:WaitForChild("Humanoid", 10)
        if hum then
            _G.DefaultWalkSpeed = hum.WalkSpeed
            _G.DefaultJumpPower = hum.JumpPower
        end
    end)
end

if _G.DefaultJumpPower == nil then
    _G.DefaultJumpPower = 50
end

if _G.OriginalAmbient == nil then _G.OriginalAmbient = Lighting.Ambient end
if _G.OriginalBrightness == nil then _G.OriginalBrightness = Lighting.Brightness end
if _G.OriginalClockTime == nil then _G.OriginalClockTime = Lighting.ClockTime end
if _G.OriginalFogStart == nil then _G.OriginalFogStart = Lighting.FogStart end
if _G.OriginalFogEnd == nil then _G.OriginalFogEnd = Lighting.FogEnd end

local Settings = {}

Settings.MenuKey = "RightControl"
Settings.FlightSpeed = 3
Settings.WalkSpeed = 16
Settings.JumpPower = 50
Settings.QuickFlyPos = nil
Settings.QuickNoclipPos = nil
Settings.CurrentTheme = "Cyan"

local Themes = {
    Cyan = {
        MainBg = Color3.fromRGB(20, 20, 20),
        SidebarBg = Color3.fromRGB(25, 25, 30),
        ContentBg = Color3.fromRGB(32, 32, 36),
        Accent = Color3.fromRGB(0, 160, 255),
        TextPrimary = Color3.fromRGB(245, 245, 245),
        TextSecondary = Color3.fromRGB(180, 180, 180),
        Outline = Color3.fromRGB(50, 50, 60),
        ItemHover = Color3.fromRGB(40, 40, 50),
        Red = Color3.fromRGB(255, 75, 75),
        Green = Color3.fromRGB(75, 255, 120),
        Yellow = Color3.fromRGB(255, 200, 50)
    },
    Red = {
        MainBg = Color3.fromRGB(20, 20, 20),
        SidebarBg = Color3.fromRGB(30, 25, 25),
        ContentBg = Color3.fromRGB(36, 32, 32),
        Accent = Color3.fromRGB(255, 60, 60),
        TextPrimary = Color3.fromRGB(255, 245, 245),
        TextSecondary = Color3.fromRGB(180, 150, 150),
        Outline = Color3.fromRGB(60, 50, 50),
        ItemHover = Color3.fromRGB(50, 40, 40),
        Red = Color3.fromRGB(255, 75, 75),
        Green = Color3.fromRGB(75, 255, 120),
        Yellow = Color3.fromRGB(255, 200, 50)
    },
    Green = {
        MainBg = Color3.fromRGB(20, 20, 20),
        SidebarBg = Color3.fromRGB(25, 30, 25),
        ContentBg = Color3.fromRGB(32, 36, 32),
        Accent = Color3.fromRGB(60, 255, 100),
        TextPrimary = Color3.fromRGB(245, 255, 245),
        TextSecondary = Color3.fromRGB(150, 180, 150),
        Outline = Color3.fromRGB(50, 60, 50),
        ItemHover = Color3.fromRGB(40, 50, 40),
        Red = Color3.fromRGB(255, 75, 75),
        Green = Color3.fromRGB(75, 255, 120),
        Yellow = Color3.fromRGB(255, 200, 50)
    },
    Purple = {
        MainBg = Color3.fromRGB(20, 20, 20),
        SidebarBg = Color3.fromRGB(28, 25, 30),
        ContentBg = Color3.fromRGB(34, 32, 36),
        Accent = Color3.fromRGB(170, 0, 255),
        TextPrimary = Color3.fromRGB(250, 245, 255),
        TextSecondary = Color3.fromRGB(170, 160, 180),
        Outline = Color3.fromRGB(55, 50, 60),
        ItemHover = Color3.fromRGB(45, 40, 50),
        Red = Color3.fromRGB(255, 75, 75),
        Green = Color3.fromRGB(75, 255, 120),
        Yellow = Color3.fromRGB(255, 200, 50)
    },
    Orange = {
        MainBg = Color3.fromRGB(20, 20, 20),
        SidebarBg = Color3.fromRGB(30, 28, 25),
        ContentBg = Color3.fromRGB(36, 34, 32),
        Accent = Color3.fromRGB(255, 140, 0),
        TextPrimary = Color3.fromRGB(255, 250, 245),
        TextSecondary = Color3.fromRGB(180, 170, 160),
        Outline = Color3.fromRGB(60, 55, 50),
        ItemHover = Color3.fromRGB(50, 45, 40),
        Red = Color3.fromRGB(255, 75, 75),
        Green = Color3.fromRGB(75, 255, 120),
        Yellow = Color3.fromRGB(255, 200, 50)
    },
    Midnight = {
        MainBg = Color3.fromRGB(10, 10, 15),
        SidebarBg = Color3.fromRGB(15, 15, 20),
        ContentBg = Color3.fromRGB(20, 20, 25),
        Accent = Color3.fromRGB(100, 100, 255),
        TextPrimary = Color3.fromRGB(200, 200, 255),
        TextSecondary = Color3.fromRGB(120, 120, 160),
        Outline = Color3.fromRGB(30, 30, 50),
        ItemHover = Color3.fromRGB(25, 25, 40),
        Red = Color3.fromRGB(255, 75, 75),
        Green = Color3.fromRGB(75, 255, 120),
        Yellow = Color3.fromRGB(255, 200, 50)
    },
    Synapse = {
        MainBg = Color3.fromRGB(40, 40, 40),
        SidebarBg = Color3.fromRGB(50, 50, 50),
        ContentBg = Color3.fromRGB(45, 45, 45),
        Accent = Color3.fromRGB(255, 255, 255),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 200, 200),
        Outline = Color3.fromRGB(70, 70, 70),
        ItemHover = Color3.fromRGB(60, 60, 60),
        Red = Color3.fromRGB(255, 75, 75),
        Green = Color3.fromRGB(75, 255, 120),
        Yellow = Color3.fromRGB(255, 200, 50)
    }
}

local function saveSettings()
    pcall(function()
        if not isfolder(FOLDER_NAME) then
            makefolder(FOLDER_NAME)
        end
        local json = HttpService:JSONEncode(Settings)
        writefile(FULL_PATH, json)
    end)
end

local function loadSettings()
    pcall(function()
        if isfile(FULL_PATH) then
            local json = readfile(FULL_PATH)
            local loaded = HttpService:JSONDecode(json)
            for k, v in pairs(loaded) do
                Settings[k] = v
            end
        end
    end)
end

loadSettings()

local Theme = Themes[Settings.CurrentTheme] or Themes.Cyan
local GUI_NAME = "NEBULA_Script_Rel_V2.9_Info"
local NotificationLayout

local function AddStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Theme.Outline
    stroke.Thickness = thickness or 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

local function SendNotification(text, color)
    if not NotificationLayout then return end
    
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 250, 0, 40)
    container.BackgroundColor3 = Theme.SidebarBg
    container.BackgroundTransparency = 1
    container.Parent = NotificationLayout.Parent
    
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 1, 0)
    content.Position = UDim2.new(1, 10, 0, 0) 
    content.BackgroundColor3 = Theme.SidebarBg
    content.Parent = container
    Instance.new("UICorner", content).CornerRadius = UDim.new(0, 6)
    AddStroke(content, color or Theme.Accent, 1)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Theme.TextPrimary
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = content
    
    TweenService:Create(content, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    
    task.spawn(function()
        task.wait(3)
        TweenService:Create(content, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1, 20, 0, 0)}):Play()
        task.wait(0.5)
        container:Destroy()
    end)
end

local function createLayout(parent)
    local layout = Instance.new("UIListLayout")
    layout.Parent = parent
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    return layout
end

local function createToggleSwitch(parent, text, callback, externalControl, noSave)
    local toggleObj = {}
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0.96, 0, 0, 36)
    container.BackgroundColor3 = Theme.ContentBg
    container.Parent = parent
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)
    AddStroke(container, Theme.Outline, 1)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0.05, 0, 0, 0)
    label.Text = text
    label.TextColor3 = Theme.TextPrimary
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.BackgroundTransparency = 1
    label.Parent = container

    local switchBg = Instance.new("TextButton")
    switchBg.Size = UDim2.new(0, 36, 0, 18)
    switchBg.Position = UDim2.new(1, -45, 0.5, -9)
    switchBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    switchBg.Text = ""
    switchBg.AutoButtonColor = false
    switchBg.Parent = container
    Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 14, 0, 14)
    circle.Position = UDim2.new(0, 2, 0.5, -7)
    circle.BackgroundColor3 = Theme.TextPrimary
    circle.Parent = switchBg
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local isOn = false
    local function updateVisuals()
        local targetPos = isOn and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        local targetColor = isOn and Theme.Accent or Color3.fromRGB(60, 60, 60)
        
        TweenService:Create(circle, TweenInfo.new(0.2), {Position = targetPos}):Play()
        TweenService:Create(switchBg, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
    end

    switchBg.MouseButton1Click:Connect(function()
        isOn = not isOn
        updateVisuals()
        task.spawn(function() callback(isOn) end)
        if not noSave then
            Settings[text] = isOn
            saveSettings()
        end
    end)

    function toggleObj:SetState(state)
        if isOn ~= state then
            isOn = state
            updateVisuals()
            if not externalControl then task.spawn(function() callback(isOn) end) end
            if not noSave then
                Settings[text] = isOn
                saveSettings()
            end
        end
    end

    if not noSave and Settings[text] ~= nil then
        isOn = Settings[text]
        updateVisuals()
        if not externalControl then task.spawn(function() callback(isOn) end) end
    end
    return toggleObj
end

local function createSlider(parent, text, minVal, maxVal, defaultVal, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0.96, 0, 0, 48)
    container.BackgroundColor3 = Theme.ContentBg
    container.Parent = parent
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)
    AddStroke(container, Theme.Outline, 1)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 2)
    label.Text = text
    label.TextColor3 = Theme.TextPrimary
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.BackgroundTransparency = 1
    label.Parent = container

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(1, 0, 0, 20)
    valueLabel.Position = UDim2.new(0, -10, 0, 2)
    valueLabel.Text = tostring(defaultVal)
    valueLabel.TextColor3 = Theme.Accent
    valueLabel.TextXAlignment = Enum.TextXAlignment. Right
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 12
    valueLabel.BackgroundTransparency = 1
    valueLabel.Parent = container

    local sliderBg = Instance.new("TextButton")
    sliderBg.Size = UDim2.new(0.92, 0, 0, 4)
    sliderBg.Position = UDim2.new(0.04, 0, 0.7, 0)
    sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sliderBg.Text = ""
    sliderBg.AutoButtonColor = false
    sliderBg.Parent = container
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)

    local sliderFill = Instance.new("Frame")
    sliderFill.BackgroundColor3 = Theme.Accent
    sliderFill.Parent = sliderBg
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)

    local draggingSlider = false
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local val = math.floor(minVal + ((maxVal - minVal) * pos))
        
        TweenService:Create(sliderFill, TweenInfo.new(0.1), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
        valueLabel.Text = tostring(val)
        
        if Settings[text] ~= val then
            Settings[text] = val
            saveSettings()
            callback(val)
        end
    end

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = true
            updateSlider(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = false
        end
    end)

    local currentVal = Settings[text] or defaultVal
    local startPercent = (currentVal - minVal) / (maxVal - minVal)
    sliderFill.Size = UDim2.new(startPercent, 0, 1, 0)
    valueLabel.Text = tostring(currentVal)
end

local function createButton(parent, text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.96, 0, 0, 38)
    btn.BackgroundColor3 = Theme.ContentBg
    btn.Text = text
    btn.TextColor3 = color or Theme.TextPrimary
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.AutoButtonColor = false
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local stroke = AddStroke(btn, Theme.Outline, 1)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ItemHover}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = color or Theme.Accent}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ContentBg}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Theme.Outline}):Play()
    end)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createTextBox(parent, placeholder, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0.96, 0, 0, 38)
    container.BackgroundColor3 = Theme.ContentBg
    container.Parent = parent
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)
    AddStroke(container, Theme.Outline, 1)

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.95, 0, 1, 0)
    box.Position = UDim2.new(0.025, 0, 0, 0)
    box.BackgroundTransparency = 1
    box.Text = ""
    box.PlaceholderText = placeholder
    box.PlaceholderColor3 = Theme.TextSecondary
    box.TextColor3 = Theme.TextPrimary
    box.Font = Enum.Font.Gotham
    box.TextSize = 13
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.Parent = container

    box.FocusLost:Connect(function(enterPressed)
        if callback then callback(box.Text) end
    end)
    return box
end

local function createConfirmation(parent, text, onYes)
    local screen = Instance.new("Frame")
    screen.Size = UDim2.new(1, 0, 1, 0)
    screen.BackgroundTransparency = 0.7 
    screen.BackgroundColor3 = Color3.new(0,0,0)
    screen.ZIndex = 200
    screen.Parent = parent.Parent.Parent 

    local popup = Instance.new("Frame")
    popup.Size = UDim2.new(0, 300, 0, 150)
    popup.Position = UDim2.new(0.5, -150, 0.5, -75)
    popup.BackgroundColor3 = Theme.MainBg
    popup.Parent = screen
    Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 10)
    AddStroke(popup, Theme.Accent, 2)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0.6, 0)
    label.Position = UDim2.new(0, 10, 0, 10)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Theme.TextPrimary
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextWrapped = true
    label.Parent = popup

    local yesBtn = Instance.new("TextButton")
    yesBtn.Size = UDim2.new(0.4, 0, 0, 35)
    yesBtn.Position = UDim2.new(0.05, 0, 0.7, 0)
    yesBtn.BackgroundColor3 = Theme.ContentBg
    yesBtn.Text = "✅ Yes"
    yesBtn.TextColor3 = Theme.Red
    yesBtn.Font = Enum.Font.GothamBold
    yesBtn.Parent = popup
    Instance.new("UICorner", yesBtn).CornerRadius = UDim.new(0, 6)
    
    local noBtn = Instance.new("TextButton")
    noBtn.Size = UDim2.new(0.4, 0, 0, 35)
    noBtn.Position = UDim2.new(0.55, 0, 0.7, 0)
    noBtn.BackgroundColor3 = Theme.ContentBg
    noBtn.Text = "❌ No"
    noBtn.TextColor3 = Theme.Green
    noBtn.Font = Enum.Font.GothamBold
    noBtn.Parent = popup
    Instance.new("UICorner", noBtn).CornerRadius = UDim.new(0, 6)

    yesBtn.MouseButton1Click:Connect(function()
        onYes()
        screen:Destroy()
    end)
    noBtn.MouseButton1Click:Connect(function()
        screen:Destroy()
    end)
end

local oldScript = _G.NOVA_Cleanup
if oldScript then pcall(oldScript) end

local Connections = {}
local function AddConnection(conn)
    table.insert(Connections, conn)
    return conn
end

local ScreenGui

local function Cleanup()
    _G.NEBULA_Cleanup = nil
    
    pcall(function()
        local cam = workspace.CurrentCamera
        cam.CameraSubject = Player.Character:FindFirstChild("Humanoid")
        cam.CameraType = Enum.CameraType.Custom
        Lighting.Ambient = _G.OriginalAmbient or Lighting.Ambient
        Lighting.Brightness = _G.OriginalBrightness or Lighting.Brightness
        Lighting.ClockTime = _G.OriginalClockTime or Lighting.ClockTime
        Lighting.FogStart = _G.OriginalFogStart or Lighting.FogStart
        Lighting.FogEnd = _G.OriginalFogEnd or Lighting.FogEnd

        if Player.Character then
            local hum = Player.Character:FindFirstChild("Humanoid")
            if hum then
                hum.WalkSpeed = _G.DefaultWalkSpeed or 16
                hum.JumpPower = _G.DefaultJumpPower or 50
                hum.PlatformStand = false
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
            local root = Player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                for _, v in pairs(root:GetChildren()) do
                    if v.Name == "NEBULA_BodyGyro" or v.Name == "NEBULA_BodyVel" or v.Name == "NEBULA_Spin" then
                        v:Destroy()
                    end
                end
            end
            
            for _, part in ipairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end)

    for _, conn in ipairs(Connections) do
        if conn and conn.Connected then conn:Disconnect() end
    end
    table.clear(Connections)
    
    if PlayerGui:FindFirstChild(GUI_NAME) then
        PlayerGui[GUI_NAME]:Destroy()
    end
end
_G.NOVA_Cleanup = Cleanup

local function BuildInterface(isReload)
    if PlayerGui:FindFirstChild(GUI_NAME) then PlayerGui[GUI_NAME]:Destroy() end
    
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = GUI_NAME
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true 
    ScreenGui.Parent = PlayerGui

    local NotifContainer = Instance.new("Frame")
    NotifContainer.Size = UDim2.new(1, 0, 1, 0)
    NotifContainer.Position = UDim2.new(0, 0, 0.05, 0)
    NotifContainer.BackgroundTransparency = 1
    NotifContainer.ZIndex = 20000
    NotifContainer.Parent = ScreenGui
    
    NotificationLayout = Instance.new("UIListLayout")
    NotificationLayout.Parent = NotifContainer
    NotificationLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NotificationLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    NotificationLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    NotificationLayout.Padding = UDim.new(0, 5)

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "OpenButton"
    ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
    ToggleBtn.Position = Settings.ToggleBtnPos and UDim2.new(Settings.ToggleBtnPos.X, Settings.ToggleBtnPos.XOff, Settings.ToggleBtnPos.Y, Settings.ToggleBtnPos.YOff) or UDim2.new(0.01, 0, 0.45, 0)
    ToggleBtn.BackgroundColor3 = Theme.SidebarBg
    ToggleBtn.Text = "N" 
    ToggleBtn.TextColor3 = Theme.Accent
    ToggleBtn.Font = Enum.Font.GothamBlack
    ToggleBtn.TextSize = 30
    ToggleBtn.Draggable = true
    ToggleBtn.Parent = ScreenGui
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 14)
    AddStroke(ToggleBtn, Theme.Accent, 2)

    local QuickFlyBtn = Instance.new("TextButton")
    QuickFlyBtn.Name = "QuickFlyButton"
    QuickFlyBtn.Size = UDim2.new(0, 50, 0, 50)
    QuickFlyBtn.Position = Settings.QuickFlyPos and UDim2.new(Settings.QuickFlyPos.X, Settings.QuickFlyPos.XOff, Settings.QuickFlyPos.Y, Settings.QuickFlyPos.YOff) or UDim2.new(0.01, 0, 0.55, 0)
    QuickFlyBtn.BackgroundColor3 = Theme.SidebarBg
    QuickFlyBtn.Text = "FLY" 
    QuickFlyBtn.TextColor3 = Theme.Accent
    QuickFlyBtn.Font = Enum.Font.GothamBlack
    QuickFlyBtn.TextSize = 16
    QuickFlyBtn.Visible = false
    QuickFlyBtn.Draggable = true
    QuickFlyBtn.Parent = ScreenGui
    Instance.new("UICorner", QuickFlyBtn).CornerRadius = UDim.new(0, 14)
    local QuickFlyStroke = AddStroke(QuickFlyBtn, Theme.Accent, 2)

    local QuickNoclipBtn = Instance.new("TextButton")
    QuickNoclipBtn.Name = "QuickNoclipButton"
    QuickNoclipBtn.Size = UDim2.new(0, 50, 0, 50)
    QuickNoclipBtn.Position = Settings.QuickNoclipPos and UDim2.new(Settings.QuickNoclipPos.X, Settings.QuickNoclipPos.XOff, Settings.QuickNoclipPos.Y, Settings.QuickNoclipPos.YOff) or UDim2.new(0.01, 0, 0.65, 0)
    QuickNoclipBtn.BackgroundColor3 = Theme.SidebarBg
    QuickNoclipBtn.Text = "NoClip" 
    QuickNoclipBtn.TextColor3 = Theme.Accent
    QuickNoclipBtn.Font = Enum.Font.GothamBlack
    QuickNoclipBtn.TextSize = 12
    QuickNoclipBtn.Visible = false
    QuickNoclipBtn.Draggable = true
    QuickNoclipBtn.Parent = ScreenGui
    Instance.new("UICorner", QuickNoclipBtn).CornerRadius = UDim.new(0, 14)
    local QuickNoclipStroke = AddStroke(QuickNoclipBtn, Theme.Accent, 2)

    local function saveBtnPos()
        Settings.ToggleBtnPos = {X = ToggleBtn.Position.X.Scale, XOff = ToggleBtn.Position.X.Offset, Y = ToggleBtn.Position.Y.Scale, YOff = ToggleBtn.Position.Y.Offset}
        Settings.QuickFlyPos = {X = QuickFlyBtn.Position.X.Scale, XOff = QuickFlyBtn.Position.X.Offset, Y = QuickFlyBtn.Position.Y.Scale, YOff = QuickFlyBtn.Position.Y.Offset}
        Settings.QuickNoclipPos = {X = QuickNoclipBtn.Position.X.Scale, XOff = QuickNoclipBtn.Position.X.Offset, Y = QuickNoclipBtn.Position.Y.Scale, YOff = QuickNoclipBtn.Position.Y.Offset}
        saveSettings()
    end
    AddConnection(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            saveBtnPos()
        end
    end))

    local BlackScreen = Instance.new("TextButton")
    BlackScreen.Name = "BlackScreenFrame"
    BlackScreen.Size = UDim2.new(1, 0, 1, 0)
    BlackScreen.BackgroundColor3 = Color3.new(0, 0, 0) 
    BlackScreen.ZIndex = 10000 
    BlackScreen.AutoButtonColor = false
    BlackScreen.Text = ""
    BlackScreen.Active = true
    BlackScreen.Visible = false
    BlackScreen.Parent = ScreenGui

    local CloseX = Instance.new("TextButton")
    CloseX.Name = "CloseButton"
    CloseX.Size = UDim2.new(0, 30, 0, 30)
    CloseX.Position = UDim2.new(1, -40, 0, 10)
    CloseX.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    CloseX.Text = "✖️"
    CloseX.TextColor3 = Theme.Red
    CloseX.Font = Enum.Font.GothamBold
    CloseX.TextSize = 18
    CloseX.ZIndex = 10001
    CloseX.Parent = BlackScreen
    Instance.new("UICorner", CloseX).CornerRadius = UDim.new(0, 5)
    AddStroke(CloseX, Theme.Red, 1)

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 450, 0, 300)
    MainFrame.Position = Settings.MainFramePos and UDim2.new(Settings.MainFramePos.X, Settings.MainFramePos.XOff, Settings.MainFramePos.Y, Settings.MainFramePos.YOff) or UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.BackgroundColor3 = Theme.MainBg
    MainFrame.Visible = false
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
    AddStroke(MainFrame, Theme.Outline, 1.5)

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "CloseButton"
    CloseBtn.Size = UDim2.new(0, 20, 0, 20)
    CloseBtn.Position = UDim2.new(1, -21, 0.5, -149)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "⛔"
    CloseBtn.TextColor3 = Theme.Red
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 18
    CloseBtn.ZIndex = 11
    CloseBtn.Parent = MainFrame
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)
    
    CloseBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
    end)

    local SideBar = Instance.new("Frame")
    SideBar.Size = UDim2.new(0.25, 0, 1, 0)
    SideBar.BackgroundColor3 = Theme.SidebarBg
    SideBar.Parent = MainFrame
    Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0, 10)

    local dragging, dragInput, dragStart, startPos
    local function updateDrag(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        Settings.MainFramePos = {X = MainFrame.Position.X.Scale, XOff = MainFrame.Position.X.Offset, Y = MainFrame.Position.Y.Scale, YOff = MainFrame.Position.Y.Offset}
        saveSettings()
    end
    SideBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    SideBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then updateDrag(input) end
    end)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, 0, 0, 60)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "NOVA"
    TitleLabel.TextColor3 = Theme.Accent
    TitleLabel.Font = Enum.Font.GothamBlack
    TitleLabel.TextSize = 26
    TitleLabel.Parent = SideBar
    local SubTitle = Instance.new("TextLabel")
    SubTitle.Size = UDim2.new(1, 0, 0, 20)
    SubTitle.Position = UDim2.new(0,0,0,35)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = "🚀 Ultimate V1.0"
    SubTitle.TextColor3 = Theme.TextSecondary
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.TextSize = 10
    SubTitle.Parent = TitleLabel

    local TabButtonsContainer = Instance.new("ScrollingFrame")
    TabButtonsContainer.Size = UDim2.new(1, 0, 0.8, 0)
    TabButtonsContainer.Position = UDim2.new(0, 0, 0.2, 0)
    TabButtonsContainer.BackgroundTransparency = 1
    TabButtonsContainer.ScrollBarThickness = 0
    TabButtonsContainer.Parent = SideBar
    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Parent = TabButtonsContainer
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 5)
    TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local ContentArea = Instance.new("Frame")
    ContentArea.Size = UDim2.new(0.75, 0, 1, 0)
    ContentArea.Position = UDim2.new(0.25, 0, 0, 0)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainFrame
    local ContentPad = Instance.new("UIPadding")
    ContentPad.PaddingTop = UDim.new(0, 15)
    ContentPad.PaddingBottom = UDim.new(0, 15)
    ContentPad.PaddingLeft = UDim.new(0, 15)
    ContentPad.PaddingRight = UDim.new(0, 15)
    ContentPad.Parent = ContentArea

    local Frames = {}
    local function CreatePage(name)
        local page = Instance.new("ScrollingFrame")
        page.Name = name .. "Frame"
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = Theme.Accent
        page.Parent = ContentArea
        createLayout(page)
        Frames[name] = page
        return page
    end

    local MovementFrame = CreatePage("Movement")
    local VisualsFrame = CreatePage("Visuals")
    local PlayersFrame = CreatePage("Players")
    local AFKFrame = CreatePage("AFK")
    local ServerFrame = CreatePage("Server")
    local InfoFrame = CreatePage("Info")
    local SettingsFrame = CreatePage("Settings")

    local currentTab = nil
    local function SwitchTab(btn, frame)
        if currentTab == btn then return end
        for _, f in pairs(Frames) do f.Visible = false end
        frame.Visible = true
        for _, child in pairs(TabButtonsContainer:GetChildren()) do
            if child:IsA("TextButton") then
                TweenService:Create(child, TweenInfo.new(0.2), {BackgroundColor3 = Theme.SidebarBg, TextColor3 = Theme.TextSecondary}):Play()
                if child:FindFirstChild("Bar") then
                    TweenService:Create(child.Bar, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0.8, 0)}):Play()
                end
            end
        end
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ContentBg, TextColor3 = Theme.TextPrimary}):Play()
        if btn:FindFirstChild("Bar") then
            TweenService:Create(btn.Bar, TweenInfo.new(0.2), {Size = UDim2.new(0, 3, 0.8, 0)}):Play()
        end
        currentTab = btn
    end

    local function CreateTabButton(name, frame)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0, 35)
        btn.BackgroundColor3 = Theme.SidebarBg
        btn.Text = name
        btn.TextColor3 = Theme.TextSecondary
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.AutoButtonColor = false
        btn.Parent = TabButtonsContainer
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        local bar = Instance.new("Frame")
        bar.Name = "Bar"
        bar.Size = UDim2.new(0, 0, 0.8, 0)
        bar.Position = UDim2.new(0, 0, 0.1, 0)
        bar.BackgroundColor3 = Theme.Accent
        bar.BorderSizePixel = 0
        bar.Parent = btn
        Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 2)
        btn.MouseButton1Click:Connect(function() SwitchTab(btn, frame) end)
        return btn
    end

    local Tab1 = CreateTabButton("🏃 Move", MovementFrame)
    local Tab2 = CreateTabButton("👁️ Visuals", VisualsFrame)
    local Tab3 = CreateTabButton("👥 Players", PlayersFrame)
    local Tab4 = CreateTabButton("💤 AFK", AFKFrame)
    local Tab5 = CreateTabButton("🌍 Server", ServerFrame)
    local Tab6 = CreateTabButton("ℹ️ Info", InfoFrame)
    local Tab7 = CreateTabButton("⚙️ Config", SettingsFrame)

    SwitchTab(Tab1, MovementFrame)

    local flyEnabled = false
    local flySpeed = Settings.FlightSpeed or 3
    local flyBodyGyro, flyBodyVel
    local MenuFlySwitch

    local function stopFly()
        if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
        if flyBodyVel then flyBodyVel:Destroy() flyBodyVel = nil end
        if Player.Character then
            local root = Player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                if root:FindFirstChild("NEBULA_BodyGyro") then root.NEBULA_BodyGyro:Destroy() end
                if root:FindFirstChild("NEBULA_BodyVel") then root.NEBULA_BodyVel:Destroy() end
            end
            local hum = Player.Character:FindFirstChild("Humanoid")
            if hum then
                hum.PlatformStand = false
                hum:ChangeState(Enum.HumanoidStateType.GettingUp) 
            end
        end
    end

    local function startFly()
        stopFly()
        local char = Player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")
        if not root or not hum then return end
        
        hum.PlatformStand = true
        
        flyBodyGyro = Instance.new("BodyGyro")
        flyBodyGyro.Name = "NEBULA_BodyGyro"
        flyBodyGyro.P = 9e4
        flyBodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        flyBodyGyro.CFrame = root.CFrame
        flyBodyGyro.Parent = root
        
        flyBodyVel = Instance.new("BodyVelocity")
        flyBodyVel.Name = "NEBULA_BodyVel"
        flyBodyVel.Velocity = Vector3.new(0, 0, 0)
        flyBodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        flyBodyVel.Parent = root

        task.spawn(function()
            while flyEnabled and char and hum.Parent and hum.Health > 0 do
                local cam = workspace.CurrentCamera
                local moveDir = hum.MoveDirection
                
                flyBodyGyro.CFrame = cam.CFrame
                
                if moveDir.Magnitude > 0 then
                    local camCFrame = cam.CFrame
                    local moveRel = camCFrame:VectorToObjectSpace(moveDir)
                    local newVel = (camCFrame.LookVector * -moveRel.Z) + (camCFrame.RightVector * moveRel.X)
                    
                    if newVel.Magnitude > 0 then
                        newVel = newVel.Unit
                    end
                    
                    flyBodyVel.Velocity = newVel * flySpeed * 50
                else
                    flyBodyVel.Velocity = Vector3.new(0, 0, 0)
                end
                RunService.RenderStepped:Wait()
            end
            stopFly()
        end)
    end

    local function toggleFlyFunc(state)
        flyEnabled = state
        local targetColor = state and Theme.Green or Theme.Accent
        QuickFlyBtn.TextColor3 = targetColor
        QuickFlyStroke.Color = targetColor
        
        if MenuFlySwitch then MenuFlySwitch:SetState(state) end
        if state then startFly() else stopFly() end
    end

    QuickFlyBtn.MouseButton1Click:Connect(function()
        toggleFlyFunc(not flyEnabled)
    end)

    local function onCharacterAdded(char)
        local humanoid = char:WaitForChild("Humanoid")
        AddConnection(humanoid.Died:Connect(function()
            if flyEnabled then
                toggleFlyFunc(false) 
            end
        end))
    end

    if Player.Character then onCharacterAdded(Player.Character) end
    AddConnection(Player.CharacterAdded:Connect(onCharacterAdded))

    MenuFlySwitch = createToggleSwitch(MovementFrame, "🛸 Enable Fly", function(state)
        if state ~= flyEnabled then toggleFlyFunc(state) end
    end, true, false)

    createSlider(MovementFrame, "⚡ Flight Speed", 1, 50, 3, function(val)
        flySpeed = val
        Settings.FlightSpeed = val
    end)

    createToggleSwitch(MovementFrame, "🔲 Show Quick Fly Button", function(state)
        QuickFlyBtn.Visible = state
    end)

    local speedEnabled = false
    local jumpEnabled = false
    local currentSpeed = Settings["💨 Speed Value"] or 16
    local currentJump = Settings["⏫ Jump Value"] or 20

    createToggleSwitch(MovementFrame, "👟 Speed Boost", function(state) speedEnabled = state end)
    createSlider(MovementFrame, "💨 Speed Value", 16, 250, 16, function(val) currentSpeed = val end)

    createToggleSwitch(MovementFrame, "🦗 Jump Boost", function(state) jumpEnabled = state end)
    createSlider(MovementFrame, "⏫ Jump Value", 16, 250, 20, function(val) currentJump = val end)

    AddConnection(RunService.Stepped:Connect(function()
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            local hum = Player.Character.Humanoid

            if speedEnabled then 
                hum.WalkSpeed = currentSpeed 
            else
                if hum.WalkSpeed ~= _G.DefaultWalkSpeed then 
                    hum.WalkSpeed = _G.DefaultWalkSpeed 
                end
            end

            if jumpEnabled then 
                hum.UseJumpPower = true
                hum.JumpPower = currentJump * 5
            else
                if hum.JumpPower ~= _G.DefaultJumpPower then 
                    hum.JumpPower = _G.DefaultJumpPower 
                end
            end
        end
    end))

    local noclipEnabled = false
    local MenuNoclipSwitch
    local NoclipConnection = nil

    local function NoclipLoop()
        if Player.Character then
            for _, child in pairs(Player.Character:GetDescendants()) do
                if child:IsA("BasePart") and child.CanCollide == true then
                    child.CanCollide = false
                end
            end
        end
    end

    local function toggleNoclipFunc(state)
        noclipEnabled = state
        local targetColor = state and Theme.Green or Theme.Accent
        QuickNoclipBtn.TextColor3 = targetColor
        QuickNoclipStroke.Color = targetColor
        
        if MenuNoclipSwitch then MenuNoclipSwitch:SetState(state) end
        
        if state then
            NoclipConnection = RunService.Stepped:Connect(NoclipLoop)
        else
            if NoclipConnection then NoclipConnection:Disconnect() end
            if Player.Character then
                local hum = Player.Character:FindFirstChild("Humanoid")
                if hum then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
            end
        end
    end

    QuickNoclipBtn.MouseButton1Click:Connect(function()
        toggleNoclipFunc(not noclipEnabled)
    end)

    MenuNoclipSwitch = createToggleSwitch(MovementFrame, "👻 Noclip (Ghost Mode)", function(state)
        if state ~= noclipEnabled then toggleNoclipFunc(state) end
    end, true, false)

    createToggleSwitch(MovementFrame, "🔲 Show Quick Noclip", function(state)
        QuickNoclipBtn.Visible = state
    end)

    createToggleSwitch(MovementFrame, "♾️ Infinite Jump", function(state)
        _G.InfJump = state
    end)

    AddConnection(UserInputService.JumpRequest:Connect(function()
        if _G.InfJump and Player.Character then
            Player.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
        end
    end))

    local espEnabled = false
    local function createESP(player)
        if player == Player then return end
        local folder = Instance.new("Folder")
        folder.Name = player.Name .. "_ESP"
        local function updater()
            local char = player.Character
            if not char or not espEnabled then 
                folder:ClearAllChildren()
                return 
            end
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                if not folder:FindFirstChild("Highlight") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "Highlight"
                    hl.Adornee = char
                    hl.FillColor = Theme.Red
                    hl.OutlineColor = Color3.new(1,1,1)
                    hl.FillTransparency = 0.5
                    hl.Parent = folder
                end
                local bill = folder:FindFirstChild("BillboardGui") or Instance.new("BillboardGui")
                bill.Name = "BillboardGui"
                bill.AlwaysOnTop = true
                bill.Size = UDim2.new(0, 100, 0, 40)
                bill.Adornee = root
                bill.Parent = folder
                local txt = bill:FindFirstChild("TextLabel") or Instance.new("TextLabel")
                txt.Size = UDim2.new(1,0,1,0)
                txt.BackgroundTransparency = 1
                txt.TextColor3 = Theme.TextPrimary
                txt.TextStrokeTransparency = 0
                txt.Font = Enum.Font.GothamBold
                txt.TextSize = 12
                txt.Parent = bill
                local dist = math.floor((Player.Character.HumanoidRootPart.Position - root.Position).Magnitude)
                txt.Text = player.Name .. "\n[" .. dist .. "m]"
                if not folder.Parent then folder.Parent = ScreenGui end
            end
        end
        AddConnection(RunService.RenderStepped:Connect(updater))
    end

    createToggleSwitch(VisualsFrame, "🔍 Player ESP", function(state)
        espEnabled = state
        if state then
            for _, p in pairs(game.Players:GetPlayers()) do createESP(p) end
        else
            for _, child in pairs(ScreenGui:GetChildren()) do
                if child:IsA("Folder") and string.find(child.Name, "_ESP") then child:Destroy() end
            end
        end
    end)

    local noFogEnabled = false
    AddConnection(RunService.Heartbeat:Connect(function()
        if noFogEnabled then
            Lighting.FogStart = 1e6
            Lighting.FogEnd = 1e6
            
            local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
            if atmosphere then
                atmosphere.Density = 0
                atmosphere.Haze = 0
                atmosphere.Glare = 0
            end
            
            for _, v in pairs(Lighting:GetChildren()) do
                if v:IsA("Atmosphere") or v:IsA("Clouds") then
                    v:Destroy()
                end
            end
        end
    end))

    createToggleSwitch(VisualsFrame, "🌫️ No Fog", function(state)
        noFogEnabled = state
        if not state then
            Lighting.FogStart = _G.OriginalFogStart or 0
            Lighting.FogEnd = _G.OriginalFogEnd or 8000
        end
    end)

    local fullbrightEnabled = false
    createToggleSwitch(VisualsFrame, "☀️ Fullbright (Light)", function(state)
        fullbrightEnabled = state
        if state then
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
        else
            Lighting.Ambient = _G.OriginalAmbient
            Lighting.Brightness = _G.OriginalBrightness
            Lighting.ClockTime = _G.OriginalClockTime
        end
    end)

    createSlider(VisualsFrame, "🔭 Field Of View (FOV)", 70, 120, 70, function(val)
        workspace.CurrentCamera.FieldOfView = val
    end)

    local selectedPlayer = nil
    local playerLabel = Instance.new("TextLabel")
    playerLabel.Text = "Selected: None"
    playerLabel.Size = UDim2.new(0.96, 0, 0, 30)
    playerLabel.BackgroundColor3 = Theme.ContentBg
    playerLabel.TextColor3 = Theme.Accent
    playerLabel.Parent = PlayersFrame
    Instance.new("UICorner", playerLabel).CornerRadius = UDim.new(0, 6)
    AddStroke(playerLabel, Theme.Outline, 1)

    local function updatePlayerList(dropdownFrame)
        dropdownFrame:ClearAllChildren()
        local listLayout = Instance.new("UIListLayout")
        listLayout.Parent = dropdownFrame
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= Player then
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 25)
                btn.Text = p.Name
                btn.BackgroundColor3 = Theme.ItemHover
                btn.TextColor3 = Theme.TextPrimary
                btn.Parent = dropdownFrame
                btn.MouseButton1Click:Connect(function()
                    selectedPlayer = p
                    playerLabel.Text = "Selected: " .. p.Name
                    dropdownFrame.Visible = false
                end)
            end
        end
    end

    local dropdownBtn = createButton(PlayersFrame, "👇 Select Player", Theme.Outline, function() end)
    local dropdownFrame = Instance.new("ScrollingFrame")
    dropdownFrame.Size = UDim2.new(0.96, 0, 0, 150)
    dropdownFrame.Visible = false
    dropdownFrame.Parent = PlayersFrame
    dropdownBtn.MouseButton1Click:Connect(function()
        dropdownFrame.Visible = not dropdownFrame.Visible
        if dropdownFrame.Visible then updatePlayerList(dropdownFrame) end
    end)

    createButton(PlayersFrame, "🌀 Teleport to Player", Theme.Accent, function()
        if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character:SetPrimaryPartCFrame(selectedPlayer.Character.HumanoidRootPart.CFrame)
        end
    end)

    createButton(PlayersFrame, "🧲 Bring Player (Client)", Theme.Green, function()
        if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                selectedPlayer.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame
            end
        end
    end)

    local spectating = false
    createToggleSwitch(PlayersFrame, "👀 Spectate Player", function(state)
        spectating = state
        local cam = workspace.CurrentCamera
        if not state then
            cam.CameraSubject = Player.Character:FindFirstChild("Humanoid")
        end
    end)

    AddConnection(RunService.RenderStepped:Connect(function()
        if spectating and selectedPlayer and selectedPlayer.Character then
            workspace.CurrentCamera.CameraSubject = selectedPlayer.Character:FindFirstChild("Humanoid")
        end
    end))

    local clickTpEnabled = false
    local mouse = Player:GetMouse()
    createToggleSwitch(PlayersFrame, "🖱️ Ctrl + Click TP", function(state)
        clickTpEnabled = state
    end)

    AddConnection(mouse.Button1Down:Connect(function()
        if clickTpEnabled and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            local pos = mouse.Hit.p
            if Player.Character then
                Player.Character:MoveTo(pos)
            end
        end
    end))

    local afkLabel = Instance.new("TextLabel")
    afkLabel.Text = "🤖 Automation & AFK"
    afkLabel.Size = UDim2.new(0.96, 0, 0, 25)
    afkLabel.BackgroundTransparency = 1
    afkLabel.TextColor3 = Theme.Accent
    afkLabel.Font = Enum.Font.GothamBold
    afkLabel.Parent = AFKFrame

    local afkScreenToggleBtn
    afkScreenToggleBtn = createToggleSwitch(AFKFrame, "🌑 AFK Screen Mode", function(state)
        BlackScreen.Visible = state
        MainFrame.Visible = state
    end)
    BlackScreen.ZIndex = 5000
    CloseX.ZIndex = 5001
    CloseX.MouseButton1Click:Connect(function() 
        afkScreenToggleBtn:SetState(false) 
    end)

    local autoReconnectEnabled = false
    createToggleSwitch(AFKFrame, "🔄 Auto Reconnect", function(state)
        autoReconnectEnabled = state
    end)
    AddConnection(GuiService.ErrorMessageChanged:Connect(function()
        if autoReconnectEnabled then
            task.wait(5)
            TeleportService:Teleport(game.PlaceId, Player)
        end
    end))

    local antiAfkOn = false
    createToggleSwitch(AFKFrame, "🛡️ Anti-Kick (20m)", function(state)
        antiAfkOn = state
        if state then
            for _, c in pairs(getconnections(Player.Idled)) do
                c:Disable()
            end
        else
            for _, c in pairs(getconnections(Player.Idled)) do
                c:Enable()
            end
        end
    end)

    AddConnection(Player.Idled:Connect(function()
        if antiAfkOn then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end))

    local autoClickOn = false
    createToggleSwitch(AFKFrame, "👆 Auto Clicker", function(state)
        autoClickOn = state
        task.spawn(function()
            while autoClickOn do
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new())
                task.wait(0.1)
            end
        end)
    end)

    local spinOn = false
    local spinVelocity
    createToggleSwitch(AFKFrame, "😵 Spin Bot (Anti-Kick)", function(state)
        spinOn = state
        if state then
            local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                spinVelocity = Instance.new("BodyAngularVelocity")
                spinVelocity.Name = "NEBULA_Spin"
                spinVelocity.MaxTorque = Vector3.new(0, math.huge, 0)
                spinVelocity.AngularVelocity = Vector3.new(0, 50, 0)
                spinVelocity.Parent = root
            end
        else
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                if Player.Character.HumanoidRootPart:FindFirstChild("NEBULA_Spin") then
                    Player.Character.HumanoidRootPart.NEBULA_Spin:Destroy()
                end
            end
        end
    end)

    local autoJumpOn = false
    createToggleSwitch(AFKFrame, "🐇 Auto Jump", function(state)
        autoJumpOn = state
        task.spawn(function()
            while autoJumpOn do
                if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                    Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
                task.wait(2)
            end
        end)
    end)

    createButton(ServerFrame, "🔁 Rejoin Server", Theme.Yellow, function()
        saveSettings()
        TeleportService:Teleport(game.PlaceId, Player)
    end)

    createButton(ServerFrame, "⏭️ Server Hop (Low Pop)", Theme.Green, function()
        saveSettings()
        local Http = game:GetService("HttpService")
        local TPS = game:GetService("TeleportService")
        local Api = "https://games.roblox.com/v1/games/"
        local _place = game.PlaceId
        local _servers = Api.._place.."/servers/Public?sortOrder=Asc&limit=100"
        local function ListServers(cursor)
            local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
            return Http:JSONDecode(Raw)
        end
        local Server, Next; repeat
            local Servers = ListServers(Next)
            Server = Servers.data[1]
            Next = Servers.nextPageCursor
        until Server
        if Server.playing < Server.maxPlayers then
            TPS:TeleportToPlaceInstance(_place, Server.id, Player)
        else
            TPS:Teleport(game.PlaceId, Player)
        end
    end)

    local function createInfoLabel(parent, title, value)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(0.96, 0, 0, 36)
        container.BackgroundColor3 = Theme.ContentBg
        container.Parent = parent
        Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)
        AddStroke(container, Theme.Outline, 1)

        local titleLbl = Instance.new("TextLabel")
        titleLbl.Size = UDim2.new(0.4, 0, 1, 0)
        titleLbl.Position = UDim2.new(0.05, 0, 0, 0)
        titleLbl.Text = title
        titleLbl.TextColor3 = Theme.TextSecondary
        titleLbl.TextXAlignment = Enum.TextXAlignment.Left
        titleLbl.Font = Enum.Font.GothamMedium
        titleLbl.TextSize = 12
        titleLbl.BackgroundTransparency = 1
        titleLbl.Parent = container

        local valueLbl = Instance.new("TextLabel")
        valueLbl.Size = UDim2.new(0.5, 0, 1, 0)
        valueLbl.Position = UDim2.new(0.45, 0, 0, 0)
        valueLbl.Text = value
        valueLbl.TextColor3 = Theme.TextPrimary
        valueLbl.TextXAlignment = Enum.TextXAlignment.Right
        valueLbl.Font = Enum.Font.GothamBold
        valueLbl.TextSize = 12
        valueLbl.BackgroundTransparency = 1
        valueLbl.Parent = container
        return valueLbl
    end

    local gameNameLbl = createInfoLabel(InfoFrame, "🎮 Game", "Loading...")
    local runTimeLbl = createInfoLabel(InfoFrame, "⏱️ Uptime", "00:00:00")
    local playerCountLbl = createInfoLabel(InfoFrame, "👥 Players", "0 / 0")
    local userIdLbl = createInfoLabel(InfoFrame, "🆔 User ID", tostring(Player.UserId))
    local gameIdLbl = createInfoLabel(InfoFrame, "🆔 Game ID", tostring(game.GameId))
    local placeIdLbl = createInfoLabel(InfoFrame, "📍 Place ID", tostring(game.PlaceId))
    local jobIdLbl = createInfoLabel(InfoFrame, "🎫 Job ID", "Click to Copy")

    createButton(InfoFrame, "📋 Copy Job ID", Theme.Accent, function()
        setclipboard(game.JobId)
    end)

    local jobIdBox = createTextBox(InfoFrame, "🎫 Enter Job ID to Join...", function() end)
    createButton(InfoFrame, "🚀 Join by Job ID", Theme.Green, function()
        local jId = jobIdBox.Text
        if jId and jId ~= "" then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, jId, Player)
        end
    end)

    task.spawn(function()
        local success, info = pcall(function()
            return MarketplaceService:GetProductInfo(game.PlaceId)
        end)
        if success and info then
            gameNameLbl.Text = info.Name
        else
            gameNameLbl.Text = "Unknown"
        end
    end)

    task.spawn(function()
        while true do
            if InfoFrame.Visible then
                local seconds = math.floor(workspace.DistributedGameTime)
                local hours = math.floor(seconds / 3600)
                local minutes = math.floor((seconds % 3600) / 60)
                local secs = seconds % 60
                runTimeLbl.Text = string.format("%02d:%02d:%02d", hours, minutes, secs)
                playerCountLbl.Text = #game.Players:GetPlayers() .. " / " .. game.Players.MaxPlayers
            end
            task.wait(1)
        end
    end)

    createToggleSwitch(SettingsFrame, "🔒 Lock GUI Drag", function(state)
        ToggleBtn.Draggable = not state
        QuickFlyBtn.Draggable = not state
        QuickNoclipBtn.Draggable = not state
    end)
    
    createButton(SettingsFrame, "🔄 Reload Script", Theme.Yellow, function()
        Cleanup()
        task.wait(0.1)
        BuildInterface(true)
    end)

    createButton(SettingsFrame, "💀 Unload Script", Theme.Red, Cleanup)

    createButton(SettingsFrame, "🗑️ Reset Config", Theme.Red, function()
        createConfirmation(SettingsFrame, "⚠️ Are you sure? This will delete 'Settings.json' from 'Nova Script' folder.", function()
            if isfile(FULL_PATH) then delfile(FULL_PATH) end
            Settings.CurrentTheme = "Cyan" 
            Cleanup() 
            task.wait(0.1)
            BuildInterface()
            SendNotification("Config Reset Successfully", Theme.Red)
        end)
    end)

    local keyLabel = Instance.new("TextLabel")
    keyLabel.Text = "⌨️ Key: " .. Settings.MenuKey
    keyLabel.Size = UDim2.new(0.96, 0, 0, 30)
    keyLabel.TextColor3 = Theme.TextPrimary
    keyLabel.BackgroundTransparency = 1
    keyLabel.Parent = SettingsFrame

    createButton(SettingsFrame, "⌨️ Change Keybind", Theme.Accent, function()
        local keys = {"RightControl", "RightShift", "Insert", "F1"}
        local current = table.find(keys, Settings.MenuKey) or 1
        local nextKey = keys[current + 1] or keys[1]
        Settings.MenuKey = nextKey
        keyLabel.Text = "⌨️ Key: " .. nextKey
        saveSettings()
    end)

    AddConnection(UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode[Settings.MenuKey] then
            MainFrame.Visible = not MainFrame.Visible
        end
    end))

    ToggleBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)

    local themeDropdownBtn = createButton(SettingsFrame, "🎨 Theme: " .. Settings.CurrentTheme, Theme.Outline, function() end)
    local themeFrame = Instance.new("ScrollingFrame")
    themeFrame.Size = UDim2.new(0.96, 0, 0, 150)
    themeFrame.Visible = false
    themeFrame.Parent = SettingsFrame
    createLayout(themeFrame)
    local themeNote = Instance.new("TextLabel")
    themeNote.Name = "ThemeNote"
    themeNote.Size = UDim2.new(0.96, 0, 0, 20)
    themeNote.BackgroundTransparency = 1
    themeNote.Text = "Theme Changes Will Apply After Re-Execution"
    themeNote.TextColor3 = Color3.new(1, 1, 1)
    themeNote.Font = Enum.Font.GothamMedium
    themeNote.TextSize = 11
    themeNote.TextXAlignment = Enum.TextXAlignment.Center
    themeNote.Parent = SettingsFrame

    themeDropdownBtn.MouseButton1Click:Connect(function()
        themeFrame.Visible = not themeFrame.Visible
        if themeFrame.Visible then
            themeFrame:ClearAllChildren()
            local list = createLayout(themeFrame)
            for name, _ in pairs(Themes) do
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 30)
                btn.BackgroundColor3 = Theme.ItemHover
                btn.Text = name
                btn.TextColor3 = Theme.TextPrimary
                btn.Parent = themeFrame
                btn.MouseButton1Click:Connect(function()
                    Settings.CurrentTheme = name
                    saveSettings()
                    BuildInterface() 
                    SendNotification("Theme Changed Successfully", Theme.Accent)
                end)
            end
        end
    end)

    if isReload then
        SendNotification("Nova Script Reloaded Successfully", Theme.Green)
    else
        SendNotification("Nova Script Loaded Successfully", Theme.Accent)
    end
end

BuildInterface()