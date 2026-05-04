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

local blizzardtoggle = ExploitGB:AddToggle("DisableBlizzardToggle", {
    Text = "Disable Blizzard",
    Default = false,
    DisabledTooltip = "The Blizzard Modifier must be On", 
    Callback = function(Value)
        if not (blizzard and blizzard:IsA("BoolValue")) then
            Library:Notify({
                Title = "Uh Oh!",
                Description = "Blizzard not found",
                Duration = 3
            })
            return
        end

        blizzard.Value = not Value

        Library:Notify({
            Title = "Blizzard",
            Description = Value and "Blizzard disabled" or "Blizzard re-enabled",
            Duration = 2
        })
    end
})

blizzardtoggle:SetDisabled(not blizzard.Value)

local S = shared.Services
local TrollingGB = MainTab:AddLeftGroupbox("Trolling")

local PlayerSelector = TrollingGB:AddDropdown("PlayerTarget", {
    Text = "Select a Player",
    SpecialType = "Player", 
    ExcludeLocalPlayer = false,
    EnablePlayerImages = true, 
    Tooltip = "Select a Player To Kill",
})

TrollingGB:AddButton({
    Text = "Kill Selected",
    Callback = function()
        local targetName = PlayerSelector.Value
       shared.Library:Notify("Killed: " .. targetName, 2)
        local targetPlayer = S.Players:FindFirstChild(targetName)
        shared.Library:Notify("Killed: " .. targetPlayer, 2)
        local remote = S.ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("PlayerMutant")
        shared.Library:Notify("Killed: " .. remote, 2)        
                
    end
})
