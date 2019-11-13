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

	if(istype(src.loc,/obj/mecha)||istype(src.loc,/obj/machinery/cryopod)||istype(src.loc,/obj/machinery/recharge_station))
		return FALSE

	// Check if we can actually travel a Z-level.
	if (!can_ztravel(direction))
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
	if(direction == UP && area.has_gravity() && !CanAvoidGravity())
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

/mob/living/zMove(direction)
	if (is_ventcrawling)
		var/obj/machinery/atmospherics/pipe/zpipe/P = loc
		if (istype(P) && P.can_z_crawl(src, direction))
			return P.handle_z_crawl(src, direction)

	return ..()

/mob/abstract/eye/zMove(direction)
	var/turf/destination = (direction == UP) ? GetAbove(src) : GetBelow(src)
	if(destination)
		setLoc(destination)
	else
		to_chat(owner, "<span class='notice'>There is nothing of interest in this direction.</span>")

/mob/abstract/observer/zMove(direction)
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
/mob/proc/can_ztravel(var/direction)
	return FALSE

/mob/abstract/observer/can_ztravel(var/direction)
	return TRUE

/mob/living/carbon/human/can_ztravel(var/direction)
	if(incapacitated())
		return FALSE

	if(Allow_Spacemove())
		return TRUE

	for(var/turf/simulated/T in RANGE_TURFS(1,src))
		if(T.density)
			if(Check_Shoegrip(FALSE))
				return TRUE

/mob/living/carbon/human/proc/climb(var/direction, var/turf/source, var/climb_bonus)
	var/turf/destination
	if(direction == UP)
		destination = GetAbove(source)
	else
		destination = GetBelow(source)

	if(!destination)
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		return

	if(destination.density)
		to_chat(src, "<span class='notice'>There is something obstructing your destination!</span>")
		return

	for(var/obj/O in destination)
		if(O.density)
			to_chat(src, "<span class='notice'>There is something obstructing your destination!</span>")
			return

	visible_message("<span class='notice'>The [src] begins to climb [(direction == UP) ? "upwards" : "downwards"].</span>",
		"<span class='notice'>You begin to climb [(direction == UP) ? "upwards" : "downwards"].</span>")
	var/climb_chance = 50
	var/climb_speed = 45 SECONDS
	var/will_succeed = FALSE
	var/turf/stack_turf = get_turf(src) //turf upon which obejcts must be stacked upon to gain vantage
	var/speed_bonus = 0
	if(direction == DOWN)
		stack_turf = destination

	if(species && !species.natural_climbing)
		for(var/obj/O in stack_turf)
			if(O.w_class >= 4.0 || O.anchored) //if an object is anchored it's stable footing
				climb_chance = min(100, climb_chance + O.w_class) //large items increase your reach
				speed_bonus = min(15, speed_bonus + 1)
			else
				climb_chance = max(0, climb_chance - O.w_class) //small items destabilize your footing
				speed_bonus = max(0, speed_bonus - 1)
		if(climb_bonus)
			climb_chance = min(100, climb_chance + climb_bonus)
	else
		climb_chance = 100

	if(species && species.climb_coeff)
		climb_speed = round(max(1, (species.climb_coeff * climb_speed) - speed_bonus), 1)

	if(prob(climb_chance))
		will_succeed = TRUE

	if(do_after(src, climb_speed, extra_checks  = CALLBACK(src, .proc/climb_check, will_succeed, climb_chance, climb_speed, direction, destination)))
		if(will_succeed)
			visible_message("<span class='noticed'>\The [src] climbs [(direction == UP) ? "upwards" : "downwards"].</span>",
				"<span class='noticed'>You climb [(direction == UP) ? "upwards" : "downwards"].</span>")
			forceMove(destination)
			return
		else
			visible_message("<span class='warning'>\The [src] slips and falls as they climb [(direction == UP) ? "upwards" : "downwards"]!</span>",
				"<span class='danger'>You slip and fall as you climb [(direction == UP) ? "upwards" : "downwards"]!</span>")
			if(direction == DOWN)
				Move(destination)
			fall_impact(1, damage_mod = min(1, max(0.2, ((100-climb_chance)/100) - 0.2)))

