/mob/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1

	if(ismob(mover))
		var/mob/moving_mob = mover
		if ((other_mobs && moving_mob.other_mobs))
			return 1
		return (!mover.density || !density || lying)
	else
		return (!mover.density || !density || lying)
	return

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
				to_chat(usr, "<span class='warning'>This mob type cannot throw items.</span>")
			return
		if(NORTHWEST)
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				if(!C.get_active_hand())
					to_chat(usr, "<span class='warning'>You have nothing to drop in your hand.</span>")
					return
				drop_item()
			else
				to_chat(usr, "<span class='warning'>This mob type cannot drop items.</span>")
			return

//This gets called when you press the delete button.
/client/verb/delete_key_pressed()
	set hidden = 1

	if(!usr.pulling)
		to_chat(usr, "<span class='notice'>You are not pulling anything.</span>")
		return
	usr.stop_pulling()

/client/verb/swap_hand()
	set hidden = 1
	if(istype(mob, /mob/living/carbon))
		mob:swap_hand()
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
	if (!mob.stat && isturf(mob.loc) && !mob.restrained())
		mob:toggle_throw_mode()
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

//This proc should never be overridden elsewhere at /atom/movable to keep directions sane.
/atom/movable/Move(newloc, direct)
	if (direct & (direct - 1))
		if (direct & 1)
			if (direct & 4)
				if (step(src, NORTH))
					step(src, EAST)
				else
					if (step(src, EAST))
						step(src, NORTH)
			else
				if (direct & 8)
					if (step(src, NORTH))
						step(src, WEST)
					else
						if (step(src, WEST))
							step(src, NORTH)
		else
			if (direct & 2)
				if (direct & 4)
					if (step(src, SOUTH))
						step(src, EAST)
					else
						if (step(src, EAST))
							step(src, SOUTH)
				else
					if (direct & 8)
						if (step(src, SOUTH))
							step(src, WEST)
						else
							if (step(src, WEST))
								step(src, SOUTH)
	else
		var/atom/A = src.loc

		var/olddir = dir //we can't override this without sacrificing the rest of movable/New()
		. = ..()
		if(direct != olddir)
			dir = olddir
			set_dir(direct)

		src.move_speed = world.time - src.l_move_time
		src.l_move_time = world.time
		if ((A != src.loc && A && A.z == src.z))
			src.last_move = get_dir(A, src.loc)

/client/proc/Move_object(direct)
	if(mob && mob.control_object)
		if(mob.control_object.density)
			step(mob.control_object,direct)
			if(!mob.control_object)	return
			mob.control_object.dir = direct
		else
			mob.control_object.forceMove(get_step(mob.control_object,direct))
	return


