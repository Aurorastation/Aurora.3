// ------------------------- base/parent

/area/cryo_outpost
	name = "Base/Parent"
	icon_state = "bluenew"
	requires_power = TRUE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/barren
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_HIDE_FROM_HOLOMAP //| AREA_FLAG_INDESTRUCTIBLE_TURFS

// ------------------------- outside

/area/cryo_outpost/outside
	area_blurb = "TODO"
	is_outside = OUTSIDE_YES

/area/cryo_outpost/outside/landing
	name = "Landing Pad"
	icon_state = "yellow"

/area/cryo_outpost/outside/surface
	name = "Surface"

/area/cryo_outpost/outside/cave
	name = "Cave"

/area/cryo_outpost/outside/buildings
	name = "Building"
	is_outside = OUTSIDE_NO

// ------------------------- inside

/area/cryo_outpost/inside
	area_blurb = "TODO"
	is_outside = OUTSIDE_NO

// ------------- hallways

/area/cryo_outpost/inside/entrance_main
	name = "Entrance, Main"
	icon_state = "storage"

/area/cryo_outpost/inside/entrance_aux_east
	name = "Entrance, Aux East"
	icon_state = "storage"

/area/cryo_outpost/inside/entrance_aux_west
	name = "Entrance, Aux West"
	icon_state = "storage"

/area/cryo_outpost/inside/hallway_central
	name = "Hallway, Central"
	icon_state = "hallC"

/area/cryo_outpost/inside/hallway_east
	name = "Hallway, East"
	icon_state = "hallC"

/area/cryo_outpost/inside/hallway_west
	name = "Hallway, West"
	icon_state = "hallC"

// ------------- crew

/area/cryo_outpost/inside/habitation_east
	name = "Habitation, East"
	icon_state = "crew_quarters"

/area/cryo_outpost/inside/habitation_west
	name = "Habitation, West"
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

/area/cryo_outpost/inside/security
	name = "Security"
	icon_state = "security"

// ------------- labs

/area/cryo_outpost/inside/labs_hallway
	name = "Labs, Hallway"
	icon_state = "hallC"

/area/cryo_outpost/inside/labs_cryo_n
	name = "Labs, Cryo North"
	icon_state = "cryo"

/area/cryo_outpost/inside/labs_cryo_s
	name = "Labs, Cryo South"
	icon_state = "cryo"

/area/cryo_outpost/inside/labs_offices
	name = "Labs, Offices"
	icon_state = "research"

/area/cryo_outpost/inside/labs_surgery
	name = "Labs, Surgery"
	icon_state = "surgery"

/area/cryo_outpost/inside/labs_rnd
	name = "Labs, RnD"
	icon_state = "research"

/area/cryo_outpost/inside/labs_maint_w
	name = "Labs, Maint, West"
	icon_state = "maintenance"

/area/cryo_outpost/inside/labs_maint_e
	name = "Labs, Maint, East"
	icon_state = "maintenance"

// ------------- engineering

/area/cryo_outpost/inside/warehouse
	name = "Warehouse"
	icon_state = "storage"

/area/cryo_outpost/inside/engineering
	name = "Engineering"
	icon_state = "engineering"

/area/cryo_outpost/inside/engi_powergen
	name = "Engineering, Power Generation"
	icon_state = "engineering"

/area/cryo_outpost/inside/engi_atmos
	name = "Engineering, Atmospherics"
	icon_state = "engineering"

/area/cryo_outpost/inside/sensors_iff
	name = "Sensors and IFF"
	icon_state = "engineering"

/area/cryo_outpost/inside/eva
	name = "EVA"
	icon_state = "engineering"

// ------------------------- maint

/area/cryo_outpost/inside/maint_medbay
	name = "Maint, Medbay"
	icon_state = "maintenance"

/area/cryo_outpost/inside/maint_habitation
	name = "Maint, Habitation"
	icon_state = "maintenance"

/area/cryo_outpost/inside/maint_warehouse
	name = "Maint, Warehouse"
	icon_state = "maintenance"

/area/cryo_outpost/inside/maint_botany
	name = "Maint, Botany"
	icon_state = "maintenance"

/area/cryo_outpost/inside/maint_entrance
	name = "Maint, Entrance"
	icon_state = "maintenance"

/area/cryo_outpost/inside/maint_engineering
	name = "Maint, Engineering"
	icon_state = "maintenance"


// ------------------------- fin