/mob/living/carbon/human/proc/climb_check(var/success, var/climb_chance, var/speed, var/direction, var/turf/destination) //purely for immersion and variety
	if((last_special < world.time) && !success) //if you will succeed you can't fail
		last_special = world.time + speed/10
		if(prob(100 - climb_chance)) //The worse you are the sooner you'll fail.
			visible_message("<span class='warning'>\The [src] slips and falls as they climb [(direction == UP) ? "upwards" : "downwards"]!</span>",
				"<span class='danger'>You slip and fall as you climb [(direction == UP) ? "upwards" : "downwards"]!</span>")
			if(direction == DOWN)
				Move(destination)
			fall_impact(1, damage_mod = min(1, max(0.2, ((100-climb_chance)/100) - 0.2)))
			return 0
	return 1

/mob/living/silicon/robot/can_ztravel(var/direction)
	if(incapacitated() || is_dead())
		return FALSE

	if(Allow_Spacemove()) //Checks for active jetpack
		return TRUE

	for(var/turf/simulated/T in RANGE_TURFS(1,src)) //Robots get "magboots"
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
		var/obj/item/tank/jetpack/thrust = GetJetpack(src)

		if (thrust && !lying && thrust.allow_thrust(0.01, src))
			return TRUE

	return ..()

/mob/living/silicon/robot/CanAvoidGravity()
	var/obj/item/tank/jetpack/thrust = GetJetpack(src)

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
 * @param	dest The tile we're presuming the mob to be at for this check. Default
 * value is src.loc, (src. is important there!) but this is used for magboot lookahead
 * checks it turf/simulated/open/Enter().
 *
 * @return	TRUE if the atom can continue falling in its present situation.
 *			FALSE if it should stop falling and not invoke fall_through or fall_impact
 * this cycle.
 */
/atom/movable/proc/can_fall(turf/below, turf/simulated/open/dest = src.loc)
	if (!istype(dest) || !dest.is_hole)
		return FALSE

	// Anchored things don't fall.
	if(anchored)
		return FALSE

	// Lattices, ladders, and stairs stop things from falling.
	if(locate(/obj/structure/lattice, dest) || locate(/obj/structure/stairs, dest))
		return FALSE

	if(ismob(src) && locate(/obj/structure/ladder, dest)) //hmmm how is this locker just floating here?
		return FALSE

	// The var/climbers API is implemented here.
	if (LAZYLEN(dest.climbers) && (src in dest.climbers))
		return FALSE

	// See if something prevents us from falling.
	for (var/atom/A in below)
		if(!A.CanPass(src, dest))
			return FALSE

	// True otherwise.
	return TRUE

/obj/effect/can_fall()
	return FALSE

/obj/effect/decal/cleanable/can_fall()
	return TRUE

/obj/item/pipe/can_fall(turf/below, turf/simulated/open/dest = src.loc)
	. = ..()

	if((locate(/obj/structure/disposalpipe/up) in below) || locate(/obj/machinery/atmospherics/pipe/zpipe/up in below))
		return FALSE

// Only things that stop mechas are atoms that, well, stop them.
// Lattices and stairs get crushed in fall_through.
/obj/mecha/can_fall(turf/below, turf/simulated/open/dest = src.loc)
	// The var/climbers API is implemented here.
	if (LAZYLEN(dest.climbers) && (src in dest.climbers))
		return FALSE

	if (!dest.is_hole)
		return FALSE

	// See if something prevents us from falling.
	for(var/atom/A in below)
		if(!A.CanPass(src, dest))
			return FALSE

	// True otherwise.
	return TRUE

/mob/living/carbon/human/can_fall(turf/below, turf/simulated/open/dest = src.loc)
	// Special condition for jetpack mounted folk!
	if (!restrained())
		var/obj/item/tank/jetpack/thrust = GetJetpack(src)

		if (thrust && thrust.stabilization_on &&\
			!lying && thrust.allow_thrust(0.01, src))
			return FALSE

	return ..()

