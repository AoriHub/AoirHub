-- ตรวจสอบว่าโค้ดรันใน Roblox หรือไม่
if not game:IsLoaded() then
    game.Loaded:Wait()
    warn("เกมโหลดสำเร็จ")
end

-- ตัวแปรเก็บสถานะ
local player = game.Players.LocalPlayer
local isFlying = false
local isNoClip = false
local walkSpeed = 160 -- ความเร็วเริ่มต้นในการเดิน
local noClipConnection = nil

-- สร้าง ScreenGui
local playerGui = player:WaitForChild("PlayerGui", 15)
if not playerGui then
    warn("ไม่สามารถเข้าถึง PlayerGui ได้ กรุณาตรวจสอบว่าเกมอนุญาตให้ใช้ UI หรือไม่")
    return
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FuturisticUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui
warn("ScreenGui ถูกสร้างสำเร็จ")

-- สร้างปุ่มเปิด/ปิด UI
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 60, 0, 60)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 0, 100)
toggleButton.Text = "✅"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.BorderSizePixel = 0
toggleButton.Parent = screenGui

-- เพิ่ม UIStroke สำหรับปุ่มเปิด/ปิด (เรืองแสง)
local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(128, 0, 255)
toggleStroke.Thickness = 2
toggleStroke.Transparency = 0.5
toggleStroke.Parent = toggleButton
warn("ปุ่มเปิด/ปิด UI ถูกสร้างสำเร็จ")

-- สร้าง Frame หลักของ UI
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundTransparency = 0.75
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- เพิ่ม UIGradient สำหรับ Frame (ไล่สี)
local uiGradient = Instance.new("UIGradient")
uiGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 0, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(128, 0, 255))
})
uiGradient.Rotation = 45
uiGradient.Parent = mainFrame

-- เพิ่ม UIStroke สำหรับ Frame (เรืองแสง)
local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Color3.fromRGB(128, 0, 255)
frameStroke.Thickness = 3
frameStroke.Transparency = 0.3
frameStroke.Parent = mainFrame
warn("Frame หลักของ UI ถูกสร้างสำเร็จ")

-- เพิ่ม Label ชื่อเมนู
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "เมนูหลัก"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SciFi
titleLabel.Parent = mainFrame
warn("Label ชื่อเมนูถูกสร้างสำเร็จ")

-- สร้าง Frame สำหรับช่องตั้งค่าความเร็ว
local speedFrame = Instance.new("Frame")
speedFrame.Size = UDim2.new(1, -20, 0, 60)
speedFrame.Position = UDim2.new(0, 10, 0, 40)
speedFrame.BackgroundTransparency = 0.9
speedFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
speedFrame.Parent = mainFrame

-- เพิ่ม UIGradient สำหรับ speedFrame
local speedGradient = Instance.new("UIGradient")
speedGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 0, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(128, 0, 255))
})
speedGradient.Rotation = 45
speedGradient.Parent = speedFrame

-- เพิ่ม UIStroke สำหรับ speedFrame
local speedStroke = Instance.new("UIStroke")
speedStroke.Color = Color3.fromRGB(128, 0, 255)
speedStroke.Thickness = 2
speedStroke.Transparency = 0.5
speedStroke.Parent = speedFrame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.4, 0, 0, 40)
speedLabel.Position = UDim2.new(0, 10, 0, 10)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "ความเร็วเดิน:"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextScaled = true
speedLabel.Parent = speedFrame

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0.3, 0, 0, 40)
speedBox.Position = UDim2.new(0.4, 0, 0, 10)
speedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
speedBox.Text = tostring(walkSpeed) -- ค่าเริ่มต้น 160
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.TextScaled = true
speedBox.Parent = speedFrame

local applySpeedButton = Instance.new("TextButton")
applySpeedButton.Size = UDim2.new(0.25, 0, 0, 40)
applySpeedButton.Position = UDim2.new(0.75, 0, 0, 10)
applySpeedButton.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
applySpeedButton.Text = "ตั้งค่า"
applySpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
applySpeedButton.TextScaled = true
applySpeedButton.Parent = speedFrame

-- เพิ่ม ScrollingFrame สำหรับตัวเลื่อน (สำหรับปุ่มฟังก์ชัน)
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, -20, 1, -110)
scrollingFrame.Position = UDim2.new(0, 10, 0, 110)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.ScrollBarThickness = 5
scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(128, 0, 255)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.Parent = mainFrame
warn("ScrollingFrame ถูกสร้างสำเร็จ")

-- เพิ่ม UIListLayout เพื่อจัดเรียงปุ่ม
local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0, 10)
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Parent = scrollingFrame
warn("UIListLayout ถูกสร้างสำเร็จ")

