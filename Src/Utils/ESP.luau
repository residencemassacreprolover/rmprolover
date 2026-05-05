shared.ESPEnabled = (shared.ESPEnabled ~= nil) and shared.ESPEnabled or true
shared.ESPSettings = shared.ESPSettings or { TextSize = 16, MaxDistance = 2500, Tracers = true }
shared.ESPColors = shared.ESPColors or {
    Mutant = Color3.fromRGB(255, 0, 80),
    Zombie = Color3.fromRGB(0, 255, 100),
    Items = Color3.fromRGB(0, 150, 255),
    Objectives = Color3.fromRGB(255, 200, 0),
    Player = Color3.fromRGB(255, 255, 255)
}
shared.ESPCategories = shared.ESPCategories or { Mutant = true, Zombie = true, Items = true, Objectives = true, Player = true }

-- registry now defined By Night Loader Files
shared.ESP_REGISTRY = shared.ESP_REGISTRY or {}

local ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/residencemassacreprolover/rmprolover/refs/heads/main/source.lua"))()

local ActiveESP = {}
local TrackedEntities = {}

-- Wipe function should work
shared.WipeESP = function()
    for model, inst in pairs(ActiveESP) do
        if inst.Destroy then inst.Destroy() end
    end
    ActiveESP = {}
    TrackedEntities = {}
end

local function CreateESP(model, category, customName)
    if ActiveESP[model] then return end
    
    local primary = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart") or model
    local wasInvisible = false
    if primary:IsA("BasePart") and primary.Transparency == 1 then
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
            if wasInvisible and primary:IsA("BasePart") then primary.Transparency = 1 end
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
            TrackedEntities[char] = { Category = "Player", CustomName = string.format("%s [%.1f]", player.DisplayName, hum.Health) }
            
            hum.HealthChanged:Connect(function(newHealth)
                if TrackedEntities[char] then
                    TrackedEntities[char].CustomName = string.format("%s [%.1f]", player.DisplayName, newHealth)
                end
            end)
        end
    end
    if player.Character then task.spawn(setup, player.Character) end
    player.CharacterAdded:Connect(setup)
end
local function CheckInstance(child)
    for key, data in pairs(shared.ESP_REGISTRY) do
        if type(data) == "table" and data.Mode == "Name" and child.Name == key then
            TrackedEntities[child] = { Category = data.Category, CustomName = nil }
        end
    end
end

task.spawn(function()
    while task.wait(0.4) do
        -- 1. Actively scan for Path and Folder items (No DescendantAdded required)
        for key, data in pairs(shared.ESP_REGISTRY) do
            if type(data) == "table" and type(data.Get) == "function" then
                if data.Mode == "Path" then
                    local inst = data.Get()
                    if inst and not TrackedEntities[inst] then
                        TrackedEntities[inst] = { Category = data.Category, CustomName = key }
                    end
                elseif data.Mode == "Folder" then
                    local items = data.Get()
                    if items and type(items) == "table" then
                        for _, inst in ipairs(items) do
                            if not TrackedEntities[inst] then
                                TrackedEntities[inst] = { Category = data.Category, CustomName = inst.Name }
                            end
                        end
                    end
                end
            end
        end

        -- updates
        for model, data in pairs(TrackedEntities) do
            pcall(function()
                if not model or not model.Parent then 
                    if ActiveESP[model] and ActiveESP[model].Destroy then ActiveESP[model].Destroy() end
                    ActiveESP[model] = nil
                    TrackedEntities[model] = nil
                    return 
                end

                local shouldBeVisible = shared.ESPEnabled and (data.Category and shared.ESPCategories[data.Category])

                if shouldBeVisible then
                    if not ActiveESP[model] then
                        CreateESP(model, data.Category, data.CustomName)
                    else
                        if TrackedEntities[model].Category == "Player" and ActiveESP[model].SetText then
                            ActiveESP[model].SetText(TrackedEntities[model].CustomName)
                        end
                        if ActiveESP[model].SetColor then
                            ActiveESP[model].SetColor(shared.ESPColors[data.Category])
                        end
                    end
                else
                    if ActiveESP[model] then
                        if ActiveESP[model].Destroy then ActiveESP[model].Destroy() end
                        ActiveESP[model] = nil
                    end
                end
            end)
        end
    end
end)

workspace.DescendantAdded:Connect(CheckInstance)
for _, v in ipairs(workspace:GetDescendants()) do task.spawn(CheckInstance, v) end
for _, p in ipairs(game.Players:GetPlayers()) do ApplyPlayerESP(p) end
game.Players.PlayerAdded:Connect(ApplyPlayerESP)
game.Players.PlayerRemoving:Connect(function(player) if player.Character and TrackedEntities[player.Character] then TrackedEntities[player.Character] = nil end end)

print("Ms-ESP fully init")
