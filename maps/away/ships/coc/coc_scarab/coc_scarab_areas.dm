/area/ship/coc_scarab
	name = "Scarab Salvage Vessel"
	icon_state = "blue"
	requires_power = TRUE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/space
	area_flags = AREA_FLAG_RAD_SHIELDED
	has_gravity = FALSE

/area/ship/coc_scarab/bridge
	name = "Scarab Salvage Vessel - Bridge"
	icon_state = "bridge"

/area/ship/coc_scarab/bunks
	name = "Scarab Salvage Vessel - Crew Quarters"
	icon_state = "crew_quarters"

/area/ship/coc_scarab/mess
	name = "Scarab Salvage Vessel - Mess Hall"
	icon_state = "cafeteria"

/area/ship/coc_scarab/cryogenics
	name = "Scarab Salvage Vessel - Cryogenics Bay"
	icon_state = "cryo"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/ship/coc_scarab/washroom
	name = "Scarab Salvage Vessel - Washroom"
	icon_state = "washroom"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/ship/coc_scarab/engihallway
	name = "Scarab Salvage Vessel - Engineering Hallway"
	icon_state = "maint_engineering"
	sound_environment = SOUND_AREA_TUNNEL_ENCLOSED

/area/ship/coc_scarab/forehallway
	name = "Scarab Salvage Vessel - Fore Hallway"
	icon_state = "maintcentral"
	sound_environment = SOUND_AREA_TUNNEL_ENCLOSED

/area/ship/coc_scarab/porthallway
	name = "Scarab Salvage Vessel - Port Hallway"
	icon_state = "maintenance"
	sound_environment = SOUND_AREA_TUNNEL_ENCLOSED

/area/ship/coc_scarab/starboardhallway
	name = "Scarab Salvage Vessel - Starboard Hallway"
	icon_state = "maintenance"
	sound_environment = SOUND_AREA_TUNNEL_ENCLOSED

/area/ship/coc_scarab/armory
	name = "Scarab Salvage Vessel - Armory"
	icon_state = "armory"
	ambience = AMBIENCE_HIGHSEC

/area/ship/coc_scarab/ammo
	name = "Scarab Salvage Vessel - Ammunition Storage"
	icon_state = "Tactical"
	ambience = AMBIENCE_HIGHSEC

/area/ship/coc_scarab/grauwolf
	name = "Scarab Salvage Vessel - Flak Battery"
	icon_state = "bridge_weapon"
	ambience = AMBIENCE_HIGHSEC

/area/ship/coc_scarab/hydroponics
	name = "Scarab Salvage Vessel - Hydroponics Bay"
	icon_state = "hydro"

/area/ship/coc_scarab/medical
	name = "Scarab Salvage Vessel - Infirmary"
	icon_state = "medbay"

/area/ship/coc_scarab/recycling
	name = "Scarab Salvage Vessel - Recycling"
	icon_state = "disposal"

/area/ship/coc_scarab/equipment
	name = "Scarab Salvage Vessel - Equipment Storage"
	icon_state = "eva"
	ambience = AMBIENCE_ENGINEERING

/area/ship/coc_scarab/engistorage
	name = "Scarab Salvage Vessel - Engineering Storage"
	icon_state = "engineering_storage"
	ambience = AMBIENCE_ENGINEERING

/area/ship/coc_scarab/engine
	name = "Scarab Salvage Vessel - Engine Room"
	icon_state = "engine"
	ambience = AMBIENCE_ATMOS

/area/ship/coc_scarab/telecommunications
	name = "Scarab Salvage Vessel - Telecommunications Closet"
	icon_state = "tcomsatcham"
	ambience = AMBIENCE_HIGHSEC
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/ship/coc_scarab/atmospherics
	name = "Scarab Salvage Vessel - Atmospherics"
	icon_state = "atmos"
	ambience = AMBIENCE_ENGINEERING

/area/ship/coc_scarab/cargobay
	name = "Scarab Salvage Vessel - Cargo Bay"
	icon_state = "storage"
	ambience = AMBIENCE_ENGINEERING

/area/ship/coc_scarab/hangar
	name = "Scarab Salvage Vessel - Hangar"
	icon_state = "primarystorage"
	ambience = AMBIENCE_ENGINEERING

/area/ship/coc_scarab/thrust1
	name = "Scarab Salvage Vessel - Starboard Thruster"
	icon_state = "blue-red2"
	ambience = AMBIENCE_ATMOS

/area/ship/coc_scarab/thrust2
	name = "Scarab Salvage Vessel - Port Thruster"
	icon_state = "blue2"
	ambience = AMBIENCE_ATMOS

/area/ship/coc_scarab/exterior
	name = "Scarab Salvage Vessel - Exterior"
	requires_power = FALSE
	icon_state = "exterior"

// Shuttle
/area/shuttle/coc_scarab
	name = "Scarab Shuttle"
	requires_power = TRUE
	has_gravity = FALSE

/area/shuttle/coc_scarab/central
	name = "Scarab Shuttle Central Compartment"

/area/shuttle/coc_scarab/port
	name = "Scarab Shuttle Port Nacelle"

/area/shuttle/coc_scarab/starboard
	name = "Scarab Shuttle Starboard Nacelle"

// Lift
/area/turbolift/coc_scarab/scarab_lift
	name = "Scarab Salvager Lift"
	station_area = FALSE

