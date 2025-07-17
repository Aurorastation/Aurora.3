/turf/simulated/floor/exoplanet/desert
	name = "sand"
	gender = PLURAL
	desc = "It's coarse and gets everywhere."
	icon = 'icons/turf/desert.dmi'
	icon_state = "desert"
	dirt_color = "#ae9e66"
	footstep_sound = /singleton/sound_category/sand_footstep

/turf/simulated/floor/exoplanet/desert/Initialize()
	. = ..()
	icon_state = "desert[rand(1,4)]"

// TODO: Need additional desert turf sprites to distinguish the rough subtype, currently goes no higher than desert4.
/turf/simulated/floor/exoplanet/desert/rough/Initialize()
	. = ..()
	// icon_state = "desert[rand(5,7)]"
