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
    Objectives = Color3.fromRGB(255, 200, 0)
}

local ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/MS-ESP/refs/heads/main/source.lua"))()
local ActiveESP = {} -- cache

--// The Registry \\--
local ESP_REGISTRY = {
    -- Mutants
    ["Winterhorn"] = "Mutant", ["WeirdDad"] = "Mutant", ["Mutant"] = "Mutant", ["Intruder"] = "Mutant",
    -- Zombies
    ["Zombie"] = "Zombie", ["FrozenZombie"] = "Zombie", ["FrozenBloodZombie"] = "Zombie", ["BloodZombie"] = "Zombie",
    
    -- [[ PLACEHOLDERS - Uncomment and add names here ]]
    -- ["Medkit"] = "Items",
    -- ["BloxyCola"] = "Items",
    -- ["Generator"] = "Objectives",
}

--//main esp \\--
local function CreateESP(model, category)
    if ActiveESP[model] then return end -- trople double dip

    -- Auto-fix for invisible PrimaryParts (Rig support)
    local primary = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
    local wasInvisible = false
    if primary and primary.Transparency == 1 then
        wasInvisible = true
        primary.Transparency = 0.99
    end

    local instance = ESPLibrary.ESP.Highlight({
        Name = (category == "Mutant") and ("MUTANT: " .. model.Name) or model.Name:upper(),
        Model = model,
        MaxDistance = shared.ESPSettings.MaxDistance,
        FillColor = shared.ESPColors[category] or Color3.new(1,1,1),
        OutlineColor = shared.ESPColors[category] or Color3.new(1,1,1),
        TextColor = shared.ESPColors[category] or Color3.new(1,1,1),
        
        TextSize = shared.ESPSettings.TextSize,
        FillTransparency = 0.5,
        OutlineTransparency = 0,
        
        Tracer = { 
            Enabled = shared.ESPSettings.Tracers, 
            From = "Bottom", 
            Color = shared.ESPColors[category] 
        },
        Arrow = { 
            Enabled = true, 
            CenterOffset = 300, 
            Color = shared.ESPColors[category] 
        },
        
        OnDestroy = function()
            if wasInvisible and primary then primary.Transparency = 1 end
            ActiveESP[model] = nil
        end
    })

    ActiveESP[model] = instance
    model.AncestryChanged:Connect(function(_, parent)
        if not parent and ActiveESP[model] then
            instance.Destroy()
        end
    end)
end

--// This section was broken in The Original MSPAINT\\--
local function CheckInstance(child)
    if child.Name == "Model" then 
        task.wait(0.1) 
    end
    
    local category = ESP_REGISTRY[child.Name]
    if category and shared.ESPEnabled then
        CreateESP(child, category)
    end
end


task.spawn(function()
    while task.wait(0.5) do
        for model, esp in pairs(ActiveESP) do
            if not shared.ESPEnabled then
                esp.SetVisible(false)
            else
                esp.SetVisible(true)
                -- Dynamic Color Update shinyy
                local category = ESP_REGISTRY[model.Name]
                if category then
                    esp.SetColor(shared.ESPColors[category])
                end
            end
        end
    end
end)

-- Initialize listeners
workspace.ChildAdded:Connect(CheckInstance)
for _, v in ipairs(workspace:GetChildren()) do 
    task.spawn(CheckInstance, v) 
end

print("Ms-ESP fully intialized")
