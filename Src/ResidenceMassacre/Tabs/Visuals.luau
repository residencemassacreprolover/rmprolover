local Window = shared.Window
local Library = shared.Library

local VisualsTab = Window:AddTab({
    Name = "Visuals",
    Icon = "eye"
})

local EspGB = VisualsTab:AddRightGroupbox("ESP")

-- Initialize as fallback
shared.ESPEnabled = shared.ESPEnabled or false
shared.ESPCategories = shared.ESPCategories or {
    Mutant = true,
    Zombie = false,
    Items = false,
    Objectives = false,
    Player = true
}

--// toggle masterswitc
EspGB:AddToggle("EnableESP", {
    Text = "Enable ESP",
    Default = false,
    Callback = function(Value)
        shared.ESPEnabled = Value
        Library:Notify("ESP " .. (Value and "Enabled" or "Disabled"), 2)
    end
})

EspGB:AddDivider()

--// toggling loops bc its easier can't lie brochacho
local Categories = {
    { Text = "Mutant ESP", Key = "Mutant", Default = true },
    { Text = "Zombie ESP", Key = "Zombie", Default = false },
    { Text = "Items ESP", Key = "Items", Default = false },
    { Text = "Objectives ESP", Key = "Objectives", Default = false },
    { Text = "Player ESP", Key = "Player", Default = true },
}

for _, cat in ipairs(Categories) do
    EspGB:AddToggle(cat.Key .. "ESP", {
        Text = cat.Text,
        Default = cat.Default,
        Callback = function(Value)
            shared.ESPCategories[cat.Key] = Value
        end
    })
end

