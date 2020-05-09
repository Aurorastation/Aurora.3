
// CENTCOM

/area/prison/solitary
	name = "CentComm Solitary Confinement"
	icon_state = "brig"
	centcomm_area = 1

/area/centcom
	name = "Centcom"
	icon_state = "centcom"
	requires_power = 0
	no_light_control = 1
	base_turf = /turf/unsimulated/floor/plating
	centcomm_area = 1

/area/centcom/control
	name = "Centcom Control"

/area/centcom/spawning
	name = "Centcom Preparatory Wing"

/area/centcom/evac
	name = "Centcom Emergency Shuttle"

/area/centcom/suppy
	name = "Centcom Supply Shuttle"

/area/centcom/ferry
	name = "Centcom Transport Shuttle"

/area/centcom/shuttle
	name = "Centcom Administration Shuttle"

/area/centcom/test
	name = "Centcom Testing Facility"

/area/centcom/living
	name = "Centcom Living Quarters"

/area/centcom/specops
	name = "Centcom Special Ops"

/area/centcom/creed
	name = "Creed's Office"

/area/centcom/holding
	name = "Holding Facility"

/area/centcom/checkpoint/fore
	name = "Fore Checkpoint"

/area/centcom/checkpoint/aft
	name = "Aft Checkpoint"

/area/centcom/legion
	name = "BLV The Tower - Deck 1"
	icon_state = "blvtower"

/area/centcom/legion/hangar5
	name = "BLV The Tower - Hangar 5"
	icon_state = "blvhangar5"

/area/centcom/distress_prep
	name = "Distress Team Preparation"

//SYNDICATES

/area/syndicate_mothership
	name = "Mercenary Base"
	icon_state = "syndie-ship"
	requires_power = 0
	dynamic_lighting = 0
	no_light_control = 1
	centcomm_area = 1

/area/syndicate_mothership/control
	name = "Mercenary Control Room"
	icon_state = "syndie-control"

/area/syndicate_mothership/elite_squad
	name = "Elite Mercenary Squad"
	icon_state = "syndie-elite"

/area/syndicate_mothership/raider_base
	name = "Pirate Hideout"
	icon_state = "syndie-control"
	dynamic_lighting = 1

//THUNDERDOME

/area/tdome
	name = "Thunderdome"
	icon_state = "thunder"
	requires_power = 0
	dynamic_lighting = 0
	sound_env = ARENA
	no_light_control = 1
	centcomm_area = 1

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

//ACTORS GUILD
/area/acting
	name = "Centcom Acting Guild"
	icon_state = "red"
	dynamic_lighting = 0
	requires_power = 0
	no_light_control = 1
	centcomm_area = 1

/area/acting/backstage
	name = "Backstage"

/area/acting/stage
	name = "Stage"
	dynamic_lighting = 1
	icon_state = "yellow"

//ENEMY

//names are used
/area/syndicate_station
	name = "Independent Station"
	icon_state = "yellow"
	requires_power = 0
	flags = RAD_SHIELDED | SPAWN_ROOF
	no_light_control = 1

/area/syndicate_station/start
	name = "Mercenary Shuttle"
	icon_state = "yellow"
	centcomm_area = 1
	base_turf = /turf/space

/area/syndicate_station/surface
	name = "Surface of the Station"
	icon_state = "southwest"
	station_area = 1
	base_turf = /turf/unsimulated/floor/asteroid/ash

/area/syndicate_station/above
	name = "Above the Station"
	icon_state = "northwest"

/area/syndicate_station/under
	name = "Under the Station"
	icon_state = "northeast"

/area/syndicate_station/caverns
	name = "Caverns"
	icon_state = "southeast"
	base_turf = /turf/unsimulated/floor/asteroid/ash

/area/syndicate_station/arrivals_dock
	name = "Docked with Station"
	icon_state = "shuttle"
	station_area = 1
	base_turf = /turf/unsimulated/floor/asteroid/ash

/area/syndicate_station/transit
	name = "Hyperspace"
	icon_state = "shuttle"
	base_turf = /turf/space/transit/north
	centcomm_area = 1

/area/wizard_station
	name = "Wizard's Den"
	icon_state = "yellow"
	requires_power = 0
	dynamic_lighting = 0
	no_light_control = 1
	centcomm_area = 1

/area/kataphract_chapter
	name = "Kataphract Chapter"
	icon_state = "yellow"
	requires_power = 1
	dynamic_lighting = 1
	no_light_control = 0
	base_turf = /turf/space

