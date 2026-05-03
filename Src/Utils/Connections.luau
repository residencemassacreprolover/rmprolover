local Connect = {}
shared.Connections = {}

function Connect:GiveSignal(signal)
    table.insert(shared.Connections, signal)
    return signal
end

function Connect:DisconnectAll()
    for _, signal in pairs(shared.Connections) do
        if typeof(signal) == "RBXScriptConnection" and signal.Connected then
            signal:Disconnect()
        end
    end
    table.clear(shared.Connections)
end

return Connect
