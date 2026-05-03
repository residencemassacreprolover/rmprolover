local Window = shared.Window
local Library = shared.Library

local MainTab = Window:AddTab({
    Name = "Main",
    Icon = "zap"
})

local ExploitGB = MainTab:AddLeftGroupbox("Exploits")

--// vars
local replicatedStorage = game:GetService("ReplicatedStorage")
local gameState = replicatedStorage:WaitForChild("GameState", 5)
local remotes = replicatedStorage:FindFirstChild("Remotes")
local bypassUsed = false

local function generateRandomName()
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local result = ""
    for i = 1, math.random(20, 35) do
        local randomIndex = math.random(1, #chars)
        result = result .. string.sub(chars, randomIndex, randomIndex)
    end
    return result
end

--// Bypass Anticheat
ExploitGB:AddButton({
    Text = "Bypass Anticheat",
    Func = function()
        if bypassUsed then
            Library:Notify("Anticheat bypass already used!", 2)
            return
        end

        local kickRemote = remotes and remotes:FindFirstChild("Kick") or replicatedStorage:FindFirstChild("Kick")

        if kickRemote then
            kickRemote.Name = generateRandomName()
            bypassUsed = true
            Library:Notify("Success: Anticheat bypassed", 2)
        else
            Library:Notify("Error: Couldn't find 'Kick' remote", 3)
        end
    end
})

--// Disable Blizzard 
local blizzard = gameState and gameState:FindFirstChild("Blizzard")

local blizzardToggle = ExploitGB:AddToggle("DisableBlizzardToggle", {
    Text = "Disable Blizzard",
    Default = false,
    Tooltip = "Blizzard Modifier Must be On!",
    Callback = function(Value)
        if blizzard and blizzard:IsA("BoolValue") then
            blizzard.Value = not Value
            Library:Notify(Value and "Blizzard disabled" or "Blizzard re-enabled", 2)
        else
            Library:Notify("Blizzard value not found in GameState", 3)
        end
    end
})

blizzardtoggle:SetDisabled(not blizzard.Value)
