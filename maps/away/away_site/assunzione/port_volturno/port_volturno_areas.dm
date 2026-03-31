/area/port_volturno
	name = "Port Volturno"
	requires_power = 0
	no_light_control = 1
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS | AREA_FLAG_PREVENT_PERSISTENT_TRASH
	base_turf = /turf/simulated/floor/exoplanet/assunzione
	ambience = AMBIENCE_KONYANG_TRAFFIC
	sound_environment = SOUND_ENVIRONMENT_CITY
	is_outside = OUTSIDE_NO
	var/lighting = TRUE //Is this area automatically lit?
	area_blurb = "A vast dome encloses you within the open space; beyond it only is killing cold and darkness, but here, inside, it is warm and bright and welcoming."

/area/port_volturno/Initialize()
	. = ..()
	if(lighting)
		for(var/turf/T in src)
			T.set_light(MINIMUM_USEFUL_LIGHT_RANGE, 50, COLOR_WHITE) //Same light level as Konyang proper

//All walls and interior stuff uses this area, otherwise rain will appear over walls. suboptimal!
/area/port_volturno/interior
	name = "Port Volturno - Interior"
	sound_environment = SOUND_AREA_LARGE_SOFTFLOOR
	ambience = AMBIENCE_HANGAR
	is_outside = OUTSIDE_NO
	lighting = FALSE

//Main city buildings
/area/port_volturno/interior/laundromat
	name = "Port Volturno - Laundromat"

/area/port_volturno/interior/tailor
	name = "Port Volturno - Clothing Store"

/area/port_volturno/interior/restaurant
	name = "Port Volturno - Restaurant"

/area/port_volturno/interior/hotel
	name = "Port Volturno - Hotel"
	icon_state = "crew_quarters"

/area/port_volturno/interior/hotel/basement
	name = "Port Volturno - Hotel - Basement"
	icon_state = "crew_quarters"

/area/port_volturno/interior/arcade
	name = "Port Volturno - Arcade"
	area_blurb = "The deafening avalanche of arcade machines begging for your attention fill the air, all promising fantastic gaming experiences for fun and prizes."

/area/port_volturno/interior/minimart
	name = "Port Volturno - Convenience Store"

/area/port_volturno/interior/cafe
	name = "Port Volturno - Cafe"

/area/port_volturno/interior/streetvendor
	name = "Port Volturno - Decrepit Street Vendor"

/area/port_volturno/interior/police
	name = "Port Volturno - Police Department"
	icon_state = "security"

/area/port_volturno/interior/bar
	name = "Port Volturno - Bar"

/area/port_volturno/interior/robotics
	name = "Port Volturno - Robotics Clinic"

/area/port_volturno/interior/spaceport
	name = "Port Volturno - Spaceport"

/area/port_volturno/interior/decrepit
	name = "Port Volturno - Decrepit Apartments"
	area_blurb = "A damp smell lingers in the air inside these dusty apartments, it might be wise to keep an eye out for mold."

/area/port_volturno/interior/pharmacy
	name = "Port Volturno - Pharmacy"

/area/port_volturno/interior/parking
	name = "Port Volturno - Parking Shelter"

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

/area/port_volturno/interior/parking
	name = "Port Volturno - Parking"
	area_blurb = "Sounds echo impressively through this space."
	icon_state = "dk_yellow"

/area/port_volturno/interior/shallow//For open-walled areas, like awnings and balconies
	sound_environment = SOUND_ENVIRONMENT_CITY

/area/port_volturno/outdoors
	name = "Port Volturno - Outdoors"
	area_blurb = "The sounds and smells of Port Volturno bombard you from all directions. Skyscrapers tower up further into the city."
	lighting = TRUE

/area/port_volturno/water
	name = "Port Volturno - Open Water"
	icon_state = "fitness_pool"
	lighting = TRUE

/area/port_volturno/water/deep // also used for waterdock landing area
	name = "Port Volturno - Deep Water"
	lighting = TRUE
