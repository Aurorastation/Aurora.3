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

/area/horizon/maintenance/deck_1/hangar/port
	name = "Hangar Maintenance - Port"

/area/horizon/maintenance/deck_1/hangar/starboard
	name = "Hangar Maintenance - Starboard"

/area/horizon/maintenance/deck_1/hangar/far_port
	name = "Lower Wing Frame Interior - Far Port"

/area/horizon/maintenance/deck_1/operations/starboard
	name = "Operations Maintenance - Far Starboard"

/area/horizon/maintenance/deck_1/operations/starboard
	name = "Operations Maintenance - Internal"

/area/horizon/maintenance/deck_1/operations/starboard/far
	name = "Operations Maintenance - Starboard"

/area/horizon/maintenance/deck_1/main/starboard
	name = "Primary Maintenance Conduit - Starboard"

/area/horizon/maintenance/deck_1/main/port
	name = "Primary Maintenance Conduit - Port"

/area/horizon/maintenance/deck_1/main/interstitial
	name = "Primary Maintenance Conduit - Interstitial"

/area/horizon/maintenance/deck_1/teleporter
	name = "Teleporter Maintenance - Central"

/area/horizon/maintenance/deck_1/combustion
	name = "Combustion Turbine Maintenance - Aft Port"

/area/horizon/maintenance/deck_2
	horizon_deck = 2

/area/horizon/maintenance/deck_3
	horizon_deck = 3

/area/horizon/maintenance/deck_2/fore/starboard
	name = "Horizon - Maintenance - Deck Two - Fore Starboard"

/area/horizon/maintenance/deck_2/fore/port
	name = "Horizon - Maintenance - Deck Two - Fore Port"

/area/horizon/maintenance/deck_3/aft/starboard
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

/area/horizon/maintenance/deck_2/aux_atmospherics
	name = "Auxiliary Atmospherics - Starboard Wing"

//Wings

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

/area/horizon/maintenance/substation/supply // Cargo and Mining.
	name = "Main Lvl. Supply Substation"

/area/horizon/maintenance/substation/xenoarchaeology
	name = "Xenoarchaeology Substation"

/area/horizon/maintenance/substation/hangar
	name = "Hangar Substation"

/area/horizon/maintenance/substation/wing_starboard
	name = "Starboard Wing Substation"

/area/horizon/maintenance/substation/wing_port
	name = "Port Wing Substation"
