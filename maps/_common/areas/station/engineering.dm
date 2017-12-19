
//Engineering

/area/engineering
	name = "\improper Engineering"
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
	name = "\improper Engineering - Atmospherics"
	icon_state = "atmos"
	sound_env = LARGE_ENCLOSED
	no_light_control = 1
	ambience = list('sound/ambience/ambiatm1.ogg')

/area/engineering/atmos/monitoring
	name = "\improper Engineering - Atmospherics Monitoring Room"
	icon_state = "atmos_monitoring"
	sound_env = STANDARD_STATION

/area/engineering/atmos/storage
	name = "\improper Engineering - Atmospherics Storage"
	icon_state = "atmos_storage"
	sound_env = SMALL_ENCLOSED

/area/engineering/drone_fabrication
	name = "\improper Engineering - Drone Fabrication"
	icon_state = "drone_fab"
	sound_env = SMALL_ENCLOSED

/area/engineering/engine_smes
	name = "\improper Engineering - Main Lvl. SMES Room"
	icon_state = "engine_smes"
	sound_env = SMALL_ENCLOSED

/area/engineering/engine_room
	name = "\improper Engineering - Engine Room"
	icon_state = "engine"
	sound_env = LARGE_ENCLOSED
	no_light_control = 1

/area/engineering/engine_airlock
	name = "\improper Engineering - Engine Room Airlock"
	icon_state = "engine"

/area/engineering/engine_monitoring
	name = "\improper Engineering - Monitoring Room"
	icon_state = "engine_monitoring"

/area/engineering/engine_waste
	name = "\improper Engineering - Engine Waste Handling"
	icon_state = "engine_waste"
	no_light_control = 1

/area/engineering/engineering_monitoring
	name = "\improper Engineering - Monitoring Room"
	icon_state = "engine_monitoring"

/area/engineering/foyer
	name = "\improper Engineering - Foyer"
	icon_state = "engineering_foyer"
	allow_nightmode = 1

/area/engineering/storage
	name = "\improper Engineering - Storage"
	icon_state = "engineering_storage"

/area/engineering/break_room
	name = "\improper Engineering - Break Room"
	icon_state = "engineering_break"
	sound_env = MEDIUM_SOFTFLOOR

/area/engineering/engine_eva
	name = "\improper Engineering - Engine EVA"
	icon_state = "engine_eva"

/area/engineering/locker_room
	name = "\improper Engineering - Locker Room"
	icon_state = "engineering_locker"

/area/engineering/workshop
	name = "\improper Engineering - Workshop"
	icon_state = "engineering_workshop"

/area/engineering/cooling
	name = "\improper Engineering - Engine Cooling Radiator"
	icon_state = "engineering_monitoring"

/area/engineering/gravity_gen
	name = "\improper Engineering - Gravity Generator"
	icon_state = "engine"
