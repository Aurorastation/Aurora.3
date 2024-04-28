//Maintenance

/area/maintenance
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_HIDE_FROM_HOLOMAP
	sound_environment = SOUND_AREA_TUNNEL_ENCLOSED
	turf_initializer = new /datum/turf_initializer/maintenance()
	ambience = AMBIENCE_MAINTENANCE
	station_area = 1
	area_blurb = "Scarcely lit, cramped, and filled with stale, dusty air. Around you hisses compressed air through the pipes, a buzz of electrical charge through the wires, and muffled rumbles of the hull settling. This place may feel alien compared to the interior of the ship and is a place where one could get lost or badly hurt, but some may find the isolation comforting."
	area_blurb_category = "maint"

/area/maintenance/civ
	name = "Civilian Maintenance"
	icon_state = "maintcentral"

/area/maintenance/aft
	name = "Aft Maintenance"
	icon_state = "amaint"

/area/maintenance/fore
	name = "Fore Maintenance"
	icon_state = "fmaint"

/area/maintenance/starboard
	name = "Starboard Maintenance"
	icon_state = "smaint"

/area/maintenance/port
	name = "Port Maintenance"
	icon_state = "pmaint"

/area/maintenance/atmos_control
	name = "Atmospherics Maintenance"
	icon_state = "fpmaint"

/area/maintenance/fpmaint
	name = "Fore Port Maintenance - 1"
	icon_state = "fpmaint"

/area/maintenance/fpmaint2
	name = "Fore Port Maintenance - 2"
	icon_state = "fpmaint"

/area/maintenance/fsmaint
	name = "Fore Starboard Maintenance - 1"
	icon_state = "fsmaint"

/area/maintenance/fsmaint2
	name = "Fore Starboard Maintenance - 2"
	icon_state = "fsmaint"

/area/maintenance/asmaint
	name = "Aft Starboard Maintenance"
	icon_state = "asmaint"

/area/maintenance/engi_shuttle
	name = "Engineering Shuttle Access"
	icon_state = "maint_e_shuttle"

/area/maintenance/engi_engine
	name = "Engine Maintenance"
	icon_state = "maint_engine"

/area/maintenance/asmaint2
	name = "Science Maintenance"
	icon_state = "asmaint"

/area/maintenance/apmaint
	name = "Cargo Maintenance"
	icon_state = "apmaint"

/area/maintenance/maintcentral
	name = "Bridge Maintenance"
	icon_state = "maintcentral"

/area/maintenance/bridge_elevator
	name = "Bridge Elevator Maintenance"
	icon_state = "maintcentral"

/area/maintenance/bridge_elevator/surface
	name = "Surface - Bridge Elevator Maintenance"

/area/maintenance/arrivals
	name = "Surface Maintenance"
	icon_state = "maint_arrivals"

/area/maintenance/store
	name = "Commissary Maintenance"
	icon_state = "maint_cargo"

/area/maintenance/bar
	name = "Bar Maintenance"
	icon_state = "maint_bar"

/area/maintenance/bar/above
	name = "Bar Interstitial Maintenance"
	icon_state = "red"

/area/maintenance/cargo
	name = "Cargo Maintenance"
	icon_state = "maint_cargo"

/area/maintenance/cargo/surface
	name = "Cargo Maintenance - Surface"

/area/maintenance/disposal
	name = "Waste Disposal"
	icon_state = "disposal"

/area/maintenance/engineering
	name = "Engineering Maintenance"
	icon_state = "maint_engineering"

/area/maintenance/engineering/auxillary
	name = "Auxillary Engineering Maintenance"
	icon_state = "maint_engineering"

/area/maintenance/sublevel
	name = "Sub-level Maintenance"
	icon_state = "maint_engineering"

/area/maintenance/engsublevel
	name = "Engineering Sub-level Maintenance"
	icon_state = "maint_engineering"

/area/maintenance/medsublevel
	name = "Medical Sub-level Maintenance"
	icon_state = "maint_engineering"

/area/maintenance/medsublevel_port
	name = "Old Quarantine"
	icon_state = "maint_medbay"

/area/maintenance/scisublevel
	name = "Research Sub-level Maintenance"
	icon_state = "maint_engineering"

/area/maintenance/evahallway
	name = "EVA Maintenance"
	icon_state = "maint_eva"

/area/maintenance/solarmaint
	name = "Surface - Solar Maintenance"
	icon_state = "maint_eva"
	base_turf = /turf/space

/area/maintenance/dormitory
	name = "Dormitory Maintenance"
	icon_state = "maint_dormitory"

/area/maintenance/incinerator
	name = "Incinerator"
	icon_state = "disposal"

/area/maintenance/library
	name = "Library Maintenance"
	icon_state = "maint_library"

/area/maintenance/locker
	name = "Locker Room Maintenance"
	icon_state = "maint_locker"

/area/maintenance/medbay
	name = "Medbay Maintenance"
	icon_state = "maint_medbay"

/area/maintenance/medbay_interstitial
	name = "Medbay Interstitial Maintenance"
	icon_state = "maint_medbay"

/area/maintenance/medbay_virology
	name = "Old Virology Lab"
	icon_state = "maint_medbay"

/area/maintenance/research_port
	name = "Research Maintenance - Port"
	icon_state = "maint_research_port"

/area/maintenance/telecoms_ladder
	name = "Telecoms Ladder Shaft"
	icon_state = "tcomsatentrance"

