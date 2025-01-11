-- โหลด UI Library
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

-- สร้างหน้าต่าง UI
local Window = OrionLib:MakeWindow({
    Name = "RemoteSpy",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "RemoteSpyConfig"
})

-- ตัวแปรหลัก
local spyEnabled = false
local detectedRemotes = {}

-- สร้างแท็บ UI
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- ฟังก์ชันสำหรับดักจับ Remote
function startRemoteSpy()
    if spyEnabled then
        OrionLib:MakeNotification({
            Name = "RemoteSpy",
            Content = "RemoteSpy กำลังทำงานอยู่",
            Image = "rbxassetid://4483345998",
            Time = 5
        })

        -- ดักจับการเรียกใช้ RemoteEvent และ RemoteFunction
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            if spyEnabled and (self:IsA("RemoteEvent") or self:IsA("RemoteFunction")) then
                local method = getnamecallmethod()
                local args = {...}
                local info = {
                    RemoteName = self.Name,
                    RemoteType = self.ClassName,
                    Method = method,
                    Arguments = args
                }
                table.insert(detectedRemotes, info)

                OrionLib:MakeNotification({
                    Name = "Remote Detected",
                    Content = "พบ Remote: " .. self.Name,
                    Image = "rbxassetid://4483345998",
                    Time = 3
                })
            end
            return oldNamecall(self, ...)
        end)
    end
end

-- สร้างปุ่มเปิด-ปิด RemoteSpy
MainTab:AddToggle({
    Name = "เปิด/ปิด RemoteSpy",
    Default = false,
    Callback = function(Value)
        spyEnabled = Value
        if Value then
            startRemoteSpy()
        else
            OrionLib:MakeNotification({
                Name = "RemoteSpy",
                Content = "RemoteSpy ถูกปิด",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    end
})

-- สร้างปุ่มดูข้อมูล Remote ที่ตรวจพบ
MainTab:AddButton({
    Name = "ดู Remote ที่ตรวจพบ",
    Callback = function()
        for _, remote in pairs(detectedRemotes) do
            print("---- Remote Detected ----")
            print("ชื่อ Remote: " .. remote.RemoteName)
            print("ประเภท Remote: " .. remote.RemoteType)
            print("วิธีการเรียกใช้: " .. remote.Method)
            print("อาร์กิวเมนต์: ")
            for i, arg in ipairs(remote.Arguments) do
                print("   [" .. i .. "] = " .. tostring(arg))
            end
            print("--------------------------")
        end
    end
})

-- สร้างปุ่มสำหรับคัดลอกข้อมูล Remote
MainTab:AddButton({
    Name = "คัดลอก Remote ล่าสุด",
    Callback = function()
        if #detectedRemotes > 0 then
            local lastRemote = detectedRemotes[#detectedRemotes]
            local code = "-- Remote Detected: " .. lastRemote.RemoteName .. "\n"
            code = code .. "local remote = game:GetService('ReplicatedStorage'):FindFirstChild('" .. lastRemote.RemoteName .. "')\n"
            code = code .. "remote:" .. lastRemote.Method .. "("
            for i, arg in ipairs(lastRemote.Arguments) do
                code = code .. tostring(arg)
                if i < #lastRemote.Arguments then
                    code = code .. ", "
                end
            end
            code = code .. ")"
            
            setclipboard(code)
            OrionLib:MakeNotification({
                Name = "คัดลอกโค้ดสำเร็จ",
                Content = "โค้ด Remote ถูกคัดลอกแล้ว",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        else
            OrionLib:MakeNotification({
                Name = "ไม่มี Remote",
                Content = "ยังไม่มี Remote ที่ตรวจพบ",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    end
})

-- เริ่มต้น UI
OrionLib:Init()
