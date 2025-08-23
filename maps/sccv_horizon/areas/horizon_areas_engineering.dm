/// ENGINEERING_AREAS
/area/horizon/engineering
	name = "Engineering (PARENT AREA - DON'T USE)"
	icon_state = "engineering"
	ambience = AMBIENCE_ENGINEERING
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING
	department = LOC_ENGINEERING
	area_blurb = "The engineering sectors of the ship tend to be a little noisier and more utilitarian than most."

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
	area_blurb = "The intermixed odors of coffee and oil lingers in the air."
	area_blurb_category = "engi_breakroom"
	horizon_deck = 3

/area/horizon/engineering/locker_room
	name = "Locker Room"
	icon_state = "engineering_locker"
	horizon_deck = 2
	area_blurb = "It's not the most pleasantly fragrant locker room on the ship, but is probably the most orderly."

/area/horizon/engineering/gravity_gen
	name = "Gravity Generator"
	icon_state = "engine"
	horizon_deck = 1
	area_flags = AREA_FLAG_RAD_SHIELDED
	area_blurb = "The air in here tastes like copper, sour sugar, and smoke; none of the angles seem right. That probably means everything is working."
	area_blurb_category = "engi_breakroom"

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
	name = "Aft Stowage Airlock"
	horizon_deck = 2

/area/horizon/engineering/bluespace_drive
	name = "Bluespace Drive"
	icon_state = "engine"
	horizon_deck = 1

/area/horizon/engineering/bluespace_drive/monitoring
	name = "Bluespace Drive Monitoring"
	area_flags = AREA_FLAG_RAD_SHIELDED
	icon_state = "engineering"
	horizon_deck = 1

/area/horizon/engineering/shields
	name = "Shield Control"
	icon_state = "eva"
	horizon_deck = 3

/// Engineering Hallways
/area/horizon/engineering/hallway
	name = "Engineering Hallway (PARENT AREA - DON'T USE)"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	horizon_deck = 2

/area/horizon/engineering/hallway/fore
	// Location is defined here relative to the department center itself. Whatever.
	name = "Fore Hallway"
	area_blurb = "The sound of the ship's machinery grows louder the further aft you move. Machine oil, ozone, welding fumes, and combustion products begin to scent the air."

/area/horizon/engineering/hallway/aft
	// Location is defined here relative to the department center itself. Whatever.
	name = "Aft Hallway"
	area_blurb = "Filled with the sounds of machinery and an atmosphere of meaningful, directed purpose. The tops of the exterior stowage tanks are visible from the aft windows, hunched like patient stones."

/area/horizon/engineering/hallway/interior
	// Location is defined here relative to the department center itself. Whatever.
	name = "Amidships Hallway"
	area_blurb = "Filled with the sounds of machinery and an atmosphere of meaningful, directed purpose."

/// ENGINEERING_AREAS - ATMOSIA_AREAS
/area/horizon/engineering/atmos
	name = "Distribution Control"
	icon_state = "atmos"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	no_light_control = 1
	ambience = list(AMBIENCE_ENGINEERING, AMBIENCE_ATMOS)
	area_blurb = "Many volume tanks filled with gas reside here, some providing vital gases for the vessel's life support systems. \
	Through the aft windows, exterior stowage tanks filled mostly with hazardous or volatile gases loom patiently."
	area_blurb_category = "atmos"
	horizon_deck = 1
	subdepartment = SUBLOC_ATMOS

/area/horizon/engineering/atmos/storage
	name = "Atmos Storage"
	icon_state = "atmos_storage"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	area_blurb = "The softly reassuring sounds of churning humming whirring resound gently from the distribution control compartment below."
	horizon_deck = 2

/area/horizon/engineering/atmos/air
	name = "Air Mixing"

/area/horizon/engineering/atmos/propulsion
	name = "Propulsion"
	subdepartment = null
	icon_state = "blue2"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	area_blurb = "Every bulkhead is invisibly tense with the long-term strains of powerful impulse. The subtle aromas of various fuel compounds linger in the air."
	location_ew = LOC_PORT
	location_ns = LOC_AFT_FAR

