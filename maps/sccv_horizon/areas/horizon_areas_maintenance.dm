/// MAINTENANCE_AREAS
/area/horizon/maintenance
	name = "Horizon - Maintenance (PARENT AREA - DON'T USE)"
	icon_state = "maintenance"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_PREVENT_PERSISTENT_TRASH
	sound_environment = SOUND_AREA_TUNNEL_ENCLOSED
	turf_initializer = new /datum/turf_initializer/maintenance()
	area_blurb = "Scarcely lit, cramped, and filled with stale, dusty air. Around you hisses compressed air through the pipes, a buzz of electrical charge through the wires, and muffled rumbles of the hull settling. This place may feel alien compared to the interior of the ship and is a place where one could get lost or badly hurt, but some may find the isolation comforting."
	area_blurb_category = "maint"
	ambience = AMBIENCE_MAINTENANCE
	department = LOC_MAINTENANCE

/area/horizon/maintenance/deck_1
	horizon_deck = 1

/area/horizon/maintenance/deck_1/main/starboard
	name = "Primary Maintenance Conduit"
	location_ew = LOC_STARBOARD

/area/horizon/maintenance/deck_1/main/port
	name = "Primary Maintenance Conduit"
	location_ew = LOC_PORT

/area/horizon/maintenance/deck_1/main/interstitial
	name = "Primary Maintenance Conduit"
	location_ew = LOC_AMIDSHIPS

/area/horizon/maintenance/deck_1/hangar/port
	name = "Primary Hangar Maintenance"
	location_ew = LOC_PORT

/area/horizon/maintenance/deck_1/hangar/starboard
	name = "Primary Hangar Maintenance"
	location_ew = LOC_STARBOARD

/area/horizon/maintenance/deck_1/operations/starboard
	name = "Operations Maintenance"
	location_ew = LOC_STARBOARD

/area/horizon/maintenance/deck_1/operations/starboard/amidships
	name = "Operations Maintenance"
	location_ew = LOC_STARBOARD_NEAR

/area/horizon/maintenance/deck_1/operations/starboard/far
	name = "Operations Maintenance"
	location_ew = LOC_STARBOARD_FAR

/area/horizon/maintenance/deck_1/workshop
	name = "Auxiliary Engineering Maintenance"
	icon_state = "maint_engineering"
	department = LOC_ENGINEERING
	location_ew = LOC_STARBOARD

/area/horizon/maintenance/deck_1/teleporter
	name = "Teleporter Maintenance"
	location_ew = LOC_AMIDSHIPS

/area/horizon/maintenance/deck_1/wing/starboard
	name = "Lower Wing Frame Interior"
	location_ew = LOC_STARBOARD

/area/horizon/maintenance/deck_1/wing/starboard/far
	name = "Lower Wing Frame Interior"
	location_ew = LOC_STARBOARD_FAR

/area/horizon/maintenance/deck_1/wing/port/far
	name = "Lower Wing Frame Interior"
	location_ew = LOC_PORT_FAR

/area/horizon/maintenance/deck_1/auxatmos
	name = "Combustion Turbine Maintenance"
	location_ew = LOC_PORT
	location_ns = LOC_AFT

/area/horizon/maintenance/deck_2
	horizon_deck = 2

/area/horizon/maintenance/deck_2/service/starboard
	name = "Service Maintenance"
	location_ew = LOC_STARBOARD
	location_ns = LOC_FORE

/area/horizon/maintenance/deck_2/service/port
	name = "Service Maintenance"
	location_ew = LOC_PORT
	location_ns = LOC_FORE

/area/horizon/maintenance/deck_2/research
	name = "Research Maintenance"
	icon_state = "maint_research_port"
	location_ew = LOC_PORT
	location_ns = LOC_AFT

/area/horizon/maintenance/deck_2/cargo_compartment
	name = "Auxiliary Cargo Maintenance"

/area/horizon/maintenance/deck_2/aft
	name = "Machine Shop Maintenance"
	icon_state = "amaint"
	location_ns = LOC_AFT

/area/horizon/maintenance/deck_2/security_port
	name = "Security Maintenance"
	icon_state = "maint_security_port"
	location_ew = LOC_PORT
	location_ns = LOC_FORE

/area/horizon/maintenance/deck_2/cargo_compartment
	name = "Auxiliary Cargo Maintenance"

/area/horizon/maintenance/deck_2/wing/starboard
	name = "Wing Frame Interior"
	location_ew = LOC_STARBOARD

/area/horizon/maintenance/deck_2/wing/starboard/auxatmos
	name = "Auxiliary Atmospherics"
	subdepartment = SUBLOC_ATMOS
	location_ew = LOC_STARBOARD

