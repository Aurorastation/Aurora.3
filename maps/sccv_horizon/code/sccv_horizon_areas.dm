/**
 *	Definitions for every area used on the SCCV Horizon map.
 *
 *	Each department (or other appropriate grouping) will have its own section that you can jump to with ctrl-f.
 *	For convenience, these groupings are:
 *	CREW_AREAS			Catch-all areas, I.E. hallways, staff head offices, etc.
 *	COMMAND_AREAS		Command areas
 *	ENGINEERING_AREAS	Engineering dept areas
 *	MAINTENANCE_AREAS	Maintenance tunnels
 *	MEDICAL_AREAS		Medical dept areas
 *	OPERATIONS_AREAS	Operations & Logistics dept areas
 *	SCIENCE_AREAS		Science dept areas
 *	SECURITY_AREAS		Security dept areas
 *	SERVICE_AREAS		Service dept areas
 *	TCOMMS_AREAS		Telecomms areas
 *
 *	GUIDELINES:
 *	- The Horizon should not have any areas mapped to it which are defined outside this file.
 *	- Any PR that removes all areas of a given definition should also remove that definition from this file.
 *	- No area should exist across multiple decks. Ex., an elevator vestibule on all three decks should have three
 *	child definitions, one for each deck. This is both for organization and for managing area objects like APCs etc.
 *	- Update the groupings list if anything is added/removed.
 */

//
// SCCV Horizon Areas
//
/area/horizon
	name = "Horizon (PARENT AREA - DON'T USE)"
	icon_state = "unknown"
	station_area = TRUE
	ambience = AMBIENCE_GENERIC

// Exterior
/area/horizon/exterior
	name = "Horizon - Exterior"
	icon_state = "exterior"
	base_turf = /turf/space
	dynamic_lighting = TRUE
	requires_power = FALSE
	has_gravity = FALSE
	no_light_control = TRUE
	allow_nightmode = FALSE
	ambience = AMBIENCE_SPACE
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP

/// CREW_AREAS
/// COMMAND_AREAS
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


/// MAINTENANCE_AREAS
/// MEDICAL_AREAS
/area/medical/ors
	name = "Medical - Combined Operating Rooms"
	icon_state = "surgery"

/area/medical/exam
	name = "Medical - Examination Room"
	icon_state = "exam_room"

/area/medical/ward
	name = "Medical - Ward"
	icon_state = "patients"

/area/medical/ward/isolation
	name = "Medical - Isolation Ward"
	area_blurb = "This seldom-used ward somehow smells sterile and musty at the same time."
	area_blurb_category = "medical_isolation"

/area/medical/emergency_storage
	name = "Medical - Lower Deck Emergency Storage"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/medical/morgue/lower
	name = "Medical - Morgue"
	icon_state = "morgue"
	ambience = AMBIENCE_GHOSTLY

/area/medical/equipment
	name = "Medical - Equipment Room"

/area/medical/smoking
	name = "Medical - Smoking Lounge"
	area_blurb = "The smell of cigarette smoke lingers within this room."
	area_blurb_category = "medical_smoking"

/area/medical/washroom
	name = "Medical - Washroom"

/area/hallway/medical
	name = "Medical - Atrium"
	holomap_color = HOLOMAP_AREACOLOR_MEDICAL
	icon_state = "medbay"

/area/hallway/medical/upper
	name = "Medical - Upper Atrium"

/area/hallway/crew_area
	name = "Crew Quarters Hallway"
	icon_state = "crew_area"

/// OPERATIONS_AREAS
/area/horizon/operations
	name = "Operations"
	icon_state = "dark"
	ambience = AMBIENCE_ENGINEERING
	station_area = TRUE
	holomap_color = HOLOMAP_AREACOLOR_OPERATIONS

/area/horizon/operations/lower
	name = "Lower Operations"
	icon_state = "dark160"

/area/horizon/operations/upper
	name = "Upper Operations"
	icon_state = "dark128"