-- สร้าง TextBox และปุ่มส่งสำหรับกล่องข้อความ
local messageFrame = Instance.new("Frame")
messageFrame.Size = UDim2.new(1, -20, 0, 60)
messageFrame.Position = UDim2.new(0, 10, 1, -70)
messageFrame.BackgroundTransparency = 0.9
messageFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
messageFrame.Visible = false
messageFrame.Parent = mainFrame

-- เพิ่ม UIGradient สำหรับ messageFrame
local messageGradient = Instance.new("UIGradient")
messageGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 0, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(128, 0, 255))
})
messageGradient.Rotation = 45
messageGradient.Parent = messageFrame

-- เพิ่ม UIStroke สำหรับ messageFrame
local messageStroke = Instance.new("UIStroke")
messageStroke.Color = Color3.fromRGB(128, 0, 255)
messageStroke.Thickness = 2
messageStroke.Transparency = 0.5
messageStroke.Parent = messageFrame

local messageBox = Instance.new("TextBox")
messageBox.Size = UDim2.new(0.7, 0, 0, 40)
messageBox.Position = UDim2.new(0, 10, 0, 10)
messageBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
messageBox.Text = "พิมพ์ข้อความที่นี่..."
messageBox.TextColor3 = Color3.fromRGB(255, 255, 255)
messageBox.TextScaled = true
messageBox.ClearTextOnFocus = true
messageBox.Parent = messageFrame

local sendButton = Instance.new("TextButton")
sendButton.Size = UDim2.new(0.25, 0, 0, 40)
sendButton.Position = UDim2.new(0.75, 0, 0, 10)
sendButton.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
sendButton.Text = "ส่ง"
sendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
sendButton.TextScaled = true
sendButton.Parent = messageFrame

-- สีสำหรับปุ่ม
local buttonOnColor = Color3.fromRGB(128, 0, 255) -- สีเมื่อเปิด
local buttonOffColor = Color3.fromRGB(50, 0, 100) -- สีเมื่อปิด

-- ฟังก์ชันสร้างปุ่มสำหรับฟังก์ชัน
local function createToggleButton(label, callback)
    local toggleState = false
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 40)
    button.BackgroundColor3 = buttonOffColor
    button.Text = label .. " (ปิด)"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.SciFi
    button.BorderSizePixel = 0
    button.Parent = scrollingFrame

    -- เพิ่ม UIGradient สำหรับปุ่ม
    local buttonGradient = Instance.new("UIGradient")
    buttonGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, buttonOffColor),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 0, 150))
    })
    buttonGradient.Rotation = 45
    buttonGradient.Parent = button

    -- เพิ่ม UIStroke สำหรับปุ่ม (เรืองแสง)
    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Color = Color3.fromRGB(128, 0, 255)
    buttonStroke.Thickness = 2
    buttonStroke.Transparency = 0.5
    buttonStroke.Parent = button

    button.MouseButton1Click:Connect(function()
        toggleState = not toggleState
        button.Text = label .. (toggleState and " (เปิด)" or " (ปิด)")
        button.BackgroundColor3 = toggleState and buttonOnColor or buttonOffColor
        buttonGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, toggleState and buttonOnColor or buttonOffColor),
            ColorSequenceKeypoint.new(1, toggleState and Color3.fromRGB(180, 0, 255) or Color3.fromRGB(80, 0, 150))
        })
        callback(toggleState)
    end)

    -- อัปเดต CanvasSize ของ ScrollingFrame
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
    warn("ปุ่ม " .. label .. " ถูกสร้างสำเร็จ")
end

-- ฟังก์ชันบินอัตโนมัติ (ปรับจากโค้ดที่คุณให้มา)
createToggleButton("บินอัตโนมัติ", function(isActive)
    isFlying = isActive
    if isFlying then
        coroutine.wrap(function()
            if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                player.CharacterAdded:Wait()
                warn("ตัวละครโหลดสำเร็จสำหรับฟังก์ชันบินอัตโนมัติ")
            end
            local character = player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            if not (humanoid and rootPart) then
                warn("ไม่พบ Humanoid หรือ HumanoidRootPart สำหรับฟังก์ชันบินอัตโนมัติ")
                return
            end

            -- ปลดล็อกข้อจำกัด
            humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            rootPart.Anchored = false
            for _, constraint in pairs(rootPart:GetJoints()) do
                if constraint:IsA("Weld") or constraint:IsA("WeldConstraint") then
                    constraint:Destroy()
                    warn("พบและลบ Weld/WeldConstraint ที่ยึดตัวละคร")
                end
            end
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                    part.Anchored = false
                end
            end
            humanoid.PlatformStand = true
            humanoid.Sit = false

            -- สร้าง BodyVelocity
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.Parent = rootPart

            -- ยกตัวละครขึ้นเมื่อเริ่มบิน
            rootPart.CFrame = rootPart.CFrame + Vector3.new(0, 10, 0)
            warn("ยกตัวละครขึ้น 10 หน่วย")

            while isFlying do
                if humanoid and rootPart then
                    local moveDirection = humanoid.MoveDirection * walkSpeed
                    bodyVelocity.Velocity = Vector3.new(moveDirection.X, 0, moveDirection.Z)
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                        bodyVelocity.Velocity = bodyVelocity.Velocity + Vector3.new(0, walkSpeed, 0)
                        warn("กด Space: บินขึ้น")
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
                        bodyVelocity.Velocity = bodyVelocity.Velocity + Vector3.new(0, -walkSpeed, 0)
                        warn("กด Shift: บินลง")
                    end
                end
                wait()
            end
            bodyVelocity:Destroy()
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
            humanoid.PlatformStand = false
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                    part.Anchored = false
                end
            end
        end)()
    end
end)

