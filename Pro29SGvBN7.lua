-- ส่วนที่ 1: การตรวจสอบและตั้งค่าพื้นฐาน
if not game:IsLoaded() then
    game.Loaded:Wait()
    warn("เกมโหลดสำเร็จ")
end

local player = game.Players.LocalPlayer
local isFlying = false
local isNoClip = false
local isInvisible = false
local walkSpeed = 5000
local flySpeed = 400
local verticalFlySpeed = 400
local noClipConnection = nil
local preventDeathConnection = nil
local vehicleBodyVelocityConnection = nil
local invisibleConnection = nil
local highlightConnections = {}
local selectionBoxes = {}
local nameGuis = {}
warn("ตั้งค่าตัวแปรพื้นฐานสำเร็จ")
-- ส่วนที่ 2: สร้าง ScreenGui และปุ่มเปิด/ปิด UI
local playerGui = player:WaitForChild("PlayerGui", 15)
if not playerGui then
    warn("ไม่สามารถเข้าถึง PlayerGui ได้ กรุณาตรวจสอบว่าเกมอนุญาตให้ใช้ UI หรือ Executor รองรับการรัน UI")
    return
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FuturisticUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui
warn("ScreenGui ถูกสร้างสำเร็จ")

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 60, 0, 60)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 0, 100)
toggleButton.Text = "✅"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.BorderSizePixel = 0
toggleButton.Parent = screenGui

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(128, 0, 255)
toggleStroke.Thickness = 2
toggleStroke.Transparency = 0.5
toggleStroke.Parent = toggleButton
warn("ปุ่มเปิด/ปิด UI ถูกสร้างสำเร็จ")
-- ส่วนที่ 3: สร้าง Frame หลักและ Scrollbar
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 600)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -300)
mainFrame.BackgroundTransparency = 0.75
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.Visible = false
mainFrame.Parent = screenGui

local uiGradient = Instance.new("UIGradient")
uiGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 0, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(128, 0, 255))
})
uiGradient.Rotation = 45
uiGradient.Parent = mainFrame

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Color3.fromRGB(128, 0, 255)
frameStroke.Thickness = 3
frameStroke.Transparency = 0.3
frameStroke.Parent = mainFrame
warn("Frame หลักของ UI ถูกสร้างสำเร็จ")

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, -10, 1, -40)
scrollingFrame.Position = UDim2.new(0, 5, 0, 35)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.ScrollBarThickness = 5
scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(128, 0, 255)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 800)
scrollingFrame.Parent = mainFrame
warn("ScrollingFrame ถูกสร้างสำเร็จ")

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
speedBox.Size = UDim2.new(0.55, 0, 0, 40)
speedBox.Position = UDim2.new(0.45, 0, 0, 10)
speedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
speedBox.Text = tostring(walkSpeed) -- ค่าเริ่มต้น 5000
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.TextScaled = true
speedBox.Parent = speedFrame

-- สร้าง Frame สำหรับช่องตั้งค่าความเร็วแนวตั้ง
local verticalSpeedFrame = Instance.new("Frame")
verticalSpeedFrame.Size = UDim2.new(1, -20, 0, 60)
verticalSpeedFrame.Position = UDim2.new(0, 10, 0, 110)
verticalSpeedFrame.BackgroundTransparency = 0.9
verticalSpeedFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
verticalSpeedFrame.Parent = mainFrame

-- เพิ่ม UIGradient สำหรับ verticalSpeedFrame
local verticalSpeedGradient = Instance.new("UIGradient")
verticalSpeedGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 0, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(128, 0, 255))
})
verticalSpeedGradient.Rotation = 45
verticalSpeedGradient.Parent = verticalSpeedFrame

-- เพิ่ม UIStroke สำหรับ verticalSpeedFrame
local verticalSpeedStroke = Instance.new("UIStroke")
verticalSpeedStroke.Color = Color3.fromRGB(128, 0, 255)
verticalSpeedStroke.Thickness = 2
verticalSpeedStroke.Transparency = 0.5
verticalSpeedStroke.Parent = verticalSpeedFrame

