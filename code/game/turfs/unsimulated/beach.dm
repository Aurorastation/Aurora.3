/turf/unsimulated/beach
	name = "Beach"
	icon = 'icons/misc/beach.dmi'
	footstep_sound = /singleton/sound_category/sand_footstep

/turf/unsimulated/beach/sand
	name = "Sand"
	icon_state = "sand"
	footstep_sound = /singleton/sound_category/sand_footstep

/turf/unsimulated/beach/coastline
	name = "Coastline"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"
	footstep_sound = /singleton/sound_category/sand_footstep

/turf/unsimulated/beach/water
	name = "Water"
	icon_state = "water"
	footstep_sound = /singleton/sound_category/water_footstep

/turf/unsimulated/beach/water/Initialize()
	. = ..()
	AddOverlays(image("icon"='icons/misc/beach.dmi',"icon_state"="water2","layer"=MOB_LAYER+0.1))
