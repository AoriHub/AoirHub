-- โค้ดรวม: Pro29SGzXC7.lua + Auto Ultra
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- รอ Character โหลด
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- ระบบป้องกันแบน (จากโค้ดเดิม + ปรับปรุง)
local function AntiBan()
    wait(math.random(0.1, 0.5)) -- หน่วงเวลาแบบสุ่ม
    -- เพิ่มการเลียนแบบพฤติกรรม (ถ้ามีระบบจริง ใส่ที่นี่)
    LocalPlayer.Character.Humanoid:Move(Vector3.new(math.random(-1, 1), 0, math.random(-1, 1))) -- เคลื่อนไหวเล็กน้อย
end

-- ตัวอย่างการโหลดสคริปต์ (จากโค้ดเดิม)
local scriptURL = "https://raw.githubusercontent.com/AoriHub/AoirHub/main/AnotherScript.lua"
loadstring(game:HttpGet(scriptURL))()

-- ฟังก์ชันจำลองการคลิก
local function SimulateClick()
    VirtualUser:ClickButton1(Vector2.new(500, 500)) -- คลิกกึ่งกลางหน้าจอ
end

-- ฟังก์ชันวาร์ปไปยังตำแหน่ง
local function TeleportToPosition(position)
    if HumanoidRootPart then
        HumanoidRootPart.CFrame = CFrame.new(position)
    end
end

-- ฟังก์ชันวาร์ปไปหาผู้เล่น
local function TeleportToPlayer(targetPlayer)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        TeleportToPosition(targetPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 3, 0))
    end
end

-- ฟังก์ชันตรวจจับบทบาท (ปรับตามเกมจริง)
local function GetPlayerRole()
    -- สมมติว่าเกมมี UI หรือ attribute แสดงบทบาท
    local role = LocalPlayer:GetAttribute("Role") -- ตัวอย่าง: เกมเก็บบทบาทใน attribute
    return role -- คืนค่า "Innocent", "Sheriff", หรือ "Murderer"
end

-- ฟังก์ชันหาผู้เล่นที่มีกรอบใหญ่สุด
local function FindTargetWithLargestFrame()
    local largestFramePlayer = nil
    local maxFrameSize = 0

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local frame = player.Character:FindFirstChild("Highlight") -- สมมติว่าใช้ Highlight
            if frame and frame.Size then
                local frameSize = frame.Size.X * frame.Size.Y
                if frameSize > maxFrameSize then
                    maxFrameSize = frameSize
                    largestFramePlayer = player
                end
            end
        end
    end
    return largestFramePlayer
end

-- ฟังก์ชัน Auto Ultra
local AutoUltraEnabled = false
local function AutoUltra()
    while AutoUltraEnabled do
        AntiBan() -- เรียกใช้ระบบป้องกันแบน
        local role = GetPlayerRole()

        if role == "Innocent" then
            -- ผู้บริสุทธิ์: วาร์ปใต้แมพและยืนนิ่ง
            TeleportToPosition(Vector3.new(0, -500, 0)) -- ปรับพิกัดตามแมพ
            LocalPlayer.Character.Humanoid.WalkSpeed = 0
            LocalPlayer.Character.Humanoid.JumpPower = 0
            repeat
                wait(1)
            until game:GetService("ReplicatedStorage"):FindFirstChild("Victory")

        elseif role == "Sheriff" then
            -- นายอำเภอ: วาร์ปไปหาคนที่มีกรอบใหญ่สุด
            local target = FindTargetWithLargestFrame()
            if target then
                TeleportToPlayer(target)
                local tool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
                if tool then
                    tool.Parent = LocalPlayer.Character
                    tool:Activate()
                end
                SimulateClick()
                while target and target.Character and AutoUltraEnabled do
                    TeleportToPlayer(target) -- ล็อกเป้าหมาย
                    wait(0.1)
                end
            end

        elseif role == "Murderer" then
            -- ฆาตกร: วาร์ปไปหาทุกคนตามลำดับ A-Z
            local playerList = Players:GetPlayers()
            table.sort(playerList, function(a, b)
                return a.Name:lower() < b.Name:lower()
            end)

            for _, target in ipairs(playerList) do
                if target ~= LocalPlayer and target.Character and AutoUltraEnabled then
                    TeleportToPlayer(target)
                    SimulateClick()
                    wait(0.5)
                    AntiBan()
                end
            end
            repeat
                wait(1)
            until game:GetService("ReplicatedStorage"):FindFirstChild("Victory")
        end

        wait(1)
    end
end

-- เปิด/ปิด Auto Ultra
local function ToggleAutoUltra()
    AutoUltraEnabled = not AutoUltraEnabled
    if AutoUltraEnabled then
        print("Auto Ultra: ON")
        spawn(AutoUltra)
    else
        print("Auto Ultra: OFF")
    end
end

-- ผูกปุ่มกด (ตัวอย่าง: ปุ่ม F)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F then
        ToggleAutoUltra()
    end
end)

-- ข้อความต้อนรับ (จากโค้ดเดิม)
print("AoriHub Script Loaded")