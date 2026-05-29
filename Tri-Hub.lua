-- Tri-Hub | Grow a Garden
-- Auto Buy Seed Shop + Auto Buy Gear Shop

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- ================== UI ==================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TriHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 260)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Corner
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "Tri-Hub"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, 0, 0, 20)
Subtitle.Position = UDim2.new(0, 0, 0, 45)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Grow a Garden - Simple & Light"
Subtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
Subtitle.TextSize = 14
Subtitle.Font = Enum.Font.Gotham
Subtitle.Parent = MainFrame

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame

local CloseCorner = Instance.new("UICorner", CloseBtn)
CloseCorner.CornerRadius = UDim.new(0, 8)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Tabs Container
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(1, -20, 1, -80)
TabFrame.Position = UDim2.new(0, 10, 0, 70)
TabFrame.BackgroundTransparency = 1
TabFrame.Parent = MainFrame

-- Auto Buy Seeds
local SeedToggle = Instance.new("TextButton")
SeedToggle.Size = UDim2.new(0.9, 0, 0, 50)
SeedToggle.Position = UDim2.new(0.05, 0, 0, 10)
SeedToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
SeedToggle.Text = "Auto Buy Seeds: OFF"
SeedToggle.TextColor3 = Color3.new(1,1,1)
SeedToggle.TextScaled = true
SeedToggle.Font = Enum.Font.GothamSemibold
SeedToggle.Parent = TabFrame

local SeedCorner = Instance.new("UICorner", SeedToggle)
SeedCorner.CornerRadius = UDim.new(0, 10)

-- Auto Buy Gear
local GearToggle = Instance.new("TextButton")
GearToggle.Size = UDim2.new(0.9, 0, 0, 50)
GearToggle.Position = UDim2.new(0.05, 0, 0, 70)
GearToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
GearToggle.Text = "Auto Buy Gear: OFF"
GearToggle.TextColor3 = Color3.new(1,1,1)
GearToggle.TextScaled = true
GearToggle.Font = Enum.Font.GothamSemibold
GearToggle.Parent = TabFrame

local GearCorner = Instance.new("UICorner", GearToggle)
GearCorner.CornerRadius = UDim.new(0, 10)

-- Status
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(0.9, 0, 0, 30)
Status.Position = UDim2.new(0.05, 0, 0, 130)
Status.BackgroundTransparency = 1
Status.Text = "Status: Idle"
Status.TextColor3 = Color3.fromRGB(100, 255, 100)
Status.TextScaled = true
Status.Font = Enum.Font.Gotham
Status.Parent = TabFrame

-- Variables
local autoSeed = false
local autoGear = false

-- Fungsi Teleport sederhana
local function teleportTo(pos)
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

-- ================== AUTO BUY LOGIC ==================
local function buyAllSeeds()
    -- Teleport ke Seed Shop (Sam's Shop)
    -- Sesuaikan koordinat sesuai game (bisa diubah)
    teleportTo(Vector3.new(150, 50, 200)) -- Contoh koordinat Seed Shop
    
    wait(1)
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") and (v.Name:lower():find("buy") or v.Name:lower():find("seed")) then
            fireproximityprompt(v, 1)
            wait(0.3)
        end
    end
end

local function buyAllGear()
    -- Teleport ke Gear Shop
    teleportTo(Vector3.new(-150, 50, 200)) -- Contoh koordinat Gear Shop
    
    wait(1)
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") and (v.Name:lower():find("gear") or v.Name:lower():find("buy")) then
            fireproximityprompt(v, 1)
            wait(0.3)
        end
    end
end

-- Toggle Seeds
SeedToggle.MouseButton1Click:Connect(function()
    autoSeed = not autoSeed
    SeedToggle.Text = "Auto Buy Seeds: " .. (autoSeed and "ON" or "OFF")
    SeedToggle.BackgroundColor3 = autoSeed and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(30, 30, 40)
end)

-- Toggle Gear
GearToggle.MouseButton1Click:Connect(function()
    autoGear = not autoGear
    GearToggle.Text = "Auto Buy Gear: " .. (autoGear and "ON" or "OFF")
    GearToggle.BackgroundColor3 = autoGear and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(30, 30, 40)
end)

-- Main Loop
spawn(function()
    while wait(3) do
        if autoSeed then
            Status.Text = "Status: Buying Seeds..."
            buyAllSeeds()
        end
        
        if autoGear then
            Status.Text = "Status: Buying Gear..."
            buyAllGear()
        end
        
        if not autoSeed and not autoGear then
            Status.Text = "Status: Idle"
        end
    end
end)

print("Tri-Hub loaded successfully! Enjoy :)")