local verticalSpeedLabel = Instance.new("TextLabel")
verticalSpeedLabel.Size = UDim2.new(0.4, 0, 0, 40)
verticalSpeedLabel.Position = UDim2.new(0, 10, 0, 10)
verticalSpeedLabel.BackgroundTransparency = 1
verticalSpeedLabel.Text = "ความเร็วบินแนวตั้ง:"
verticalSpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
verticalSpeedLabel.TextScaled = true
verticalSpeedLabel.Parent = verticalSpeedFrame

local verticalSpeedBox = Instance.new("TextBox")
verticalSpeedBox.Size = UDim2.new(0.55, 0, 0, 40)
verticalSpeedBox.Position = UDim2.new(0.45, 0, 0, 10)
verticalSpeedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
verticalSpeedBox.Text = tostring(verticalFlySpeed)
verticalSpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
verticalSpeedBox.TextScaled = true
verticalSpeedBox.Parent = verticalSpeedFrame

-- สร้าง Frame สำหรับช่องตั้งค่าระดับความสูง
local heightFrame = Instance.new("Frame")
heightFrame.Size = UDim2.new(1, -20, 0, 60)
heightFrame.Position = UDim2.new(0, 10, 0, 180)
heightFrame.BackgroundTransparency = 0.9
heightFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
heightFrame.Parent = mainFrame

-- เพิ่ม UIGradient สำหรับ heightFrame
local heightGradient = Instance.new("UIGradient")
heightGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 0, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(128, 0, 255))
})
heightGradient.Rotation = 45
heightGradient.Parent = heightFrame

-- เพิ่ม UIStroke สำหรับ heightFrame
local heightStroke = Instance.new("UIStroke")
heightStroke.Color = Color3.fromRGB(128, 0, 255)
heightStroke.Thickness = 2
heightStroke.Transparency = 0.5
heightStroke.Parent = heightFrame

local heightLabel = Instance.new("TextLabel")
heightLabel.Size = UDim2.new(0.4, 0, 0, 40)
heightLabel.Position = UDim2.new(0, 10, 0, 10)
heightLabel.BackgroundTransparency = 1
heightLabel.Text = "ระดับความสูง:"
heightLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
heightLabel.TextScaled = true
heightLabel.Parent = heightFrame

local heightBox = Instance.new("TextBox")
heightBox.Size = UDim2.new(0.55, 0, 0, 40)
heightBox.Position = UDim2.new(0.45, 0, 0, 10)
heightBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
heightBox.Text = "0"
heightBox.TextColor3 = Color3.fromRGB(255, 255, 255)
heightBox.TextScaled = true
heightBox.Parent = heightFrame

-- เพิ่ม ScrollingFrame สำหรับตัวเลื่อน (สำหรับปุ่มฟังก์ชัน)
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, -20, 1, -250)
scrollingFrame.Position = UDim2.new(0, 10, 0, 250)
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

    return button -- คืนค่า button เพื่อใช้ในการจัดตำแหน่ง
