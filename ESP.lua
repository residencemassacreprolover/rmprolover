--// Huge Thanks To MSPAINT for lots of pre built logic!! although modified by rmprolover \\--
shared.ESPEnabled = (shared.ESPEnabled ~= nil) and shared.ESPEnabled or true
shared.ESPSettings = shared.ESPSettings or {
    TextSize = 16,
    MaxDistance = 2500,
    Tracers = true
}
shared.ESPColors = shared.ESPColors or {
    Mutant = Color3.fromRGB(255, 0, 80),
    Zombie = Color3.fromRGB(0, 255, 100),
    Items = Color3.fromRGB(0, 150, 255),
    Objectives = Color3.fromRGB(255, 200, 0),
    Player = Color3.fromRGB(255, 255, 255)
}
shared.ESPCategories = shared.ESPCategories or {
    Mutant = true,
    Zombie = true,
    Items = true,
    Objectives = true,
    Player = true
}

local ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/residencemassacreprolover/rmprolover/refs/heads/main/source.lua"))()
local ActiveESP = {}
local ESP_REGISTRY = {
    ["Winterhorn"] = "Mutant", ["WeirdDad"] = "Mutant", ["Mutant"] = "Mutant", ["Intruder"] = "Mutant",
    ["Zombie"] = "Zombie", ["FrozenZombie"] = "Zombie", ["FrozenBloodZombie"] = "Zombie", ["BloodZombie"] = "Zombie",
    ["Generator"] = "Objectives"
}

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

local function ApplyPlayerESP(player)
    if player == game.Players.LocalPlayer then return end
    local function setup(char)
        task.wait(0.1)
        local hum = char:WaitForChild("Humanoid", 5)
        if hum then
            CreateESP(char, "Player", string.format("%s [%.1f]", player.DisplayName, hum.Health))
            hum.HealthChanged:Connect(function(newHealth)
                if ActiveESP[char] then
                    pcall(function() ActiveESP[char].SetText(string.format("%s [%.1f]", player.DisplayName, newHealth)) end)
                end
            end)
        end
    end
    if player.Character then task.spawn(setup, player.Character) end
    player.CharacterAdded:Connect(setup)
end

local function CheckInstance(child)
    if child.Name == "Model" then task.wait(0.1) end
    local category = ESP_REGISTRY[child.Name]
    if category then CreateESP(child, category) end
end

task.spawn(function()
    while task.wait(0.4) do
        for model, esp in pairs(ActiveESP) do
            pcall(function()
                if not model or not model.Parent or not model.PrimaryPart then 
                    if esp.Destroy then esp.Destroy() end
                    ActiveESP[model] = nil
                    return 
                end

                local player = game.Players:GetPlayerFromCharacter(model)
                local category = ESP_REGISTRY[model.Name] or (player and "Player")
                
                -- The single source of truth , quelle suprise.
                local shouldBeVisible = shared.ESPEnabled and (category and shared.ESPCategories[category])

                esp.SetVisible(shouldBeVisible)

                -- Brute-force turn off the library's lines and arrows bc idfk how it works bro
                if esp.Tracer then esp.Tracer.Enabled = shouldBeVisible and shared.ESPSettings.Tracers end
                if esp.Arrow then esp.Arrow.Enabled = shouldBeVisible end
                if shouldBeVisible then
                    esp.SetColor(shared.ESPColors[category])
                end
            end)
        end
    end
end)

workspace.ChildAdded:Connect(CheckInstance)
for _, v in ipairs(workspace:GetChildren()) do task.spawn(CheckInstance, v) end
for _, p in ipairs(game.Players:GetPlayers()) do ApplyPlayerESP(p) end
game.Players.PlayerAdded:Connect(ApplyPlayerESP)

print("Ms-ESP fully init")
