local Data = {
    [14896802601] = {
        ["Name"] = "Night1", 
        ["Folder"] = "ResidenceMassacre",
        ["Loader"] = "Night1" 
    }
    [16667550979] = {
        ["Name"] = "Night2", 
        ["Folder"] = "ResidenceMassacre",
        ["Loader"] = "Night2" 
    }
}

local CurrentGame = Data[game.PlaceId]

if CurrentGame then
    return CurrentGame
else
    return { ["Name"] = nil }
end
