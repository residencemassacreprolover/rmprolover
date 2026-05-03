if getgenv().mspaint_loading then print("[mspaint] Loading stopped. (ERROR: Loading)"); return end
if getgenv().mspaint_loaded then print("[mspaint] Loading stopped. (ERROR: Already loaded)"); return end

getgenv().mspaint_loading = true

if not game:IsLoaded() then game.Loaded:Wait() end

shared.Services = loadstring(game:HttpGet("https://raw.githubusercontent.com/residencemassacreprolover/rmprolover/testing/Src/Utils/Services.luau"))()

shared.Services:GetServices({
    "Players",
    "UserInputService",
    "TextChatService",
    "ProximityPromptService",
    "PathfindingService",
    "CoreGui",
    "StarterGui",
    "Workspace",
    "Lighting",
    "ReplicatedStorage",
    "HttpService",
    "RunService",
    "SoundService",
    "TeleportService",
    "TweenService",
    "MarketplaceService"
})

shared.Load = loadstring(game:HttpGet("https://raw.githubusercontent.com/residencemassacreprolover/rmprolover/testing/Src/Utils/Loader.luau"))()

shared.Mapping = shared.Load("Utils", "Mappings")
shared.Connect = shared.Load("Utils", "Connections")

local UICreator = shared.Load("Utils", "Creator")
local Window = UICreator:CreateWindow()

shared.Notify = function(text, duration)
    shared.Library:Notify(text, duration or 5)
end

if shared.Mapping and shared.Mapping.Name then
    local success, err = pcall(function()
        shared.Load("Loaders", shared.Mapping.Name)
    end)
    
    if not success then
        shared.Notify("No script found for " .. shared.Mapping.Name, 10)
    end
else
    shared.Notify("Game mode not recognized.", 10)
end

UICreator:CreateSettingsTab()

getgenv().mspaint_loading = false
getgenv().mspaint_loaded = true

shared.Notify("RMPL is Loaded")
