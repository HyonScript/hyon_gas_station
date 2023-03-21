fx_version 'cerulean'
game 'gta5'
name 'hyon_gas_station'
version      '1.0.5'
description 'Gas Stations'

dependencies {
	'es_extended',
	'ox_lib',
}

shared_script {
	'@ox_lib/init.lua',
	'config.lua',
}

client_scripts {
	'@es_extended/imports.lua',
    'client/main.lua'
}

server_scripts {
	'@es_extended/imports.lua',
	'@mysql-async/lib/MySQL.lua',
	'@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}


exports {
	'GetFuel',
	'SetFuel'
}

lua54 'yes'