/mob/living/carbon/human/bst/can_fall()
	return fall_override ? FALSE : ..()

/mob/abstract/eye/can_fall()
	return FALSE

/mob/living/silicon/robot/can_fall(turf/below, turf/simulated/open/dest = src.loc)
	var/obj/item/tank/jetpack/thrust = GetJetpack(src)

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
/atom/movable/proc/fall_impact(levels_fallen, stopped_early = FALSE, var/damage_mod = 1)
	// No gravity, stop falling into spess!
	var/area/area = get_area(src)
	if (istype(loc, /turf/space) || (area && !area.has_gravity()))
		return FALSE

	visible_message("\The [src] falls and lands on \the [loc]!", "You hear a thud!")

	return TRUE

// Mobs take damage if they fall!
/mob/living/fall_impact(levels_fallen, stopped_early = FALSE, var/damage_mod = 1)
	// No gravity, stop falling into spess!
	var/area/area = get_area(src)
	if (istype(loc, /turf/space) || (area && !area.has_gravity()))
		return FALSE

	visible_message("\The [src] falls and lands on \the [loc]!",
		"With a loud thud, you land on \the [loc]!", "You hear a thud!")

	var/z_velocity = 5*(levels_fallen**2)
	var/damage = ((60 + z_velocity) + rand(-20,20)) * damage_mod

	apply_damage(damage, BRUTE)

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

/mob/living/carbon/human/fall_impact(levels_fallen, stopped_early = FALSE, var/damage_mod = 1)
	// No gravity, stop falling into spess!
	var/area/area = get_area(src)
	if (istype(loc, /turf/space) || (area && !area.has_gravity()))
		return FALSE

	var/obj/item/rig/rig = get_rig()
	if (istype(rig))
		for (var/obj/item/rig_module/actuators/A in rig.installed_modules)
			if (A.active && rig.check_power_cost(src, 10, A, 0))
				visible_message("<span class='notice'>\The [src] lands flawlessly with \his [rig].</span>",
					"<span class='notice'>You hear an electric <i>*whirr*</i> right after the slam!</span>")
				return FALSE

	var/combat_roll = 1
	if(lying)
		combat_roll = 0.7 //If you're sleeping, you take less damage because your body is less rigid. It's science 'n shit.
		if(!sleeping)
			combat_roll = 0.2 //Combat roll!
			visible_message("<span class='notice'>\The [src] tucks into a roll as they hit \the [loc]!</span>",
				"<span class='notice'>You tuck into a roll as you hit \the [loc], minimizing damage!</span>")

	var/z_velocity = 5*(levels_fallen**2)
	var/damage = (((40 * species.fall_mod) + z_velocity) + rand(-20,20)) * combat_roll * damage_mod

	var/limb_damage = rand(0,damage/2)

	if(prob(30) && combat_roll >= 1) //landed on their legs
		var/left_damage = rand(0,damage/2)
		var/right_damage = rand(0,damage/2)
		var/leftf_damage = rand(0,damage/4)
		var/rightf_damage = rand(0,damage/4)
		var/groin_damage = rand(0,damage/4)


		apply_damage(left_damage, BRUTE, "l_leg")
		apply_damage(right_damage, BRUTE, "r_leg")

		if(prob(50))
			apply_damage(leftf_damage, BRUTE, "r_foot")
		if(prob(50))
			apply_damage(leftf_damage, BRUTE, "l_foot")
		if(prob(50))
			apply_damage(groin_damage, BRUTE, "groin")

		visible_message("<span class='warning'>\The [src] falls and lands directly on their legs!</span>",
			"<span class='danger'>You land on your feet, and the impact brings you to your knees.</span>")

		limb_damage = left_damage + right_damage + leftf_damage + rightf_damage + groin_damage

	else if(prob(30) && combat_roll >= 1) //landed on their arms
		var/left_damage = rand(0,damage/4)
		var/right_damage = rand(0,damage/4)
		var/lefth_damage = rand(0,damage/4)
		var/righth_damage = rand(0,damage/4)

		apply_damage(left_damage, BRUTE, "l_arm")
		apply_damage(right_damage, BRUTE, "r_arm")

		if(prob(50))
			apply_damage(lefth_damage, BRUTE, "r_hand")
		if(prob(50))
			apply_damage(righth_damage, BRUTE, "l_hand")

		limb_damage = left_damage + right_damage + lefth_damage + righth_damage

		visible_message("<span class='warning'>\The [src] falls and lands arms first!</span>",
			"<span class='danger'>You brace your fall with your arms, hitting \the [loc] with a loud thud.</span>", "You hear a thud!")

	else if(prob(30) && combat_roll >= 1)//landed on their head
		apply_damage(limb_damage, BRUTE, "head")
		visible_message("<span class='warning'>\The [src] falls and lands on their face!</span>",
			"<span class='danger'>With a loud thud, you land on your head. Hard.</span>", "You hear a thud!")

	else
		limb_damage = 0
		if(combat_roll >= 0.5)
			visible_message("\The [src] falls and lands on \the [loc]!",
				"With a loud thud, you land on \the [loc]!", "You hear a thud!")

	if(!limb_damage)
		apply_damage(damage, BRUTE, "chest")

	Weaken(rand(damage/4, damage/2))

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

	// Stats.
	SSfeedback.IncrementSimpleStat("openturf_human_falls")
	addtimer(CALLBACK(src, .proc/post_fall_death_check), 2 MINUTES, TIMER_UNIQUE | TIMER_OVERRIDE)

	return TRUE

