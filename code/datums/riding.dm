// This is used to make things that are supposed to move while buckled more consistant and easier to handle code-wise.

/datum/riding
	var/next_vehicle_move = 0			// Used for move delays
	var/vehicle_move_delay = 2 			// Tick delay between movements, lower = faster, higher = slower
	var/keytype = null					// Can give this a type to require the rider to hold the item type inhand to move the ridden atom.
	var/nonhuman_key_exemption = FALSE	// If true, nonhumans who can't hold keys don't need them, like borgs and simplemobs.
	var/key_name = "the keys"			// What the 'keys' for the thing being rided on would be called.
	var/atom/movable/ridden = null 		// The thing that the datum is attached to.
	var/only_one_driver = FALSE			// If true, only the person in 'front' (first on list of riding mobs) can drive.

/datum/riding/New(atom/movable/_ridden)
	ridden = _ridden

/datum/riding/Destroy()
	ridden = null
	return ..()

/datum/riding/proc/handle_vehicle_layer()
	if(ridden.dir != NORTH)
		ridden.layer = ABOVE_MOB_LAYER
	else
		ridden.layer = OBJ_LAYER

/datum/riding/proc/on_vehicle_move()
	for(var/mob/living/M in ridden.buckled_mobs)
		ride_check(M)
	handle_vehicle_offsets()
	handle_vehicle_layer()

/datum/riding/proc/ride_check(mob/living/M)
	return TRUE

/datum/riding/proc/force_dismount(mob/living/M)
	ridden.unbuckle_mob(M)

/datum/riding/proc/handle_vehicle_offsets()
	var/ridden_dir = "[ridden.dir]"
	var/passindex = 0
	if(ridden.has_buckled_mobs())
		for(var/m in ridden.buckled_mobs)
			passindex++
			var/mob/living/buckled_mob = m
			var/list/offsets = get_offsets(passindex)
			var/rider_dir = get_rider_dir(passindex)
			buckled_mob.set_dir(rider_dir)
			dir_loop:
				for(var/offsetdir in offsets)
					if(offsetdir == ridden_dir)
						var/list/diroffsets = offsets[offsetdir]
						buckled_mob.pixel_x = diroffsets[1]
						if(diroffsets.len >= 2)
							buckled_mob.pixel_y = diroffsets[2]
						if(diroffsets.len == 3)
							buckled_mob.layer = diroffsets[3]
						break dir_loop

// Override this to set your vehicle's various pixel offsets
/datum/riding/proc/get_offsets(pass_index) // list(dir = x, y, layer)
	return list("[NORTH]" = list(0, 0), "[SOUTH]" = list(0, 0), "[EAST]" = list(0, 0), "[WEST]" = list(0, 0))

// Override this to set the passengers/riders dir based on which passenger they are.
// ie: rider facing the vehicle's dir, but passenger 2 facing backwards, etc.
/datum/riding/proc/get_rider_dir(pass_index)
	return ridden.dir

// KEYS
/datum/riding/proc/keycheck(mob/user)
	if(keytype)
		if(nonhuman_key_exemption && !ishuman(user))
			return TRUE

		if(user.is_holding_item_of_type(keytype))
			return TRUE
	else
		return TRUE
	return FALSE

// BUCKLE HOOKS
/datum/riding/proc/restore_position(mob/living/buckled_mob)
	if(istype(buckled_mob))
		buckled_mob.pixel_x = 0
		buckled_mob.pixel_y = 0
		buckled_mob.layer = initial(buckled_mob.layer)

// MOVEMENT
/datum/riding/proc/handle_ride(mob/user, direction)
	if(user.incapacitated())
		Unbuckle(user)
		return

	if(only_one_driver && ridden.buckled_mobs.len)
		var/mob/living/driver = ridden.buckled_mobs[1]
		if(driver != user)
			to_chat(user, "<span class='warning'>\The [ridden] can only be controlled by one person at a time, and is currently being controlled by \the [driver].</span>")
			return

	if(world.time < next_vehicle_move)
		return
	next_vehicle_move = world.time + vehicle_move_delay
	if(keycheck(user))
		if(!Process_Spacemove(direction) || !isturf(ridden.loc))
			return
		step(ridden, direction)

		handle_vehicle_layer()
		handle_vehicle_offsets()
	else
		to_chat(user, "<span class='warning'>You'll need [key_name] in one of your hands to move \the [ridden].</span>")

/datum/riding/proc/Unbuckle(atom/movable/M)
//	addtimer(CALLBACK(ridden, /atom/movable/.proc/unbuckle_mob, M), 0, TIMER_UNIQUE)
	spawn(0)
	// On /tg/ this uses the fancy CALLBACK system. Not entirely sure why they needed to do so with a duration of 0,
	// so if there is a reason, this should replicate it close enough. Hopefully.
		ridden.unbuckle_mob(M)

/datum/riding/proc/Process_Spacemove(direction)
	if(ridden.atom_has_gravity())
		return TRUE

	return FALSE

/datum/riding/space/Process_Spacemove(direction)
	return TRUE


