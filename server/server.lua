Config.CallESX()

ESX.RegisterServerCallback("foltone_vehiclelock:myKey", function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    MySQL.Async.fetchAll("SELECT * FROM key_vehicles WHERE owner = @owner AND plate = @plate", {
        ["@owner"] = identifier,
        ["@plate"] = plate
    }, function(result)
        if result[1] then
            cb(true)
        else
            cb(false)
        end
    end)
end)

ESX.RegisterServerCallback("foltone_vehiclelock:getNewKeys", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local owner = xPlayer.getIdentifier()
    local newKeys = {}
    MySQL.Async.fetchAll("SELECT owned_vehicles.plate FROM owned_vehicles LEFT JOIN key_vehicles ON owned_vehicles.plate = key_vehicles.plate WHERE key_vehicles.owner IS NULL AND owned_vehicles.owner = @owner", {
        ["@owner"] = owner
    }, function(result)
        for i = 1, #result, 1 do
            for j = 1, #newKeys, 1 do
                if newKeys[j] == result[i].plate then
                    table.remove(newKeys, j)
                    break
                end
            end
            table.insert(newKeys, result[i].plate)
        end
        cb(newKeys)
    end)
end)

ESX.RegisterServerCallback("foltone_vehiclelock:getMyKeys", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    local myKeys = {}
    MySQL.Async.fetchAll("SELECT * FROM key_vehicles WHERE owner = @owner", {
        ["@owner"] = identifier
    }, function(result)
        for i = 1, #result, 1 do
            table.insert(myKeys, result[i])
        end
        cb(myKeys)
    end)
end)

ESX.RegisterServerCallback("foltone_vehiclelock:buyKey", function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerMoney = xPlayer.getAccount("money").money
    if playerMoney >= Config.price then
        xPlayer.removeAccountMoney("money", Config.price)
        MySQL.Async.execute("INSERT INTO key_vehicles (owner, plate) VALUES (@owner, @plate)", {
            ["@owner"] = xPlayer.getIdentifier(),
            ["@plate"] = plate
        })
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent("foltone_vehiclelock:removeKey")
AddEventHandler("foltone_vehiclelock:removeKey", function(id)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.execute("DELETE FROM key_vehicles WHERE id = @id", {
        ["@id"] = id
    })
end)

RegisterServerEvent("foltone_vehiclelock:addKey")
AddEventHandler("foltone_vehiclelock:addKey", function(target, plate)
    local xPlayer = ESX.GetPlayerFromId(target)
    MySQL.Async.execute("INSERT INTO key_vehicles (owner, plate) VALUES (@owner, @plate)", {
        ["@owner"] = xPlayer.getIdentifier(),
        ["@plate"] = plate
    })
end)

RegisterServerEvent("foltone_vehiclelock:handingKey")
AddEventHandler("foltone_vehiclelock:handingKey", function(target, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)
    MySQL.Async.execute("REPLACE INTO key_vehicles (owner, plate) VALUES (@owner, @plate)", {
        ["@owner"] = xTarget.getIdentifier(),
        ["@plate"] = plate
    })
end)

RegisterServerEvent("foltone_vehiclelock:renameKey")
AddEventHandler("foltone_vehiclelock:renameKey", function(id, label)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.execute("UPDATE key_vehicles SET label = @label WHERE id = @id", {
        ["@label"] = label,
        ["@id"] = id
    })
end)
