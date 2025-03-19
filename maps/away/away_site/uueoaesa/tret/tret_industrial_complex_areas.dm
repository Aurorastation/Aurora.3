// ------------------------- base/parent

/area/tret_industrial
	name = "Tret Industrial Complex - Base/Parent"
	icon_state = "bluenew"
	requires_power = TRUE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/basalt/tret
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_HIDE_FROM_HOLOMAP //| AREA_FLAG_INDESTRUCTIBLE_TURFS

// ------------------------- outside

/area/tret_industrial/outside
	area_blurb = "The planet Tret, home of the K'lax Hive. Beneath you, the ground vibrates slightly - vast machinery deep below carrying out its work."
	is_outside = OUTSIDE_YES

/area/tret_industrial/outside/landing
	name = "Tret - Landing Pad"
	icon_state = "yellow"

/area/tret_industrial/outside/surface
	name = "Tret - Surface"

// ------------------------- inside

/area/tret_industrial/inside
	area_blurb = "The complex is pitch-dark, without any sign of lighting systems. The hums and whirs of vast alien machinery reverberate through the walls."
	is_outside = OUTSIDE_NO

// ------------- hallways

/area/tret_industrial/inside/hallway_comms
	name = "Tret Industrial Complex - Hallway, Comms"
	icon_state = "hallC"

/area/tret_industrial/inside/hallway_botany
	name = "Tret Industrial Complex - Hallway, Botany"
	icon_state = "hallC"

/area/tret_industrial/inside/hallway_medical
	name = "Tret Industrial Complex - Hallway, Medical"
	icon_state = "hallC"

/area/tret_industrial/inside/hallway_docks
	name = "Tret Industrial Complex - Hallway, Docks"
	icon_state = "hallC"

/area/tret_industrial/inside/hallway_smelting
	name = "Tret Industrial Complex - Hallway, Smelting"
	icon_state = "hallC"

// ------------- crew

/area/tret_industrial/inside/crew
	name = "Tret Industrial Complex - Habitation"
	icon_state = "crew_quarters"

/area/tret_industrial/inside/canteen
	name = "Tret Industrial Complex - Kitchen"
	icon_state = "kitchen"

/area/tret_industrial/inside/botany
	name = "Tret Industrial Complex - Hydroponics"
	icon_state = "garden"

/area/tret_industrial/inside/medical
	name = "Tret Industrial Complex - Medical"
	icon_state = "medbay"

/area/tret_industrial/inside/comms
	name = "Tret Industrial Complex - Communications"
	icon_state = "bridge"

/area/tret_industrial/inside/eva
	name = "Tret Industrial Complex - EVA Storage"
	icon_state = "storage"

// ------------- engineering

/area/tret_industrial/inside/engineering
	name = "Tret Industrial Complex - Engineering"
	icon_state = "engineering"

/area/tret_industrial/inside/engi_storage
	name = "Tret Industrial Complex - Engineering Storage"
	icon_state = "engineering"

/area/tret_industrial/inside/atmos
	name = "Tret Industrial Complex - Atmospherics"
	icon_state = "engineering"

/area/tret_industrial/inside/maint_center
	name = "Tret Industrial Complex - Maint, Center"
	icon_state = "maintenance"

// ------------- smelting/storage

/area/tret_industrial/inside/smelting_east
	name = "Tret Industrial Complex - Smelting, East"
	icon_state = "mining"

/area/tret_industrial/inside/smelting_west
	name = "Tret Industrial Complex - Smelting, West"
	icon_state = "mining"

/area/tret_industrial/inside/storage_smelting
	name = "Tret Industrial Complex - Storage, Smelting"
	icon_state = "mining"

/area/tret_industrial/inside/storage_engineering
	name = "Tret Industrial Complex - Storage, Engineering"
	icon_state = "mining"

// ------------------------- shuttle

/area/shuttle/tret_industrial/propulsion
	name = "Tret Mining Shuttle - Propulsion"

/area/shuttle/tret_industrial/main
	name = "Tret Mining Shuttle - Main"
