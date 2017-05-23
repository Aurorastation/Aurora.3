/mob/verb/up()
	set name = "Move Upwards"
	set category = "IC"

	if(zMove(UP))
		to_chat(usr, "<span class='notice'>You move upwards.</span>")

/mob/verb/down()
	set name = "Move Down"
	set category = "IC"

	if(zMove(DOWN))
		to_chat(usr, "<span class='notice'>You move down.</span>")

/mob/proc/zMove(direction)
	if(eyeobj)
		return eyeobj.zMove(direction)
	if(!can_ztravel())
		to_chat(usr, "<span class='warning'>You lack means of travel in that direction.</span>")
		return

	var/turf/destination = (direction == UP) ? GetAbove(src) : GetBelow(src)

	if(!destination)
		to_chat(usr, "<span class='notice'>There is nothing of interest in this direction.</span>")
		return 0

	var/turf/start = get_turf(src)
	if(!start.CanZPass(src, direction))
		to_chat(usr, "<span class='warning'>\The [start] is in the way.</span>")
		return 0
	if(!destination.CanZPass(src, direction))
		to_chat(usr, "<span class='warning'>You bump against \the [destination].</span>")
		return 0

	var/area/area = get_area(src)
	if(direction == UP && area.has_gravity && !usr.CanAvoidGravity())
		to_chat(usr, "<span class='warning'>Gravity stops you from moving upward.</span>")
		return 0

	for(var/atom/A in destination)
		if(!A.CanPass(src, start, 1.5, 0))
			to_chat(usr, "<span class='warning'>\The [A] blocks you.</span>")
			return 0
	Move(destination)
	return 1

/mob/eye/zMove(direction)
	var/turf/destination = (direction == UP) ? GetAbove(src) : GetBelow(src)
	if(destination)
		setLoc(destination)
	else
		to_chat(usr, "<span class='notice'>There is nothing of interest in this direction.</span>")

/mob/dead/observer/zMove(direction)
	var/turf/destination = (direction == UP) ? GetAbove(src) : GetBelow(src)
	if(destination)
		forceMove(destination)
	else
		to_chat(usr, "<span class='notice'>There is nothing of interest in this direction.</span>")

/mob/living/carbon/human/bst/zMove(direction)
	var/turf/destination = (direction == UP) ? GetAbove(src) : GetBelow(src)
	if(destination)
		forceMove(destination)
	else
		to_chat(usr, "<span class='notice'>There is nothing of interest in this direction.</span>")

/**
 * @brief	Used to determine whether or not a given mob can override gravity when
 * attempting to Z-move UP.
 *
 * Returns FALSE in standard mob cases. Exists for carbon/human and other child overrides.
 *
 * @return	TRUE if the mob can Z-move up despite gravity.
 *			FALSE otherwise.
 */
/mob/proc/CanAvoidGravity()
	return FALSE

/mob/living/carbon/human/CanAvoidGravity()
	if (!restrained())
		var/obj/item/weapon/tank/jetpack/thrust = GetJetpack(src)

		if (thrust && !lying && thrust.allow_thrust(0.01, src))
			return TRUE

	return ..()

/mob/living/silicon/robot/CanAvoidGravity()
	var/obj/item/weapon/tank/jetpack/thrust = GetJetpack(src)

	if (thrust && thrust.allow_thrust(0.02, src))
		return TRUE

	return ..()

/mob/proc/can_ztravel()
	return 0

/mob/dead/observer/can_ztravel()
	return 1

/mob/living/carbon/human/can_ztravel()
	if(incapacitated())
		return 0

	if(Allow_Spacemove())
		return 1

	if(Check_Shoegrip())	//scaling hull with magboots
		for(var/turf/simulated/T in trange(1,src))
			if(T.density)
				return 1

/mob/living/silicon/robot/can_ztravel()
	if(incapacitated() || is_dead())
		return 0

	if(Allow_Spacemove()) //Checks for active jetpack
		return 1

	for(var/turf/simulated/T in trange(1,src)) //Robots get "magboots"
		if(T.density)
			return 1

//FALLING STUFF

//Holds fall checks that should not be overriden by children
/atom/movable/proc/fall()
	if(!isturf(loc))
		return

	var/turf/below = GetBelow(src)
	if(!below)
		return

	var/turf/T = loc
	if(!T.CanZPass(src, DOWN) || !below.CanZPass(src, DOWN))
		return

	// No gravity in space, apparently.
	var/area/area = get_area(src)
	if(!area.has_gravity())
		return

	if(throwing)
		return

	if(can_fall())
		handle_fall(below)

