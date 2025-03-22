/mob/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0))
		return TRUE

	if(mover?.movement_type & PHASING)
		return TRUE

	if(ismob(mover))
		var/mob/moving_mob = mover
		if(moving_mob.pulledby == src)
			return TRUE
		if(length(moving_mob.grabbed_by))
			for(var/obj/item/grab/G in moving_mob.grabbed_by)
				if(G.assailant == src)
					return TRUE
		return (!mover.density || !density || lying)
	else
		return (!mover.density || !density || lying)

/mob/proc/setMoveCooldown(var/timeout)
	if(client)
		client.move_delay = max(world.time + timeout, client.move_delay)

/client/North()
	..()


/client/South()
	..()


/client/West()
	..()


/client/East()
	..()


/client/proc/client_dir(input, direction=-1)
	return turn(input, direction*dir2angle(dir))

/client/Northeast()
	diagonal_action(NORTHEAST)
/client/Northwest()
	diagonal_action(NORTHWEST)
/client/Southeast()
	diagonal_action(SOUTHEAST)
/client/Southwest()
	diagonal_action(SOUTHWEST)

/client/proc/diagonal_action(direction)
	switch(client_dir(direction, 1))
		if(NORTHEAST)
			swap_hand()
			return
		if(SOUTHEAST)
			attack_self()
			return
		if(SOUTHWEST)
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				C.toggle_throw_mode()
			else
				to_chat(usr, SPAN_WARNING("This mob type cannot throw items."))
			return
		if(NORTHWEST)
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				if(!C.get_active_hand())
					to_chat(usr, SPAN_WARNING("You have nothing to drop in your hand."))
					return
				drop_item()
			else if(isrobot(usr))
				var/mob/living/silicon/robot/R = usr
				var/I = R.get_active_hand()
				if(istype(I, /obj/item/gripper))
					var/obj/item/gripper/G = I
					G.drop_item()
			else
				to_chat(usr, SPAN_WARNING("This mob type cannot drop items."))
			return

//This gets called when you press the delete button.
/client/verb/delete_key_pressed()
	set hidden = 1

	if(!usr.pulling)
		to_chat(usr, SPAN_NOTICE("You are not pulling anything."))
		return
	usr.stop_pulling()

