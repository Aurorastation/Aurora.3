
// CENTCOM

/area/prison/solitary
	name = "CentComm Solitary Confinement"
	icon_state = "brig"
	centcomm_area = 1
	area_flags = AREA_FLAG_PRISON

/area/centcom
	name = "Centcom"
	icon_state = "centcom"
	requires_power = 0
	no_light_control = 1
	base_turf = /turf/unsimulated/floor/plating
	centcomm_area = 1
	ambience = AMBIENCE_ARRIVALS

/area/centcom/control
	name = "Centcom Control"
	ambience = AMBIENCE_HIGHSEC

/area/centcom/spawning
	name = "NTCC Odin Departures"
	icon_state = "centcomspawn"
	ambience = AMBIENCE_ARRIVALS

/area/centcom/start
	name = "New Player Spawn"
	dynamic_lighting = 0
	sound_environment = SOUND_ENVIRONMENT_NONE

/area/centcom/evac
	name = "Centcom Emergency Shuttle"
	icon_state = "centcomevac"

/area/centcom/suppy
	name = "Centcom Supply Shuttle"
	icon_state = "centcomsupply"

/area/centcom/ferry
	name = "Centcom Transport Shuttle"
	icon_state = "centcomferry"

/area/centcom/shuttle
	name = "Centcom Administration Shuttle"

/area/centcom/test
	name = "Centcom Testing Facility"

/area/centcom/living
	name = "Centcom Living Quarters"
	icon_state = "centcomliving"

/area/centcom/specops
	name = "Centcom Special Ops"
	icon_state = "centcomspecops"

/area/centcom/creed
	name = "Creed's Office"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/centcom/holding
	name = "Holding Facility"
	icon_state = "centcomhold"

/area/centcom/checkpoint

/area/centcom/checkpoint/fore
	name = "Fore Checkpoint"
	icon_state = "centcomcheckfore"

/area/centcom/checkpoint/aft
	name = "Aft Checkpoint"
	icon_state = "centcomcheckaft"

/area/centcom/bar
	name = "Valkyrie's Rest"

/area/centcom/legion
	name = "BLV The Tower - Deck 1"
	icon_state = "blvtower"
	area_flags = AREA_FLAG_NO_CREW_EXPECTED

/area/centcom/legion/hangar5
	name = "BLV The Tower - Hangar 5"
	icon_state = "blvhangar5"
	ambience = AMBIENCE_HANGAR
	sound_environment = SOUND_ENVIRONMENT_HANGAR

/area/centcom/distress_prep
	name = "Distress Team Preparation"
	ambience = AMBIENCE_HIGHSEC

/area/merchant_station
	name = "Merchant Station"
	icon_state = "merchant"
	requires_power = 0
	dynamic_lighting = 1
	no_light_control = 1
	centcomm_area = 1
	area_flags = AREA_FLAG_NO_CREW_EXPECTED
	ambience = AMBIENCE_HIGHSEC

/area/merchant_station/warehouse
	name = "Merchant Warehouse"
	icon_state = "merchant_ware"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

// Antagonist Bases

/area/antag
	name = "Unknown Blacksite"
	icon_state = "dark"
	requires_power = FALSE
	no_light_control = TRUE
	centcomm_area = TRUE
	area_flags = AREA_FLAG_NO_CREW_EXPECTED

/area/antag/mercenary
	name = "Mercenary Barracks"
	icon_state = "merc"

/area/antag/raider
	name = "Raider Hideout"
	icon_state = "raider"

/area/antag/ninja
	name = "Ninja Preparation"
	icon_state = "ninja"

/area/antag/burglar
	name = "Burglar Hideout"
	icon_state = "burglar"

/area/antag/jockey
	name = "Jockey Workshop"
	icon_state = "jockey"

/area/antag/loner
	name = "Loner Basement"
	icon_state = "loner"

/area/antag/wizard
	name = "Wizard Mind Palace"
	icon_state = "wizard"
	dynamic_lighting = FALSE


//THUNDERDOME

/area/tdome
	name = "Thunderdome"
	icon_state = "thunder"
	requires_power = 0
	sound_environment = SOUND_ENVIRONMENT_ARENA
	no_light_control = 1
	centcomm_area = 1
	area_flags = AREA_FLAG_NO_CREW_EXPECTED

/area/tdome/tdome1
	name = "Thunderdome (Team 1)"
	icon_state = "green"

/area/tdome/tdome2
	name = "Thunderdome (Team 2)"
	icon_state = "yellow"

/area/tdome/tdomeadmin
	name = "Thunderdome (Admin.)"
	icon_state = "purple"

/area/tdome/tdomeobserve
	name = "Thunderdome (Observer.)"
	icon_state = "purple"

//Dungeons

/area/dungeon/crashed_ship
	name = "Derelict Ship"
	icon_state = "yellow"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_SPAWN_ROOF

/area/dungeon/tomb
	name = "Burial Chamber"
	icon_state = "yellow"
	area_flags = AREA_FLAG_SPAWN_ROOF

/area/dungeon/syndie_listening_post
	name = "Abandoned Listening Post"
	icon_state = "red"
	area_flags = AREA_FLAG_SPAWN_ROOF
	requires_power = 0
	no_light_control = 1

/area/dungeon/anomaly_outpost
	name = "Xenoarchaeological Outpost"
	icon_state = "anomaly"
	area_flags = AREA_FLAG_SPAWN_ROOF
	requires_power = 0
	no_light_control = 1

/area/dungeon/sol_outpost
	name = "Solarian Outpost"
	icon_state = "red"
	area_flags = AREA_FLAG_SPAWN_ROOF
	requires_power = 0
	no_light_control = 1

/area/dungeon/crashed_satellite
	name = "Communications Satellite"
	icon_state = "tcomsatcham"
	no_light_control = 1

/area/dungeon/skrell_ship
	name = "Crashed Skrell Ship"
	icon_state = "purple"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_SPAWN_ROOF

/area/dungeon/bluespace_outpost
	name = "Bluespace Outpost"
	icon_state = "purple"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_SPAWN_ROOF

//Away ships, third party ships, etc. Mostly for the ships that are expected to move on the overmap and/or have ghost roles.
/area/ship
	name = "Ship"
	icon_state = "ship"
	requires_power = 0
	sound_environment = SOUND_AREA_STANDARD_STATION
	no_light_control = 1
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_SPAWN_ROOF
