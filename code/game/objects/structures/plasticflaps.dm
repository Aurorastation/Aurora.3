/obj/structure/plasticflaps //HOW DO YOU CALL THOSE THINGS ANYWAY
	name = "\improper plastic flaps"
	desc = "Completely impassable - or are they?"
	icon = 'icons/obj/stationobjs.dmi' //Change this.
	icon_state = "plasticflaps"
	density = 0
	anchored = 1
	layer = 4
	explosion_resistance = 5
	build_amt = 4
	var/manipulating = FALSE //Prevents queueing up a ton of deconstructs
	var/list/mobs_can_pass = list(
		/mob/living/carbon/slime,
		/mob/living/simple_animal/rat,
		/mob/living/silicon/robot/drone
		)

/obj/structure/plasticflaps/Initialize()
	. = ..()
	material = SSmaterials.get_material_by_name(MATERIAL_PLASTIC)

/obj/structure/plasticflaps/CanPass(atom/A, turf/T)
	if(istype(A) && A.checkpass(PASSGLASS))
		return prob(60)

	var/obj/structure/bed/B = A
	if (istype(A, /obj/structure/bed) && B.buckled)//if it's a bed/chair and someone is buckled, it will not pass
		return 0

	if(istype(A, /obj/vehicle))	//no vehicles
		return 0

	var/mob/living/M = A
	if(istype(M))
		if(M.lying)
			return ..()
		for(var/mob_type in mobs_can_pass)
			if(istype(A, mob_type))
				return ..()
		return issmall(M)

	return ..()

/obj/structure/plasticflaps/ex_act(severity)
	switch(severity)
		if (1)
			qdel(src)
		if (2)
			if (prob(50))
				qdel(src)
		if (3)
			if (prob(5))
				qdel(src)

/obj/structure/plasticflaps/attackby(obj/item/W, mob/user)
	if(manipulating)	return
	if(W.iswirecutter() || W.sharp && !W.noslice)
		manipulating = TRUE
		visible_message(SPAN_NOTICE("[user] begins cutting down \the [src]."),
					SPAN_NOTICE("You begin cutting down \the [src]."))
		if(!W.use_tool(src, user, 30, volume = 50))
			manipulating = FALSE
			return
		visible_message(SPAN_NOTICE("[user] cuts down \the [src]."), SPAN_NOTICE("You cut down \the [src]."))
		dismantle()

/obj/structure/plasticflaps/mining //A specific type for mining that doesn't allow airflow because of them damn crates
	name = "airtight plastic flaps"
	desc = "Heavy duty, airtight, plastic flaps."

/obj/structure/plasticflaps/mining/Initialize() //set the turf below the flaps to block air
	..()
	var/turf/T = get_turf(loc)
	if(T)
		T.blocks_air = 1


/obj/structure/plasticflaps/mining/Destroy() //lazy hack to set the turf to allow air to pass if it's a simulated floor
	var/turf/T = get_turf(loc)
	if(T)
		if(istype(T, /turf/simulated/floor))
			T.blocks_air = 0
	return ..()


//Airtight plastic flaps made for the kitchen freezer, blocks atmos but not movement
/obj/structure/plasticflaps/airtight
	name = "airtight plastic flaps"
	desc = "Heavy duty, airtight, plastic flaps."
	layer = 3

/obj/structure/plasticflaps/airtight/Initialize() //set the turf below the flaps to block air
	..()
	var/turf/T = get_turf(loc)
	if(T)
		T.blocks_air = 1

/obj/structure/plasticflaps/airtight/Destroy() //lazy hack to set the turf to allow air to pass if it's a simulated floor
	var/turf/T = get_turf(loc)
	if(T)
		if(istype(T, /turf/simulated/floor))
			T.blocks_air = 0
	return ..()

/obj/structure/plasticflaps/airtight/CanPass(atom/A, turf/T)
	return 1//Blocks nothing except air