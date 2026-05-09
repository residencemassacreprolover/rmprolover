local Window = shared.Window
local Library = shared.Library
local Toggles = shared.Toggles
local Options = shared.Options


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

local TrollingGB = MainTab:AddRightGroupbox("Trolling")

-- pain in the ass but it finally worked
local PlayerSelector = TrollingGB:AddDropdown("PlayerTarget", {
    Text = "Select a Player",
    SpecialType = "Player", 
    ExcludeLocalPlayer = false,
    EnablePlayerImages = true, 
    Tooltip = "Select a Player To Troll",
})

TrollingGB:AddSlider("tickrate", {
    Text = "Speed & Rate of The Loop",
    Default = 0.5,
    Min = 0,
    Max = 2,
    Rounding = 3
})


TrollingGB:AddButton({
    Text = "Kill Selected",
    Risky = true,
    Tooltip = "Name of The Killer will be displayed in an Error On the Console for Everyone",
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

local trapLoop = false

TrollingGB:AddToggle("FollowTrap", {
    Text = "Trap Follow Player",
    Default = false,
    Risky = true,
    Tooltip = "Could Cause Intense Lag (FE)",
    Callback = function(Value)
        trapLoop = Value
        if Value then
            task.spawn(function()
                local Players = game:GetService("Players")
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local remote = ReplicatedStorage.Remotes.PlayerMutant

                while trapLoop do
                    local selected = PlayerSelector.Value
                    local targetPlayer = Players:FindFirstChild(tostring(selected))

                    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        remote:FireServer("Trap", targetPlayer.Character.HumanoidRootPart.CFrame)
                    end
                    task.wait(Options.tickrate.Value)
                end
            end)
        end
    end
})

TrollingGB:AddDivider()

local lanternLoop = false
local strobeLoop = false

-- Helper to find the Lantern if it exists in game
local function getLanternTool()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local char = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    
    return (char and char:FindFirstChild("Lantern")) or (backpack and backpack:FindFirstChild("Lantern"))
end
-- helper to pick already existing lanterns in workspace
local function pickUpExistingLantern()
    for _, obj in pairs(workspace:GetChildren()) do
        if obj.Name == "Lantern" and obj:IsA("Model") then
            local cd = obj:FindFirstChild("Handle") and obj.Handle:FindFirstChild("ClickDetector")
            if cd then
                fireclickdetector(cd)
            end
        end
    end
end
-- most useless helpers oat

TrollingGB:AddButton({
    Text = "Place Lantern on Player",
    Tooltip = "Need to Have Lantern in Inventory",
    Func = function()
        local selected = PlayerSelector.Value
        local targetPlayer = game.Players:FindFirstChild(tostring(selected))
        pickUpExistingLantern()
        task.wait(0.1)
        local lantern = getLanternTool()
        
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if lantern and lantern:FindFirstChild("Place") then
                local head = targetPlayer.Character:FindFirstChild("Head") or targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                local targetPos = head.CFrame * CFrame.new(0, 0, 0)
                lantern.Place:FireServer(targetPos)
                shared.Library:Notify("Lantern placed on " .. targetPlayer.Name, 2)
            else
                shared.Library:Notify("Lantern Tool not found!", 3)
            end
        else
            shared.Library:Notify("Target invalid or missing", 3)
        end
    end
})

TrollingGB:AddToggle("LoopLantern", {
    Text = "Loop Place Lantern on Player",
    Default = false,
    Risky = true,
    Tooltip = "Could Cause Intense Lag (FE)",
    Callback = function(Value)
        lanternLoop = Value
        if Value then
            task.spawn(function()
                while lanternLoop do
                    pickUpExistingLantern()
                    task.wait(Options.tickrate.Value / 3)
                    local selected = PlayerSelector.Value
                    local targetPlayer = game.Players:FindFirstChild(tostring(selected))
                    local lantern = getLanternTool()

                    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and lantern and lantern:FindFirstChild("Place") then
                        local head = targetPlayer.Character:FindFirstChild("Head") or targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                        local targetPos = head.CFrame * CFrame.new(0, 0, 0)
                        lantern.Place:FireServer(targetPos)
                        
                        -- Yoink
                        task.wait(Options.tickrate.Value / 3) 
                        for _, obj in pairs(workspace:GetChildren()) do
                            if obj.Name == "Lantern" and obj:IsA("Model") then
                                local cd = obj:FindFirstChild("Handle") and obj.Handle:FindFirstChild("ClickDetector")
                                if cd then
                                    fireclickdetector(cd)
                                end
                            end
                        end
                    end
                    task.wait(Options.tickrate.Value / 3)
                end
            end)
        end
    end
})


local AutoGB = MainTab:AddLeftGroupbox("Autos")
local ClickWireRemote = remotes:WaitForChild("ClickWire")

local function fixActiveWires()
    local fuseBox = workspace:FindFirstChild("FuseBox")
    if not fuseBox then return end
    
    local wiresFolder = fuseBox:FindFirstChild("Wires")
    if not wiresFolder then return end

    for i = 1, 4 do
        local wire = wiresFolder:FindFirstChild(tostring(i))
        if wire then
            local sparkles = wire:FindFirstChild("Sparkles")
            if sparkles and sparkles.Enabled then
                ClickWireRemote:FireServer(wire)
            end
        end
    end
end

AutoGB:AddButton({
    Text = "Fix Wires",
    Func = function()
        fixActiveWires()
    end
})

AutoGB:AddToggle("AutoWire", {
    Text = "Auto Fix Wires",
    Tooltip = "Automatically Fixes wires whenever they break",
    Default = false,
    Callback = function(Value)
        _G.AutoWire = Value
        if Value then
            task.spawn(function()
                while _G.AutoWire do
                    fixActiveWires()
                    task.wait(0.5) 
                end
            end)
        end
    end
})

AutoGB:AddButton({
    Text = "Complete Objectives",
    Tooltip = "Completes the two Starting Objectives of Night 1",
    Func = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        local radio = workspace:FindFirstChild("Radio")
        local detector = radio and radio:FindFirstChild("ClickDetector")
        local gameState = game:GetService("ReplicatedStorage"):FindFirstChild("GameState")

        if rootPart then
            rootPart.CFrame = CFrame.new(
                -34.3541336, 7.79997444, -58.3701172, 
                0.619202912, -3.47004629e-08, -0.785230994, 
                5.68393368e-08, 1, 6.29901742e-10, 
                0.785230994, -4.50220448e-08, 0.619202912
            )

            shared.Library:Notify("Teleported! Firing Radio Clicks", 2)

            task.spawn(function()
                while gameState and not gameState.Active.Value do
                    if detector then
                        fireclickdetector(detector)
                    end
                    task.wait(0.3)
                end
                shared.Library:Notify("Objectives Completed", 2)
            end)
        else
            shared.Library:Notify("Character root not found? How. Are you dead? seriously.", 2)
        end
    end
})

AutoGB:AddDivider()

local FlashEvent = remotes:WaitForChild("FlashCam")
local CamerasFolder = workspace:WaitForChild("Cameras")
local LocalPlayer = game:GetService("Players").LocalPlayer

local selectedCamera = "1"



AutoGB:AddDropdown("CameraSelect", {
    Text = "Cameras",
    Tooltip = "Select Cameras For Flashing",
    Default = "1",
    Values = {"1", "2", "3"},
    Callback = function(Value)
        selectedCamera = Value
    end
})


AutoGB:AddButton({
    Text = "Flash Selected Camera",
    Func = function()
        local camObject = CamerasFolder:FindFirstChild(selectedCamera)
        if camObject then
            firesignal(FlashEvent.OnClientEvent, LocalPlayer, 0.0001, camObject)
        else
            shared.Library:Notify("Camera not Setup!", 2)
        end
    end
})


AutoGB:AddToggle("LoopFlashAll", {
    Text = "Loop Flash ALL Cameras",
    Default = false,
    Callback = function(Value)
        _G.LoopAllCams = Value
        if Value then
            task.spawn(function()
                while _G.LoopAllCams do
                    for i = 1, 3 do
                        local camObject = CamerasFolder:FindFirstChild(tostring(i))
                        if camObject then
                            firesignal(FlashEvent.OnClientEvent, LocalPlayer, 0.0001, camObject)
                        end
                    end
                    task.wait(0.1) 
                end
            end)
        end
    end
})



