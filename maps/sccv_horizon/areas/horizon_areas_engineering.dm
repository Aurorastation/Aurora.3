/// ENGINEERING_AREAS
/area/horizon/engineering
	name = "Engineering"
	icon_state = "engineering"
	ambience = AMBIENCE_ENGINEERING
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING
	department = "Engineering"

/area/horizon/engineering/drone_fabrication
	name = "Engineering - Drone Fabrication"
	icon_state = "drone_fab"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/horizon/engineering/storage_hard
	name = "Engineering - Hard Storage"
	icon_state = "engineering_storage"

/area/horizon/engineering/storage_eva
	name = "Engineering - EVA Storage"
	icon_state = "engineering_storage"

/area/horizon/engineering/break_room
	name = "Engineering - Break Room"
	icon_state = "engineering_break"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR
	area_blurb = "The smell of coffee intermixed with oil linger in the air."
	area_blurb_category = "engi_breakroom"

/area/horizon/engineering/locker_room
	name = "Engineering - Locker Room"
	icon_state = "engineering_locker"

/area/horizon/engineering/gravity_gen
	name = "Engineering - Gravity Generator"
	icon_state = "engine"

/area/horizon/engineering/lobby
	name = "Engineering - Lobby"

/area/horizon/engineering/storage/tech
	name = "Engineering - Technical Storage"
	icon_state = "auxstorage"

/area/horizon/engineering/storage/lower
	name = "Engineering - Lower Deck Storage"

/area/horizon/engineering/aft_airlock
	name = "Engineering - Aft Service Airlock"

/area/horizon/engineering/smes
	name = "Engineering - SM SMES"
	icon_state = "engine_smes"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	ambience = AMBIENCE_SINGULARITY

/area/hallway/engineering
	name = "Engineering - Main Hallway"
	icon_state = "engineering"
	ambience = AMBIENCE_ENGINEERING
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/horizon/engineering/bluespace_drive
	name = "Engineering - Bluespace Drive"
	icon_state = "engine"
	horizon_deck = 1

/area/horizon/engineering/bluespace_drive/monitoring
	name = "Engineering - Bluespace Drive"
	icon_state = "engineering"

/area/horizon/engineering/shields
	name = "Ship Shield Control"
	icon_state = "eva"

/// ENGINEERING_AREAS - ATMOSIA_AREAS
/area/horizon/engineering/atmos
	name = "Engineering - Atmospherics"
	icon_state = "atmos"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	no_light_control = 1
	ambience = list(AMBIENCE_ENGINEERING, AMBIENCE_ATMOS)
	area_blurb = "Many volume tanks filled with gas reside here, some providing vital gases for the vessel's life support systems."
	area_blurb_category = "atmos"
	horizon_deck = 1
	subdepartment = "Atmospherics"

/area/horizon/engineering/atmos/storage
	name = "Engineering - Atmospherics Storage"
	icon_state = "atmos_storage"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	horizon_deck = 2

/area/horizon/engineering/atmos/air
	name = "Engineering - Air Mixing"

/area/horizon/engineering/atmos/propulsion
	name = "Port Propulsion"
	icon_state = "blue2"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/horizon/engineering/atmos/propulsion/starboard
	name = "Starboard Propulsion"
	icon_state = "blue-red2"

/area/horizon/engineering/atmos/turbine
	name = "Engineering - Combustion Turbine"

/// ENGINEERING_AREAS - REACTOR_AREAS
/area/horizon/engineering/reactor
	icon_state = "engine"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	no_light_control = 1
	ambience = AMBIENCE_SINGULARITY
	horizon_deck = 2

// We'll give this a cool custom icon one day.
/area/horizon/engineering/reactor/supermatter

/area/horizon/engineering/reactor/supermatter/airlock
	name = "Engineering - Engine Room Airlock"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/horizon/engineering/reactor/supermatter/mainchamber
	name = "Engineering - Supermatter Reactor"

/area/horizon/engineering/reactor/supermatter/monitoring
	name = "Engineering - Monitoring Room"
	icon_state = "engine_monitoring"

/area/horizon/engineering/reactor/supermatter/waste
	name = "Engineering - Engine Waste Handling"
	icon_state = "engine_waste"
	no_light_control = 1

// We'll give this a cool custom icon one day.
/area/horizon/engineering/reactor/indra

/area/horizon/engineering/reactor/indra/hallway
	name = "Engineering - INDRA Hallway"
	icon_state = "engine"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	no_light_control = 1
	ambience = AMBIENCE_SINGULARITY

/area/horizon/engineering/reactor/indra/smes
	name = "Engineering - INDRA SMES"

/area/horizon/engineering/reactor/indra/monitoring
	name = "Engineering - INDRA Engine Monitoring"
	icon_state = "engine_monitoring"

/area/horizon/engineering/reactor/indra/office
	name = "Engineering - INDRA Office"

/area/horizon/engineering/reactor/indra/mainchamber
	name = "Engineering - INDRA Engine"

/// TCOMMS_AREAS
/area/horizon/tcommsat
	ambience = AMBIENCE_ENGINEERING
	no_light_control = 1
	station_area = TRUE
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/horizon/tcommsat/entrance
	name = "Telecomms Entrance"
	icon_state = "tcomsatentrance"
	lightswitch = TRUE

/area/horizon/tcommsat/chamber
	name = "Telecomms Central Compartment"
	icon_state = "tcomsatcham"
	area_blurb = "Countless machines sit here, an unfathomably complicated network that runs every radio and computer connection. The air lacks any notable scent, having been filtered of dust and pollutants before being allowed into the room and all the sensitive machinery."
