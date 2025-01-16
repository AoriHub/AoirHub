-- โหลด Orion UI Library
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

-- สร้างหน้าต่าง UI
local Window = OrionLib:MakeWindow({
    Name = "BloxFruitZ Hub",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "BloxFruitZ_Config"
})

-- สร้างแท็บหลัก
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998", -- เปลี่ยน Icon ตามที่ต้องการ
    PremiumOnly = false
})

-- เพิ่มปุ่มโหลดสคริปต์
MainTab:AddButton({
    Name = "Load BloxFruitZ Script",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AoriHub/AoirHub/refs/heads/main/BloxFruitZ.lua"))()
    end
})

-- เพิ่มข้อความแจ้งเตือนเมื่อเปิดใช้งาน
MainTab:AddParagraph("Note", "กดปุ่มด้านบนเพื่อโหลดสคริปต์ BloxFruitZ")

-- ปิด UI
OrionLib:Init()
