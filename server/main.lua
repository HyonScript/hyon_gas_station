GasStations = {}


MySQL.ready(function()
    local database = MySQL.Sync.fetchAll('SELECT * FROM gas_stations')
    for k, v in pairs(database) do
        local id = v.id
        local identifier = v.owner
		local level = v.level
		local fuel_price = v.fuel_price
        local capacity = v.capacity
		local max_capacity = v.max_capacity
        local price = v.price
        local balance = v.balance
		local petrol_can_price = v.petrol_can_price
		local petrol_can_stock = v.petrol_can_stock
		local petrol_can_max_stock = v.petrol_can_max_stock
        GasStations[id] = {
            id = id,
            owner = identifier,
			level = level,
			fuel_price = fuel_price,
            capacity = capacity,
			max_capacity = max_capacity,
            price = price,
            balance = balance,
			petrol_can_price = petrol_can_price,
			petrol_can_stock = petrol_can_stock,
			petrol_can_max_stock = petrol_can_max_stock
        }
    end
    Citizen.Wait(100)
    updateGasStations()
end)

RegisterNetEvent('hyon_gas_station:petrol_can_up', function(stationId)
	local ox_inventory = exports.ox_inventory
    local xPlayer = ESX.GetPlayerFromId(source)
	local item = ox_inventory:GetCurrentWeapon(source)
    local xPlayerMoney = xPlayer.getMoney()
	
	if GasStations[stationId] == nil then
		if item then
			if item.metadata.durability < 100 and item.metadata.ammo < 100 then
			local amount = (100-item.metadata.durability)
			local price = Config.Fuel_Price*amount
				if xPlayerMoney >= price then
				xPlayer.removeMoney(price)
				item.metadata.durability = 100
				item.metadata.ammo = 100
				ox_inventory:SetMetadata(source, item.slot, item.metadata)
				TriggerClientEvent('esx:showNotification', xPlayer.source, Config.Locales.thanks, "success")

				else
				TriggerClientEvent('esx:showNotification', xPlayer.source, Config.Locales.lowmoney, "error")
				end
			end
		end
	else
		if item then
			if item.metadata.durability < 100 and item.metadata.ammo < 100 then
			local amount = (100-item.metadata.durability)
			if GasStations[stationId].capacity >= amount then
			local price = GasStations[stationId].fuel_price*amount
				if xPlayerMoney >= price then
				xPlayer.removeMoney(price)
				item.metadata.durability = 100
				item.metadata.ammo = 100
				ox_inventory:SetMetadata(source, item.slot, item.metadata)
					local newbalance = price+GasStations[stationId].balance
					local newcapa = math.floor((GasStations[stationId].capacity-amount)+0.5)
				    MySQL.Async.execute('UPDATE gas_stations SET capacity = @capacity, balance = @balance WHERE id = @id',
                        {['capacity'] = newcapa, ['balance'] = newbalance, ['id'] = stationId},
                    function()
                        GasStations[stationId].capacity = newcapa
                        GasStations[stationId].balance = newbalance
						Citizen.Wait(100)
                        updateGasStations()
						TriggerClientEvent('esx:showNotification', xPlayer.source, Config.Locales.thanks, "success")
                    end)
				
				else
				TriggerClientEvent('esx:showNotification', xPlayer.source, Config.Locales.lowmoney, "error")
				end
			else
				TriggerClientEvent('esx:showNotification', xPlayer.source, Config.Locales.lowfuelcap, "error")
			end
			end
		end
	end
end)

RegisterNetEvent('hyon_gas_station:levelup', function(stationId)
print("teszt")
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayerMoney = xPlayer.getMoney()
	local currentlevel = GasStations[stationId].level
	local nextlevel = currentlevel+1
	local nextprice = Config.Levels[nextlevel].Price
	if currentlevel ~= #Config.Levels then
		if GasStations[stationId].balance >= nextprice then
			local database = MySQL.Sync.fetchAll('SELECT * FROM gas_stations')
			for k, v in pairs(database) do
            local id = v.id
				if v.id == stationId then
				local newbalance = GasStations[stationId].balance - nextprice
                local newlevel = nextlevel
                local newfuelcap = Config.Levels[nextlevel].Fuel_Capacity
                local newcanstock = Config.Levels[nextlevel].Petrol_Can_Stock
                    MySQL.Async.execute('UPDATE gas_stations SET level = @level, max_capacity = @max_capacity, petrol_can_max_stock = @petrol_can_max_stock, balance = @balance WHERE id = @id',
                        {['level'] = newlevel, ['petrol_can_max_stock'] = newcanstock, ['max_capacity'] = newfuelcap, ['balance'] = newbalance, ['id'] = stationId},
                    function()
                        GasStations[stationId].level = newlevel
                        GasStations[stationId].balance = newbalance
                        GasStations[stationId].max_capacity = newfuelcap
                        GasStations[stationId].petrol_can_max_stock = newcanstock
						Citizen.Wait(100)
                        updateGasStations()
                    end)
				end
			end
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, Config.Locales.gas_balance_low, "error")
		end
	end
