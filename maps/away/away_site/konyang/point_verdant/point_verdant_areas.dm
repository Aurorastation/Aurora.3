/area/point_verdant
	name = "Point Verdant - Conglomerate Spaceport"
	requires_power = 0
	no_light_control = 1
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS
	base_turf = /turf/simulated/floor/exoplanet/dirt_konyang
	ambience = AMBIENCE_KONYANG_TRAFFIC
	sound_environment = SOUND_ENVIRONMENT_CITY
	is_outside = TRUE
	var/lighting = FALSE //Is this area automatically lit?

/area/point_verdant/Initialize()
	. = ..()
	if(lighting)
		for(var/turf/T in src)
			T.set_light(MINIMUM_USEFUL_LIGHT_RANGE, 50, COLOR_WHITE) //Same light level as Konyang proper

/area/point_verdant/outer
	name = "Point Verdant - Outskirts"
	sound_environment = SOUND_ENVIRONMENT_FOREST
	lighting = TRUE

/area/point_verdant/coast
	name = "Point Verdant - Waterside"
	ambience = AMBIENCE_KONYANG_WATER
	area_blurb = "The crashing sounds of waves on the shore punctuates the air. The vast ocean spreads out as far as the eye can see, looking almost flat."
	area_blurb_category = "verdant_shore"
	lighting = TRUE

/area/point_verdant/reservoir
	name = "Point Verdant - Reservoir"
	sound_environment = SOUND_ENVIRONMENT_PLAIN
	ambience = AMBIENCE_KONYANG_WATER
	lighting = TRUE

/area/point_verdant/sewer
	name = "Point Verdant - Sewers"
	sound_environment = SOUND_ENVIRONMENT_SEWER_PIPE
	area_blurb = "Tainted water flows through these dark and grimy sewers, it smells utterly horrible down here. It's best not to think what you are breathing in, or touching."
	area_blurb_category = "verdant_sewers"
//All walls and interior stuff uses this area, otherwise rain will appear over walls. suboptimal!
/area/point_verdant/interior
	name = "Point Verdant - Indoors"
	sound_environment = SOUND_AREA_LARGE_SOFTFLOOR
	ambience = AMBIENCE_KONYANG_RAIN_MUFFLED
	is_outside = FALSE

//Main city buildings
/area/point_verdant/interior/laundromat
	name = "Point Verdant - Laundromat"

/area/point_verdant/interior/tailor
	name = "Point Verdant - Clothing Store"

/area/point_verdant/interior/restaurant
	name = "Point Verdant - Restaurant"

/area/point_verdant/interior/hotel
	name = "Point Verdant - Hotel"
	icon_state = "crew_quarters"

/area/point_verdant/interior/hotel/basement
	name = "Point Verdant - Hotel - Basement"
	icon_state = "crew_quarters"

/area/point_verdant/interior/arcade
	name = "Point Verdant - Arcade"
	area_blurb = "The deafening avalanche of arcade machines begging for your attention fill the air, all promising fantastic gaming experiences for fun and prizes."
	area_blurb_category = "verdant_arcade"

/area/point_verdant/interior/minimart
	name = "Point Verdant - Convenience Store"

/area/point_verdant/interior/cafe
	name = "Point Verdant - Cafe"

/area/point_verdant/interior/streetvendor
	name = "Point Verdant - Decrepit Street Vendor"

/area/point_verdant/interior/police
	name = "Point Verdant - Police Department"
	icon_state = "security"

/area/point_verdant/interior/bar
	name = "Point Verdant - Bar"

/area/point_verdant/interior/robotics
	name = "Point Verdant - Robotics Clinic"

/area/point_verdant/interior/spaceport
	name = "Point Verdant - Spaceport"

/area/point_verdant/interior/decrepit
	name = "Point Verdant - Decrepit Apartments"
	area_blurb = "A damp smell lingers in the air inside these dusty apartments, it might be wise to keep an eye out for mold."
	area_blurb_category = "verdant_decrepit_apartment"

/area/point_verdant/interior/pharmacy
	name = "Point Verdant - Pharmacy"

/area/point_verdant/interior/parking
	name = "Point Verdant - Parking Shelter"

/area/point_verdant/interior/special_ops
	name = "Point Verdant - Conglomerate Oversight"

/area/point_verdant/interior/offices
	name = "Point Verdant - Corporate Offices"

/area/point_verdant/interior/offices/basement
	name = "Point Verdant - Corporate Subterranean Compound"

/area/point_verdant/interior/offices/headquarters
	name = "Conglomerate Local Command Headquarters"

/area/point_verdant/interior/offices/kaf
	name = "KAF Military Base"

/area/point_verdant/interior/offices/einstein
	name = "Einstein Engines System Advisory"

/area/point_verdant/interior/maint_janitorial
	name = "Point Verdant - Maint/Janitorial"
	icon_state = "maintenance"

/area/point_verdant/interior/tunnels
	name = "Point Verdant - Tunnels"
	area_blurb = "Sounds echo impressively through these tunnels."
	area_blurb_category = "verdant_tunnels"

/area/point_verdant/interior/shallow//For open-walled areas, like awnings and balconies
	sound_environment = SOUND_ENVIRONMENT_CITY

/area/point_verdant/outdoors
	name = "Point Verdant - Outdoors"
	area_blurb = "The sounds and smells of Point Verdant bombard you from all directions. Skyscrapers tower up further into the city."
	area_blurb_category = "verdant_outdoors"
	lighting = TRUE

/area/point_verdant/water
	name = "Point Verdant - Open Water"
	icon_state = "fitness_pool"
	lighting = TRUE

/area/point_verdant/water/deep // also used for waterdock landing area
	name = "Point Verdant - Deep Water"
	lighting = TRUE
