local Window = shared.Window
local Library = shared.Library
local Options = shared.Options

local PlayerTab = Window:AddTab({
    Name = "Player",
    Icon = "user"
})

-- Swapped the name to Character
local CharacterGB = PlayerTab:AddLeftGroupbox("Character")

--// Infinite Oxygen
local oxygenLoopRunning = false
local oxygenThread = nil

CharacterGB:AddToggle("InfiniteOxygen", {
    Text = "Infinite Oxygen",
    Default = false,
    Callback = function(Value)
        oxygenLoopRunning = Value
        Library:Notify("Infinite Oxygen: " .. (Value and "ON" or "OFF"), 2)

        if Value then
            if oxygenThread then return end
            oxygenThread = task.spawn(function()
                while oxygenLoopRunning do
                    local char = game.Players.LocalPlayer.Character
                    local oxygen = char and char:FindFirstChild("Breath")
                    if oxygen then
                        oxygen.Value = 100
                    end
                    task.wait(0.1)
                end
                oxygenThread = nil
            end)
        end
    end
})

--// Infinite Sprint
local sprintLoopRunning = false
local sprintThread = nil

CharacterGB:AddToggle("InfiniteSprint", {
    Text = "Infinite Sprint",
    Default = false,
    Callback = function(Value)
        sprintLoopRunning = Value
        Library:Notify("Infinite Sprint: " .. (Value and "ON" or "OFF"), 2)

        if Value then
            if sprintThread then return end
            sprintThread = task.spawn(function()
                while sprintLoopRunning do
                    local char = game.Players.LocalPlayer.Character
                    local sprint = char and char:FindFirstChild("Sprint")
                    local stamina = sprint and sprint:FindFirstChild("Stam")
                    if stamina then
                        stamina.Value = 999
                    end
                    task.wait(0.1)
                end
                sprintThread = nil
            end)
        end
    end
})

--// Noclip
local noclipEnabled = false
local noclipConnection = nil

CharacterGB:AddToggle("Noclip", {
    Text = "Noclip",
    Default = false,
    Risky = true,
    Tooltip = "Only use if you have an active bypass!",
    Callback = function(Value)
        noclipEnabled = Value
        Library:Notify("Noclip: " .. (Value and "ON" or "OFF"), 2)

        if Value then
            if noclipConnection then return end
            noclipConnection = game:GetService("RunService").Heartbeat:Connect(function()
                local char = game.Players.LocalPlayer.Character
                if char and noclipEnabled then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            local char = game.Players.LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

CharacterGB:AddDivider()

--// TP Walk
local tpwalking = false
local tpwalkThread = nil

CharacterGB:AddToggle("TPWalk", {
    Text = "TP Walk",
    Default = false,
    Callback = function(Value)
        tpwalking = Value
        Library:Notify("TP Walk: " .. (Value and "ON" or "OFF"), 2)

        if Value then
            if tpwalkThread then return end
            tpwalkThread = task.spawn(function()
                local RunService = game:GetService("RunService")
                while tpwalking do
                    local char = game.Players.LocalPlayer.Character
                    local hum = char and char:FindFirstChildWhichIsA("Humanoid")
                    local delta = RunService.Heartbeat:Wait()

                    if hum and hum.MoveDirection.Magnitude > 0 then
                        local speed = Options.TPWalkSpeed.Value
                        char:TranslateBy(hum.MoveDirection * speed * delta * 10)
                    end
                end
                tpwalkThread = nil
            end)
        end
    end
})

CharacterGB:AddSlider("TPWalkSpeed", {
    Text = "TP Walk Speed",
    Default = 2,
    Min = 1,
    Max = 6,
    Rounding = 0
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local infBatteryLoop = false
local originalBatteryUI = {}

CharacterGB:AddToggle("InfBattery", {
    Text = "Infinite Flashlight",
    Default = false,
    Callback = function(Value)
        infBatteryLoop = Value
        
        local flashlightUI = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("FlashlightUI")
        local batteryText = flashlightUI and flashlightUI.Battery:FindFirstChild("BatteryText")
        
        if Value then
            if batteryText then
                originalBatteryUI.Text = batteryText.Text
                originalBatteryUI.Visible = batteryText.Visible
                originalBatteryUI.Wrapped = batteryText.TextWrapped
                originalBatteryUI.XAlign = batteryText.TextXAlignment
                
                batteryText.Visible = true
                batteryText.TextWrapped = false
                batteryText.TextXAlignment = Enum.TextXAlignment.Left
                batteryText.Text = "Infinite Battery"
            end

            task.spawn(function()
                while infBatteryLoop do
                    local char = LocalPlayer.Character
                    local flash = char and char:FindFirstChild("Flashlight")
                    
                    if flash and flash:FindFirstChild("Battery") then
                        flash.Battery.Value = 999999
                    end
                    
                    if batteryText then
                        batteryText.Text = "Infinite Battery"
                    end
                    task.wait(0.5)
                end
            end)
        else
            if batteryText and originalBatteryUI.Text then
                batteryText.Text = originalBatteryUI.Text
                batteryText.Visible = originalBatteryUI.Visible
                batteryText.TextWrapped = originalBatteryUI.Wrapped
                batteryText.TextXAlignment = originalBatteryUI.XAlign
            end
        end
    end
})


