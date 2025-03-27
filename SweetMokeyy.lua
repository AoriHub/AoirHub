-- แจ้งเตือนว่าโค้ดเริ่มรัน
print("เริ่มรันโค้ด UltraModernUI บน Arceus X...")

-- สร้าง ScreenGui สำหรับ UI
local player = game.Players.LocalPlayer
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- รอให้ PlayerGui โหลด
if not player:FindFirstChild("PlayerGui") then
    print("กำลังรอ PlayerGui โหลด...")
    player:WaitForChild("PlayerGui", 10)
end
if not player.PlayerGui then
    print("PlayerGui ไม่โหลด กรุณาลองใหม่")
    return
end
print("PlayerGui โหลดสำเร็จ!")

-- รอให้ Character โหลด
if not player.Character then
    print("กำลังรอ Character โหลด...")
    player.CharacterAdded:Wait()
end
print("Character โหลดสำเร็จ!")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraModernUI"
ScreenGui.Parent = player.PlayerGui
ScreenGui.ResetOnSpawn = false -- ป้องกัน UI หายเมื่อตาย

-- สร้าง Frame หลัก (หน้าต่าง)
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 600, 0, 300)
Frame.Position = UDim2.new(0.5, -300, 0.5, -150)
Frame.BackgroundTransparency = 1
Frame.Parent = ScreenGui

-- ฟังก์ชันเพิ่มเอฟเฟกต์ทันสมัย (ลดความซับซ้อน)
local function addModernEffects(element, glow)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.5
    stroke.Parent = element

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = element
end

-- สร้างปุ่มปิด/เปิด UI
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 60, 0, 60)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
ToggleButton.Text = "✖"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 24
ToggleButton.Font = Enum.Font.SourceSansBold
addModernEffects(ToggleButton, true)
ToggleButton.Parent = ScreenGui

-- สร้างปุ่มเปิดเมนู (เมื่อ UI ถูกปิด)
local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.new(0, 50, 0, 50)
OpenButton.Position = UDim2.new(1, -60, 1, -60) -- มุมขวาล่าง
OpenButton.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
OpenButton.Text = "เมนู"
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.TextSize = 20
OpenButton.Font = Enum.Font.SourceSansBold
OpenButton.Visible = false
addModernEffects(OpenButton, true)
OpenButton.Parent = ScreenGui

-- สร้าง Sidebar (ด้านซ้าย)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 70, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Sidebar.BackgroundTransparency = 0.75 -- โปร่งใส 75%
addModernEffects(Sidebar, true)
Sidebar.Parent = Frame

-- สร้าง Content Area (ด้านขวา)
local Content = Instance.new("Frame")
Content.Size = UDim2.new(0, 520, 1, 0)
Content.Position = UDim2.new(0, 80, 0, 0)
Content.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Content.BackgroundTransparency = 0.75 -- โปร่งใส 75%
addModernEffects(Content, true)
Content.Parent = Frame

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
local function createSidebarButton(icon, yPos, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 50, 0, 50)
    button.Position = UDim2.new(0, 10, 0, yPos)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    button.Text = icon
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 20
    button.Font = Enum.Font.SourceSansBold
    addModernEffects(button, true)
    button.Parent = Sidebar

    button.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
end

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
TitleLabel.TextSize = 24
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Parent = HomeFrame

-- หัวข้อ "หน้าหลัก"
local DashboardLabel = Instance.new("TextLabel")
DashboardLabel.Size = UDim2.new(0, 100, 0, 30)
DashboardLabel.Position = UDim2.new(0, 410, 0, 10)
DashboardLabel.BackgroundTransparency = 1
DashboardLabel.Text = "หน้าหลัก"
DashboardLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
DashboardLabel.TextSize = 20
DashboardLabel.Font = Enum.Font.SourceSansBold
DashboardLabel.Parent = HomeFrame

-- ชื่อผู้ใช้
local UserLabel = Instance.new("TextLabel")
UserLabel.Size = UDim2.new(0, 200, 0, 30)
UserLabel.Position = UDim2.new(0, 10, 0, 60)
UserLabel.BackgroundTransparency = 1
UserLabel.Text = "ยินดีต้อนรับ, " .. player.Name
UserLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
UserLabel.TextSize = 20
UserLabel.Font = Enum.Font.SourceSansBold
UserLabel.Parent = HomeFrame