/area/horizon/operations/storage
	name = "Operations Equipment Storage"
	icon_state = "dark160"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	area_blurb = "Scuff marks scar the floor from the movement of many crates and stored goods."
	area_blurb_category = "ops_warehouse"

/area/horizon/operations/lobby
	name = "Operations Lobby"

/area/horizon/operations/loading
	name = "Operations Bay"
	icon_state = "quartloading"

/area/horizon/operations/break_room
	name = "Operations Break Room"
	icon_state = "blue"

/area/horizon/operations/office
	name = "Operations Office"
	icon_state = "quartoffice"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/horizon/operations/office_aux
	name = "Operations Office (Aux)"
	icon_state = "quartoffice"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/horizon/operations/mail_room
	name = "Operations Mail Room"
	icon_state = "red"

/area/horizon/operations/qm
	name = "Operations Manager's Office"
	icon_state = "quart"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/// OPERATIONS_AREAS - HANGAR_AREAS
/area/horizon/hangar
	name = "Hangar"
	icon_state = "bluenew"
	ambience = AMBIENCE_HANGAR
	sound_environment = SOUND_ENVIRONMENT_HANGAR
	holomap_color = HOLOMAP_AREACOLOR_HANGAR

/area/horizon/hangar/briefing
	name = "Expedition Briefing Room"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/horizon/hangar/control
	name = "Hangar Control Room"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/horizon/hangar/intrepid
	name = "Intrepid Hangar"
	area_blurb = "A big, open room, home to the SCCV Horizon's largest shuttle, the Intrepid."
	area_blurb_category = "intrepid_hanger"

/area/horizon/hangar/intrepid/interstitial
	name = "Intrepid Hangar Access"

/area/horizon/hangar/operations
	name = "Operations Hangar"

/area/horizon/hangar/auxiliary
	name = "Auxiliary Hangar"

/// OPERATIONS_AREAS - MACHINIST_AREAS
/area/horizon/operations/lower/machinist
	name = "Machinist Workshop"
	icon_state = "machinist_workshop"
	area_blurb = "The scents of oil and mechanical lubricants fill the air in this workshop."
	area_blurb_category = "robotics"

/area/horizon/operations/lower/machinist/surgicalbay
	name = "Machinist Surgical Bay"
	icon_state = "machinist_workshop"
	area_blurb = "The scent of sterilized equipment fill the air in this surgical bay."
	area_blurb_category = "robotics"

/// OPERATIONS_AREAS - MINING_AREAS

/// SCIENCE_AREAS
/// SECURITY_AREAS
/// SERVICE_AREAS
/// TCOMMS_AREAS


//Medical


//Research

/area/rnd/conference
	name = "Research - Conference Room"

//Hangar



//Operations



//Propulsion

//Bridge
/area/horizon/crew/command/heads/xo
	name = "Command - Executive Officer's Office"

/area/bridge/bridge_crew
	name = "Bridge Crew Preparation"
	icon_state = "bridge_crew"

/area/bridge/helm
	name = "Bridge Helm"
	icon_state = "bridge_helm"

/area/bridge/supply
	name = "Bridge Supply Closet"
	icon_state = "bridge_crew"

//Crew quarters

/area/crew_quarters/lounge
	name = "Crew Lounge"
	icon_state = "lounge"

/area/crew_quarters/lounge/secondary
	name = "Secondary Crew Lounge"
	icon_state = "lounge2"

// Infrastructure

/area/storage/shields
	name = "Ship Shield Control"
	icon_state = "eva"

//shuttles

/area/shuttle/intrepid
	name = "Intrepid"
	icon_state = "intrepid"
	requires_power = TRUE

/area/shuttle/intrepid/main_compartment
	name = "Intrepid Main Compartment"

/area/shuttle/intrepid/port_compartment
	name = "Intrepid Port Compartment"

/area/shuttle/intrepid/starboard_compartment
	name = "Intrepid Starboard Compartment"

