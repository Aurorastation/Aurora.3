
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
	base_turf = /turf/unsimulated/floor
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
	name = "\improper Mercenary Forward Operating Base"
	icon_state = "yellow"
	centcomm_area = 1
	base_turf = /turf/space

/area/syndicate_station/surface
	name = "\improper Surface of the Station"
	icon_state = "southwest"
	station_area = 1
	base_turf = /turf/simulated/floor/asteroid/ash

/area/syndicate_station/above
	name = "\improper Above the Station"
	icon_state = "northwest"

/area/syndicate_station/under
	name = "\improper Under the Station"
	icon_state = "northeast"

/area/syndicate_station/caverns
	name = "\improper Caverns"
	icon_state = "southeast"
	base_turf = /turf/simulated/floor/asteroid/ash

/area/syndicate_station/arrivals_dock
	name = "\improper Docked with Station"
	icon_state = "shuttle"
	station_area = 1
	base_turf = /turf/simulated/floor/asteroid/ash

/area/syndicate_station/transit
	name = "\improper Hyperspace"
	icon_state = "shuttle"
	centcomm_area = 1

/area/wizard_station
	name = "\improper Wizard's Den"
	icon_state = "yellow"
	requires_power = 0
	dynamic_lighting = 0
	no_light_control = 1
	centcomm_area = 1

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
	centcomm_area = 1

/area/skipjack_station/surface
	name = "\improper Surface of the Station"
	icon_state = "southwest"
	station_area = 1
	base_turf = /turf/simulated/floor/asteroid/ash

/area/skipjack_station/above
	name = "\improper Above the Station"
	icon_state = "northwest"

/area/skipjack_station/under
	name = "\improper Under the Station"
	icon_state = "northeast"

/area/skipjack_station/cavern
	name = "\improper Caverns"
	icon_state = "southeast"
	base_turf = /turf/simulated/floor/asteroid/ash

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
	base_turf = /turf/simulated/floor/asteroid/ash

/area/beach
	name = "Keelin's private beach"
	icon_state = "null"
	luminosity = 1
	dynamic_lighting = 0
	requires_power = 0
	no_light_control = 1

//dungeon areas

/area/crashed_ship
	name = "\improper Derelict Ship"
	icon_state = "yellow"
	flags = RAD_SHIELDED | SPAWN_ROOF

/area/tomb
	name = "\improper Burial Chamber"
	icon_state = "yellow"
	flags = SPAWN_ROOF