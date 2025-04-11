-- ตรวจสอบว่าโค้ดรันใน Roblox หรือไม่
if not game:IsLoaded() then
    game.Loaded:Wait()
    warn("เกมโหลดสำเร็จ")
end

-- ตัวแปรเก็บสถานะ
local isSecondPerson = false
local currentSkyState = "Night"
local skyClickCount = 0
local isHorseSpeed = false
local isGodMode = false
local isFastAttack = false
local godModeConnection = nil -- ตัวแปรสำหรับเก็บการเชื่อมต่อ HealthChanged
local selectedPlayers = {} -- ตารางเก็บรายชื่อผู้เล่นที่เลือกให้เปลี่ยนมุมมอง

-- สร้าง ScreenGui
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 15)
if not playerGui then
    warn("ไม่สามารถเข้าถึง PlayerGui ได้ กรุณาตรวจสอบว่าเกมอนุญาตให้ใช้ UI หรือไม่")
    return
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SimpleUI"
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
warn("ปุ่มเปิด/ปิด UI ถูกสร้างสำเร็จ")

-- สร้าง Frame หลักของ UI
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundTransparency = 0.75
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.Visible = false
mainFrame.Parent = screenGui
warn("Frame หลักของ UI ถูกสร้างสำเร็จ")

-- เพิ่ม ScrollingFrame สำหรับตัวเลื่อน (สำหรับปุ่มฟังก์ชัน)
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, -20, 0.5, -80)
scrollingFrame.Position = UDim2.new(0, 10, 0, 70)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.ScrollBarThickness = 5
scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(128, 0, 255)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.Parent = mainFrame
warn("ScrollingFrame สำหรับปุ่มฟังก์ชันถูกสร้างสำเร็จ")

-- เพิ่ม UIListLayout เพื่อจัดเรียงปุ่ม
local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0, 10)
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Parent = scrollingFrame
warn("UIListLayout ถูกสร้างสำเร็จ")

-- เพิ่ม ScrollingFrame สำหรับเลือกผู้เล่น (สำหรับฟังก์ชันปลดล็อกมุมมอง)
local playerListFrame = Instance.new("ScrollingFrame")
playerListFrame.Size = UDim2.new(1, -20, 0.4, 0)
playerListFrame.Position = UDim2.new(0, 10, 0.5, -10)
playerListFrame.BackgroundTransparency = 0.9
playerListFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
playerListFrame.ScrollBarThickness = 5
playerListFrame.ScrollBarImageColor3 = Color3.fromRGB(128, 0, 255)
playerListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
playerListFrame.Visible = false -- ซ่อนไว้ก่อนจนกว่าจะกดเปิดฟังก์ชัน
playerListFrame.Parent = mainFrame
warn("ScrollingFrame สำหรับเลือกผู้เล่นถูกสร้างสำเร็จ")

-- เพิ่ม UIListLayout สำหรับรายชื่อผู้เล่น
local playerListLayout = Instance.new("UIListLayout")
playerListLayout.Padding = UDim.new(0, 5)
playerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
playerListLayout.Parent = playerListFrame
warn("UIListLayout สำหรับรายชื่อผู้เล่นถูกสร้างสำเร็จ")

-- เพิ่ม Label ชื่อเมนู
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "เมนูหลัก"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Parent = mainFrame
warn("Label ชื่อเมนูถูกสร้างสำเร็จ")

-- เพิ่ม Label สำหรับแสดงสถานะท้องฟ้า
local skyStatusLabel = Instance.new("TextLabel")
skyStatusLabel.Size = UDim2.new(1, 0, 0, 30)
skyStatusLabel.Position = UDim2.new(0, 0, 0, 35)
skyStatusLabel.BackgroundTransparency = 1
skyStatusLabel.Text = "ท้องฟ้า: กลางคืน"
skyStatusLabel.TextColor3 = Color3.fromRGB(128, 0, 255)
skyStatusLabel.TextScaled = true
skyStatusLabel.Parent = mainFrame
warn("Label สถานะท้องฟ้าถูกสร้างสำเร็จ")

-- สีสำหรับปุ่ม
local buttonOnColor = Color3.fromRGB(128, 0, 255) -- สีม่วงสว่าง (เปิด)
local buttonOffColor = Color3.fromRGB(50, 0, 100) -- สีม่วงเข้ม (ปิด)

