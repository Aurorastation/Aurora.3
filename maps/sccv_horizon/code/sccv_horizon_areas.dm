/**
 *	Definitions for every area used on the SCCV Horizon map.
 *
 *	Each department (or other appropriate grouping) will have its own section that you can jump to with ctrl-f.
 *	For convenience, these groupings are:
 *	CREW_AREAS			Catch-all/public areas, I.E. hallways, staff head offices, etc.
 *	COMMAND_AREAS		Command areas
 *	ENGINEERING_AREAS	Engineering dept areas
 *	HOLODECK_AREAS		Fifty million holodeck areas
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

//Crew
/area/horizon/crew
	name = "Crew Compartment"
	icon_state = "Sleep"
	station_area = TRUE
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

/area/horizon/chapel
	station_area = TRUE
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

/area/horizon/chapel/main
	name = "Chapel"
	icon_state = "chapel"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	ambience = AMBIENCE_CHAPEL

/area/horizon/chapel/office
	name = "Chapel Office"
	icon_state = "chapeloffice"

/area/horizon/journalistoffice
	name = "Journalist's Office"
	station_area = TRUE
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

// Hallways
/area/horizon/hallway
	name = "Horizon - Hallway (PARENT AREA - DON'T USE)"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	allow_nightmode = TRUE
	lightswitch = TRUE
	holomap_color = HOLOMAP_AREACOLOR_HALLWAYS
	emergency_lights = TRUE

/area/horizon/hallway/primary/deck_three/central
	name = "Horizon - Deck 3 - Central Primary Hallway"
	icon_state = "hallC"

/area/horizon/hallway/primary/deck_three/starboard
	name = "Horizon - Deck 3 - Starboard Primary Hallway"
	icon_state = "hallS"

/area/horizon/hallway/primary/deck_three/starboard/docks
	name = "Horizon - Deck 3 - Starboard Primary Hallway - Docks"
	holomap_color = HOLOMAP_AREACOLOR_DOCK

/area/horizon/hallway/primary/deck_three/port
	name = "Horizon - Deck 3 - Port Primary Hallway"
	icon_state = "hallP"

/area/horizon/hallway/primary/deck_three/port/docks
	name = "Horizon - Deck 3 - Port Primary Hallway - Docks"
	holomap_color = HOLOMAP_AREACOLOR_DOCK

/area/horizon/hallway/primary/deck_two/central
	name = "Horizon - Deck 2 - Central Primary Hallway"
	icon_state = "hallF"

/area/horizon/hallway/primary/deck_two/fore
	name = "Horizon - Deck 2 - Fore Primary Hallway"
	icon_state = "hallF"

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

// Crew Quarters
/area/horizon/crew
	name = "Horizon - Crew Quarters (PARENT AREA - DON'T USE)"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

// Cryogenics
/area/horizon/crew/cryo
	name = "Horizon - Cryogenic Storage"
	area_flags = AREA_FLAG_RAD_SHIELDED
	icon_state = "Sleep"

/area/horizon/crew/cryo/living_quarters_lift
	name = "Horizon - Living Quarters Lift"
	area_flags = AREA_FLAG_RAD_SHIELDED
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/horizon/crew/cryo/washroom
	name = "Horizon - Cryogenic Storage - Washroom"
	icon_state = "washroom"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

// Fitness Center
/area/horizon/crew/fitness
	name = "Horizon - Fitness Center (PARENT AREA - DON'T USE)"
	icon_state = "fitness"

/area/horizon/crew/fitness/gym
	name = "Horizon - Fitness Center - Gym"
	icon_state = "fitness_gym"

/area/horizon/crew/fitness/changing
	name = "Horizon - Fitness Center - Changing Room"
	icon_state = "fitness_changingroom"

/area/horizon/crew/fitness/showers
	name = "Horizon - Fitness Center - Showers"
	icon_state = "showers"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/horizon/crew/lounge
	name = "Crew Lounge"
	icon_state = "lounge"

/area/horizon/crew/lounge/secondary
	name = "Secondary Crew Lounge"
	icon_state = "lounge2"

// Miscellanous
/area/horizon/crew/washroom/central
	name = "Horizon - Central Washroom"
	icon_state = "washroom"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/horizon/crew/vacantoffice
	name = "Vacant Office"
	no_light_control = 0


/// COMMAND_AREAS
/area/horizon/bridge
	name = "Bridge"
	icon_state = "bridge"
	no_light_control = 1
	station_area = TRUE
	holomap_color = HOLOMAP_AREACOLOR_COMMAND
	area_blurb = "The sound here seems to carry more than others, every click of a shoe or clearing of a throat amplified. The smell of ink, written and printed, wafts notably through the air."
	area_blurb_category = "command"

/area/horizon/crew/command/heads/xo
	name = "Command - Executive Officer's Office"

/area/horizon/bridge/bridge_crew
	name = "Bridge Crew Preparation"
	icon_state = "bridge_crew"

/area/horizon/bridge/supply
	name = "Bridge Supply Closet"
	icon_state = "bridge_crew"

/area/horizon/bridge/upperdeck
	name = "Command Atrium Upper Deck"
	icon_state = "bridge"

/area/horizon/bridge/minibar
	name = "Command Break Room"
	icon_state = "bridge"

/area/horizon/bridge/aibunker
	name = "Command - Bunker"
	icon_state = "ai_foyer"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_HIDE_FROM_HOLOMAP

/area/horizon/bridge/centcom_meetingroom
	name = "Level A Meeting Room"
	icon_state = "bridge"

/area/horizon/bridge/meeting_room
	name = "Command - Conference Room"
	icon_state = "bridge"
	ambience = list()
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR
	area_blurb = "A place for behind-closed-doors meetings to get things done, or to argue for hours in..."
	area_blurb_category = "command_meeting"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/horizon/bridge/cciaroom
	name = "Command - Human Resources Meeting Room"
	icon_state = "hr"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR
	area_blurb = "You might feel dread when you enter this meeting room."
	area_blurb_category = "hr_meeting"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/horizon/bridge/cciaroom/lounge
	name = "Command - Human Resources Lounge"
	icon_state = "hrlounge"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR
	area_blurb = "A place that may worsen any anxiety surrounding meetings with your bosses' boss."
	area_blurb_category = "hr_lounge"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/horizon/bridge/selfdestruct
	name = "Command - Station Authentication Terminal Safe"
	icon_state = "bridge"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP

/area/horizon/bridge/controlroom
	name = "Command - Control Room"
	area_blurb = "The full expanse of space lies beyond a thick pane of reinforced glass, all that protects you from a cold and painful death. The computers hum, showing various displays and holographic signs. The sight would be overwhelming if you are not used to such an environment. Even at full power, the sensors fail to map even a fraction of the dots of light making up the cosmic filament."
	area_blurb_category = "bridge"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/horizon/crew/command/captain
	name = "Command - Captain's Office"
	icon_state = "captain"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR
	holomap_color = HOLOMAP_AREACOLOR_COMMAND
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/horizon/crew/command/heads
	holomap_color = HOLOMAP_AREACOLOR_COMMAND
	area_flags = AREA_FLAG_RAD_SHIELDED
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/horizon/crew/command/heads/hor
	name = "Research - RD's Office"
	icon_state = "head_quarters"

/area/horizon/crew/command/heads/chief
	name = "Engineering - Chief Engineer's Office"
	icon_state = "head_quarters"

/area/horizon/crew/command/heads/hos
	name = "Security - Head of Security's Office"
	icon_state = "head_quarters"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP
	ambience = AMBIENCE_HIGHSEC

/area/horizon/crew/command/heads/cmo
	name = "Medbay - CMO's Office"
	icon_state = "head_quarters"

/area/horizon/crew/command/heads/opsmgr
	name = "Operations - OM's Office"
	icon_state = "head_quarters"

/area/horizon/repoffice
	name = "Representative Office"
	icon_state = "law"
	station_area = TRUE
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

/area/horizon/repoffice/consular_one
	name = "Consular Office A"
	icon_state = "law_con"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

/area/horizon/repoffice/consular_two
	name = "Consular Office B"
	icon_state = "law_con_b"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

/area/horizon/repoffice/representative_one
	name = "Representative Office A"
	icon_state = "law_rep"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

/area/horizon/repoffice/representative_two
	name = "Representative Office B"
	icon_state = "law_rep_b"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

//Teleporter
/area/teleporter
	name = "Command - Teleporter"
	icon_state = "teleporter"
	station_area = TRUE

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


/// MAINTENANCE_AREAS
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


/// MEDICAL_AREAS
/area/horizon/medical/ors
	name = "Medical - Combined Operating Rooms"
	icon_state = "surgery"

/area/horizon/medical/exam
	name = "Medical - Examination Room"
	icon_state = "exam_room"

/area/horizon/medical/ward
	name = "Medical - Ward"
	icon_state = "patients"

/area/horizon/medical/ward/isolation
	name = "Medical - Isolation Ward"
	area_blurb = "This seldom-used ward somehow smells sterile and musty at the same time."
	area_blurb_category = "medical_isolation"

/area/horizon/medical/emergency_storage
	name = "Medical - Lower Deck Emergency Storage"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/horizon/medical/morgue/lower
	name = "Medical - Morgue"
	icon_state = "morgue"
	ambience = AMBIENCE_GHOSTLY

/area/horizon/medical/equipment
	name = "Medical - Equipment Room"

/area/horizon/medical/smoking
	name = "Medical - Smoking Lounge"
	area_blurb = "The smell of cigarette smoke lingers within this room."
	area_blurb_category = "medical_smoking"

/area/horizon/medical/washroom
	name = "Medical - Washroom"

/area/horizon/hallway/medical
	name = "Medical - Atrium"
	holomap_color = HOLOMAP_AREACOLOR_MEDICAL
	icon_state = "medbay"

/area/horizon/hallway/medical/upper
	name = "Medical - Upper Atrium"

//MedBay

/area/horizon/medical
	station_area = TRUE
	holomap_color = HOLOMAP_AREACOLOR_MEDICAL
	area_blurb = "Various smells waft through the air: disinfectants, various medicines, sterile gloves, and gauze. It's not a pleasant smell, but one you could grow to ignore."
	area_blurb_category = "mecical"

//Medbay is a large area, these additional areas help level out APC load.

/area/horizon/medical/paramedic
	name = "Medical - Paramedic Equipment Storage"
	icon_state = "medbay"

/area/horizon/medical/temp_morgue
	name = "Medical - Temporary Morgue"
	icon_state = "morgue"
	ambience = AMBIENCE_GHOSTLY

/area/horizon/medical/biostorage
	name = "Medical - Secondary Storage"
	icon_state = "medbay2"

/area/horizon/medical/reception
	name = "Medical - Reception"
	icon_state = "medbay"
	ambience = list('sound/ambience/signal.ogg')

/area/horizon/medical/psych
	name = "Medical - Psych Room"
	icon_state = "medbay3"
	area_blurb = "Featuring wood floors and soft carpets, this room has a warmer feeling compared to the sterility of the rest of the medical department."
	area_blurb_category = "psych"

/area/horizon/medical/morgue
	name = "Medical - Long-term Morgue"
	icon_state = "morgue"
	ambience = AMBIENCE_GHOSTLY
	area_blurb = "Morgue trays sit within this room, ready to hold the deceased until their postmortem wishes can be attended to."
	area_blurb_category = "morgue"

/area/horizon/medical/pharmacy
	name = "Medical - Pharmacy"
	icon_state = "phar"

/area/horizon/medical/surgery
	name = "Medical - Operating Theatre"
	icon_state = "surgery"
	no_light_control = 1

/area/horizon/medical/cryo
	name = "Cryogenics"
	icon_state = "cryo"

/area/horizon/medical/gen_treatment
	name = "Medical - General Treatment"
	icon_state = "cryo"

/area/horizon/medical/icu
	name = "Medical - Intensive Care Unit"
	icon_state = "cryo"
	area_blurb = "The sounds of pumps and cooling equipment can be heard within the room."
	area_blurb_category = "icu"

/area/horizon/medical/main_storage
	name = "Medical - Main Storage"
	icon_state = "exam_room"

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

/area/horizon/operations/commissary
	name = "Horizon - Commissary"

/area/horizon/operations/secure_ammunition_storage
	name = "Horizon - Secure Ammunitions Storage"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	ambience = AMBIENCE_FOREBODING
	holomap_color = HOLOMAP_AREACOLOR_OPERATIONS

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
/area/horizon/operations/mining_main
	ambience = AMBIENCE_EXPOUTPOST

/area/horizon/operations/mining_main
	icon_state = "outpost_mine_main"
	station_area = TRUE
	holomap_color = HOLOMAP_AREACOLOR_OPERATIONS

/area/horizon/operations/mining_main/eva
	name = "Mining EVA storage"

/area/horizon/operations/mining_main/refinery
	name = "Mining Refinery"


/// SCIENCE_AREAS
/area/horizon/assembly
	station_area = TRUE

/area/horizon/assembly/chargebay
	name = "Mech Bay"
	icon_state = "mechbay"

//rnd (Research and Development
/area/horizon/rnd
	station_area = TRUE
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/area/horizon/rnd/conference
	name = "Research - Conference Room"

/area/horizon/rnd/hallway
	name = "Research - Hallway"
	icon_state = "research"
	lightswitch = TRUE

/area/horizon/rnd/hallway/secondary
	name = "Research - Secondary Hallway"
	icon_state = "research"
	lightswitch = TRUE

/area/horizon/rnd/telesci
	name = "Research - Telescience Laboratory"
	icon_state = "research"

/area/horizon/rnd/chemistry
	name = "Research - Exploratory Chemistry"
	icon_state = "chem"

/area/horizon/rnd/lab
	name = "Research - R&D Laboratory"
	icon_state = "toxlab"

/area/horizon/rnd/xenobiology
	name = "Research - Xenobiology Lab"
	icon_state = "xeno_lab"

/area/horizon/rnd/xenobiology/xenological
	name = "Research - Xenological Studies"
	icon_state = "xeno_log"

/area/horizon/rnd/xenobiology/hazardous
	name = "Research - Xenobiology Hazardous Containment"
	icon_state = "xeno_lab"

/area/horizon/rnd/xenobiology/dissection
	name = "Research - Xenobiology Dissection"
	icon_state = "xeno_lab"

/area/horizon/rnd/xenobiology/foyer
	name = "Research - Xenobiology Foyer"
	icon_state = "xeno_lab"

/area/horizon/rnd/xenobiology/xenological
	name = "Research - Xenological Studies"
	icon_state = "xeno_log"

/area/horizon/rnd/xenobiology/xenoflora
	name = "Research - Xenoflora Lab"
	icon_state = "xeno_f_lab"
	no_light_control = TRUE

/area/horizon/rnd/eva
	name = "Research - EVA Preparation"
	icon_state = "blue"

/area/horizon/rnd/xenoarch_atrium
	name = "Research - Xenoarchaeology Atrium"
	icon_state = "research"

/area/horizon/rnd/xenoarch_storage
	name = "Research - Xenoarchaeology Storage"
	icon_state = "purple"

/area/horizon/rnd/isolation_a
	name = "Research - Anomaly Isolation A"
	icon_state = "blue"

/area/horizon/rnd/isolation_b
	name = "Research - Anomaly Isolation B"
	icon_state = "red"

/area/horizon/rnd/isolation_c
	name = "Research - Anomaly Isolation C"
	icon_state = "green"

/area/horizon/rnd/test_range
	name = "Research - Weapons Testing Range"
	area_flags = AREA_FLAG_FIRING_RANGE

/area/horizon/rnd/server
	name = "Research Server Room"
	icon_state = "server"
	station_area = TRUE
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE


/// SECURITY_AREAS
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

/area/horizon/security/checkpoint
	name = "Security Checkpoint"
	icon_state = "checkpoint1"
	no_light_control = 0

/area/horizon/security/checkpoint2
	name = "Security - Arrivals Checkpoint"
	icon_state = "security"
	ambience = AMBIENCE_ARRIVALS



/// SERVICE_AREAS
/area/horizon/service
	name = "Horizon - Service (PARENT AREA - DON'T USE)"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

/// Hydroponics areas
/area/horizon/service/hydroponics
	name = "Horizon - Hydroponics"
	icon_state = "hydro"

/area/horizon/service/hydroponics/lower
	name = "Horizon - Hydroponics - Lower"

/area/horizon/service/hydroponics/garden
	name = "Horizon - Public Garden"
	icon_state = "garden"

/// Library areas
/area/horizon/service/library
	name = "Horizon - Library"
	icon_state = "library"
	sound_environment = SOUND_AREA_LARGE_SOFTFLOOR

/// Kitchen areas
/area/horizon/service/kitchen
	name = "Horizon - Kitchen"
	icon_state = "kitchen"
	allow_nightmode = FALSE

/area/horizon/service/kitchen/freezer
	name = "Horizon - Kitchen - Freezer"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/// Bar areas
/area/horizon/service/bar
	name = "Horizon - Bar"
	icon_state = "bar"

/area/horizon/service/bar/backroom
	name = "Horizon - Bar - Backroom"
	area_flags = AREA_FLAG_RAD_SHIELDED

// Dining Hall
/area/horizon/service/dining_hall
	name = "Horizon - Dining Hall"
	icon_state = "lounge"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

// Cafeteria
/area/horizon/service/cafeteria
	name = "Horizon - Deck 3 Cafeteria"
	icon_state = "cafeteria"
	area_blurb = "The smell of coffee wafts over from the cafe. Patience, the tree, stands proudly in the centre of the atrium."
	area_blurb_category = "d3_cafe"

// Custodial areas
/area/horizon/service/custodial
	name = "Horizon - Custodial Closet"
	icon_state = "janitor"
	allow_nightmode = FALSE
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	ambience = list(AMBIENCE_FOREBODING, AMBIENCE_ENGINEERING)
	area_blurb = "A strong, concentrated smell of many cleaning supplies linger within this room."
	area_blurb_category = "janitor"

/area/horizon/service/custodial/disposals
	name = "Horizon - Disposals and Recycling"
	icon_state = "disposal"
	ambience = list(AMBIENCE_ENGINEERING, AMBIENCE_ATMOS) // Industrial sounds.
	area_blurb = "A large trash compactor takes up much of the room, ready to crush the ship's rubbish."
	area_blurb_category = "trash_compactor"

/area/horizon/service/custodial/auxiliary
	name = "Horizon - Auxiliary Custodial Closet"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/// SHUTTLE_AREAS
/area/horizon/shuttle
	name = "Shuttle"
	icon_state = "shuttle"
	requires_power = 0
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/horizon/shuttle/intrepid
	name = "Intrepid"
	icon_state = "intrepid"
	requires_power = TRUE

/area/horizon/shuttle/intrepid/main_compartment
	name = "Intrepid Main Compartment"

/area/horizon/shuttle/intrepid/port_compartment
	name = "Intrepid Port Compartment"

/area/horizon/shuttle/intrepid/starboard_compartment
	name = "Intrepid Starboard Compartment"

/area/horizon/shuttle/intrepid/junction_compartment
	name = "Intrepid Junction Compartment"

/area/horizon/shuttle/intrepid/buffet
	name = "Intrepid Buffet"

/area/horizon/shuttle/intrepid/medical
	name = "Intrepid Medical Compartment"

/area/horizon/shuttle/intrepid/engineering
	name = "Intrepid Engineering Compartment"

/area/horizon/shuttle/intrepid/port_storage
	name = "Intrepid Port Nacelle"

/area/horizon/shuttle/intrepid/flight_deck
	name = "Intrepid Flight Deck"

/area/horizon/shuttle/escape_pod
	name = "Escape Pod"

/area/horizon/shuttle/escape_pod/pod1
	name = "Escape Pod - 1"

/area/horizon/shuttle/escape_pod/pod2
	name = "Escape Pod - 2"

/area/horizon/shuttle/escape_pod/pod3
	name = "Escape Pod - 3"

/area/horizon/shuttle/escape_pod/pod4
	name = "Escape Pod - 4"

/area/horizon/shuttle/mining
	name = "Spark"
	requires_power = TRUE

/area/horizon/shuttle/canary
	name = "Canary"
	requires_power = TRUE

/area/horizon/shuttle/quark/cockpit
	name = "Quark Cockpit"
	requires_power = TRUE

/area/horizon/shuttle/quark/cargo_hold
	name = "Quark Cargo Hold"
	requires_power = TRUE


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


/// HOLODECK_AREAS
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


/// WEAPONS_AREAS
/area/horizon/weapons/longbow
	name = "Horizon - Longbow Weapon System"
	icon_state = "bridge_weapon"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	ambience = AMBIENCE_HIGHSEC
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP

/area/horizon/weapons/grauwolf
	name = "Horizon - Grauwolf Weapon System"
	icon_state = "bridge_weapon"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	ambience = AMBIENCE_HIGHSEC
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP

/********** Weapon Systems End **********/

/// STORAGE_AREAS
/area/horizon/storage
	station_area = TRUE

/// STORAGE_AREAS
/area/horizon/storage/primary
	name = "Primary Tool Storage"
	icon_state = "primarystorage"

/area/horizon/storage/eva
	name = "EVA Storage"
	icon_state = "eva"

/area/horizon/storage/secure
	name = "Secure Storage"
	icon_state = "storage"

