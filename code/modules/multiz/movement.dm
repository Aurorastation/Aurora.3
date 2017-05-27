/atom/movable
	/** Used to check wether or not an atom is being handled by SSfalling. */
	var/tmp/multiz_falling = 0

/**
 * Verb for the mob to move up a z-level if possible.
 */
/mob/verb/up()
	set name = "Move Upwards"
	set category = "IC"

	if(zMove(UP))
		to_chat(usr, "<span class='notice'>You move upwards.</span>")

/**
 * Verb for the mob to move down a z-level if possible.
 */
/mob/verb/down()
	set name = "Move Down"
	set category = "IC"

	if(zMove(DOWN))
		to_chat(usr, "<span class='notice'>You move down.</span>")

/**
 * Used to check if a mob can move up or down a Z-level and to then actually do the move.
 *
 * @param	direction The direction in which we're moving. Expects defines UP or DOWN.
 *
 * @return	TRUE if the mob has been successfully moved a Z-level.
 *			FALSE otherwise.
 */
/mob/proc/zMove(direction)
	// In the case of an active eyeobj, move that instead.
	if (eyeobj)
		return eyeobj.zMove(direction)

	// Check if we can actually travel a Z-level.
	if (!can_ztravel())
		to_chat(src, "<span class='warning'>You lack means of travel in that direction.</span>")
		return FALSE

	var/turf/destination = (direction == UP) ? GetAbove(src) : GetBelow(src)

	if(!destination)
		to_chat(src, "<span class='notice'>There is nothing of interest in this direction.</span>")
		return FALSE

	var/turf/start = get_turf(src)
	if(!start.CanZPass(src, direction))
		to_chat(src, "<span class='warning'>\The [start] is in the way.</span>")
		return FALSE

	if(!destination.CanZPass(src, direction))
		to_chat(src, "<span class='warning'>You bump against \the [destination].</span>")
		return FALSE

	var/area/area = get_area(src)

	// If we want to move up,but the current area has gravity. Invoke CanAvoidGravity()
	// to check if this move is possible.
	if(direction == UP && area.has_gravity && !CanAvoidGravity())
		to_chat(src, "<span class='warning'>Gravity stops you from moving upward.</span>")
		return FALSE

	// Check for blocking atoms at the destination.
	for (var/atom/A in destination)
		if (!A.CanPass(src, start, 1.5, 0))
			to_chat(src, "<span class='warning'>\The [A] blocks you.</span>")
			return FALSE

	// Actually move.
	Move(destination)
	return TRUE

/mob/eye/zMove(direction)
	var/turf/destination = (direction == UP) ? GetAbove(src) : GetBelow(src)
	if(destination)
		setLoc(destination)
	else
		to_chat(owner, "<span class='notice'>There is nothing of interest in this direction.</span>")

/mob/dead/observer/zMove(direction)
	var/turf/destination = (direction == UP) ? GetAbove(src) : GetBelow(src)
	if(destination)
		forceMove(destination)
	else
		to_chat(src, "<span class='notice'>There is nothing of interest in this direction.</span>")

/mob/living/carbon/human/bst/zMove(direction)
	var/turf/destination = (direction == UP) ? GetAbove(src) : GetBelow(src)
	if(destination)
		forceMove(destination)
	else
		to_chat(src, "<span class='notice'>There is nothing of interest in this direction.</span>")

/**
 * An initial check for Z-level travel. Called relatively early in mob/proc/zMove.
 *
 * Useful for overwriting and special conditions for STOPPING z-level transit.
 *
 * @return	TRUE if the mob can move a Z-level of its own volition.
 *			FALSE otherwise.
 */
/mob/proc/can_ztravel()
	return FALSE

/mob/dead/observer/can_ztravel()
	return TRUE

/mob/living/carbon/human/can_ztravel()
	if(incapacitated())
		return FALSE

	if(Allow_Spacemove())
		return TRUE

	if(Check_Shoegrip())	//scaling hull with magboots
		for(var/turf/simulated/T in trange(1,src))
			if(T.density)
				return TRUE

/mob/living/silicon/robot/can_ztravel()
	if(incapacitated() || is_dead())
		return FALSE

	if(Allow_Spacemove()) //Checks for active jetpack
		return TRUE

	for(var/turf/simulated/T in trange(1,src)) //Robots get "magboots"
		if(T.density)
			return TRUE