/area/kataphract_chapter/bridge
	name = "Kataphract Chapter - Bridge"
	icon_state = "bridge"

/area/kataphract_chapter/sparring_chamber
	name = "Kataphract Chapter - Sparring Chamber"
	icon_state = "security"

/area/kataphract_chapter/commissary
	name = "Kataphract Chapter - Commissary"
	icon_state = "Warden"

/area/kataphract_chapter/main_ring
	name = "Kataphract Chapter - Main Ring"
	icon_state = "yellow"

/area/kataphract_chapter/dorms
	name = "Kataphract Chapter - Dorms"
	icon_state = "Sleep"

/area/kataphract_chapter/toilets
	name = "Kataphract Chapter - Toilets"
	icon_state = "toilet"

/area/kataphract_chapter/office
	name = "Kataphract Chapter - Knight's Office"
	icon_state = "law"

/area/kataphract_chapter/cafeteria
	name = "Kataphract Chapter - Cafeteria"
	icon_state = "kitchen"

/area/kataphract_chapter/engineering
	name = "Kataphract Chapter - Engineering"
	icon_state = "engineering_workshop"

/area/kataphract_chapter/port_solars
	name = "Kataphract Chapter - Port Solars"
	icon_state = "panelsA"

/area/kataphract_chapter/starboard_solars
	name = "Kataphract Chapter - Starboard Solars"
	icon_state = "panelsA"

/area/kataphract_chapter/trading_area
	name = "Kataphract Chapter - Trading Area"
	icon_state = "quartoffice"

/area/kataphract_chapter/warehouse
	name = "Kataphract Chapter - Warehouse"
	icon_state = "quartstorage"

/area/kataphract_chapter/hangar
	name = "Kataphract Chapter - Hangar"
	icon_state = "green"

/area/kataphract_chapter/hull
	name = "Kataphract Chapter - Hull"
	icon_state = "blue"

/area/skipjack_station
	name = "Skipjack"
	icon_state = "yellow"
	requires_power = 0
	no_light_control = 1
	base_turf = /turf/space
	flags = SPAWN_ROOF

/area/skipjack_station/start
	name = "Skipjack"
	icon_state = "yellow"
	centcomm_area = 1

/area/skipjack_station/transit
	name = "Hyperspace"
	icon_state = "shuttle"
	base_turf = /turf/space/transit/north
	centcomm_area = 1

/area/skipjack_station/surface
	name = "Surface of the Station"
	icon_state = "southwest"
	station_area = 1
	base_turf = /turf/unsimulated/floor/asteroid/ash

/area/skipjack_station/above
	name = "Above the Station"
	icon_state = "northwest"

/area/skipjack_station/under
	name = "Under the Station"
	icon_state = "northeast"

/area/skipjack_station/cavern
	name = "Caverns"
	icon_state = "southeast"
	base_turf = /turf/unsimulated/floor/asteroid/ash

//DJSTATION

/area/djstation
	name = "Listening Post"
	icon_state = "LP"
	no_light_control = 1

/area/djstation/solars
	name = "Listening Post Solars"
	icon_state = "LPS"


//merchant station and shuttle

/area/merchant_station
	name = "Merchant Station"
	icon_state = "merchant"
	requires_power = 0
	dynamic_lighting = 1
	no_light_control = 1
	centcomm_area = 1

/area/merchant_station/warehouse
	name = "Merchant Warehouse"
	icon_state = "merchant_ware"

/area/merchant_station/transit
	name = "Hyperspace"
	icon_state = "shuttle"
	centcomm_area = 1

/area/merchant_ship
	name = "Merchant Ship"
	icon_state = "yellow"
	requires_power = 0
	flags = RAD_SHIELDED | SPAWN_ROOF
	no_light_control = 1

/area/merchant_ship/start
	name = "Merchant Ship Docked"
	icon_state = "yellow"
	centcomm_area = 1
	base_turf = /turf/space

/area/merchant_ship/docked
	name = "Docked with station"
	icon_state = "southwest"
	station_area = 1
	base_turf = /turf/unsimulated/floor/asteroid/ash

/area/beach
	name = "Keelin's private beach"
	icon_state = "yellow"
	luminosity = 1
	dynamic_lighting = 0
	requires_power = 0
	no_light_control = 1

//dungeon areas

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
