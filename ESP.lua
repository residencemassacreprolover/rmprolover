--// Huge Thanks To MSPAINT for lots of pre built logic!! although modified by rmprolover \\--
shared.ESPEnabled = true
shared.ESPSettings = {
    TextSize = 16,
    MaxDistance = 2500,
    Tracers = true
}

shared.ESPColors = {
    Mutant = Color3.fromRGB(255, 0, 80),
    Zombie = Color3.fromRGB(0, 255, 100),
    Items = Color3.fromRGB(0, 150, 255),
    Objectives = Color3.fromRGB(255, 200, 0),
    Player = Color3.fromRGB(255, 255, 255) -- Fixed from 1,1,1 to White
}

shared.ESPCategories = {
    Mutant = true,
    Zombie = true,
    Items = true,
    Objectives = true,
    Player = true
}

local ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/MS-ESP/refs/heads/main/source.lua"))()
local ActiveESP = {} 

--// The Registry \\--
local ESP_REGISTRY = {
    ["Winterhorn"] = "Mutant", ["WeirdDad"] = "Mutant", ["Mutant"] = "Mutant", ["Intruder"] = "Mutant",
    ["Zombie"] = "Zombie", ["FrozenZombie"] = "Zombie", ["FrozenBloodZombie"] = "Zombie", ["BloodZombie"] = "Zombie",
}

--// Core ESP Functions\\--
local function CreateESP(model, category, customName)
    if ActiveESP[model] then return end 

    local primary = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
    local wasInvisible = false
    if primary and primary.Transparency == 1 then
        wasInvisible = true
        primary.Transparency = 0.99
    end

    local displayName = customName or ((category == "Mutant") and ("MUTANT: " .. model.Name) or model.Name:upper())

    local instance = ESPLibrary.ESP.Highlight({
        Name = displayName,
        Model = model,
        MaxDistance = shared.ESPSettings.MaxDistance,
        FillColor = shared.ESPColors[category] or Color3.new(1,1,1),
        OutlineColor = shared.ESPColors[category] or Color3.new(1,1,1),
        TextColor = shared.ESPColors[category] or Color3.new(1,1,1),
        
        TextSize = shared.ESPSettings.TextSize,
        FillTransparency = 0.5,
        OutlineTransparency = 0,
        
        Tracer = { Enabled = shared.ESPSettings.Tracers, From = "Bottom", Color = shared.ESPColors[category] },
        Arrow = { Enabled = true, CenterOffset = 300, Color = shared.ESPColors[category] },
        
        OnDestroy = function()
            if wasInvisible and primary then primary.Transparency = 1 end
            ActiveESP[model] = nil
        end
    })

    ActiveESP[model] = instance
end

--// playeresp from mspaint \\--
local function ApplyPlayerESP(player)
    if player == game.Players.LocalPlayer then return end
    
    local function setup(char)
        task.wait(0.1)
        local hum = char:WaitForChild("Humanoid", 5)
        if hum then
            CreateESP(char, "Player", string.format("%s [%.1f]", player.DisplayName, hum.Health))
            
            -- Health Update Connection
            hum.HealthChanged:Connect(function(newHealth)
                if ActiveESP[char] then
                    ActiveESP[char].SetText(string.format("%s [%.1f]", player.DisplayName, newHealth))
                end
            end)
        end
    end
    
    if player.Character then task.spawn(setup, player.Character) end
    player.CharacterAdded:Connect(setup)
end

--// Checks and Loops \\--
local function CheckInstance(child)
    if child.Name == "Model" then task.wait(0.1) end
    local category = ESP_REGISTRY[child.Name]
    if category then CreateESP(child, category) end
end

task.spawn(function()
    while task.wait(0.5) do
        for model, esp in pairs(ActiveESP) do
            local category = ESP_REGISTRY[model.Name] or (game.Players:GetPlayerFromCharacter(model) and "Player")
            
            if shared.ESPEnabled and category and shared.ESPCategories[category] then
                esp.SetVisible(true)
                esp.SetColor(shared.ESPColors[category])
            else
                esp.SetVisible(false)
            end
        end
    end
end)

--// Initialize Everything \\--
workspace.ChildAdded:Connect(CheckInstance)
for _, v in ipairs(workspace:GetChildren()) do task.spawn(CheckInstance, v) end

-- Initialize Players !!
for _, p in ipairs(game.Players:GetPlayers()) do ApplyPlayerESP(p) end
game.Players.PlayerAdded:Connect(ApplyPlayerESP)

print("Ms-ESP fully initialized")
