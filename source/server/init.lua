ESX = exports['es_extended']:getSharedObject()
local key = 'errorism_time'
local startTime = {}

AddEventHandler('onResourceStart', function(resourceName)
    if not (GetCurrentResourceName() == resourceName) then return end
    local xPlayers = ESX.GetExtendedPlayers()
    for i=1,#(xPlayers) do
        local xPlayer = xPlayers[i]
        local identifier = xPlayer.getIdentifier()
        startTime[identifier] = {}
        startTime[identifier].online = GetGameTimer()
    end
end)

function Ready(identifier)
    while not startTime?[identifier]?.online do
        Wait(500)
    end
end

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    local identifier = xPlayer.identifier
    startTime[identifier] = {}
    startTime[identifier].online = GetGameTimer()
end)

AddEventHandler('playerDropped', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    local identifier = xPlayer.getIdentifier()
    TriggerEvent('esx_datastore:getDataStore', key, identifier, function(store)
        store.set('online', (store.get('online') or 0) + getCurrent('online',identifier))
    end)
    startTime[identifier] = nil
end)

function getCurrent(index,identifier)
    local startAt = startTime[identifier][index] or 0
    return (GetGameTimer() - startAt)
end
exports('getCurrent', getCurrent)

function get(index,identifier,onDatabase)
    if not onDatabase then
        return getCurrent(index,identifier)
    end
    local p = promise.new()
    TriggerEvent('esx_datastore:getDataStore', key, identifier, function(store)
        p:resolve((store.get(index) or 0) + getCurrent(index,identifier))
    end)
    return Citizen.Await(p)
end
exports('get', get)

function start(index,identifier)
    Ready(identifier)
    if index == 'online' then return end
    startTime[identifier][index] = GetGameTimer()
    return start
end
exports('start', start)

function stop(index,identifier,save)
    Ready(identifier)
    if index == 'online' then return end
    local resultTime = get(index,identifier,save)
    if save then
        TriggerEvent('esx_datastore:getDataStore', key, identifier, function(store)
            store.set(index, resultTime)
        end)
    end
    startTime[identifier][index] = nil
    return resultTime
end
exports('stop', stop)