//For children to override
/atom/movable/proc/can_fall()
	if(anchored)
		return FALSE

	if(locate(/obj/structure/lattice, loc))
		return FALSE

	// See if something prevents us from falling.
	var/turf/below = GetBelow(src)
	for(var/atom/A in below)
		if(!A.CanPass(src, src.loc))
			return FALSE

	return TRUE

/obj/effect/can_fall()
	return FALSE

/obj/effect/decal/cleanable/can_fall()
	return TRUE

/obj/item/pipe/can_fall()
	var/turf/simulated/open/below = loc
	below = below.below

	. = ..()

	if(anchored)
		return FALSE

	if((locate(/obj/structure/disposalpipe/up) in below) || locate(/obj/machinery/atmospherics/pipe/zpipe/up in below))
		return FALSE

/mob/living/carbon/human/can_fall()
	// Special condition for jetpack mounted folk!
	if (!restrained())
		var/obj/item/weapon/tank/jetpack/thrust = GetJetpack(src)

		if (thrust && thrust.stabilization_on &&\
			!lying && thrust.allow_thrust(0.01, src))
			return FALSE

	return ..()

/mob/living/silicon/robot/can_fall()
	var/obj/item/weapon/tank/jetpack/thrust = GetJetpack(src)

	if (thrust && thrust.stabilization_on && thrust.allow_thrust(0.02, src))
		return FALSE

	return ..()

/atom/movable/proc/handle_fall(var/turf/landing)
	Move(landing)
	if(locate(/obj/structure/stairs) in landing)
		return 1

	if(istype(landing, /turf/simulated/open))
		visible_message("\The [src] falls from the level above through \the [landing]!", "You hear a whoosh of displaced air.")
	else if(!istype(landing, /turf/space))
		visible_message("\The [src] falls from the level above and slams onto \the [landing]!", "You hear something slam onto the floor.")

/mob/living/handle_fall(var/turf/landing)
	if(..())
		return

	var/area/area1 = get_area(landing)
	if(!area1.has_gravity())
		return

	if(istype(landing, /turf/simulated/open))
		var/turf/simulated/open/open = landing
		var/area/area2 = get_area(open.below)
		if(!area2.has_gravity())
			return

	if(!istype(src, /mob/living/carbon/human))
		var/damage = 30
		apply_damage(rand(0, damage), BRUTE)
		apply_damage(rand(0, damage), BRUTE)
		apply_damage(rand(0, damage), BRUTE)

/mob/living/carbon/human/handle_fall(var/turf/landing)
	if(..())
		return
	if(istype(landing, /turf/simulated/open)) // Don't damage them, but keep track of how many they fall.
		z_levels_fallen = z_levels_fallen + 1
		return
	if(istype(landing, /turf/space))
		z_levels_fallen = 0 // turns out they didn't hit anything solid. Lucky them.
		return
	if(!z_levels_fallen) // Checks if they only fell down one floor.
		z_levels_fallen = 1
	var/damage = 30*species.fall_mod
	if(prob(20)) //landed on their head
		apply_damage(rand(0, damage*z_levels_fallen), BRUTE, "head")

	else if(prob(20)) //landed on their arms
		apply_damage(rand(0, (damage*z_levels_fallen)), BRUTE, "l_arm")
		apply_damage(rand(0, (damage*z_levels_fallen)), BRUTE, "r_arm")

		if(prob(50))
			apply_damage(rand(0, ((damage/2)*z_levels_fallen)), BRUTE, "r_hand")
		if(prob(50))
			apply_damage(rand(0, ((damage/2)*z_levels_fallen)), BRUTE, "l_hand")

	else //landed on their legs
		apply_damage(10 + rand(10, (damage*z_levels_fallen)), BRUTE, "l_leg")
		apply_damage(10 + rand(10, (damage*z_levels_fallen)), BRUTE, "r_leg")

		if(prob(50))
			apply_damage(rand(0, ((damage/2)*z_levels_fallen)), BRUTE, "r_foot")
		if(prob(50))
			apply_damage(rand(0, ((damage/2)*z_levels_fallen)), BRUTE, "l_foot")
		if(prob(50))
			apply_damage(rand(0, ((damage/2)*z_levels_fallen)), BRUTE, "groin")
	apply_damage(rand(0, (damage*z_levels_fallen)), BRUTE, "chest") 
	Weaken(rand(0, ((damage/2)*z_levels_fallen)))
	z_levels_fallen = 0 // reset their fallen variable.
	updatehealth()

/mob/living/carbon/human/bst/can_fall()
	return FALSE

/mob/living/carbon/human/bst/handle_fall(turf/landing)
	return