-- หัวข้อ "ฟีเจอร์"
local FeaturesLabel = Instance.new("TextLabel")
FeaturesLabel.Size = UDim2.new(0, 200, 0, 30)
FeaturesLabel.Position = UDim2.new(0, 10, 0, 100)
FeaturesLabel.BackgroundTransparency = 1
FeaturesLabel.Text = "ฟีเจอร์"
FeaturesLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FeaturesLabel.TextSize = 20
FeaturesLabel.Font = Enum.Font.SourceSansBold
FeaturesLabel.Parent = HomeFrame

-- ฟังก์ชันปุ่มในหน้า Home
local function createFeatureButton(name, xPos, yPos, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 150, 0, 35)
    button.Position = UDim2.new(0, xPos, 0, yPos)
    button.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 18
    button.Font = Enum.Font.SourceSans
    addModernEffects(button, true)
    button.Parent = HomeFrame

    local isActive = false
    button.MouseButton1Click:Connect(function()
        isActive = not isActive
        button.Text = name .. (isActive and " [เปิด]" or "")
        if callback then callback(isActive) end
    end)
end

-- ฟังก์ชัน 1: มองทะลุสิ่งของในแมพ
local originalMaterials = {}
local originalTransparency = {}
createFeatureButton("มองทะลุ", 10, 140, function(isActive)
    if isActive then
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and not part:IsDescendantOf(player.Character) then
                originalMaterials[part] = part.Material
                originalTransparency[part] = part.Transparency
                part.Material = Enum.Material.Glass
                part.Transparency = 0.8
            end
        end
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
        coroutine.wrap(function()
            while autoFarmActive do
                local character = player.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local humanoid = character:FindFirstChild("Humanoid")
                    local rootPart = character:FindFirstChild("HumanoidRootPart")
                    for _, enemy in pairs(workspace:GetChildren()) do
                        if enemy.Name:find("Enemy") and enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") then
                            local enemyHumanoid = enemy:FindFirstChild("Humanoid")
                            local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")
                            if enemyHumanoid and enemyHumanoid.Health > 0 then
                                humanoid:MoveTo(enemyRoot.Position)
                                humanoid.MoveToFinished:Wait()
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
        end)()
    end
end)

-- ฟังก์ชัน 3: ออโต้บิน, ปรับความเร็ว, กระโดดสูง, ไม่ตาย
local flyActive = false
local speedValue = 50
local jumpValue = 50
local godModeActive = false

createFeatureButton("บินอัตโนมัติ", 310, 100, function(isActive)
    flyActive = isActive
    if flyActive then
        coroutine.wrap(function()
            if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                player.CharacterAdded:Wait()
            end
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
        end)()
    end
end)

createFeatureButton("ปรับความเร็ว", 310, 145, function(isActive)
    if isActive then
        if not player.Character or not player.Character:FindFirstChild("Humanoid") then
            player.CharacterAdded:Wait()
        end
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = speedValue
        end
    else
        if not player.Character or not player.Character:FindFirstChild("Humanoid") then
            player.CharacterAdded:Wait()
        end
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = 16
        end
    end
end)

createFeatureButton("กระโดดสูง", 310, 190, function(isActive)
    if isActive then
        if not player.Character or not player.Character:FindFirstChild("Humanoid") then
            player.CharacterAdded:Wait()
        end
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.JumpPower = jumpValue
        end
    else
        if not player.Character or not player.Character:FindFirstChild("Humanoid") then
            player.CharacterAdded:Wait()
        end
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.JumpPower = 50
        end
    end
end)

-- โหมดเทพ
createFeatureButton("โหมดเทพ", 310, 235, function(isActive)
    godModeActive = isActive
    if godModeActive then
        coroutine.wrap(function()
            while godModeActive do
                if not player.Character or not player.Character:FindFirstChild("Humanoid") then
                    player.CharacterAdded:Wait()
                end
                local character = player.Character
                if character and character:FindFirstChild("Humanoid") then
                    local humanoid = character:FindFirstChild("Humanoid")
                    humanoid.MaxHealth = math.huge
                    humanoid.Health = math.huge
                    humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                        if humanoid.Health < math.huge then
                            humanoid.Health = math.huge
                        end
                    end)
                    player.CharacterAdded:Connect(function(newCharacter)
                        if godModeActive then
                            wait()
                            local newHumanoid = newCharacter:WaitForChild("Humanoid")
                            newHumanoid.MaxHealth = math.huge
                            newHumanoid.Health = math.huge
                        end
                    end)
                end
                wait()
            end
        end)()
    else
        if not player.Character or not player.Character:FindFirstChild("Humanoid") then
            player.CharacterAdded:Wait()
        end
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            local humanoid = character:FindFirstChild("Humanoid")
            humanoid.MaxHealth = 100
            humanoid.Health = 100
        end
    end
