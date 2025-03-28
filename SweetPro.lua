-- แจ้งเตือนว่าโค้ดเริ่มรัน
print("เริ่มรันโค้ด UltraModernUI บน Arceus X...")

-- ตัวแปรหลัก


-- ตัวแปรเก็บกรอบสีแดง
local highlightBoxes = {}

createFeatureButton("มองทะลุ", 20, 50, function(isActive)
    if isActive then
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and not part:IsDescendantOf(player.Character) then
                originalMaterials[part] = part.Material
                originalTransparency[part] = part.Transparency
                part.Material = Enum.Material.Glass
                part.Transparency = 0.8
            end
        end

        -- เพิ่มกรอบสีแดงให้ผู้เล่นทุกคน
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local highlight = Instance.new("SelectionBox")
                highlight.Adornee = p.Character
                highlight.LineThickness = 0.05
                highlight.Color3 = Color3.fromRGB(255, 0, 0)
                highlight.Parent = p.Character
                highlightBoxes[p] = highlight
            end
        end

        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then
                if p == player then
                    setCollision(p.Character, false)
                end
            end
        end

        player.CharacterAdded:Connect(function(character)
            if isActive then
                setCollision(character, false)
            end
        end)

        Players.PlayerAdded:Connect(function(newPlayer)
            if isActive and newPlayer.Character then
                local highlight = Instance.new("SelectionBox")
                highlight.Adornee = newPlayer.Character
                highlight.LineThickness = 0.05
                highlight.Color3 = Color3.fromRGB(255, 0, 0)
                highlight.Parent = newPlayer.Character
                highlightBoxes[newPlayer] = highlight
            end
        end)
    else
        for part, material in pairs(originalMaterials) do
            part.Material = material
            part.Transparency = originalTransparency[part] or 0
        end
        originalMaterials = {}
        originalTransparency = {}

        -- ลบกรอบสีแดงทั้งหมด
        for _, highlight in pairs(highlightBoxes) do
            highlight:Destroy()
        end
        highlightBoxes = {}

        if player.Character then
            setCollision(player.Character, true)
        end
    end
end)local player = game.Players.LocalPlayer
local Players = game:GetService("Players")
local PhysicsService = game:GetService("PhysicsService")

-- รอให้ PlayerGui โหลด
local success, errorMsg = pcall(function()
    if not player:FindFirstChild("PlayerGui") then
        print("กำลังรอ PlayerGui โหลด...")
        player:WaitForChild("PlayerGui", 15)
    end
end)
if not success then
    print("ไม่สามารถโหลด PlayerGui ได้: " .. errorMsg)
    return
end
if not player.PlayerGui then
    print("PlayerGui ไม่โหลด กรุณาลองใหม่")
    return
end
print("PlayerGui โหลดสำเร็จ!")

-- รอให้ Character โหลด
success, errorMsg = pcall(function()
    if not player.Character then
        print("กำลังรอ Character โหลด...")
        player.CharacterAdded:Wait()
    end
end)
if not success then
    print("ไม่สามารถโหลด Character ได้: " .. errorMsg)
    return
end
print("Character โหลดสำเร็จ!")

-- รอให้ Workspace โหลด
success, errorMsg = pcall(function()
    if not game:IsLoaded() then
        print("กำลังรอ Workspace โหลด...")
        game.Loaded:Wait()
    end
end)
if not success then
    print("ไม่สามารถโหลด Workspace ได้: " .. errorMsg)
    return
end
print("Workspace โหลดสำเร็จ!")

-- ตั้งค่า CollisionGroup สำหรับการเดินทะลุ
local defaultCollisionGroup = "Default"
local noCollisionGroup = "NoCollision"
success, errorMsg = pcall(function()
    PhysicsService:CreateCollisionGroup(noCollisionGroup)
    PhysicsService:CollisionGroupSetCollidable(noCollisionGroup, defaultCollisionGroup, false)
end)
if not success then
    print("ไม่สามารถตั้งค่า CollisionGroup ได้: " .. errorMsg)
end

-- สร้าง ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraModernUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player.PlayerGui
print("สร้าง ScreenGui สำเร็จ!")

