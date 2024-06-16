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
	name = "Landing Pads"
	icon_state = "yellow"

/area/cryo_outpost/outside/surface
	name = "Surface"

/area/cryo_outpost/outside/cave
	name = "Cave"

// ------------------------- inside

/area/cryo_outpost/inside
	area_blurb = "TODO"
	is_outside = OUTSIDE_NO

// ------------- hallways



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

// ------------------------- shuttle


// ------------------------- fin