end)

RegisterNetEvent('hyon_gas_station:update_prices', function(stationId, what, clientprice)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayerMoney = xPlayer.getMoney()
	local update = what
	local newprice = clientprice
		if update == "fuel" and newprice <= Config.Fuel_Max_Price then 
			local database = MySQL.Sync.fetchAll('SELECT * FROM gas_stations')
			for k, v in pairs(database) do
            local id = v.id
				if v.id == stationId then
                local newfuelprice = newprice
                    MySQL.Async.execute('UPDATE gas_stations SET fuel_price = @fuel_price WHERE id = @id',
                        {['fuel_price'] = newfuelprice, ['id'] = stationId},
                    function()
                        GasStations[stationId].fuel_price = newfuelprice
						Citizen.Wait(100)
                        updateGasStations()
                    end)
				end
			end
		elseif update == "fuel" and newprice > Config.Fuel_Max_Price then
			TriggerClientEvent('esx:showNotification', xPlayer.source, Config.Locales.maxfuelprice .. Config.Fuel_Max_Price, "error")
		end
		if update == "petrol_can" and newprice <= Config.Petrol_Can_Max_Price then 
			local database = MySQL.Sync.fetchAll('SELECT * FROM gas_stations')
			for k, v in pairs(database) do
            local id = v.id
				if v.id == stationId then
                local newcanprice = newprice
                    MySQL.Async.execute('UPDATE gas_stations SET petrol_can_price = @petrol_can_price WHERE id = @id',
                        {['petrol_can_price'] = newcanprice, ['id'] = stationId},
                    function()
                        GasStations[stationId].petrol_can_price = newcanprice
						Citizen.Wait(100)
                        updateGasStations()
                    end)
                end
			end
		elseif update == "petrol_can" and newprice > Config.Petrol_Can_Max_Price then
			TriggerClientEvent('esx:showNotification', xPlayer.source, Config.Locales.maxpetrolcanprice .. Config.Petrol_Can_Max_Price, "error")
		end
end)

RegisterNetEvent('hyon_gas_station:payForFuel', function(stationId, amountUsed)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayerMoney = xPlayer.getMoney()
	print(amountUsed)
    local price = Config.Fuel_Price*amountUsed
	print(price)
    if GasStations[stationId] then
        price = GasStations[stationId].fuel_price*amountUsed
    end
    if xPlayerMoney >= price then
        xPlayer.removeMoney(price)
    end
    if tonumber(stationId) and tonumber(amountUsed) then
        local stationCapacity = nil
        local database = MySQL.Sync.fetchAll('SELECT * FROM gas_stations')
        for k, v in pairs(database) do
            local id = v.id
            if v.id == stationId then
                local left = math.floor((v.capacity - tonumber(amountUsed)) + 0.5)
                local balance = math.floor((v.balance + tonumber(price)) + 0.5)
                if left >= 0 then
                    MySQL.Async.execute('UPDATE gas_stations SET capacity = @capacity, balance = @balance WHERE id = @id',
                        {['capacity'] = left, ['balance'] = balance, ['id'] = stationId},
                    function()
                        GasStations[stationId].capacity = left
                        GasStations[stationId].balance = balance
                        updateGasStations()
                    end)
                end
            end
        end
    end
end)

