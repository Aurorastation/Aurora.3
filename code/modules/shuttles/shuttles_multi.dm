/datum/shuttle/multi
	/// Tags of all the landmarks that this should can go to.
	/// Can contain nested lists, as it is flattened before use.
	var/list/destination_tags
	var/list/destinations_cache = list()
	var/last_cache_rebuild_time = 0
	category = /datum/shuttle/multi

/datum/shuttle/multi/proc/set_destination(var/destination_key, mob/user)
	if(moving_status != SHUTTLE_IDLE)
		return
	next_location = destinations_cache[destination_key]

/datum/shuttle/multi/proc/get_destinations()
	if (last_cache_rebuild_time < SSshuttle.last_landmark_registration_time)
		build_destinations_cache()
	return destinations_cache

/datum/shuttle/multi/proc/build_destinations_cache()
	last_cache_rebuild_time = world.time
	destinations_cache.Cut()
	destination_tags = flatten_list(destination_tags)
	for(var/destination_tag in destination_tags)
		var/obj/effect/shuttle_landmark/landmark = SSshuttle.get_landmark(destination_tag)
		if(istype(landmark))
			destinations_cache["[landmark.name]"] = landmark

//Antag play announcements when they leave/return to their home area
/datum/shuttle/multi/antag
	warmup_time = 10 SECONDS //replaced the old move cooldown
	//This variable is type-abused initially: specify the landmark_tag, not the actual landmark.
	var/obj/effect/shuttle_landmark/home_waypoint

	var/cloaked = TRUE
	var/returned = FALSE
	var/return_warning_cooldown
	var/announcer
	var/arrival_message
	var/departure_message

	category = /datum/shuttle/multi/antag

/datum/shuttle/multi/antag/New()
	..()
	if(home_waypoint)
		home_waypoint = SSshuttle.get_landmark(home_waypoint)
	else
		home_waypoint = current_location

/datum/shuttle/multi/antag/cleanup_runway(obj/effect/shuttle_landmark/new_dock, list/old_turfs, list/new_turfs, list/areas_to_move, list/underlying_areas, list/moved_atoms, rotation, movement_direction, area/fallback_area)
	. = ..()
	if(new_dock == home_waypoint)
		announce_arrival()
	else if(istype(new_dock, /obj/effect/shuttle_landmark/transit))
		announce_departure()

/datum/shuttle/multi/antag/arrived()
	if(current_location == home_waypoint)
		returned = TRUE

/datum/shuttle/multi/antag/launch(var/user)
	if(returned)
		if(user)
			to_chat(user, SPAN_WARNING("You don't have enough fuel for another launch!"))
		return //Nada, can't go back.
	..(user)

/datum/shuttle/multi/antag/proc/announce_departure()
	if(cloaked || isnull(departure_message))
		return
	command_announcement.Announce(departure_message, announcer || "[SSmapping.current_map.boss_name]")

/datum/shuttle/multi/antag/proc/announce_arrival()
	if(cloaked || isnull(arrival_message))
		return
	command_announcement.Announce(arrival_message, announcer || "[SSmapping.current_map.boss_name]")
