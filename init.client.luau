if getgenv().mspaint_loading then return end
if getgenv().mspaint_loaded then return end
getgenv().mspaint_loading = true

if not game:IsLoaded() then game.Loaded:Wait() end

--// Force fetch the Services module and put it in the GLOBAL environment
local url = "https://raw.githubusercontent.com/residencemassacreprolover/rmprolover/refs/heads/main/Utils/Services.luau?t=" .. tick()
local success, result = pcall(function()
    return loadstring(game:HttpGet(url))()
end)

if success and result then
    getgenv().Services = result -- ??
    getgenv().Services:GetServices({
        "Players", "UserInputService", "TextChatService", "ProximityPromptService",
        "PathfindingService", "CoreGui", "StarterGui", "Workspace", "Lighting",
        "ReplicatedStorage", "HttpService", "RunService", "SoundService",
        "TeleportService", "TweenService", "MarketplaceService"
    })
    print("Services Initialized")
else
    warn("Failed to initialize Services: " .. tostring(result))
    getgenv().mspaint_loading = false
    return
end

--// Load the main script
loadstring(game:HttpGet("https://raw.githubusercontent.com/residencemassacreprolover/rmprolover/refs/heads/main/Utils/DebugOverlay.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/residencemassacreprolover/rmprolover/refs/heads/main/main.lua"))()

getgenv().mspaint_loaded = true
getgenv().mspaint_loading = false
