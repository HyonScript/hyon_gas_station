
Config = {}

Config.ox_inventory = true -- Use Ox Inventory true/false

Config.Blips = true -- show gas station blips true / false

Config.HUD = true -- show hud true / false

Config.KMhorMPh = "kmh" -- "kmh" or "mph" if Config.HUD = true

Config.NPC = "a_m_m_genfat_02"

Config.Fuel_Price = 1.5 -- Default Fuel Price / liter

Config.Gas_Station_Price = 100000 -- Default Gas Station Price

Config.Petrol_Can_Price = 50 -- Default Petrol Can price (empty)

Config.Fuel_Max_Price = 10 -- Max price of Fuel

Config.Petrol_Can_Max_Price = 10 -- Max price of Empty Petrol Can 

Config.fuel_import_price = 3  -- Fuel Price for Gas Station Owner

Config.can_import_price = 5 -- Petrol Can Price for Gas Station Owner

Config.Levels = {
	{
	Level = 1,
	Fuel_Capacity = 10000,
	Petrol_Can_Stock = 20,
	},
	{
	Level = 2,
	Price = 200000,
	Fuel_Capacity = 20000,
	Petrol_Can_Stock = 40,
	},
	{
	Level = 3,
	Price = 300000,
	Fuel_Capacity = 30000,
	Petrol_Can_Stock = 60,
	},
	{
	Level = 4,
	Price = 400000,
	Fuel_Capacity = 40000,
	Petrol_Can_Stock = 80,
	},
	{
	Level = 5,
	Price = 500000,
	Fuel_Capacity = 50000,
	Petrol_Can_Stock = 100,
	},
}

Config.fueluse = { -- per rpm
	[1.0] = 1.4,
	[0.9] = 1.2,
	[0.8] = 1.0,
	[0.7] = 0.9,
	[0.6] = 0.8,
	[0.5] = 0.7,
	[0.4] = 0.5,
	[0.3] = 0.4,
	[0.2] = 0.2,
	[0.1] = 0.1,
	[0.0] = 0.0,
}

Config.refuel_speed = 0.5 -- refuel speed


Config.Fuel_Missions = {  -- fuel missions
{coords = vec3(2726.04,1412.92,24.4), heading = 279.64},
{coords = vec3(260.64,-3020.84,5.76), heading = 167.88},
{coords = vec3(538.32,-2306.12,5.88), heading = 275.96},
{coords = vec3(2912.36,4381.12,50.32), heading = 211.72},
}

Config.Petrol_Can_Mission = {coords = vec3(-9.92,-1092.36,26.68), heading = 65.44} -- petrol can mission

