-- Nebula X Hub - Ultra Modern Roblox Mod Menu
-- Made by @KoolSageYT

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

-- ========== UI CREATION ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NebulaXHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 400)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainFrame

local Logo = Instance.new("TextLabel")
Logo.Name = "Logo"
Logo.Text = "Nebula X Hub"
Logo.Font = Enum.Font.GothamBlack
Logo.TextSize = 28
Logo.TextColor3 = Color3.fromRGB(0, 255, 255)
Logo.BackgroundTransparency = 1
Logo.Position = UDim2.new(0.5, -100, 0, 10)
Logo.Size = UDim2.new(0, 200, 0, 50)
Logo.Parent = MainFrame

spawn(function()
    while true do
        for i = 0,1,0.02 do
            Logo.TextStrokeTransparency = 1 - i
            wait(0.01)
        end
        for i = 0,1,0.02 do
            Logo.TextStrokeTransparency = i
            wait(0.01)
        end
    end
end)

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.Position = UDim2.new(0,0,0,0)
Sidebar.BackgroundColor3 = Color3.fromRGB(15,15,25)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarUICorner = Instance.new("UICorner")
SidebarUICorner.CornerRadius = UDim.new(0, 15)
SidebarUICorner.Parent = Sidebar

local tabs = {"Player", "World", "Utility", "Settings"}
local tabButtons = {}
local contentFrames = {}

for i, tabName in pairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Name = tabName .. "Tab"
    btn.Text = tabName
    btn.Size = UDim2.new(1,0,0,50)
    btn.Position = UDim2.new(0,0,0,(i-1)*50 + 60)
    btn.BackgroundColor3 = Color3.fromRGB(20,20,30)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 18
    btn.Parent = Sidebar
    table.insert(tabButtons, btn)

    local frame = Instance.new("Frame")
    frame.Name = tabName .. "Content"
    frame.Size = UDim2.new(1, -120, 1, -60)
    frame.Position = UDim2.new(0, 120, 0, 60)
    frame.BackgroundColor3 = Color3.fromRGB(25,25,35)
    frame.Visible = false
    frame.Parent = MainFrame
    table.insert(contentFrames, frame)
end

contentFrames[1].Visible = true

for i, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        for _, frame in pairs(contentFrames) do frame.Visible = false end
        contentFrames[i].Visible = true
    end)
end

-- ========== PLAYER TAB ==========
local PlayerFrame = contentFrames[1]

local WalkSlider = Instance.new("TextButton")
WalkSlider.Text = "WalkSpeed: 16"
WalkSlider.Size = UDim2.new(0, 200, 0, 40)
WalkSlider.Position = UDim2.new(0, 20, 0, 20)
WalkSlider.BackgroundColor3 = Color3.fromRGB(50,50,60)
WalkSlider.TextColor3 = Color3.fromRGB(255,255,255)
WalkSlider.Parent = PlayerFrame
WalkSlider.MouseButton1Click:Connect(function()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local newSpeed = humanoid.WalkSpeed == 16 and 50 or 16
        humanoid.WalkSpeed = newSpeed
        WalkSlider.Text = "WalkSpeed: " .. newSpeed
    end
end)

local JumpSlider = Instance.new("TextButton")
JumpSlider.Text = "JumpPower: 50"
JumpSlider.Size = UDim2.new(0, 200, 0, 40)
JumpSlider.Position = UDim2.new(0, 20, 0, 70)
JumpSlider.BackgroundColor3 = Color3.fromRGB(50,50,60)
JumpSlider.TextColor3 = Color3.fromRGB(255,255,255)
JumpSlider.Parent = PlayerFrame
JumpSlider.MouseButton1Click:Connect(function()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local newJump = humanoid.JumpPower == 50 and 150 or 50
        humanoid.JumpPower = newJump
        JumpSlider.Text = "JumpPower: " .. newJump
    end
end)

