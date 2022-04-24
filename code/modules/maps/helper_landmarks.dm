/obj/effect/landmark/map_load_mark
	name = "map loader landmark"
	var/list/templates	//list of template types to pick from

//Clears walls
/obj/effect/landmark/clear
	name = "clear turf"
	icon = 'icons/effects/landmarks.dmi'
	icon_state = "clear"
	delete_me = TRUE

/obj/effect/landmark/clear/Initialize()
	var/turf/simulated/wall/W = get_turf(src)
	if(istype(W))
		W.dismantle_wall(TRUE, TRUE)
	var/turf/simulated/mineral/M = W
	if(istype(M))
		M.GetDrilled()
	. = ..()

//Applies fire act to the turf
/obj/effect/landmark/scorcher
	name = "fire"
	icon = 'icons/effects/landmarks.dmi'
	icon_state = "fire"
	var/temp = T0C + 3000

/obj/effect/landmark/scorcher/Initialize()
	var/turf/simulated/T = get_turf(src)
	if(istype(T))
		T.fire_act(temp)
	. = ..()