/area/shuttle/intrepid/junction_compartment
	name = "Intrepid Junction Compartment"

/area/shuttle/intrepid/buffet
	name = "Intrepid Buffet"

/area/shuttle/intrepid/medical
	name = "Intrepid Medical Compartment"

/area/shuttle/intrepid/engineering
	name = "Intrepid Engineering Compartment"

/area/shuttle/intrepid/port_storage
	name = "Intrepid Port Nacelle"

/area/shuttle/intrepid/flight_deck
	name = "Intrepid Flight Deck"

/area/shuttle/canary
	name = "Canary"
	requires_power = TRUE

/area/shuttle/quark/cockpit
	name = "Quark Cockpit"
	requires_power = TRUE

/area/shuttle/quark/cargo_hold
	name = "Quark Cargo Hold"
	requires_power = TRUE

/********** Hallways Start **********/
// Hallways
/area/horizon/hallway
	name = "Horizon - Hallway (PARENT AREA - DON'T USE)"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	allow_nightmode = TRUE
	lightswitch = TRUE
	holomap_color = HOLOMAP_AREACOLOR_HALLWAYS
	emergency_lights = TRUE

/area/horizon/hallway/deck_three/primary/central
	name = "Horizon - Deck 3 - Central Primary Hallway"
	icon_state = "hallC"

/area/horizon/hallway/deck_three/primary/starboard
	name = "Horizon - Deck 3 - Starboard Primary Hallway"
	icon_state = "hallS"

/area/horizon/hallway/deck_three/primary/starboard/docks
	name = "Horizon - Deck 3 - Starboard Primary Hallway - Docks"
	holomap_color = HOLOMAP_AREACOLOR_DOCK

/area/horizon/hallway/deck_three/primary/port
	name = "Horizon - Deck 3 - Port Primary Hallway"
	icon_state = "hallP"

/area/horizon/hallway/deck_three/primary/port/docks
	name = "Horizon - Deck 3 - Port Primary Hallway - Docks"
	holomap_color = HOLOMAP_AREACOLOR_DOCK

/area/horizon/hallway/deck_two/fore
	name = "Horizon - Deck 2 - Fore Hallway"
	icon_state = "hallF"
/********** Hallways End **********/

/********** Stairwells Start **********/
// Stairwells
/area/horizon/stairwell
	name = "Horizon - Stairwell (PARENT AREA - DON'T USE)"
	area_flags = AREA_FLAG_RAD_SHIELDED
	holomap_color = HOLOMAP_AREACOLOR_HALLWAYS

/area/horizon/stairwell/central
	name = "Horizon - Central Stairwell"
	icon_state = "stairwell"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/horizon/stairwell/bridge
	name = "Horizon - Bridge Stairwell"
	icon_state = "bridge_stairs"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	ambience = AMBIENCE_HIGHSEC
/********** Stairwells End **********/

/********** Crew Quarters Start **********/
// Crew Quarters
/area/horizon/crew
	name = "Horizon - Crew Quarters (PARENT AREA - DON'T USE)"
	area_flags = AREA_FLAG_RAD_SHIELDED
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

// Cryogenics
/area/horizon/crew/cryo
	name = "Horizon - Cryogenic Storage"
	icon_state = "Sleep"

/area/horizon/crew/cryo/living_quarters_lift
	name = "Horizon - Living Quarters Lift"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/horizon/crew/cryo/dormitories
	name = "Horizon - Cryogenic Storage - Dormitories"

/area/horizon/crew/cryo/washroom
	name = "Horizon - Cryogenic Storage - Washroom"
	icon_state = "washroom"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/horizon/crew/cryo/showers
	name = "Horizon - Cryogenic Storage - Showers"
	icon_state = "showers"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

// Fitness Center
/area/horizon/crew/fitness
	name = "Horizon - Fitness Center (PARENT AREA - DON'T USE)"
	icon_state = "fitness"