/area/horizon/maintenance/deck_2/wing/starboard/near
	name = "Wing Frame Interior"
	location_ew = LOC_STARBOARD_NEAR

/area/horizon/maintenance/deck_2/wing/starboard/far
	name = "Wing Frame Interior"
	location_ew = LOC_STARBOARD_FAR

/area/horizon/maintenance/deck_2/wing/starboard/nacelle
	name = "Starboard Nacelle"
	// Special case, we're just going to have the location in the name.

/area/horizon/maintenance/deck_2/wing/port
	name = "Wing Frame Interior"
	location_ew = LOC_PORT

/area/horizon/maintenance/deck_2/wing/port/near
	name = "Wing Frame Interior"
	location_ew = LOC_PORT_NEAR

/area/horizon/maintenance/deck_2/wing/port/far
	name = "Wing Frame Interior"
	location_ew = LOC_PORT_FAR

/area/horizon/maintenance/deck_2/wing/port/nacelle
	// Special case, we're just going to have the location in the name.
	name = "Port Nacelle"

/area/horizon/maintenance/deck_3
	horizon_deck = 3

/area/horizon/maintenance/deck_3/aft/holodeck
	name = "Holodeck Maintenance"
	location_ew = LOC_STARBOARD

/area/horizon/maintenance/deck_3/aft/starboard
	name = "Command Systems Maintenance"
	location_ew = LOC_STARBOARD
	location_ns = LOC_AFT

/area/horizon/maintenance/deck_3/aft/starboard/far
	name = "Command Systems Maintenance"
	location_ew = LOC_STARBOARD_FAR
	location_ns = LOC_AFT

/area/horizon/maintenance/deck_3/aft/port
	name = "Command Systems Maintenance"
	location_ew = LOC_PORT
	location_ns = LOC_AFT

/area/horizon/maintenance/deck_3/aft/port/far
	name = "Command Systems Maintenance"
	location_ew = LOC_PORT_FAR
	location_ns = LOC_AFT

/area/horizon/maintenance/deck_3/security/starboard
	name = "Security Maintenance"
	location_ew = LOC_STARBOARD

/area/horizon/maintenance/deck_3/security/port
	name = "Security Maintenance"
	location_ew = LOC_PORT

/area/horizon/maintenance/deck_3/bridge
	name = "Bridge Maintenance"
	icon_state = "maintcentral"
	location_ew = LOC_STARBOARD
	location_ns = LOC_FORE

/// SUBSTATIONS (Subtype of maint)
/area/horizon/maintenance/substation
	name = "Substation"
	icon_state = "substation"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	ambience = AMBIENCE_SUBSTATION
	area_blurb = "The hum of the substation's machinery fills the room, holding equipment made to transform voltage and manage power supply to various rooms, and to act as an emergency battery. In comparison to the maintenance tunnels, these stations are far less dusty."
	area_blurb_category = "substation"

/// Engineering (Main)
/area/horizon/maintenance/substation/engineering
	name = "Engineering Substation"
	horizon_deck = 2

/// Engineering (Atmospherics)
/area/horizon/maintenance/substation/engineering/lower
	name = "Atmospherics Substation"
	horizon_deck = 1

/// Medbay
/area/horizon/maintenance/substation/medical
	name = "Medical Substation"
	horizon_deck = 2

/// Research
/area/horizon/maintenance/substation/research
	name = "Research Substation - Primary"
	horizon_deck = 2

/// Xenoarchaeology
/area/horizon/maintenance/substation/xenoarchaeology
	name = "Research Substation - Secondary"
	horizon_deck = 1

/// Deck 2 civilian & service areas
/area/horizon/maintenance/substation/civ_d2
	name = "Civilian Substation - Primary"
	horizon_deck = 1

/// Deck 3 civilian areas
/area/horizon/maintenance/substation/civ_d3
	name = "Civilian Substation - Secondary"
	horizon_deck = 3

/// AI and central cluster.
/area/horizon/maintenance/substation/command
	name = "Command Substation"
	horizon_deck = 3

// Security, Brig, Permabrig, etc.
/area/horizon/maintenance/substation/security
	name = "Security Substation"
	horizon_deck = 1

/// Cargo and Mining.
/area/horizon/maintenance/substation/operations
	name = "Operations Substation"
	horizon_deck = 1

/// Hangars and Deck 1 civilian areas
/area/horizon/maintenance/substation/hangar
	name = "Hangar Substation"
	horizon_deck = 1

/// Deconstructed.
/area/horizon/maintenance/substation/wing_starboard
	name = "Starboard Wing Substation"
	horizon_deck = 2

/// Deconstructed.
/area/horizon/maintenance/substation/wing_port
	name = "Port Wing Substation"
	horizon_deck = 2