/mob/living/carbon/human/proc/post_fall_death_check()
	if (stat == DEAD)
		SSfeedback.IncrementSimpleStat("openturf_human_deaths")

/mob/living/carbon/human/bst/fall_impact()
	return FALSE

/obj/mecha/fall_impact(levels_fallen, stopped_early = FALSE, var/damage_mod = 1)
	. = ..()
	if (!.)
		return

	var/z_velocity = 5*(levels_fallen**2)
	var/damage = ((60 + z_velocity) + rand(-20,20)) * damage_mod

	take_damage(damage)

	playsound(loc, "sound/effects/bang.ogg", 100, 1)
	playsound(loc, "sound/effects/bamf.ogg", 100, 1)

/obj/vehicle/fall_impact(levels_fallen, stopped_early = FALSE, var/damage_mod = 1)
	. = ..()
	if (!.)
		return

	var/z_velocity = 5*(levels_fallen**2)
	var/damage = ((60 + z_velocity) + rand(-20,20)) * damage_mod
	if(istype(loc, /turf/unsimulated/floor/asteroid))
		damage /= 2

	health -= (damage * brute_dam_coeff)

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
	if (istype(loc, /turf/space) || (area && !area.has_gravity()))
		return null

	var/list/fall_specs = fall_get_specs(levels_fallen)
	var/weight = fall_specs[1]
	var/fall_force = fall_specs[2]

	if(weight >= 3 && fall_force <= 5) //Necessary because some big large obj's do not have a defined throw_force (mechs, lockers, pianos, etc)
		fall_force = throw_range

	var/speed = ((levels_fallen-1) + throw_speed) / THROWFORCE_SPEED_DIVISOR
	var/mass = weight + density + opacity //1
	var/momentum = speed * mass //8
	if(weight <= 10) //Keeps damages sane.
		momentum = momentum / THROWNOBJ_KNOCKBACK_DIVISOR
	var/damage = round(fall_force * momentum) //64

	var/miss_chance = max(10 * (levels_fallen), 0)

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
		var/cranial_damage = rand(0,damage/2)
		H.apply_damage(cranial_damage, BRUTE, "head")
		H.apply_damage((damage - cranial_damage), BRUTE, "chest")

		if (damage >= THROWNOBJ_KNOCKBACK_DIVISOR)
			H.Weaken(rand(damage / 4, damage / 2))
	else
		L.apply_damage(damage, BRUTE)

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
