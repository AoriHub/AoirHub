-- โหลด Orion UI Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({
    Name = "Aori Hub - Secure",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "AoriHub_Config"
})

-- 🧠 ตัวแปรหลัก
local player = game.Players.LocalPlayer
local isKeyValid = false
local validKeys = {
    "Allmap-Aoir-7TJO-79KJ-ZVO9",
    "Allmap-Aoir-F7GH-5IY&-UOP1",
    "Allmap-Aoir-VJ3O-YNUP-YER0",
    "Allmap-Aoir-X4GK-RFJO-MGS7",
    "Allmap-Aoir-BVU7-JOPL-SFDG",
    "Allmap-Aoir-FYTR-AROG-WS7K",
    "Allmap-Aoir-ZFSV-MBNI-OYTU",
    "Allmap-Aoir-REIO-GJKL-DSAX",
    "Allmap-Aoir-RAXC-HOP8-KGSF",
    "Allmap-Aoir-VXZE-TOUP-BSWE"
}

-- ฟังก์ชันตรวจสอบ Key
local function validateKey(inputKey)
    for _, key in pairs(validKeys) do
        if inputKey == key then
            return true
        end
    end
    return false
end

-- 🌟 หน้า Key Verification
local KeyTab = Window:MakeTab({Name = "Key Verification", Icon = "rbxassetid://4483345998", PremiumOnly = false})

KeyTab:AddTextbox({
    Name = "กรุณาใส่ Key",
    Default = "",
    TextDisappear = true,
    Callback = function(inputKey)
        if validateKey(inputKey) then
            isKeyValid = true
            OrionLib:MakeNotification({
                Name = "ยืนยัน Key สำเร็จ!",
                Content = "คุณสามารถใช้งานฟังก์ชันทั้งหมดได้แล้ว",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        else
            isKeyValid = false
            OrionLib:MakeNotification({
                Name = "Key ไม่ถูกต้อง",
                Content = "กรุณาใส่ Key ที่ถูกต้องเพื่อใช้งาน",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    end
})

-- 🌀 หน้า Main UI
local MainTab = Window:MakeTab({Name = "Main Functions", Icon = "rbxassetid://4483345998", PremiumOnly = false})

-- ฟังก์ชัน Aura (รัศมีสีชมพู)
MainTab:AddToggle({
    Name = "เปิดใช้งาน Aura",
    Default = false,
    Callback = function(enabled)
        if isKeyValid then
            if enabled then
                while enabled do
                    wait(0.1)
                    for _, v in pairs(workspace.Players:GetChildren()) do
                        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                            local distance = (v.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                            if distance <= 10 then
                                v.Humanoid:TakeDamage(789)
                                -- เอฟเฟกต์ Aura สีชมพู
                                local aura = Instance.new("Part", workspace)
                                aura.Shape = Enum.PartType.Ball
                                aura.Size = Vector3.new(5, 5, 5)
                                aura.Color = Color3.fromRGB(255, 105, 180)
                                aura.CFrame = player.Character.HumanoidRootPart.CFrame
                                aura.Anchored = true
                                aura.CanCollide = false
                                game:GetService("Debris"):AddItem(aura, 0.5)
                            end
                        end
                    end
                end
            end
        else
            OrionLib:MakeNotification({
                Name = "Key ไม่ถูกต้อง",
                Content = "กรุณายืนยัน Key ก่อนใช้งานฟังก์ชันนี้",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    end
})

-- ฟังก์ชัน Barrier (บาเรียสีเขียว)
MainTab:AddToggle({
    Name = "เปิดใช้งาน Barrier",
    Default = false,
    Callback = function(enabled)
        if isKeyValid then
            if enabled then
                local barrier = Instance.new("Part", player.Character)
                barrier.Shape = Enum.PartType.Ball
                barrier.Size = Vector3.new(20, 20, 20)
                barrier.Color = Color3.fromRGB(0, 255, 0)
                barrier.Anchored = true
                barrier.CanCollide = false
                barrier.Name = "Barrier"
            else
                if player.Character:FindFirstChild("Barrier") then
                    player.Character.Barrier:Destroy()
                end
            end
        else
            OrionLib:MakeNotification({
                Name = "Key ไม่ถูกต้อง",
                Content = "กรุณายืนยัน Key ก่อนใช้งานฟังก์ชันนี้",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    end
})

-- ฟังก์ชันล็อกเป้าหมาย
MainTab:AddTextbox({
    Name = "ใส่ชื่อเป้าหมาย",
    Default = "",
    TextDisappear = true,
    Callback = function(targetName)
        if isKeyValid then
            local targetPlayer = game.Players:FindFirstChild(targetName)
            if targetPlayer then
                OrionLib:MakeNotification({
                    Name = "ล็อกเป้าหมายสำเร็จ",
                    Content = "เป้าหมาย: " .. targetName,
                    Image = "rbxassetid://4483345998",
                    Time = 5
                })
                -- ใช้งานสกิลเฉพาะเป้าหมาย
                MainTab:AddButton({
                    Name = "โจมตีเป้าหมาย",
                    Callback = function()
                        if targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
                            targetPlayer.Character.Humanoid:TakeDamage(1000)
                        end
                    end
                })
            else
                OrionLib:MakeNotification({
                    Name = "ไม่พบเป้าหมาย",
                    Content = "ไม่สามารถล็อกเป้าหมายได้",
                    Image = "rbxassetid://4483345998",
                    Time = 5
                })
            end
        else
            OrionLib:MakeNotification({
                Name = "Key ไม่ถูกต้อง",
                Content = "กรุณายืนยัน Key ก่อนใช้งานฟังก์ชันนี้",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
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
