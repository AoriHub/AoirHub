-- สร้าง ScreenGui สำหรับ UI
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraModernUI"
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- สร้าง Frame หลัก (หน้าต่าง)
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 600, 0, 300)
Frame.Position = UDim2.new(0.5, -300, 0.5, -150)
Frame.BackgroundTransparency = 1
Frame.Parent = ScreenGui

-- ฟังก์ชันเพิ่มเอฟเฟกต์ทันสมัย
local function addModernEffects(element, glow)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.5
    stroke.Parent = element

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = element

    if glow then
        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 150))
        })
        gradient.Rotation = 45
        gradient.Parent = stroke
    end
end

-- สร้างปุ่มปิด/เปิด UI
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 60, 0, 60)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
ToggleButton.Text = "✖"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextScaled = true
ToggleButton.Font = Enum.Font.GothamBold
addModernEffects(ToggleButton, true)
ToggleButton.Parent = ScreenGui

-- สร้าง Sidebar (ด้านซ้าย)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 70, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
addModernEffects(Sidebar, true)
Sidebar.Parent = Frame

-- เพิ่ม UIGradient เพื่อให้ Sidebar มีการไล่สีแบบนีออน
local SidebarGradient = Instance.new("UIGradient")
SidebarGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 255))
})
SidebarGradient.Rotation = 45
SidebarGradient.Parent = Sidebar

-- ปุ่มใน Sidebar
local function createSidebarButton(icon, yPos, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 50, 0, 50)
    button.Position = UDim2.new(0, 10, 0, yPos)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    button.Text = icon
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.GothamBold
    addModernEffects(button, true)
    button.Parent = Sidebar

    -- เพิ่มแอนิเมชันเมื่อกด
    button.MouseButton1Click:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 45, 0, 45)})
        tween:Play()
        wait(0.2)
        local tweenBack = TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 50, 0, 50)})
        tweenBack:Play()
        if callback then callback() end
    end)

    -- เพิ่มเอฟเฟกต์นีออนเมื่อโฮเวอร์
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 200, 255)})
        tween:Play()
    end)
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(50, 50, 70)})
        tween:Play()
    end)
end

-- สร้าง Content Area (ด้านขวา)
local Content = Instance.new("Frame")
Content.Size = UDim2.new(0, 520, 1, 0)
Content.Position = UDim2.new(0, 80, 0, 0)
Content.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
addModernEffects(Content, true)
Content.Parent = Frame

-- เพิ่ม UIGradient เพื่อให้ Content มีการไล่สีแบบนีออน
local ContentGradient = Instance.new("UIGradient")
ContentGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 255))
})
ContentGradient.Rotation = 45
ContentGradient.Parent = Content

-- สร้างหน้า Home และ Settings
local HomeFrame = Instance.new("Frame")
HomeFrame.Size = UDim2.new(1, 0, 1, 0)
HomeFrame.BackgroundTransparency = 1
HomeFrame.Parent = Content

local SettingsFrame = Instance.new("Frame")
SettingsFrame.Size = UDim2.new(1, 0, 1, 0)
SettingsFrame.BackgroundTransparency = 1
SettingsFrame.Visible = false
SettingsFrame.Parent = Content

-- ปุ่มใน Sidebar เพื่อสลับหน้า
createSidebarButton("🏠", 10, function()
    HomeFrame.Visible = true
    SettingsFrame.Visible = false
end)
createSidebarButton("⚙️", 70, function()
    HomeFrame.Visible = false
    SettingsFrame.Visible = true
end)

-- ### หน้า Home ###
-- หัวข้อ "เมนูสุดล้ำสมัย"
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 250, 0, 40)
TitleLabel.Position = UDim2.new(0, 10, 0, 10)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "เมนูสุดล้ำสมัย"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextScaled = true
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.Parent = HomeFrame

-- หัวข้อ "หน้าหลัก"
local DashboardLabel = Instance.new("TextLabel")
DashboardLabel.Size = UDim2.new(0, 100, 0, 30)
DashboardLabel.Position = UDim2.new(0, 410, 0, 10)
DashboardLabel.BackgroundTransparency = 1
DashboardLabel.Text = "หน้าหลัก"
DashboardLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
DashboardLabel.TextScaled = true
DashboardLabel.Font = Enum.Font.GothamBold
DashboardLabel.Parent = HomeFrame

-- ชื่อผู้ใช้
local UserLabel = Instance.new("TextLabel")
UserLabel.Size = UDim2.new(0, 200, 0, 30)
UserLabel.Position = UDim2.new(0, 10, 0, 60)
UserLabel.BackgroundTransparency = 1
UserLabel.Text = "ยินดีต้อนรับ, " .. player.Name
UserLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
UserLabel.TextScaled = true
UserLabel.Font = Enum.Font.GothamBold
UserLabel.Parent = HomeFrame

-- หัวข้อ "ฟีเจอร์"
local FeaturesLabel = Instance.new("TextLabel")
FeaturesLabel.Size = UDim2.new(0, 200, 0, 30)
FeaturesLabel.Position = UDim2.new(0, 10, 0, 100)
FeaturesLabel.BackgroundTransparency = 1
FeaturesLabel.Text = "ฟีเจอร์"
FeaturesLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FeaturesLabel.TextScaled = true
FeaturesLabel.Font = Enum.Font.GothamBold
FeaturesLabel.Parent = HomeFrame

