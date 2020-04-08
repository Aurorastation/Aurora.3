
// CENTCOM

/area/prison/solitary
	name = "\improper CentComm Solitary Confinement"
	icon_state = "brig"
	centcomm_area = 1

/area/centcom
	name = "\improper Centcom"
	icon_state = "centcom"
	requires_power = 0
	no_light_control = 1
	base_turf = /turf/unsimulated/floor/plating
	centcomm_area = 1

/area/centcom/control
	name = "\improper Centcom Control"

/area/centcom/spawning
	name = "\improper Centcom Preparatory Wing"

/area/centcom/evac
	name = "\improper Centcom Emergency Shuttle"

/area/centcom/suppy
	name = "\improper Centcom Supply Shuttle"

/area/centcom/ferry
	name = "\improper Centcom Transport Shuttle"

/area/centcom/shuttle
	name = "\improper Centcom Administration Shuttle"

/area/centcom/test
	name = "\improper Centcom Testing Facility"

/area/centcom/living
	name = "\improper Centcom Living Quarters"

/area/centcom/specops
	name = "\improper Centcom Special Ops"

/area/centcom/creed
	name = "Creed's Office"

/area/centcom/holding
	name = "\improper Holding Facility"

/area/centcom/checkpoint/fore
	name = "\improper Fore Checkpoint"

/area/centcom/checkpoint/aft
	name = "\improper Aft Checkpoint"

/area/centcom/legion
	name = "\improper BLV The Tower - Deck 1"
	icon_state = "blvtower"

/area/centcom/legion/hangar5
	name = "\improper BLV The Tower - Hangar 5"
	icon_state = "blvhangar5"

/area/centcom/distress_prep
	name = "\improper Distress Team Preparation"

//SYNDICATES

/area/syndicate_mothership
	name = "\improper Mercenary Base"
	icon_state = "syndie-ship"
	requires_power = 0
	dynamic_lighting = 0
	no_light_control = 1
	centcomm_area = 1

/area/syndicate_mothership/control
	name = "\improper Mercenary Control Room"
	icon_state = "syndie-control"

/area/syndicate_mothership/elite_squad
	name = "\improper Elite Mercenary Squad"
	icon_state = "syndie-elite"

/area/syndicate_mothership/raider_base
	name = "\improper Pirate Hideout"
	icon_state = "syndie-control"
	dynamic_lighting = 1

//THUNDERDOME

/area/tdome
	name = "\improper Thunderdome"
	icon_state = "thunder"
	requires_power = 0
	dynamic_lighting = 0
	sound_env = ARENA
	no_light_control = 1
	centcomm_area = 1

/area/tdome/tdome1
	name = "\improper Thunderdome (Team 1)"
	icon_state = "green"

/area/tdome/tdome2
	name = "\improper Thunderdome (Team 2)"
	icon_state = "yellow"

/area/tdome/tdomeadmin
	name = "\improper Thunderdome (Admin.)"
	icon_state = "purple"

/area/tdome/tdomeobserve
	name = "\improper Thunderdome (Observer.)"
	icon_state = "purple"

//ACTORS GUILD
/area/acting
	name = "\improper Centcom Acting Guild"
	icon_state = "red"
	dynamic_lighting = 0
	requires_power = 0
	no_light_control = 1
	centcomm_area = 1

/area/acting/backstage
	name = "\improper Backstage"

/area/acting/stage
	name = "\improper Stage"
	dynamic_lighting = 1
	icon_state = "yellow"

//ENEMY

//names are used
/area/syndicate_station
	name = "\improper Independent Station"
	icon_state = "yellow"
	requires_power = 0
	flags = RAD_SHIELDED | SPAWN_ROOF
	no_light_control = 1

/area/syndicate_station/start
	name = "\improper Mercenary Shuttle"
	icon_state = "yellow"
	centcomm_area = 1
	base_turf = /turf/space

/area/syndicate_station/surface
	name = "\improper Surface of the Station"
	icon_state = "southwest"
	station_area = 1
	base_turf = /turf/unsimulated/floor/asteroid/ash

/area/syndicate_station/above
	name = "\improper Above the Station"
	icon_state = "northwest"

/area/syndicate_station/under
	name = "\improper Under the Station"
	icon_state = "northeast"

/area/syndicate_station/caverns
	name = "\improper Caverns"
	icon_state = "southeast"
	base_turf = /turf/unsimulated/floor/asteroid/ash

/area/syndicate_station/arrivals_dock
	name = "\improper Docked with Station"
	icon_state = "shuttle"
	station_area = 1
	base_turf = /turf/unsimulated/floor/asteroid/ash

/area/syndicate_station/transit
	name = "\improper Hyperspace"
	icon_state = "shuttle"
	base_turf = /turf/space/transit/north
	centcomm_area = 1

/area/wizard_station
	name = "\improper Wizard's Den"
	icon_state = "yellow"
	requires_power = 0
	dynamic_lighting = 0
	no_light_control = 1
	centcomm_area = 1

/area/kataphract_chapter
	name = "\improper Kataphract Chapter"
	icon_state = "yellow"
	requires_power = 1
	dynamic_lighting = 1
	no_light_control = 0
	base_turf = /turf/space

