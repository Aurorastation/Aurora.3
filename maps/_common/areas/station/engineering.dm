
//Engineering

/area/engineering
	name = "Engineering"
	icon_state = "engineering"
	ambience = list(
		'sound/ambience/ambisin1.ogg',
		'sound/ambience/ambisin2.ogg',
		'sound/ambience/ambisin3.ogg',
		'sound/ambience/ambisin4.ogg'
	)
	station_area = 1
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/engineering/atmos
	name = "Engineering - Atmospherics"
	icon_state = "atmos"
	sound_env = LARGE_ENCLOSED
	no_light_control = 1
	ambience = list('sound/ambience/ambiatm1.ogg')

/area/engineering/atmos/monitoring
	name = "Engineering - Atmospherics Monitoring Room"
	icon_state = "atmos_monitoring"
	sound_env = STANDARD_STATION

/area/engineering/atmos/storage
	name = "Engineering - Atmospherics Storage"
	icon_state = "atmos_storage"
	sound_env = SMALL_ENCLOSED

/area/engineering/drone_fabrication
	name = "Engineering - Drone Fabrication"
	icon_state = "drone_fab"
	sound_env = SMALL_ENCLOSED

/area/engineering/engine_smes
	name = "Engineering - Main Lvl. SMES Room"
	icon_state = "engine_smes"
	sound_env = SMALL_ENCLOSED

/area/engineering/engine_room
	name = "Engineering - Engine Room"
	icon_state = "engine"
	sound_env = LARGE_ENCLOSED
	no_light_control = 1

/area/engineering/engine_airlock
	name = "Engineering - Engine Room Airlock"
	icon_state = "engine"

/area/engineering/engine_monitoring
	name = "Engineering - Monitoring Room"
	icon_state = "engine_monitoring"

/area/engineering/engine_waste
	name = "Engineering - Engine Waste Handling"
	icon_state = "engine_waste"
	no_light_control = 1

/area/engineering/engineering_monitoring
	name = "Engineering - Monitoring Room"
	icon_state = "engine_monitoring"

/area/engineering/engineering_hallway_main
	name = "Engineering - Main Level Hallway"
	lightswitch = TRUE
	icon_state = "engine_monitoring"

/area/engineering/foyer
	name = "Engineering - Foyer"
	icon_state = "engineering_foyer"
	allow_nightmode = 1

/area/engineering/storage
	name = "Engineering - Storage"
	icon_state = "engineering_storage"

/area/engineering/storage_hard
	name = "Engineering - Hard Storage"
	icon_state = "engineering_storage"

/area/engineering/storage_eva
	name = "Engineering - EVA Storage"
	icon_state = "engineering_storage"

/area/engineering/storage_sublevel
	name = "Engineering - Sublevel Storage"
	icon_state = "engineering_storage"

/area/engineering/storage_tesla
	name = "Engineering - Tesla Parts Storage"
	icon_state = "engineering_storage"

/area/engineering/break_room
	name = "Engineering - Break Room"
	icon_state = "engineering_break"
	sound_env = MEDIUM_SOFTFLOOR

/area/engineering/engine_eva
	name = "Engineering - Engine EVA"
	icon_state = "engine_eva"

/area/engineering/locker_room
	name = "Engineering - Locker Room"
	icon_state = "engineering_locker"

/area/engineering/bathroom
	name = "Engineering - Bathroom"
	icon_state = "engineering_locker"

/area/engineering/workshop
	name = "Engineering - Workshop"
	icon_state = "engineering_workshop"

/area/engineering/cooling
	name = "Engineering - Engine Cooling Radiator"
	icon_state = "engine_monitoring"

/area/engineering/gravity_gen
	name = "Engineering - Gravity Generator"
	icon_state = "engine"

/area/engineering/backup_SMES
	name = "Engineering - Backup Power Storage"
	icon_state = "substation"
	sound_env = SMALL_ENCLOSED
