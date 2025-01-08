-- โหลด Orion UI Library
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()
local Window = OrionLib:MakeWindow({
    Name = "Aori Hub - Ultimate",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "AoriHub_Config"
})

-- 🧠 ตัวแปรหลัก
local player = game.Players.LocalPlayer
local humanoid = player.Character:WaitForChild("Humanoid")
local rootPart = player.Character:WaitForChild("HumanoidRootPart")
local startTime = os.time()
local auraEnabled = false
local barrierEnabled = false
local lockTarget = nil

-- 📊 Tab: Aura & Barrier
local CombatTab = Window:MakeTab({Name = "Combat", Icon = "rbxassetid://4483345998", PremiumOnly = false})

CombatTab:AddToggle({
    Name = "เปิด Aura (รัศมี 10 ซม., ดาเมจ 789)",
    Default = false,
    Callback = function(Value)
        auraEnabled = Value
        while auraEnabled do
            pcall(function()
                for _, v in pairs(workspace:GetChildren()) do
                    if v:IsA("Model") and v ~= player.Character and (v:FindFirstChild("HumanoidRootPart")) then
                        local distance = (v.HumanoidRootPart.Position - rootPart.Position).Magnitude
                        if distance <= 10 then
                            v.Humanoid:TakeDamage(789)
                        end
                    end
                end
            end)
            wait(0.5)
        end
    end
})

CombatTab:AddToggle({
    Name = "เปิด Barrier (วงกลมสีเขียวรอบตัว)",
    Default = false,
    Callback = function(Value)
        barrierEnabled = Value
        if barrierEnabled then
            local barrier = Instance.new("Part", player.Character)
            barrier.Name = "Barrier"
            barrier.Shape = Enum.PartType.Ball
            barrier.Size = Vector3.new(30, 30, 30)
            barrier.Transparency = 0.5
            barrier.Anchored = true
            barrier.CanCollide = false
            barrier.Color = Color3.fromRGB(0, 255, 0)
            barrier.CFrame = rootPart.CFrame
            barrier.Position = rootPart.Position
            spawn(function()
                while barrierEnabled do
                    barrier.Position = rootPart.Position
                    wait(0.1)
                end
                barrier:Destroy()
            end)
        end
    end
})

CombatTab:AddTextbox({
    Name = "ล็อกเป้าหมาย (ใส่ชื่อผู้เล่น)",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        lockTarget = Value
    end
})

CombatTab:AddButton({
    Name = "โจมตีเป้าหมายที่ล็อกไว้",
    Callback = function()
        if lockTarget then
            local target = game.Players:FindFirstChild(lockTarget)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                rootPart.CFrame = target.Character.HumanoidRootPart.CFrame
                humanoid:MoveTo(target.Character.HumanoidRootPart.Position)
            else
                OrionLib:MakeNotification({
                    Name = "ล็อกเป้าหมายล้มเหลว",
                    Content = "ไม่พบเป้าหมายหรือไม่สามารถล็อกได้",
                    Image = "rbxassetid://4483345998",
                    Time = 5
                })
            end
        end
    end
})

-- 📊 Tab: Misc (FPS, เวลา, ความเร็ว)
local MiscTab = Window:MakeTab({Name = "Misc", Icon = "rbxassetid://4483345998", PremiumOnly = false})

MiscTab:AddLabel("⏳ เวลาที่อยู่ในเซิร์ฟเวอร์: " .. tostring(os.time() - startTime) .. " วินาที")
MiscTab:AddLabel("🎮 FPS: " .. tostring(workspace:GetRealPhysicsFPS()))
MiscTab:AddLabel("🚀 ความเร็ว: " .. humanoid.WalkSpeed)

MiscTab:AddSlider({
    Name = "ปรับความเร็ว",
    Min = 1,
    Max = 100,
    Default = 100,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(value)
        humanoid.WalkSpeed = value
    end
})

-- 📊 อัปเดตค่า FPS และเวลาในเซิร์ฟแบบ Real-Time
spawn(function()
    while wait(1) do
        MiscTab:UpdateLabel("⏳ เวลาที่อยู่ในเซิร์ฟเวอร์: " .. tostring(os.time() - startTime) .. " วินาที")
        MiscTab:UpdateLabel("🎮 FPS: " .. tostring(workspace:GetRealPhysicsFPS()))
    end
end)

-- 🖌️ เปลี่ยนธีม UI
MiscTab:AddDropdown({
    Name = "เลือกธีม UI",
    Default = "White",
    Options = {"White", "Black", "Gray"},
    Callback = function(Value)
        if Value == "White" then
            OrionLib:SetTheme(Color3.fromRGB(255, 255, 255))
        elseif Value == "Black" then
            OrionLib:SetTheme(Color3.fromRGB(0, 0, 0))
        elseif Value == "Gray" then
            OrionLib:SetTheme(Color3.fromRGB(128, 128, 128))
        end
    end
})

-- ⚙️ Tab: Settings
local SettingsTab = Window:MakeTab({Name = "Settings", Icon = "rbxassetid://4483345998", PremiumOnly = false})

SettingsTab:AddButton({
    Name = "ปิด UI",
    Callback = function()
        OrionLib:Destroy()
    end
})

-- 🌟 เริ่มต้น UI
OrionLib:Init()