Config.GasStations = {
--1
	{
	coords = vec3(-2555.12,2333.88,33.08),
	npc_coord = {coords = vector3(-2555.72,2315.84,33.2), heading = 8.88},
	vehicle_coord = {coords = vector3(-2533.72,2346.64,33.04), heading = 33.76},
	},
--2
	{
	coords = vec3(-319.6,-1471.6,30.56),
	npc_coord = {coords = vector3(-327.16,-1476.56,30.56), heading = 284.08},
	vehicle_coord = {coords = vector3(-303.48,-1482.0,30.4), heading = 354.68},
	},
--3
	{
	coords = vec3(1701.04,6420.92,32.64),
	npc_coord = {coords = vector3(1709.16,6424.04,32.76), heading = 158.12},
	vehicle_coord = {coords = vector3(1715.08,6414.36,33.28), heading = 159.4},
	},
--4
	{
	coords = vec3(2573.84,362.08,108.48),
	npc_coord = {coords = vector3(2561.6,367.0,108.64), heading = 268.76},
	vehicle_coord = {coords = vector3(2595.64,358.08,108.44), heading = 354.72},
	},
--5	
	{
	coords = vec3(-715.64,-934.04,19.2),
	npc_coord = {coords = vector3(-704.72,-933.92,19.2), heading = 94.64},
	vehicle_coord = {coords = vector3(-707.88,-929.24,19.0), heading = 0.12},
	},
--6	
	{
	coords = vec3(180.4,6605.2,32.04),
	npc_coord = {coords = vector3(207.28,6605.8,31.72), heading = 103.44},
	vehicle_coord = {coords = vector3(200.6,6606.72,31.68), heading = 181.96},
	},
--7	
	{
	coords = vec3(-1438.28,-276.2,46.2),
	npc_coord = {coords = vector3(-1422.56,-276.24,46.28), heading = 116.6},
	vehicle_coord = {coords = vector3(-1419.08,-284.64,46.24), heading = 127.4},
	},
--8	
	{
	coords = vec3(1687.12,4929.04,42.08),
	npc_coord = {coords = vector3(1696.24,4926.16,42.24), heading = 49.72},
	vehicle_coord = {coords = vector3(1678.16,4926.88,42.04), heading = 49.76},
	},
--9	
	{
	coords = vec3(1178.04,-325.4,69.16),
	npc_coord = {coords = vector3(1167.64,-321.96,69.28), heading = 277.2},
	vehicle_coord = {coords = vector3(1184.92,-313.96,69.16), heading = 278.2},
	},
--10
	{
	coords = vec3(173.04,-1561.24,29.24),
	npc_coord = {coords = vector3(173.88,-1548.44,29.28), heading = 222.88},
	vehicle_coord = {coords = vector3(190.16,-1559.52,29.24), heading = 214.8},
	},
--11	
	{
	coords = vec3(1042.2,2669.12,39.56),
	npc_coord = {coords = vector3(1050.16,2662.96,39.56), heading = 359.6},
	vehicle_coord = {coords = vector3(1057.08,2669.8,39.56), heading = 358.08},
	},
--12	
	{
	coords = vec3(49.8,2780.04,57.88),
	npc_coord = {coords = vector3(49.6,2787.16,57.88), heading = 139.0},
	vehicle_coord = {coords = vector3(60.2,2773.68,57.88), heading = 142.0},
	},
--13
	{
	coords = vec3(-1807.84,798.52,138.52),
	npc_coord = {coords = vector3(-1819.24,797.76,138.16), heading = 313.08},
	vehicle_coord = {coords = vector3(-1807.36,818.16,138.76), heading = 312.8},
	},
--14
	{
	coords = vec3(2680.2,3267.32,55.24),
	npc_coord = {coords = vector3(2677.88,3274.08,55.4), heading = 237.48},
	vehicle_coord = {coords = vector3(2679.96,3247.6,55.24), heading = 157.0},
	},
--15
	{
	coords = vec3(1208.84,-1402.32,35.24),
	npc_coord = {coords = vector3(1211.24,-1389.2,35.36), heading = 176.32},
	vehicle_coord = {coords = vector3(1197.56,-1400.84,35.24), heading = 181.64},
	},
--16	
	{
	coords = vec3(815.12,-1028.84,26.28),
	npc_coord = {coords = vector3(821.96,-1040.08,26.76), heading = 359.04},
	vehicle_coord = {coords = vector3(807.68,-1041.32,26.56), heading = 177.96},
	},
--17
	{
	coords = vec3(1783.84,3330.08,41.24),
	npc_coord = {coords = vector3(1777.56,3326.56,41.44), heading = 298.76},
	vehicle_coord = {coords = vector3(1786.68,3317.68,41.56), heading = 205.76},
	},
--18	
	{
	coords = vec3(-525.08,-1214.4,18.2),
	npc_coord = {coords = vector3(-529.16,-1220.88,18.44), heading = 334.28},
	vehicle_coord = {coords = vector3(-511.76,-1207.84,18.56), heading = 334.52},
	},
--19
	{
	coords = vec3(-2088.44,-318.32,13.04),
	npc_coord = {coords = vector3(-2074.08,-318.56,13.32), heading = 88.32},
	vehicle_coord = {coords = vector3(-2091.8,-303.84,13.04), heading = 82.84},
	},
--20	
	{
	coords = vec3(263.92,2605.76,44.88),
	npc_coord = {coords = vector3(267.84,2599.24,44.72), heading = 4.2},
	vehicle_coord = {coords = vector3(260.88,2613.84,44.84), heading = 267.44},
	},
--21	
	{
	coords = vec3(2537.32,2593.16,37.96),
	npc_coord = {coords = vector3(2539.4,2603.48,37.96), heading = 102.52},
	vehicle_coord = {coords = vector3(2534.4,2587.48,37.96), heading = 1.32},
	},
--22
	{
	coords = vec3(629.52,268.72,103.08),
	npc_coord = {coords = vector3(643.6,264.44,103.28), heading = 60.8},
	vehicle_coord = {coords = vector3(632.04,281.6,103.12), heading = 61.76},
	},
--23
	{
	coords = vec3(1206.32,2660.8,37.88),
	npc_coord = {coords = vector3(1201.56,2655.04,37.84), heading = 314.08},
	vehicle_coord = {coords = vector3(1211.44,2670.56,37.76), heading = 3.6},
	},
--24	
	{
	coords = vec3(2007.96,3776.04,32.4),
	npc_coord = {coords = vector3(2003.0,3780.48,32.2), heading = 208.84},
	vehicle_coord = {coords = vector3(1990.68,3772.8,32.2), heading = 223.24},
	},
--25
	{
	coords = vec3(273.96,-1260.24,29.28),
	npc_coord = {coords = vector3(287.64,-1259.52,29.44), heading = 93.04},
	vehicle_coord = {coords = vector3(279.36,-1246.4,29.2), heading = 80.76},
	},
--26	
	{
	coords = vec3(-95.36,6418.84,31.48),
	npc_coord = {coords = vector3(-92.24,6412.28,31.64), heading = 42.52},
	vehicle_coord = {coords = vector3(-106.68,6410.0,31.48), heading = 33.96},
	},
--27	
	{
	coords = vec3(-61.88,-1762.8,29.28),
	npc_coord = {coords = vector3(-53.36,-1770.4,29.16), heading = 48.96},
	vehicle_coord = {coords = vector3(-70.2,-1746.68,29.48), heading = 341.08},
	},
}