-- ฟังก์ชันปุ่มในหน้า Home
local function createFeatureButton(name, xPos, yPos, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 150, 0, 35)
    button.Position = UDim2.new(0, xPos, 0, yPos)
    button.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.Gotham
    addModernEffects(button, true)
    button.Parent = HomeFrame

    local isActive = false
    button.MouseButton1Click:Connect(function()
        isActive = not isActive
        button.Text = name .. (isActive and " [เปิด]" or "")
        if callback then callback(isActive) end
        local tween = TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 140, 0, 30)})
        tween:Play()
        wait(0.2)
        local tweenBack = TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 150, 0, 35)})
        tweenBack:Play()
    end)

    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 255, 255)})
        tween:Play()
    end)
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 200, 255)})
        tween:Play()
    end)
end

-- ฟังก์ชัน 1: มองทะลุสิ่งของในแมพ
local originalMaterials = {}
local originalTransparency = {}
createFeatureButton("มองทะลุ", 10, 140, function(isActive)
    if isActive then
        -- ทำให้ผนังและสิ่งกีดขวางโปร่งใส
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and not part:IsDescendantOf(player.Character) then
                originalMaterials[part] = part.Material
                originalTransparency[part] = part.Transparency
                part.Material = Enum.Material.Glass
                part.Transparency = 0.8
            end
        end
        -- ทำให้ผู้เล่นทุกคนเป็นสีน้ำเงิน
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                for _, part in pairs(otherPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.BrickColor = BrickColor.new("Bright blue")
                    end
                end
            end
        end
    else
        -- คืนค่าเดิม
        for part, material in pairs(originalMaterials) do
            part.Material = material
            part.Transparency = originalTransparency[part] or 0
        end
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                for _, part in pairs(otherPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.BrickColor = BrickColor.new("Medium stone grey")
                    end
                end
            end
        end
        originalMaterials = {}
        originalTransparency = {}
    end
end)

-- ฟังก์ชัน 2: ออโต้ฟาร์มบล็อกฟุต
local autoFarmActive = false
createFeatureButton("ออโต้ฟาร์มบล็อกฟุต", 10, 185, function(isActive)
    autoFarmActive = isActive
    if autoFarmActive then
        spawn(function()
            while autoFarmActive do
                local character = player.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local humanoid = character:FindFirstChild("Humanoid")
                    local rootPart = character:FindFirstChild("HumanoidRootPart")
                    -- ตัวอย่าง: ฟาร์มมอนสเตอร์ใน Blox Fruits
                    for _, enemy in pairs(workspace:GetChildren()) do
                        if enemy.Name:find("Enemy") and enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") then
                            local enemyHumanoid = enemy:FindFirstChild("Humanoid")
                            local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")
                            if enemyHumanoid and enemyHumanoid.Health > 0 then
                                humanoid:MoveTo(enemyRoot.Position)
                                humanoid.MoveToFinished:Wait()
                                -- โจมตี
                                local tool = player.Backpack:FindFirstChildOfClass("Tool")
                                if tool then
                                    tool.Parent = character
                                    tool:Activate()
                                end
                            end
                        end
                    end
                end
                wait(0.5)
            end
        end)
    end
end)

-- ฟังก์ชัน 3: ออโต้บิน, ปรับความเร็ว, กระโดดสูง, ไม่ตาย
local flyActive = false
local speedValue = 50
local jumpValue = 50
local godModeActive = false

-- ออโต้บิน
createFeatureButton("บินอัตโนมัติ", 310, 100, function(isActive)
    flyActive = isActive
    if flyActive then
        spawn(function()
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.Parent = player.Character.HumanoidRootPart

            while flyActive do
                local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
                local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if humanoid and rootPart then
                    local moveDirection = humanoid.MoveDirection * speedValue
                    bodyVelocity.Velocity = Vector3.new(moveDirection.X, 0, moveDirection.Z)
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                        bodyVelocity.Velocity = bodyVelocity.Velocity + Vector3.new(0, speedValue, 0)
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
                        bodyVelocity.Velocity = bodyVelocity.Velocity + Vector3.new(0, -speedValue, 0)
                    end
                end
                wait()
            end
            bodyVelocity:Destroy()
        end)
    end
end)

-- ปรับความเร็ว
createFeatureButton("ปรับความเร็ว", 310, 145, function(isActive)
    if isActive then
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = speedValue
        end
    else
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = 16 -- ค่าเริ่มต้น
        end
    end
end)

-- กระโดดสูง
createFeatureButton("กระโดดสูง", 310, 190, function(isActive)
    if isActive then
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.JumpPower = jumpValue
        end
    else
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.JumpPower = 50 -- ค่าเริ่มต้น
        end
    end
end)

-- ไม่ตาย
createFeatureButton("โหมดเทพ", 310, 235, function(isActive)
    godModeActive = isActive
    if godModeActive then
        spawn(function()
            while godModeActive do
                local character = player.Character
                if character and character:FindFirstChild("Humanoid") then
                    character.Humanoid.MaxHealth = math.huge
                    character.Humanoid.Health = math.huge
                end
                wait()
            end
        end)
    else
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.MaxHealth = 100
            character.Humanoid.Health = 100
        end
    end
end)

-- ### หน้า Settings ###
-- หัวข้อ "ตั้งค่า"
local SettingsLabel = Instance.new("TextLabel")
SettingsLabel.Size = UDim2.new(0, 200, 0, 30)
SettingsLabel.Position = UDim2.new(0, 10, 0, 10)
SettingsLabel.BackgroundTransparency = 1
SettingsLabel.Text = "ตั้งค่า"
SettingsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingsLabel.TextScaled = true
SettingsLabel.Font = Enum.Font.GothamBold
SettingsLabel.Parent = SettingsFrame

-- ปรับสีเมนู
local ColorLabel = Instance.new("TextLabel")
ColorLabel.Size = UDim2.new(0, 200, 0, 30)
ColorLabel.Position = UDim2.new(0, 10, 0, 50)
ColorLabel.BackgroundTransparency = 1
ColorLabel.Text = "สีเมนู"
ColorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ColorLabel.TextScaled = true
ColorLabel.Font = Enum.Font.GothamBold
ColorLabel.Parent = SettingsFrame

local colors = {
    {Name = "แดง", Color = Color3.fromRGB(255, 0, 0)},
    {Name = "เขียว", Color = Color3.fromRGB(0, 255, 0)},
    {Name = "น้ำเงิน", Color = Color3.fromRGB(0, 0, 255)},
    {Name = "เหลือง", Color = Color3.fromRGB(255, 255, 0)},
    {Name = "ม่วง", Color = Color3.fromRGB(128, 0, 128)},
    {Name = "ส้ม", Color = Color3.fromRGB(255, 165, 0)},
    {Name = "ชมพู", Color = Color3.fromRGB(255, 105, 180)}
}

for i, color in ipairs(colors) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 60, 0, 30)
    button.Position = UDim2.new(0, 10 + (i - 1) * 70, 0, 90)
    button.BackgroundColor3 = color.Color
    button.Text = color.Name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.Gotham
    addModernEffects(button, true)
    button.Parent = SettingsFrame

    button.MouseButton1Click:Connect(function()
        local newColor1 = color.Color
        local newColor2 = Color3.fromRGB(newColor1.R * 0.5 * 255, newColor1.G * 0.5 * 255, newColor1.B * 0.5 * 255)
        SidebarGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, newColor1),
            ColorSequenceKeypoint.new(1, newColor2)
        })
        ContentGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, newColor1),
            ColorSequenceKeypoint.new(1, newColor2)
        })
    end)