-- สร้าง Frame หลัก (หน้าต่าง)
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 350, 0, 300) -- เพิ่มขนาดเพื่อให้มีที่ว่าง
Frame.Position = UDim2.new(0.5, -175, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- สีเทาเข้ม
Frame.BackgroundTransparency = 0.5
Frame.Parent = ScreenGui
print("สร้าง Frame หลักสำเร็จ!")

-- เพิ่ม UIStroke และ UICorner ให้ Frame
local FrameStroke = Instance.new("UIStroke")
FrameStroke.Thickness = 2
FrameStroke.Color = Color3.fromRGB(255, 255, 255)
FrameStroke.Transparency = 0.5
FrameStroke.Parent = Frame

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 8)
FrameCorner.Parent = Frame

-- สร้างปุ่มปิด/เปิด UI
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 30, 0, 30)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
ToggleButton.Text = "🛟"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 18
ToggleButton.Font = Enum.Font.SourceSans
FrameStroke:Clone().Parent = ToggleButton
FrameCorner:Clone().Parent = ToggleButton
ToggleButton.Parent = ScreenGui
print("สร้างปุ่มปิด/เปิด UI สำเร็จ!")

-- สร้างปุ่มเปิดเมนู (เมื่อ UI ถูกปิด)
local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.new(0, 50, 0, 50)
OpenButton.Position = UDim2.new(1, -60, 1, -60)
OpenButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
OpenButton.Text = "เมนู"
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.TextSize = 18
OpenButton.Font = Enum.Font.SourceSans
FrameStroke:Clone().Parent = OpenButton
FrameCorner:Clone().Parent = OpenButton
OpenButton.Visible = false
OpenButton.Parent = ScreenGui
print("สร้างปุ่มเปิดเมนูสำเร็จ!")

-- สร้าง Content Area
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, 0, 0, 250)
Content.Position = UDim2.new(0, 0, 0, 50)
Content.BackgroundTransparency = 1
Content.Parent = Frame
print("สร้าง Content Area สำเร็จ!")

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
print("สร้างหน้า Home และ Settings สำเร็จ!")

-- ปุ่มสลับหน้า (วางด้านบนของ Frame)
local HomeButton = Instance.new("TextButton")
HomeButton.Size = UDim2.new(0, 40, 0, 40)
HomeButton.Position = UDim2.new(0, 60, 0, 5)
HomeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
HomeButton.Text = "🏠"
HomeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
HomeButton.TextSize = 24
HomeButton.Font = Enum.Font.SourceSans
FrameStroke:Clone().Parent = HomeButton
FrameCorner:Clone().Parent = HomeButton
HomeButton.Parent = Frame
HomeButton.MouseButton1Click:Connect(function()
    HomeFrame.Visible = true
    SettingsFrame.Visible = false
end)

local SettingsButton = Instance.new("TextButton")
SettingsButton.Size = UDim2.new(0, 40, 0, 40)
SettingsButton.Position = UDim2.new(0, 110, 0, 5)
SettingsButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SettingsButton.Text = "⚙️"
SettingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingsButton.TextSize = 24
SettingsButton.Font = Enum.Font.SourceSans
FrameStroke:Clone().Parent = SettingsButton
FrameCorner:Clone().Parent = SettingsButton
SettingsButton.Parent = Frame
SettingsButton.MouseButton1Click:Connect(function()
    HomeFrame.Visible = false
    SettingsFrame.Visible = true
end)
print("สร้างปุ่มสลับหน้าสำเร็จ!")

-- ### หน้า Home ###
-- หัวข้อ "เมนูสุดล้ำ"
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 200, 0, 30)
TitleLabel.Position = UDim2.new(0, 10, 0, 10)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "เมนูสุดล้ำ"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 24
TitleLabel.Font = Enum.Font.SourceSans
TitleLabel.Parent = HomeFrame