/area/horizon/engineering/atmos/propulsion/starboard
	name = "Propulsion"
	icon_state = "blue-red2"
	location_ew = LOC_STARBOARD

/area/horizon/engineering/atmos/turbine
	name = "Combustion Turbine"
	area_blurb = "It feels like this compartment gets smaller every time you enter it! What's with that?!"

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
	area_blurb = "It's like clambering into the gullet of a monster."

/area/horizon/engineering/reactor/supermatter/mainchamber
	name = "Supermatter Reactor Chamber"
	area_blurb = "The air throbs with subdued lethality. Phoronic science breaks the laws of thermodynamics in this chamber, and the laws of thermodynamics seem angry."

/area/horizon/engineering/reactor/supermatter/smes
	name = "Supermatter Reactor SMES"
	icon_state = "engine_smes"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	area_blurb = "One could almost feel bad for the PSU in here."

/area/horizon/engineering/reactor/supermatter/monitoring
	name = "Supermatter Reactor Monitoring"
	icon_state = "engine_monitoring"
	area_flags = AREA_FLAG_RAD_SHIELDED
	area_blurb = "This compartment provides a fairly convincing illusion of safety and control."

/area/horizon/engineering/reactor/supermatter/waste
	name = "Supermatter Reactor Waste Handling"
	icon_state = "engine_waste"
	no_light_control = 1
	area_blurb = "Carefully threaded systems regulate the offgas products of the Supermatter Crystal in here, their final destination to be forever argued over by Atmospheric Technicians."

// We'll give this a cool custom icon one day.
/area/horizon/engineering/reactor/indra
	name = "INDRA Reactor (PARENT AREA - DON'T USE)"

/area/horizon/engineering/reactor/indra/mainchamber
	name = "INDRA Reactor Chamber"
	ambience = AMBIENCE_SINGULARITY
	area_blurb = "The product of over four-hundred years' iteration and refinement: the INDRA Mk.II Tokamak Fusion bottle and its vast supporting machineries dominate the entire compartment"

/area/horizon/engineering/reactor/indra/smes
	name = "INDRA Reactor SMES"
	icon_state = "engine_smes"
	area_blurb = "A quiet hum suffuses this compartment from grid balancing hardware and power banks fitted beneath the floor."

/area/horizon/engineering/reactor/indra/monitoring
	name = "INDRA Reactor Monitoring"
	icon_state = "engine_monitoring"
	area_flags = AREA_FLAG_RAD_SHIELDED
	area_blurb = "Where atoms are consigned to be smashed and the pretty lights beheld."

/area/horizon/engineering/reactor/indra/office
	name = "INDRA Reactor Office"
	area_blurb = "A dingy, forgotten compartment a year or three away from looking about as well-kept as the Maints'."

// The engineering stairwell /area/horizon/stairwell/engineering/* are defined in './horizon_areas_crew.dm'. Bat put them there originally because they felt that made sense. If you don't, migrate them here I guess, everything's cool.

/// TCOMMS_AREAS
/area/horizon/tcommsat
	ambience = AMBIENCE_ENGINEERING
	no_light_control = 1
	station_area = TRUE
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING
	horizon_deck = 3
	area_blurb = "Countless machines sit within these compartments, an unfathomably complex network that runs every radio and computer connection. \
	The air lacks any notable scent, having been filtered of dust and pollutants for the sake of all the sensitive machinery."
	department = LOC_ENGINEERING
	subdepartment = SUBLOC_TELECOMMS

/area/horizon/tcommsat/entrance
	name = "Telecomms Entrance"
	icon_state = "tcomsatentrance"
	lightswitch = TRUE

/area/horizon/tcommsat/chamber
	name = "Telecomms Central Compartment"
	icon_state = "tcomsatcham"
