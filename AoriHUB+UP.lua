-- โหลด Orion UI Library
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

-- สร้างหน้าต่าง UI
local Window = OrionLib:MakeWindow({
    Name = "Player Tracker",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "PlayerTracker_Config"
})

-- ตัวแปรเก็บสถานะ
local trackingEnabled = false -- เปิด/ปิดการติดตาม
local playersData = {} -- เก็บข้อมูลผู้เล่นทั้งหมด
local LocalPlayer = game.Players.LocalPlayer -- ผู้เล่นของเรา
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() -- ตัวละครของเรา
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart") -- จุดศูนย์กลางตัวละคร

-- สร้างแท็บ UI
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- เพิ่ม Toggle เปิด/ปิดการติดตามผู้เล่น
MainTab:AddToggle({
    Name = "เปิด/ปิด การติดตามผู้เล่น",
    Default = false,
    Callback = function(Value)
        trackingEnabled = Value
        if trackingEnabled then
            OrionLib:MakeNotification({
                Name = "Tracker",
                Content = "เริ่มติดตามผู้เล่น",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        else
            OrionLib:MakeNotification({
                Name = "Tracker",
                Content = "หยุดติดตามผู้เล่น",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    end
})

-- เพิ่มฟังก์ชันแสดงข้อมูลผู้เล่นทั้งหมด
MainTab:AddParagraph("ข้อมูลผู้เล่น", "ข้อมูลจะปรากฏที่นี่")

-- ฟังก์ชันสร้างกรอบรอบตัวผู้เล่น
local function createHighlight(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "PlayerHighlight"
        highlight.FillColor = Color3.fromRGB(0, 0, 255) -- สีฟ้า
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- สีขาว
        highlight.OutlineTransparency = 0.1
        highlight.Parent = player.Character
    end
end

-- ฟังก์ชันคำนวณระยะห่าง
local function calculateDistance(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local targetPart = player.Character.HumanoidRootPart
        local distance = (HumanoidRootPart.Position - targetPart.Position).Magnitude
        return math.floor(distance * 100) -- คำนวณเป็นเซนติเมตร
    end
    return nil
end

-- ฟังก์ชันอัปเดตข้อมูลผู้เล่น
local function updatePlayerList()
    playersData = {} -- เคลียร์ข้อมูลเก่า
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = calculateDistance(player)
            local playerInfo = player.Name .. " - ระยะ: " .. tostring(distance or "N/A") .. " CM"
            table.insert(playersData, playerInfo)
            createHighlight(player)
        end
    end

    -- แสดงรายชื่อผู้เล่นใน UI
    local playerText = "จำนวนผู้เล่น: " .. tostring(#playersData) .. "\n\n"
    playerText = playerText .. table.concat(playersData, "\n")
    MainTab:AddParagraph("ข้อมูลผู้เล่น", playerText)
end

-- ติดตามผู้เล่นแบบเรียลไทม์
game:GetService("RunService").RenderStepped:Connect(function()
    if trackingEnabled then
        updatePlayerList()
    end
end)

-- เพิ่มปุ่มกดออก
MainTab:AddButton({
    Name = "ออกจากโปรแกรม",
    Callback = function()
        OrionLib:Destroy()
    end
})

-- เริ่มต้น UI
OrionLib:Init()