-- ฟังก์ชันตั้งค่าความเร็วในการเดิน
applySpeedButton.MouseButton1Click:Connect(function()
    local newSpeed = tonumber(speedBox.Text)
    if newSpeed then
        if newSpeed < 0 then
            newSpeed = 0
            speedBox.Text = "0"
            warn("ความเร็วต้องไม่ต่ำกว่า 0")
        elseif newSpeed > 500 then
            newSpeed = 500
            speedBox.Text = "500"
            warn("ความเร็วสูงสุดคือ 500")
        end
        walkSpeed = newSpeed
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = walkSpeed
                warn("ตั้งค่าความเร็วในการเดินเป็น: " .. walkSpeed)
            end
        end
    else
        speedBox.Text = tostring(walkSpeed)
        warn("กรุณาใส่ตัวเลขที่ถูกต้อง")
    end
end)

-- ฟังก์ชันเดินเร็วขึ้น
createToggleButton("เดินเร็วขึ้น", function(state)
    if not player.Character then
        player.CharacterAdded:Wait()
        warn("ตัวละครโหลดสำเร็จสำหรับฟังก์ชันเดินเร็วขึ้น")
    end
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not (humanoid and rootPart) then
        warn("ไม่พบ Humanoid หรือ HumanoidRootPart สำหรับฟังก์ชันเดินเร็วขึ้น")
        return
    end

    if state then
        humanoid.WalkSpeed = walkSpeed
        warn("เดินเร็วขึ้น: เปิด (ความเร็ว: " .. walkSpeed .. ")")
    else
        humanoid.WalkSpeed = 16
        warn("เดินเร็วขึ้น: ปิด")
    end
end)

-- ฟังก์ชันกันแบน (เดินทะลุสิ่งกีดขวาง)
createToggleButton("กันแบน (เดินทะลุ)", function(state)
    isNoClip = state
    if not player.Character then
        player.CharacterAdded:Wait()
        warn("ตัวละครโหลดสำเร็จสำหรับฟังก์ชันกันแบน")
    end
    local character = player.Character
    if not character then
        warn("ไม่พบตัวละครสำหรับฟังก์ชันกันแบน")
        return
    end

    if state then
        warn("กันแบน (เดินทะลุ): เปิด")
        warn("คำเตือน: การใช้ฟังก์ชันนี้อาจถูกตรวจจับโดยระบบป้องกันการโกงของเกม!")
        noClipConnection = game:GetService("RunService").Stepped:Connect(function()
            if not isNoClip then return end
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end)
    else
        warn("กันแบน (เดินทะลุ): ปิด")
        if noClipConnection then
            noClipConnection:Disconnect()
            noClipConnection = nil
        end
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)

-- ฟังก์ชันกล่องข้อความ
createToggleButton("กล่องข้อความ", function(state)
    messageFrame.Visible = state
    if state then
        warn("กล่องข้อความ: เปิด")
    else
        warn("กล่องข้อความ: ปิด")
    end
end)

-- ฟังก์ชันส่งข้อความ
sendButton.MouseButton1Click:Connect(function()
    local message = messageBox.Text
    if message and message ~= "" and message ~= "พิมพ์ข้อความที่นี่..." then
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, "All")
        warn("ส่งข้อความ: " .. message)
        messageBox.Text = "พิมพ์ข้อความที่นี่..."
    end
end)

-- ฟังก์ชันลาก UI
local dragging = false
local dragStart = nil
local startPos = nil

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ฟังก์ชันเปิด/ปิด UI
toggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    toggleButton.Text = mainFrame.Visible and "❌" or "✅"
    toggleButton.BackgroundColor3 = mainFrame.Visible and Color3.fromRGB(128, 0, 255) or Color3.fromRGB(50, 0, 100)
    warn(mainFrame.Visible and "UI: เปิด" or "UI: ปิด")
end)

-- แจ้งเตือนว่าโค้ดโหลดสำเร็จ
warn("โค้ดโหลดสำเร็จ! คลิกปุ่ม ✅ เพื่อเปิด UI")