//Engineering

/area/engineering/lobby
	name = "Engineering - Lobby"

/area/engineering/storage/tech
	name = "Engineering - Technical Storage"
	icon_state = "auxstorage"

/area/engineering/storage/lower
	name = "Engineering - Lower Deck Storage"

/area/engineering/aft_airlock
	name = "Engineering - Aft Service Airlock"

/area/engineering/rust_office
	name = "Engineering - INDRA Office"

/area/engineering/engine_room/rust
	name = "Engineering - INDRA Engine"

/area/engineering/smes
	name = "Engineering - SM SMES"
	icon_state = "engine_smes"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	ambience = AMBIENCE_SINGULARITY

/area/engineering/smes/rust
	name = "Engineering - INDRA SMES"

/area/engineering/engine_monitoring/rust
	name = "Engineering - INDRA Engine Monitoring"

/area/engineering/atmos/air
	name = "Engineering - Air Mixing"

/area/maintenance/substation/engineering/lower
	name = "Engineering Substation - Lower Deck"

/area/hallway/engineering
	name = "Engineering - Main Hallway"
	icon_state = "engineering"
	ambience = AMBIENCE_ENGINEERING
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/hallway/engineering/rust
	name = "Engineering - INDRA Hallway"

//Medical

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

//Research

/area/rnd/conference
	name = "Research - Conference Room"

/area/maintenance/substation/xenoarchaeology
	name = "Xenoarchaeology Substation"

//Hangar

/area/hangar
	name = "Hangar"
	icon_state = "bluenew"
	ambience = AMBIENCE_HANGAR
	sound_environment = SOUND_ENVIRONMENT_HANGAR
	station_area = TRUE
	holomap_color = HOLOMAP_AREACOLOR_HANGAR

/area/hangar/briefing
	name = "Expedition Briefing Room"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/hangar/control
	name = "Hangar Control Room"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/hangar/intrepid
	name = "Intrepid Hangar"
	area_blurb = "A big, open room, home to the SCCV Horizon's largest shuttle, the Intrepid."
	area_blurb_category = "intrepid_hanger"

/area/hangar/intrepid/interstitial
	name = "Intrepid Hangar Access"

/area/hangar/operations
	name = "Operations Hangar"

/area/hangar/auxiliary
	name = "Auxiliary Hangar"

/area/maintenance/substation/hangar
	name = "Hangar Substation"

/area/hangar/canary
	name = "Canary Hangar"

//Operations

/area/operations
	name = "Operations"
	icon_state = "dark"
	ambience = AMBIENCE_ENGINEERING
	station_area = TRUE
	holomap_color = HOLOMAP_AREACOLOR_OPERATIONS

/area/operations/lower
	name = "Lower Operations"
	icon_state = "dark160"

/area/operations/upper
	name = "Upper Operations"
	icon_state = "dark128"

/area/operations/storage
	name = "Operations Equipment Storage"
	icon_state = "dark160"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	area_blurb = "Scuff marks scar the floor from the movement of many crates and stored goods."
	area_blurb_category = "ops_warehouse"

/area/operations/lower/machinist
	name = "Machinist Workshop"
	icon_state = "machinist_workshop"
	area_blurb = "The scents of oil and mechanical lubricants fill the air in this workshop."
	area_blurb_category = "robotics"

/area/operations/lobby
	name = "Operations Lobby"

/area/operations/loading
	name = "Operations Bay"
	icon_state = "quartloading"

/area/operations/break_room
	name = "Operations Break Room"
	icon_state = "blue"

/area/operations/office
	name = "Operations Office"
	icon_state = "quartoffice"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/operations/office_aux
	name = "Operations Office (Aux)"
	icon_state = "quartoffice"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/operations/mail_room
	name = "Operations Mail Room"
	icon_state = "red"

/area/operations/qm
	name = "Operations Manager's Office"
	icon_state = "quart"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

//Wings

/area/maintenance/substation/wing_starboard
	name = "Starboard Wing Substation"

/area/maintenance/substation/wing_port
	name = "Port Wing Substation"

/area/maintenance/hangar
	name = "Hangar Maintenance"

/area/maintenance/hangar/port
	name = "Port Hangar Maintenance"

/area/maintenance/hangar/starboard
	name = "Starboard Hangar Maintenance"

/area/maintenance/wing
	name = "Wing Frame Maintenance"
	icon_state = "fpmaint"

/area/maintenance/wing/starboard
	name = "Central Wing Frame Interior - Starboard"

/area/maintenance/wing/starboard/far
	name = "Central Wing Frame Interior - Far Starboard"

/area/maintenance/wing/starboard/deck1
	name = "Lower Wing Frame Interior - Starboard"

/area/maintenance/wing/port
	name = "Central Wing Frame Interior - Port"

/area/maintenance/wing/port/far
	name = "Central Wing Frame Interior - Far Port"

/area/maintenance/wing/port/deck1
	name = "Lower Wing Frame Interior - Port"

//Propulsion

/area/engineering/atmos/propulsion
	name = "Port Propulsion"
	icon_state = "blue2"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/engineering/atmos/propulsion/starboard
	name = "Starboard Propulsion"
	icon_state = "blue-red2"

//Bridge
/area/crew_quarters/heads/hop/xo
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

// Maintenance

/area/maintenance/operations
	name = "Operations Maintenance"
	icon_state = "maint_cargo"