/area/horizon/crew/fitness/hallway
	name = "Horizon - Fitness Center Hallway"
	icon_state = "fitness_hallway"

/area/horizon/crew/fitness/pool
	name = "Horizon - Fitness Center - Pool"
	icon_state = "fitness_pool"

/area/horizon/crew/fitness/gym
	name = "Horizon - Fitness Center - Gym"
	icon_state = "fitness_gym"

/area/horizon/crew/fitness/changing
	name = "Horizon - Fitness Center - Changing Room"
	icon_state = "fitness_changingroom"

/area/horizon/crew/fitness/washroom
	name = "Horizon - Fitness Center - Washroom"
	icon_state = "washroom"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/horizon/crew/fitness/showers
	name = "Horizon - Fitness Center - Showers"
	icon_state = "showers"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/horizon/crew/fitness/lounge
	name = "Horizon - Fitness Center - Lounge"
	icon_state = "fitness_lounge"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

// Lounges
/area/horizon/crew/lounge/bar
	name = "Horizon - Bar Lounge"
	icon_state = "lounge"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

// Miscellanous
/area/horizon/crew/washroom/central
	name = "Horizon - Central Washroom"
	icon_state = "washroom"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/********** Crew Quarters End **********/

/********** Holodeck Start **********/
// Holodeck
/area/horizon/holodeck_control
	name = "Horizon - Holodeck Alpha"
	area_flags = AREA_FLAG_RAD_SHIELDED
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

/area/horizon/holodeck_control/beta
	name = "Horizon - Holodeck Beta"

/area/horizon/holodeck
	name = "Horizon - Holodeck (PARENT AREA - DON'T USE)"
	icon_state = "Holodeck"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	no_light_control = TRUE
	dynamic_lighting = FALSE
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_NO_GHOST_TELEPORT_ACCESS
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

/area/horizon/holodeck/alphadeck
	name = "Horizon - Holodeck Alpha"
	dynamic_lighting = TRUE

/area/horizon/holodeck/betadeck
	name = "Horizon - Holodeck Beta"
	dynamic_lighting = TRUE

/area/horizon/holodeck/source_plating
	name = "Horizon - Holodeck - Off"

/area/horizon/holodeck/source_chapel
	name = "Horizon - Holodeck - Chapel"

/area/horizon/holodeck/source_gym
	name = "Horizon - Holodeck - Gym"
	sound_environment = SOUND_ENVIRONMENT_ARENA

/area/horizon/holodeck/source_range
	name = "Horizon - Holodeck - Range"
	sound_environment = SOUND_ENVIRONMENT_ARENA

/area/horizon/holodeck/source_emptycourt
	name = "Horizon - Holodeck - Empty Court"
	sound_environment = SOUND_ENVIRONMENT_ARENA

/area/horizon/holodeck/source_boxingcourt
	name = "Horizon - Holodeck - Boxing Court"
	sound_environment = SOUND_ENVIRONMENT_ARENA

/area/horizon/holodeck/source_basketball
	name = "Horizon - Holodeck - Basketball Court"
	sound_environment = SOUND_ENVIRONMENT_ARENA

/area/horizon/holodeck/source_thunderdomecourt
	name = "Horizon - Holodeck - Thunderdome Court"
	sound_environment = SOUND_ENVIRONMENT_ARENA

/area/horizon/holodeck/source_courtroom
	name = "Horizon - Holodeck - Courtroom"
	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM

/area/horizon/holodeck/source_burntest
	name = "Horizon - Holodeck - Atmospheric Burn Test"

/area/horizon/holodeck/source_wildlife
	name = "Horizon - Holodeck - Wildlife Simulation"

/area/horizon/holodeck/source_meetinghall
	name = "Horizon - Holodeck - Meeting Hall"
	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM

/area/horizon/holodeck/source_theatre
	name = "Horizon - Holodeck - Callistean Theatre"
	sound_environment = SOUND_ENVIRONMENT_CONCERT_HALL

