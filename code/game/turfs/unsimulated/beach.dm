/turf/unsimulated/beach
	name = "Beach"
	icon = 'icons/misc/beach.dmi'
	footstep_type = "sandstep"

/turf/unsimulated/beach/sand
	name = "Sand"
	icon_state = "sand"
	footstep_type = "sandstep"

/turf/unsimulated/beach/coastline
	name = "Coastline"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"
	footstep_type = "sandstep"

/turf/unsimulated/beach/water
	name = "Water"
	icon_state = "water"
	footstep_type = "waterstep"

/turf/unsimulated/beach/water/Initialize()
	. = ..()
	add_overlay(image("icon"='icons/misc/beach.dmi',"icon_state"="water2","layer"=MOB_LAYER+0.1))
