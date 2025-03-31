--// โหลด UI Library local RayfieldLoaded, Rayfield = pcall(loadstring, game:HttpGet('https://sirius.menu/rayfield')) if not RayfieldLoaded then warn("Rayfield UI โหลดไม่สำเร็จ!") return end

--// สร้าง Window local Window = Rayfield:CreateWindow({ Name = "Aori Hub - Premium Script", LoadingTitle = "Loading Aori Hub...", LoadingSubtitle = "by YourName", ConfigurationSaving = { Enabled = false, }, Discord = { Enabled = false, }, KeySystem = false })

--// สร้าง Tab (หมวดหมู่) local GeneralTab = Window:CreateTab("General", 4483362458) local LocationsTab = Window:CreateTab("Locations", 4483362458) local SettingsTab = Window:CreateTab("Settings", 4483362458)

--// โหลดโค้ดจาก SweetMoJa.lua local SweetMoJaScript = loadfile("SweetMoJa.lua") if SweetMoJaScript then SweetMoJaScript() else warn("โหลด SweetMoJa.lua ไม่สำเร็จ!") end

--// เพิ่มปุ่มและฟังก์ชันใน GeneralTab GeneralTab:CreateSlider({ Name = "Speed Hack", Min = 1, Max = 250, CurrentValue = 50, Callback = function(Value) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value end })

GeneralTab:CreateButton({ Name = "ESP (Wallhack)", Callback = function() for _, player in pairs(game.Players:GetPlayers()) do if player ~= game.Players.LocalPlayer then local highlight = Instance.new("Highlight") highlight.Parent = player.Character highlight.Adornee = player.Character highlight.FillColor = Color3.fromRGB(255, 0, 0) highlight.OutlineColor = Color3.fromRGB(255, 0, 0) end end end })

GeneralTab:CreateDropdown({ Name = "Teleport to Player", Options = (function() local playerNames = {} for _, player in pairs(game.Players:GetPlayers()) do table.insert(playerNames, player.Name) end return playerNames end)(), Callback = function(Value) local targetPlayer = game.Players:FindFirstChild(Value) if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame end end })

GeneralTab:CreateButton({ Name = "Enable Flight", Callback = function() local player = game.Players.LocalPlayer if player.Character and player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid.JumpPower = 0 player.Character.Humanoid.PlatformStand = true player.Character.HumanoidRootPart.Velocity = Vector3.new(0, 160, 0) end end })

--// เปิด UI Rayfield:LoadConfiguration()