/area/horizon/holodeck/source_picnicarea
	name = "Horizon - Holodeck - Picnic Area"
	sound_environment = SOUND_ENVIRONMENT_PLAIN

/area/horizon/holodeck/source_dininghall
	name = "Horizon - Holodeck - Dining Hall"
	sound_environment = SOUND_ENVIRONMENT_PLAIN

/area/horizon/holodeck/source_snowfield
	name = "Horizon - Holodeck - Bursa Tundra"
	sound_environment = SOUND_ENVIRONMENT_FOREST

/area/horizon/holodeck/source_desert
	name = "Horizon - Holodeck - Desert"
	sound_environment = SOUND_ENVIRONMENT_PLAIN

/area/horizon/holodeck/source_space
	name = "Horizon - Holodeck - Space"
	has_gravity = FALSE
	sound_environment = SOUND_AREA_SPACE

/area/horizon/holodeck/source_battlemonsters
	name = "Horizon - Holodeck - Battlemonsters Arena"
	sound_environment = SOUND_ENVIRONMENT_ARENA

/area/horizon/holodeck/source_chessboard
	name = "Horizon - Holodeck - Chessboard"

/area/horizon/holodeck/source_adhomai
	name = "Horizon - Holodeck - Adhomian Campfire"

/area/horizon/holodeck/source_beach
	name = "Horizon - Holodeck - Silversunner Coast"
	sound_environment = SOUND_ENVIRONMENT_PLAIN

/area/horizon/holodeck/source_pool
	name = "Horizon - Holodeck - Swimming Pool"

/area/horizon/holodeck/source_sauna
	name = "Horizon - Holodeck - Sauna"

/area/horizon/holodeck/source_jupiter
	name = "Horizon - Holodeck - Jupiter Upper Atmosphere"

/area/horizon/holodeck/source_konyang
	name = "Horizon - Holodeck - Konyanger Boardwalk"

/area/horizon/holodeck/source_moghes
	name = "Horizon - Holodeck - Moghresian Jungle"

/area/horizon/holodeck/source_biesel
	name = "Horizon - Holodeck - Foggy Mendell Skyline"

/area/horizon/holodeck/source_tribunal
	name = "Horizon - Holodeck - Tribunalist Chapel"

/area/horizon/holodeck/source_trinary
	name = "Horizon - Holodeck - Trinarist Chapel"

/area/horizon/holodeck/source_cafe
	name = "Horizon - Holodeck - Animal Cafe"

/area/horizon/holodeck/source_lasertag
	name = "Horizon - Holodeck - Laser Tag Arena"

/area/horizon/holodeck/source_combat_training
	name = "Horizon - Holodeck - Combat Training Arena"

/********** Holodeck End **********/

/********** Unique Start **********/
// Hydroponics
/area/horizon/hydroponics
	name = "Horizon - Hydroponics"
	icon_state = "hydro"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

/area/horizon/hydroponics/lower
	name = "Horizon - Hydroponics - Lower"

/area/horizon/hydroponics/garden
	name = "Horizon - Public Garden"
	icon_state = "garden"

// Library
/area/horizon/library
	name = "Horizon - Library"
	icon_state = "library"
	sound_environment = SOUND_AREA_LARGE_SOFTFLOOR
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

// Kitchen
/area/horizon/kitchen
	name = "Horizon - Kitchen"
	icon_state = "kitchen"
	allow_nightmode = FALSE
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

/area/horizon/kitchen/hallway
	name = "Horizon - Kitchen - Hallway"

/area/horizon/kitchen/freezer
	name = "Horizon - Kitchen - Freezer"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

// Bar
/area/horizon/bar
	name = "Horizon - Bar"
	icon_state = "bar"
	allow_nightmode = FALSE
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

/area/horizon/bar/backroom
	name = "Horizon - Bar - Backroom"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN
	area_flags = AREA_FLAG_RAD_SHIELDED

