local BaseUrl = "https://raw.githubusercontent.com/residencemassacreprolover/rmprolover/testing/Src/"

return function(scriptType: "Utils" | "Tabs" | "Loaders", name: string)
    local path = ""
    
    if scriptType == "Utils" then
        path = "Utils/" .. name .. ".luau"
    elseif scriptType == "Tabs" then
        path = "ResidenceMassacre/Tabs/" .. name .. ".luau"
    elseif scriptType == "Loaders" then
        path = "ResidenceMassacre/Loaders/" .. name .. ".luau"
    end

    local success, content = pcall(function()
        return game:HttpGet(BaseUrl .. path)
    end)

    if success and content then
        local func, err = loadstring(content)
        if func then
            return func()
        else
            warn("[Loader] Syntax error in " .. name .. ": " .. tostring(err))
        end
    else
        warn("[Loader] Failed to fetch from GitHub: " .. path)
    end
end
