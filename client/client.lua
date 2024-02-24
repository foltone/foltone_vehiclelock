local timout = false
local function setTimeout(time)
    timout = true
    Citizen.SetTimeout(time, function()
        timout = false
    end)
end
local function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry("FMMC_KEY_TIP1", TextEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end

local playerLoaded = false

local newKeys = {}

Config.CallESX()

local function getClosestVehicle()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local vehicle = nil
    if IsPedInAnyVehicle(playerPed,  false) then
        vehicle = GetVehiclePedIsIn(playerPed, false)
    else
        vehicle = GetClosestVehicle(playerCoords.x, playerCoords.y, playerCoords.z, 10.0, 0, 70)
    end
    return vehicle
end

local function openCloseVehicle()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local vehicle = getClosestVehicle()
    local plate = GetVehicleNumberPlateText(vehicle)
    if vehicle ~= 0 then
        ESX.TriggerServerCallback("foltone_vehiclelock:myKey", function(gotKey)
            if gotKey then
                if GetVehicleDoorLockStatus(vehicle) == 1 then
                    SetVehicleDoorsLocked(vehicle, 2)
                    PlayVehicleDoorCloseSound(vehicle, 1)
                    SetVehicleLights(vehicle, 2)
                    Wait(200)
                    SetVehicleLights(vehicle, 0)
                    Wait(200)
                    SetVehicleLights(vehicle, 2)
                    Wait(200)
                    SetVehicleLights(vehicle, 0)
                    Wait(200)
                    SetVehicleLights(vehicle, 2)
                    Wait(200)
                    SetVehicleLights(vehicle, 0)
                    Config.Notification(_U("vehicle_locked"))
                else
                    SetVehicleDoorsLocked(vehicle, 1)
                    PlayVehicleDoorOpenSound(vehicle, 0)
                    SetVehicleLights(vehicle, 2)
                    Wait(200)
                    SetVehicleLights(vehicle, 0)
                    Wait(200)
                    SetVehicleLights(vehicle, 2)
                    Wait(200)
                    SetVehicleLights(vehicle, 0)
                    Wait(200)
                    SetVehicleLights(vehicle, 2)
                    Wait(200)
                    SetVehicleLights(vehicle, 0)
                    Config.Notification(_U("vehicle_unlocked"))
                end
            else
                Config.Notification(_U("no_key"))
            end
        end, plate)
    else
        Config.Notification(_U("no_vehicle"))
    end
end

Keys.Register(Config.key, Config.key, "Open/Close Vehicle Doors", function()
    if not timout then
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local playerPed = PlayerPedId()

        local dict = "anim@mp_player_intmenu@key_fob@"
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(0)
        end

        local propModel = GetHashKey("prop_cuff_keys_01")
        RequestModel(propModel)
        while not HasModelLoaded(propModel) do
            Wait(0)
        end
        if not IsPedInAnyVehicle(GetPlayerPed(-1), true) then 
            local prop = CreateObject(propModel, 0, 0, 0, true, true, true)
            AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 57005), 0.11, 0.03, -0.03, 90.0, 0.0, 0.0, true, true, false, true, 1, true)
            TaskPlayAnim(playerPed, dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
            Wait(500)
            openCloseVehicle()
            Wait(500)
            DeleteEntity(prop)
            ClearPedSecondaryTask(playerPed)
            setTimeout(1200)
        else
            openCloseVehicle()
            setTimeout(1000)
        end
    end
end)

local menuKeys = RageUI.CreateMenu(nil, _U("menu_subtitle"), nil, nil, "shopui_title_carmod2", "shopui_title_carmod2")
local open = false
function RageUI.PoolMenus:FoltoneKeys()
    menuKeys.Closed = function()
        FreezeEntityPosition(PlayerPedId(), false)
        open = false
    end
    menuKeys:IsVisible(function(Items)
        if #newKeys > 0 then
            for i = 1, #newKeys, 1 do
                Items:AddButton(_U("key_label", newKeys[i]), nil, { RightLabel = _U("price_label", Config.price), IsDisabled = timout }, function(onSelected)
                    if onSelected then
                        setTimeout(500)
                        ESX.TriggerServerCallback("foltone_vehiclelock:buyKey", function(bought)
                            if bought then
                                table.remove(newKeys, i)
                                Config.Notification(_U("key_bought", newKeys[i]))
                            else
                                Config.Notification(_U("no_money"))
                            end
                        end, newKeys[i])
                    end
                end)
            end
        end
    end, function()
    end)
end

CreateThread(function()
    -- while not playerLoaded do
    --     Wait(500)

    -- end
    for k, v in pairs(Config.listKeyShop) do
        local pedModel = GetHashKey(v.pedModel)
        RequestModel(pedModel)
        while not HasModelLoaded(pedModel) do
            Wait(0)
        end
        local ped = CreatePed(4, pedModel, v.position.x, v.position.y, v.position.z, v.position.w, false, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        
        TaskStartScenarioInPlace(ped, v.pedScenario, 0, true)
        
        local blip = AddBlipForCoord(v.position.x, v.position.y)
        SetBlipSprite(blip, Config.blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, Config.blip.scale)
        SetBlipColour(blip, Config.blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.blip.label)
        EndTextCommandSetBlipName(blip)
        
    end
    while true do
        local wait = 500
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        for k, v in pairs(Config.listKeyShop) do
            local distance = #(playerCoords - vector3(v.position.x, v.position.y, v.position.z))
            if distance < 1.5 and not open then
                wait = 0
                Config.DisplayHelpText(_U("press_to_open"))
                if IsControlJustReleased(0, 38) then
                    FreezeEntityPosition(playerPed, true)
                    open = true
                    ESX.TriggerServerCallback("foltone_vehiclelock:getNewKeys", function(data)
                        newKeys = data
                        RageUI.Visible(menuKeys, not RageUI.Visible(menuKeys))
                    end)
                end
            end
        end
        Wait(wait)
    end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer)
    ESX.PlayerData = xPlayer
    playerLoaded = true
end)