RegisterNetEvent("hyon_gas_station:buyGasStation", function(id)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayerMoney = xPlayer.getMoney()
    local identifier = xPlayer.getIdentifier()
    local database = MySQL.Sync.fetchAll('SELECT * FROM gas_stations')
    for k, v in pairs(database) do
        if v.id == id and v.price <= 0 then
		TriggerClientEvent('esx:showNotification', xPlayer.source, Config.Locales.lowmoney, "error")
            return
        elseif v.id == id and v.price > 0 then   
            if xPlayerMoney >= v.price then
				local level = v.capacity
				local fuel_price = Config.Fuel_Price
				local capacity = v.capacity
				local max_capacity = v.max_capacity
				local price = 0
				local balance = v.balance
				local petrol_can_max_stock = v.petrol_can_max_stock
				
                MySQL.Async.execute('UPDATE gas_stations SET owner = @owner, level = @level, fuel_price = @fuel_price, capacity = @capacity, max_capacity = @max_capacity, price = @price, balance = @balance, petrol_can_price = @petrol_can_price, petrol_can_stock = @petrol_can_stock, petrol_can_max_stock = @petrol_can_max_stock WHERE id = @id',
                {['owner'] = identifier, ['level'] = level, ['fuel_price'] = fuel_price,['capacity'] = capacity, ['max_capacity'] = max_capacity, ['price'] = price, ['balance'] = balance, ['id'] = id, ['petrol_can_price'] = petrol_can_price, ['petrol_can_stock'] = petrol_can_stock, ['petrol_can_max_stock'] = petrol_can_max_stock},
                function()
                    xPlayer.removeMoney(v.price)
                    local users = MySQL.Sync.fetchAll('SELECT accounts FROM users WHERE identifier = @identifier', {['identifier'] = v.owner})
                    if users then
                        local accounts = {}
                        for k,v in pairs(users) do 
                            accounts = json.decode(v.accounts)
                        end
                        accounts.money = accounts.money + tonumber(v.price)
                        MySQL.Async.execute('UPDATE users SET accounts = @accounts WHERE identifier = @identifier',
                        { ['accounts'] = json.encode(accounts), ['identifier'] = v.owner },
                        function() end)
                    end
                    GasStations[id] = {
                        id = id,
                        owner = identifier,
						level = level,
						fuel_price = fuel_price,
                        capacity = capacity,
						max_capacity = max_capacity,
                        price = price,
                        balance = balance,
						petrol_can_price = petrol_can_price,
						petrol_can_stock = petrol_can_stock,
						petrol_can_max_stock = petrol_can_max_stock
                    }
                    updateGasStations()
                end)
			else
		TriggerClientEvent('esx:showNotification', xPlayer.source, Config.Locales.lowmoney, "error")
            end
            return
        end
    end
        
    if xPlayerMoney >= Config.Gas_Station_Price then
		local level = 1
		local fuel_price = Config.Fuel_Price
        local capacity = 0
		local max_capacity = Config.Levels[1].Fuel_Capacity
        local price = 0
        local balance = 0
		local petrol_can_max_stock = Config.Levels[1].Petrol_Can_Stock
        MySQL.Async.insert('INSERT INTO gas_stations (id, owner, level, fuel_price, capacity, max_capacity, price, balance, petrol_can_price, petrol_can_stock, petrol_can_max_stock) VALUES (@id, @owner, @level, @fuel_price, @capacity, @max_capacity, @price, @balance, @petrol_can_price, @petrol_can_stock, @petrol_can_max_stock)',
        {['id'] = id, ['owner'] = identifier, ['level'] = 1, ['fuel_price'] = Config.Fuel_Price, ['capacity'] = 0, ['max_capacity'] = Config.Levels[1].Fuel_Capacity, ['price'] = price, ['balance'] = balance, ['petrol_can_price'] = Config.Petrol_Can_Price, ['petrol_can_stock'] = 0, ['petrol_can_max_stock'] = Config.Levels[1].Petrol_Can_Stock},
        function() 
            xPlayer.removeMoney(Config.Gas_Station_Price)
            GasStations[id] = {
                id = id,
                owner = identifier,
				level = level,
				fuel_price = fuel_price,
                capacity = capacity,
				max_capacity = max_capacity,
                price = price,
                balance = balance,
				petrol_can_price = Config.Petrol_Can_Price,
				petrol_can_stock = 0,
				petrol_can_max_stock = petrol_can_max_stock
            }
			TriggerClientEvent('esx:showNotification', xPlayer.source, Config.Locales.bought_gas_station, "success")
            updateGasStations()
        end)
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, Config.Locales.lowmoney, "error")
    end
end)

