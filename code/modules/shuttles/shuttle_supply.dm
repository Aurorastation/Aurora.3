/datum/shuttle/autodock/ferry/supply
	category = /datum/shuttle/autodock/ferry/supply
	var/away_location = 1	//the location to hide at while pretending to be in-transit
	var/late_chance = 80
	var/max_late_time = 300

	/// A list for step_triggers, used for toggling fall functionality. Making the elevator shaft tiles safe to stand or not depening on where the elevator is.
	var/list/step_trigger_group = list()

	/// Elevator effects for each northern corners of the shaft. This way the entire elevator won't disappear if there's an opaque obstacle in the sight line.
	/// Later on hardcoded to have their icons positioned on top of each other.
	/// These contain elevator shaft sprite. '/obj/effect/elevator/animation_overlay/elevator_animation' is used as a masked layer onto this.
	var/obj/effect/elevator/NW
	var/obj/effect/elevator/NE

	/// This effect will contain an image, copy of the turfs at CC supply shuttle zone. Added onto the elevator shaft effect as an off-centered overlay.
	var/obj/effect/elevator/animation_overlay/elevator_animation

	/// Hatch layers, similar to 'elevator_animation', is added to elevator shaft's 'vis_contents'.
	var/obj/effect/elevator/animation_overlay/hatch/left/hatch_L
	var/obj/effect/elevator/animation_overlay/hatch/right/hatch_R

	/// Locations caches for Horizon elevator bay.
	var/target_dest_x
	var/target_dest_y
	var/target_dest_z

	/// Area cache of Horizon elevator bay.
	var/area/horizon_elevator_area

	/// Used in animating elevator platform.
	var/animation_move_x = 0
	var/animation_move_y = 0

/datum/shuttle/autodock/ferry/supply/New(var/_name, var/obj/effect/shuttle_landmark/start_waypoint)
	..(_name, start_waypoint)
	SScargo.shuttle = src
	addtimer(CALLBACK(src, PROC_REF(prepare_elevator)), 1 MINUTE) // pseudo initialize. We give mapload some time before initializing rest of the properties

/datum/shuttle/autodock/ferry/supply/proc/prepare_elevator()
	var/obj/dest_helper = locate(/obj/effect/landmark/destination_helper/cargo_elevator)
	target_dest_x = dest_helper.x
	target_dest_y = dest_helper.y
	target_dest_z = dest_helper.z

	horizon_elevator_area = get_area(dest_helper)
	for(var/obj/effect/step_trigger/cargo_elevator/ST in horizon_elevator_area)
		step_trigger_group += ST


	elevator_animation = new /obj/effect/elevator/animation_overlay()
	elevator_animation.pixel_x = 224 // 7 tiles
	elevator_animation.pixel_y = -96 // 3 tiles

	hatch_L = new /obj/effect/elevator/animation_overlay/hatch/left()
	hatch_R = new /obj/effect/elevator/animation_overlay/hatch/right()

	NW = new /obj/effect/elevator(get_turf(src))
	NW.pixel_y = -192 // 6 tiles
	NW.vis_contents += elevator_animation
	NW.vis_contents += hatch_L
	NW.vis_contents += hatch_R

	NE = new /obj/effect/elevator(get_turf(src))
	NE.pixel_x = -192
	NE.pixel_y = -192
	NE.vis_contents += elevator_animation
	NE.vis_contents += hatch_L
	NE.vis_contents += hatch_R

	// We position the shaft beforehand.
	NW.forceMove(locate(target_dest_x, target_dest_y, target_dest_z))
	NE.forceMove(locate(target_dest_x + 6, target_dest_y, target_dest_z))

