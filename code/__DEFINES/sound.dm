//max channel is 1024. Only go lower from here, because byond tends to pick the first available channel to play sounds on
#define CHANNEL_MASTER_VOLUME 1024
#define CHANNEL_LOBBYMUSIC 1023
#define CHANNEL_ADMIN 1022
#define CHANNEL_VOX 1021
#define CHANNEL_JUKEBOX 1020
#define CHANNEL_HEARTBEAT 1019 //sound channel for heartbeats
#define CHANNEL_AMBIENCE 1018
#define CHANNEL_BUZZ 1017
#define CHANNEL_SOUND_EFFECTS 1016
#define CHANNEL_SOUND_FOOTSTEPS 1015
#define CHANNEL_WEATHER 1014
#define CHANNEL_MACHINERY 1013
#define CHANNEL_INSTRUMENTS 1012
#define CHANNEL_MOB_SOUNDS 1011

/// Default range of a sound.
#define SOUND_RANGE 17
#define MEDIUM_RANGE_SOUND_EXTRARANGE -5
/// Default extra range for sounds considered to be quieter
#define SHORT_RANGE_SOUND_EXTRARANGE -9
/// The range deducted from sound range for things that are considered silent / sneaky
#define SILENCED_SOUND_EXTRARANGE -11
/// Percentage of sound's range where no falloff is applied
/// For a normal sound this would be 1 tile of no falloff
#define SOUND_DEFAULT_FALLOFF_DISTANCE 1
/// The default exponent of sound falloff
#define SOUND_FALLOFF_EXPONENT 6

//THIS SHOULD ALWAYS BE THE LOWEST ONE!
//KEEP IT UPDATED

#define CHANNEL_HIGHEST_AVAILABLE 1011

#define MAX_INSTRUMENT_CHANNELS (128 * 6)

#define SOUND_MINIMUM_PRESSURE 10

#define INTERACTION_SOUND_RANGE_MODIFIER -3
#define EQUIP_SOUND_VOLUME 30
#define PICKUP_SOUND_VOLUME 15
#define DROP_SOUND_VOLUME 20
#define BLOCK_SOUND_VOLUME 70

//default byond sound environments
#define SOUND_ENVIRONMENT_OFF -2
#define SOUND_ENVIRONMENT_NONE -1
#define SOUND_ENVIRONMENT_GENERIC 0
#define SOUND_ENVIRONMENT_PADDED_CELL 1
#define SOUND_ENVIRONMENT_ROOM 2
#define SOUND_ENVIRONMENT_BATHROOM 3
#define SOUND_ENVIRONMENT_LIVINGROOM 4
#define SOUND_ENVIRONMENT_STONEROOM 5
#define SOUND_ENVIRONMENT_AUDITORIUM 6
#define SOUND_ENVIRONMENT_CONCERT_HALL 7
#define SOUND_ENVIRONMENT_CAVE 8
#define SOUND_ENVIRONMENT_ARENA 9
#define SOUND_ENVIRONMENT_HANGAR 10
#define SOUND_ENVIRONMENT_CARPETED_HALLWAY 11
#define SOUND_ENVIRONMENT_HALLWAY 12
#define SOUND_ENVIRONMENT_STONE_CORRIDOR 13
#define SOUND_ENVIRONMENT_ALLEY 14
#define SOUND_ENVIRONMENT_FOREST 15
#define SOUND_ENVIRONMENT_CITY 16
#define SOUND_ENVIRONMENT_MOUNTAINS 17
#define SOUND_ENVIRONMENT_QUARRY 18
#define SOUND_ENVIRONMENT_PLAIN 19
#define SOUND_ENVIRONMENT_PARKING_LOT 20
#define SOUND_ENVIRONMENT_SEWER_PIPE 21
#define SOUND_ENVIRONMENT_UNDERWATER 22
#define SOUND_ENVIRONMENT_DRUGGED 23
#define SOUND_ENVIRONMENT_DIZZY 24
#define SOUND_ENVIRONMENT_PSYCHOTIC 25
//If we ever make custom ones add them here
#define SOUND_ENVIROMENT_PHASED list(1.8, 0.5, -1000, -4000, 0, 5, 0.1, 1, -15500, 0.007, 2000, 0.05, 0.25, 1, 1.18, 0.348, -5, 2000, 250, 0, 3, 100, 63)

//"sound areas": easy way of keeping different types of areas consistent.
#define SOUND_AREA_STANDARD_STATION SOUND_ENVIRONMENT_PARKING_LOT
#define SOUND_AREA_LARGE_ENCLOSED SOUND_ENVIRONMENT_QUARRY
#define SOUND_AREA_SMALL_ENCLOSED SOUND_ENVIRONMENT_BATHROOM
#define SOUND_AREA_TUNNEL_ENCLOSED SOUND_ENVIRONMENT_STONEROOM
#define SOUND_AREA_LARGE_SOFTFLOOR SOUND_ENVIRONMENT_CARPETED_HALLWAY
#define SOUND_AREA_MEDIUM_SOFTFLOOR SOUND_ENVIRONMENT_LIVINGROOM
#define SOUND_AREA_SMALL_SOFTFLOOR SOUND_ENVIRONMENT_ROOM
#define SOUND_AREA_ASTEROID SOUND_ENVIRONMENT_CAVE
#define SOUND_AREA_SPACE SOUND_ENVIRONMENT_UNDERWATER
#define SOUND_AREA_LAVALAND SOUND_ENVIRONMENT_MOUNTAINS
#define SOUND_AREA_ICEMOON SOUND_ENVIRONMENT_CAVE
#define SOUND_AREA_WOODFLOOR SOUND_ENVIRONMENT_CITY