-- ฟังก์ชันสร้างปุ่มสำหรับเลือกผู้เล่น
local function createPlayerToggle(playerName)
    local isSelected = false
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 30)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    button.Text = playerName .. " (ไม่เลือก)"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.BorderSizePixel = 0
    button.Parent = playerListFrame

    button.MouseButton1Click:Connect(function()
        isSelected = not isSelected
        button.Text = playerName .. (isSelected and " (เลือก)" or " (ไม่เลือก)")
        button.BackgroundColor3 = isSelected and Color3.fromRGB(80, 0, 150) or Color3.fromRGB(40, 40, 50)
        if isSelected then
            table.insert(selectedPlayers, playerName)
        else
            for i, name in ipairs(selectedPlayers) do
                if name == playerName then
                    table.remove(selectedPlayers, i)
                    break
                end
            end
        end
        warn("ผู้เล่นที่เลือก: " .. table.concat(selectedPlayers, ", "))
    end)

    -- อัปเดต CanvasSize ของ playerListFrame
    playerListFrame.CanvasSize = UDim2.new(0, 0, 0, playerListLayout.AbsoluteContentSize.Y)
end

-- ฟังก์ชันโหลดรายชื่อผู้เล่นในเซิร์ฟเวอร์
local function loadPlayerList()
    -- ลบปุ่มเก่าก่อน
    for _, child in pairs(playerListFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    selectedPlayers = {} -- รีเซ็ตผู้เล่นที่เลือก

    -- เพิ่มรายชื่อผู้เล่น
    for _, p in pairs(game.Players:GetPlayers()) do
        createPlayerToggle(p.Name)
    end

    -- อัปเดตเมื่อมีผู้เล่นเข้า/ออก
    game.Players.PlayerAdded:Connect(function(newPlayer)
        createPlayerToggle(newPlayer.Name)
    end)

    game.Players.PlayerRemoving:Connect(function(leavingPlayer)
        for _, child in pairs(playerListFrame:GetChildren()) do
            if child:IsA("TextButton") and child.Text:find(leavingPlayer.Name) then
                child:Destroy()
            end
        end
        for i, name in ipairs(selectedPlayers) do
            if name == leavingPlayer.Name then
                table.remove(selectedPlayers, i)
                break
            end
        end
        playerListFrame.CanvasSize = UDim2.new(0, 0, 0, playerListLayout.AbsoluteContentSize.Y)
    end)
end

-- ฟังก์ชันสร้างปุ่มสำหรับฟังก์ชัน
local function createToggleButton(label, callback)
    local toggleState = false
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 40)
    button.BackgroundColor3 = buttonOffColor
    button.Text = label .. " (ปิด)"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.BorderSizePixel = 0
    button.Parent = scrollingFrame

    button.MouseButton1Click:Connect(function()
        toggleState = not toggleState
        button.Text = label .. (toggleState and " (เปิด)" or " (ปิด)")
        button.BackgroundColor3 = toggleState and buttonOnColor or buttonOffColor
        callback(toggleState)
    end)

    -- อัปเดต CanvasSize ของ ScrollingFrame
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
    warn("ปุ่ม " .. label .. " ถูกสร้างสำเร็จ")
end

-- ฟังก์ชันปลดล็อกมุมมองบุคคลที่สอง (ปรับให้เลือกผู้เล่นได้)
createToggleButton("ปลดล็อคหมุนมองบุคคลที่สอง", function(state)
    isSecondPerson = state
    playerListFrame.Visible = state -- แสดง/ซ่อนรายชื่อผู้เล่น
    if state then
        loadPlayerList() -- โหลดรายชื่อผู้เล่นเมื่อเปิดฟังก์ชัน
        warn("ปลดล็อกมุมมองบุคคลที่สอง: เปิด - เลือกผู้เล่นด้านล่าง")
    else
        -- คืนค่ามุมมองให้ผู้เล่นที่เลือกทั้งหมด
        for _, name in ipairs(selectedPlayers) do
            local targetPlayer = game.Players:FindFirstChild(name)
            if targetPlayer then
                targetPlayer.CameraMode = Enum.CameraMode.Classic
                targetPlayer.CameraMaxZoomDistance = 128
            end
        end
        selectedPlayers = {} -- รีเซ็ตผู้เล่นที่เลือก
        warn("ปลดล็อกมุมมองบุคคลที่สอง: ปิด")
    end

    -- เปลี่ยนมุมมองของผู้เล่นที่เลือก
    if state then
        game:GetService("RunService").RenderStepped:Connect(function()
            if not isSecondPerson then return end
            for _, name in ipairs(selectedPlayers) do
                local targetPlayer = game.Players:FindFirstChild(name)
                if targetPlayer then
                    if targetPlayer == player then
                        player.CameraMode = Enum.CameraMode.LockFirstPerson
                        player.CameraMaxZoomDistance = 0.5
                    else
                        warn("คำเตือน: ไม่สามารถเปลี่ยนมุมมองของ " .. name .. " ได้โดยตรง เนื่องจากข้อจำกัดของ Roblox")
                        -- ในทางปฏิบัติ ต้องใช้ RemoteEvent เพื่อส่งคำสั่งไปยังผู้เล่นคนนั้น
                    end
                end
            end
        end)
    end
end)