/datum/shuttle/autodock/ferry/supply/short_jump(var/area/destination)
	if(moving_status != SHUTTLE_IDLE)
		return

	if(isnull(location))
		return

	//it would be cool to play a sound here
	moving_status = SHUTTLE_WARMUP
	spawn(warmup_time*10)
		if (moving_status == SHUTTLE_IDLE)
			return	//someone cancelled the launch

		if (at_station() && forbidden_atoms_check())
			//cancel the launch because of forbidden atoms. announce over supply channel?
			moving_status = SHUTTLE_IDLE
			return

		if (!at_station()) //at centcom
			if(!SScargo.buy()) //Check if the shuttle can be sent
				moving_status = SHUTTLE_IDLE //Dont move the shuttle
				return

			flip_rotating_alarms() // elevator is coming up, prepare the lights
			//playsound(locate(hatch.x + 3, hatch.y - 1, hatch.z), 'sound/machines/warning-buzzer-2.ogg', 60, FALSE)

		//We pretend it's a long_jump by making the shuttle stay at centcom for the "in-transit" period.
		var/obj/effect/shuttle_landmark/away_waypoint = get_location_waypoint(away_location)
		moving_status = SHUTTLE_INTRANSIT

		//If we are at the away_landmark then we are just pretending to move, otherwise actually do the move
		if (next_location == away_waypoint)
			attempt_move(away_waypoint)
			play_elevator_animation(TRUE) // returning to CC, play the animation after elevator physically leaves

		//wait ETA here.
		arrive_time = world.time + SScargo.movetime
		while (world.time <= arrive_time)
			sleep(5)

		if (next_location != away_waypoint)
			//late
			if (prob(late_chance))
				sleep(rand(0,max_late_time))

			play_elevator_animation() // coming from CC, play the animation before elevator physically arrives, delay the process
			attempt_move(destination)

		moving_status = SHUTTLE_IDLE

		if (!at_station())	//at centcom
			SScargo.sell()

// returns 1 if the supply shuttle should be prevented from moving because it contains forbidden atoms
/datum/shuttle/autodock/ferry/supply/proc/forbidden_atoms_check()
	if (!at_station())
		return 0	//if badmins want to send mobs or a nuke on the supply shuttle from centcom we don't care

	for(var/area/A in shuttle_area)
		if(SScargo.forbidden_atoms_check(A))
			return 1

/datum/shuttle/autodock/ferry/supply/proc/at_station()
	return (!location)

//returns 1 if the shuttle is idle and we can still mess with the cargo shopping list
/datum/shuttle/autodock/ferry/supply/proc/idle()
	return (moving_status == SHUTTLE_IDLE)

//returns the ETA in minutes
/datum/shuttle/autodock/ferry/supply/proc/eta_minutes()
	var/ticksleft = arrive_time - world.time
	return round(ticksleft/600,1)

/**************************
	Elevator Animations
***************************/

// this will be reworked, currently a draft
/datum/shuttle/autodock/ferry/supply/proc/play_elevator_animation(returning_to_CC = FALSE)
	var/obj/effect/step_trigger/cargo_elevator/CE

	for(var/area/A in shuttle_area) // an image copy of the elevator platform is prepared here
		for(var/turf/T in A)
			elevator_animation.vis_contents += T

	if(!returning_to_CC) // coming to Horizon
		//playsound(locate(hatch.x + 3, hatch.y - 1, hatch.z), 'sound/machines/industrial_lift_raising.ogg', 100, FALSE)
		for(CE in step_trigger_group) // checking for the things standing on top of the hatch, then we send them to falling
			for(var/atom/movable/AM in get_turf(CE))
				if(istype(AM, /obj/effect)) // prevent picking up step_triggers
					continue
				CE.handle_falling(AM)
		CE = step_trigger_group[1]
		CE.safe_to_walk = FALSE
		sleep(4 SECONDS)

		animate(elevator_animation, pixel_x = animation_move_x, pixel_y = animation_move_y, time = 4 SECONDS)
		sleep(4.2 SECONDS)

		CE.safe_to_walk = TRUE
		flip_rotating_alarms()
		addtimer(CALLBACK(src, PROC_REF(toggle_railings)), 2 SECOND)

	else // leaving the Horizon
		flip_rotating_alarms()
		toggle_railings()
		sleep(2 SECONDS)

		// checking for standers is redundant here, since the elevator won't leave if a forbidden type is standing
		CE = step_trigger_group[1]
		CE.safe_to_walk = FALSE
		//playsound(locate(hatch.x + 4, hatch.y - 2, hatch.z), 'sound/machines/industrial_lift_lowering.ogg', 100, FALSE)
		animate(elevator_animation, pixel_x = animation_move_x, pixel_y = animation_move_y, time = 4 SECONDS)
		sleep(4.2 SECONDS)

		CE.safe_to_walk = TRUE
		flip_rotating_alarms()

	if(elevator_animation.pixel_y == 0) // prepare the animation for lowering for next time
		animation_move_x = 224
		animation_move_y = -96
	else // vice-versa
		animation_move_x = 0
		animation_move_y = 0

	elevator_animation.vis_contents.Cut()
	// we move the elevator shafts away to avoid layering issues
	NW.moveToNullspace()
	NE.moveToNullspace()

