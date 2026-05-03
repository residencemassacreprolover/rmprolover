if getgenv().mspaint_loading then print("[mspaint] Loading stopped. (ERROR: Loading)"); return end
if getgenv().mspaint_loaded then print("[mspaint] Loading stopped. (ERROR: Already loaded)"); return end

getgenv().mspaint_loading = true

--// Loading Wait \\--
if not game:IsLoaded() then game.Loaded:Wait() end

--// Services \\--
local Services = require("Utils/Services")
Services:GetServices({
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


loadstring(game:HttpGet("https://raw.githubusercontent.com/residencemassacreprolover/rmprolover/refs/heads/main/main.lua"))()

getgenv().mspaint_loaded = true
getgenv().mspaint_loading = false