-- ฟังก์ชันปรับท้องฟ้า
createToggleButton("ปรับท้องฟ้า", function(state)
    if state then
        skyClickCount = skyClickCount + 1
        if skyClickCount == 1 then
            if currentSkyState == "Night" then
                game.Lighting.TimeOfDay = "06:00:00" -- เช้า
                game.Lighting.Brightness = 2
                currentSkyState = "Morning"
                skyStatusLabel.Text = "ท้องฟ้า: เช้า"
                warn("ท้องฟ้า: เช้า")
            elseif currentSkyState == "Noon" then
                game.Lighting.TimeOfDay = "06:00:00" -- เช้า
                game.Lighting.Brightness = 2
                currentSkyState = "Morning"
                skyStatusLabel.Text = "ท้องฟ้า: เช้า"
                warn("ท้องฟ้า: เช้า")
            end
        elseif skyClickCount == 2 then
            if currentSkyState == "Morning" then
                game.Lighting.TimeOfDay = "12:00:00" -- กลางวัน
                game.Lighting.Brightness = 3
                currentSkyState = "Noon"
                skyStatusLabel.Text = "ท้องฟ้า: กลางวัน"
                warn("ท้องฟ้า: กลางวัน")
            elseif currentSkyState == "Noon" then
                game.Lighting.TimeOfDay = "00:00:00" -- กลางคืน
                game.Lighting.Brightness = 0.5
                currentSkyState = "Night"
                skyStatusLabel.Text = "ท้องฟ้า: กลางคืน"
                warn("ท้องฟ้า: กลางคืน")
                skyClickCount = 0 -- รีเซ็ตการนับคลิก
            end
        end
    else
        skyClickCount = 0 -- รีเซ็ตเมื่อปิด
        warn("ปรับท้องฟ้า: ปิด")
    end
end)

-- ฟังก์ชันขี่ม้าไวขึ้น
createToggleButton("ขี่ม้าไวขึ้น", function(state)
    isHorseSpeed = state
    if not player.Character then
        player.CharacterAdded:Wait()
        warn("ตัวละครโหลดสำเร็จสำหรับฟังก์ชันขี่ม้าไวขึ้น")
    end
    local character = player.Character
    if character and character:FindFirstChildOfClass("Humanoid") then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if state then
            humanoid.WalkSpeed = 250
            warn("ขี่ม้าไวขึ้น: เปิด")
        else
            humanoid.WalkSpeed = 16
            warn("ขี่ม้าไวขึ้น: ปิด")
        end
    else
        warn("ไม่พบ Humanoid สำหรับฟังก์ชันขี่ม้าไวขึ้น")
    end
end)

-- ฟังก์ชันตีแล้วเลือดไม่ลด
createToggleButton("ตีแล้วเลือดไม่ลด", function(state)
    isGodMode = state
    if not player.Character then
        player.CharacterAdded:Wait()
        warn("ตัวละครโหลดสำเร็จสำหรับฟังก์ชันตีแล้วเลือดไม่ลด")
    end
    if state then
        warn("ตีแล้วเลือดไม่ลด: เปิด")
        if godModeConnection then
            godModeConnection:Disconnect()
        end
        godModeConnection = player.Character.Humanoid.HealthChanged:Connect(function(health)
            if isGodMode and health < player.Character.Humanoid.MaxHealth then
                player.Character.Humanoid.Health = player.Character.Humanoid.MaxHealth
            end
        end)
    else
        if godModeConnection then
            godModeConnection:Disconnect()
            godModeConnection = nil
        end
        warn("ตีแล้วเลือดไม่ลด: ปิด")
    end
end)

-- ฟังก์ชันตีเร็วขึ้น
createToggleButton("ตีเร็วขึ้น", function(state)
    isFastAttack = state
    if not player.Character then
        player.CharacterAdded:Wait()
        warn("ตัวละครโหลดสำเร็จสำหรับฟังก์ชันตีเร็วขึ้น")
    end
    local character = player.Character
    if state then
        warn("ตีเร็วขึ้น: เปิด")
        if character then
            local tool = character:FindFirstChildOfClass("Tool") or player.Backpack:FindFirstChildOfClass("Tool")
            if tool then
                tool.Activated:Connect(function()
                    if isFastAttack then
                        for _, v in pairs(game.Players:GetPlayers()) do
                            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                                local distance = (v.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
                                if distance <= 1000 then
                                    v.Character.Humanoid.Health = 0
                                end
                            end
                        end
                    end
                end)
            else
                warn("ไม่พบ Tool สำหรับฟังก์ชันตีเร็วขึ้น")
            end
        end
    else
        warn("ตีเร็วขึ้น: ปิด")
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