ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('ewen:server:BreakKevlar')
AddEventHandler('ewen:server:BreakKevlar', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    SetPedArmour(GetPlayerPed(source), 0)
    MySQL.Async.execute('DELETE FROM kevlar WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        if result then
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Votre gilet par balle est cassé')
        end
    end)
end)


RegisterServerEvent('ewen:server:SetArmour')
AddEventHandler('ewen:server:SetArmour', function(type)
    TriggerClientEvent('ewen:client:SetArmour', source, type)
end)

RegisterServerEvent('ewen:server:getKevlar')
AddEventHandler('ewen:server:getKevlar', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('ewen:server:SetArmour', source, true)
    MySQL.Async.fetchAll('SELECT * FROM kevlar WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        if result[1] then
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez mis votre gilet par balle')
            SetPedArmour(GetPlayerPed(xPlayer.source), result[1].armour)
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas de gilet par balle')
        end
    end)
end)

RegisterServerEvent('ewen:server:removeKevlar')
AddEventHandler('ewen:server:removeKevlar', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local Armour = GetPedArmour(GetPlayerPed(source))
    if Armour == 0 then return end
    MySQL.Async.execute('UPDATE kevlar SET armour = @armour WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier,
        ['@armour'] = Armour
    }, function(result)
        if result then
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez enlevé votre gilet par balle')
            SetPedArmour(GetPlayerPed(xPlayer.source), 0)
        end
    end)
end)

ESX.RegisterUsableItem('kevlar', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getInventoryItem('kevlar').count > 0 then
        MySQL.Async.fetchAll('SELECT * FROM kevlar WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        }, function(result)
            if result[1] then
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez déjà un gilet par balle')
            else
                MySQL.Async.execute('INSERT INTO kevlar (identifier, armour) VALUES (@identifier, @armour)', {
                    ['@identifier'] = xPlayer.identifier,
                    ['@armour'] = 100
                }, function(result)
                    if result then
                        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez mis votre gilet par balle')
                        SetPedArmour(GetPlayerPed(xPlayer.source), 100)
                        xPlayer.removeInventoryItem('kevlar', 1)
                    end
                end)
            end
        end)
    end
end)