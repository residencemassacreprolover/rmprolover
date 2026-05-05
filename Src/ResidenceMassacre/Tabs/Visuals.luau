local Window = shared.Window
local Library = shared.Library
local Toggles = shared.Toggles
local Options = shared.Options

local VisualsTab = Window:AddTab({
    Name = "Visuals",
    Icon = "eye"
})

local EspGB = VisualsTab:AddRightGroupbox("ESP")

-- Initialize as fallback
shared.ESPEnabled = shared.ESPEnabled or false
shared.ESPCategories = shared.ESPCategories or {
    Mutant = false,
    Zombie = false,
    Items = false,
    Objectives = false,
    Player = false
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
    { Text = "Mutant ESP", Key = "Mutant", Default = false },
    { Text = "Zombie ESP", Key = "Zombie", Default = false },
    { Text = "Items ESP", Key = "Items", Default = false },
    { Text = "Objectives ESP", Key = "Objectives", Default = false },
    { Text = "Player ESP", Key = "Player", Default = false },
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


local Lighting = game:GetService("Lighting")
local WorldGB = VisualsTab:AddLeftGroupbox("World")

local FB = WorldGB:AddToggle("Fullbright", { Text = "FullBright", Default = false, Tooltip = "Its, Full Bright.." })
local NF = WorldGB:AddToggle("NoFog", { Text = "No Fog", Default = false, Tooltip = "No Fog" })
local AL = WorldGB:AddToggle("AntiLag", { Text = "Anti-Lag", Default = false, Tooltip = "PotatoMan" })

WorldGB:AddToggle("DebugOverlay", {
    Text = "Debug Overlay",
    Default = false,
    Callback = function(Value)
        _G.DebugMenuEnabled = Value
    end
})


local LastBrightness = Lighting.Brightness
local LastShadows = Lighting.GlobalShadows
local LastAmbient = Lighting.OutdoorAmbient
local LastExposure = Lighting.ExposureCompensation

local brightnessConn, shadowsConn, ambientConn, exposureConn

FB:OnChanged(function()
    local value = FB.Value
    if value then
        LastBrightness = Lighting.Brightness
        LastShadows = Lighting.GlobalShadows
        LastAmbient = Lighting.OutdoorAmbient
        LastExposure = Lighting.ExposureCompensation

        local function Apply()
            Lighting.Brightness = 3
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            Lighting.ExposureCompensation = 1
        end

        Apply()

        brightnessConn = Lighting:GetPropertyChangedSignal("Brightness"):Connect(Apply)
        shadowsConn = Lighting:GetPropertyChangedSignal("GlobalShadows"):Connect(Apply)
        ambientConn = Lighting:GetPropertyChangedSignal("OutdoorAmbient"):Connect(Apply)
        exposureConn = Lighting:GetPropertyChangedSignal("ExposureCompensation"):Connect(Apply)
    else
        if brightnessConn then brightnessConn:Disconnect() end
        if shadowsConn then shadowsConn:Disconnect() end
        if ambientConn then ambientConn:Disconnect() end
        if exposureConn then exposureConn:Disconnect() end
        
        Lighting.Brightness = LastBrightness
        Lighting.GlobalShadows = LastShadows
        Lighting.OutdoorAmbient = LastAmbient
        Lighting.ExposureCompensation = LastExposure
    end
end)



local fogStartConn, fogEndConn
NF:OnChanged(function()
    local value = NF.Value
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


AL:OnChanged(function()
    local value = AL.Value
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
