local Window = shared.Window
local Library = shared.Library
shared.Load("Utils", "source") -- The mspaint library
shared.Load("Utils", "ESP")
shared.Load("Utils", "Debug")
shared.Notify("Loading.. Night 1")

shared.ESP_REGISTRY = {
    -- MUTANTS
    ["Winterhorn"] = { Category = "Mutant", Mode = "Name" },
    ["WeirdDad"] = { Category = "Mutant", Mode = "Name" },
    ["Mutant"] = { Category = "Mutant", Mode = "Name" },
    ["Intruder"] = { Category = "Mutant", Mode = "Name" },

    -- ZOMBIES 
    ["Zombie"] = { Category = "Zombie", Mode = "Name" },
    ["FrozenZombie"] = { Category = "Zombie", Mode = "Name" },
    ["FrozenBloodZombie"] = { Category = "Zombie", Mode = "Name" },
    ["BloodZombie"] = { Category = "Zombie", Mode = "Name" },

    -- ITEMS 
    ["Items"] = {
        Category = "Items",
        Mode = "Folder",
        Get = function()
            local items = {}
            local folder = workspace:FindFirstChild("ItemSpots")
            if folder then
                for _, spot in ipairs(folder:GetChildren()) do
                    for _, obj in ipairs(spot:GetChildren()) do
                        if obj:IsA("Tool") or obj.Name == "Battery" then
                            table.insert(items, obj)
                        end
                    end
                end
            end
            return items
        end
    }
}



shared.Load("Tabs", "Player")
shared.Load("Tabs", "Main")
shared.Load("Tabs", "Visuals")

