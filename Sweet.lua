-- โหลด Orion UI Library
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()

-- ตรวจสอบว่าเป็นมือถือหรือไม่
local UserInputService = game:GetService("UserInputService")
local isMobile = UserInputService.TouchEnabled

-- สร้างหน้าต่าง UI
local Window = OrionLib:MakeWindow({
    Name = "Aori Hub - Ultimate",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "AoriHub_Config",
    IntroEnabled = true,
    IntroText = "Aori Hub Loading..."
})

-- 🧠 ตัวแปรหลัก
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local startTime = os.time()
local auraEnabled = false
local barrierEnabled = false
local lockTarget = nil

-- ตัวแปรสำหรับการปรับแต่ง UI
local uiScale = isMobile and 0.8 or 1 -- ขนาดเริ่มต้น (เล็กลงสำหรับมือถือ)
local uiTransparency = 0.1 -- ความโปร่งใสเริ่มต้น
local uiBackgroundColor = Color3.fromRGB(30, 30, 30) -- สีพื้นหลังเริ่มต้น

-- ป้องกันการโหลดซ้ำเมื่อตัวละครเกิดใหม่
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    rootPart = char:WaitForChild("HumanoidRootPart")
end)

-- 📊 Tab: Combat
local CombatTab = Window:MakeTab({Name = "Combat", Icon = "rbxassetid://4483345998", PremiumOnly = false})

CombatTab:AddToggle({
    Name = "Enable Aura (10cm, 789 DMG)",
    Default = false,
    Callback = function(Value)
        auraEnabled = Value
        if auraEnabled then
            task.spawn(function()
                while auraEnabled and humanoid.Health > 0 do
                    pcall(function()
                        for _, v in pairs(workspace:GetChildren()) do
                            if v:IsA("Model") and v ~= character and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                                local distance = (v.HumanoidRootPart.Position - rootPart.Position).Magnitude
                                if distance <= 10 then
                                    v.Humanoid:TakeDamage(789)
                                end
                            end
                        end
                    end)
                    task.wait(0.5)
                end
            end)
        end
    end
})

CombatTab:AddToggle({
    Name = "Enable Barrier (Green Sphere)",
    Default = false,
    Callback = function(Value)
        barrierEnabled = Value
        if barrierEnabled then
            local barrier = Instance.new("Part")
            barrier.Name = "Barrier"
            barrier.Shape = Enum.PartType.Ball
            barrier.Size = Vector3.new(30, 30, 30)
            barrier.Transparency = 0.5
            barrier.Anchored = true
            barrier.CanCollide = false
            barrier.Color = Color3.fromRGB(0, 255, 0)
            barrier.Parent = character
            barrier.CFrame = rootPart.CFrame
            
            task.spawn(function()
                while barrierEnabled and humanoid.Health > 0 do
                    barrier.CFrame = rootPart.CFrame
                    task.wait(0.1)
                end
                barrier:Destroy()
            end)
        end
    end
})

CombatTab:AddTextbox({
    Name = "Lock Target (Player Name)",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        lockTarget = Value
    end
})

CombatTab:AddButton({
    Name = "Attack Locked Target",
    Callback = function()
        if lockTarget then
            local target = Players:FindFirstChild(lockTarget)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                rootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)
                humanoid:MoveTo(target.Character.HumanoidRootPart.Position)
            else
                OrionLib:MakeNotification({
                    Name = "Target Lock Failed",
                    Content = "Target not found or invalid",
                    Image = "rbxassetid://4483345998",
                    Time = 5
                })
            end
        end
    end
})

-- 📊 Tab: Misc
local MiscTab = Window:MakeTab({Name = "Misc", Icon = "rbxassetid://4483345998", PremiumOnly = false})

local timeLabel = MiscTab:AddLabel("⏳ Server Time: 0s")
local fpsLabel = MiscTab:AddLabel("🎮 FPS: 0")
local speedLabel = MiscTab:AddLabel("🚀 Speed: " .. humanoid.WalkSpeed)

MiscTab:AddSlider({
    Name = "Adjust Speed",
    Min = 16,
    Max = 100,
    Default = 16,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(value)
        humanoid.WalkSpeed = value
        speedLabel:Set("🚀 Speed: " .. value)
    end
})

-- อัปเดตข้อมูลแบบเรียลไทม์
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            timeLabel:Set("⏳ Server Time: " .. tostring(os.time() - startTime) .. "s")
            fpsLabel:Set("🎮 FPS: " .. tostring(math.floor(1 / game:GetService("RunService").RenderStepped:Wait())))
        end)
    end
end)

-- 📊 Tab: UI Customization (เพิ่มใหม่)
local UITab = Window:MakeTab({Name = "UI Customize", Icon = "rbxassetid://4483345998", PremiumOnly = false})

UITab:AddSlider({
    Name = "UI Scale",
    Min = 0.5,
    Max = 1.5,
    Default = uiScale,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 0.1,
    ValueName = "Scale",
    Callback = function(value)
        uiScale = value
        Window:SetScale(Vector2.new(uiScale, uiScale))
    end
})

UITab:AddSlider({
    Name = "UI Transparency",
    Min = 0,
    Max = 1,
    Default = uiTransparency,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 0.1,
    ValueName = "Transparency",
    Callback = function(value)
        uiTransparency = value
        -- ปรับความโปร่งใสของ UI (ต้องใช้ API ภายใน Orion หากรองรับ)
        OrionLib:MakeNotification({
            Name = "Transparency",
            Content = "Set to " .. value,
            Time = 3
        })
    end
})

UITab:AddColorpicker({
    Name = "Background Color",
    Default = uiBackgroundColor,
    Callback = function(value)
        uiBackgroundColor = value
        -- ปรับสีพื้นหลัง (ขึ้นอยู่กับ Orion API)
        OrionLib:MakeNotification({
            Name = "Color Changed",
            Content = "Background set to new color",
            Time = 3
        })
    end
})

UITab:AddDropdown({
    Name = "Select Theme",
    Default = "Dark",
    Options = {"Dark", "Light", "Custom"},
    Callback = function(Value)
        if Value == "Dark" then
            uiBackgroundColor = Color3.fromRGB(30, 30, 30)
        elseif Value == "Light" then
            uiBackgroundColor = Color3.fromRGB(255, 255, 255)
        elseif Value == "Custom" then
            OrionLib:MakeNotification({
                Name = "Custom Theme",
                Content = "Use Colorpicker to set custom color",
                Time = 5
            })
        end
    end
})

UITab:AddToggle({
    Name = "Compact Mode (Mobile)",
    Default = isMobile,
    Callback = function(Value)
        if Value then
            Window:SetScale(Vector2.new(0.6, 0.6))
        else
            Window:SetScale(Vector2.new(uiScale, uiScale))
        end
    end
})

-- ⚙️ Tab: Settings
local SettingsTab = Window:MakeTab({Name = "Settings", Icon = "rbxassetid://4483345998", PremiumOnly = false})

SettingsTab:AddButton({
    Name = "Close UI",
    Callback = function()
        OrionLib:Destroy()
    end
})

-- ตั้งค่าเริ่มต้น
Window:SetScale(Vector2.new(uiScale, uiScale))

-- 🌟 เริ่มต้น UI
OrionLib:Init()

-- การจัดการข้อผิดพลาด
local function handleError(err)
    OrionLib:MakeNotification({
        Name = "Error",
        Content = "An error occurred: " .. tostring(err),
        Image = "rbxassetid://4483345998",
        Time = 5
    })
end

xpcall(function()
    -- โค้ดหลักอยู่ในนี้
end, handleError)