-- ฟังก์ชันปุ่มในหน้า Home
local function createFeatureButton(name, xPos, yPos, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 120, 0, 40) -- ปุ่มใหญ่ขึ้น
    button.Position = UDim2.new(0, xPos, 0, yPos)
    button.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 18 -- ตัวอักษรใหญ่ขึ้น
    button.Font = Enum.Font.SourceSans
    FrameStroke:Clone().Parent = button
    FrameCorner:Clone().Parent = button
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
local function setCollision(character, canCollide)
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CollisionGroup = canCollide and defaultCollisionGroup or noCollisionGroup
            end
        end
    end
end

createFeatureButton("มองทะลุ", 20, 50, function(isActive)
    if isActive then
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and not part:IsDescendantOf(player.Character) then
                originalMaterials[part] = part.Material
                originalTransparency[part] = part.Transparency
                part.Material = Enum.Material.Glass
                part.Transparency = 0.8
            end
        end

        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then
                if p == player then
                    setCollision(p.Character, false)
                end
            end
        end

        player.CharacterAdded:Connect(function(character)
            if isActive then
                setCollision(character, false)
            end
        end)
    else
        for part, material in pairs(originalMaterials) do
            part.Material = material
            part.Transparency = originalTransparency[part] or 0
        end
        originalMaterials = {}
        originalTransparency = {}

        if player.Character then
            setCollision(player.Character, true)
        end
    end
end)

-- ฟังก์ชัน 2: ออโต้ฟาร์มบล็อกฟุต
local autoFarmActive = false
createFeatureButton("ออโต้ฟาร์ม", 160, 50, function(isActive)
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

createFeatureButton("บิน", 20, 100, function(isActive)
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

createFeatureButton("ความเร็ว", 160, 100, function(isActive)
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

createFeatureButton("กระโดดสูง", 20, 150, function(isActive)
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

createFeatureButton("โหมดเทพ", 160, 150, function(isActive)
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
print("สร้างปุ่มฟีเจอร์ในหน้า Home สำเร็จ!")

-- ### หน้า Settings ###
local SettingsLabel = Instance.new("TextLabel")
SettingsLabel.Size = UDim2.new(0, 200, 0, 30)
SettingsLabel.Position = UDim2.new(0, 10, 0, 10)
SettingsLabel.BackgroundTransparency = 1
SettingsLabel.Text = "ตั้งค่า"
SettingsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingsLabel.TextSize = 24
SettingsLabel.Font = Enum.Font.SourceSans
SettingsLabel.Parent = SettingsFrame

-- ปรับสีเมนู
local ColorLabel = Instance.new("TextLabel")
ColorLabel.Size = UDim2.new(0, 200, 0, 20)
ColorLabel.Position = UDim2.new(0, 10, 0, 40)
ColorLabel.BackgroundTransparency = 1
ColorLabel.Text = "สีเมนู"
ColorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ColorLabel.TextSize = 20
ColorLabel.Font = Enum.Font.SourceSans
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
    button.Size = UDim2.new(0, 60, 0, 35) -- ปุ่มใหญ่ขึ้น
    if i <= 4 then
        -- แถวแรก (4 ปุ่ม)
        button.Position = UDim2.new(0, 20 + (i - 1) * 70, 0, 70)
    else
        -- แถวที่สอง (3 ปุ่ม)
        button.Position = UDim2.new(0, 20 + (i - 5) * 70, 0, 120)
    end
    button.BackgroundColor3 = color.Color
    button.Text = color.Name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 16 -- ตัวอักษรใหญ่ขึ้น
    button.Font = Enum.Font.SourceSans
    FrameStroke:Clone().Parent = button
    FrameCorner:Clone().Parent = button
    button.Parent = SettingsFrame

    button.MouseButton1Click:Connect(function()
        Frame.BackgroundColor3 = color.Color
    end)
end
print("สร้างหน้า Settings สำเร็จ!")

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
    ToggleButton.Text = uiVisible and "💫" or "🌟"
end)

OpenButton.MouseButton1Click:Connect(function()
    uiVisible = true
    Frame.Visible = true
    OpenButton.Visible = false
    ToggleButton.Text = "💫"
end)

-- แจ้งเตือนว่าโค้ดรันสำเร็จ
print("โค้ด UltraModernUI รันสำเร็จ! UI ควรปรากฏแล้ว")