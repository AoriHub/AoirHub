-- AoriHub UI Script (Delta Compatible)

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local playerGui = player:WaitForChild("PlayerGui")

-- 🖥️ UI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AoriHubUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

-- Title
local titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.Text = "Aori Hub UI"
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true

-- ⚡ Speed Hack
local speedHack = Instance.new("TextButton", mainFrame)
speedHack.Text = "Speed Hack: OFF"
speedHack.Size = UDim2.new(0.9, 0, 0, 30)
speedHack.Position = UDim2.new(0.05, 0, 0.1, 0)
speedHack.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
local isSpeedEnabled = false

speedHack.MouseButton1Click:Connect(function()
    isSpeedEnabled = not isSpeedEnabled
    if isSpeedEnabled then
        humanoid.WalkSpeed = 50
        speedHack.Text = "Speed Hack: ON"
    else
        humanoid.WalkSpeed = 16
        speedHack.Text = "Speed Hack: OFF"
    end
end)

-- 🦘 Jump Hack
local jumpHack = Instance.new("TextButton", mainFrame)
jumpHack.Text = "Jump Hack: OFF"
jumpHack.Size = UDim2.new(0.9, 0, 0, 30)
jumpHack.Position = UDim2.new(0.05, 0, 0.2, 0)
jumpHack.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
local isJumpEnabled = false

jumpHack.MouseButton1Click:Connect(function()
    isJumpEnabled = not isJumpEnabled
    if isJumpEnabled then
        humanoid.JumpPower = 100
        jumpHack.Text = "Jump Hack: ON"
    else
        humanoid.JumpPower = 50
        jumpHack.Text = "Jump Hack: OFF"
    end
end)

-- 🔄 Rejoin Server
local rejoinButton = Instance.new("TextButton", mainFrame)
rejoinButton.Text = "Rejoin Server"
rejoinButton.Size = UDim2.new(0.9, 0, 0, 30)
rejoinButton.Position = UDim2.new(0.05, 0, 0.3, 0)
rejoinButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)

rejoinButton.MouseButton1Click:Connect(function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, player)
end)

-- ❌ Close Button
local closeButton = Instance.new("TextButton", mainFrame)
closeButton.Text = "Close"
closeButton.Size = UDim2.new(0.9, 0, 0, 30)
closeButton.Position = UDim2.new(0.05, 0, 0.4, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)

closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)
