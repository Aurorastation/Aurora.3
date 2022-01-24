
// CENTCOM

/area/prison/solitary
	name = "CentComm Solitary Confinement"
	icon_state = "brig"
	centcomm_area = 1
	flags = PRISON

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
	sound_env = SMALL_SOFTFLOOR

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
	flags = NO_CREW_EXPECTED

/area/centcom/legion/hangar5
	name = "BLV The Tower - Hangar 5"
	icon_state = "blvhangar5"
	ambience = AMBIENCE_HANGAR
	sound_env = HANGAR

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
	flags = NO_CREW_EXPECTED
	ambience = AMBIENCE_HIGHSEC

/area/merchant_station/warehouse
	name = "Merchant Warehouse"
	icon_state = "merchant_ware"
	sound_env = LARGE_ENCLOSED

// Antagonist Bases

/area/antag
	name = "Unknown Blacksite"
	icon_state = "dark"
	requires_power = FALSE
	no_light_control = TRUE
	centcomm_area = TRUE
	flags = NO_CREW_EXPECTED

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
	sound_env = ARENA
	no_light_control = 1
	centcomm_area = 1
	flags = NO_CREW_EXPECTED

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

// Kataphract Station

/area/kataphract_chapter
	name = "Kataphract Chapter"
	icon_state = "yellow"
	requires_power = 1
	dynamic_lighting = 1
	no_light_control = 0
	base_turf = /turf/space
	flags = NO_CREW_EXPECTED

/area/kataphract_chapter/bridge
	name = "Kataphract Chapter - Bridge"
	icon_state = "bridge"
	ambience = AMBIENCE_HIGHSEC

/area/kataphract_chapter/sparring_chamber
	name = "Kataphract Chapter - Sparring Chamber"
	icon_state = "security"
	sound_env = ARENA

/area/kataphract_chapter/commissary
	name = "Kataphract Chapter - Commissary"
	icon_state = "Warden"

/area/kataphract_chapter/main_ring
	name = "Kataphract Chapter - Main Ring"
	icon_state = "yellow"

/area/kataphract_chapter/dorms
	name = "Kataphract Chapter - Dormitory"
	icon_state = "Sleep"
	sound_env = SMALL_SOFTFLOOR

/area/kataphract_chapter/toilets
	name = "Kataphract Chapter - Toilets"
	icon_state = "toilet"
	sound_env = SMALL_ENCLOSED

/area/kataphract_chapter/office
	name = "Kataphract Chapter - Knight's Office"
	icon_state = "law"
	sound_env = SMALL_SOFTFLOOR

/area/kataphract_chapter/cafeteria
	name = "Kataphract Chapter - Cafeteria"
	icon_state = "kitchen"

/area/kataphract_chapter/engineering
	name = "Kataphract Chapter - Engineering"
	icon_state = "engineering_workshop"
	ambience = AMBIENCE_ENGINEERING

/area/kataphract_chapter/port_solars
	name = "Kataphract Chapter - Port Solars"
	icon_state = "panelsA"
	ambience = AMBIENCE_SPACE

/area/kataphract_chapter/starboard_solars
	name = "Kataphract Chapter - Starboard Solars"
	icon_state = "panelsA"
	ambience = AMBIENCE_SPACE

/area/kataphract_chapter/trading_area
	name = "Kataphract Chapter - Trading Area"
	icon_state = "quartoffice"

/area/kataphract_chapter/warehouse
	name = "Kataphract Chapter - Warehouse"
	icon_state = "quartstorage"
	sound_env = LARGE_ENCLOSED

/area/kataphract_chapter/hangar
	name = "Kataphract Chapter - Hangar"
	icon_state = "green"
	ambience = AMBIENCE_HANGAR
	sound_env = HANGAR

/area/kataphract_chapter/hull
	name = "Kataphract Chapter - Hull"
	icon_state = "blue"

/area/beach
	name = "Keelin's private beach"
	icon_state = "yellow"
	luminosity = 1
	dynamic_lighting = 0
	requires_power = 0
	no_light_control = 1

//Dungeons

/area/dungeon/crashed_ship
	name = "Derelict Ship"
	icon_state = "yellow"
	flags = RAD_SHIELDED | SPAWN_ROOF

/area/dungeon/tomb
	name = "Burial Chamber"
	icon_state = "yellow"
	flags = SPAWN_ROOF

/area/dungeon/syndie_listening_post
	name = "Abandoned Listening Post"
	icon_state = "red"
	flags = SPAWN_ROOF
	requires_power = 0
	no_light_control = 1

/area/dungeon/anomaly_outpost
	name = "Xenoarchaeological Outpost"
	icon_state = "anomaly"
	flags = SPAWN_ROOF
	requires_power = 0
	no_light_control = 1

/area/dungeon/sol_outpost
	name = "Solarian Outpost"
	icon_state = "red"
	flags = SPAWN_ROOF
	requires_power = 0
	no_light_control = 1

/area/dungeon/crashed_satellite
	name = "Communications Satellite"
	icon_state = "tcomsatcham"
	no_light_control = 1

/area/dungeon/skrell_ship
	name = "Crashed Skrell Ship"
	icon_state = "purple"
	flags = RAD_SHIELDED | SPAWN_ROOF

/area/dungeon/bluespace_outpost
	name = "Bluespace Outpost"
	icon_state = "purple"
	flags = RAD_SHIELDED | SPAWN_ROOF

//Misc

/area/beach
	name = "Keelin's private beach"
	icon_state = "yellow"
	luminosity = 1
	dynamic_lighting = 0
	requires_power = 0
	no_light_control = 1
