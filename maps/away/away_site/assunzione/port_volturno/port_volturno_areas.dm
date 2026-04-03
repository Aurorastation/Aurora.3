/area/port_volturno
	name = "Port Volturno"
	requires_power = 0
	no_light_control = 1
	icon_state = "dark128"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS | AREA_FLAG_PREVENT_PERSISTENT_TRASH
	base_turf = /turf/simulated/floor/exoplanet/assunzione
	ambience = AMBIENCE_KONYANG_TRAFFIC
	sound_environment = SOUND_ENVIRONMENT_CITY
	is_outside = OUTSIDE_NO
	area_has_base_lighting = TRUE
	base_lighting_alpha = 50
	base_lighting_color = COLOR_OFF_WHITE
	luminosity = 0.8

/area/port_volturno/exterior
	area_blurb = "A vast dome encloses you within the open space; beyond it only is killing cold and darkness, but here, inside, it is warm and bright and welcoming."

/area/port_volturno/interior
	name = "Port Volturno - Interior"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	ambience = AMBIENCE_HANGAR
	area_has_base_lighting = FALSE
	is_outside = OUTSIDE_NO
	area_blurb = "With the interior curvature of the dome out of sight, it's easy to imagine you're on a normal, well-lit temperate world somewhere."

/area/port_volturno/interior/spaceport
	name = "Port Volturno - Spaceport"
	icon_state = "ship"

/area/port_volturno/interior/spaceport/traffic_control
	name = "Port Volturno - Spaceport Traffic Control"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	icon_state = "wizard"

/area/port_volturno/interior/spaceport/security_office
	name = "Port Volturno - Spaceport Security Office"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	icon_state = "security"

//Main city buildings
/area/port_volturno/interior/liquor_store
	name = "Port Volturno - Liquor Store"
	icon_state = "crew_quarters"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/port_volturno/interior/music_store
	name = "Port Volturno - Music Store"
	icon_state = "party"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/port_volturno/interior/parking
	name = "Port Volturno - Parking Garage"
	area_blurb = "Sounds echo impressively through this space."
	sound_environment = SOUND_AREA_STANDARD_STATION
	icon_state = "dk_yellow"

/area/port_volturno/interior/riad
	name = "Port Volturno - Spaceport Riad"
	icon_state = "bar"

/area/port_volturno/interior/riad/garden
	name = "Port Volturno - AEC Memorial Garden"
	icon_state = "green"

/area/port_volturno/interior/robotics
	name = "Port Volturno - Electromechanics Shop"
	icon_state = "machinist_workshop"

/area/port_volturno/interior/arcade
	name = "Port Volturno - Arcade"
	area_blurb = "The deafening avalanche of arcade machines begging for your attention fill the air, all promising fantastic gaming experiences for fun and prizes."

/area/port_volturno/interior/minimart
	name = "Port Volturno - QuikStop"
	icon_state = "merchant"

/area/port_volturno/interior/cafe
	name = "Port Volturno - Cafe"

/area/port_volturno/interior/streetvendor
	name = "Port Volturno - Decrepit Street Vendor"

/area/port_volturno/interior/police
	name = "Port Volturno - Zeng-Hu Spaceport Security Department"
	icon_state = "security"

/area/port_volturno/interior/bar
	name = "Port Volturno - Bar"

/area/port_volturno/interior/decrepit
	name = "Port Volturno - Decrepit Apartments"
	area_blurb = "A damp smell lingers in the air inside these dusty apartments, it might be wise to keep an eye out for mold."

/area/port_volturno/interior/pharmacy
	name = "Port Volturno - Pharmacy"

/area/port_volturno/interior/special_ops
	name = "Port Volturno - Conglomerate Oversight"

/area/port_volturno/interior/offices
	name = "Port Volturno - Corporate Offices"

/area/port_volturno/interior/offices/basement
	name = "Port Volturno - Corporate Subterranean Compound"

/area/port_volturno/interior/offices/headquarters
	name = "Conglomerate Local Command Headquarters"

/area/port_volturno/interior/offices/kaf
	name = "KAF Military Base"

/area/port_volturno/interior/offices/einstein
	name = "Einstein Engines System Advisory"

/area/port_volturno/interior/maint_janitorial
	name = "Port Volturno - Maint/Janitorial"
	icon_state = "maintenance"