/datum/shuttle/autodock/ferry/supply/proc/flip_rotating_alarms()
	for(var/obj/machinery/rotating_alarm/RA in horizon_elevator_area)
		RA.toggle_state()

/datum/shuttle/autodock/ferry/supply/proc/toggle_railings()
	for(var/obj/structure/railing/retractable/R in horizon_elevator_area)
		R.toggle_state()

/obj/effect/landmark/destination_helper/cargo_elevator
	name = "cargo elevator destination helper"

/obj/effect/step_trigger/cargo_elevator
	name = "cargo elevator shaft"
	icon = 'icons/effects/map_effects.dmi'
	simulated = FALSE // this prevents the effects getting transported along with the elevator

	/// List of turfs within the 'area/supply/dock'. Shared between all instances.
	var/static/list/possible_turfs_to_land_on = list()

	/// Boolean, determines whether the movables should fall or not. Shared between all instances.
	var/static/safe_to_walk = TRUE

/obj/effect/step_trigger/cargo_elevator/Initialize()
	. = ..()
	if(!possible_turfs_to_land_on.len)
		possible_turfs_to_land_on = get_area_turfs(/area/supply/dock)

/obj/effect/step_trigger/cargo_elevator/Trigger(atom/movable/AM)
	if(safe_to_walk)
		return
	handle_falling(AM)

/obj/effect/step_trigger/cargo_elevator/proc/handle_falling(atom/movable/AM)

	if(!isliving(AM) && !isobj(AM)) // only mobs and objects
		return

	if(isliving(AM))
		var/mob/living/L = AM
		if(L.CanAvoidGravity())
			return
		L.Weaken(20 SECONDS)

	INVOKE_ASYNC(src, PROC_REF(animate_falling), AM)

/obj/effect/step_trigger/cargo_elevator/proc/animate_falling(atom/movable/AM)
	var/oldalpha = AM.alpha
	var/oldcolor = AM.color
	var/old_pixel_y = AM.pixel_y
	animate(AM, transform = matrix() - matrix(), alpha = 0, color = rgb(0, 0, 0), time = 10)

	for(var/i in 1 to 5)
		//Make sure the item is still there after our sleep
		if(!AM || QDELETED(AM))
			return
		AM.pixel_y--
		sleep(2)

	//Make sure the item is still there after our sleep
	if(!AM || QDELETED(AM))
		return

	AM.visible_message(SPAN_WARNING("[AM] falls into [src]!"), SPAN_DANGER("You stumble and stare into \the [src] as you fall. It will be a long ride..."))
	AM.forceMove(pick(possible_turfs_to_land_on))

	AM.alpha = oldalpha
	AM.color = oldcolor
	AM.transform = matrix()
	AM.pixel_y = old_pixel_y

	if(isliving(AM))
		var/mob/living/L = AM
		L.death()
		L.adjustBruteLoss(rand(200,400))
		L.dir = pick(GLOB.cardinals)
