local Window = shared.Window
local Library = shared.Library
local Toggles = shared.Toggles
local Options = shared.Options


local BadgesTab = Window:AddTab({
    Name = "Badges",
    Icon = "zap"
})

local GeneralGB = MainTab:AddLeftGroupbox("General")

--// vars
local replicatedStorage = game:GetService("ReplicatedStorage")
local gameState = replicatedStorage:WaitForChild("GameState", 5)
local remotes = replicatedStorage:FindFirstChild("Remotes")


-- Electrocuted Badge
local ClickWireRemote = remotes:WaitForChild("ClickWire")

local function clickWrongWire()
    local fuseBox = workspace:FindFirstChild("FuseBox")
    if not fuseBox then return end
    
    local wiresFolder = fuseBox:FindFirstChild("Wires")
    if not wiresFolder then return end

    for i = 1, 4 do
        local wire = wiresFolder:FindFirstChild(tostring(i))
        if wire then
            local sparkles = wire:FindFirstChild("Sparkles")
            if not sparkles or not sparkles.Enabled then
                ClickWireRemote:FireServer(wire)
                break -- Stop after clicking
            end
        end
    end
end

GeneralGB:AddButton({
    Text = "Electrocuted",
    Tooltip = "Automatically Awards you The 'Electrocuted' Badge",
    Func = function()
        fixActiveWires()
    end
})

-- Asphyxia
local AsphyxiaRemote = game:GetService("ReplicatedStorage").Remotes.Asphyxia

GeneralGB:AddButton({
    Text = "Asphyxia",
    Risky = true,
    Tooltip = "Automatically Awards you The 'Asphyxia' Badge/n WILL KILL YOU",
    Func = function()
        AsphyxiaRemote:FireServer()
    end
})
