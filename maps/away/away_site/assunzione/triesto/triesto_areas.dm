/area/triesto
	name = "Triesto - Zeng-Hu Spaceport"
	requires_power = 0
	no_light_control = 1
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS
	base_turf = /turf/simulated/floor/exoplanet/assunzione
	ambience = AMBIENCE_KONYANG_TRAFFIC
	sound_environment = SOUND_ENVIRONMENT_CITY
	is_outside = OUTSIDE_YES
	var/lighting = FALSE //Is this area automatically lit?

/area/triesto/Initialize()
	. = ..()
	if(lighting)
		for(var/turf/T in src)
			T.set_light(MINIMUM_USEFUL_LIGHT_RANGE, 50, COLOR_WHITE) //Same light level as Konyang proper

//All walls and interior stuff uses this area, otherwise rain will appear over walls. suboptimal!
/area/triesto/interior
	name = "Triesto - Indoors"
	sound_environment = SOUND_AREA_LARGE_SOFTFLOOR
	ambience = AMBIENCE_KONYANG_RAIN_MUFFLED
	is_outside = OUTSIDE_NO

//Main city buildings
/area/triesto/interior/laundromat
	name = "Triesto - Laundromat"

/area/triesto/interior/tailor
	name = "Triesto - Clothing Store"

/area/triesto/interior/restaurant
	name = "Triesto - Restaurant"

/area/triesto/interior/hotel
	name = "Triesto - Hotel"
	icon_state = "crew_quarters"

/area/triesto/interior/hotel/basement
	name = "Triesto - Hotel - Basement"
	icon_state = "crew_quarters"

/area/triesto/interior/arcade
	name = "Triesto - Arcade"
	area_blurb = "The deafening avalanche of arcade machines begging for your attention fill the air, all promising fantastic gaming experiences for fun and prizes."

/area/triesto/interior/minimart
	name = "Triesto - Convenience Store"

/area/triesto/interior/cafe
	name = "Triesto - Cafe"

/area/triesto/interior/streetvendor
	name = "Triesto - Decrepit Street Vendor"

/area/triesto/interior/police
	name = "Triesto - Police Department"
	icon_state = "security"

/area/triesto/interior/bar
	name = "Triesto - Bar"

/area/triesto/interior/robotics
	name = "Triesto - Robotics Clinic"

/area/triesto/interior/spaceport
	name = "Triesto - Spaceport"

/area/triesto/interior/decrepit
	name = "Triesto - Decrepit Apartments"
	area_blurb = "A damp smell lingers in the air inside these dusty apartments, it might be wise to keep an eye out for mold."

/area/triesto/interior/pharmacy
	name = "Triesto - Pharmacy"

/area/triesto/interior/parking
	name = "Triesto - Parking Shelter"

/area/triesto/interior/special_ops
	name = "Triesto - Conglomerate Oversight"

/area/triesto/interior/offices
	name = "Triesto - Corporate Offices"

/area/triesto/interior/offices/basement
	name = "Triesto - Corporate Subterranean Compound"

/area/triesto/interior/offices/headquarters
	name = "Conglomerate Local Command Headquarters"

/area/triesto/interior/offices/kaf
	name = "KAF Military Base"

/area/triesto/interior/offices/einstein
	name = "Einstein Engines System Advisory"

/area/triesto/interior/maint_janitorial
	name = "Triesto - Maint/Janitorial"
	icon_state = "maintenance"

/area/triesto/interior/tunnels
	name = "Triesto - Tunnels"
	area_blurb = "Sounds echo impressively through these tunnels."

/area/triesto/interior/shallow//For open-walled areas, like awnings and balconies
	sound_environment = SOUND_ENVIRONMENT_CITY

/area/triesto/outdoors
	name = "Triesto - Outdoors"
	area_blurb = "The sounds and smells of Triesto bombard you from all directions. Skyscrapers tower up further into the city."
	lighting = TRUE

/area/triesto/water
	name = "Triesto - Open Water"
	icon_state = "fitness_pool"
	lighting = TRUE

/area/triesto/water/deep // also used for waterdock landing area
	name = "Triesto - Deep Water"
	lighting = TRUE
