// ------------------------- base/parent

/area/cryo_outpost
	name = "Base/Parent"
	icon_state = "bluenew"
	requires_power = TRUE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/basalt/cryo_outpost
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_HIDE_FROM_HOLOMAP //| AREA_FLAG_INDESTRUCTIBLE_TURFS

// ------------------------- outside

/area/cryo_outpost/outside
	area_blurb = "The planet Tret, home of the K'lax Hive. Beneath you, the ground vibrates slightly - vast machinery deep below carrying out its work."
	is_outside = OUTSIDE_YES

/area/cryo_outpost/outside/landing
	name = "Tret - Landing Pad"
	icon_state = "yellow"

/area/cryo_outpost/outside/surface
	name = "Tret - Surface"

// ------------------------- inside

/area/cryo_outpost/inside
	area_blurb = "The complex is pitch-dark, without any sign of lighting systems. The hums and whirs of vast alien machinery reverberate through the walls."
	is_outside = OUTSIDE_NO

// ------------- hallways

/area/cryo_outpost/inside/hallway_comms
	name = "Hallway, Comms"
	icon_state = "hallC"

/area/cryo_outpost/inside/hallway_botany
	name = "Hallway, Botany"
	icon_state = "hallC"

/area/cryo_outpost/inside/hallway_medical
	name = "Hallway, Medical"
	icon_state = "hallC"

/area/cryo_outpost/inside/hallway_docks
	name = "Hallway, Docks"
	icon_state = "hallC"

/area/cryo_outpost/inside/hallway_smelting
	name = "Hallway, Smelting"
	icon_state = "hallC"

// ------------- crew

/area/cryo_outpost/inside/crew
	name = "Habitation"
	icon_state = "crew_quarters"

/area/cryo_outpost/inside/canteen
	name = "Kitchen"
	icon_state = "kitchen"

/area/cryo_outpost/inside/botany
	name = "Hydroponics"
	icon_state = "garden"

/area/cryo_outpost/inside/medical
	name = "Medical"
	icon_state = "medbay"

/area/cryo_outpost/inside/comms
	name = "Communications"
	icon_state = "bridge"

/area/cryo_outpost/inside/eva
	name = "EVA Storage"
	icon_state = "storage"

// ------------- engineering

/area/cryo_outpost/inside/engineering
	name = "Engineering"
	icon_state = "engineering"

/area/cryo_outpost/inside/engi_storage
	name = "Engineering Storage"
	icon_state = "engineering"

/area/cryo_outpost/inside/atmos
	name = "Atmospherics"
	icon_state = "engineering"

/area/cryo_outpost/inside/maint_center
	name = "Maint, Center"
	icon_state = "maintenance"

// ------------- smelting/storage

/area/cryo_outpost/inside/smelting_east
	name = "Smelting, East"
	icon_state = "mining"

/area/cryo_outpost/inside/smelting_west
	name = "Smelting, West"
	icon_state = "mining"

/area/cryo_outpost/inside/storage_smelting
	name = "Storage, Smelting"
	icon_state = "mining"

/area/cryo_outpost/inside/storage_engineering
	name = "Storage, Engineering"
	icon_state = "mining"

// ------------------------- shuttle

/area/shuttle/cryo_outpost/propulsion
	name = "Tret Mining Shuttle - Propulsion"

/area/shuttle/cryo_outpost/main
	name = "Tret Mining Shuttle - Main"

// ------------------------- fin
