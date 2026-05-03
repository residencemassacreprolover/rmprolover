--// Loading Wait \\--
if not game:IsLoaded() then game.Loaded:Wait() end

--// Services \\--
local Services = require("./Utils/Services")
if Services then print("Services Required success")
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

