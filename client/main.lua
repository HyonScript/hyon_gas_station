 PlayerData = {}
local npc = {}
Citizen.CreateThread(function()
    while PlayerData.identifier == nil do
        PlayerData = ESX.GetPlayerData()
        Citizen.Wait(1)
    end
end)

function GetFuel(vehicle)
	return DecorGetFloat(vehicle, Config.FuelDecor)
end

function SetFuel(vehicle, level)
	SetVehicleFuelLevel(vehicle, level)
    DecorSetFloat(vehicle, Config.FuelDecor, GetVehicleFuelLevel(vehicle))
end

local GasStations = {}
local NearestPump = nil 
local Drawing = {}
local Hose = {}
local Looping = {}
local Vehicle = nil
local Filling = 0.0 
local AmountUsed = 0.0
local FuelLevel = 0
local PlayerMoney = 0 
local Fueling = false 
local closest_stat = nil
local petrolcanprice = 0
local petrolcanstock = 0
local petrolprice = 0
local sellstationprice = 0 
local draw_text = false
local fuel_order_amount = 0
local station_mission = 0
local fuel_mission = 0
local fuel_task = 0
local fuel_mission_blip = nil
local trailer_level = 0
local misson_fuel_text = false
local misson_can_text = false
local can_mission = 0
local can_task = 0
local can_mission_blip = nil
local can_order_amount = 0
local can_mission_entity = nil
local fuelSynced = false

RegisterNetEvent('hyon_gas_station:updateClientData', function(stations)
    GasStations = stations
end)
Citizen.CreateThread(function()
lib.hideTextUI()
	for i = 1, #Config.GasStations do
	npc[i] = nil
	end
end)
Citizen.CreateThread(function()
DecorRegister(Config.FuelDecor, 1)
	if Config.Blips == true then
        for k,v in ipairs(Config.GasStations) do
        local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
        SetBlipSprite(blip, 415)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.75)
        SetBlipColour(blip, 2)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Gas Station")
        EndTextCommandSetBlipName(blip)
        end
	end
	
	while true do
		Citizen.Wait(1000)

		local ped = PlayerPedId()

		if IsPedInAnyVehicle(ped) then
			local vehicle = GetVehiclePedIsIn(ped)
				ManageFuelUsage(vehicle)
		else
			if fuelSynced then
				fuelSynced = false
			end
		end
	end
end)


function ManageFuelUsage(vehicle)
	if not DecorExistOn(vehicle, Config.FuelDecor) then
		SetFuel(vehicle, math.random(200, 800) / 10)
	elseif not fuelSynced then
		SetFuel(vehicle, GetFuel(vehicle))

		fuelSynced = true
	end

	if IsVehicleEngineOn(vehicle) then
		SetFuel(vehicle, GetVehicleFuelLevel(vehicle) - Config.fueluse[Round(GetVehicleCurrentRpm(vehicle), 1)] / 10)
	end
end

local fueling_with_can = false
local fuel_level_can = 0
local refuel_withcan = 0.0
Citizen.CreateThread(function()
while true do
	local wait = 1000
	local pPed = PlayerPedId()
	local playerco = GetEntityCoords(pPed)
	local pedWeapon = GetSelectedPedWeapon(pPed)
	local weapon = 883325847
	local closveh = GetClosestVehicle(playerco, 2.0, 0, 127)
	if closveh == 0 then
	closveh = GetClosestVehicle(playerco, 2.0, 0, 12294)
	end
	local closcar = IsThisModelABicycle(GetEntityModel(closveh))
	local closvehcoord = GetEntityCoords(closveh)
	local distance = #(playerco - closvehcoord)
	if pedWeapon == weapon then
	wait = 1000
		if Config.ox_inventory == true then
			if closcar ~= 1 then
			wait = 5
			local vehfuellevel = GetVehicleFuelLevel(closveh)
					DrawText3Ds(closvehcoord.x, closvehcoord.y, closvehcoord.z+0.7, Config.Locales.fuel_can_veh_level ..GetVehicleFuelLevel(closveh) .. "\n" .. Config.Locales.fuel_with_can_nearveh)
						if fueling_with_can == false then
						fuelwithcan_ox(closveh,pPed)				
						end						
			else
			wait = 1000
			end
		else
			if closcar ~= 1 then
			wait = 5
			local vehfuellevel = GetVehicleFuelLevel(closveh)
					DrawText3Ds(closvehcoord.x, closvehcoord.y, closvehcoord.z+0.7, Config.Locales.fuel_can_veh_level ..GetVehicleFuelLevel(closveh) .. "\n" .. Config.Locales.fuel_with_can_nearveh)
						if fueling_with_can == false then
						fuelwithcan_no_ox(closveh,pPed)				
						end						
			else
			wait = 1000
			end
		end
	else
	wait = 1000
	end
	Citizen.Wait(wait)
end
end)

--function fuelwithcan_ox(closveh, pPed)
  --  fueling_with_can = true
   -- Citizen.CreateThread(function()
    --    local refuel = math.floor(GetVehicleFuelLevel(closveh))
     --   Citizen.Wait(500)
      --  while IsControlPressed(0,38) do
	--	    if refuel < 100 then
		--	local add = refuel_speed
		--	refuel = refuel + add
		--	    if refuel > fuel_level_can then
                   -- SetVehicleFuelLevel(closveh, refuel)
         --       end
		--	elseif refuel >= 100 and cur_weapon.metadata.ammo <= 0 then
		--	    fueling_with_can = false
		--	else
		--	fueling_with_can = false
		--	break
		--	end
		--e-nd
			--fueling_with_can = false
--end)
--end
local fuelingCan = nil
if Config.ox_inventory == true then

AddEventHandler('ox_inventory:currentWeapon', function(currentWeapon)
	fuelingCan = currentWeapon?.name == 'WEAPON_PETROLCAN' and currentWeapon
end)
end