end
-- ฟังก์ชันบินอัตโนมัติ (ปรับให้วัตถุที่นั่งบินได้ และเพิ่มระดับการบิน)
createToggleButton("บินอัตโนมัติ", function(isActive)
    isFlying = isActive
    if isFlying then
        coroutine.wrap(function()
            -- รอตัวละคร
            if not player.Character then
                player.CharacterAdded:Wait()
                warn("ตัวละครโหลดสำเร็จสำหรับฟังก์ชันบินอัตโนมัติ")
            end
            local character = player.Character
            local humanoid = character:WaitForChild("Humanoid", 5)
            local rootPart = character:WaitForChild("HumanoidRootPart", 5)
            if not (humanoid and rootPart) then
                warn("ไม่พบ Humanoid หรือ HumanoidRootPart สำหรับฟังก์ชันบินอัตโนมัติ")
                return
            end

            -- ตรวจสอบว่าตัวละครนั่งอยู่บนวัตถุหรือไม่
            local vehiclePart = nil
            if humanoid.SeatPart then
                vehiclePart = humanoid.SeatPart.Parent
                warn("ตรวจพบวัตถุที่นั่ง: " .. vehiclePart.Name)
            else
                for _, constraint in pairs(rootPart:GetJoints()) do
                    if constraint:IsA("Weld") or constraint:IsA("Motor") then
                        vehiclePart = constraint.Part1 == rootPart and constraint.Part0 or constraint.Part1
                        if vehiclePart then
                            warn("ตรวจพบวัตถุที่นั่งผ่าน Weld/Motor: " .. vehiclePart.Name)
                            break
                        end
                    end
                end
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

            -- ถ้ามีวัตถุที่นั่ง ปลดล็อกวัตถุด้วย
            if vehiclePart then
                for _, part in pairs(vehiclePart:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                        part.Anchored = false
                    end
                end
            end

            -- สร้าง BodyVelocity
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.Parent = vehiclePart or rootPart -- ถ้ามีวัตถุที่นั่ง ใช้ BodyVelocity กับวัตถุ

            -- ยกตัวละครหรือวัตถุขึ้นเมื่อเริ่มบิน
            local targetPart = vehiclePart or rootPart
            targetPart.CFrame = targetPart.CFrame + Vector3.new(0, 10, 0)
            warn("ยก" .. (vehiclePart and "วัตถุ" or "ตัวละคร") .. "ขึ้น 10 หน่วย")

            while isFlying do
                if humanoid and targetPart then
                    local moveDirection = humanoid.MoveDirection * flySpeed -- ล็อกความเร็วบินที่ 400
                    bodyVelocity.Velocity = Vector3.new(moveDirection.X, 0, moveDirection.Z)
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                        bodyVelocity.Velocity = bodyVelocity.Velocity + Vector3.new(0, verticalFlySpeed, 0)
                        warn("กด Space: บินขึ้น (ความเร็วแนวตั้ง: " .. verticalFlySpeed .. ")")
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
                        bodyVelocity.Velocity = bodyVelocity.Velocity + Vector3.new(0, -verticalFlySpeed, 0)
                        warn("กด Shift: บินลง (ความเร็วแนวตั้ง: " .. verticalFlySpeed .. ")")
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
            if vehiclePart then
                for _, part in pairs(vehiclePart:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                        part.Anchored = false
                    end
                end
            end
        end)()
    end
end)

-- ฟังก์ชันตั้งค่าความเร็วในการเดิน (ปรับทันทีเมื่อพิมพ์)
speedBox:GetPropertyChangedSignal("Text"):Connect(function()
    local newSpeed = tonumber(speedBox.Text)
    if newSpeed then
        if newSpeed < 0 then
            newSpeed = 0
            speedBox.Text = "0"
            warn("ความเร็วต้องไม่ต่ำกว่า 0")
        elseif newSpeed > 1000000 then
            newSpeed = 1000000
            speedBox.Text = "1000000"
            warn("ความเร็วสูงสุดคือ 1000000")
        end
        walkSpeed = newSpeed
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = walkSpeed
                warn("ตั้งค่าความเร็วในการเดินเป็น: " .. walkSpeed)

                -- ถ้ากำลังนั่งบนวัตถุ อัปเดตความเร็วของวัตถุ
                local vehiclePart = nil
                if humanoid.SeatPart then
                    vehiclePart = humanoid.SeatPart.Parent
                    warn("ตรวจพบวัตถุที่นั่ง: " .. vehiclePart.Name)
                end
                if vehiclePart then
                    local bodyVelocity = vehiclePart:FindFirstChildOfClass("BodyVelocity") or Instance.new("BodyVelocity")
                    bodyVelocity.MaxForce = Vector3.new(math.huge, 0, math.huge)
                    bodyVelocity.Velocity = humanoid.MoveDirection * walkSpeed
                    bodyVelocity.Parent = vehiclePart
                    warn("ตั้งค่าความเร็วของวัตถุที่นั่งเป็น: " .. walkSpeed)
                end
            end
        end
    else
        speedBox.Text = tostring(walkSpeed)
        warn("กรุณาใส่ตัวเลขที่ถูกต้อง")
    end
end)

-- ฟังก์ชันตั้งค่าความเร็วแนวตั้ง (ปรับทันทีเมื่อพิมพ์)
verticalSpeedBox:GetPropertyChangedSignal("Text"):Connect(function()
    local newVerticalSpeed = tonumber(verticalSpeedBox.Text)
    if newVerticalSpeed then
        if newVerticalSpeed < 0 then
            newVerticalSpeed = 0
            verticalSpeedBox.Text = "0"
            warn("ความเร็วแนวตั้งต้องไม่ต่ำกว่า 0")
        end
        verticalFlySpeed = newVerticalSpeed
        warn("ตั้งค่าความเร็วแนวตั้งเป็น: " .. verticalFlySpeed)
    else
        verticalSpeedBox.Text = tostring(verticalFlySpeed)
        warn("กรุณาใส่ตัวเลขที่ถูกต้องสำหรับความเร็วแนวตั้ง")
    end
end)

-- ฟังก์ชันตั้งค่าระดับความสูง (ปรับทันทีเมื่อพิมพ์)
heightBox:GetPropertyChangedSignal("Text"):Connect(function()
    local newHeight = tonumber(heightBox.Text)
    if newHeight then
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            warn("ไม่พบตัวละครสำหรับปรับระดับความสูง")
            return
        end
        local rootPart = player.Character.HumanoidRootPart
        local currentCFrame = rootPart.CFrame
        rootPart.CFrame = CFrame.new(currentCFrame.Position.X, newHeight, currentCFrame.Position.Z) * CFrame.Angles(currentCFrame:ToEulerAnglesXYZ())
        warn("ตั้งค่าระดับความสูงเป็น: " .. newHeight)
    else
        heightBox.Text = "0"
        warn("กรุณาใส่ตัวเลขที่ถูกต้องสำหรับระดับความสูง")
    end
end)

-- ฟังก์ชันเดินเร็วขึ้น (รองรับวัตถุที่นั่ง)
createToggleButton("เดินเร็วขึ้น", function(state)
    if not player.Character then
        player.CharacterAdded:Wait()
        warn("ตัวละครโหลดสำเร็จสำหรับฟังก์ชันเดินเร็วขึ้น")
    end
    local character = player.Character
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not (humanoid and rootPart) then
        warn("ไม่พบ Humanoid หรือ HumanoidRootPart สำหรับฟังก์ชันเดินเร็วขึ้น")
        return
    end

    if state then
        humanoid.WalkSpeed = walkSpeed
        warn("เดินเร็วขึ้น: เปิด (ความเร็ว: " .. walkSpeed .. ")")

        -- ถ้ากำลังนั่งบนวัตถุ ใช้ BodyVelocity เพื่อควบคุมความเร็ว
        local vehiclePart = nil
        if humanoid.SeatPart then
            vehiclePart = humanoid.SeatPart.Parent
            warn("ตรวจพบวัตถุที่นั่ง: " .. vehiclePart.Name)
        end
        if vehiclePart then
            for _, part in pairs(vehiclePart:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Anchored = false
                end
            end
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(math.huge, 0, math.huge)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.Parent = vehiclePart
            vehicleBodyVelocityConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if not state or not vehiclePart then return end
                bodyVelocity.Velocity = humanoid.MoveDirection * walkSpeed
            end)
        end
    else
        humanoid.WalkSpeed = 16
        warn("เดินเร็วขึ้น: ปิด")
        if vehicleBodyVelocityConnection then
            vehicleBodyVelocityConnection:Disconnect()
            vehicleBodyVelocityConnection = nil
        end
    end
end)
-- ฟังก์ชันกันแบน (เดินทะลุ + ป้องกันตาย)
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

        -- ป้องกันตัวละครตาย
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            preventDeathConnection = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                if humanoid.Health <= 0 then
                    humanoid.Health = 100
                    warn("ป้องกันตัวละครตาย: คืนค่า Health เป็น 100")
                end
            end)
        end
    else
        warn("กันแบน (เดินทะลุ): ปิด")
        if noClipConnection then
            noClipConnection:Disconnect()
            noClipConnection = nil
        end
        if preventDeathConnection then
            preventDeathConnection:Disconnect()
            preventDeathConnection = nil
        end
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)

