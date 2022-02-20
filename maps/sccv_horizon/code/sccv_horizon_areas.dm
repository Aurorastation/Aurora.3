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

/area/engineering/engine_room/tesla
	name = "Engineering - Tesla Engine"

/area/engineering/smes
	name = "Engineering - SM SMES"
	icon_state = "engine_smes"
	sound_env = SMALL_ENCLOSED
	ambience = AMBIENCE_SINGULARITY

/area/engineering/smes/tesla
	name = "Engineering - Tesla SMES"

/area/engineering/engine_monitoring/tesla
	name = "Engineering - Tesla Engine Monitoring"

/area/engineering/atmos/air
	name = "Engineering - Air Mixing"

/area/maintenance/substation/engineering/lower
	name = "Engineering Substation - Lower Deck"

/area/hallway/engineering
	name = "Engineering hallway"
	icon_state = "engineering"
	ambience = AMBIENCE_ENGINEERING
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/hallway/engineering/tesla
	name = "Tesla hallway"

//Medical

/area/medical/or1
	name = "Medical - Operating Room 1"
	icon_state = "surgery"

/area/medical/or2
	name = "Medical - Operating Room 2"
	icon_state = "surgery"

/area/medical/exam
	name = "Medical - Examination Room"
	icon_state = "exam_room"

/area/medical/ward
	name = "Medical - Ward"
	icon_state = "patients"

/area/medical/ward/isolation
	name = "Medical - Isolation Ward"

/area/medical/emergency_storage
	name = "Medical - Lower Deck Emergency Storage"
	sound_env = SMALL_ENCLOSED

/area/medical/morgue/lower
	name = "Medical - Morgue"
	icon_state = "morgue"
	ambience = AMBIENCE_GHOSTLY

/area/medical/equipment
	name = "Medical - Equipment Room"

/area/medical/smoking
	name = "Medical - Smoking Lounge"

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

/area/maintenance/substation/xenoarcheology
	name = "Xenoarcheology Substation"

//Hangar

/area/hangar
	name = "Hangar"
	icon_state = "bluenew"
	ambience = AMBIENCE_HANGAR
	sound_env = HANGAR
	station_area = TRUE

/area/hangar/briefing
	name = "Expedition Briefing Room"
	sound_env = LARGE_ENCLOSED

/area/hangar/control
	name = "Hangar Control Room"
	sound_env = SMALL_ENCLOSED

/area/hangar/intrepid
	name = "Intrepid Hangar"

/area/hangar/intrepid/interstitial
	name = "Intrepid Hangar Access"

/area/hangar/operations
	name = "Operations Hangar"

/area/hangar/auxiliary
	name = "Auxiliary Hangar"

/area/maintenance/substation/hangar
	name = "Hangar Substation"

//Operations

/area/operations
	name = "Operations"
	icon_state = "dark"
	ambience = AMBIENCE_ENGINEERING
	station_area = TRUE

/area/operations/lower
	name = "Lower Operations"
	icon_state = "dark160"

/area/operations/upper
	name = "Upper Operations"
	icon_state = "dark128"

/area/operations/storage
	name = "Operations Equipment Storage"
	icon_state = "dark160"
	sound_env = LARGE_ENCLOSED

/area/operations/lower/machinist
	name = "Machinist Workshop"

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
	sound_env = MEDIUM_SOFTFLOOR

/area/operations/mail_room
	name = "Operations Mail Room"
	icon_state = "red"

/area/operations/qm
	name = "Operations Manager's Office"
	icon_state = "quart"
	sound_env = SMALL_SOFTFLOOR

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
	sound_env = SMALL_ENCLOSED

/area/engineering/atmos/propulsion/starboard
	name = "Starboard Propulsion"
	icon_state = "blue-red2"

//Bridge
/area/crew_quarters/heads/hop/xo
	name = "Command - Executive Officer's Office"

/area/bridge/bridge_crew
	name = "Bridge Crew Preparation"
	icon_state = "bridge_crew"

/area/bridge/third_deck_stairs
	name = "Bridge Stairs"
	icon_state = "bridge_stairs"

/area/bridge/helm
	name = "Bridge Helm"
	icon_state = "bridge_helm"

/area/crew_armory
	name = "Crew Armory"
	icon_state = "crew_armory"
	no_light_control = TRUE
	station_area = TRUE
	holomap_color = HOLOMAP_AREACOLOR_COMMAND

//Crew quarters

/area/crew_quarters/lounge
	name = "Crew Lounge"
	icon_state = "lounge"

/area/crew_quarters/lounge/secondary
	name = "Secondary Crew Lounge"
	icon_state = "lounge2"

/area/crew_quarters/sleep/cryo/living_quarters_lift
	name = "Living Quarters Lift"

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

// Exterior
/area/horizonexterior
	name = "Exterior"
	icon_state = "exterior"
	has_gravity = FALSE
	base_turf = /turf/space
	station_area = TRUE
