/turf/simulated/floor/exoplanet/grass
	name = "grass"
	gender = PLURAL
	desc = "Some lush grass."
	icon = 'icons/turf/jungle.dmi'
	icon_state = "greygrass"
	color = "#799c4b"
	footstep_sound = /singleton/sound_category/grass_footstep

/turf/simulated/floor/exoplanet/grass/Initialize()
	. = ..()
	if(SSatlas.current_map.use_overmap)
		var/obj/effect/overmap/visitable/sector/exoplanet/E = GLOB.map_sectors["[z]"]
		if(color && istype(E) && E.grass_color)
			color = E.grass_color
	if(!resources)
		resources = list()
	if(prob(5))
		resources[ORE_URANIUM] = rand(1,3)
	if(prob(2))
		resources[ORE_DIAMOND] = 1

/turf/simulated/floor/exoplanet/grass/grove
	desc = "Short grass is growing here."
	icon_state = "grove_grass1"
	color = null
	has_edge_icon = FALSE

/turf/simulated/floor/exoplanet/grass/grove/Initialize()
	. = ..()
	icon_state = "grove_grass[rand(1,2)]"

/turf/simulated/floor/exoplanet/grass/stalk
	name = "stalky grass"
	desc = "Odd-looking, stalky grass."
	icon = 'icons/turf/flooring/grass.dmi'
	icon_state = "grass_stalk"
	color = null
	has_edge_icon = null

/turf/simulated/floor/exoplanet/grass/marsh
	name = "marshy ground"
	desc = "Marshy ground, small mushrooms grow here and there."
	icon = 'icons/turf/fungal_marsh.dmi'
	icon_state = "marsh"
	color = null
	has_edge_icon = null
	footstep_sound = /singleton/sound_category/water_footstep

/turf/simulated/floor/exoplanet/grass/marsh/Initialize()
	. = ..()
	icon_state = "marsh[rand(1,8)]"

/turf/simulated/floor/exoplanet/grass/moghes
	name = "alien grass"
	desc = "Thick, alien grass grows here."
	icon = 'icons/turf/flooring/exoplanet/moghes.dmi'
	icon_state = "grass"
	color = null

/turf/simulated/floor/exoplanet/grass/moghes/dirt
	name = "dirt"
	desc = "A patch of dirt."
	icon_state = "dirt"
	color = null

/turf/simulated/floor/exoplanet/grass/moghes/dirt/beach
	desc = "The ground slopes down into some water."
	icon_state = "beach"