-- ฟังก์ชันล่องหน (หายตัว + เดินทะลุ)
createToggleButton("ล่องหน", function(state)
    isInvisible = state
    if not player.Character then
        player.CharacterAdded:Wait()
        warn("ตัวละครโหลดสำเร็จสำหรับฟังก์ชันล่องหน")
    end
    local character = player.Character
    if not character then
        warn("ไม่พบตัวละครสำหรับฟังก์ชันล่องหน")
        return
    end

    if state then
        warn("ล่องหน: เปิด")
        warn("คำเตือน: การใช้ฟังก์ชันนี้อาจถูกตรวจจับโดยระบบป้องกันการโกงของเกม!")

        -- ทำให้ตัวละครหายตัว (ตั้งค่า Transparency)
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1 -- หายตัว
                part.CanCollide = false -- เดินทะลุ
            elseif part:IsA("Decal") then
                part.Transparency = 1
            end
        end

        -- ลบชื่อผู้เล่น (ถ้ามี)
        local head = character:FindFirstChild("Head")
        if head then
            local billboard = head:FindFirstChildOfClass("BillboardGui")
            if billboard then
                billboard.Enabled = false
            end
        end

        -- อัปเดตทุกครั้งที่มีการเคลื่อนไหว เพื่อให้แน่ใจว่าหายตัวตลอด
        invisibleConnection = game:GetService("RunService").Stepped:Connect(function()
            if not isInvisible then return end
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 1
                    part.CanCollide = false
                elseif part:IsA("Decal") then
                    part.Transparency = 1
                end
            end
        end)
    else
        warn("ล่องหน: ปิด")
        if invisibleConnection then
            invisibleConnection:Disconnect()
            invisibleConnection = nil
        end
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0 -- กลับมาเห็นปกติ
                part.CanCollide = true
            elseif part:IsA("Decal") then
                part.Transparency = 0
            end
        end
        local head = character:FindFirstChild("Head")
        if head then
            local billboard = head:FindFirstChildOfClass("BillboardGui")
            if billboard then
                billboard.Enabled = true
            end
        end
    end
end)