// Cafeteria
/area/horizon/cafeteria
	name = "Horizon - Deck 3 Cafeteria"
	icon_state = "cafeteria"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN
	area_blurb = "The smell of coffee wafts over from the cafe. Patience, the tree, stands proudly in the centre of the atrium."
	area_blurb_category = "d3_cafe"

// Custodial
/area/horizon/custodial
	name = "Horizon - Custodial Closet"
	icon_state = "janitor"
	allow_nightmode = FALSE
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	ambience = list(AMBIENCE_FOREBODING, AMBIENCE_ENGINEERING)
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN
	area_blurb = "A strong, concentrated smell of many cleaning supplies linger within this room."
	area_blurb_category = "janitor"

/area/horizon/custodial/disposals
	name = "Horizon - Disposals and Recycling"
	icon_state = "disposal"
	ambience = list(AMBIENCE_ENGINEERING, AMBIENCE_ATMOS) // Industrial sounds.
	area_blurb = "A large trash compactor takes up much of the room, ready to crush the ship's rubbish."
	area_blurb_category = "trash_compactor"

/area/horizon/custodial/auxiliary
	name = "Horizon - Auxiliary Custodial Closet"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN


// Security (Deck 2)
/area/horizon/security
	name = "Horizon - Security (PARENT AREA - DON'T USE)"
	holomap_color = HOLOMAP_AREACOLOR_SECURITY

/area/horizon/security/lobby
	name = "Horizon - Security - Lobby"
	icon_state = "security"

/area/horizon/security/office
	name = "Horizon - Security - Office"
	icon_state = "security"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/horizon/security/hallway
	name = "Horizon - Security - Main Hallway"
	icon_state = "security"

/area/horizon/security/equipment
	name = "Horizon - Security - Equipment Room"
	icon_state = "security"

/area/horizon/security/washroom
	name = "Horizon - Security - Washroom"
	icon_state = "security"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/horizon/security/brig
	name = "Horizon - Security - Brig"
	icon_state = "brig"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_PRISON
	ambience = AMBIENCE_HIGHSEC

/area/horizon/security/holding_cell_a
	name = "Horizon - Security - Holding Cell A"
	icon_state = "brig_proc"

/area/horizon/security/holding_cell_b
	name = "Horizon - Security - Holding Cell B"
	icon_state = "brig_proc_two"

/area/horizon/security/head_of_security
	name = "Horizon - Security - Head of Security's Office"
	icon_state = "head_quarters"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP
	ambience = AMBIENCE_HIGHSEC
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/horizon/security/warden
	name = "Horizon - Security - Warden's Office"
	icon_state = "Warden"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP
	ambience = AMBIENCE_HIGHSEC
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/horizon/security/armoury
	name = "Horizon - Security - Armoury"
	icon_state = "Warden"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP
	ambience = AMBIENCE_HIGHSEC
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

// Security (Deck 3)
/area/horizon/security/investigations_hallway
	name = "Horizon - Security - Investigations Hallway"
	icon_state = "security"

/area/horizon/security/meeting_room
	name = "Horizon - Security - Meeting Room"
	icon_state = "security"

/area/horizon/security/firing_range
	name = "Horizon - Security - Firing Range"
	icon_state = "security"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/horizon/security/investigators_office
	name = "Horizon - Security - Investigators' Office"
	icon_state = "investigations_office"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/horizon/security/interrogation
	name = "Horizon - Security - Interrogation"
	icon_state = "investigations"
	ambience = list(AMBIENCE_HIGHSEC, AMBIENCE_FOREBODING)
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/horizon/security/interrogation/monitoring
	name = "Horizon - Security - Interrogation Monitoring"

/area/horizon/security/forensic_laboratory
	name = "Horizon - Security - Forensic Laboratory"
	icon_state = "investigations"

