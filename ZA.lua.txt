if not game:IsLoaded() then
    game.Loaded:Wait()
    print("เกมโหลดสำเร็จ")
end

local player = game.Players.LocalPlayer
local isFlying = false
local isNoClip = false
local isInvisible = false
local isAutoUltra = false
local walkSpeed = 16
local noClipConnection = nil
local selectionBoxes = {}

local playerGui = player:WaitForChild("PlayerGui", 15)
if not playerGui then
    warn("ไม่พบ PlayerGui")
    return
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoUltraUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui
print("ScreenGui สร้างสำเร็จ")

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 60, 0, 60)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 0, 100)
toggleButton.Text = "✅"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.BorderSizePixel = 0
toggleButton.Parent = screenGui
print("ปุ่มเปิด/ปิด UI สร้างสำเร็จ")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundTransparency = 0.75
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.Visible = false
mainFrame.Parent = screenGui
print("Frame หลักสร้างสำเร็จ")

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, -20, 1, -20)
scrollingFrame.Position = UDim2.new(0, 10, 0, 10)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.ScrollBarThickness = 5
scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(128, 0, 255)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.Parent = mainFrame
print("ScrollingFrame สร้างสำเร็จ")

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0, 10)
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Parent = scrollingFrame
print("UIListLayout สร้างสำเร็จ")

local function createToggleButton(label, callback)
    local toggleState = false
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 40)
    button.BackgroundColor3 = Color3.fromRGB(50, 0, 100)
    button.Text = label .. " (ปิด)"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.BorderSizePixel = 0
    button.Parent = scrollingFrame

    button.MouseButton1Click:Connect(function()
        toggleState = not toggleState
        button.Text = label .. (toggleState and " (เปิด)" or " (ปิด)")
        button.BackgroundColor3 = toggleState and Color3.fromRGB(128, 0, 255) or Color3.fromRGB(50, 0, 100)
        callback(toggleState)
    end)

    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
    return button
end

createToggleButton("บินอัตโนมัติ", function(isActive)
    isFlying = isActive
    if isFlying then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 50, 0)
        bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
        bodyVelocity.Parent = player.Character.HumanoidRootPart
        print("บินอัตโนมัติ: เปิด")
    else
        if player.Character and player.Character.HumanoidRootPart:FindFirstChild("BodyVelocity") then
            player.Character.HumanoidRootPart.BodyVelocity:Destroy()
        end
        print("บินอัตโนมัติ: ปิด")
    end
end)

createToggleButton("เดินเร็วขึ้น", function(state)
    if state then
        walkSpeed = 50
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = walkSpeed
        end
        print("เดินเร็วขึ้น: เปิด")
    else
        walkSpeed = 16
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = walkSpeed
        end
        print("เดินเร็วขึ้น: ปิด")
    end
end)

local function enableNoClip()
    if not player.Character then return end
    noClipConnection = game:GetService("RunService").Stepped:Connect(function()
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
    print("กันแบน: เปิด")
end

local function disableNoClip()
    if noClipConnection then
        noClipConnection:Disconnect()
        noClipConnection = nil
    end
    if player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
    print("กันแบน: ปิด")
end

createToggleButton("กันแบน (เดินทะลุ)", function(state)
    isNoClip = state
    if state then
        enableNoClip()
    else
        disableNoClip()
    end
end)

createToggleButton("วาร์ปไปหาผู้เล่น", function(state)
    if state then
        local target = game.Players:GetPlayers()[2]
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(3, 0, 0)
            print("วาร์ปไปหา: " .. target.Name)
        end
    end
    print("วาร์ปไปหาผู้เล่น: " .. (state and "เปิด" or "ปิด"))
end)

local function enablePositionTracking()
    for _, targetPlayer in pairs(game.Players:GetPlayers()) do
        if targetPlayer ~= player and targetPlayer.Character then
            local selectionBox = Instance.new("SelectionBox")
            selectionBox.LineThickness = 0.05
            selectionBox.Color3 = Color3.fromRGB(0, 0, 255)
            selectionBox.Adornee = targetPlayer.Character
            selectionBox.Parent = targetPlayer.Character
            table.insert(selectionBoxes, selectionBox)
        end
    end
    print("ดูตำแหน่งทุกคน: เปิด")
end

local function disablePositionTracking()
    for _, box in pairs(selectionBoxes) do
        box:Destroy()
    end
    selectionBoxes = {}
    print("ดูตำแหน่งทุกคน: ปิด")
end

createToggleButton("ดูตำแหน่งทุกคน", function(state)
    if state then
        enablePositionTracking()
    else
        disablePositionTracking()
    end
end)

createToggleButton("กล่องข้อความ", function(state)
    if state then
        local textBox = Instance.new("TextBox")
        textBox.Size = UDim2.new(0, 200, 0, 50)
        textBox.Position = UDim2.new(0.5, -100, 0.8, -25)
        textBox.Text = "พิมพ์ข้อความที่นี่"
        textBox.Parent = screenGui
        print("กล่องข้อความ: เปิด")
    else
        local existingBox = screenGui:FindFirstChild("TextBox")
        if existingBox then existingBox:Destroy() end
        print("กล่องข้อความ: ปิด")
    end
end)

createToggleButton("ล่องหน", function(state)
    isInvisible = state
    if state then
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 1
                end
            end
            print("ล่องหน: เปิด")
        end
    else
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                end
            end
            print("ล่องหน: ปิด")
        end
    end
end)

local function getCurrentRole()
    local roleGui = player.PlayerGui:FindFirstChild("RoleGui")
    if roleGui and roleGui:FindFirstChild("RoleText") then
        return roleGui.RoleText.Text
    end
    return nil
end

local function autoUltra()
    while isAutoUltra do
        local currentRole = getCurrentRole()
        if currentRole then
            if currentRole == "ผู้บริสุทธิ์" then
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = CFrame.new(0, -100, 0)
                    player.Character.HumanoidRootPart.Anchored = true
                    print("ผู้บริสุทธิ์: วาร์ปไปใต้แมพและยืนนิ่ง")
                end
            elseif currentRole == "นายอำเภอ" then
                local targetPlayer = game.Players:GetPlayers()[2]
                if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(3, 0, 0)
                    print("นายอำเภอ: วาร์ปไปหา " .. targetPlayer.Name)
                end
            elseif currentRole == "ฆาตกร" then
                enableNoClip()
                local playersList = game.Players:GetPlayers()
                table.sort(playersList, function(a, b) return a.Name < b.Name end)
                for _, targetPlayer in ipairs(playersList) do
                    if targetPlayer ~= player and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        player.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(3, 0, 0)
                        print("ฆาตกร: วาร์ปไปหา " .. targetPlayer.Name)
                        wait(0.5)
                    end
                end
                disableNoClip()
            end
        end
        wait(1)
    end
    disableNoClip()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.Anchored = false
    end
end

createToggleButton("ออโต้อัลตร้า", function(state)
    isAutoUltra = state
    if state then
        enablePositionTracking()
        coroutine.wrap(autoUltra)()
        print("ออโต้อัลตร้า: เปิด")
    else
        print("ออโต้อัลตร้า: ปิด")
    end
end)

toggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    toggleButton.Text = mainFrame.Visible and "❌" or "✅"
    toggleButton.BackgroundColor3 = mainFrame.Visible and Color3.fromRGB(128, 0, 255) or Color3.fromRGB(50, 0, 100)
    print(mainFrame.Visible and "UI: เปิด" or "UI: ปิด")
end)

print("โค้ดโหลดสำเร็จ! คลิกปุ่ม ✅ เพื่อเปิด UI")