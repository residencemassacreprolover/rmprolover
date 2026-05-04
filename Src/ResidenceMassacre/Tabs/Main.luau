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

local TrollingGB = MainTab:AddLeftGroupbox("Trolling")

-- pain in the ass but it finally worked
local PlayerSelector = TrollingGB:AddDropdown("PlayerTarget", {
    Text = "Select a Player",
    SpecialType = "Player", 
    ExcludeLocalPlayer = false,
    EnablePlayerImages = true, 
    Tooltip = "Select a Player To Troll",
})

TrollingGB:AddButton({
    Text = "Kill Selected",
    Func = function()
        local selected = PlayerSelector.Value
        local targetName = tostring(selected) 
        
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local targetPlayer = Players:FindFirstChild(targetName)
        
        if targetPlayer then
            local remote = ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("PlayerMutant")
            if remote then
                remote:FireServer("Kill", targetPlayer)
                shared.Library:Notify("Sent Kill to " .. targetName, 2)
            end
        else
            shared.Library:Notify("Player not found in game", 3)
        end
    end
})


TrollingGB:AddButton({
    Text = "Spawn Trap On Self",
    Func = function()
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local LocalPlayer = Players.LocalPlayer
        
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local remote = ReplicatedStorage.Remotes.PlayerMutant
            local myPos = LocalPlayer.Character.HumanoidRootPart.CFrame
            
            remote:FireServer("Trap", myPos)
            shared.Library:Notify("Trap spawned at self", 2)
        end
    end
})

TrollingGB:AddButton({
    Text = "Spawn Trap On Player",
    Func = function()
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        
        local selected = PlayerSelector.Value
        local targetName = tostring(selected)
        local targetPlayer = Players:FindFirstChild(targetName)
        
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local remote = ReplicatedStorage.Remotes.PlayerMutant
            local targetPos = targetPlayer.Character.HumanoidRootPart.CFrame
            
            remote:FireServer("Trap", targetPos)
            shared.Library:Notify("Trap spawned on " .. targetName, 2)
        else
            shared.Library:Notify("Target invalid or has no character", 3)
        end
    end
})
