/area/point_verdant
	name = "Point Verdant - Conglomerate Spaceport"
	requires_power = 0
	no_light_control = 1
	flags = HIDE_FROM_HOLOMAP
	base_turf = /turf/simulated/floor/exoplanet/dirt_konyang
	ambience = list('sound/ambience/konyang/konyang-traffic.ogg','sound/ambience/konyang/konyang-traffic-001.ogg')
	sound_env = CITY

/area/point_verdant/outer
	name = "Point Verdant - Outskirts"
	sound_env = FOREST

/area/point_verdant/coast
	name = "Point Verdant - Waterside"
	ambience = list('sound/ambience/konyang/konyang-traffic.ogg','sound/ambience/konyang/konyang-traffic-001.ogg','sound/ambience/konyang/konyang-water.ogg')

/area/point_verdant/reservoir
	name = "Point Verdant - Reservoir"
	sound_env = PLAIN
	ambience = list('sound/ambience/konyang/konyang-water.ogg')

/area/point_verdant/sewer
	name = "Point Verdant - Sewers"
	sound_env = SEWER_PIPE

//All walls and interior stuff uses this area, otherwise rain will appear over walls. suboptimal!
/area/point_verdant/interior
	name = "Point Verdant - Indoors"
	sound_env = LARGE_SOFTFLOOR

//Stuff for rainy areas below. WIP implementation
/area/point_verdant/outdoors
	name = "Point Verdant - Outdoors"

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
