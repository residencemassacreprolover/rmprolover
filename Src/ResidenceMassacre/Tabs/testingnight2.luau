local Window = shared.Window
local Library = shared.Library
local Toggles = shared.Toggles
local Options = shared.Options

local MainTab = Window:AddTab({
    Name = "Night 2",
    Icon = "zap"
})

local AutoGB = MainTab:AddLeftGroupbox("Exploits")

local remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")

local FlashEvent = remotes:WaitForChild("FlashCam")
local CamerasFolder = workspace:WaitForChild("Cameras")
local LocalPlayer = game:GetService("Players").LocalPlayer

local selectedCamera = "1"

AutoGB:AddDropdown("CameraSelect", {
    Text = "Cameras",
    Tooltip = "Select Cameras For Flashing",
    Default = "1",
    Values = {"1", "2", "3"},
    Callback = function(Value)
        selectedCamera = Value
    end
})

AutoGB:AddButton({
    Text = "Flash Selected Camera",
    Func = function()
        local camObject = CamerasFolder:FindFirstChild(selectedCamera)
        if camObject then
            firesignal(FlashEvent.OnClientEvent, LocalPlayer, 7.5, camObject)
        else
            shared.Library:Notify("Camera not Setup!", 2)
        end
    end
})

AutoGB:AddToggle("LoopFlashAll", {
    Text = "Loop Flash ALL Cameras",
    Default = false,
    Callback = function(Value)
        _G.LoopAllCams = Value
        if Value then
            task.spawn(function()
                while _G.LoopAllCams do
                    for i = 1, 3 do
                        local camObject = CamerasFolder:FindFirstChild(tostring(i))
                        if camObject then
                            firesignal(FlashEvent.OnClientEvent, LocalPlayer, 7.5, camObject)
                        end
                    end
                    task.wait(0.1) 
                end
            end)
        end
    end
})