end)

-- ### หน้า Settings ###
local SettingsLabel = Instance.new("TextLabel")
SettingsLabel.Size = UDim2.new(0, 200, 0, 30)
SettingsLabel.Position = UDim2.new(0, 10, 0, 10)
SettingsLabel.BackgroundTransparency = 1
SettingsLabel.Text = "ตั้งค่า"
SettingsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingsLabel.TextSize = 20
SettingsLabel.Font = Enum.Font.SourceSansBold
SettingsLabel.Parent = SettingsFrame

-- ปรับสีเมนู
local ColorLabel = Instance.new("TextLabel")
ColorLabel.Size = UDim2.new(0, 200, 0, 30)
ColorLabel.Position = UDim2.new(0, 10, 0, 50)
ColorLabel.BackgroundTransparency = 1
ColorLabel.Text = "สีเมนู"
ColorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ColorLabel.TextSize = 20
ColorLabel.Font = Enum.Font.SourceSansBold
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
    button.TextSize = 18
    button.Font = Enum.Font.SourceSans
    addModernEffects(button, true)
    button.Parent = SettingsFrame

    button.MouseButton1Click:Connect(function()
        Sidebar.BackgroundColor3 = color.Color
        Content.BackgroundColor3 = color.Color
    end)
end

-- เพิ่มส่วน FPS
local FPSLabel = Instance.new("TextLabel")
FPSLabel.Size = UDim2.new(0, 200, 0, 30)
FPSLabel.Position = UDim2.new(0, 10, 0, 130)
FPSLabel.BackgroundTransparency = 1
FPSLabel.Text = "เฟรมเรต: 0"
FPSLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FPSLabel.TextSize = 18
FPSLabel.Font = Enum.Font.SourceSans
FPSLabel.Parent = SettingsFrame

-- คำนวณ FPS ด้วย Heartbeat
print("เริ่มคำนวณ FPS...")
local frameCount = 0
local lastTime = tick()
coroutine.wrap(function()
    while true do
        frameCount = frameCount + 1
        local currentTime = tick()
        if currentTime - lastTime >= 1 then
            local fps = math.floor(frameCount / (currentTime - lastTime))
            FPSLabel.Text = "เฟรมเรต: " .. fps
            frameCount = 0
            lastTime = currentTime
        end
        RunService.Heartbeat:Wait()
    end
end)()

-- เพิ่มส่วนเวลา (ใช้ tick() แทน os.date)
local TimeLabel = Instance.new("TextLabel")
TimeLabel.Size = UDim2.new(0, 200, 0, 30)
TimeLabel.Position = UDim2.new(0, 10, 0, 170)
TimeLabel.BackgroundTransparency = 1
TimeLabel.Text = "เวลา: 00:00:00"
TimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TimeLabel.TextSize = 18
TimeLabel.Font = Enum.Font.SourceSans
TimeLabel.Parent = SettingsFrame

-- คำนวณเวลาที่ผ่านไป
print("เริ่มคำนวณเวลา...")
local startTime = tick()
coroutine.wrap(function()
    while true do
        local elapsed = math.floor(tick() - startTime)
        local hours = math.floor(elapsed / 3600)
        local minutes = math.floor((elapsed % 3600) / 60)
        local seconds = elapsed % 60
        TimeLabel.Text = string.format("เวลา: %02d:%02d:%02d", hours, minutes, seconds)
        wait(1)
    end
end)()

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

-- ฟังก์ชันปิด/เปิด UI
local uiVisible = true
ToggleButton.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    if uiVisible then
        Frame.Visible = true
        OpenButton.Visible = false
    else
        Frame.Visible = false
        OpenButton.Visible = true
    end
    ToggleButton.Text = uiVisible and "✖" or "✔"
end)

OpenButton.MouseButton1Click:Connect(function()
    uiVisible = true
    Frame.Visible = true
    OpenButton.Visible = false
    ToggleButton.Text = "✖"
end)

-- แจ้งเตือนว่าโค้ดรันสำเร็จ
print("โค้ด UltraModernUI รันสำเร็จ! UI ควรปรากฏแล้ว")