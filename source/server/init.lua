ESX = exports['es_extended']:getSharedObject()
local key = 'errorism_time'
local startTime = {}

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
    if index == 'online' then return end
    if not startTime[identifier] then
        startTime[identifier] = {}
    end
    startTime[identifier][index] = GetGameTimer()
end
exports('start', start)

function stop(index,identifier,save)
    if not startTime?[identifier]?[index] then return 0 end
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