-- ตัวแปรเก็บสถานะปุ่มส่งข้อความ
local messageButton = nil

-- ฟังก์ชันกล่องข้อความ (เลือกผู้เล่นได้)
messageButton = createToggleButton("กล่องข้อความ", function(state)
    messageFrame.Visible = state
    -- สร้าง Frame สำหรับเลือกผู้เล่น (เมื่อเปิดปุ่มส่งข้อความ)
    local playerListFrame = Instance.new("Frame")
    playerListFrame.Size = UDim2.new(1, -10, 0, 150)
    playerListFrame.BackgroundTransparency = 0.9
    playerListFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    playerListFrame.Visible = state
    playerListFrame.LayoutOrder = messageButton.LayoutOrder + 1 -- ให้อยู่ด้านล่างของปุ่มกล่องข้อความ
    playerListFrame.Parent = scrollingFrame

    -- เพิ่ม UIGradient สำหรับ playerListFrame
    local playerListGradient = Instance.new("UIGradient")
    playerListGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 0, 100)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(128, 0, 255))
    })
    playerListGradient.Rotation = 45
    playerListGradient.Parent = playerListFrame

    -- เพิ่ม UIStroke สำหรับ playerListFrame
    local playerListStroke = Instance.new("UIStroke")
    playerListStroke.Color = Color3.fromRGB(128, 0, 255)
    playerListStroke.Thickness = 2
    playerListStroke.Transparency = 0.5
    playerListStroke.Parent = playerListFrame

    local playerListScrollingFrame = Instance.new("ScrollingFrame")
    playerListScrollingFrame.Size = UDim2.new(1, -10, 1, -10)
    playerListScrollingFrame.Position = UDim2.new(0, 5, 0, 5)
    playerListScrollingFrame.BackgroundTransparency = 1
    playerListScrollingFrame.ScrollBarThickness = 5
    playerListScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(128, 0, 255)
    playerListScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    playerListScrollingFrame.Parent = playerListFrame

    local playerListLayout = Instance.new("UIListLayout")
    playerListLayout.Padding = UDim.new(0, 5)
    playerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    playerListLayout.Parent = playerListScrollingFrame

    -- ฟังก์ชันอัปเดตผู้เล่นในเซิร์ฟเวอร์
    local function updatePlayerList()
        for _, child in pairs(playerListScrollingFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end

        for _, targetPlayer in pairs(game.Players:GetPlayers()) do
            if targetPlayer ~= player then
                local playerButton = Instance.new("TextButton")
                playerButton.Size = UDim2.new(1, -10, 0, 30)
                playerButton.BackgroundColor3 = Color3.fromRGB(50, 0, 100)
                playerButton.Text = targetPlayer.Name
                playerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                playerButton.TextScaled = true
                playerButton.Font = Enum.Font.SciFi
                playerButton.BorderSizePixel = 0
                playerButton.Parent = playerListScrollingFrame

                -- เพิ่ม UIStroke สำหรับปุ่มผู้เล่น
                local buttonStroke = Instance.new("UIStroke")
                buttonStroke.Color = Color3.fromRGB(128, 0, 255)
                buttonStroke.Thickness = 2
                buttonStroke.Transparency = 0.5
                buttonStroke.Parent = playerButton

                playerButton.MouseButton1Click:Connect(function()
                    local message = messageBox.Text
                    if message and message ~= "" and message ~= "พิมพ์ข้อความที่นี่..." then
                        local targetCharacter = targetPlayer.Character
                        if targetCharacter then
                            -- สร้าง BillboardGui เพื่อแสดงข้อความบนหน้าจอของผู้เล่นคนนั้น
                            local messageGui = Instance.new("BillboardGui")
                            messageGui.Size = UDim2.new(4, 0, 1, 0)
                            messageGui.StudsOffset = Vector3.new(0, 5, 0) -- ด้านบนของตัวละคร
                            messageGui.AlwaysOnTop = true
                            messageGui.Parent = targetCharacter

                            local messageLabel = Instance.new("TextLabel")
                            messageLabel.Size = UDim2.new(1, 0, 1, 0)
                            messageLabel.BackgroundTransparency = 1
                            messageLabel.Text = message
                            messageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                            messageLabel.TextScaled = true
                            messageLabel.Font = Enum.Font.SciFi
                            messageLabel.Parent = messageGui

                            -- ลบข้อความหลังจาก 5 วินาที
                            delay(5, function()
                                messageGui:Destroy()
                            end)

                            warn("ส่งข้อความไปยัง " .. targetPlayer.Name .. ": " .. message)
                            messageBox.Text = "พิมพ์ข้อความที่นี่..."
                        else
                            warn("ไม่พบตัวละครของ " .. targetPlayer.Name)
                        end
                    end
                end)
            end
        end

        playerListScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, playerListLayout.AbsoluteContentSize.Y)
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
    end

    -- อัปเดตผู้เล่นเมื่อมีผู้เล่นเข้ามา/ออกจากเซิร์ฟเวอร์
    local playerAddedConnection
    local playerRemovingConnection

    if state then
        updatePlayerList()
        playerAddedConnection = game.Players.PlayerAdded:Connect(updatePlayerList)
        playerRemovingConnection = game.Players.PlayerRemoving:Connect(updatePlayerList)
        warn("กล่องข้อความ: เปิด")
    else
        if playerAddedConnection then playerAddedConnection:Disconnect() end
        if playerRemovingConnection then playerRemovingConnection:Disconnect() end
        playerListFrame:Destroy()
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
        warn("กล่องข้อความ: ปิด")
    end