/client/Move(n, direct)
	if(!mob)
		return // Moved here to avoid nullrefs below

	if(mob.control_object)
		Move_object(direct)

	if(mob.incorporeal_move && isobserver(mob))
		Process_Incorpmove(direct)
		return

	if(moving || world.time < move_delay)
		return 0

	//This compensates for the inaccuracy of move ticks
	//Whenever world.time overshoots the movedelay, due to it only ticking once per decisecond
	//The overshoot value is subtracted from our next delay, farther down where move delay is set.
	//This doesn't entirely remove the problem, but it keeps travel times accurate to within 0.1 seconds
	//Over an infinite distance, and prevents the inaccuracy from compounding. Thus making it basically a non-issue
	var/leftover = world.time - move_delay
	if (leftover > 1)
		leftover = 0

	if(mob.stat == DEAD && isliving(mob))
		mob.ghostize()
		return

	// handle possible Eye movement
	if(mob.eyeobj)
		return mob.EyeMove(n,direct)

	if(mob.transforming)
		return	//This is sota the goto stop mobs from moving var

	if(isliving(mob))
		var/mob/living/L = mob
		if(L.incorporeal_move)//Move though walls
			Process_Incorpmove(direct)
			return
		if(mob.client && ((mob.client.view != world.view) || (mob.client.pixel_x != 0) || (mob.client.pixel_y != 0)))		// If mob moves while zoomed in with device, unzoom them.
			for(var/obj/item/item in mob)
				if(item.zoom)
					item.zoom(mob)
					break

		// Only meaningful for living mobs.
		if(Process_Grab())
			return

	if(!mob.canmove)
		return

	//if(istype(mob.loc, /turf/space) || (mob.flags & NOGRAV))
	//	if(!mob.Process_Spacemove(0))	return 0

	if(!mob.lastarea)
		mob.lastarea = get_area(mob.loc)

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
			for(var/mob/M in range(mob, 1))
				if(M.pulling == mob)
					if(!M.restrained() && M.stat == 0 && M.canmove && mob.Adjacent(M))
						to_chat(src, "<span class='notice'>You're restrained! You can't move!</span>")
						return 0
					else
						M.stop_pulling()

		if(mob.pinned.len)
			to_chat(src, "<span class='notice'>You're pinned to a wall by [mob.pinned[1]]!</span>")
			return 0

		move_delay = world.time - leftover//set move delay

		if (mob.buckled)
			if(istype(mob.buckled, /obj/vehicle))
				//manually set move_delay for vehicles so we don't inherit any mob movement penalties
				//specific vehicle move delays are set in code\modules\vehicles\vehicle.dm
				move_delay = world.time
				//drunk driving
				if(mob.confused && prob(25))
					direct = pick(cardinal)
				return mob.buckled.relaymove(mob,direct)

			//TODO: Fuck wheelchairs.
			//Toss away all this snowflake code here, and rewrite wheelchairs as a vehicle.
			else if(istype(mob.buckled, /obj/structure/bed/chair/wheelchair))
				var/min_move_delay = 0
				if(ishuman(mob.buckled))
					var/mob/living/carbon/human/driver = mob.buckled
					var/obj/item/organ/external/l_hand = driver.get_organ(BP_L_HAND)
					var/obj/item/organ/external/r_hand = driver.get_organ(BP_R_HAND)
					if((!l_hand || l_hand.is_stump()) && (!r_hand || r_hand.is_stump()))
						return // No hands to drive your chair? Tough luck!
					min_move_delay = driver.min_walk_delay
				//drunk wheelchair driving
				if(mob.confused && prob(25))
					direct = pick(cardinal)
				move_delay += max((mob.movement_delay() + config.walk_speed) * config.walk_delay_multiplier, min_move_delay)
				return mob.buckled.relaymove(mob,direct)

		var/tally = mob.movement_delay() + config.walk_speed

		// Apply human specific modifiers.
		var/mob_is_human = ishuman(mob)	// Only check this once and just reuse the value.
		if (mob_is_human)
			var/mob/living/carbon/human/H = mob
			//If we're sprinting and able to continue sprinting, then apply the sprint bonus ontop of this
			if (H.m_intent == "run" && H.species.handle_sprint_cost(H, tally)) //This will return false if we collapse from exhaustion
				tally = (tally / (1 + H.sprint_speed_factor)) * config.run_delay_multiplier
			else
				tally = max(tally * config.walk_delay_multiplier, H.min_walk_delay) //clamp walking speed if its limited
		else
			tally *= config.walk_delay_multiplier

		move_delay += tally

		var/tickcomp = 0 //moved this out here so we can use it for vehicles
		if(config.Tickcomp)
			// move_delay -= 1.3 //~added to the tickcomp calculation below
			tickcomp = ((1/(world.tick_lag))*1.3) - 1.3
			move_delay = move_delay + tickcomp

		if(istype(mob.machine, /obj/machinery))
			if(mob.machine.relaymove(mob,direct))
				return

		//Wheelchair pushing goes here for now.
		//TODO: Fuck wheelchairs.
		if(istype(mob.pulledby, /obj/structure/bed/chair/wheelchair) || istype(mob.pulledby, /obj/structure/janitorialcart))
			move_delay += 1
			return mob.pulledby.relaymove(mob, direct)

		//We are now going to move
		moving = 1
		//Something with pulling things
		if (mob_is_human && (istype(mob:l_hand, /obj/item/grab) || istype(mob:r_hand, /obj/item/grab)))
			move_delay = max(move_delay, world.time + 7)
			var/list/L = mob.ret_grab()
			if(istype(L, /list))
				if(L.len == 2)
					L -= mob
					var/mob/M = L[1]
					if(M)
						if ((get_dist(mob, M) <= 1 || M.loc == mob.loc))
							var/turf/T = mob.loc
							. = ..()
							if (isturf(M.loc))
								var/diag = get_dir(mob, M)
								if ((diag - 1) & diag)
								else
									diag = null
								if ((get_dist(mob, M) > 1 || diag))
									step(M, get_dir(M.loc, T))
				else
					for(var/mob/M in L)
						M.other_mobs = 1
						if(mob != M)
							M.animate_movement = 3
					for(var/mob/M in L)
						spawn( 0 )
							step(M, direct)
							return
						spawn( 1 )
							M.other_mobs = null
							M.animate_movement = 2
							return

		else if(mob.confused && prob(25))
			step(mob, pick(cardinal))
		else
			. = mob.SelfMove(n, direct)

		for (var/obj/item/grab/G in list(mob:l_hand, mob:r_hand))
			if (G.state == GRAB_NECK)
				mob.set_dir(reverse_dir[direct])
			G.adjust_position()

		for (var/obj/item/grab/G in mob.grabbed_by)
			G.adjust_position()

		moving = 0

	if(isobj(mob.loc) || ismob(mob.loc))	//Inside an object, tell it we moved
		var/atom/O = mob.loc
		return O.relaymove(mob, direct)