/area/horizon/security/autopsy_laboratory
	name = "Horizon - Security - Autopsy Laboratory"
	icon_state = "investigations"
	ambience = list(AMBIENCE_GHOSTLY, AMBIENCE_FOREBODING)

/area/horizon/security/evidence_storage
	name = "Horizon - Security - Evidence Storage"
	icon_state = "evidence"
	ambience = AMBIENCE_FOREBODING
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

// Commissary
/area/horizon/commissary
	name = "Horizon - Commissary"
/********** Unique End **********/

/********** Weapon Systems Start **********/
// Secure Ammunition Storage
/area/horizon/secure_ammunition_storage
	name = "Horizon - Secure Ammunitions Storage"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	ambience = AMBIENCE_FOREBODING
	holomap_color = HOLOMAP_AREACOLOR_OPERATIONS

// ZAT
/area/horizon/zat
	name = "Horizon - ZAT Weapon System"
	icon_state = "zat"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	ambience = AMBIENCE_SINGULARITY
	area_blurb = "A gargantuan machine dominates the room, covered in components and moving parts. Its name is befitting of its size."
	area_blurb_category = "leviathan"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP

// Longbow
/area/horizon/longbow
	name = "Horizon - Longbow Weapon System"
	icon_state = "bridge_weapon"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	ambience = AMBIENCE_HIGHSEC
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP

/area/horizon/grauwolf
	name = "Horizon - Grauwolf Weapon System"
	icon_state = "bridge_weapon"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	ambience = AMBIENCE_HIGHSEC
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP

/********** Weapon Systems End **********/

/// STORAGE_AREAS
/area/horizon/storage
	station_area = TRUE

/area/horizon/storage/eva
	name = "EVA Storage"
	icon_state = "eva"

/area/horizon/storage/primary
	name = "Primary Tool Storage"
	icon_state = "primarystorage"
	allow_nightmode = 1

/area/horizon/storage/secure
	name = "Secure Storage"
	icon_state = "storage"

/area/horizon/storage/shields
	name = "Station Shield Control"
	icon_state = "eva"

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

/// MAINTENANCE_AREAS
//Maintenance
/********** Maintenance Start **********/
// Maintenance
/area/horizon/maintenance
	name = "Horizon - Maintenance (PARENT AREA - DON'T USE)"
	icon_state = "maintenance"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_HIDE_FROM_HOLOMAP
	sound_environment = SOUND_AREA_TUNNEL_ENCLOSED
	turf_initializer = new /datum/turf_initializer/maintenance()
	area_blurb = "Scarcely lit, cramped, and filled with stale, dusty air. Around you hisses compressed air through the pipes, a buzz of electrical charge through the wires, and muffled rumbles of the hull settling. This place may feel alien compared to the interior of the ship and is a place where one could get lost or badly hurt, but some may find the isolation comforting."
	area_blurb_category = "maint"
	ambience = AMBIENCE_MAINTENANCE

/area/horizon/maintenance/deck_two/fore/starboard
	name = "Horizon - Maintenance - Deck Two - Fore Starboard"

/area/horizon/maintenance/deck_two/fore/port
	name = "Horizon - Maintenance - Deck Two - Fore Port"

/area/horizon/maintenance/deck_three/aft/starboard
	name = "Horizon - Maintenance - Deck Three - Aft Starboard"

/area/horizon/maintenance/aft
	name = "Aft Maintenance"
	icon_state = "amaint"

/area/horizon/maintenance/maintcentral
	name = "Bridge Maintenance"
	icon_state = "maintcentral"

/area/horizon/maintenance/engineering
	name = "Engineering Maintenance"
	icon_state = "maint_engineering"

/area/horizon/maintenance/engineering/auxillary
	name = "Auxillary Engineering Maintenance"
	icon_state = "maint_engineering"

/area/horizon/maintenance/research_port
	name = "Research Maintenance - Port"
	icon_state = "maint_research_port"

/area/horizon/maintenance/engineering_ladder
	name = "Engineering Ladder Shaft"
	icon_state = "maint_engineering"

