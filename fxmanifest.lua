fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'mnr_ipl'
description 'Optimized IPL manager, providing efficient loading and unloading of IPLs, entity sets, and zones.'
author 'IlMelons'
version '1.0.0'
repository 'https://github.com/Monarch-Development/mnr_ipl'

this_is_a_map 'yes'

files {
    'config/*.lua',
}

shared_scripts {
    '@ox_lib/init.lua',
}

client_scripts {
    'client/*.lua',
}

server_scripts {
    'server/*.lua',
}