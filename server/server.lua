ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'unicorn', 'alerte unicorn', true, true)
TriggerEvent('esx_society:registerSociety', 'unicorn', 'unicorn', 'society_unicorn', 'society_unicorn', 'society_unicorn', {type = 'public'})

RegisterServerEvent('unicorn:ouvert')
AddEventHandler('unicorn:ouvert', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], "Unicorn Club", "Annonce", "Le Unicorn Club est désormais ~g~Ouvert ~s~!", "CHAR_MP_STRIPCLUB_PR", 5)
    end
end)

RegisterServerEvent('unicorn:ferme')
AddEventHandler('unicorn:ferme', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], "Unicorn Club", "Annonce", "Le Unicorn Club est désormais ~r~Fermé ~s~!", "CHAR_MP_STRIPCLUB_PR", 5)
	end
end) 

RegisterServerEvent('unicorn:perso')
AddEventHandler('unicorn:perso', function(notif)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], "Unicorn Club", "Annonce", notif, "CHAR_MP_STRIPCLUB_PR", 5)
    end
end)

ESX.RegisterServerCallback('unicorn:playerinventory', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local items = xPlayer.inventory
    local all_items = {}
    for k,v in pairs(items) do
        if v.count > 0 then
            table.insert(all_items, {label = v.label, item = v.name, nb = v.count})
        end
    end
    cb(all_items)
end)

ESX.RegisterServerCallback('unicorn:getStockItems', function(source, cb)
    local all_items = {}
    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_unicorn', function(inventory)
        for k,v in pairs(inventory.items) do
            if v.count > 0 then
                table.insert(all_items, {label = v.label,item = v.name, nb = v.count})
            end
        end
    end)
    cb(all_items)
end)

RegisterServerEvent('unicorn:putStockItems')
AddEventHandler('unicorn:putStockItems', function(itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item_in_inventory = xPlayer.getInventoryItem(itemName).count
    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_unicorn', function(inventory)
        if item_in_inventory >= count and count > 0 then
            xPlayer.removeInventoryItem(itemName, count)
            inventory.addItem(itemName, count)
            TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez déposé "..Config.Color.." "..count.." "..itemName.." ~s~dans le coffre de la société")
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Vous n'en avez pas assez sur vous")
        end
    end)
end)

RegisterServerEvent('unicorn:takeStockItems')
AddEventHandler('unicorn:takeStockItems', function(itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_unicorn', function(inventory)
        xPlayer.addInventoryItem(itemName, count)
        inventory.removeItem(itemName, count)
        TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez retiré "..Config.Color..""..count.." "..itemName.." ~s~du coffre de la société")
    end)
end)

RegisterServerEvent('unicorn:preparer')
AddEventHandler('unicorn:preparer', function(name)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addInventoryItem(name, 1)
end)