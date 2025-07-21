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

/area/horizon/maintenance/deck_1
	horizon_deck = 1

/area/horizon/maintenance/deck_1/main/starboard
	name = "Primary Maintenance Conduit - Starboard"

/area/horizon/maintenance/deck_1/main/port
	name = "Primary Maintenance Conduit - Port"

/area/horizon/maintenance/deck_1/main/interstitial
	name = "Primary Maintenance Conduit - Interstitial"

/area/horizon/maintenance/deck_1/hangar/port
	name = "Primary Hangar Maintenance - Port"

/area/horizon/maintenance/deck_1/hangar/starboard
	name = "Primary Hangar Maintenance - Starboard"

/area/horizon/maintenance/deck_1/operations/starboard
	name = "Operations Maintenance - Far to Starboard"

/area/horizon/maintenance/deck_1/operations/starboard/amidships
	name = "Operations Maintenance - Starboard Amidships"

/area/horizon/maintenance/deck_1/operations/starboard/far
	name = "Operations Maintenance - Starboard"

/area/horizon/maintenance/deck_1/workshop
	name = "Auxillary Engineering Maintenance - Starboard"
	icon_state = "maint_engineering"

/area/horizon/maintenance/deck_1/teleporter
	name = "Teleporter Maintenance - Central"

/area/horizon/maintenance/deck_1/wing/starboard
	name = "Lower Wing Frame Interior - Starboard"

/area/horizon/maintenance/deck_1/wing/starboard/far
	name = "Lower Wing Frame Interior - Far to Starboard"

/area/horizon/maintenance/deck_1/wing/port/far
	name = "Lower Wing Frame Interior - Far to Port"

/area/horizon/maintenance/deck_1/auxatmos
	name = "Combustion Turbine Maintenance - Aft Port"

/area/horizon/maintenance/deck_2
	horizon_deck = 2

/area/horizon/maintenance/deck_2/service/starboard
	name = "Service Maintenance - Starboard Fore"

/area/horizon/maintenance/deck_2/service/port
	name = "Service Maintenance - Port Fore"

/area/horizon/maintenance/deck_2/research
	name = "Research Maintenance - Port Aft"
	icon_state = "maint_research_port"

/area/horizon/maintenance/deck_2/aft
	name = "Machine Shop Maintenance - Aft"
	icon_state = "amaint"

/area/horizon/maintenance/deck_2/security_port
	name = "Security Maintenance - Fore"
	icon_state = "maint_security_port"

/area/horizon/maintenance/deck_2/wing/starboard
	name = "Wing Frame Interior - Starboard"

/area/horizon/maintenance/deck_2/wing/starboard/auxatmos
	name = "Wing Frame Interior - Starboard Auxiliary Atmospherics"

/area/horizon/maintenance/deck_2/wing/starboard/near
	name = "Wing Frame Interior - Starboard Amidships"

/area/horizon/maintenance/deck_2/wing/starboard/far
	name = "Wing Frame Interior - Far to Starboard"

/area/horizon/maintenance/deck_2/wing/starboard/nacelle
	name = "Starboard Nacelle"

/area/horizon/maintenance/deck_2/wing/port
	name = "Wing Frame Interior - Port"

/area/horizon/maintenance/deck_2/wing/port/near
	name = "Wing Frame Interior - Port Amidships"

/area/horizon/maintenance/deck_2/wing/port/far
	name = "Wing Frame Interior - Far to Port"

/area/horizon/maintenance/deck_2/wing/port/nacelle
	name = "Port Nacelle"

/area/horizon/maintenance/deck_3
	horizon_deck = 3

/area/horizon/maintenance/deck_3/aft/holodeck
	name = "Holodeck Maintenance - Starboard"

/area/horizon/maintenance/deck_3/aft/starboard
	name = "Command Systems Maintenance - Starboard Aft"

/area/horizon/maintenance/deck_3/aft/starboard/far
	name = "Command Systems Maintenance - Far to Starboard Aft"

/area/horizon/maintenance/deck_3/aft/port
	name = "Command Systems Maintenance - Port Aft"

/area/horizon/maintenance/deck_3/aft/port/far
	name = "Command Systems Maintenance - Far to Port Aft"

/area/horizon/maintenance/deck_3/security/starboard
	name = "Security Maintenance - Starboard"

/area/horizon/maintenance/deck_3/security/port
	name = "Security Maintenance - Port"

/area/horizon/maintenance/deck_3/bridge
	name = "Bridge Maintenance - Starboard Fore"
	icon_state = "maintcentral"

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