/area/kataphract_chapter/bridge
	name = "\improper Kataphract Chapter - Bridge"
	icon_state = "bridge"

/area/kataphract_chapter/sparring_chamber
	name = "\improper Kataphract Chapter - Sparring Chamber"
	icon_state = "security"

/area/kataphract_chapter/commissary
	name = "\improper Kataphract Chapter - Commissary"
	icon_state = "Warden"

/area/kataphract_chapter/main_ring
	name = "\improper Kataphract Chapter - Main Ring"
	icon_state = "yellow"

/area/kataphract_chapter/dorms
	name = "\improper Kataphract Chapter - Dorms"
	icon_state = "Sleep"

/area/kataphract_chapter/toilets
	name = "\improper Kataphract Chapter - Toilets"
	icon_state = "toilet"

/area/kataphract_chapter/office
	name = "\improper Kataphract Chapter - Knight's Office"
	icon_state = "law"

/area/kataphract_chapter/cafeteria
	name = "\improper Kataphract Chapter - Cafeteria"
	icon_state = "kitchen"

/area/kataphract_chapter/engineering
	name = "\improper Kataphract Chapter - Engineering"
	icon_state = "engineering_workshop"

/area/kataphract_chapter/port_solars
	name = "\improper Kataphract Chapter - Port Solars"
	icon_state = "panelsA"

/area/kataphract_chapter/starboard_solars
	name = "\improper Kataphract Chapter - Starboard Solars"
	icon_state = "panelsA"

/area/kataphract_chapter/trading_area
	name = "\improper Kataphract Chapter - Trading Area"
	icon_state = "quartoffice"

/area/kataphract_chapter/warehouse
	name = "\improper Kataphract Chapter - Warehouse"
	icon_state = "quartstorage"

/area/kataphract_chapter/hangar
	name = "\improper Kataphract Chapter - Hangar"
	icon_state = "green"

/area/kataphract_chapter/hull
	name = "\improper Kataphract Chapter - Hull"
	icon_state = "blue"

/area/skipjack_station
	name = "\improper Skipjack"
	icon_state = "yellow"
	requires_power = 0
	no_light_control = 1
	base_turf = /turf/space
	flags = SPAWN_ROOF

/area/skipjack_station/start
	name = "\improper Skipjack"
	icon_state = "yellow"
	centcomm_area = 1

/area/skipjack_station/transit
	name = "\improper Hyperspace"
	icon_state = "shuttle"
	base_turf = /turf/space/transit/north
	centcomm_area = 1

/area/skipjack_station/surface
	name = "\improper Surface of the Station"
	icon_state = "southwest"
	station_area = 1
	base_turf = /turf/unsimulated/floor/asteroid/ash

/area/skipjack_station/above
	name = "\improper Above the Station"
	icon_state = "northwest"

/area/skipjack_station/under
	name = "\improper Under the Station"
	icon_state = "northeast"

/area/skipjack_station/cavern
	name = "\improper Caverns"
	icon_state = "southeast"
	base_turf = /turf/unsimulated/floor/asteroid/ash

//DJSTATION

/area/djstation
	name = "\improper Listening Post"
	icon_state = "LP"
	no_light_control = 1

/area/djstation/solars
	name = "\improper Listening Post Solars"
	icon_state = "LPS"


//merchant station and shuttle

/area/merchant_station
	name = "\improper Merchant Station"
	icon_state = "merchant"
	requires_power = 0
	dynamic_lighting = 1
	no_light_control = 1
	centcomm_area = 1

/area/merchant_station/warehouse
	name = "\improper Merchant Warehouse"
	icon_state = "merchant_ware"

/area/merchant_station/transit
	name = "\improper Hyperspace"
	icon_state = "shuttle"
	centcomm_area = 1

/area/merchant_ship
	name = "\improper Merchant Ship"
	icon_state = "yellow"
	requires_power = 0
	flags = RAD_SHIELDED | SPAWN_ROOF
	no_light_control = 1

/area/merchant_ship/start
	name = "\improper Merchant Ship Docked"
	icon_state = "yellow"
	centcomm_area = 1
	base_turf = /turf/space

/area/merchant_ship/docked
	name = "\improper Docked with station"
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
	name = "\improper Derelict Ship"
	icon_state = "yellow"
	flags = RAD_SHIELDED | SPAWN_ROOF

/area/dungeon/tomb
	name = "\improper Burial Chamber"
	icon_state = "yellow"
	flags = SPAWN_ROOF

/area/dungeon/syndie_listening_post
	name = "\improper Abandoned Listening Post"
	icon_state = "red"
	flags = SPAWN_ROOF
	requires_power = 0
	no_light_control = 1

/area/dungeon/anomaly_outpost
	name = "\improper Xenoarchaeological Outpost"
	icon_state = "anomaly"
	flags = SPAWN_ROOF
	requires_power = 0
	no_light_control = 1

/area/dungeon/sol_outpost
	name = "\improper Solarian Outpost"
	icon_state = "red"
	flags = SPAWN_ROOF
	requires_power = 0
	no_light_control = 1

/area/dungeon/crashed_satellite
	name = "\improper Communications Satellite"
	icon_state = "tcomsatcham"
	no_light_control = 1