Config.PumpModels = {
	'prop_vintage_pump',
	'prop_gas_pump_old2',
	'prop_gas_pump_old3',
	'prop_gas_pump_1a',
	'prop_gas_pump_1c',
	'prop_gas_pump_1b',
	'prop_gas_pump_1d',
}

Config.Usage = { -- per rpm
	[1.0] = 0.1,
	[0.9] = 0.09,
	[0.8] = 0.085,
	[0.7] = 0.07,
	[0.6] = 0.055,
	[0.5] = 0.04,
	[0.4] = 0.03,
	[0.3] = 0.02,
	[0.2] = 0.015,
	[0.1] = 0.01,
	[0.0] = 0.0,
}

Config.Locales = {
-- Notifies:
	no_space = "You don't have enough free space", 
	bought_gas_station = "You bought a Gas Station!",
	lowcanstock = "Gas Station doesn't have Petrol Can in Stock Now", --???
	lowmoney = "You don't have enough money!",
	no_petrol_can_hand = "You don't have Petrol Can in your hand",
	thanks = "Thank You For Your Purchase", 
	toofar = "You went too far!",
	outoffuel = "Gas Station Fuel Level is to low!",
	fulltank = "Full Tank!",
	nomoney = "No money!",
	boss_balance_low = "Gas Station Balance to low!",
	boss_free_space_low = "Gas Station Free Capacity to low!",
	gas_balance_low = "Gas Station balance is too low",
	can_ammo_low = "Petrol Can LeveL is too low",
	_max_level = "Your Gas Station Level is MAX",


	
--Fuel pump menu
	fuel_menu = "Press ~g~E~s~ to open menu",
	fuel_menu_nofuel = "Ran out of fuel",
	fuel_menu_fuelcap = "Fuel Capacity:",
	fuel_menu_title = "Fuel Menu",
	fuel_menu_price = "Fuel Price : ",
	fuel_car = "Fuel a Car",
	fuel_can = "Fuel a Petrol Can",
	fueling_amount = "~g~Amount: ~y~",
	fueling_price = "~g~Price: ~y~$",
	fueling_nozzle = "Press ~g~E~s~ To Attach Nozzle",
	fueling_level = "~g~Fuel Level:~s~ ~y~",
	fueling_holde = "Hold Pressing ~g~E~s~ To Refuel",
	fueling_cancel = "Press ~r~X~s~ To Grab Nozzle", 
        maxfuelprice = "Max Fuel price:",

-- Petrol Can
	fuel_with_can_nearveh = "Hold Pressing ~g~E~s~ To Refuel",
	fuel_can_veh_level = "Fuel Level: ",

	
--NPC MENU:
	npc = "Press ~g~E~s~ to open menu",

	--Free Gas Station:
	free_gas_station_menu_title = "Gas Station Menu",
	free_gas_station = "Buy Gas Station", 
	free_gas_station_price = "Price: ", 
	free_buy_petrol_can_title = "Buy an empty Petrol Can", 
	free_buy_petrol_can_desc = "Petrol Can Price", 
	
	--Gas Station have an owner
	own_gas_station_title = "Gas Station Menu",
	own_gas_station = "Buy Gas Station", 
	own_gas_station_price = "Price: ",
	own_buy_petrol_can_title = "Buy an empty Petrol Can", 
	own_buy_petrol_can_desc = "Petrol Can Price: $", 
	own_buy_petrol_can_desc_stock = " Stock: ", 
	open_bossmenu_title = "Open Boss menu", 
	
	--Boss menu
	boss_menu_title = "Boss Menu",
	boss_gas_station_id = "Gas Station id",
	boss_gas_station_level = "Current Level",
	boss_gas_station_max_level = "Max",
	boss_gas_station_balance = "Balance",
	boss_gas_station_balancedesc = "Current Balance:",
	boss_gas_station_withdraw = "Withdraw Money",
	boss_gas_station_deposit = "Deposit Money",
	boss_gas_station_fuel_stock = "Fuel Stock",
	boss_gas_station_max_fuel_stock = "Max Fuel Stock",
	boss_gas_station_fuel_price = "Current Fuel Price",
	boss_gas_station_max_fuel_price = "Max Fuel Price",
	boss_gas_station_can_price = "Current Petrol Can Price",
	boss_gas_station_max_can_price = "Max Petrol Can Price",
	boss_gas_station_can_stock = "Petrol Can Stock",
	boss_gas_station_max_can_stock = "Max Petrol Can Stock",
	
	boss_bossm_price_desc = "Price",
	boss_bossm_nextlvl_price = "Next Level Price", 
	boss_bossm_nextlvl_fuelcap = "Next Level Fuel Capacity",
	boss_bossm_nextlvl_cancap = "Next Level Petrol Can Capacity",
	bossm_upgrade_level_title = "Upgrade Gas Station Level",
	bossm_new_fuel_price = "Add New Fuel Price",
	bossm_new_petrol_can_price = "Add New Petrol Can Price",
	bossm_sell_gas_station = "Sell Gas Station",
	bossm_sell_gas_station_cancel = "Cancel for sale",
	boss_balance_menu = "Balance Menu",
	boss_balance_with_dep_amount = "Amount",
	boss_stocks_menu = "Fuel & Petrol Can Stocks Menu",
	boss_fuel_order_title = "Fuel Order",
	boss_fuel_order_free_cap = "Free Capacity: ",
	boss_can_order_title = "Petrol Can Order",
	boss_can_order_free_cap = "Free Capacity: ",
	maxpetrolcanprice = "Max Petrol Can Price: ",
	
	-- Fuel Mission
	mission_refuel_trailer = "Press E To Refuel Your Tanker",
	mission_notruck = "You don't sit in your truck",
	mission_refuel_progbar = "Refueling...",
	mission_fillup_station = "Press E to fill up your Gas Station",
	mission_fillup_progbar = "Filling up the Gas Station...",
	
	--Petrol Can Mission
	mission_can_progbar_npc = "Waiting For Package...",
	mission_can_in_car = "Get out of the car",
	mission_can_set_in_car = "Put the box in your car",
	mission_can_get_box = "Press E To Get Box",
	mission_can_put_in = "Press E To put the box in your car",
	mission_can_finish = "Press E To Fill Up Your Stock"
	
	
}


 -- DONT CHANGE!!!!
Config.FuelDecor = "_FUEL_LEVEL_"
