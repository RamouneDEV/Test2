shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'adamant'
games { 'gta5' }

client_scripts {
    'client/main.lua',
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/main.lua',
}