end)
-- ตัวแปรเก็บสถานะปุ่มวาร์ป
local teleportButton = nil

-- ฟังก์ชันวาร์ปไปหาผู้เล่น
teleportButton = createToggleButton("วาร์ปไปหาผู้เล่น", function(state)
    -- สร้าง Frame สำหรับรายชื่อผู้เล่น (เมื่อเปิดปุ่มวาร์ป)
    local teleportFrame = Instance.new("Frame")
    teleportFrame.Size = UDim2.new(1, -10, 0, 150)
    teleportFrame.BackgroundTransparency = 0.9
    teleportFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    teleportFrame.Visible = state
    teleportFrame.LayoutOrder = teleportButton.LayoutOrder + 1 -- ให้อยู่ด้านล่างของปุ่มวาร์ป
    teleportFrame.Parent = scrollingFrame

    -- เพิ่ม UIGradient สำหรับ teleportFrame
    local teleportGradient = Instance.new("UIGradient")
    teleportGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 0, 100)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(128, 0, 255))
    })
    teleportGradient.Rotation = 45
    teleportGradient.Parent = teleportFrame

    -- เพิ่ม UIStroke สำหรับ teleportFrame
    local teleportStroke = Instance.new("UIStroke")
    teleportStroke.Color = Color3.fromRGB(128, 0, 255)
    teleportStroke.Thickness = 2
    teleportStroke.Transparency = 0.5
    teleportStroke.Parent = teleportFrame

    local teleportScrollingFrame = Instance.new("ScrollingFrame")
    teleportScrollingFrame.Size = UDim2.new(1, -10, 1, -10)
    teleportScrollingFrame.Position = UDim2.new(0, 5, 0, 5)
    teleportScrollingFrame.BackgroundTransparency = 1
    teleportScrollingFrame.ScrollBarThickness = 5
    teleportScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(128, 0, 255)
    teleportScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    teleportScrollingFrame.Parent = teleportFrame

    local teleportListLayout = Instance.new("UIListLayout")
    teleportListLayout.Padding = UDim.new(0, 5)
    teleportListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    teleportListLayout.Parent = teleportScrollingFrame

    -- ฟังก์ชันอัปเดตผู้เล่นในเซิร์ฟเวอร์
    local function updatePlayerList()
        for _, child in pairs(teleportScrollingFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end

        for _, targetPlayer in pairs(game.Players:GetPlayers()) do
            if targetPlayer ~= player then
                local playerButton = Instance.new("TextButton")
                playerButton.Size = UDim2.new(1, -10, 0, 30)
                playerButton.BackgroundColor3 = Color3.fromRGB(50, 0, 100)
                playerButton.Text = targetPlayer.Name
                playerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                playerButton.TextScaled = true
                playerButton.Font = Enum.Font.SciFi
                playerButton.BorderSizePixel = 0
                playerButton.Parent = teleportScrollingFrame

                -- เพิ่ม UIStroke สำหรับปุ่มผู้เล่น
                local buttonStroke = Instance.new("UIStroke")
                buttonStroke.Color = Color3.fromRGB(128, 0, 255)
                buttonStroke.Thickness = 2
                buttonStroke.Transparency = 0.5
                buttonStroke.Parent = playerButton

                playerButton.MouseButton1Click:Connect(function()
                    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                        warn("ไม่พบตัวละครของผู้เล่น")
                        return
                    end
                    local targetCharacter = targetPlayer.Character
                    if targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart") then
                        local rootPart = player.Character.HumanoidRootPart
                        rootPart.CFrame = targetCharacter.HumanoidRootPart.CFrame + Vector3.new(3, 0, 0)
                        warn("วาร์ปไปหา: " .. targetPlayer.Name)
                    else
                        warn("ไม่พบตัวละครของ " .. targetPlayer.Name)
                    end
                end)
            end
        end

        teleportScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, teleportListLayout.AbsoluteContentSize.Y)
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
    end

    -- อัปเดตผู้เล่นเมื่อมีผู้เล่นเข้ามา/ออกจากเซิร์ฟเวอร์
    local playerAddedConnection
    local playerRemovingConnection

    if state then
        updatePlayerList()
        playerAddedConnection = game.Players.PlayerAdded:Connect(updatePlayerList)
        playerRemovingConnection = game.Players.PlayerRemoving:Connect(updatePlayerList)
        warn("วาร์ปไปหาผู้เล่น: เปิด")
    else
        if playerAddedConnection then playerAddedConnection:Disconnect() end
        if playerRemovingConnection then playerRemovingConnection:Disconnect() end
        teleportFrame:Destroy()
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
        warn("วาร์ปไปหาผู้เล่น: ปิด")
    end