/area/horizon/maintenance/security_port
	name = "Security Maintenance - Port"
	icon_state = "maint_security_port"

/area/horizon/maintenance/bridge
	name = "Bridge Maintenance"
	icon_state = "maintcentral"

/area/horizon/maintenance/operations
	name = "Operations Maintenance"
	icon_state = "maint_cargo"

/area/horizon/maintenance/aux_atmospherics/deck_2/starboard
	name = "Starboard Auxiliary Atmospherics"
/area/horizon/maintenance/aux_atmospherics/deck_2/starboard/wing
	name = "Starboard Wing Auxiliary Atmospherics"
/area/horizon/maintenance/aux_atmospherics/deck_3
	name = "Central Auxiliary Atmospherics"

//Wings

/area/horizon/maintenance/substation/wing_starboard
	name = "Starboard Wing Substation"

/area/horizon/maintenance/substation/wing_port
	name = "Port Wing Substation"

/area/horizon/maintenance/hangar
	name = "Hangar Maintenance"

/area/horizon/maintenance/hangar/port
	name = "Port Hangar Maintenance"

/area/horizon/maintenance/hangar/starboard
	name = "Starboard Hangar Maintenance"

/area/horizon/maintenance/wing
	name = "Wing Frame Maintenance"
	icon_state = "fpmaint"

/area/horizon/maintenance/wing/starboard
	name = "Central Wing Frame Interior - Starboard"

/area/horizon/maintenance/wing/starboard/far
	name = "Central Wing Frame Interior - Far Starboard"

/area/horizon/maintenance/wing/starboard/deck1
	name = "Lower Wing Frame Interior - Starboard"

/area/horizon/maintenance/wing/port
	name = "Central Wing Frame Interior - Port"

/area/horizon/maintenance/wing/port/far
	name = "Central Wing Frame Interior - Far Port"

/area/horizon/maintenance/wing/port/deck1
	name = "Lower Wing Frame Interior - Port"

// SUBSTATIONS (Subtype of maint, that should let them serve as shielded area during radstorm)

/area/horizon/maintenance/substation
	name = "Substation"
	icon_state = "substation"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	ambience = AMBIENCE_SUBSTATION
	area_blurb = "The hum of the substation's machinery fills the room, holding equipment made to transform voltage and manage power supply to various rooms, and to act as an emergency battery. In comparison to the maintenance tunnels, these stations are far less dusty."
	area_blurb_category = "substation"

/area/horizon/maintenance/substation/engineering // Engineering
	name = "Engineering Substation"

/area/horizon/maintenance/substation/engineering/lower
	name = "Engineering Substation - Lower Deck"

/area/horizon/maintenance/substation/medical // Medbay
	name = "Main Lvl. Medical Substation"

/area/horizon/maintenance/substation/research // Research
	name = "Main Lvl. Research Substation"

/area/horizon/maintenance/substation/research_sublevel
	name = "Research Sublevel - Substation"

/area/horizon/maintenance/substation/civilian_east // Bar, kitchen, dorms, ...
	name = "Surface Lvl. Civilian Substation"

/area/horizon/maintenance/substation/civilian_west // PTS, locker room, probably arrivals, ...)
	name = "Main Lvl. Civilian Substation"

/area/horizon/maintenance/substation/command // AI and central cluster. This one will be between HoP office and meeting room (probably).
	name = "Command Substation"

/area/horizon/maintenance/substation/security // Security, Brig, Permabrig, etc.
	name = "Security Substation"

/area/horizon/maintenance/substation/interstitial // Construction Level.
	name = "Construction Level Substation"

/area/horizon/maintenance/substation/supply // Cargo and Mining.
	name = "Main Lvl. Supply Substation"

/area/horizon/maintenance/substation/xenoarchaeology
	name = "Xenoarchaeology Substation"

/area/horizon/maintenance/substation/hangar
	name = "Hangar Substation"
