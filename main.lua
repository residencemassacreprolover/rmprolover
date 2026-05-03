-- RESIDENCE MASSACRE SCRIPT third TEST
-- BY RMPROLOVER
-- SPECIAL CREDITS TO: MSPAINT


-- starts the libarary, obsidian UI + ESP
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/residencemassacreprolover/rmprolover/refs/heads/main/ESP.lua"))()
local Options = Library.Options
local Toggles = Library.Toggles
-- Loading Screen
local Loading = Library:CreateLoading({
    Title = "Residence Massacre Paint-d",
    Icon = 95816097006870,
    TotalSteps = 6
})
 
-- Loading...
Loading:SetMessage("Initializing...")
Loading:SetDescription("Waiting For Residence Massacre To Load...")
task.wait(1)
 
Loading:SetCurrentStep(1)
Loading:SetDescription("Loading The Configs...")
task.wait(1)
 
-- Show sidebar with information
Loading:SetCurrentStep(2)
Loading:ShowSidebarPage(true)
Loading.Sidebar:AddLabel("Welcome, " .. game.Players.LocalPlayer.Name)
Loading.Sidebar:AddLabel("Enjoy Your stay.")
task.wait(2)
 
Loading:SetCurrentStep(3)
Loading:SetDescription("the end is never the end is never the end is never the end is never the end")
task.wait(0.5)
 
Loading:SetCurrentStep(4)
Loading:ShowSidebarPage(true)
Loading:Continue() -- Destroys the loader and opens the main window




local Window = Library:CreateWindow({
    Title = "Residence Massacre",
    Footer = "version: example",
    Icon = 95816097006870,
    NotifySide = "Right",
})


local maintab = Window:AddTab({
    Name = "Main",
    Description = "Main features",
    Icon = "house"
})

-- Bypasses
local bypassGB = maintab:AddLeftGroupbox("Bypass", "wrench")

