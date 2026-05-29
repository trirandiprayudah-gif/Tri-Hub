-- Tri-Hub | Grow a Garden - Fixed Auto Buy
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- ================== UI (Sama seperti sebelumnya) ==================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TriHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Logo = Instance.new("TextButton")
Logo.Size = UDim2.new(0, 60, 0, 60)
Logo.Position = UDim2.new(0, 20, 0, 20)
Logo.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
Logo.Text = "T"
Logo.TextColor3 = Color3.new(0,0,0)
Logo.TextScaled = true
Logo.Font = Enum.Font.GothamBold
Logo.Parent = ScreenGui

local LogoCorner = Instance.new("UICorner", Logo)
LogoCorner.CornerRadius = UDim.new(1,0)

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 280)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 16)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "Tri-Hub"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 35, 0, 35)
MinimizeBtn.Position = UDim2.new(1, -45, 0, 8)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
MinimizeBtn.Text = "−"
MinimizeBtn.TextColor3 = Color3.new(1,1,1)
MinimizeBtn.TextScaled = true
MinimizeBtn.Parent = MainFrame

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -70)
Content.Position = UDim2.new(0, 10, 0, 60)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- Toggle Buttons
local SeedToggle = Instance.new("TextButton")
SeedToggle.Size = UDim2.new(1, 0, 0, 55)
SeedToggle.Position = UDim2.new(0, 0, 0, 0)
SeedToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
SeedToggle.Text = "Auto Buy Seeds: OFF"
SeedToggle.TextColor3 = Color3.new(1,1,1)
SeedToggle.TextScaled = true
SeedToggle.Font = Enum.Font.GothamSemibold
SeedToggle.Parent = Content

local GearToggle = Instance.new("TextButton")
GearToggle.Size = UDim2.new(1, 0, 0, 55)
GearToggle.Position = UDim2.new(0, 0, 0, 65)
GearToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
GearToggle.Text = "Auto Buy Gear: OFF"
GearToggle.TextColor3 = Color3.new(1,1,1)
GearToggle.TextScaled = true
GearToggle.Font = Enum.Font.GothamSemibold
GearToggle.Parent = Content

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, 0, 0, 40)
Status.Position = UDim2.new(0, 0, 0, 130)
Status.BackgroundTransparency = 1
Status.Text = "Status: Idle"
Status.TextColor3 = Color3.fromRGB(120, 255, 120)
Status.TextScaled = true
Status.Font = Enum.Font.Gotham
Status.Parent = Content

-- Variables
local autoSeed = false
local autoGear = false
local isMinimized = false

-- Minimize Function
local function toggleUI()
    isMinimized = not isMinimized
    MainFrame.Visible = not isMinimized
end

Logo.MouseButton1Click:Connect(toggleUI)
MinimizeBtn.MouseButton1Click:Connect(toggleUI)

-- Toggle Logic
SeedToggle.MouseButton1Click:Connect(function()
    autoSeed = not autoSeed
    SeedToggle.Text = "Auto Buy Seeds: " .. (autoSeed and "ON" or "OFF")
    SeedToggle.BackgroundColor3 = autoSeed and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(30,30,40)
end)

GearToggle.MouseButton1Click:Connect(function()
    autoGear = not autoGear
    GearToggle.Text = "Auto Buy Gear: " .. (autoGear and "ON" or "OFF")
    GearToggle.BackgroundColor3 = autoGear and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(30,30,40)
end)

-- ================== IMPROVED BUYING LOGIC ==================
local function findNPC(name)
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and (v.Name:find(name) or v.Name:lower():find(name:lower())) then
            local root = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChildWhichIsA("BasePart")
            if root then
                return root.Position
            end
        end
    end
    return nil
end

local function buyFromShop(shopType)
    local pos = findNPC(shopType == "seed" and "Sam" or "Gear")
    if not pos then
        Status.Text = "Status: Shop NPC not found!"
        wait(2)
        return
    end

    -- Teleport ke NPC
    if character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 5, 3))
    end
    wait(1.5)

    -- Fire semua ProximityPrompt di sekitar NPC
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            local parentName = v.Parent.Name:lower()
            if (shopType == "seed" and (parentName:find("sam") or parentName:find("seed"))) or
               (shopType == "gear" and (parentName:find("gear") or parentName:find("tool"))) then
                fireproximityprompt(v, 1)
                wait(0.6)
            end
        end
    end
end

-- Main Loop
spawn(function()
    while wait(4) do
        if autoSeed then
            Status.Text = "Status: Buying Seeds..."
            buyFromShop("seed")
        end
        if autoGear then
            Status.Text = "Status: Buying Gear..."
            buyFromShop("gear")
        end
        if not autoSeed and not autoGear then
            Status.Text = "Status: Idle"
        end
    end
end)

print("Tri-Hub Fixed Version Loaded! Auto Buy sudah di-improve.")
