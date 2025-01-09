-- โหลด Orion UI Library
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

-- สร้างหน้าต่าง UI
local Window = OrionLib:MakeWindow({
    Name = "TANGMO HUB",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "TANGMO_Config"
})

-- ตัวแปรการทำงาน
local fishingSettings = {
    isEnabled = false, -- สถานะการทำงาน
    shakeDelay = 1,    -- เวลาการเขย่าหน้าจอ (วินาที)
    holdDuration = 2,  -- เวลากดค้าง (วินาที)
    maxBarValue = 100, -- ค่าหลอดสีขาวที่ต้องเต็ม
    currentBarValue = 0 -- ค่าปัจจุบันของหลอด
}

-- ฟังก์ชันเปิด-ปิดระบบออโต้ตกปลา
function toggleAutoFishing()
    fishingSettings.isEnabled = not fishingSettings.isEnabled
    if fishingSettings.isEnabled then
        OrionLib:MakeNotification({
            Name = "Fishing",
            Content = "เริ่มระบบออโต้ตกปลา",
            Image = "rbxassetid://4483345998", -- ไอคอน
            Time = 5
        })
        startFishing()
    else
        OrionLib:MakeNotification({
            Name = "Fishing",
            Content = "ปิดระบบออโต้ตกปลา",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
end

-- ฟังก์ชันเริ่มตกปลา
function startFishing()
    while fishingSettings.isEnabled do
        clickRod()      -- กดที่เบ็ด
        holdScreen()    -- กดค้างหน้าจอ 2 วินาที
        shakeScreen()   -- การเขย่าหน้าจอ
        controlBar()    -- การควบคุมหลอดสีขาว
        underwaterFishing() -- การตกปลาใต้น้ำแบบไม่ตาย
    end
end

-- ฟังก์ชันต่าง ๆ (เหมือนที่อธิบายไว้ก่อนหน้านี้)
function clickRod()
    print("กดที่เบ็ด")
end

function holdScreen()
    print("กดค้างหน้าจอ " .. fishingSettings.holdDuration .. " วินาที")
    wait(fishingSettings.holdDuration)
    print("ปล่อยหน้าจอ")
end

function shakeScreen()
    print("เขย่าหน้าจอ " .. fishingSettings.shakeDelay .. " วินาที")
    wait(fishingSettings.shakeDelay)
end

function controlBar()
    fishingSettings.currentBarValue = 0
    while fishingSettings.currentBarValue < fishingSettings.maxBarValue do
        pressButton()
        fishingSettings.currentBarValue = fishingSettings.currentBarValue + 10
        print("ค่าหลอดปัจจุบัน: " .. fishingSettings.currentBarValue)
    end
    print("หลอดสีขาวเต็มแล้ว!")
end

function pressButton()
    print("กดปุ่มเพิ่มค่าหลอด")
    wait(0.1)
end

function underwaterFishing()
    print("ตกปลาใต้น้ำแบบไม่ตาย")
end

-- สร้างแท็บ UI
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- เพิ่มปุ่มเปิด-ปิดระบบ
MainTab:AddToggle({
    Name = "เปิด/ปิด ออโต้ตกปลา",
    Default = false,
    Callback = function(Value)
        fishingSettings.isEnabled = Value
        toggleAutoFishing()
    end
})

-- เพิ่มตัวเลื่อนค่าการเขย่า
MainTab:AddSlider({
    Name = "ตั้งค่าการเขย่า (วินาที)",
    Min = 1,
    Max = 5,
    Default = 1,
    Color = Color3.fromRGB(255, 0, 0),
    Increment = 0.1,
    Callback = function(Value)
        fishingSettings.shakeDelay = Value
    end
})

-- เพิ่มระบบเคลื่อนย้าย UI
Window:MakeDraggable()

-- เริ่มต้น UI
OrionLib:Init()