--- Bypass anti cheat
local function generateRandomName()
    local length = math.random(20, 35)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local result = ""
    for i = 1, length do
        local randomIndex = math.random(1, #chars)
        result = result .. string.sub(chars, randomIndex, randomIndex)
    end
    return result
end

-- vars
local replicatedStorage = game:GetService("ReplicatedStorage")
local gameState = replicatedStorage:WaitForChild("GameState", 5)
local remotes = replicatedStorage:FindFirstChild("Remotes")
local bypassUsed = false

local blizzard = gameState and gameState:FindFirstChild("Blizzard")

bypassGB:AddButton("Bypass Anticheat", function()
    if bypassUsed then
        Library:Notify({
            Title = "Hold up",
            Description = "Anticheat bypass already used!",
            Duration = 2,
        })
        return
    end

    local success, err = pcall(function()
        local kickRemote = nil

        if remotes then
            kickRemote = remotes:FindFirstChild("Kick")
        end

        if not kickRemote then
            kickRemote = replicatedStorage:FindFirstChild("Kick")
        end

        if not kickRemote then
            Library:Notify({
                Title = "Uh Oh!",
                Description = "Couldn't find 'Kick' remote",
                Duration = 3,
            })
            return
        end

        kickRemote.Name = generateRandomName()
        bypassUsed = true

        Library:Notify({
            Title = "Success",
            Description = "Anticheat bypassed",
            Duration = 2,
        })
    end)

    if not success then
        Library:Notify({
            Title = "Error",
            Description = tostring(err),
            Duration = 4,
        })
    end
end)

local blizzardtoggle = bypassGB:AddToggle("DisableBlizzardToggle", {
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

local oxygenLoopRunning = false
local oxygenThread = nil

local oxygentoggle = bypassGB:AddToggle("InfiniteOxygen", {
    Text = "Infinite Oxygen",
    Default = false,

    Callback = function(Value)
        oxygenLoopRunning = Value

        Library:Notify({
            Title = "Infinite Oxygen",
            Description = Value and "Is Now On" or "Is Now Off",
            Duration = 2
        })

        if Value then
            if oxygenThread then return end

            oxygenThread = task.spawn(function()
                local player = game.Players.LocalPlayer

                while oxygenLoopRunning do
                    task.wait(0.1)

                    player = game.Players.LocalPlayer
                    if player and player.Character then
                        local oxygen = player.Character:FindFirstChild("Breath")
                        if oxygen then
                            oxygen.Value = 100
                        end
                    end
                end

                oxygenThread = nil
            end)
        else
            oxygenLoopRunning = false
        end
    end
})

local sprintLoopRunning = false
local sprintThread = nil

local sprintToggle = bypassGB:AddToggle("InfiniteSprint", {
    Text = "Infinite Sprint",
    Default = false,
    Callback = function(Value)
    sprintLoopRunning = Value

    Library:Notify({
        Title = "Infinity sprint",
        Description = Value and "Is Now On" or "Is Now Off",
        Duration = 2
    })

    if Value then
        if sprintThread then return end

        sprintThread = task.spawn(function()
            local player = game.Players.LocalPlayer

            while sprintLoopRunning do
                task.wait(0.1)

                player = game.Players.LocalPlayer
                if player and player.Character then
                    local sprint = player.Character:FindFirstChild("Sprint")
                    if sprint then
                        local stamina = sprint:FindFirstChild("Stam")
                        if stamina then
                            stamina.Value = 999
                        end
                    end
                end
            end

            sprintThread = nil
        end)
    else
    sprintLoopRunning = false
    sprintThread = nil
    end
end    
})

local noclipEnabled = false
local noclipConnection = nil

local noclipToggle = bypassGB:AddToggle("Noclip", {
    Text = "Noclip",
    Default = false,
    Risky = true,
    Tooltip = "Only Use With 'Bypass Anticheat', Could Cause you to get kicked!",

    Callback = function(Value)
        noclipEnabled = Value

        Library:Notify({
            Title = "Noclip",
            Description = Value and "Is Now On" or "Is Now Off",
            Duration = 2
        })

        if Value then
            if noclipConnection then return end

            local RunService = game:GetService("RunService")

            noclipConnection = RunService.Heartbeat:Connect(function()
                if not noclipEnabled then return end

                local player = game.Players.LocalPlayer
                local character = player.Character

                if character then
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)

        else
            noclipEnabled = false

            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end

            local player = game.Players.LocalPlayer
            local character = player.Character

            if character then
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

local tpwalking = false
local tpwalkThread = nil
local tpwalkSpeed = 2

local tpwalkToggle = bypassGB:AddToggle("TPWalk", {
    Text = "TP Walk",
    Default = false,

    Callback = function(Value)
        tpwalking = Value

        Library:Notify({
            Title = "TP Walk",
            Description = Value and "Is Now On" or "Is Now Off",
            Duration = 2
        })

        if Value then
            if tpwalkThread then return end

            tpwalkThread = task.spawn(function()
                local player = game.Players.LocalPlayer
                local RunService = game:GetService("RunService")

                while tpwalking do
                    local char = player.Character
                    local hum = char and char:FindFirstChildWhichIsA("Humanoid")

                    if not hum or not hum.Parent then
                        break
                    end

                    local delta = RunService.Heartbeat:Wait()

                    if hum.MoveDirection.Magnitude > 0 then
                        char:TranslateBy(hum.MoveDirection * Options.TPWalkSpeed.Value * delta * 10)
                    end

                    if player.Character ~= char then
                        break
                    end
                end

                tpwalkThread = nil
                tpwalking = false
            end)

        else
            tpwalking = false
            tpwalkThread = nil
        end
    end
})


bypassGB:AddSlider("TPWalkSpeed", {
    Text = "TP Walk Speed",
    Default = 2,
    Min = 1,
    Max = 6,
    Rounding = 0
})


local EspGB = maintab:AddRightGroupbox("ESP", "wrench")


shared.ESPEnabled = false
shared.ESPCategories = {
    Mutant = true,
    Zombie = false,
    Items = false,
    Objectives = false,
    Player = true
}


local enableESP = EspGB:AddToggle("EnableESP", {
    Text = "Enable ESP",
    Default = false,
    Callback = function(Value)
        shared.ESPEnabled = Value
    end
})

local enableMutantESP = EspGB:AddToggle("MutantESP", { 
    Text = "Mutant ESP",
    Default = true,
    Callback = function(Value)
        shared.ESPCategories.Mutant = Value
    end
})

local enableZombieESP = EspGB:AddToggle("ZombieESP", {
    Text = "Zombie ESP",
    Default = false,
    Callback = function(Value)
        shared.ESPCategories.Zombie = Value
    end
})

local enableItemsESP = EspGB:AddToggle("ItemsESP", {
    Text = "Items ESP",
    Default = false,
    Callback = function(Value)
        shared.ESPCategories.Items = Value
    end
})

local enableObjectivesESP = EspGB:AddToggle("ObjectivesESP", {
    Text = "Objectives ESP",
    Default = false,
    Callback = function(Value)
        shared.ESPCategories.Objectives = Value
    end
})

local enablePlayerESP = EspGB:AddToggle("PlayerESP", {
    Text = "Player ESP",
    Default = true,
    Callback = function(Value)
        shared.ESPCategories.Player = Value
    end
})


local Lighting = shared.Lighting
local LastBrightness = Lighting.Brightness
local LastShadows = Lighting.GlobalShadows
local brightnessConn, shadowsConn, fogStartConn, fogEndConn

EspGB:AddToggle("Fullbright", {
    Text = "FullBright",
    Default = false,
    Tooltip = "Yo its fb"
})

EspGB:AddToggle("NoFog", {
    Text = "No Fog",
    Default = false,
    Tooltip = "Yo its fb"
})

EspGB:AddToggle("AntiLag", {
    Text = "AntiLag",
    Default = false,
    Tooltip = "Yo its fb"
})

Toggles.Fullbright:OnChanged(function(value)
    if value then
        LastBrightness = Lighting.Brightness
        LastShadows = Lighting.GlobalShadows
        Lighting.Brightness = 2
        Lighting.GlobalShadows = false
        
        brightnessConn = Lighting:GetPropertyChangedSignal("Brightness"):Connect(function()
            if Lighting.Brightness ~= 2 then Lighting.Brightness = 2 end
        end)
        
        shadowsConn = Lighting:GetPropertyChangedSignal("GlobalShadows"):Connect(function()
            if Lighting.GlobalShadows ~= false then Lighting.GlobalShadows = false end
        end)
    else
        if brightnessConn then brightnessConn:Disconnect() end
        if shadowsConn then shadowsConn:Disconnect() end
        Lighting.Brightness = LastBrightness
        Lighting.GlobalShadows = LastShadows
    end
end)

Toggles.NoFog:OnChanged(function(value)
    local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
    if value then
        if not Lighting:GetAttribute("OrigFogStart") then Lighting:SetAttribute("OrigFogStart", Lighting.FogStart) end
        if not Lighting:GetAttribute("OrigFogEnd") then Lighting:SetAttribute("OrigFogEnd", Lighting.FogEnd) end
        
        Lighting.FogStart = 0
        Lighting.FogEnd = math.huge
        if atmosphere then atmosphere.Density = 0 end

        fogStartConn = Lighting:GetPropertyChangedSignal("FogStart"):Connect(function()
            if Lighting.FogStart ~= 0 then Lighting.FogStart = 0 end
        end)
        
        fogEndConn = Lighting:GetPropertyChangedSignal("FogEnd"):Connect(function()
            if Lighting.FogEnd ~= math.huge then Lighting.FogEnd = math.huge end
        end)
    else
        if fogStartConn then fogStartConn:Disconnect() end
        if fogEndConn then fogEndConn:Disconnect() end
        Lighting.FogStart = Lighting:GetAttribute("OrigFogStart") or 0
        Lighting.FogEnd = Lighting:GetAttribute("OrigFogEnd") or 100000
        if atmosphere then atmosphere.Density = 0.395 end
    end
end)

Toggles.AntiLag:OnChanged(function(value)
    for _, object in pairs(workspace:GetDescendants()) do
        if object:IsA("BasePart") then
            if value then
                if not object:GetAttribute("OrigMat") then object:SetAttribute("OrigMat", object.Material.Name) end
                object.Material = Enum.Material.Plastic
                object.Reflectance = 0
            else
                object.Material = Enum.Material[object:GetAttribute("OrigMat") or "Plastic"]
            end
        elseif object:IsA("Decal") or object:IsA("Texture") then
            object.Transparency = value and 1 or 0
        end
    end
    
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        terrain.WaterReflectance = value and 0 or 1
        terrain.WaterWaveSize = value and 0 or 0.05
    end
end)


EspGB:AddToggle("DebugOverlay", {
    Text = "Debug Overlay",
    Default = true,
    Tooltip = "Yo its fb",
    Callback = function(Value)
        _G.DebugMenuEnabled = Value
    end
})