end

-- แสดง FPS
local FPSLabel = Instance.new("TextLabel")
FPSLabel.Size = UDim2.new(0, 200, 0, 30)
FPSLabel.Position = UDim2.new(0, 10, 0, 130)
FPSLabel.BackgroundTransparency = 1
FPSLabel.Text = "เฟรมเรต: 0"
FPSLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FPSLabel.TextScaled = true
FPSLabel.Font = Enum.Font.Gotham
FPSLabel.Parent = SettingsFrame

RunService.RenderStepped:Connect(function(deltaTime)
    local fps = math.floor(1 / deltaTime)
    FPSLabel.Text = "เฟรมเรต: " .. fps
end)

-- แสดงเวลาในเกม
local TimeLabel = Instance.new("TextLabel")
TimeLabel.Size = UDim2.new(0, 200, 0, 30)
TimeLabel.Position = UDim2.new(0, 10, 0, 170)
TimeLabel.BackgroundTransparency = 1
TimeLabel.Text = "เวลา: 00:00:00"
TimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TimeLabel.TextScaled = true
TimeLabel.Font = Enum.Font.Gotham
TimeLabel.Parent = SettingsFrame

spawn(function()
    while true do
        local time = os.date("*t")
        TimeLabel.Text = string.format("เวลา: %02d:%02d:%02d", time.hour, time.min, time.sec)
        wait(1)
    end
end)

-- ฟังก์ชันลาก UI
local dragging = false
local dragStart = nil
local startPos = nil

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
    end
end)

Frame.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

Frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ฟังก์ชันปิด/เปิด UI ด้วยแอนิเมชันจาง
local uiVisible = true
ToggleButton.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    if uiVisible then
        Frame.Visible = true
        local tween = TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Position = Frame.Position})
        tween:Play()
    else
        local tween = TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Position = UDim2.new(Frame.Position.X.Scale, Frame.Position.X.Offset, 1, 0)})
        tween:Play()
        wait(0.5)
        Frame.Visible = false
    end
    ToggleButton.Text = uiVisible and "✖" or "✔"
end)

-- แอนิเมชันเริ่มต้น
Frame.Position = UDim2.new(0.5, -300, 1, 0)
Frame.Visible = true
local tween = TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Position = UDim2.new(0.5, -300, 0.5, -150)})
tween:Play()