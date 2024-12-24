//Clears walls
/obj/effect/landmark/clear
	name = "clear turf"
	icon = 'icons/effects/landmarks.dmi'
	icon_state = "clear"

/obj/effect/landmark/clear/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/landmark/clear/LateInitialize()
	var/turf/simulated/wall/W = get_turf(src)
	if(istype(W))
		W.dismantle_wall(TRUE, TRUE)
	var/turf/simulated/mineral/M = W
	if(istype(M))
		M.GetDrilled()

	qdel(src) //Our job here is done

//Applies fire act to the turf
/obj/effect/landmark/scorcher
	name = "fire"
	icon = 'icons/effects/landmarks.dmi'
	icon_state = "fire"
	var/temp = T0C + 3000

/obj/effect/landmark/scorcher/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD //This assures that everything under the marker has loaded before burning it

/obj/effect/landmark/scorcher/LateInitialize()
	var/turf/simulated/T = get_turf(src)
	if(istype(T))
		T.fire_act(temp)

	qdel(src) //Our job here is done
