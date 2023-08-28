/singleton/psionic_power/warp
	name = "Warp"
	desc = "Warp through objects."
	icon_state = "tech_blink"
	point_cost = 4
	ability_flags = PSI_FLAG_ANTAG
	spell_path = /obj/item/spell/warp

/obj/item/spell/warp
	name = "warp"
	icon_state = "warp_strike"
	cast_methods = CAST_MELEE
	aspect = ASPECT_PSIONIC
	cooldown = 50
	psi_cost = 10
	var/maximum_distance = 20 //Measured in tiles.
	var/busy = FALSE

/obj/item/spell/warp/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)
	. = ..()
	if(!.)
		return
	if(busy)	//Prevent someone from trying to get two uses of the spell from one instance.
		return FALSE
	if(!allowed_to_teleport())
		to_chat(user, SPAN_WARNING("You can't teleport here."))
		return FALSE
	var/turf/T = get_turf(hit_atom)		//Turf we touched.
	var/turf/our_turf = get_turf(user)	//Where we are.
	if(!T.density)
		if(!T.check_density())
			to_chat(user, SPAN_WARNING("This spell is for solid objects."))
			return FALSE
	var/direction = get_dir(our_turf, T)
	var/turf/checked_turf = T			//Turf we're currently checking for density in the loop below.
	var/turf/found_turf = null			//Our destination, if one is found.
	var/i = maximum_distance

	visible_message(SPAN_NOTICE("[user] rests a hand on \the [hit_atom]."))
	busy = TRUE

	spark(our_turf, 3, cardinal)

	while(i)
		checked_turf = get_step(checked_turf, direction) //Advance in the given direction
		i--

		if(!checked_turf.density) //If we found a destination (a non-dense turf), then we can stop.
			var/dense_objs_on_turf = 0
			for(var/atom/movable/stuff in checked_turf.contents) //Make sure nothing dense is where we want to go, like an airlock or window.
				if(stuff.density)
					dense_objs_on_turf = 1

			if(!dense_objs_on_turf) //If we found a non-dense turf with nothing dense on it, then that's our destination.
				found_turf = checked_turf
				break
		sleep(10)

	if(found_turf)
		if(user.loc != our_turf)
			to_chat(user, SPAN_WARNING("You need to stand still in order to phase through \the [hit_atom]."))
			return FALSE
		if(!user.incapacitated())
			visible_message(SPAN_WARNING("[user] appears to phase through \the [hit_atom]!"))
			to_chat(user, SPAN_NOTICE("You find a destination on the other side of \the [hit_atom], and phase through it."))
			spark(src, 5, 0)
			user.forceMove(found_turf)
			qdel(src)
			return TRUE
		else
			to_chat(user, SPAN_WARNING("You don't have enough energy to phase through these walls!"))
			busy = FALSE
	else
		to_chat(user, SPAN_NOTICE("You weren't able to find an open space to go to."))
		busy = FALSE