RegisterNetEvent("hyon_gas_station:updateLevel", function(stationId, amount)
    if stationId and amount then
        if GasStations[stationId] and GasStations[stationId].capacity then
            local newcap = GasStations[stationId].capacity - amount
                MySQL.Async.execute('UPDATE gas_stations SET capacity = @capacity WHERE id = @id',
                    { ['capacity'] = newcap, ['id'] = stationId },
                function()
					GasStations[stationId].capacity = newcap
                    updateGasStations()
				end)
        end
    end
end)

RegisterNetEvent("hyon_gas_station:missionupdatecan", function(stationId, amount)
    if stationId and amount then
        if GasStations[stationId] then
           local newcap = GasStations[stationId].petrol_can_stock + amount
                MySQL.Async.execute('UPDATE gas_stations SET petrol_can_stock = @petrol_can_stock WHERE id = @id',
                    { ['petrol_can_stock'] = newcap, ['id'] = stationId },
                function()
					GasStations[stationId].petrol_can_stock = newcap
                    updateGasStations()
				end)
        end
    end
end)

RegisterNetEvent("hyon_gas_station:missionupdateLevel", function(stationId, amount)
    if stationId and amount then
        if GasStations[stationId] then
           local newcap = GasStations[stationId].capacity + amount
                MySQL.Async.execute('UPDATE gas_stations SET capacity = @capacity WHERE id = @id',
                    { ['capacity'] = newcap, ['id'] = stationId },
                function()
					GasStations[stationId].capacity = newcap
                    updateGasStations()
				end)
        end
    end
end)


RegisterNetEvent("hyon_gas_station:deposit", function(stationId, deposit)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    if stationId and tonumber(deposit) then
        if GasStations[stationId].owner == identifier then
            if xPlayer.getMoney() >= tonumber(deposit) then
                xPlayer.removeMoney(tonumber(deposit))
                local newbalance = GasStations[stationId].balance + tonumber(deposit)
                MySQL.Async.execute('UPDATE gas_stations SET balance = @balance WHERE id = @id',
                    { ['balance'] = newbalance, ['id'] = stationId },
                function()
					GasStations[stationId].balance = newbalance
                    updateGasStations()
                end)
            end
        end
    end
end)

RegisterNetEvent("hyon_gas_station:withdraw", function(stationId, withdraw)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    if stationId and tonumber(withdraw) then
        if GasStations[stationId].owner == identifier then
            if GasStations[stationId].balance >= tonumber(withdraw) then
                local newbalance = GasStations[stationId].balance - tonumber(withdraw)
                MySQL.Async.execute('UPDATE gas_stations SET balance = @balance WHERE id = @id',
                    { ['balance'] = newbalance, ['id'] = stationId },
                function()
                    xPlayer.addMoney(tonumber(withdraw))
					GasStations[stationId].balance = newbalance
                    updateGasStations()
                end)
            end
        end
    end
end)

RegisterNetEvent("hyon_gas_station:balanceremove", function(stationId, withdraw)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    if stationId and tonumber(withdraw) then
        if GasStations[stationId].owner == identifier then
            if GasStations[stationId].balance >= tonumber(withdraw) then
                GasStations[stationId].balance = GasStations[stationId].balance - tonumber(withdraw)
                MySQL.Async.execute('UPDATE gas_stations SET balance = @balance WHERE id = @id',
                    { ['balance'] = GasStations[stationId].balance, ['id'] = stationId },
                function()
                    updateGasStations()
                end)
            end
        end
    end
end)

RegisterNetEvent('hyon_gas_station:sellStation', function(stationId, sellPrice)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    if stationId and tonumber(sellPrice) then
        if GasStations[stationId].owner == identifier then
            GasStations[stationId].price = tonumber(sellPrice)
            MySQL.Async.execute('UPDATE gas_stations SET price = @price WHERE id = @id',
                { ['price'] = json.encode(GasStations[stationId].price), ['id'] = stationId },
            function()
                updateGasStations()
            end)
        end
    end
end)

