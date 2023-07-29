/area/light_cruiser
	no_light_control = 1
	turf_initializer = new /datum/turf_initializer/maintenance() //SFA owned

/area/light_cruiser/starboard_thrusters
	name = "Starboard - Propulsion"
	icon_state = "blue-red2"
	ambience = AMBIENCE_ENGINEERING

/area/light_cruiser/port_thrusters
	name = "Port - Propulsion"
	icon_state = "blue-red2"
	ambience = AMBIENCE_ENGINEERING

/area/light_cruiser/starboard_engineering
	name = "Starboard - Engineering"
	icon_state = "engineering"
	ambience = AMBIENCE_ENGINEERING

/area/light_cruiser/port_engineering
	name = "Port - Engineering"
	icon_state = "Port Engineering"
	ambience = AMBIENCE_ENGINEERING

/area/light_cruiser/reactor
	name = "Reactor"
	icon_state = "engine_smes"
	sound_env = SMALL_ENCLOSED
	ambience = AMBIENCE_SINGULARITY

/area/light_cruiser/starboard_aft_hall
	name = "Starboard - Aft Hallway"
	icon_state = "hallC1"
	sound_env = LARGE_ENCLOSED

/area/light_cruiser/port_aft_hall
	name = "Port - Aft Hallway"
	sound_env = LARGE_ENCLOSED
	icon_state = "hallC1"

/area/light_cruiser/lifts_and_stairs
	name = "Lifts & Stairs"
	icon_state = "arrivals_dock"
	sound_env = LARGE_ENCLOSED

/area/light_cruiser/head
	name = "Head"
	icon_state = "washroom"
	sound_env = SMALL_ENCLOSED

/area/light_cruiser/armoury
	name = "Starboard - Armoury"
	ambience = AMBIENCE_HIGHSEC
	icon_state = "security"

/area/light_cruiser/medical
	name = "Port - Medical"
	icon_state = "medbay"
	ambience = list('sound/ambience/signal.ogg')

/area/light_cruiser/central_hall
	name = "Central Hallway"
	sound_env = LARGE_ENCLOSED
	icon_state = "hallC2"

/area/light_cruiser/strongroom //somebody set us up the bomb
	name = "Strongroom"
	ambience = AMBIENCE_HIGHSEC
	icon_state = "nuke_storage"

/area/light_cruiser/cic_hall
	name = "CIC Hallway"
	sound_env = LARGE_ENCLOSED
	icon_state = "hallC3"

/area/light_cruiser/port_abandoned_observation
	name = "Port - Abandoned Observation Room"
	sound_env = SMALL_ENCLOSED
	ambience = AMBIENCE_MAINTENANCE
	icon_state = "unknown"

/area/light_cruiser/starboard_observation
	name = "Starboard - Observation Room"
	sound_env = SMALL_SOFTFLOOR
	icon_state = "green"

/area/light_cruiser/cic
	name = "combat information center"
	sound_env = MEDIUM_SOFTFLOOR
	icon_state = "bridge"

/area/light_cruiser/starboard_maintenance_exit
	name = "Starboard - Maintenance Exit"
	sound_env = SMALL_ENCLOSED
	ambience = AMBIENCE_MAINTENANCE
	icon_state = "maintcentral"

/area/light_cruiser/port_maintenance_exit
	name = "Port - Maintenance Exit"
	ambience = AMBIENCE_MAINTENANCE
	sound_env = SMALL_ENCLOSED
	icon_state = "maintcentral"

/area/light_cruiser/starboard_fore_hall_1
	name = "Starboard - Fore Hallway"
	sound_env = LARGE_ENCLOSED
	icon_state = "hallS"

/area/light_cruiser/starboard_fore_hall_2
	name = "Starboard - Fore Hallway"
	sound_env = LARGE_ENCLOSED
	icon_state = "hallS"

/area/light_cruiser/port_fore_hall_1
	name = "Port - Fore Hallway"
	sound_env = LARGE_ENCLOSED
	icon_state = "hallP"

/area/light_cruiser/port_fore_hall_2
	name = "Port - Fore Hallway"
	sound_env = LARGE_ENCLOSED
	icon_state = "hallP"

/area/light_cruiser/starboard_coilgun_ammo_1
	name = "Starboard - Coilgun Ammunition"
	sound_env = SMALL_ENCLOSED
	icon_state = "unknown"

/area/light_cruiser/starboard_coilgun_ammo_2
	name = "Starboard - Coilgun Ammunition"
	sound_env = SMALL_ENCLOSED
	icon_state = "unknown"

/area/light_cruiser/port_coilgun_ammo_1
	name = "Port - Coilgun Ammunition"
	sound_env = SMALL_ENCLOSED
	icon_state = "unknown"

/area/light_cruiser/port_coilgun_ammo_2
	name = "Port - Coilgun Ammunition"
	sound_env = SMALL_ENCLOSED
	icon_state = "unknown"

/area/light_cruiser/starboard_coilgun
	name = "Starboard - Coilgun"
	sound_env = SMALL_ENCLOSED
	icon_state = "dark"

/area/light_cruiser/port_coilgun
	name = "Port - Coilgun"
	sound_env = SMALL_ENCLOSED
	icon_state = "dark"

/area/light_cruiser/starboard_exterior_armour
	name = "Starboard - Armour"
	icon_state = "unknown"

/area/light_cruiser/port_exterior_armour
	name = "Port - Armour"
	icon_state = "unknown"

/area/light_cruiser/exterior
	name = "Cruiser Exterior"
	icon_state = "unknown"
	requires_power = FALSE

/area/light_cruiser/starboard_grauwolf
	name = "Starboard - Grauwolf"
	icon_state = "unknown"

/area/light_cruiser/port_abandoned_grauwolf
	name = "Port - Abandoned Grauwolf"
	icon_state = "unknown"