/**
 * Used to determine whether or not a given mob can override gravity when
 * attempting to Z-move UP.
 *
 * Returns FALSE in standard mob cases. Exists for carbon/human and other child overrides.
 *
 * @return	TRUE if the mob can Z-move up despite gravity.
 *			FALSE otherwise.
 */
/mob/proc/CanAvoidGravity()
	return FALSE

// Humans and borgs have jetpacks which allows them to override gravity! Or rather,
// they can have them. So we override and check.
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

/**
 * An overridable proc used by SSfalling to determine whether or not an atom
 * should continue falling to the next level, or stop processing and be caught
 * in midair, effectively. One of the ways to make things never fall is to make
 * this return FALSE.
 *
 * If the mob has fallen and is stopped amidst a fall by this, fall_impact is
 * invoked with the second argument being TRUE. As opposed to the default value, FALSE.
 *
 * @param	below The turf that the mob is expected to end up at.
 *
 * @return	TRUE if the atom can continue falling in its present situation.
 *			FALSE if it should stop falling and not invoke fall_through or fall_impact
 * this cycle.
 */
/atom/movable/proc/can_fall(turf/below)
	// Anchored things don't fall.
	if(anchored)
		return FALSE

	// Lattices and stairs stop things from falling.
	if(locate(/obj/structure/lattice, loc) || locate(/obj/structure/stairs, loc))
		return FALSE

	// See if something prevents us from falling.
	for(var/atom/A in below)
		if(!A.CanPass(src, src.loc))
			return FALSE

	// True otherwise.
	return TRUE

/obj/effect/can_fall()
	return FALSE

/obj/effect/decal/cleanable/can_fall()
	return TRUE

/obj/item/pipe/can_fall(turf/below)
	. = ..()

	if((locate(/obj/structure/disposalpipe/up) in below) || locate(/obj/machinery/atmospherics/pipe/zpipe/up in below))
		return FALSE

// Only things that stop mechas are atoms that, well, stop them.
// Lattices and stairs get crushed in fall_through.
/obj/mecha/can_fall(turf/below)
	// See if something prevents us from falling.
	for(var/atom/A in below)
		if(!A.CanPass(src, src.loc))
			return FALSE

	// True otherwise.
	return TRUE

/mob/living/carbon/human/can_fall()
	// Special condition for jetpack mounted folk!
	if (!restrained())
		var/obj/item/weapon/tank/jetpack/thrust = GetJetpack(src)

		if (thrust && thrust.stabilization_on &&\
			!lying && thrust.allow_thrust(0.01, src))
			return FALSE

	return ..()

/mob/living/carbon/human/bst/can_fall()
	return FALSE

/mob/living/silicon/robot/can_fall()
	var/obj/item/weapon/tank/jetpack/thrust = GetJetpack(src)

	if (thrust && thrust.stabilization_on && thrust.allow_thrust(0.02, src))
		return FALSE

	return ..()

/**
 * Invoked by SSfalling when an atom is moved one open turf to another via falling.
 *
 * src.loc can be assumed to be of type /turf/simulated/open.
 */
/atom/movable/proc/fall_through()
	visible_message("\The [src] falls from the level above through \the [loc]!",
		"You hear a whoosh of displaced air.")

/mob/fall_through()
	visible_message("\The [src] falls from the level above through \the [loc]!",
		"You fall through \the [loc]!", "You hear a whoosh of displaced air.")

/obj/mecha/fall_through()
	var/obj/structure/lattice/L = locate() in loc
	if (L)
		visible_message("<span class='danger'>\The [src] crushes \the [L] with its weight!</span>")
		qdel(L)

	var/obj/structure/stairs/S = locate() in loc
	if (S)
		visible_message("<span class='danger'>\The [src] crushes \the [S] with its weight!</span>")
		qdel(S)

/**
 * Invoked when an atom has landed on a tile through which they can no longer fall.
 *
 * src.loc now contains the final and updated position of the atom.
 *
 * @param	levels_fallen How many Z-levels the atom has fallen before landing
 * on its current loc.
 * @param	stopped_early TRUE if the fall was stopped by can_fall.
 *						  FALSE if the fall was stopped by the fact that the atom
 *						  was no longer on an open turf.
 *
 * @return	TRUE if the proc ran completely. FALSE otherwise. Used to determine
 * if child procs should continue running or not, really.
 */