/area/maintenance/aux_atmospherics/deck_2/starboard
	name = "Starboard Auxiliary Atmospherics"
/area/maintenance/aux_atmospherics/deck_2/starboard/wing
	name = "Starboard Wing Auxiliary Atmospherics"
/area/maintenance/aux_atmospherics/deck_3
	name = "Central Auxiliary Atmospherics"

// Infrastructure

/area/storage/shields
	name = "Ship Shield Control"
	icon_state = "eva"

//shuttles

/area/shuttle/intrepid
	name = "Intrepid"
	icon_state = "intrepid"
	requires_power = TRUE
/area/shuttle/intrepid/crew_compartment
	name = "Intrepid Crew Compartment"
/area/shuttle/intrepid/cargo_bay
	name = "Intrepid Cargo Bay"
/area/shuttle/intrepid/engine_compartment
	name = "Engine Compartment"
/area/shuttle/intrepid/atmos_compartment
	name = "Atmos Compartment"
/area/shuttle/intrepid/cockpit
	name = "Cockpit"
/area/shuttle/intrepid/quarters
	name = "Intrepid Crew Quarters"

/area/shuttle/canary
	name = "Canary"
	requires_power = TRUE
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
	name = "Horizon - Exterior (DO NOT ENCROACH ON LANDING PLACES)"
	icon_state = "exterior"
	base_turf = /turf/space
	dynamic_lighting = TRUE
	requires_power = FALSE
	has_gravity = FALSE
	no_light_control = TRUE
	allow_nightmode = FALSE
	ambience = AMBIENCE_SPACE

/********** Maintenance Start **********/
// Maintenance
/area/horizon/maintenance
	name = "Horizon - Maintenance (PARENT AREA - DON'T USE)"
	icon_state = "maintenance"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_HIDE_FROM_HOLOMAP
	sound_environment = SOUND_AREA_TUNNEL_ENCLOSED
	turf_initializer = new /datum/turf_initializer/maintenance()
	ambience = AMBIENCE_MAINTENANCE

/area/horizon/maintenance/deck_two/fore/starboard
	name = "Horizon - Maintenance - Deck Two - Fore Starboard"

/area/horizon/maintenance/deck_two/fore/port
	name = "Horizon - Maintenance - Deck Two - Fore Port"

/area/horizon/maintenance/deck_three/aft/starboard
	name = "Horizon - Maintenance - Deck Three - Aft Starboard"

/********** Maintenance End **********/

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
/area/horizon/crew_quarters
	name = "Horizon - Crew Quarters (PARENT AREA - DON'T USE)"
	area_flags = AREA_FLAG_RAD_SHIELDED
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

// Cryogenics
/area/horizon/crew_quarters/cryo
	name = "Horizon - Cryogenic Storage"
	icon_state = "Sleep"

/area/horizon/crew_quarters/cryo/living_quarters_lift
	name = "Horizon - Living Quarters Lift"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/horizon/crew_quarters/cryo/dormitories
	name = "Horizon - Cryogenic Storage - Dormitories"

/area/horizon/crew_quarters/cryo/washroom
	name = "Horizon - Cryogenic Storage - Washroom"
	icon_state = "washroom"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/horizon/crew_quarters/cryo/showers
	name = "Horizon - Cryogenic Storage - Showers"
	icon_state = "showers"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

// Fitness Center
/area/horizon/crew_quarters/fitness
	name = "Horizon - Fitness Center (PARENT AREA - DON'T USE)"
	icon_state = "fitness"

/area/horizon/crew_quarters/fitness/hallway
	name = "Horizon - Fitness Center Hallway"
	icon_state = "fitness_hallway"

/area/horizon/crew_quarters/fitness/pool
	name = "Horizon - Fitness Center - Pool"
	icon_state = "fitness_pool"

/area/horizon/crew_quarters/fitness/gym
	name = "Horizon - Fitness Center - Gym"
	icon_state = "fitness_gym"

/area/horizon/crew_quarters/fitness/changing
	name = "Horizon - Fitness Center - Changing Room"
	icon_state = "fitness_changingroom"

/area/horizon/crew_quarters/fitness/washroom
	name = "Horizon - Fitness Center - Washroom"
	icon_state = "washroom"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/horizon/crew_quarters/fitness/showers
	name = "Horizon - Fitness Center - Showers"
	icon_state = "showers"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/horizon/crew_quarters/fitness/lounge
	name = "Horizon - Fitness Center - Lounge"
	icon_state = "fitness_lounge"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

// Lounges
/area/horizon/crew_quarters/lounge/bar
	name = "Horizon - Bar Lounge"
	icon_state = "lounge"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

// Miscellanous
/area/horizon/crew_quarters/washroom/central
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

// Crew Armoury
/area/horizon/crew_armoury
	name = "Horizon - Crew Armoury"
	icon_state = "crew_armoury"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	ambience = AMBIENCE_HIGHSEC
	allow_nightmode = FALSE
	holomap_color = HOLOMAP_AREACOLOR_COMMAND

/area/horizon/crew_armoury/foyer
	name = "Horizon - Crew Armoury - Foyer"
	icon_state = "crew_armoury_foyer"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	ambience = AMBIENCE_FOREBODING
	holomap_color = HOLOMAP_AREACOLOR_HALLWAYS

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

// ZTA
/area/horizon/zta
	name = "Horizon - ZTA Weapon System"
	icon_state = "zta"
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