RegisterNetEvent("hyon_gas_station:buypetrolcan", function(stationId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
	local xPlayerMoney = xPlayer.getMoney()
	local item = "WEAPON_PETROLCAN"
		if GasStations[stationId] == nil then
		local defaultprice = Config.Petrol_Can_Price
			if xPlayer.canCarryItem(item, 1) then
					if xPlayerMoney >= defaultprice then
							xPlayer.removeMoney(defaultprice)
						exports.ox_inventory:AddItem(source, 'WEAPON_PETROLCAN', 1, "new")
						
								local petrcan = exports.ox_inventory:Search(source, 1, 'WEAPON_PETROLCAN')
								for k, v in pairs(petrcan) do
									if v.metadata.type == "new" then
										v.metadata.type = ""
										v.metadata.durability = 0
										v.metadata.ammo = 0
										exports.ox_inventory:SetMetadata(source, v.slot, v.metadata)
									end
								end
					else
					TriggerClientEvent('esx:showNotification', xPlayer.source, Config.Locales.lowmoney, "error")
					end
			else
				TriggerClientEvent('esx:showNotification', xPlayer.source, Config.Locales.no_space, "error")
			end
		else
		local defaultprice = GasStations[stationId].petrol_can_price
			if xPlayer.canCarryItem(item, 1) then
					if xPlayerMoney >= defaultprice then
							xPlayer.removeMoney(defaultprice)
						exports.ox_inventory:AddItem(source, 'WEAPON_PETROLCAN', 1, "new")
						
								local petrcan = exports.ox_inventory:Search(source, 1, 'WEAPON_PETROLCAN')
								for k, v in pairs(petrcan) do
									if v.metadata.type == "new" then
										v.metadata.type = ""
										v.metadata.durability = 0
										v.metadata.ammo = 0
										exports.ox_inventory:SetMetadata(source, v.slot, v.metadata)
									end
								end
								local database = MySQL.Sync.fetchAll('SELECT * FROM gas_stations')
								for k, v in pairs(database) do
									local id = v.id
									if v.id == stationId then
										local balance = math.floor((v.balance + tonumber(v.petrol_can_price)) + 0.5)
										local petrol_can_stock = math.floor((v.petrol_can_stock - 1.0) + 0.5)
										MySQL.Async.execute('UPDATE gas_stations SET balance = @balance, petrol_can_stock = @petrol_can_stock WHERE id = @id',
										{['balance'] = balance, ['petrol_can_stock'] = petrol_can_stock, ['id'] = stationId},
											function()
											GasStations[stationId].balance = balance
											GasStations[stationId].petrol_can_stock = petrol_can_stock
											updateGasStations()
											end)
									end
								end
					else
					TriggerClientEvent('esx:showNotification', xPlayer.source, Config.Locales.lowmoney, "error")
					end
			else
				TriggerClientEvent('esx:showNotification', xPlayer.source, Config.Locales.no_space, "error")
			end
		end
end)

RegisterNetEvent("hyon_gas_station:buypetrolcan_no_ox", function(stationId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
	local xPlayerMoney = xPlayer.getMoney()
	local item = "WEAPON_PETROLCAN"

		if GasStations[stationId] == nil then
			local defaultprice = Config.Petrol_Can_Price
			xPlayer.removeMoney(defaultprice)
		else
			local defaultprice = GasStations[stationId].petrol_can_price
			xPlayer.removeMoney(defaultprice)
			local database = MySQL.Sync.fetchAll('SELECT * FROM gas_stations')
								for k, v in pairs(database) do
									local id = v.id
									if v.id == stationId then
										local balance = math.floor((v.balance + tonumber(v.petrol_can_price)) + 0.5)
										local petrol_can_stock = math.floor((v.petrol_can_stock - 1.0) + 0.5)
										MySQL.Async.execute('UPDATE gas_stations SET balance = @balance, petrol_can_stock = @petrol_can_stock WHERE id = @id',
										{['balance'] = balance, ['petrol_can_stock'] = petrol_can_stock, ['id'] = stationId},
											function()
											GasStations[stationId].balance = balance
											GasStations[stationId].petrol_can_stock = petrol_can_stock
											updateGasStations()
											end)
									end
								end
		end			
end)

RegisterNetEvent("hyon_gas_station:update_can_level_ox", function(amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
	local item = "WEAPON_PETROLCAN"
						
								local petrcan = exports.ox_inventory:GetCurrentWeapon(source)
										petrcan.metadata.durability = amount
										petrcan.metadata.ammo = amount
								exports.ox_inventory:SetMetadata(source, petrcan.slot, petrcan.metadata)
end)



RegisterNetEvent("esx:playerLoaded", function(source, xPlayer)
    TriggerClientEvent("hyon_gas_station:updateClientData", source, _G["GasStations"])
end)

function updateGasStations()
    TriggerClientEvent("hyon_gas_station:updateClientData", -1, _G["GasStations"])
end