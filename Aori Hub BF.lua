-- Aori Hub ChatBot Style UI Script

-- Variables
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local aoriUI = Instance.new("ScreenGui")
aoriUI.Name = "AoriHubUI"
aoriUI.ResetOnSpawn = false
aoriUI.Parent = playerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 450, 0, 400)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Draggable = true
mainFrame.Active = true
mainFrame.Parent = aoriUI

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Text = "Aori Hub"
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = mainFrame

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -40, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 50, 50)
closeButton.Parent = mainFrame
closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- Side Menu (Tabs)
local sideMenu = Instance.new("Frame")
sideMenu.Name = "SideMenu"
sideMenu.Size = UDim2.new(0, 100, 1, -40)
sideMenu.Position = UDim2.new(0, 0, 0, 40)
sideMenu.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
sideMenu.Parent = mainFrame

-- Tabs (Main, AI, Premium, More, Help)
local tabs = {"Main", "AI", "Premium", "More", "Help"}
for i, tabName in pairs(tabs) do
    local tabButton = Instance.new("TextButton")
    tabButton.Name = tabName .. "Tab"
    tabButton.Size = UDim2.new(1, 0, 0, 40)
    tabButton.Position = UDim2.new(0, 0, 0, (i-1)*40)
    tabButton.Text = tabName
    tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    tabButton.Parent = sideMenu
end

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -100, 1, -40)
contentFrame.Position = UDim2.new(0, 100, 0, 40)
contentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
contentFrame.Parent = mainFrame

-- Example Buttons in Main Tab
local quickQuest = Instance.new("TextButton")
quickQuest.Name = "QuickQuest"
quickQuest.Size = UDim2.new(0, 200, 0, 40)
quickQuest.Position = UDim2.new(0, 20, 0, 20)
quickQuest.Text = "Quick Quest"
quickQuest.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
quickQuest.TextColor3 = Color3.fromRGB(255, 255, 255)
quickQuest.Parent = contentFrame
quickQuest.MouseButton1Click:Connect(function()
    print("Quick Quest Activated")
end)

local fastPunch = Instance.new("TextButton")
fastPunch.Name = "FastPunch"
fastPunch.Size = UDim2.new(0, 200, 0, 40)
fastPunch.Position = UDim2.new(0, 20, 0, 80)
fastPunch.Text = "Fast Punch Attack"
fastPunch.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
fastPunch.TextColor3 = Color3.fromRGB(255, 255, 255)
fastPunch.Parent = contentFrame
fastPunch.MouseButton1Click:Connect(function()
    print("Fast Punch Activated")
end)

-- Server Time & FPS Display
local infoLabel = Instance.new("TextLabel")
infoLabel.Name = "InfoLabel"
infoLabel.Size = UDim2.new(1, 0, 0, 40)
infoLabel.Position = UDim2.new(0, 0, 1, -40)
infoLabel.Text = "Time: 00:00 | FPS: 60"
infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
infoLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
infoLabel.Parent = mainFrame

game:GetService("RunService").Heartbeat:Connect(function()
    infoLabel.Text = "Time: " .. os.date("%H:%M:%S") .. " | FPS: " .. math.floor(workspace:GetRealPhysicsFPS())
end)

-- Toggle UI with RightShift
local userInputService = game:GetService("UserInputService")
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightShift then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

print("✅ Aori Hub Loaded Successfully with ChatBot UI Style!")
