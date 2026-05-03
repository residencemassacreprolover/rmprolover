local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- config
local DebugConfig = {
    RefreshRate = 0.1,
    Theme = {
        Background = Color3.fromRGB(0, 0, 0),
        Transparency = 0.6,
        TextColor = Color3.fromRGB(255, 255, 255),
    }
}

_G.DebugMenuEnabled = false 

-- util for Getting Vals without repeated code
local function getVal(parent, name)
    if not parent then return "nil" end
    local obj = parent:FindFirstChild(name)
    if obj then
        if type(obj.Value) == "number" then
            return string.format("%.1f", obj.Value)
        end
        return tostring(obj.Value)
    end
    return "nil"
end

-- stuff for Larry
local function getMutantConfig()
    local wMutant = workspace:FindFirstChild("Mutant")
    if wMutant and wMutant:FindFirstChild("Config") then return wMutant.Config end
    
    local rMutant = ReplicatedStorage:FindFirstChild("Mutant")
    if rMutant and rMutant:FindFirstChild("Config") then return rMutant.Config end
    
    return nil
end

-- Tracking Values
local GS = ReplicatedStorage:FindFirstChild("GameState")

local DataTrackers = {
    -- Game State
    {Label = "Active",       Func = function() return getVal(GS, "Active") end},
    {Label = "Ended",        Func = function() return getVal(GS, "Ended") end},
    {Label = "Fuel",         Func = function() return getVal(GS, "Fuel") end},
    {Label = "Lights On",    Func = function() return getVal(GS, "LightsOn") end},
    {Label = "Fuses Fried",  Func = function() return getVal(GS, "FusesFried") end},
    {Label = "Is Night",     Func = function() return getVal(GS, "Night") end},
    
    -- Modifiers
    {Label = "Bloodmoon",    Func = function() return getVal(GS, "Bloodmoon") end},
    {Label = "Blizzard",     Func = function() return getVal(GS, "Blizzard") end},
    {Label = "Fire Fuel",    Func = function() return getVal(GS, "FireFuel") end},
    {Label = "Event Active", Func = function() return getVal(GS, "Event") end},
    {Label = "Event Timer",  Func = function() return getVal(GS, "EventTimer") end},
    {Label = "Total Mods",   Func = function() return getVal(GS, "TotalModifiers") end},
    {Label = "Thunderstorm", Func = function() return getVal(GS, "Thunderstorm") end},
    {Label = "Zombies",      Func = function() return getVal(GS, "Zombies") end},
    {Label = "Multiversal",  Func = function() return getVal(GS, "WeirdStrict") end},
    
    -- Endless Mode
    {Label = "Discount",     Func = function() return getVal(GS, "Discount") end},
    {Label = "Is Endless",     Func = function() return getVal(GS, "Infinite") end},
    {Label = "Gas Quest",    Func = function() return getVal(GS, "GasQuest") end},
    {Label = "Money",        Func = function() return getVal(GS, "Money") end},
    {Label = "Skip Zombies", Func = function() return getVal(GS, "SkipZombies") end},

    -- Mutant
    {Label = "Is Mutant Active",     Func = function() return getVal(getMutantConfig(), "Active") end},
    {Label = "Is Mutant Wandering",  Func = function() return getVal(getMutantConfig(), "Wandering") end},
    {Label = "Is Mutant Chasing",    Func = function() return getVal(getMutantConfig(), "Chasing") end},
    {Label = "Is Mutant Dancing",      Func = function() return getVal(getMutantConfig(), "Dance") end},
}

-- Debug Menu
local DebugMenu = {}

function DebugMenu:BuildUI()
    self.Screen = Instance.new("ScreenGui", CoreGui)
    self.Screen.Name = "ResidenceMassacreF3"
    self.Screen.Enabled = _G.DebugMenuEnabled
    
    self.MainFrame = Instance.new("Frame", self.Screen)
    self.MainFrame.BackgroundColor3 = DebugConfig.Theme.Background
    self.MainFrame.BackgroundTransparency = DebugConfig.Theme.Transparency
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Position = UDim2.new(0, 10, 0, 10)
    self.MainFrame.Size = UDim2.new(0, 220, 0, 20)
    self.MainFrame.Active = true
    self.MainFrame.Draggable = true 
    
    self.Label = Instance.new("TextLabel", self.MainFrame)
    self.Label.Size = UDim2.new(1, -10, 1, -10)
    self.Label.Position = UDim2.new(0, 5, 0, 5)
    self.Label.BackgroundTransparency = 1
    self.Label.TextColor3 = DebugConfig.Theme.TextColor
    self.Label.Font = Enum.Font.Code
    self.Label.TextSize = 12 -- Smaller font for the huge list
    self.Label.TextXAlignment = Enum.TextXAlignment.Left
    self.Label.TextYAlignment = Enum.TextYAlignment.Top
    self.Label.Parent = self.MainFrame
end

function DebugMenu:Update()
    local output = "--- [ Debug Tracking Menu ] ---\n"
    for _, item in ipairs(DataTrackers) do
        local success, val = pcall(item.Func)
        output = output .. string.format("%s: %s\n", item.Label, success and tostring(val) or "!")
    end
    self.Label.Text = output
    
    -- This is Not Rounded how i would've liked but it is what it is
    -- :(
    self.MainFrame.Size = UDim2.new(0, 220, 0, (#DataTrackers + 2) * 15 + 10)
end

-- init
DebugMenu:BuildUI()

task.spawn(function()
    while true do
        if DebugMenu.Screen.Enabled ~= _G.DebugMenuEnabled then
            DebugMenu.Screen.Enabled = _G.DebugMenuEnabled
        end
        if _G.DebugMenuEnabled then
            DebugMenu:Update()
        end
        task.wait(DebugConfig.RefreshRate)
    end
end)

