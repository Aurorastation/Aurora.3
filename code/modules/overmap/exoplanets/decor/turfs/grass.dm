/turf/simulated/floor/exoplanet/grass
	name = "grass"
	icon = 'icons/turf/jungle.dmi'
	icon_state = "greygrass"
	color = "#799c4b"
	footstep_sound = /singleton/sound_category/grass_footstep
	does_footprint = FALSE

/turf/simulated/floor/exoplanet/grass/Initialize()
	. = ..()
	if(current_map.use_overmap)
		var/obj/effect/overmap/visitable/sector/exoplanet/E = map_sectors["[z]"]
		if(color && istype(E) && E.grass_color)
			color = E.grass_color
	if(!resources)
		resources = list()
	if(prob(5))
		resources[MATERIAL_URANIUM] = rand(1,3)
	if(prob(2))
		resources[MATERIAL_DIAMOND] = 1

/turf/simulated/floor/exoplanet/grass/grove
	icon_state = "grove_grass1"
	color = null
	has_edge_icon = FALSE

/turf/simulated/floor/exoplanet/grass/grove/Initialize()
	. = ..()
	icon_state = "grove_grass[rand(1,2)]"

/turf/simulated/floor/exoplanet/grass/stalk
	icon = 'icons/turf/total_floors.dmi'
	icon_state = "grass_stalk"
	color = null
	has_edge_icon = null

/turf/simulated/floor/exoplanet/grass/marsh
	icon = 'icons/turf/fungal_marsh.dmi'
	icon_state = "marsh"
	color = null
	has_edge_icon = null
	footstep_sound = /singleton/sound_category/water_footstep
	does_footprint = TRUE

/turf/simulated/floor/exoplanet/grass/marsh/Initialize()
	. = ..()
	icon_state = "marsh[rand(1,8)]"