function fuelwithcan_ox(closveh, pPed)
    fueling_with_can = true
    Citizen.CreateThread(function()
	local ped = PlayerPedId()
        refuel_withcan = math.floor(GetVehicleFuelLevel(closveh))
        Citizen.Wait(1000)
        while IsControlPressed(0,38) do
		LoadAnimDict("weapon@w_sp_jerrycan")
		if not IsEntityPlayingAnim(ped, "weapon@w_sp_jerrycan", "fire", 3) then
			TaskPlayAnim(ped, "weapon@w_sp_jerrycan", "fire", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
		end
            Citizen.Wait(1000)
            if refuel_withcan < 100 and fuelingCan.metadata.ammo > 0 then
                local add = Config.refuel_speed
                refuel_withcan = refuel_withcan + add
                AmountUsed = AmountUsed + add
				fuelingCan.metadata.ammo = fuelingCan.metadata.ammo - add
                if refuel_withcan > FuelLevel then
                    SetVehicleFuelLevel(closveh, refuel_withcan)
					DecorSetFloat(closveh, Config.FuelDecor, refuel_withcan + 0.0)
					TriggerServerEvent("hyon_gas_station:update_can_level_ox", fuelingCan.metadata.ammo)
                end
            elseif refuel_withcan >= 100 then
				ESX.ShowNotification(Config.Locales.fulltank)
                fueling_with_can = false
				ClearPedTasks(ped)
				
                break
			elseif fuelingCan.metadata.ammo <= 0 then
				ESX.ShowNotification(Config.Locales.can_ammo_low)
                fueling_with_can = false
				ClearPedTasks(ped)
            else
                fueling_with_can = false
				ClearPedTasks(ped)
                break
            end
        end
        fueling_with_can = false
						ClearPedTasks(ped)
    end)
end

function fuelwithcan_no_ox(closveh, pPed)
    fueling_with_can = true
    Citizen.CreateThread(function()
	local ped = PlayerPedId()
	local ammo = (GetAmmoInPedWeapon(ped, 883325847))
        refuel_withcan = math.floor(GetVehicleFuelLevel(closveh))
        Citizen.Wait(1000)
        while IsControlPressed(0,38) do
		LoadAnimDict("weapon@w_sp_jerrycan")
		if not IsEntityPlayingAnim(ped, "weapon@w_sp_jerrycan", "fire", 3) then
			TaskPlayAnim(ped, "weapon@w_sp_jerrycan", "fire", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
		end
            Citizen.Wait(1000)
            if refuel_withcan < 100 and ammo > 0 then
                local add = math.random(10, 20) / 10.0
                refuel_withcan = refuel_withcan + add
                AmountUsed = AmountUsed + add
				ammo = ammo - add*100
                if refuel_withcan > FuelLevel then
                    SetVehicleFuelLevel(closveh, refuel_withcan)
					DecorSetFloat(closveh, Config.FuelDecor, refuel_withcan + 0.0)
					SetPedAmmo(ped, 883325847, math.floor(GetAmmoInPedWeapon(ped, 883325847) - ammo ))
                end
            elseif refuel_withcan >= 100 then
				ESX.ShowNotification(Config.Locales.fulltank)
                fueling_with_can = false
				ClearPedTasks(ped)
				
                break
            else
                fueling_with_can = false
				ClearPedTasks(ped)
                break
            end
        end
        fueling_with_can = false
						ClearPedTasks(ped)
    end)
end

function LoadAnimDict(dict)
	if not HasAnimDictLoaded(dict) then
		RequestAnimDict(dict)

		while not HasAnimDictLoaded(dict) do
			Citizen.Wait(1)
		end
	end
end

Citizen.CreateThread(function()
    while true do
	local wait = 500
        local closestStation = getClosestStation()
        local closestPump = getClosestPump()
        local player = PlayerPedId()
        local coords = GetEntityCoords(player)
		local pedmodel = GetHashKey(Config.NPC)
		closest_stat = closestStation.id
		Citizen.Wait(wait)
		RequestModel(pedmodel)
		while not HasModelLoaded(pedmodel) do
			Citizen.Wait(1)
		end
        Vehicle = GetVehiclePedIsIn(player, false)
        NearestPump = closestPump
        if closestStation then
            local dist = #(coords - closestStation.coords)
			local npcdist = #(coords - closestStation.npc_coord.coords)
            if dist <= 40.0 then
			if GasStations[closestStation.id] ~= nil then
			petrolcanprice = GasStations[closestStation.id].petrol_can_price
			petrolcanstock = GasStations[closestStation.id].petrol_can_stock
			end
				if npc[closestStation.id] == nil then
					npc[closestStation.id] = CreatePed(1, pedmodel, closestStation.npc_coord.coords.x, closestStation.npc_coord.coords.y, closestStation.npc_coord.coords.z-1, closestStation.npc_coord.heading, false, true)
					SetPedComponentVariation(npc[closestStation.id], 0, 1, 0, 2) -- face
					SetPedComponentVariation(npc[closestStation.id], 1, 0, 0, 0) -- mask
					SetPedComponentVariation(npc[closestStation.id], 2, 5, 0, 0) -- haircut
					SetPedComponentVariation(npc[closestStation.id], 3, 1, 2, 2) -- no shirt
					SetPedComponentVariation(npc[closestStation.id], 4, 1, 2, 2) -- leg
					SetPedComponentVariation(npc[closestStation.id], 5, 0, 0, 0) -- Parachute
					SetPedComponentVariation(npc[closestStation.id], 6, 0, 2, 2) -- shoes
					SetPedComponentVariation(npc[closestStation.id], 7, 0, 0, 0) -- Accessory					
					SetPedComponentVariation(npc[closestStation.id], 8, 2, 0, 2) -- accessories (no necklace)				   
					SetPedComponentVariation(npc[closestStation.id], 9, 1, 0, 2) --mission items/tasks (private parts)
					SetPedComponentVariation(npc[closestStation.id], 10, 0, 0, 0) -- Badge
					SetPedComponentVariation(npc[closestStation.id], 11, 0, 0, 0) -- Torso2
					FreezeEntityPosition(npc[closestStation.id], true)
					SetEntityHeading(npc[closestStation.id], closestStation.npc_coord.heading)
					SetEntityInvincible(npc[closestStation.id], true)
					SetBlockingOfNonTemporaryEvents(npc[closestStation.id], true)
				end
			else
				if npc[closestStation.id] ~= nil then
				DeleteEntity(npc[closestStation.id])
				npc[closestStation.id] = nil
				end
            end
                if closestPump and not IsPedInAnyVehicle(player, false) then
                    if not Drawing[NearestPump.object] then
                        Drawing[NearestPump.object] = true
                        pumpLoop(NearestPump.object, closestStation.id)
                    end
                end
        end
        Citizen.Wait(wait)
    end 
end)

Citizen.CreateThread(function()
while true do
local wait = 1000
local player = PlayerPedId()
local coords = GetEntityCoords(player)
local npc_coord = Config.GasStations[closest_stat].npc_coord.coords
local npcdist = #(coords - npc_coord)
	if npcdist <= 2.0 then
	wait = 5
		DrawText3Ds(npc_coord.x, npc_coord.y, npc_coord.z+1, Config.Locales.npc)
		if IsControlJustReleased(0,38) then
			--OpenNPCMenu(closestStation.id)
			if GasStations[closest_stat] == nil then
				lib.showContext('OpenFreeNPCMenu')
			elseif GasStations[closest_stat] ~= nil and GasStations[closest_stat].owner == PlayerData.identifier then
			gas_owner()
			elseif GasStations[closest_stat] ~= nil and GasStations[closest_stat].owner ~= PlayerData.identifier then
			gas_no_owner()
			end
		end
	else
	wait = 1000
	end
	Citizen.Wait(wait)
end
end)

function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function comma_value(amount)
    local formatted = amount
    while true do  
      formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
      if (k==0) then
        break
      end
    end
    return formatted
end

function pumpLoop(drawingId, stationId)
    Citizen.CreateThread(function()
        while NearestPump do
            local pumpText = {}
			local coords = GetEntityCoords(closest)
            local pump = NearestPump
            local player = PlayerPedId()
			if not Hose.active then
			if GasStations[stationId] and GasStations[stationId].capacity > 0 and tonumber(GasStations[stationId].fuel_price) then
				DrawText3Ds(pump.coords.x, pump.coords.y, pump.coords.z+1.5 ,Config.Locales.fuel_menu)
            elseif GasStations[stationId] ~= nil and GasStations[stationId].capacity < 1 then
            DrawText3Ds(pump.coords.x, pump.coords.y, pump.coords.z+1.5 ,"~r~" .. Config.Locales.fuel_menu_nofuel .. "~s~")
			elseif GasStations[stationId] == nil then
				DrawText3Ds(pump.coords.x, pump.coords.y, pump.coords.z+1.5 ,Config.Locales.fuel_menu)
            end
			end
            if IsPedInAnyVehicle(player, false) then
                break
            end
            if IsControlJustPressed(0,38) then
                if not Hose.active then
					if GasStations[stationId] and GasStations[stationId].capacity > 0 and tonumber(GasStations[stationId].fuel_price) then
							fuelmenu_owner(pump)
						elseif GasStations[stationId] == nil then
							fuelmenu_noowner(pump)
						end
                end
            end
            if IsControlJustPressed(0,73) or IsDisabledControlJustPressed(0,73) then
                if Hose.active then
                    deleteHose(stationId)
                end
            end
            if Hose.active then
                DisablePlayerFiring(PlayerId(), true)
                local closest = GetClosestVehicle(pump.coords, 4.0, 0, 127)
                local coords = GetEntityCoords(closest)
                if GasStations[stationId] and GasStations[stationId].capacity then
                    local price = (AmountUsed * GasStations[stationId].fuel_price)
					DrawText3Ds(pump.coords.x, pump.coords.y, pump.coords.z+1.5 ,Config.Locales.fueling_amount.. AmountUsed  .. "L" .. "\n".. Config.Locales.fueling_price.. round(price,2))
                else
					DrawText3Ds(pump.coords.x, pump.coords.y, pump.coords.z+1.5 ,Config.Locales.fueling_amount.. AmountUsed  .. "L" .. "\n".. Config.Locales.fueling_price.. round((AmountUsed*Config.Fuel_Price),2))
                end
                if closest and closest ~= 0 then
                    if GetVehicleClass(closest) ~= 13 then
                        local text = {}
                        if not Hose.attached then
								DrawText3Ds(coords.x, coords.y, coords.z+0.5 ,Config.Locales.fueling_nozzle)
                            if IsControlJustPressed(0,38) or IsDisabledControlJustPressed(0,38) then
                                attachToVehicle(closest)
                            end
                        elseif Hose.attached then
                            if Filling == 0 then
                                Filling = GetVehicleFuelLevel(closest) 
                                FuelLevel = GetVehicleFuelLevel(closest) 
                            end
                            if tonumber(Filling) then
                                local value = math.floor(tonumber(Filling)).."%"
								DrawText3Ds(coords.x, coords.y, coords.z+0.5 ,Config.Locales.fueling_level .. value .. "~s~\n" .. Config.Locales.fueling_holde .. "\n" .. Config.Locales.fueling_cancel)
                            end
                            if IsControlJustPressed(0,38) or IsDisabledControlJustPressed(0,38) then
                                if not Fueling then
                                    fillingLoop(closest, stationId)
                                end
                            end
                        end
                    end
                end
            end
            Citizen.Wait(2)
        end
        if Hose.active then
			ESX.ShowNotification(Config.Locales.toofar)
        end
        deleteHose(stationId)
        Drawing[drawingId] = false
    end)
end

function fillingLoop(vehicle, stationId)
    Fueling = true
    Citizen.CreateThread(function()
        Filling = math.floor(GetVehicleFuelLevel(vehicle))
        Citizen.Wait(500)
        TriggerServerEvent("hyon_gas_station:updateLevel")
        while IsControlPressed(0,38) do
            Citizen.Wait(500)
            PlayerData = ESX.GetPlayerData()
            for i,v in ipairs(PlayerData.accounts) do
                if v.name == 'money' then
                    PlayerMoney = v.money
                end
            end
            if Filling < 100 and PlayerMoney >= math.ceil(Config.Fuel_Price * (AmountUsed + 1)) then
                local add = Config.refuel_speed
                if GasStations[stationId] and GasStations[stationId].capacity then
                    if GasStations[stationId].capacity < add then                    
						ESX.ShowNotification(Config.Locales.outoffuel)
                        Fueling = false
                        deleteHose(stationId)
                        break
                    end
                end
                Filling = Filling + add
                AmountUsed = AmountUsed + add
                TriggerServerEvent("hyon_gas_station:updateLevel", stationId, add)
                if Filling > FuelLevel then
                    SetVehicleFuelLevel(vehicle, Filling)
					DecorSetFloat(vehicle, Config.FuelDecor, Filling + 0.0)
                end
            elseif Filling >= 100 then
				ESX.ShowNotification(Config.Locales.fulltank)
                Fueling = false
                deleteHose(stationId)
                break
            elseif PlayerMoney < math.ceil(Config.Fuel_Price * (AmountUsed + 1)) then
				ESX.ShowNotification(Config.Locales.nomoney)
                Fueling = false
                deleteHose(stationId)
                break
            else
                deleteHose(stationId)
                Fueling = false
                break
            end
        end
        Fueling = false
    end)
end

function attachToVehicle(vehicle)
    if Hose.active and not Hose.attached then
        Hose.attached = true
        local vehicleBone = -1
        local isMotorcycle = false
        local vehicleClass = GetVehicleClass(vehicle)
        local change = {x = 0.0, y = 0.0, z = 0.0}
        local newX, newY, newZ = 0,0,0
        if vehicleClass == 8 then
            vehicleBone = GetEntityBoneIndexByName(vehicle, "petrolcap")
            if vehicleBone == -1 then vehicleBone = GetEntityBoneIndexByName(vehicle, "petroltank") end
            if vehicleBone == -1 then vehicleBone = GetEntityBoneIndexByName(vehicle, "engine") end
            isMotorcycle = true
        else
            vehicleBone = GetEntityBoneIndexByName(vehicle, "petrolcap")
            if vehicleBone == -1 then vehicleBone = GetEntityBoneIndexByName(vehicle, "petroltank_l") end
            if vehicleBone == -1 then vehicleBone = GetEntityBoneIndexByName(vehicle, "hub_lr") end
            if vehicleBone == -1 then
                vehicleBone = GetEntityBoneIndexByName(vehicle, "handle_dside_r")
                newX = 0.1
                newY = -0.5
                newZ = -0.6
            end
        end
        if isMotorcycle then AttachEntityToEntity(Hose.nozzle, vehicle, vehicleBone, 0.0 + newX, -0.2 + newY, 0.2 + newZ, -80.0, 0.0, 0.0, true, true, false, false, 1, true)
        else AttachEntityToEntity(Hose.nozzle, vehicle, vehicleBone, -0.2 + newX, 0.0 + newY, 0.6 + newZ, -50.0, 0.0, -90.0, true, true, false, false, 0, true) end
    end
end

function grabNozzleFromPump(pump)
    Hose.active = true 
	if Hose.active and not Hose.attached then
    local ped = PlayerPedId()
    Hose.nozzle = CreateObject('prop_cs_fuel_nozle', 0, 0, 0, true, true, true)
    AttachEntityToEntity(Hose.nozzle, ped, GetPedBoneIndex(ped, 6286), 0.08, 0.1, 0.02, -80.0, -90.0, -30.0, true, true, false, true, 1, true)
    RopeLoadTextures()
    while not RopeAreTexturesLoaded() do
        Wait(0)
    end
    RopeLoadTextures()
    Hose.rope = AddRope(pump.coords.x, pump.coords.y, pump.coords.z, 0.0, 0.0, 0.0, 3.0, 1, 1000.0, 0.0, 1.0, false, false, false, 1.0, true)
    while not Hose.rope do
        Wait(0)
    end
    ActivatePhysics(Hose.rope)
    Wait(50)
    local nozzlePos = GetEntityCoords(Hose.nozzle)
    nozzlePos = GetOffsetFromEntityInWorldCoords(Hose.nozzle, 0.0, -0.033, -0.195)
	AttachEntitiesToRope(Hose.rope, pump.object, Hose.nozzle, pump.coords.x, pump.coords.y, pump.coords.z + 1.45, nozzlePos.x, nozzlePos.y, nozzlePos.z, 5.0, false, false, nil, nil)
	end
end

function deleteHose(stationId)
    if Hose.active then
        DeleteEntity(Hose.nozzle)
        RopeUnloadTextures()
        DeleteRope(Hose.rope)
        Hose = {}
    end
    if AmountUsed > 0 then
        TriggerServerEvent('hyon_gas_station:payForFuel', stationId, AmountUsed)
        AmountUsed = 0
    end
    while Fueling do Wait(0) end
    Filling = 0
    FuelLevel = 0
end

function getClosestStation()
    local player = PlayerPedId()
    local coords = GetEntityCoords(player)
    local closest, closestDist = nil, nil
    for k,v in ipairs(Config.GasStations) do
        local distance = #(coords - v.coords)
        if not closestDist then closestDist = distance end
        if distance <= closestDist then
            closestDist = distance
            closest = {id = k, coords = v.coords, distance = distance, npc_coord = v.npc_coord}
        end
    end
    return closest
end

function getClosestPump(cords, minDist)
    local player = PlayerPedId()
    local coords = GetEntityCoords(player)
    if cords then
        coords = cords
    end
	local closest = nil
    local closestDist = 4.0
    if minDist then
        closestDist = minDist
    end
    for k,v in ipairs(Config.PumpModels) do
        local object = GetClosestObjectOfType(coords.x, coords.y, coords.z, closestDist, GetHashKey(v), false, true, true)
        if object then
            local objectCoords = GetEntityCoords(object)
            local distance = #(coords - objectCoords)
            if distance <= closestDist then
                closest = {object = object, coords = objectCoords, distance = distance}
            end
        end
    end
    return closest
end


function DrawText3D(coords, entry, strings, lift)
	local defaultFont = 10
	local defaultColor = {r = 255, g = 255, b = 255}
	local defaultScale = 0.35
	if scale ~= nil then
		defaultScale = scale
	end
	if font ~= nil then
		defaultFont = font
	end
	if color ~= nil then
		defaultColor = color
	end
	 SetDrawOrigin(coords.x, coords.y, coords.z+lift)
	SetTextScale(defaultScale, defaultScale)
    SetTextFont(defaultFont)
	SetTextProportional(1)
    SetTextColour(defaultColor.r, defaultColor.g, defaultColor.b, 255)
	if entry ~= nil then
    SetTextEntry(entry)
	else
	SetTextEntry("STRING")
	end
    SetTextCentre(1)
    SetTextOutline()
    for i = 1, #strings do
        AddTextComponentString(strings[i])
    end
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.30, 0.30)
    SetTextFont(22)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextOutline()
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370

end

--function OpenNPCMenu(id)
lib.registerContext({
    id = 'OpenFreeNPCMenu',
    title = Config.Locales.free_gas_station_menu_title,
    onExit = function()
    end,
    options = {
        {
			icon = "fa fa-gas-pump",
            title = Config.Locales.free_gas_station,
			arrow = true,
            onSelect = function(args)
              TriggerServerEvent("hyon_gas_station:buyGasStation", closest_stat)
            end,
            metadata = {
                {label = Config.Locales.free_gas_station_price, value = "$"..Config.Gas_Station_Price},
            }
        },
        {
			icon = "fa fa-dollar-sign",
            title = Config.Locales.free_buy_petrol_can_title,
			arrow = true,
            onSelect = function(args)
				if Config.ox_inventory == true then
						TriggerServerEvent("hyon_gas_station:buypetrolcan", closest_stat)
				elseif Config.ox_inventory == false then
					local plyrData = ESX.GetPlayerData()
					local currentCash = 0
					for i=1, #plyrData.accounts, 1 do
					if plyrData.accounts[i].name == 'money' then
						currentCash = plyrData.accounts[i].money
						break
					end
					end
			if currentCash >= Config.Petrol_Can_Price then
				if not HasPedGotWeapon(ped, 883325847) then
				GiveWeaponToPed(ply, 883325847, 0, false, true)
				TriggerServerEvent("hyon_gas_station:buypetrolcan_no_ox", closest_stat)
				end
			else
			TriggerEvent("ESX:Notify", "error", 3000, Config.Locales.lowmoney)
			end
			end
            end,
            metadata = {
                {label = Config.Locales.free_buy_petrol_can_desc, value = "$"..Config.Petrol_Can_Price},
            }
        },
    },
})
local stock_can = 0.01
local now_level = 0
local next_level = 0
local now_fuel_price = 0
local now_can_price = 0
local sell_gas_station = true
local nosell_gas_station = true
local boss_fuel_stock = 0
local boss_can_stock = 0
local gas_statione_price = 0
function gas_owner()
	if GasStations[closest_stat] ~= nil then
		if GasStations[closest_stat].petrol_can_stock ~= nil then
		stock_can = ((GasStations[closest_stat].petrol_can_stock/GasStations[closest_stat].petrol_can_max_stock)*100)+0.01
		else
		stock_can = 0.01
		end
				if GasStations[closest_stat].price > 0 then
		nosell_gas_station = false
		sell_gas_station = true
		else
		nosell_gas_station = true
		sell_gas_station = false
		end
		gas_statione_price = GasStations[closest_stat].price
		now_can_price = GasStations[closest_stat].petrol_can_price
lib.registerContext(
{
    id = 'OpenOwnerNPCMenu',
    title = Config.Locales.own_gas_station_title,
    onExit = function()
    end,
    options = {
        {
			icon = "fa fa-gas-pump",
            title = Config.Locales.open_bossmenu_title,
            onSelect = function(args)
			boss_menu()
            end,
        },
        {
			icon = "fa fa-gas-pump",
            title = Config.Locales.own_gas_station,
			disabled = nosell_gas_station,
            onSelect = function(args)
			TriggerServerEvent("hyon_gas_station:buyGasStation", closest_stat)
            end,
			metadata = {
                {label = Config.Locales.boss_bossm_price_desc, value = "$"..gas_statione_price},
            }
        },
        {
			icon = "fa fa-dollar-sign",
            title = Config.Locales.free_buy_petrol_can_title,
			progress = stock_can,
			arrow = true,
            onSelect = function(args)
				if Config.ox_inventory == true then
						TriggerServerEvent("hyon_gas_station:buypetrolcan", closest_stat)
				elseif Config.ox_inventory == false then
					local plyrData = ESX.GetPlayerData()
					local currentCash = 0
					local ply = PlayerPedId()
					for i=1, #plyrData.accounts, 1 do
					if plyrData.accounts[i].name == 'money' then
						currentCash = plyrData.accounts[i].money
						break
					end
					end
			if currentCash >= Config.Petrol_Can_Price then
				if not HasPedGotWeapon(ply, 883325847) then
				GiveWeaponToPed(ply, 883325847, 0, false, true)
				TriggerServerEvent("hyon_gas_station:buypetrolcan_no_ox", closest_stat)
				end
			else
			TriggerEvent("ESX:Notify", "error", 3000, Config.Locales.lowmoney)
			end
			end
            end,
            metadata = {
                {label = Config.Locales.free_buy_petrol_can_desc, value = "$"..now_can_price},
            }
        },
    },

})
lib.showContext('OpenOwnerNPCMenu')
	end
end

function gas_no_owner()
	if GasStations[closest_stat] ~= nil then
	
		if GasStations[closest_stat].petrol_can_stock ~= nil then
		stock_can = ((GasStations[closest_stat].petrol_can_stock/GasStations[closest_stat].petrol_can_max_stock)*100)+0.01
		else
		stock_can = 0.01
		end
	
		--stock_can = ((GasStations[closest_stat].petrol_can_stock/GasStations[closest_stat].petrol_can_max_stock)*100)+0.01
				if GasStations[closest_stat].price > 0 then
		nosell_gas_station = false
		sell_gas_station = true
		else
		nosell_gas_station = true
		sell_gas_station = false
		end
		gas_statione_price = GasStations[closest_stat].price
		now_can_price = GasStations[closest_stat].petrol_can_price
lib.registerContext(
{
    id = 'Open_no_OwnerNPCMenu',
    title = Config.Locales.own_gas_station_title,
    onExit = function()
    end,
    options = {
        {
			icon = "fa fa-gas-pump",
            title = Config.Locales.own_gas_station,
			disabled = nosell_gas_station,
            onSelect = function(args)
			TriggerServerEvent("hyon_gas_station:buyGasStation", closest_stat)
            end,
			metadata = {
                {label = Config.Locales.boss_bossm_price_desc, value = "$"..gas_statione_price},
            }
        },
        {
			icon = "fa fa-dollar-sign",
            title = Config.Locales.free_buy_petrol_can_title,
			progress = stock_can,
			arrow = true,
            onSelect = function(args)
				if Config.ox_inventory == true then
						TriggerServerEvent("hyon_gas_station:buypetrolcan", closest_stat)
				elseif Config.ox_inventory == false then
					local plyrData = ESX.GetPlayerData()
					local currentCash = 0
					local ply = PlayerPedId()
					for i=1, #plyrData.accounts, 1 do
					if plyrData.accounts[i].name == 'money' then
						currentCash = plyrData.accounts[i].money
						break
					end
					end
			if currentCash >= Config.Petrol_Can_Price then
				if not HasPedGotWeapon(ply, 883325847) then
				GiveWeaponToPed(ply, 883325847, 0, false, true)
				TriggerServerEvent("hyon_gas_station:buypetrolcan_no_ox", closest_stat)
				end
			else
			TriggerEvent("ESX:Notify", "error", 3000, Config.Locales.lowmoney)
			end
			end
            end,
            metadata = {
                {label = Config.Locales.free_buy_petrol_can_desc, value = "$"..now_can_price},
            }
        },
    },

})
lib.showContext('Open_no_OwnerNPCMenu')
	end
end

local balance = 0
local stocks_fuelstockprog = 0.01
local stocks_canstockprog = 0.01
local stocks_fuel = 0
local stocks_can = 0
local stocks_fuel_max = 0
local stocks_can_max = 0
local your_free_fuel = 0
local your_free_can = 0
local spawn_coords = nil
local spawn_heading = nil
local your_stat = 0


function boss_menu()
local newmeta = {}
local _maxlevel = false
		stock_can = ((GasStations[closest_stat].petrol_can_stock/GasStations[closest_stat].petrol_can_max_stock)*100)+0.01
		now_fuel_price = GasStations[closest_stat].fuel_price
		now_can_price = GasStations[closest_stat].petrol_can_price
		balance = GasStations[closest_stat].balance
		if GasStations[closest_stat].level ~= #Config.Levels then
		now_level = GasStations[closest_stat].level
		next_level = now_level+1
		else
		now_level = Config.Locales.boss_gas_station_max_level
		end
		if GasStations[closest_stat].level ~= #Config.Levels then
		local op1 = {label = Config.Locales.boss_bossm_nextlvl_price, value = "$"..Config.Levels[next_level].Price},
		table.insert(newmeta, op1)
		local op2 = {label = Config.Locales.boss_bossm_nextlvl_fuelcap, value = Config.Levels[next_level].Fuel_Capacity},
		table.insert(newmeta, op2)
		local op3 = {label = Config.Locales.boss_bossm_nextlvl_cancap, value = Config.Levels[next_level].Petrol_Can_Stock},
		table.insert(newmeta, op3)
		else
		local op1 = {label = Config.Locales.boss_gas_station_max_level, value = ""},
		table.insert(newmeta, op1)
		local op2 = {label = Config.Locales.boss_gas_station_max_level, value = ""},
		table.insert(newmeta, op2)
		local op3 = {label = Config.Locales.boss_gas_station_max_level, value = ""},
		table.insert(newmeta, op3)
		end
		if GasStations[closest_stat].price > 0 then
		nosell_gas_station = false
		sell_gas_station = true
		else
		nosell_gas_station = true
		sell_gas_station = false
		end
		your_stat = closest_stat
		boss_can_stock = GasStations[closest_stat].petrol_can_stock
		boss_fuel_stock = GasStations[closest_stat].capacity
		stocks_fuelstockprog = (((GasStations[closest_stat].capacity/GasStations[closest_stat].max_capacity)*100)+0.01)
		stocks_canstockprog = (((GasStations[closest_stat].petrol_can_stock/GasStations[closest_stat].petrol_can_max_stock)*100)+0.01)
		stocks_fuel = GasStations[closest_stat].capacity
		stocks_can = GasStations[closest_stat].petrol_can_stock
		stocks_fuel_max = GasStations[closest_stat].max_capacity
		stocks_can_max = GasStations[closest_stat].petrol_can_max_stock
		your_free_fuel = GasStations[closest_stat].max_capacity-GasStations[closest_stat].capacity
		your_free_can = GasStations[closest_stat].petrol_can_max_stock-GasStations[closest_stat].petrol_can_stock
		spawn_coords = Config.GasStations[closest_stat].vehicle_coord.coords
		spawn_heading = Config.GasStations[closest_stat].vehicle_coord.heading
lib.registerContext({
    id = 'OpenBossMenu',
    title = Config.Locales.boss_menu_title,
    onExit = function()
    end,
    options = {
        {
			icon = "fa fa-gas-pump",
            title = Config.Locales.boss_gas_station_id ..": ".. closest_stat,
        },
        {
			icon = "fa fa-gas-pump",
            title = Config.Locales.bossm_upgrade_level_title,
			description = Config.Locales.boss_gas_station_level .. " " .. now_level,
			arrow = true,
            onSelect = function(args)
			if GasStations[closest_stat].level ~= #Config.Levels then
			TriggerServerEvent('hyon_gas_station:levelup', closest_stat)
			else
			TriggerEvent("ESX:Notify", "success", 3000, Config.Locales._max_level)
			end
            end,
			metadata = newmeta
        },
        {
			icon = "fa fa-dollar",
            title = Config.Locales.boss_balance_menu,
			menu = 'balance_menu',
			description = Config.Locales.boss_gas_station_balancedesc .. " $" .. balance,
			arrow = true,
            onSelect = function(args)
            end,
			metadata = {
                {label = Config.Locales.boss_gas_station_withdraw, value = ""},
				{label = Config.Locales.boss_gas_station_deposit, value = ""},
            }
        },
        {
			icon = "fa fa-dollar",
            title = Config.Locales.boss_stocks_menu,
			menu = 'stocks_menu',
			arrow = true,
            onSelect = function(args)
            end,
			metadata = {
                {label = Config.Locales.boss_gas_station_fuel_stock, value = boss_fuel_stock .. " L"},
				{label = Config.Locales.boss_gas_station_can_stock, value = boss_can_stock},
            }
        },
        {
			icon = "fa fa-dollar",
            title = Config.Locales.bossm_new_fuel_price,
			arrow = true,
            onSelect = function(args)
			local input = lib.inputDialog(Config.Locales.bossm_new_fuel_price, {Config.Locales.boss_bossm_price_desc})

			if not input then return end
			local newprice = tonumber(input[1])
			local what = "fuel"
			TriggerServerEvent('hyon_gas_station:update_prices', closest_stat, what, newprice)
            end,
			metadata = {
                {label = Config.Locales.boss_gas_station_fuel_price, value = "$"..now_fuel_price.."/L"},
				{label = Config.Locales.boss_gas_station_max_fuel_price, value = "$"..Config.Fuel_Max_Price.."/L"},
            }
        },
        {
			icon = "fa fa-dollar",
            title = Config.Locales.bossm_new_petrol_can_price,
			arrow = true,
            onSelect = function(args)
			local input = lib.inputDialog(Config.Locales.bossm_new_petrol_can_price, {Config.Locales.boss_bossm_price_desc})

			if not input then return end
			local newprice = tonumber(input[1])
			local what = "petrol_can"
			TriggerServerEvent('hyon_gas_station:update_prices', closest_stat, what, newprice)
            end,
			metadata = {
                {label = Config.Locales.boss_gas_station_can_price, value = "$"..now_can_price},
				{label = Config.Locales.boss_gas_station_max_can_price, value = "$"..Config.Petrol_Can_Max_Price},
            }
        },
        {
			icon = "fa fa-dollar",
            title = Config.Locales.bossm_sell_gas_station,
			disabled = sell_gas_station,
            onSelect = function(args)
			local input = lib.inputDialog(Config.Locales.bossm_sell_gas_station, {Config.Locales.boss_bossm_price_desc})
			
			if not input then return end
			local newprice = tonumber(input[1])
			TriggerServerEvent('hyon_gas_station:sellStation', closest_stat, newprice)
            end,
        },
        {
			icon = "fa fa-dollar",
            title = Config.Locales.bossm_sell_gas_station_cancel,
			disabled = nosell_gas_station,
            onSelect = function(args)
			local newprice = 0
			TriggerServerEvent('hyon_gas_station:sellStation', closest_stat, newprice)
            end,
        },
    },
	    {
        id = 'balance_menu',
        title = Config.Locales.boss_balance_menu,
		menu = 'OpenBossMenu',
        options = {
        {
			icon = "fa fa-dollar",
            title = Config.Locales.boss_gas_station_withdraw,
			description = Config.Locales.boss_gas_station_balancedesc .. " $" .. balance,
            onSelect = function(args)
			local input = lib.inputDialog(Config.Locales.boss_gas_station_withdraw, {Config.Locales.boss_balance_with_dep_amount})
			
			if not input then return end
			local withdraw = tonumber(input[1])
			TriggerServerEvent("hyon_gas_station:withdraw", closest_stat, withdraw)
            end,
        },
        {
			icon = "fa fa-dollar",
            title = Config.Locales.boss_gas_station_deposit,
            onSelect = function(args)
			local input = lib.inputDialog(Config.Locales.boss_gas_station_deposit, {Config.Locales.boss_balance_with_dep_amount})
			
			if not input then return end
			local deposit = tonumber(input[1])
			TriggerServerEvent("hyon_gas_station:deposit", closest_stat, deposit)
            end,
        },
        }
    },
	
		    {
        id = 'stocks_menu',
        title = Config.Locales.boss_stocks_menu,
		menu = 'OpenBossMenu',
        options = {
		{
		 title = Config.Locales.boss_gas_station_fuel_stock,
		 arrow = true,
		 progress = stocks_fuelstockprog,
		onSelect = function(args)
			local input = lib.inputDialog(Config.Locales.boss_fuel_order_title, {Config.Locales.boss_fuel_order_free_cap .. your_free_fuel})
			
			if not input then return end
			fuel_order_amount = tonumber(input[1])
				if balance >= (Config.fuel_import_price*fuel_order_amount) and your_free_fuel >= fuel_order_amount then
				                local truck = GetHashKey('phantom')
                                local trailer = GetHashKey('tanker')
                                RequestModel(truck)
                                while not HasModelLoaded(truck) do Wait(1) end
                                RequestModel(trailer)
                                while not HasModelLoaded(trailer) do Wait(1) end
                                if not IsAnyVehicleNearPoint(spawn_coords.x, spawn_coords.y, spawn_coords.z, 5.0) then
                                    Truck = CreateVehicle(truck, spawn_coords.x, spawn_coords.y, spawn_coords.z, spawn_heading, true, false)
                                    SetVehicleFuelLevel(Truck, 100.0)
                                    Trailer = CreateVehicle(trailer, spawn_coords.x, spawn_coords.y, spawn_coords.z, spawn_heading, true, false)
                                    AttachVehicleToTrailer(Truck, Trailer, 1.0)
                                end
								fuel_mission = math.random(1, #Config.Fuel_Missions)
								fuel_task = 1
								station_mission = your_stat
                                SetModelAsNoLongerNeeded(truck)
                                SetModelAsNoLongerNeeded(trailer)
				elseif balance < (Config.fuel_import_price*fuel_order_amount) then
				TriggerEvent("ESX:Notify", "error", 3000, Config.Locales.boss_balance_low)
				elseif your_free_fuel < fuel_order_amount then
				TriggerEvent("ESX:Notify", "error", 3000, Config.Locales.boss_free_space_low)
				end
         end,
		metadata = {
                {label = Config.Locales.boss_gas_station_fuel_stock, value = stocks_fuel},
				{label = Config.Locales.boss_gas_station_max_fuel_stock, value = stocks_fuel_max},
        }
		},
		{
		 title = Config.Locales.boss_gas_station_can_stock,
		arrow = true,
		 progress = stocks_canstockprog,
		onSelect = function(args)
		local input = lib.inputDialog(Config.Locales.boss_can_order_title, {Config.Locales.boss_can_order_free_cap .. your_free_can})
			
		if not input then return end
		can_order_amount = tonumber(input[1])
				if balance >= (Config.can_import_price*can_order_amount) and your_free_can >= can_order_amount then
				
				    local truck = GetHashKey('youga2')
				    RequestModel(truck)
				    while not HasModelLoaded(truck) do Wait(1) end
				    if not IsAnyVehicleNearPoint(spawn_coords.x, spawn_coords.y, spawn_coords.z, 5.0) then
				        Truck = CreateVehicle(truck, spawn_coords.x, spawn_coords.y, spawn_coords.z, spawn_heading, true, false)
				        SetVehicleFuelLevel(Truck, 100.0)
				    end
				    --fuel_mission = math.random(1, #Config.Fuel_Missions)
				    can_task = 1
				    station_mission = your_stat
				    SetModelAsNoLongerNeeded(truck)

				elseif balance < (Config.can_import_price*can_order_amount) then
				TriggerEvent("ESX:Notify", "error", 3000, Config.Locales.boss_balance_low)
				elseif your_free_can < can_order_amount then
				TriggerEvent("ESX:Notify", "error", 3000, Config.Locales.boss_free_space_low)
				end
        end,
		metadata = {
                {label = Config.Locales.boss_gas_station_can_stock, value = stocks_can},
				{label = Config.Locales.boss_gas_station_max_can_stock, value = stocks_can_max},
        }
		},
        }
    }
	
})
lib.showContext('OpenBossMenu')
end


local fuelmenu_price = 0
local fuelmenu_cap = 0.1
function fuelmenu_owner(nearpump)

local pump = nearpump
local player = PlayerPedId()
local petrol_can = GetHashKey("WEAPON_PETROLCAN")
local pedWeapon = GetSelectedPedWeapon(player)
fuelmenu_pric = GasStations[closest_stat].fuel_price
fuelmenu_cap = ((GasStations[closest_stat].capacity/GasStations[closest_stat].max_capacity)*100)+0.01
local refillCost = Round(fuelmenu_pric * (1 - GetAmmoInPedWeapon(ped, 883325847) / 4500))
local refillamount = Round(1 - GetAmmoInPedWeapon(ped, 883325847) / 4500)
				for i=1, #PlayerData.accounts, 1 do
					if PlayerData.accounts[i].name == 'money' then
						currentCash = PlayerData.accounts[i].money
						break
					end
				end
lib.registerContext({
    id = 'OpenFuelMenuOwner',
    title = Config.Locales.fuel_menu_title,
    onExit = function()
    end,
    options = {
		{
            title = Config.Locales.fuel_menu_price .. "$" .. fuelmenu_pric .. "/L",
        },
		{
		 title = Config.Locales.fuel_menu_fuelcap,
		 progress = fuelmenu_cap,
		},
        {
			icon = "fa fa-dollar",
            title = Config.Locales.fuel_car,
			arrow = true,
            onSelect = function(args)
			if not Hose.active then
			grabNozzleFromPump(pump)
			end
			end,
        },
        {
			icon = "fa fa-dollar",
            title = Config.Locales.fuel_can,
			arrow = true,
            onSelect = function(args)
			if Config.ox_inventory == true then
				if pedWeapon == petrol_can then
				TriggerServerEvent('hyon_gas_station:petrol_can_up', closest_stat)
				else
				TriggerEvent("ESX:Notify", "error", 3000, Config.Locales.no_petrol_can_hand)
				end
			else
				if HasPedGotWeapon(player, 883325847) then
					if refillCost > 0 then
						if currentCash >= refillCost then
							TriggerServerEvent('hyon_gas_station:payForFuel', closest_stat, refillamount)
							SetPedAmmo(ped, 883325847, 4500)
						else
						TriggerEvent("ESX:Notify", "error", 3000, Config.Locales.lowmoney)
						end
					end
				else
				TriggerEvent("ESX:Notify", "error", 3000, Config.Locales.no_petrol_can_hand)
				end
			end
            end,
        },
    },
})
lib.showContext('OpenFuelMenuOwner')
end

function fuelmenu_noowner(nearpump)

local pump = nearpump
local player = PlayerPedId()
local petrol_can = GetHashKey("WEAPON_PETROLCAN")
local pedWeapon = GetSelectedPedWeapon(player)
local refillCost = Round(Config.Fuel_Price * (1 - GetAmmoInPedWeapon(ped, 883325847) / 4500))
local refillamount = Round(1 - GetAmmoInPedWeapon(ped, 883325847) / 4500)
				for i=1, #PlayerData.accounts, 1 do
					if PlayerData.accounts[i].name == 'money' then
						currentCash = PlayerData.accounts[i].money
						break
					end
				end
lib.registerContext({
    id = 'OpenFuelMenunoOwner',
    title = Config.Locales.fuel_menu_title,
    onExit = function()
    end,
    options = {
		{
            title = Config.Locales.fuel_menu_price .. "$" .. Config.Fuel_Price .. "/L",
        },
        {
			icon = "fa fa-dollar",
            title = Config.Locales.fuel_car,
			arrow = true,
            onSelect = function(args)
			if not Hose.active then
			grabNozzleFromPump(pump)
			end
			end,
        },
        {
			icon = "fa fa-dollar",
            title = Config.Locales.fuel_can,
			arrow = true,
            onSelect = function(args)
			if Config.ox_inventory == true then
				if pedWeapon == petrol_can then
				TriggerServerEvent('hyon_gas_station:petrol_can_up', closest_stat)
				else
				TriggerEvent("ESX:Notify", "error", 3000, Config.Locales.no_petrol_can_hand)
				end
			else
				if HasPedGotWeapon(player, 883325847) then
					if refillCost > 0 then
						if currentCash >= refillCost then
							TriggerServerEvent('hyon_gas_station:payForFuel', closest_stat, refillamount)
							SetPedAmmo(ped, 883325847, 4500)
						else
						TriggerEvent("ESX:Notify", "error", 3000, Config.Locales.lowmoney)
						end
					end
				else
				TriggerEvent("ESX:Notify", "error", 3000, Config.Locales.no_petrol_can_hand)
				end
			end
            end,
        },
    },
})
lib.showContext('OpenFuelMenunoOwner')
end


local distance_now = 100
local x = nil
local y = nil
local z = nil	
Citizen.CreateThread(function()
while true do
local wait = 1000
local player_ped = PlayerPedId()
local player_coord = GetEntityCoords(player_ped)
local vehicle_mission = GetEntityModel(GetVehiclePedIsIn(player_ped, false))
	if fuel_task == 1 then
	local distance = #(Config.Fuel_Missions[fuel_mission].coords - player_coord)
	distance_now = distance
		if fuel_mission_blip == nil then
        fuel_mission_blip = AddBlipForCoord(Config.Fuel_Missions[fuel_mission].coords.x, Config.Fuel_Missions[fuel_mission].coords.y, Config.Fuel_Missions[fuel_mission].coords.z)
        SetBlipSprite(fuel_mission_blip, 1)
        SetBlipDisplay(fuel_mission_blip, 4)
        SetBlipScale(fuel_mission_blip, 0.75)
        SetBlipColour(fuel_mission_blip, 5)
        SetBlipAsShortRange(fuel_mission_blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Fuel Mission")
        EndTextCommandSetBlipName(fuel_mission_blip)
		SetNewWaypoint(Config.Fuel_Missions[fuel_mission].coords.x,Config.Fuel_Missions[fuel_mission].coords.y)
		end
		x = Config.Fuel_Missions[fuel_mission].coords.x
		y = Config.Fuel_Missions[fuel_mission].coords.y
		z = Config.Fuel_Missions[fuel_mission].coords.z
		if distance < 4 then
		wait = 100
			if IsControlPressed(0,38) then
			distance_now = 100
			wait = 5
			FreezeEntityPosition(player_ped,true)
			FreezeEntityPosition(GetVehiclePedIsIn(player_ped, false),true)
				if vehicle_mission == GetHashKey('phantom') then
				local price_now = Config.fuel_import_price * fuel_order_amount
				RemoveBlip(fuel_mission_blip)
				fuel_mission_blip = nil
				fuel_task = 2
				lib.hideTextUI()
				misson_fuel_text = false
				if lib.progressBar({
					duration = 10000,
					label = Config.Locales.mission_refuel_progbar,
					useWhileDead = false,
					canCancel = false,
					disable = {
						car = false,
					},
					}) then
					trailer_level = fuel_order_amount					
					FreezeEntityPosition(player_ped,false)
					FreezeEntityPosition(GetVehiclePedIsIn(player_ped, false),false)
					TriggerServerEvent("hyon_gas_station:balanceremove", station_mission, price_now)
					end
				else
				TriggerEvent("ESX:Notify", "error", 3000, Config.Locales.mission_notruck)
				end
			end
		end
	elseif fuel_task == 2 then
		local distance2 = #(Config.GasStations[station_mission].vehicle_coord.coords - player_coord)
		distance_now = distance2
		if fuel_mission_blip == nil then
	    fuel_mission_blip = AddBlipForCoord(Config.GasStations[station_mission].vehicle_coord.coords.x, Config.GasStations[station_mission].vehicle_coord.coords.y, Config.GasStations[station_mission].vehicle_coord.coords.z)
        SetBlipSprite(fuel_mission_blip, 1)
        SetBlipDisplay(fuel_mission_blip, 4)
        SetBlipScale(fuel_mission_blip, 0.75)
        SetBlipColour(fuel_mission_blip, 5)
        SetBlipAsShortRange(fuel_mission_blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Your Gas Station")
        EndTextCommandSetBlipName(fuel_mission_blip)
		SetNewWaypoint(Config.GasStations[station_mission].vehicle_coord.coords.x,Config.GasStations[station_mission].vehicle_coord.coords.y)
		end
		x = Config.GasStations[station_mission].vehicle_coord.coords.x
		y = Config.GasStations[station_mission].vehicle_coord.coords.y
		z = Config.GasStations[station_mission].vehicle_coord.coords.z
			if distance2 < 4 then
			wait = 100
			if IsControlPressed(0,38) then
			distance_now = 100
			wait = 5
			FreezeEntityPosition(player_ped,true)
			FreezeEntityPosition(GetVehiclePedIsIn(player_ped, false),true)
				if vehicle_mission == GetHashKey('phantom') then
				RemoveBlip(fuel_mission_blip)
				fuel_mission_blip = nil
				fuel_task = 0
				lib.hideTextUI()
				misson_fuel_text = false
				if lib.progressBar({
					duration = 10000,
					label = Config.Locales.mission_fillup_progbar,
					useWhileDead = false,
					canCancel = false,
					disable = {
						car = false,
					},
					}) then
					trailer_level = fuel_order_amount					
					FreezeEntityPosition(player_ped,false)
					FreezeEntityPosition(GetVehiclePedIsIn(player_ped, false),false)
					DeleteVehicle(GetVehiclePedIsIn(player_ped, false))
					TriggerServerEvent("hyon_gas_station:missionupdateLevel", station_mission, fuel_order_amount)
					end
				else
				TriggerEvent("ESX:Notify", "error", 3000, Config.Locales.mission_notruck)
				end
			end
		end
	else
	fuel_mission_blip = nil
	end
	Citizen.Wait(wait)
end
end)

Citizen.CreateThread(function()
while true do
local wait = 1000
local player_ped = PlayerPedId()
local player_coord = GetEntityCoords(player_ped)
local vehicle_mission = GetEntityModel(GetVehiclePedIsIn(player_ped, false))

	if can_task == 1 then
	local distance = #(Config.Petrol_Can_Mission.coords - player_coord)
	distance_now = distance
		if can_mission_blip == nil then
        can_mission_blip = AddBlipForCoord(Config.Petrol_Can_Mission.coords.x, Config.Petrol_Can_Mission.coords.y, Config.Petrol_Can_Mission.coords.z)
        SetBlipSprite(can_mission_blip, 1)
        SetBlipDisplay(can_mission_blip, 4)
        SetBlipScale(can_mission_blip, 0.75)
        SetBlipColour(can_mission_blip, 5)
        SetBlipAsShortRange(can_mission_blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Petrol Can Mission")
        EndTextCommandSetBlipName(can_mission_blip)
		SetNewWaypoint(Config.Petrol_Can_Mission.coords.x,Config.Petrol_Can_Mission.coords.y)
		end
		x = Config.Petrol_Can_Mission.coords.x
		y = Config.Petrol_Can_Mission.coords.y
		z = Config.Petrol_Can_Mission.coords.z
		if distance < 2 then
		wait = 100
			if IsControlPressed(0,38) then
			if vehicle_mission == 0 then
			distance_now = 100
			wait = 5
			FreezeEntityPosition(player_ped,true)
				local price_now = Config.can_import_price * can_order_amount
				RemoveBlip(can_mission_blip)
				can_mission_blip = nil
				lib.hideTextUI()
				misson_can_text = false
				if lib.progressBar({
					duration = 2000,
					label = Config.Locales.mission_can_progbar_npc,
					useWhileDead = false,
					canCancel = false,
					disable = {
						car = true,
					},
					}) then
					can_task = 2
					
					FreezeEntityPosition(player_ped,false)
					TriggerServerEvent("hyon_gas_station:balanceremove", station_mission, price_now)
					RequestAnimDict('anim@heists@box_carry@')
					while not HasAnimDictLoaded('anim@heists@box_carry@') do
						Citizen.Wait(10)
					end
					TaskPlayAnim(player_ped, 'anim@heists@box_carry@', 'idle', 4.0, 1.0, -1, 49, 0, 0, 0, 0)
					RemoveAnimDict('anim@heists@box_carry@')

					local propHash = GetHashKey('hei_prop_heist_box')
					RequestModel(propHash)
					while not HasModelLoaded(propHash) do
						Citizen.Wait(10)
					end

					local x1, y2, z3 = table.unpack(GetEntityCoords(player_ped))
					can_mission_entity = CreateObject(propHash, x1, y2, z3 + 0.2, true, true, true)
					AttachEntityToEntity(can_mission_entity, player_ped, GetPedBoneIndex(player_ped, 60309), 0.025, 0.08, 0.255, -145.0, 290.0, 0.0, true, true, false, true, 1, true)
					SetModelAsNoLongerNeeded(propHash)
					TriggerEvent("ESX:Notify", "success", 3000, Config.Locales.mission_can_set_in_car)
					end
			else
			TriggerEvent("ESX:Notify", "error", 3000, Config.Locales.mission_can_in_car)
			end
		end
	end
	end
	if can_task == 2 then

	local player_co = GetEntityCoords(player_ped)
	local clos_veh = GetEntityModel(GetClosestVehicle(player_co, 4.0, 0, 127))
	local veh_clos =  GetClosestVehicle(player_co, 4.0, 0, 127)
		if clos_veh == GetHashKey('youga2') then

			local closveh_coord = GetEntityCoords(veh_clos)
			local distance2 = #(closveh_coord - player_coord)
			x = closveh_coord.x
			y = closveh_coord.y
			z = closveh_coord.z
			distance_now = distance2
			if distance2 < 4 then

				wait = 100
				if IsControlPressed(0,38) then
					distance_now = 100
					ClearPedTasks(player_ped)
					DeleteEntity(can_mission_entity)
					can_task = 3
					lib.hideTextUI()
					misson_can_text = false
				end
			end
		end
	end
	if can_task == 3 then
		local distance3 = #(Config.GasStations[station_mission].vehicle_coord.coords - player_coord)
		distance_now = distance3
		if can_mission_blip == nil then
	    can_mission_blip = AddBlipForCoord(Config.GasStations[station_mission].vehicle_coord.coords.x, Config.GasStations[station_mission].vehicle_coord.coords.y, Config.GasStations[station_mission].vehicle_coord.coords.z)
        SetBlipSprite(can_mission_blip, 1)
        SetBlipDisplay(can_mission_blip, 4)
        SetBlipScale(can_mission_blip, 0.75)
        SetBlipColour(can_mission_blip, 5)
        SetBlipAsShortRange(can_mission_blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Your Gas Station")
        EndTextCommandSetBlipName(can_mission_blip)
		SetNewWaypoint(Config.GasStations[station_mission].vehicle_coord.coords.x,Config.GasStations[station_mission].vehicle_coord.coords.y)
		end
		x = Config.GasStations[station_mission].vehicle_coord.coords.x
		y = Config.GasStations[station_mission].vehicle_coord.coords.y
		z = Config.GasStations[station_mission].vehicle_coord.coords.z
		if distance3 < 4 then
			wait = 100
			if IsControlPressed(0,38) then
			distance_now = 100
			wait = 5
				if vehicle_mission == GetHashKey('youga2') then
				RemoveBlip(can_mission_blip)
				can_mission_blip = nil
				can_task = 0
				lib.hideTextUI()
				misson_can_text = false
					DeleteVehicle(GetVehiclePedIsIn(player_ped, false))
					TriggerServerEvent("hyon_gas_station:missionupdatecan", station_mission, can_order_amount)
				else
				TriggerEvent("ESX:Notify", "error", 3000, Config.Locales.mission_notruck)
				end
			end
		end

	end
	Citizen.Wait(wait)
end
end)

Citizen.CreateThread(function()
local wait = 1000
while  true do
	if fuel_task == 1 and distance_now < 40 then
	wait = 5
	DrawMarker(39, x, y, z , -1, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 100, false, true, 2, true, false, false, false)
	if distance_now < 4 and misson_fuel_text == false then
	misson_fuel_text = true
	text_ui()
	elseif distance_now > 4 then
	misson_fuel_text = false
	lib.hideTextUI()
	end
	if IsControlPressed(0,38) then
	misson_fuel_text = false
	lib.hideTextUI()
	end
elseif fuel_task == 2 and distance_now < 40 then
	wait = 5
	DrawMarker(39, x, y, z , -1, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 100, false, true, 2, true, false, false, false)
	if distance_now < 4 and misson_fuel_text == false then
	misson_fuel_text = true
	text_ui2()
	elseif distance_now > 4 then
	misson_fuel_text = false
	lib.hideTextUI()
	end
	if IsControlPressed(0,38) then
	misson_fuel_text = false
	lib.hideTextUI()

	end
end
if can_task == 1 and distance_now < 40 then
	wait = 5
	DrawMarker(0, x, y, z , -1, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 100, false, true, 2, true, false, false, false)
	if distance_now < 2 and misson_fuel_text == false then
	misson_can_text = true
	text_ui3()
	elseif distance_now > 2 then
	misson_can_text = false
	lib.hideTextUI()
	end
	if IsControlPressed(0,38) then
	misson_can_text = false
	lib.hideTextUI()
	end
elseif can_task == 2 and distance_now < 40 then
	wait = 5
	DrawMarker(0, x, y, z , -1, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 100, false, true, 2, true, false, false, false)
	if distance_now < 4 and misson_can_text == false then
	misson_can_text = true
	text_ui4()
	elseif distance_now > 4 then
	misson_can_text = false
	lib.hideTextUI()
	end
	if IsControlPressed(0,38) then
	misson_can_text = false
	lib.hideTextUI()
	end
elseif can_task == 3 and distance_now < 40 then
	wait = 5
	DrawMarker(0, x, y, z , -1, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 100, false, true, 2, true, false, false, false)
	if distance_now < 4 and misson_can_text == false then
	misson_can_text = true
	text_ui5()
	elseif distance_now > 4 then
	misson_can_text = false
	lib.hideTextUI()
	end
	if IsControlPressed(0,38) then
	misson_can_text = false
	lib.hideTextUI()
	end
end
Citizen.Wait(wait)
end
end)

function text_ui()
lib.showTextUI(Config.Locales.mission_refuel_trailer, {
    position = "right-center",
    icon = "fa fa-gas-pump",
    style = {
        borderRadius = 10,
        backgroundColor = '#00a2ff',
        color = 'white'
    }
})
end
function text_ui2()
lib.showTextUI(Config.Locales.mission_fillup_station, {
    position = "right-center",
    icon = "fa fa-gas-pump",
    style = {
        borderRadius = 10,
        backgroundColor = '#00a2ff',
        color = 'white'
    }
})
end

function text_ui3()
lib.showTextUI(Config.Locales.mission_can_get_box, {
    position = "right-center",
    icon = "fa fa-gas-pump",
    style = {
        borderRadius = 10,
        backgroundColor = '#00a2ff',
        color = 'white'
    }
})
end

function text_ui4()
lib.showTextUI(Config.Locales.mission_can_put_in, {
    position = "right-center",
    icon = "fa fa-gas-pump",
    style = {
        borderRadius = 10,
        backgroundColor = '#00a2ff',
        color = 'white'
    }
})
end

function text_ui5()
lib.showTextUI(Config.Locales.mission_can_finish, {
    position = "right-center",
    icon = "fa fa-gas-pump",
    style = {
        borderRadius = 10,
        backgroundColor = '#00a2ff',
        color = 'white'
    }
})
end

	local displayHud = false
	local x = 0.01135
	local y = 0.002
Citizen.CreateThread(function()
		while true do
		local wait = 2000
			local ped = PlayerPedId()

			if IsPedInAnyVehicle(ped)	and fuel_task > 0 then
				local vehicle = GetVehiclePedIsIn(ped)


				displayHud = true
			else
				displayHud = false
			end

			Citizen.Wait(wait)
		end
	end)

Citizen.CreateThread(function()
	local function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
		SetTextFont(font)
		SetTextProportional(0)
		SetTextScale(sc, sc)
		N_0x4e096588b13ffeca(jus)
		SetTextColour(r, g, b, a)
		SetTextDropShadow(0, 0, 0, 0,255)
		SetTextEdge(1, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		AddTextComponentString(text)
		DrawText(x - 0.1+w, y - 0.02+h)
	end
		while true do
		local wait = 1500
		
			if displayHud then
			wait = 3
				if Config.HUD == true then
				DrawAdvancedText(0.200 - x, 0.7565 - y, 0.005, 0.0028, 0.4, "Trailer Fuel Level:  " .. trailer_level .. " L", 0, 162, 255, 255, 7, 1)
				else
				DrawAdvancedText(0.11 - x, 0.7565 - y, 0.005, 0.0028, 0.4, "Trailer Fuel Level:  " .. trailer_level .. " L", 0, 162, 255, 255, 7, 1)
				end
			end

			Citizen.Wait(wait)
		end
	end)


if Config.HUD then
	local function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
		SetTextFont(font)
		SetTextProportional(0)
		SetTextScale(sc, sc)
		N_0x4e096588b13ffeca(jus)
		SetTextColour(r, g, b, a)
		SetTextDropShadow(0, 0, 0, 0,255)
		SetTextEdge(1, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		AddTextComponentString(text)
		DrawText(x - 0.1+w, y - 0.02+h)
	end

	local mph = 0
	local kmh = 0
	local fuel = 0
	local displayHud = false

	local x = 0.01135
	local y = 0.002

	Citizen.CreateThread(function()
		while true do
			local ped = PlayerPedId()

			if IsPedInAnyVehicle(ped) and not (Config.RemoveHUDForBlacklistedVehicle and inBlacklisted) then
				local vehicle = GetVehiclePedIsIn(ped)
				local speed = GetEntitySpeed(vehicle)

				mph = tostring(math.ceil(speed * 2.236936))
				kmh = tostring(math.ceil(speed * 3.6))
				fuel = tostring(math.ceil(GetFuel(vehicle)))

				displayHud = true
			else
				displayHud = false

				Citizen.Wait(500)
			end

			Citizen.Wait(50)
		end
	end)

	Citizen.CreateThread(function()
		while true do
			if displayHud then
			--	DrawAdvancedText(0.130 - x, 0.77 - y, 0.005, 0.0028, 0.6, mph, 255, 255, 255, 255, 6, 1)
			--	DrawAdvancedText(0.174 - x, 0.77 - y, 0.005, 0.0028, 0.6, kmh, 255, 255, 255, 255, 6, 1)
			--	DrawAdvancedText(0.2195 - x, 0.77 - y, 0.005, 0.0028, 0.6, fuel, 255, 255, 255, 255, 6, 1)
			if Config.KMhorMPh == "mph" then
				DrawAdvancedText(0.11 - x, 0.7365 - y, 0.005, 0.0028, 0.4, "Speed:  " .. mph .. "/mph", 0, 162, 255, 255, 7, 1)
			end
			if Config.KMhorMPh == "kmh" then
				DrawAdvancedText(0.11 - x, 0.7365 - y, 0.005, 0.0028, 0.4, "Speed:  " .. kmh .. "/kmh", 0, 162, 255, 255, 7, 1)
			end
				DrawAdvancedText(0.11 - x, 0.7565 - y, 0.005, 0.0028, 0.4, "Fuel Level:  " .. fuel .. " L", 0, 162, 255, 255, 7, 1)
			else
				Citizen.Wait(750)
			end

			Citizen.Wait(0)
		end
	end)
end