/atom/movable/proc/fall_impact(levels_fallen, stopped_early = FALSE)
	// No gravity, stop falling into spess!
	var/area/area = get_area(src)
	if (istype(loc, /turf/space) || (area && !area.has_gravity))
		return FALSE

	visible_message("\The [src] falls and lands on \the [loc]!", "You hear a thud!")

	return TRUE

// Mobs take damage if they fall!
/mob/living/fall_impact(levels_fallen, stopped_early = FALSE)
	// No gravity, stop falling into spess!
	var/area/area = get_area(src)
	if (istype(loc, /turf/space) || (area && !area.has_gravity))
		return FALSE

	visible_message("\The [src] falls and lands on \the [loc]!",
		"With a loud thud, you land on \the [loc]!", "You hear a thud!")

	var/damage = 30 * levels_fallen
	apply_damage(rand(0, damage), BRUTE)
	apply_damage(rand(0, damage), BRUTE)
	apply_damage(rand(0, damage), BRUTE)

	// The only piece of duplicate code. I was so close. Soooo close. :ree:
	if(!isSynthetic())
		switch(damage)
			if(-INFINITY to 10)
				playsound(src.loc, "sound/weapons/bladeslice.ogg", 50, 1)
			if(11 to 50)
				playsound(src.loc, "sound/weapons/punch[rand(1, 4)].ogg", 75, 1)
			if(51 to INFINITY)
				playsound(src.loc, "sound/weapons/heavysmash.ogg", 100, 1)
			else
				playsound(src.loc, "sound/weapons/genhit1.ogg", 75, 1)
	else
		playsound(src.loc, "sound/weapons/smash.ogg", 75, 1)

	return TRUE

/mob/living/carbon/human/fall_impact(levels_fallen, stopped_early = FALSE)
	// No gravity, stop falling into spess!
	var/area/area = get_area(src)
	if (istype(loc, /turf/space) || (area && !area.has_gravity))
		return FALSE

	visible_message("\The [src] falls and lands on \the [loc]!",
		"With a loud thud, you land on \the [loc]!", "You hear a thud!")

	var/damage = 25 * species.fall_mod * levels_fallen
	if(prob(20)) //landed on their head
		apply_damage(rand(0, damage), BRUTE, "head")

	else if(prob(20)) //landed on their arms
		apply_damage(rand(0, damage), BRUTE, "l_arm")
		apply_damage(rand(0, damage), BRUTE, "r_arm")

		if(prob(50))
			apply_damage(rand(0, (damage/2)), BRUTE, "r_hand")
		if(prob(50))
			apply_damage(rand(0, (damage/2)), BRUTE, "l_hand")

	else //landed on their legs
		apply_damage(10 + rand(10, damage), BRUTE, "l_leg")
		apply_damage(10 + rand(10, damage), BRUTE, "r_leg")

		if(prob(50))
			apply_damage(rand(0, (damage/2)), BRUTE, "r_foot")
		if(prob(50))
			apply_damage(rand(0, (damage/2)), BRUTE, "l_foot")
		if(prob(50))
			apply_damage(rand(0, (damage/2)), BRUTE, "groin")

	apply_damage(rand(0, damage), BRUTE, "chest")

	Weaken(rand(0, damage/2))

	updatehealth()

// Humans can be synthetic. Never forgetti.
	if(!isSynthetic())
		switch(damage)
			if(-INFINITY to 10)
				playsound(src.loc, "sound/weapons/bladeslice.ogg", 50, 1)
			if(11 to 50)
				playsound(src.loc, "sound/weapons/punch[rand(1, 4)].ogg", 75, 1)
			if(51 to INFINITY)
				playsound(src.loc, "sound/weapons/heavysmash.ogg", 100, 1)
			else
				playsound(src.loc, "sound/weapons/genhit1.ogg", 75, 1)
	else
		playsound(src.loc, "sound/weapons/smash.ogg", 75, 1)

	return TRUE

/mob/living/carbon/human/bst/fall_impact()
	return FALSE

