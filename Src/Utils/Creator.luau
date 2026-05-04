local UICreator = {}

local libSuccess, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()
end)

if not libSuccess or not Library then
    warn("[Creator] Library failed to load")
    return nil
end

shared.Library = Library
shared.Options = Library.Options
shared.Toggles = Library.Toggles

function UICreator:CreateWindow()
    local Loading = Library:CreateLoading({
        Title = "RMPL",
        Icon = 95816097006870,
        TotalSteps = 5
    })

    Loading:SetMessage("Initializing...")
    Loading:SetDescription("Waiting For Residence Massacre To Load...")
    task.wait(1)

    Loading:SetCurrentStep(1)
    Loading:SetDescription("Loading The Configs...")
    task.wait(1)

    Loading:SetCurrentStep(2)
    Loading:ShowSidebarPage(true)
    Loading.Sidebar:AddLabel("Welcome, " .. game.Players.LocalPlayer.Name)
    Loading.Sidebar:AddLabel("Enjoy Your stay.")
    task.wait(1)

    Loading:SetCurrentStep(3)
    Loading:SetDescription("I LOVE RESIDENCE MASSACRE")
    task.wait(0.5)

    Loading:SetCurrentStep(4)
    Loading:SetDescription("Finalizing UI...")
    task.wait(0.5)

    Loading:SetCurrentStep(5)
    Loading:Continue()

    local Window = Library:CreateWindow({
        Title = "RMPL",
        Footer = "Test Version, Expect Bugs",
        Icon = 95816097006870,
        NotifySide = "Right",
    })

    shared.Window = Window

    local hometab = Window:AddTab({
        Name = "Home",
        Description = "Homepage for mspaint",
        Icon = "door-closed"
    })

    local account = hometab:AddLeftGroupbox("Account")

    account:AddImage("playerimg", {
        Image = "rbxassetid://135666356081915",
        Height = 200,
    })

    local playerName = game.Players.LocalPlayer.DisplayName
    account:AddLabel("Good Afternoon <b>" .. playerName .. "</b>! Welcome back to mspaint!", true)

    account:AddDivider()

    account:AddButton({
        Text = "Script Dashboard",
        Func = function() setclipboard("https://www.mspaint.cc/subscription-dashboard") end
    })

    local dc = account:AddButton({
        Text = "Main Discord",
        Func = function() setclipboard("https://discord.gg/mspaint") end
    })
    dc:AddButton({
        Text = "Support Discord",
        Func = function() setclipboard("https://mspaint.cc/support/") end
    })

    local status = hometab:AddRightTabbox("ScriptStatus")
    local status1 = status:AddTab("Script Status")

    status1:AddLabel("🟢 <font color='rgb(73, 230, 133)'>Residence Massacre</font>", true)
    status1:AddDivider()
    status1:AddLabel("You can report bugs or suggest features in the dashboard:", true)

    status1:AddButton({
        Text = "Copy Link",
        Func = function() setclipboard("https://www.mspaint.cc/subscription-dashboard") end
    })

    local status2 = status:AddTab("Key Info")
    status2:AddDivider()
    status2:AddLabel("Time Left: Lifetime", true)
    status2:AddLabel("Total Executions: nil", true)
    status2:AddLabel("Discord: nil", true)

    Library:OnUnload(function()
        if shared.Connect then
            shared.Connect:DisconnectAll()
        end
        getgenv().mspaint_loading = false
        getgenv().mspaint_loaded = false
    end)

    return Window
end

function UICreator:CreateSettingsTab()
    local SettingsTab = shared.Window:AddTab({
        Name = "Settings",
        Icon = "settings"
    })

    local MenuSection = SettingsTab:AddLeftGroupbox("Menu")
    MenuSection:AddButton({
        Text = "Unload Script",
        Func = function() Library:Unload() end
    })
end
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
    Default = "RightShift",
    NoUI = true,
    Text = "Menu keybind",
    Callback = function(Value) Library.ToggleKeybind = Options.MenuKeybind end
})


return UICreator