local NoclipBtn = Instance.new("TextButton")
NoclipBtn.Text = "Noclip: OFF"
NoclipBtn.Size = UDim2.new(0, 200, 0, 40)
NoclipBtn.Position = UDim2.new(0, 20, 0, 120)
NoclipBtn.BackgroundColor3 = Color3.fromRGB(50,50,60)
NoclipBtn.TextColor3 = Color3.fromRGB(255,255,255)
NoclipBtn.Parent = PlayerFrame
local noclip = false
NoclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    NoclipBtn.Text = "Noclip: " .. (noclip and "ON" or "OFF")
end)
RunService.Stepped:Connect(function()
    if noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- ========== WORLD TAB ==========
local WorldFrame = contentFrames[2]

local BrightBtn = Instance.new("TextButton")
BrightBtn.Text = "FullBright"
BrightBtn.Size = UDim2.new(0, 200, 0, 40)
BrightBtn.Position = UDim2.new(0, 20, 0, 20)
BrightBtn.BackgroundColor3 = Color3.fromRGB(50,50,60)
BrightBtn.TextColor3 = Color3.fromRGB(255,255,255)
BrightBtn.Parent = WorldFrame
BrightBtn.MouseButton1Click:Connect(function()
    game:GetService("Lighting").Brightness = 2
    game:GetService("Lighting").ClockTime = 14
end)

local GravityBtn = Instance.new("TextButton")
GravityBtn.Text = "Gravity 196.2"
GravityBtn.Size = UDim2.new(0, 200, 0, 40)
GravityBtn.Position = UDim2.new(0, 20, 0, 70)
GravityBtn.BackgroundColor3 = Color3.fromRGB(50,50,60)
GravityBtn.TextColor3 = Color3.fromRGB(255,255,255)
GravityBtn.Parent = WorldFrame
GravityBtn.MouseButton1Click:Connect(function()
    workspace.Gravity = workspace.Gravity == 196.2 and 50 or 196.2
    GravityBtn.Text = "Gravity " .. workspace.Gravity
end)

-- ========== UTILITY TAB ==========
local UtilityFrame = contentFrames[3]

local RejoinBtn = Instance.new("TextButton")
RejoinBtn.Text = "Rejoin"
RejoinBtn.Size = UDim2.new(0, 200, 0, 40)
RejoinBtn.Position = UDim2.new(0, 20, 0, 20)
RejoinBtn.BackgroundColor3 = Color3.fromRGB(50,50,60)
RejoinBtn.TextColor3 = Color3.fromRGB(255,255,255)
RejoinBtn.Parent = UtilityFrame
RejoinBtn.MouseButton1Click:Connect(function()
    local TeleportService = game:GetService("TeleportService")
    local PlaceId = game.PlaceId
    TeleportService:Teleport(PlaceId, LocalPlayer)
end)

local ServerHopBtn = Instance.new("TextButton")
ServerHopBtn.Text = "Server Hop"
ServerHopBtn.Size = UDim2.new(0, 200, 0, 40)
ServerHopBtn.Position = UDim2.new(0, 20, 0, 70)
ServerHopBtn.BackgroundColor3 = Color3.fromRGB(50,50,60)
ServerHopBtn.TextColor3 = Color3.fromRGB(255,255,255)
ServerHopBtn.Parent = UtilityFrame
-- Server hop placeholder, actual implementation requires HTTP requests

local AntiAFK = LocalPlayer.Idled:Connect(function()
    local VirtualUser = game:GetService("VirtualUser")
    VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

-- ========== BRANDING WATERMARK ==========
local Watermark = Instance.new("TextLabel")
Watermark.Text = "Made by @KoolSageYT"
Watermark.Font = Enum.Font.GothamBold
Watermark.TextSize = 14
Watermark.TextColor3 = Color3.fromRGB(0,255,255)
Watermark.BackgroundTransparency = 1
Watermark.Position = UDim2.new(1, -150, 1, -30)
Watermark.Size = UDim2.new(0, 150, 0, 20)
Watermark.Parent = ScreenGui
spawn(function()
    while true do
        Watermark.TextStrokeTransparency = math.random() * 0.5
        wait(0.5)
    end
end)

-- ========== UI DRAG FUNCTIONALITY ==========
local dragging = false
local dragInput, mousePos, framePos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - mousePos
        MainFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
end)