/obj/mecha/fall_impact(levels_fallen, stopped_early = FALSE)
	. = ..()
	if (!.)
		return

	var/damage = 40 * levels_fallen
	take_damage(rand(0, damage))
	take_damage(rand(0, damage))
	take_damage(rand(0, damage))
	take_damage(rand(0, damage))

	playsound(loc, "sound/effects/bang.ogg", 100, 1)
	playsound(loc, "sound/effects/bamf.ogg", 100, 1)

/obj/vehicle/fall_impact(levels_fallen, stopped_early = FALSE)
	. = ..()
	if (!.)
		return

	var/damage = 35 * levels_fallen
	health -= (rand(0, damage) * brute_dam_coeff)
	health -= (rand(0, damage) * brute_dam_coeff)
	health -= (rand(0, damage) * brute_dam_coeff)
	health -= (rand(0, damage) * brute_dam_coeff)

	playsound(loc, "sound/effects/clang.ogg", 75, 1)

/**
 * Used to handle damage dealing for objects post fall. Why is it separated from
 * fall_impact? Because putting this into fall_impact would make the procs a huge
 * mess of snowflake istype(src, x) checks. And I'm trying to avoid this by making
 * the system quite atomic.
 *
 * @param	levels_fallen How many Z-levels the atom has fallen before landing
 * on its current loc.
 * @param	stopped_early TRUE if the fall was stopped by can_fall.
 *						  FALSE if the fall was stopped by the fact that the atom
 *						  was no longer on an open turf.
 *
 * @return	The /mob/living that was hit. null if no mob was hit.
 */
/atom/movable/proc/fall_collateral(levels_fallen, stopped_early = FALSE)
	// No gravity, stop falling into spess!
	var/area/area = get_area(src)
	if (istype(loc, /turf/space) || (area && !area.has_gravity))
		return null

	var/list/fall_specs = fall_get_specs(levels_fallen)
	var/weight = fall_specs[1]
	var/fall_force = fall_specs[2]

	var/speed = levels_fallen * throw_speed
	var/mass = (weight / THROWNOBJ_KNOCKBACK_DIVISOR) + density + opacity
	var/momentum = speed * mass
	var/damage = round(fall_force * (speed / THROWNOBJ_KNOCKBACK_DIVISOR) * momentum)

	var/miss_chance = max(15 * (levels_fallen - 1), 0)

	if (prob(miss_chance))
		return null

	if (damage < 1)
		return null

	var/mob/living/L = null

	// Can't use  locate due to the if check.
	for (var/mob/living/ll in loc)
		// in contents check exists for vehicles, mechas, etcetera.
		if (ll != src && !(ll in contents))
			L = ll
			break

	if (!L)
		return null

	if (ishuman(L))
		var/mob/living/carbon/human/H = L
		H.apply_damage(rand(damage / 2, damage), BRUTE, "head")
		H.apply_damage(damage, BRUTE, "chest")

		if (damage >= THROWNOBJ_KNOCKBACK_DIVISOR)
			H.Weaken(rand(damage / 4, damage / 2))
	else
		L.apply_damage(damage, BRUTE)
		L.apply_damage(rand(damage / 2, damage), BRUTE)

	L.visible_message("<span class='danger'>\The [L] had \the [src] fall onto \him!</span>",
		"<span class='danger'>You had \the [src] fall onto you and strike you!</span>")

	admin_attack_log((ismob(src) ? src : null), L, "fell onto", "was fallen on by", "fell ontop of")

	playsound(L.loc, "sound/waepons/genhit[rand(1, 3)].ogg", 75, 1)

	return L

/mob/fall_collateral(levels_fallen, stopped_early = FALSE)
	. = ..()

	if (.)
		to_chat(src, "<span class='danger'>You fell ontop of \the [.]!</span>")

/**
 * Helper proc for customizing which attributes should be used in fall damage
 * calculations. Allows for greater control over the damage. (Drop pods, anyone?)
 *
 * @param	levels_fallen How many Z-levels the atom has fallen before landing
 * on its current loc.
 *
 * @return	A two entity list: list(weight, fall_force)
 */
/atom/movable/proc/fall_get_specs(levels_fallen)
	return list(1, throw_range)

/obj/fall_get_specs(levels_fallen)
	return list(w_class, throwforce)

/mob/fall_get_specs(levels_fallen)
	return list(mob_size, throw_range)