/area/maintenance/engineering_ladder
	name = "Engineering Ladder Shaft"
	icon_state = "maint_engineering"

/area/maintenance/research_xenobiology
	name = "Research Maintenance - Xenobiology"
	icon_state = "maint_research_port"

/area/maintenance/research_starboard
	name = "Research Maintenance - Starboard"
	icon_state = "maint_research_starboard"

/area/maintenance/research_shuttle
	name = "Research Shuttle Dock Maintenance"
	icon_state = "maint_research_shuttle"

/area/maintenance/security_port
	name = "Security Maintenance - Port"
	icon_state = "maint_security_port"

/area/maintenance/security_starboard
	name = "Security Maintenance - Starboard"
	icon_state = "maint_security_starboard"

/area/maintenance/security_interstitial
	name = "Security Maintenance - Interstitial"
	icon_state = "maint_security_starboard"

/area/maintenance/storage
	name = "Atmospherics"
	icon_state = "green"

/area/maintenance/interstitial_main
	name = "Construction Level"
	icon_state = "maintcentral"

/area/maintenance/interstitial_cargo
	name = "Cargo - Interstitial"
	icon_state = "maint_cargo"

/area/maintenance/interstitial_bridge
	name = "Bridge - Interstitial"
	icon_state = "maintcentral"

/area/maintenance/bridge
	name = "Bridge Maintenance"
	icon_state = "maintcentral"

/area/maintenance/interstitial_construction_site
	name = "Construction Zone"
	icon_state = "engineering_workshop"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP

/area/maintenance/interstitial_construction_site/zone_2
	name = "Secondary Construction Zone"

/area/maintenance/interstitial_construction_site/office
	name = "Construction Office"

/area/maintenance/elevator
	name = "Primary Elevator Shaft Maintenance"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	icon_state = "green"

/area/maintenance/vault
	name = "Vault Maintenance"
	icon_state = "green"

// SUBSTATIONS (Subtype of maint, that should let them serve as shielded area during radstorm)

/area/maintenance/substation
	name = "Substation"
	icon_state = "substation"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	ambience = AMBIENCE_SUBSTATION
	area_blurb = "The hum of the substation's machinery fills the room, holding equipment made to transform voltage and manage power supply to various rooms, and to act as an emergency battery. In comparison to the maintenance tunnels, these stations are far less dusty."
	area_blurb_category = "substation"

/area/maintenance/substation/engineering // Engineering
	name = "Engineering Substation"

/area/maintenance/substation/engineering_sublevel // Engineering
	name = "Engineering Sublevel Substation"

/area/maintenance/substation/medical_science // Medbay and Science. Each has it's own separated machinery, but it originates from the same room.
	name = "Medical Research Substation"

/area/maintenance/substation/medical // Medbay
	name = "Main Lvl. Medical Substation"

/area/maintenance/substation/medical_sublevel // Medbay
	name = "Medical Sublevel - Substation"

/area/maintenance/substation/research // Research
	name = "Main Lvl. Research Substation"

/area/maintenance/substation/research_sublevel
	name = "Research Sublevel - Substation"

/area/maintenance/substation/civilian_east // Bar, kitchen, dorms, ...
	name = "Surface Lvl. Civilian Substation"

/area/maintenance/substation/civilian_west // PTS, locker room, probably arrivals, ...)
	name = "Main Lvl. Civilian Substation"

/area/maintenance/substation/command // AI and central cluster. This one will be between HoP office and meeting room (probably).
	name = "Command Substation"

/area/maintenance/substation/security // Security, Brig, Permabrig, etc.
	name = "Security Substation"

/area/maintenance/substation/interstitial // Construction Level.
	name = "Construction Level Substation"

/area/maintenance/substation/supply // Cargo and Mining.
	name = "Main Lvl. Supply Substation"

//Solars

/area/solar
	requires_power = 1
	always_unpowered = 1
	ambience = AMBIENCE_SPACE
	base_turf = /turf/space
	station_area = 1

/area/solar/auxport
	name = "Roof Solar Array"
	icon_state = "panelsA"
	base_turf = /turf/space

/area/solar/auxstarboard
	name = "Fore Starboard Solar Array"
	icon_state = "panelsA"

/area/solar/fore
	name = "Surface - Fore TComms Solar Array"
	icon_state = "yellow"

/area/solar/aft
	name = "Aft Solar Array"
	icon_state = "aft"

/area/solar/starboard
	name = "Surface - Aft TComms Solar Array"
	icon_state = "panelsS"

/area/solar/port
	name = "Surface - Port TComms Solar Array"
	icon_state = "panelsP"

/area/maintenance/auxsolarport
	name = "Solar Maintenance - Fore Port"
	icon_state = "SolarcontrolP"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/maintenance/starboardsolar
	name = "Solar Maintenance - Aft"
	icon_state = "SolarcontrolS"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/maintenance/portsolar
	name = "Solar Maintenance - Port"
	icon_state = "SolarcontrolP"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/maintenance/auxsolarstarboard
	name = "Solar Maintenance - Fore Starboard"
	icon_state = "SolarcontrolS"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/maintenance/foresolar
	name = "Solar Maintenance - Fore"
	icon_state = "SolarcontrolA"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/maintenance/workshop
	name = "Research Maintenance - Auxiliary"
	icon_state = "workshop"
	turf_initializer = null
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