/mob/proc/SelfMove(turf/n, direct)
	return Move(n, direct)

///Process_Incorpmove
///Called by client/Move()
///Allows mobs to run though walls
/client/proc/Process_Incorpmove(direct)
	var/turf/mobloc = get_turf(mob)
	switch(mob.incorporeal_move)
		if(1)
			var/turf/T = get_step(mob, direct)
			if(mob.check_holy(T))
				to_chat(mob, "<span class='warning'>You cannot get past holy grounds while you are in this plane of existence!</span>")
				return
			else
				mob.forceMove(get_step(mob, direct))
				mob.dir = direct
		if(2)
			anim(mobloc,mob,'icons/mob/mob.dmi',,"shadow",,mob.dir)
			mob.forceMove(get_step(mob, direct))
			mob.dir = direct

		if(3)
			if(!mob.canmove || mob.anchored)
				return
			move_delay = 1 + world.time
			var/turf/T = get_step(mob, direct)
			for(var/obj/structure/window/W in T)
				if(istype(W, /obj/structure/window/phoronbasic) || istype(W, /obj/structure/window/phoronreinforced))
					if(W.is_full_window())
						to_chat(mob, "<span class='warning'>\The [W] obstructs your movement!</span>")
						return

					if((direct & W.dir) && W.density)
						to_chat(mob, "<span class='warning'>\The [W] obstructs your movement!</span>")
						return
			if(istype(T, /turf/simulated/wall/phoron) || istype(T, /turf/simulated/wall/ironphoron))
				to_chat(mob, "<span class='warning'>\The [T] obstructs your movement!</span>")
				return

			for(var/mob/living/L in T)
				if(L.is_diona() == DIONA_WORKER)
					to_chat(mob, "<span class='danger'>You struggle briefly as you are photovored into \the [L], trapped within a nymphomatic husk!</span>")
					var/mob/living/carbon/alien/diona/D = new /mob/living/carbon/alien/diona(L)
					var/mob/living/simple_animal/shade/bluespace/BS = mob
					if (!(/mob/living/carbon/proc/echo_eject in L.verbs))
						L.verbs.Add(/mob/living/carbon/proc/echo_eject)
					BS.mind.transfer_to(D)
					D.echo = 1
					D.stat = CONSCIOUS
					D.gestalt = L
					D.sync_languages(D.gestalt)
					D.update_verbs()
					D.forceMove(L)
					qdel(BS)
					return

			mob.forceMove(get_step(mob, direct))
			mob.dir = direct

	// Crossed is always a bit iffy
	for(var/obj/S in mob.loc)
		if(istype(S,/obj/effect/step_trigger) || istype(S,/obj/effect/beam))
			S.Crossed(mob)

	var/area/A = get_area_master(mob)
	if(A)
		A.Entered(mob)
	if(isturf(mob.loc))
		var/turf/T = mob.loc
		T.Entered(mob)
	mob.Post_Incorpmove()
	return 1

/mob/proc/Post_Incorpmove()
	return

// Checks whether this mob is allowed to move in space
// Return 1 for movement, 0 for none,
// -1 to allow movement but with a chance of slipping
/mob/proc/Allow_Spacemove(var/check_drift = 0)
	if(!Check_Dense_Object()) //Nothing to push off of so end here
		return 0

	if(restrained()) //Check to see if we can do things
		return 0

	return -1

//Checks if a mob has solid ground to stand on
//If there's no gravity then there's no up or down so naturally you can't stand on anything.
//For the same reason lattices in space don't count - those are things you grip, presumably.
/mob/proc/check_solid_ground()
	if(istype(loc, /turf/space))
		return 0

	if(!lastarea)
		lastarea = get_area(loc)
	if(!lastarea.has_gravity())
		return 0

	return 1


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
	if(prob(slip_chance(5)) && !buckled)
		to_chat(src, "<span class='warning'>You slipped!</span>")
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
