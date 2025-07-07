/// ENGINEERING_AREAS
/area/horizon/engineering
	name = "Engineering (PARENT AREA - DON'T USE)"
	icon_state = "engineering"
	ambience = AMBIENCE_ENGINEERING
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING
	department = LOC_ENGINEERING

/area/horizon/engineering/drone_fabrication
	name = "Drone Fabrication"
	icon_state = "drone_fab"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	horizon_deck = 2

/area/horizon/engineering/storage_hard
	name = "Hard Storage"
	icon_state = "engineering_storage"
	horizon_deck = 2

/area/horizon/engineering/storage_eva
	name = "EVA Storage"
	icon_state = "engineering_storage"
	horizon_deck = 2

/area/horizon/engineering/break_room
	name = "Break Room"
	icon_state = "engineering_break"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR
	area_blurb = "The smell of coffee intermixed with oil linger in the air."
	area_blurb_category = "engi_breakroom"
	horizon_deck = 3

/area/horizon/engineering/locker_room
	name = "Locker Room"
	icon_state = "engineering_locker"
	horizon_deck = 2

/area/horizon/engineering/gravity_gen
	name = "Gravity Generator"
	icon_state = "engine"
	horizon_deck = 1

/area/horizon/engineering/lobby
	name = "Lobby"
	horizon_deck = 2

/area/horizon/engineering/storage/tech
	name = "Technical Storage"
	icon_state = "auxstorage"
	horizon_deck = 1

/area/horizon/engineering/storage/lower
	name = "Lower Deck Storage"
	horizon_deck = 1

/area/horizon/engineering/aft_airlock
	name = "Aft Service Airlock"
	horizon_deck = 2

/area/horizon/engineering/bluespace_drive
	name = "Bluespace Drive"
	icon_state = "engine"
	horizon_deck = 1

/area/horizon/engineering/bluespace_drive/monitoring
	name = "Bluespace Drive Monitoring"
	icon_state = "engineering"
	horizon_deck = 1

/area/horizon/engineering/shields
	name = "Shield Control"
	icon_state = "eva"
	horizon_deck = 3

/// Engineering Hallways
/area/horizon/engineering/hallway
	name = "Hallway (PARENT AREA - DON'T USE)"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/horizon/engineering/hallway/fore
	name = "Fore Hallway"

/area/horizon/engineering/hallway/aft
	name = "Aft Hallway"

/area/horizon/engineering/hallway/interior
	name = "Interior Hallway"

/// ENGINEERING_AREAS - ATMOSIA_AREAS
/area/horizon/engineering/atmos
	name = "Atmospherics Control"
	icon_state = "atmos"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	no_light_control = 1
	ambience = list(AMBIENCE_ENGINEERING, AMBIENCE_ATMOS)
	area_blurb = "Many volume tanks filled with gas reside here, some providing vital gases for the vessel's life support systems."
	area_blurb_category = "atmos"
	horizon_deck = 1
	subdepartment = SUBLOC_ATMOS

/area/horizon/engineering/atmos/storage
	name = "Atmospherics Storage"
	icon_state = "atmos_storage"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	horizon_deck = 2

/area/horizon/engineering/atmos/air
	name = "Air Mixing"
	horizon_deck = 1

/area/horizon/engineering/atmos/propulsion
	name = "Port Propulsion"
	icon_state = "blue2"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	horizon_deck = 1

/area/horizon/engineering/atmos/propulsion/starboard
	name = "Starboard Propulsion"
	icon_state = "blue-red2"
	horizon_deck = 1

/area/horizon/engineering/atmos/turbine
	name = "Combustion Turbine"
	horizon_deck = 1

/// ENGINEERING_AREAS - REACTOR_AREAS
/area/horizon/engineering/reactor
	name = "Engine (PARENT AREA - DON'T USE)"
	icon_state = "engine"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	no_light_control = 1
	ambience = AMBIENCE_SINGULARITY
	horizon_deck = 2

// We'll give this a cool custom icon one day.
/area/horizon/engineering/reactor/supermatter
	name = "Supermatter Reactor (PARENT AREA - DON'T USE)"

/area/horizon/engineering/reactor/supermatter/airlock
	name = "Supermatter Reactor Airlock"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/horizon/engineering/reactor/supermatter/mainchamber
	name = "Supermatter Reactor Chamber"

/area/horizon/engineering/smes
	name = "Supermatter Reactor Substation"
	icon_state = "engine_smes"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/horizon/engineering/reactor/supermatter/monitoring
	name = "Supermatter Reactor Monitoring"
	icon_state = "engine_monitoring"

/area/horizon/engineering/reactor/supermatter/waste
	name = "Supermatter Reactor Waste Handling"
	icon_state = "engine_waste"
	no_light_control = 1

// We'll give this a cool custom icon one day.
/area/horizon/engineering/reactor/indra
	name = "INDRA Reactor (PARENT AREA - DON'T USE)"

/area/horizon/engineering/reactor/indra/mainchamber
	name = "INDRA Reactor Chamber"
	ambience = AMBIENCE_SINGULARITY

/area/horizon/engineering/reactor/indra/smes
	name = "INDRA Reactor Substation"
	icon_state = "engine_smes"

/area/horizon/engineering/reactor/indra/monitoring
	name = "INDRA Reactor Monitoring"
	icon_state = "engine_monitoring"

/area/horizon/engineering/reactor/indra/office
	name = "INDRA Reactor Office"

/// TCOMMS_AREAS
/area/horizon/tcommsat
	ambience = AMBIENCE_ENGINEERING
	no_light_control = 1
	station_area = TRUE
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING
	horizon_deck = 3
	department = LOC_ENGINEERING
	subdepartment = SUBLOC_TELECOMMS

/area/horizon/tcommsat/entrance
	name = "Telecomms Entrance"
	icon_state = "tcomsatentrance"
	lightswitch = TRUE

/area/horizon/tcommsat/chamber
	name = "Telecomms Central Compartment"
	icon_state = "tcomsatcham"
	area_blurb = "Countless machines sit here, an unfathomably complicated network that runs every radio and computer connection. The air lacks any notable scent, having been filtered of dust and pollutants before being allowed into the room and all the sensitive machinery."
