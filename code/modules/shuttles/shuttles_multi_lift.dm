
// multi lift, meaning it goes between stops
// if it goes from first stop to the last one
// it goes one by one sequentially through the ones in the middle
// order of stops is same as defined in destination_tags
/datum/shuttle/autodock/multi/lift/
	warmup_time = 3
	move_time = 3
	knockdown = FALSE
	squishes = FALSE
	ceiling_type = null
	sound_takeoff = 'sound/effects/lift_heavy_start.ogg'
	sound_landing = 'sound/effects/lift_heavy_stop.ogg'
	var/obj/effect/shuttle_landmark/final_location = null

// final_location must be set and valid
// if current and final location are the same, returns current location
/datum/shuttle/autodock/multi/lift/proc/get_next_destination_tag()
	var/current_tag = current_location.landmark_tag
	var/final_tag = final_location.landmark_tag
	ASSERT(current_tag in destination_tags)
	ASSERT(final_tag in destination_tags)
	var/current_i = destination_tags.Find(current_tag)
	var/final_i = destination_tags.Find(final_tag)
	ASSERT(current_i != final_i)
	if(current_i < final_i)
		return destination_tags[current_i + 1]
	else if(current_i > final_i)
		return destination_tags[current_i - 1]
	else
		return destination_tags[current_i]

/datum/shuttle/autodock/multi/lift/set_destination(var/destination_key, mob/user)
	final_location = destinations_cache[destination_key]
	var/next_tag = get_next_destination_tag()
	next_location = SSshuttle.get_landmark(next_tag)
	..(next_location.name, user)

/datum/shuttle/autodock/multi/lift/arrived()
	if(final_location == current_location)
		final_location = null
		// TODO: play sound lol
	else
		var/next_tag = get_next_destination_tag()
		next_location = SSshuttle.get_landmark(next_tag)
		set_destination(next_location.name, null)
		launch(in_use)
	..()

// TODO: handle emergency stop

