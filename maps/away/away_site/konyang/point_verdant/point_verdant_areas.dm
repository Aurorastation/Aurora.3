/area/point_verdant
	name = "Point Verdant - Conglomerate Spaceport"
	requires_power = 0
	no_light_control = 1
	flags = HIDE_FROM_HOLOMAP | RAD_SHIELDED
	base_turf = /turf/simulated/floor/exoplanet/dirt_konyang
	ambience = AMBIENCE_KONYANG_TRAFFIC
	sound_env = CITY

/area/point_verdant/outer
	name = "Point Verdant - Outskirts"
	sound_env = FOREST

/area/point_verdant/coast
	name = "Point Verdant - Waterside"
	ambience = AMBIENCE_KONYANG_WATER

/area/point_verdant/reservoir
	name = "Point Verdant - Reservoir"
	sound_env = PLAIN
	ambience = AMBIENCE_KONYANG_WATER

/area/point_verdant/sewer
	name = "Point Verdant - Sewers"
	sound_env = SEWER_PIPE

//All walls and interior stuff uses this area, otherwise rain will appear over walls. suboptimal!
/area/point_verdant/interior
	name = "Point Verdant - Indoors"
	sound_env = LARGE_SOFTFLOOR
	ambience = AMBIENCE_KONYANG_RAIN_MUFFLED

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

/area/point_verdant/interior/arcade
	name = "Point Verdant - Arcade"

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

/area/point_verdant/interior/pharmacy
	name = "Point Verdant - Pharmacy"

/area/point_verdant/interior/parking
	name = "Point Verdant - Parking Shelter"

/area/point_verdant/interior/special_ops
	name = "Point Verdant - Conglomerate Oversight"

/area/point_verdant/interior/offices
	name = "Point Verdant - Corporate Offices"

/area/point_verdant/interior/maint_janitorial
	name = "Point Verdant - Maint/Janitorial"
	icon_state = "maintenance"

/area/point_verdant/interior/tunnels
	name = "Point Verdant - Tunnels"

/area/point_verdant/interior/shallow//For open-walled areas, like awnings and balconies
	sound_env = CITY
	ambience = AMBIENCE_KONYANG_RAIN_INDOORS

//Stuff for rainy areas below. WIP implementation
/area/point_verdant/outdoors
	name = "Point Verdant - Outdoors"
	ambience = AMBIENCE_KONYANG_RAIN

/area/point_verdant/outdoors/Initialize()
	. = ..()
	add_overlay(image("icon"='icons/effects/rain_effects.dmi',"icon_state"="splat","layer"=OBJ_LAYER-0.1))
	add_overlay(image("icon"='icons/effects/rain_effects.dmi',"icon_state"="rain","layer"=MOB_LAYER+0.1))

/area/point_verdant/water
	name = "Point Verdant - Open Water"

/area/point_verdant/water/Initialize()
	. = ..()
	add_overlay(image("icon"='icons/effects/rain_effects.dmi',"icon_state"="ripple","layer"=OBJ_LAYER-0.1))
	add_overlay(image("icon"='icons/effects/rain_effects.dmi',"icon_state"="rain","layer"=MOB_LAYER+0.1))