/**
 * List of all of our sound keys.
 * Used with /datum/sound_effect as the key.
 * See also 'code\game\sound\sound_keys\sound_keys.dm'
 */
#define SFX_ARCADE "arcade"
#define SFX_BODYFALL "bodyfall"
#define SFX_BODYFALL_MACHINE "bodyfall_machine"
#define SFX_BODYFALL_SKRELL "bodyfall_skrell"
#define SFX_BOTTLE_HIT_BROKEN "bottle_hit_broken"
#define SFX_BOTTLE_HIT_INTACT "bottle_hit_intact"
#define SFX_BREAK_CARDBOARD "break_cardboard"
#define SFX_BREAK_GLASS "break_glass"
#define SFX_BREAK_WOOD "break_wood"
#define SFX_BULLET_MISS "bullet_miss"
#define SFX_BUTTON "button"
#define SFX_CASING_DROP "casing_drop"
#define SFX_CASING_DROP_SHOTGUN "casing_drop_shotgun"
#define SFX_COMPUTER_BEEP "computer_beep"
#define SFX_COMPUTER_BOOP "computer_boop"
#define SFX_CROWBAR "crowbar"
#define SFX_DRILL_HIT "drill_hit"
#define SFX_DROP "drop"
#define SFX_ELECTRICAL_HUM "electrical_hum"
#define SFX_ELECTRICAL_SPARK "electrical_sparm"
#define SFX_EQUIP_SWORD "equip_sword"
#define SFX_EXPLOSION "explosion"
#define SFX_FOOTSTEP_ASTEROID "footstep_asteroid"
#define SFX_FOOTSTEP_BLANK "footstep_blank"
#define SFX_FOOTSTEP_CARPET "footstep_carpet"
#define SFX_FOOTSTEP_CATWALK "footstep_catwalk"
#define SFX_FOOTSTEP_CLOWN "footstep_clown"
#define SFX_FOOTSTEP_GRASS "footstep_grass"
#define SFX_FOOTSTEP_LAVA "footstep_lava"
#define SFX_FOOTSTEP_PLATING "footstep_plating"
#define SFX_FOOTSTEP_SAND "footstep_sand"
#define SFX_FOOTSTEP_SKRELL "footstep_skrell"
#define SFX_FOOTSTEP_SNOW "footstep_snow"
#define SFX_FOOTSTEP_TILES "footstep_tiles"
#define SFX_FOOTSTEP_UNATHI "footstep_unathi"
#define SFX_FOOTSTEP_WATER "footstep_water"
#define SFX_FOOTSTEP_WOOD "footstep_wood"
#define SFX_FRACTURE "fracture"
#define SFX_GLASS_CRACK "glass_crack"
#define SFX_GRAB "grab"
#define SFX_GUNSHOT_ANY "gunshot_any"
#define SFX_GUNSHOT_BALLISTIC "gunshot_ballistic"
#define SFX_GUNSHOT_ENERGY "gunshot_energy"
#define SFX_HAMMER "hammer"
#define SFX_HATCH_CLOSE "hatch_close"
#define SFX_HATCH_OPEN "hatch_open"
#define SFX_HISS "hiss"
#define SFX_HIVEBOT_MELEE "hivebot_melee"
#define SFX_HIVEBOT_WAIL "hivebot_wail"
#define SFX_KEYBOARD "keyboard"
#define SFX_OINTMENT "ointment"
#define SFX_OUT_OF_AMMO "out_of_ammo"
#define SFX_OUT_OF_AMMO_REVOLVER "out_of_ammo_revolver"
#define SFX_OUT_OF_AMMO_RIFLE "out_of_ammo_rifle"
#define SFX_OUT_OF_AMMO_SHOTGUN "out_of_ammo_shotgun"
#define SFX_PAGE_TURN "page_turn"
#define SFX_PICKAXE "pickaxe"
#define SFX_PICKUP "pickup"
#define SFX_PICKUP_SWORD "pickup_sword"
#define SFX_POUR "pour"
#define SFX_PRINT "print"
#define SFX_PUMP_SHOTGUN "pump_shotgun"
#define SFX_PUNCH "punch"
#define SFX_PUNCH_BASSY "punch_bassy"
#define SFX_PUNCH_MISS "punch_miss"
#define SFX_RELOAD_HMG "reload_hmg"
#define SFX_RELOAD_METAL_SLIDE "reload_metal_slide"
#define SFX_RELOAD_POLYMER_SLIDE "reload_polymer_slide"
#define SFX_RELOAD_REVOLVER "reload_revolver"
#define SFX_RELOAD_RIFLE_SLIDE "reload_rifle_slide"
#define SFX_RELOAD_SHOTGUN "reload_shotgun"
#define SFX_RIP "rip"
#define SFX_RUSTLE "rustle"
#define SFX_SCREWDRIVER "screwdriver"
#define SFX_SHAKER_LID_OFF "shaker_lid_off"
#define SFX_SHAKER_SHAKING "shaker_shaking"
#define SFX_SHOOT_GAUSS "shoot_gauss"
#define SFX_SHOVEL "shovel"
#define SFX_SM_CALM "sm_calm"
#define SFX_SM_DELAM "sm_delam"
#define SFX_SPARKS "sfx_sparks"
#define SFX_STEAM_PIPE "steam_pipe"
#define SFX_SWING_HIT "swing_hit"
#define SFX_SWITCH "switch"
#define SFX_TRAY_HIT "tray_hit"
#define SFX_WIELD "wield"
