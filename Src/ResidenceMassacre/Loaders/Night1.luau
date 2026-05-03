local Window = shared.Window
local Library = shared.Library

print("Night1.luau has successfully loaded!")

local MainTab = Window:AddTab({
    Name = "Night 1",
    Description = "Main features for Night 1",
    Icon = "moon"
})

local TestSection = MainTab:AddLeftGroupbox("Testing")

TestSection:AddLabel("Night 1 Script Active")

TestSection:AddButton({
    Text = "Test Notification",
    Func = function()
        shared.Notify("The Night 1 loader is working perfectly!")
    end
})

TestSection:AddToggle("TestToggle", {
    Text = "Debug Console Print",
    Default = false,
    Callback = function(Value)
        print("Test Toggle is now:", Value)
    end
})

shared.Notify("Night 1 logic initialized!")
shared.Load("Tabs", "Player")


