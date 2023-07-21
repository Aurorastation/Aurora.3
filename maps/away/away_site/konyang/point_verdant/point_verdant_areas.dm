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

/area/point_verdant/interior
	name = "Point Verdant - Indoors"
	sound_env = LARGE_SOFTFLOOR