end)
-- ส่วนที่ 4: แสดงพิกัดเรียลไทม์
local coordLabel = Instance.new("TextLabel")
coordLabel.Size = UDim2.new(0, 200, 0, 30)
coordLabel.Position = UDim2.new(0.5, -100, 0, 10)
coordLabel.BackgroundTransparency = 0.5
coordLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
coordLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
coordLabel.TextScaled = true
coordLabel.Text = "X: 0, Y: 0, Z: 0"
coordLabel.Parent = screenGui
warn("Label พิกัดถูกสร้างสำเร็จ")

game:GetService("RunService").RenderStepped:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local pos = player.Character.HumanoidRootPart.Position
        coordLabel.Text = string.format("X: %.2f, Y: %.2f, Z: %.2f", pos.X, pos.Y, pos.Z)
    end
end)
-- ส่วนที่ 5: ช่องกรอกพิกัดและเทเลพอร์ต
local coordInputLabel = Instance.new("TextLabel")
coordInputLabel.Size = UDim2.new(1, -10, 0, 30)
coordInputLabel.Position = UDim2.new(0, 5, 0, 10)
coordInputLabel.BackgroundTransparency = 1
coordInputLabel.Text = "กรอกพิกัด (X, Y, Z):"
coordInputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
coordInputLabel.TextScaled = true
coordInputLabel.Parent = scrollingFrame
warn("Label กรอกพิกัดถูกสร้างสำเร็จ")

