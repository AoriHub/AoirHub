-- Aori Hub Premium Script
local player = game.Players.LocalPlayer
local humanoid = player.Character or player.CharacterAdded:Wait():WaitForChild("Humanoid")

-- 🛡️ No Fall Damage
humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)

-- ⚡ Speed Boost
humanoid.WalkSpeed = 50

-- 👻 Invisibility
for _, v in pairs(player.Character:GetChildren()) do
    if v:IsA("BasePart") then
        v.Transparency = 1
    end
end

-- 🩸 God Mode
humanoid.MaxHealth = math.huge
humanoid.Health = math.huge

print("✅ Aori Hub Premium Loaded Successfully!")