/client/verb/swap_hand()
	set hidden = 1
	if(istype(mob, /mob/living/carbon))
		var/mob/living/carbon/C = mob
		C.swap_hand()
	if(istype(mob,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = mob
		R.cycle_modules()
	return



/client/verb/attack_self()
	set hidden = 1
	if(mob)
		mob.mode()
	return


/client/verb/toggle_throw_mode()
	set hidden = 1
	if(!istype(mob, /mob/living/carbon))
		return

	var/mob/living/carbon/C = mob

	if (!C.stat && isturf(C.loc) && !C.restrained())
		C.toggle_throw_mode()
	else
		return


/client/verb/drop_item()
	set hidden = 1
	if(!isrobot(mob) && mob.stat == CONSCIOUS && isturf(mob.loc))
		return mob.drop_item()
	return


/client/Center()
	/* No 3D movement in 2D spessman game. dir 16 is Z Up
	if (isobj(mob.loc))
		var/obj/O = mob.loc
		if (mob.canmove)
			return O.relaymove(mob, 16)
	*/
	return

/client/proc/Move_object(direct)
	if(mob && mob.control_object)
		if(mob.control_object.density)
			step(mob.control_object,direct)
			if(!mob.control_object)	return
			mob.control_object.dir = direct
		else
			mob.control_object.forceMove(get_step(mob.control_object,direct))
	return


/**
 * Move a client in a direction
 *
 * This is called when a client tries to move, usually it dispatches the moving request to the mob it's controlling
 */
/client/Move(new_loc, direct)
	if(world.time < move_delay) //do not move anything ahead of this check please
		return FALSE

	var/old_move_delay = move_delay

	if(!direct || !new_loc)
		return FALSE
	if(!mob?.loc)
		return FALSE

	if(mob.control_object)
		Move_object(direct)

	if(mob.incorporeal_move && isabstractmob(mob))
		Process_Incorpmove(direct, mob)
		return

	if(moving || world.time < move_delay)
		return 0

	if(mob.stat == DEAD && isliving(mob))
		mob.ghostize()
		return

	// handle possible Eye movement
	if(mob.eyeobj)
		return mob.EyeMove(new_loc,direct)

	if(mob.transforming)
		return	//This is sota the goto stop mobs from moving var

	var/add_delay = mob.cached_multiplicative_slowdown

	if(isliving(mob))
		if(SEND_SIGNAL(mob, COMSIG_MOB_CLIENT_PRE_LIVING_MOVE, new_loc, direct) & COMSIG_MOB_CLIENT_BLOCK_PRE_LIVING_MOVE)
			return FALSE

		var/mob/living/L = mob
		if(L.incorporeal_move && isturf(mob.loc))//Move though walls
			Process_Incorpmove(direct, mob)
			return
		if(mob.client && ((mob.client.view != world.view) || (mob.client.pixel_x != 0) || (mob.client.pixel_y != 0)))		// If mob moves while zoomed in with device, unzoom them.
			for(var/obj/item/item in mob)
				if(item.zoom)
					item.zoom(mob)
					break
		if(istype(mob.machine,/obj/machinery/computer/security))
			// Has to be here specfically to allow WASD/arrow movement of cameras while buckled.
			// TODO: Remove when machinery/computer finally dies.
			var/obj/machinery/computer/security/console = mob.machine
			if(console.current_camera)
				var/turf/T = get_turf(console.current_camera)
				for(var/i;i<10;i++)
					T = get_step(T,direct)
				console.jump_on_click(mob,T)
				return

		if(length(mob.grabbed_by))
			var/turf/target_turf = get_step(mob, direct)
			for(var/obj/item/grab/G in mob.grabbed_by)
				// can't move, try resisting and stop movement
				if(G.state > GRAB_PASSIVE || get_dist(G.assailant, target_turf) > 1)
					L.resist()
					return

		for(var/obj/item/grab/G in list(mob.l_hand, mob.r_hand))
			G.reset_kill_state() //no wandering across the station/asteroid while choking someone

	if(!mob.canmove || mob.paralysis)
		return

	if(!mob.lastarea)
		mob.lastarea = get_area(mob.loc)

	if(isobj(mob.loc) || ismob(mob.loc))	//Inside an object, tell it we are moving out
		var/atom/O = mob.loc
		return O.relaymove(mob, direct)

	if(isturf(mob.loc))
		if(!mob.check_solid_ground())
			var/allowmove = mob.Allow_Spacemove(0)
			if(!allowmove)
				return 0
			else if(allowmove == -1 && mob.handle_spaceslipping()) //Check to see if we slipped
				return 0
			else
				mob.inertia_dir = 0 //If not then we can reset inertia and move


		if(mob.restrained())		//Why being pulled while cuffed prevents you from moving
			var/mob/puller = mob.pulledby
			if(puller)
				if(!puller.restrained() && puller.stat == 0 && puller.canmove && mob.Adjacent(puller))
					to_chat(src, SPAN_NOTICE("You're restrained! You can't move!"))
					return FALSE
				else
					puller.stop_pulling()

		if(length(mob.pinned))
			to_chat(src, SPAN_WARNING("You're pinned to a wall by [mob.pinned[1]]!"))
			move_delay = world.time + 1 SECOND // prevent spam
			return FALSE

		//If the move was recent, count using old_move_delay
		//We want fractional behavior and all
		if(old_move_delay + world.tick_lag > world.time)
			//Yes this makes smooth movement stutter if add_delay is too fractional
			//Yes this is better then the alternative
			move_delay = old_move_delay
		else
			move_delay = world.time

		if(mob.buckled_to)
			if(istype(mob.buckled_to, /obj/vehicle))
				//manually set move_delay for vehicles so we don't inherit any mob movement penalties
				//specific vehicle move delays are set in code\modules\vehicles\vehicle.dm
				move_delay = (old_move_delay + world.tick_lag > world.time) ? old_move_delay : world.time
				//drunk driving
				if(mob.confused && prob(25))
					direct = pick(GLOB.cardinals)
				return mob.buckled_to.relaymove(mob,direct)

			//TODO: Fuck wheelchairs.
			//Toss away all this snowflake code here, and rewrite wheelchairs as a vehicle.
			else if(istype(mob.buckled_to, /obj/structure/bed/stool/chair/office/wheelchair))
				var/min_move_delay = 0
				if(ishuman(mob.buckled_to))
					var/mob/living/carbon/human/driver = mob.buckled_to
					var/obj/item/organ/external/l_hand = driver.get_organ(BP_L_HAND)
					var/obj/item/organ/external/r_hand = driver.get_organ(BP_R_HAND)
					if((!l_hand || l_hand.is_stump()) && (!r_hand || r_hand.is_stump()))
						return // No hands to drive your chair? Tough luck!
					min_move_delay = driver.min_walk_delay
				//drunk wheelchair driving
				if(mob.confused && prob(25))
					direct = pick(GLOB.cardinals)
				move_delay += max((mob.movement_delay() + GLOB.config.walk_speed) * GLOB.config.walk_delay_multiplier, min_move_delay)
				return mob.buckled_to.relaymove(mob,direct)

		var/tally = mob.movement_delay() + GLOB.config.walk_speed

		// Apply human specific modifiers.
		var/mob_is_human = ishuman(mob)	// Only check this once and just reuse the value.
		var/sprint_tally = 0
		if (mob_is_human)
			var/mob/living/carbon/human/H = mob
			//If we're sprinting and able to continue sprinting, then apply the sprint bonus ontop of this
			if (H.m_intent == M_RUN && (H.status_flags & GODMODE || H.species.handle_sprint_cost(H, tally, TRUE))) //This will return false if we collapse from exhaustion
				sprint_tally = tally
				tally = (tally / (1 + H.sprint_speed_factor)) * GLOB.config.run_delay_multiplier
			else if (H.m_intent == M_LAY && (H.status_flags & GODMODE || H.species.handle_sprint_cost(H, tally, TRUE)))
				tally = (tally / (1 + H.lying_speed_factor)) * GLOB.config.lying_delay_multiplier
			else
				tally = max(tally * GLOB.config.walk_delay_multiplier, H.min_walk_delay) //clamp walking speed if its limited
		else
			tally *= GLOB.config.walk_delay_multiplier

		move_delay += tally
		move_delay += add_delay

		if(mob_is_human && mob.lying)
			var/mob/living/carbon/human/H = mob
			var/crawl_tally = H.get_crawl_tally()
			if(crawl_tally >= 120)
				return FALSE

		if(istype(mob.machine, /obj/machinery))
			if(mob.machine.relaymove(mob,direct))
				return

		//Wheelchair pushing goes here for now.
		//TODO: Fuck wheelchairs.
		if(istype(mob.pulledby, /obj/structure/bed/stool/chair/office/wheelchair) || istype(mob.pulledby, /obj/structure/janitorialcart))
			var/obj/structure/S = mob.pulledby
			move_delay += S.slowdown
			return mob.pulledby.relaymove(mob, direct)

		var/old_loc = mob.loc

		//We are now going to move
		moving = 1
		if(mob_is_human)
			for(var/obj/item/grab/G in list(mob.l_hand, mob.r_hand))
				switch(G.get_grab_type())
					if(MOB_GRAB_FIREMAN)
						move_delay++
					if(MOB_GRAB_NORMAL)
						move_delay = max(move_delay, world.time + 7)
						step(G.affecting, get_dir(G.affecting.loc, mob.loc))

		if(mob.confused && prob(25) && mob.m_intent == M_RUN)
			step(mob, pick(GLOB.cardinals))
		else
			. = mob.SelfMove(new_loc, direct)

		for (var/obj/item/grab/G in list(mob.l_hand, mob.r_hand))
			if (G.state == GRAB_NECK)
				mob.set_dir(REVERSE_DIR(direct))
			G.adjust_position()

		for (var/obj/item/grab/G in mob.grabbed_by)
			G.adjust_position()

		moving = 0

		if(sprint_tally && mob.loc != old_loc)
			var/mob/living/carbon/human/H = mob
			H.species.handle_sprint_cost(H, sprint_tally, FALSE)

/mob/living/carbon/human/proc/get_crawl_tally()
	var/obj/item/organ/external/rhand = organs_by_name[BP_R_HAND]
	. += limb_check(rhand)

	var/obj/item/organ/external/lhand = organs_by_name[BP_L_HAND]
	. += limb_check(lhand)

	var/obj/item/organ/external/rfoot = organs_by_name[BP_R_FOOT]
	. += limb_check(rfoot)

	var/obj/item/organ/external/lfoot = organs_by_name[BP_L_FOOT]
	. += limb_check(lfoot)

// Checks status of limb, returns an amount to
/mob/living/carbon/human/proc/limb_check(var/obj/item/organ/external/limb)
	if(!limb) // Limb is null, thus missing.
		return 30
	else if(!limb.is_usable() || limb.is_broken()) // You can't use the limb, but it's still there to maneuvre yourself
		return 15
	else
		return 0


/mob/proc/SelfMove(turf/n, direct)
	return Move(n, direct)

///Process_Incorpmove
///Called by client/Move()
///Allows mobs to run though walls
/client/proc/Process_Incorpmove(direct, var/mob/use_mob)
	if(!use_mob)
		use_mob = mob
	var/turf/mobloc = get_turf(use_mob)
	switch(use_mob.incorporeal_move)
		if(INCORPOREAL_GHOST)
			var/turf/T = get_step(use_mob, direct)
			if(use_mob.check_holy(T))
				to_chat(src, SPAN_WARNING("You cannot get past holy grounds while you are in this plane of existence!"))
				return
			else
				use_mob.forceMove(get_step(use_mob, direct))
				use_mob.dir = direct
		if(INCORPOREAL_NINJA, INCORPOREAL_BSTECH)
			anim(mobloc, use_mob, 'icons/mob/mob.dmi', null, "shadow", null, use_mob.dir)
			use_mob.forceMove(get_step(use_mob, direct))
			use_mob.dir = direct
		if(INCORPOREAL_MECH)
			new /obj/effect/temp_visual/incorporeal_mech(mobloc, use_mob.dir, use_mob)
			use_mob.forceMove(get_step(use_mob, direct))
		if(INCORPOREAL_SHADE)
			if(!use_mob.canmove || use_mob.anchored)
				return
			move_delay = 1 + world.time
			var/turf/T = get_step(use_mob, direct)
			for(var/obj/structure/window/W in T)
				if(istype(W, /obj/structure/window/borosilicate) || istype(W, /obj/structure/window/borosilicate/reinforced))
					if(W.is_full_window())
						to_chat(src, SPAN_WARNING("\The [W] obstructs your movement!"))
						return

					if((direct & W.dir) && W.density)
						to_chat(src, SPAN_WARNING("\The [W] obstructs your movement!"))
						return
			if(istype(T, /turf/simulated/wall/phoron) || istype(T, /turf/simulated/wall/ironphoron))
				to_chat(src, SPAN_WARNING("\The [T] obstructs your movement!"))
				return

			for(var/mob/living/L in T)
				if(L.is_diona() == DIONA_WORKER)
					to_chat(src, SPAN_DANGER("You struggle briefly as you are photovored into \the [L], trapped within a nymphomatic husk!"))
					var/mob/living/carbon/alien/diona/D = new /mob/living/carbon/alien/diona(L)
					var/mob/living/simple_animal/shade/bluespace/BS = use_mob
					if (!(/mob/living/carbon/proc/echo_eject in L.verbs))
						L.verbs.Add(/mob/living/carbon/proc/echo_eject)
					BS.mind.transfer_to(D)
					D.echo = 1
					D.set_stat(CONSCIOUS)
					D.gestalt = L
					D.sync_languages(D.gestalt)
					D.update_verbs()
					D.forceMove(L)
					qdel(BS)
					return

			use_mob.forceMove(get_step(use_mob, direct))
			use_mob.dir = direct

	// Crossed is always a bit iffy
	for(var/obj/S in use_mob.loc)
		if(istype(S,/obj/effect/step_trigger) || istype(S,/obj/effect/beam))
			S.Crossed(use_mob)

	var/area/A = get_area_master(use_mob)
	if(A)
		A.Entered(use_mob)
	if(isturf(use_mob.loc))
		var/turf/T = use_mob.loc
		T.Entered(use_mob)
	use_mob.Post_Incorpmove()
	return 1

/mob/proc/Post_Incorpmove()
	return

// Checks whether this mob is allowed to move in space
// Return 1 for movement, 0 for none,
// -1 to allow movement but with a chance of slipping
/mob/proc/Allow_Spacemove(var/check_drift = 0)
	if(status_flags & NOFALL || incorporeal_move == INCORPOREAL_BSTECH)
		return 1

	if(!Check_Dense_Object()) //Nothing to push off of so end here
		return 0

	if(restrained()) //Check to see if we can do things
		return 0

	return -1

//Checks if a mob has solid ground to stand on
//If there's no gravity then there's no up or down so naturally you can't stand on anything, unless you have grip.
//For the same reason lattices in space don't count - those are things you grip, presumably.
/mob/proc/check_solid_ground()
	var/turf/T = get_turf(src)

	if (!T) // nullspace so sure, have gravity.
		return TRUE
	else if(T.is_hole)
		return FALSE

	var/area/A = T.loc
	if (!A.has_gravity() && !Check_Shoegrip())
		return FALSE

	return TRUE


/mob/proc/Check_Dense_Object() //checks for anything to push off in the vicinity. also handles magboots on gravity-less floors tiles
	var/shoegrip = Check_Shoegrip()

	for(var/turf/simulated/T in RANGE_TURFS(1,src)) //we only care for non-space turfs
		if(T.density)	//walls work
			return TRUE
		else
			var/area/A = T.loc
			if(A.has_gravity() || shoegrip)
				return TRUE

	for(var/obj/O in orange(1, src))
		if(istype(O, /obj/structure/lattice))
			return TRUE
		if(istype(O, /obj/structure/ladder))
			return TRUE
		if(O && O.density && O.anchored)
			return TRUE

	return FALSE

/mob/proc/Check_Shoegrip()
	return 0

/mob/proc/slip_chance(var/prob_slip = 5)
	if(stat)
		return 0
	if(Check_Shoegrip())
		return 0
	return prob_slip

//return 1 if slipped, 0 otherwise
/mob/proc/handle_spaceslipping()
	if(prob(slip_chance(5)) && !buckled_to)
		to_chat(src, SPAN_WARNING("You slipped!"))
		src.inertia_dir = src.last_move
		step(src, src.inertia_dir)
		return 1
	return 0

// /tg/ movement procs

//The byond version of these verbs wait for the next tick before acting.
//	instant verbs however can run mid tick or even during the time between ticks.
/client/verb/moveup()
	set name = ".moveup"
	set instant = 1
	Move(get_step(mob, NORTH), NORTH)

/client/verb/movedown()
	set name = ".movedown"
	set instant = 1
	Move(get_step(mob, SOUTH), SOUTH)

/client/verb/moveright()
	set name = ".moveright"
	set instant = 1
	Move(get_step(mob, EAST), EAST)

/client/verb/moveleft()
	set name = ".moveleft"
	set instant = 1
	Move(get_step(mob, WEST), WEST)

/mob/proc/update_gravity()
	return

/mob/proc/mob_has_gravity(turf/T)
	return has_gravity(src, T)

/mob/proc/mob_negates_gravity()
	return 0