local xInput = Instance.new("TextBox")
xInput.Size = UDim2.new(0.3, -5, 0, 30)
xInput.Position = UDim2.new(0, 5, 0, 50)
xInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
xInput.TextColor3 = Color3.fromRGB(255, 255, 255)
xInput.Text = "X"
xInput.TextScaled = true
xInput.Parent = scrollingFrame

local yInput = Instance.new("TextBox")
yInput.Size = UDim2.new(0.3, -5, 0, 30)
yInput.Position = UDim2.new(0.33, 0, 0, 50)
yInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
yInput.TextColor3 = Color3.fromRGB(255, 255, 255)
yInput.Text = "Y"
yInput.TextScaled = true
yInput.Parent = scrollingFrame

local zInput = Instance.new("TextBox")
zInput.Size = UDim2.new(0.3, -5, 0, 30)
zInput.Position = UDim2.new(0.66, 0, 0, 50)
zInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
zInput.TextColor3 = Color3.fromRGB(255, 255, 255)
zInput.Text = "Z"
zInput.TextScaled = true
zInput.Parent = scrollingFrame

local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(1, -10, 0, 30)
teleportButton.Position = UDim2.new(0, 5, 0, 90)
teleportButton.BackgroundColor3 = Color3.fromRGB(50, 0, 100)
teleportButton.Text = "เทเลพอร์ต"
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.TextScaled = true
teleportButton.Parent = scrollingFrame

teleportButton.MouseButton1Click:Connect(function()
    local x = tonumber(xInput.Text)
    local y = tonumber(yInput.Text)
    local z = tonumber(zInput.Text)
    if x and y and z and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.Position = Vector3.new(x, y, z)
        warn("เทเลพอร์ตไปยัง X: " .. x .. ", Y: " .. y .. ", Z: " .. z)
    else
        warn("กรุณากรอกพิกัดที่ถูกต้อง (ตัวเลขเท่านั้น)")
    end
end)
warn("ปุ่มเทเลพอร์ตถูกสร้างสำเร็จ")
-- ส่วนที่ 6: ฟังก์ชันลาก UI
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
warn("ฟังก์ชันลาก UI ถูกสร้างสำเร็จ")
-- ส่วนที่ 7: ฟังก์ชันเปิด/ปิด UI
toggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    toggleButton.Text = mainFrame.Visible and "❌" or "✅"
    toggleButton.BackgroundColor3 = mainFrame.Visible and Color3.fromRGB(128, 0, 255) or Color3.fromRGB(50, 0, 100)
    warn(mainFrame.Visible and "UI: เปิด" or "UI: ปิด")
end)
-- ส่วนที่ 8: การแจ้งเตือนโค้ดโหลดสำเร็จ
warn("โค้ดโหลดสำเร็จ! คลิกปุ่ม ✅ เพื่อเปิด UI")