-- AoriHub UI with Advanced Features

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- UI Creation
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "AoriHubUI"

-- Main Frame
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 2
mainFrame.Draggable = true
mainFrame.Active = true

-- Title Bar
local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Text = "AoriHub"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.BackgroundTransparency = 1

-- Close Button
local closeButton = Instance.new("TextButton", titleBar)
closeButton.Size = UDim2.new(0, 30, 1, 0)
closeButton.Position = UDim2.new(1, -60, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 0, 0)

-- Minimize Button
local minimizeButton = Instance.new("TextButton", titleBar)
minimizeButton.Size = UDim2.new(0, 30, 1, 0)
minimizeButton.Position = UDim2.new(1, -30, 0, 0)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 0)

-- Content Frame
local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1, 0, 1, -30)
contentFrame.Position = UDim2.new(0, 0, 0, 30)
contentFrame.BackgroundTransparency = 0.1

-- Buttons
local toggleNoFall = Instance.new("TextButton", contentFrame)
toggleNoFall.Text = "No Fall Damage: OFF"
toggleNoFall.Size = UDim2.new(0.9, 0, 0, 30)
toggleNoFall.Position = UDim2.new(0.05, 0, 0.05, 0)

local toggleSpeed = Instance.new("TextButton", contentFrame)
toggleSpeed.Text = "Speed: OFF"
toggleSpeed.Size = UDim2.new(0.9, 0, 0, 30)
toggleSpeed.Position = UDim2.new(0.05, 0, 0.15, 0)

local toggleInvisibility = Instance.new("TextButton", contentFrame)
toggleInvisibility.Text = "Invisibility: OFF"
toggleInvisibility.Size = UDim2.new(0.9, 0, 0, 30)
toggleInvisibility.Position = UDim2.new(0.05, 0, 0.25, 0)

-- UI Logic
local isContentVisible = true
minimizeButton.MouseButton1Click:Connect(function()
    isContentVisible = not isContentVisible
    contentFrame.Visible = isContentVisible
    minimizeButton.Text = isContentVisible and "-" or "+"
end)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Features Logic
local humanoid = player.Character:WaitForChild("Humanoid")

-- No Fall Damage
local isNoFallEnabled = false
toggleNoFall.MouseButton1Click:Connect(function()
    isNoFallEnabled = not isNoFallEnabled
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, not isNoFallEnabled)
    toggleNoFall.Text = isNoFallEnabled and "No Fall Damage: ON" or "No Fall Damage: OFF"
end)

-- Speed Boost
local isSpeedEnabled = false
toggleSpeed.MouseButton1Click:Connect(function()
    isSpeedEnabled = not isSpeedEnabled
    humanoid.WalkSpeed = isSpeedEnabled and 50 or 16
    toggleSpeed.Text = isSpeedEnabled and "Speed: ON" or "Speed: OFF"
end)

-- Invisibility
local isInvisibleEnabled = false
toggleInvisibility.MouseButton1Click:Connect(function()
    isInvisibleEnabled = not isInvisibleEnabled
    for _, v in pairs(player.Character:GetChildren()) do
        if v:IsA("BasePart") or v:IsA("Decal") then
            v.Transparency = isInvisibleEnabled and 1 or 0
        end
    end
    toggleInvisibility.Text = isInvisibleEnabled and "Invisibility: ON" or "Invisibility: OFF"
end)
