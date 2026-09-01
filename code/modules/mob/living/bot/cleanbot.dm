// Updated by Nadrew, bits and pieces taken from Baycode, but fairly heavily modified to function here (and because a few bits of the baycode was ehh)

// The main issue in the old code was the Life() loop and the fact that it could go infinite really easily.
// The fix involved labeling the various loops involved so they could be continued and broken properly.
// It also decreases the amount of calls to AStar() and handle_target()

///A list of *types* that cleanbots will look for
GLOBAL_LIST_INIT_TYPED(cleanbot_types, /obj/effect/decal/cleanable, typesof(/obj/effect/decal/cleanable/blood, /obj/effect/decal/cleanable/vomit, /obj/effect/decal/cleanable/flour, \
						/obj/effect/decal/cleanable/crayon, /obj/effect/decal/cleanable/mucus, /obj/effect/decal/cleanable/dirt))

/obj/effect/decal/cleanable
	var/being_cleaned = FALSE
	///A reference to a `/mob/living/bot/cleanbot` that wants to clean this turf, or null
	var/datum/weakref/clean_marked = null

/mob/living/bot/cleanbot
	name = "Cleanbot"
	desc = "A little cleaning robot, consisting of a bucket, a proximity sensor, and a prosthetic arm. It looks excited to clean!"
	icon_state = "cleanbot0"
	req_one_access = list(ACCESS_JANITOR, ACCESS_ROBOTICS)
	botcard_access = list(ACCESS_JANITOR, ACCESS_MAINT_TUNNELS)

	locked = FALSE // Start unlocked so roboticist can set them to patrol.

	///The target we're going to clean up, an `/obj/effect/decal/cleanable` weakref
	var/datum/weakref/cleaning_target = null
	var/list/path = list()
	var/list/patrol_path = list()

	//A list of `/datum/weakref` that resolve to `/obj/effect/decal/cleanable`, those are the objects to ignore
	var/list/datum/weakref/ignorelist = list()

	///Used for patrol pathing, navbeacons have this by default
	var/beacon_freq = BEACONS_FREQ

	///The last time a numbered patrol scan failed, used to avoid constant pathfinding retries
	var/last_patrol_search = 0
	var/closest_numbered_dist = 9999
	var/next_dest_loc
	///Numbered patrol beacons, indexed by patrol number as text
	var/list/numbered_patrols = list()
	///Z-level for which numbered_patrols was populated
	var/numbered_patrol_z = 0
	///The closest numbered patrol beacon found by the latest radio request
	var/nearest_patrol_number = 0
	///The numbered patrol beacon at which the current leg began
	var/current_patrol_number = 0
	///The numbered patrol beacon the bot is currently travelling toward
	var/target_patrol_number = 0
	///Whether the bot is currently moving toward higher or lower patrol numbers
	var/patrol_direction = 1
	///Player-readable explanation for the most recent numbered patrol routing failure
	var/patrol_route_failure

	var/screw_loose = FALSE
	var/odd_button = FALSE
	var/should_patrol = FALSE
	var/cleans_blood = TRUE

	///A list of `/obj/effect/decal/cleanable` *types* that this borg can target for cleaning
	var/list/target_types = list()

	var/maximum_search_range = 7

	///Boolean, if it's cleaning something *right now* and waiting for the timer to say it's done
	var/cleaning = FALSE

	///The turf we got the last movement failure on, used to distinguish a door bump from a persistent obstruction
	var/turf/last_movement_failure_turf
	///Number of consecutive movement failures on the same turf
	var/movement_failure_count = 0

/mob/living/bot/cleanbot/Cross(atom/movable/crossed)
	if(crossed)
		if(istype(crossed, /mob/living/bot/cleanbot))
			return FALSE
		return ..()

/mob/living/bot/cleanbot/Initialize()
	. = ..()
	get_targets()
	//Do not start to patrol until you're told to, also save processing
	set_patrol_mode(FALSE)

	if(is_station_turf(get_turf(src)))
		GLOB.janitorial_supplies |= src

/mob/living/bot/cleanbot/Destroy()
	path = null
	patrol_path = null
	cleaning_target = null
	ignorelist = null
	next_dest_loc = null
	numbered_patrols = null

	if(src in GLOB.janitorial_supplies)
		GLOB.janitorial_supplies -= src
	return ..()

/mob/living/bot/cleanbot/proc/handle_target()
	//Get the actual cleanable decal to target
	var/obj/effect/decal/cleanable/cleaning_target_cache = cleaning_target?.resolve()
	if(!cleaning_target_cache)
		cleaning_target = null
		path = list()
		return FALSE

	var/mob/living/bot/cleanbot/turf_targeting_cleanbot = cleaning_target_cache?.clean_marked?.resolve()

	//If already marked by another bot, ignore it. Reclaim stale marks whose bot no longer exists.
	if(turf_targeting_cleanbot && turf_targeting_cleanbot != src)
		ignorelist |= cleaning_target
		cleaning_target = null
		path = list()
		return FALSE
	else if(!turf_targeting_cleanbot)
		cleaning_target_cache.clean_marked = WEAKREF(src)

	//If we are over it, clean it up
	if(get_turf(src) == get_turf(cleaning_target_cache))
		if(!cleaning)
			UnarmedAttack(cleaning_target_cache)
			return TRUE

	//Try to get a path to the location if you don't have one
	if(!length(path))
		path = get_path_to(src, cleaning_target_cache, 250, 0, botcard.GetAccess(), diagonal_handling=DIAGONAL_REMOVE_ALL)
		//No length means there's no path to reach it, add it to the exclusions
		if(!length(path))
			ignorelist |= cleaning_target
			cleaning_target_cache.clean_marked = null
			cleaning_target = null
			path = list()

	if(length(path) && !cleaning)
		var/successfully_moved = step_to(src, path[1])

		if(successfully_moved)
			last_movement_failure_turf = null
			movement_failure_count = 0
			path.Cut(1, 2)
			return TRUE

		//Something blocked us, look for a different target, we might come back to this in a while
		if(last_movement_failure_turf != path[1])
			last_movement_failure_turf = path[1]
			movement_failure_count = 1
			return FALSE

		movement_failure_count++
		if(movement_failure_count < 5)
			return FALSE

		//This is the second failure on the same turf, invalidate the target.
		ignorelist |= cleaning_target
		cleaning_target_cache.clean_marked = null
		cleaning_target = null
		path = list()
		last_movement_failure_turf = null
		movement_failure_count = 0
		return FALSE



/mob/living/bot/cleanbot/proc/remove_from_ignore(datum/weakref/thing_to_unignore)
	ignorelist -= thing_to_unignore

/mob/living/bot/cleanbot/Life(seconds_per_tick, times_fired)
	if(!..())
		return FALSE

	if(!on)
		ignorelist = list()
		return

	if(length(ignorelist) && prob(2))
		ignorelist -= pick(ignorelist)

	if(client)
		return
	if(cleaning)
		return

	if(!screw_loose && !odd_button && prob(2) && world.time > last_emote + 2 MINUTES)
		custom_emote(AUDIBLE_MESSAGE, "makes an excited beeping booping sound!")
		last_emote = world.time

	if(screw_loose && prob(5)) // Make a mess
		if(istype(loc, /turf/simulated))
			var/turf/simulated/T = loc
			T.wet_floor()

	if(odd_button && prob(5)) // Make a big mess
		visible_message(SPAN_WARNING("Some bloody gibs fall out of [src]..."))
		var/obj/effect/decal/cleanable/blood/gibs/gib = new /obj/effect/decal/cleanable/blood/gibs(get_turf(src))
		var/datum/weakref/gib_ref = WEAKREF(gib)
		ignorelist += gib_ref
		addtimer(CALLBACK(src, PROC_REF(remove_from_ignore), gib_ref), 600)

	return TRUE

/mob/living/bot/cleanbot/think()
	if(pAI) // no AI if we have a pAI installed
		return

	..()

	if(!on)
		return

	if(pulledby) // Don't wiggle if someone pulls you
		patrol_path?.Cut()
		return

	if(cleaning)
		return

	//Keep servicing an acquired target even after consuming the final path node.
	if(cleaning_target)
		handle_target()
		return

	//Otherwise, look around for a target, or patrol
	//If we could a spot to clean or not
	var/found_spot

	for(var/obj/effect/decal/cleanable/D in view(maximum_search_range, src))
		// Dirt is expected in maintenance and should not pull the bot away from its patrol route.
		if(is_maint_area(get_area(D)))
			continue

		var/datum/weakref/cleanable_weakref = WEAKREF(D)

		var/mob/living/bot/cleanbot/turf_targeting_cleanbot = D.clean_marked?.resolve()

		//Someone already wants this cleanable and it's not us, keep looking
		if(!isnull(turf_targeting_cleanbot) && turf_targeting_cleanbot != src)
			continue

		var/mob/living/bot/cleanbot/other_bot = locate() in get_turf(D)
		if(other_bot && other_bot.cleaning && other_bot != src)
			continue

		// If the object has been slated to be ignored we continue the loop.
		if(cleanable_weakref in ignorelist)
			continue

		// A matching /cleanable was found, now we want to path trace to it and see if we can reach it.
		if(D.type in target_types)
			patrol_path = list()
			cleaning_target = cleanable_weakref
			D.clean_marked = WEAKREF(src)
			found_spot = handle_target()
			if(found_spot || cleaning_target)
				break // If the target location is found and pathed properly, break the search loop.

	if(found_spot || cleaning_target || !should_patrol)
		return

	if(!length(patrol_path))
		if(!last_patrol_search || world.time >= last_patrol_search + 200)
			var/found_numbered_route = refresh_numbered_patrol_path(TRUE)
			last_patrol_search = found_numbered_route ? 0 : world.time

	if(length(patrol_path))
		follow_patrol_path()


///Attempts the next patrol step without discarding a valid route during movement cooldowns or while a door opens.
/mob/living/bot/cleanbot/proc/follow_patrol_path()
	if(!length(patrol_path))
		return FALSE

	var/turf/next_step = patrol_path[1]
	if(next_step == loc)
		patrol_path.Cut(1, 2)
		if(!length(patrol_path))
			complete_numbered_patrol_leg()
		return TRUE

	if(step_to(src, next_step) && get_turf(src) == next_step)
		last_movement_failure_turf = null
		movement_failure_count = 0
		patrol_path.Cut(1, 2)
		if(!length(patrol_path))
			complete_numbered_patrol_leg()
		return TRUE

	if(last_movement_failure_turf != next_step)
		last_movement_failure_turf = next_step
		movement_failure_count = 1
		return FALSE

	movement_failure_count++
	if(movement_failure_count < 5)
		return FALSE

	patrol_path = list()
	invalidate_numbered_patrol_cache()
	last_patrol_search = 0
	last_movement_failure_turf = null
	movement_failure_count = 0
	return FALSE


///Rebuilds the route to the intended numbered waypoint, or selects the next waypoint when needed.
/mob/living/bot/cleanbot/proc/refresh_numbered_patrol_path(preserve_target = FALSE)
	patrol_route_failure = null
	next_dest_loc = null
	patrol_path = list()
	var/cache_refreshed = FALSE

	if(!numbered_patrol_cache_is_valid())
		find_numbered_patrol_beacons()
		cache_refreshed = TRUE

	if(!nearest_patrol_number || !length(numbered_patrols))
		patrol_route_failure = "no numbered patrol beacons are registered on this frequency and Z-level"
		return FALSE

	if(preserve_target && target_patrol_number)
		next_dest_loc = get_numbered_patrol_turf(target_patrol_number)
		if(!next_dest_loc && !cache_refreshed)
			find_numbered_patrol_beacons()
			cache_refreshed = TRUE
			next_dest_loc = get_numbered_patrol_turf(target_patrol_number)

	if(!next_dest_loc)
		if(!current_patrol_number || !numbered_patrols["[current_patrol_number]"])
			current_patrol_number = nearest_patrol_number
		next_dest_loc = get_numbered_patrol_destination()
		if(!next_dest_loc && !cache_refreshed)
			find_numbered_patrol_beacons()
			cache_refreshed = TRUE
			if(!current_patrol_number || !numbered_patrols["[current_patrol_number]"])
				current_patrol_number = nearest_patrol_number
			next_dest_loc = get_numbered_patrol_destination()

	if(!next_dest_loc)
		patrol_route_failure = "no following patrol number could be selected"
		return FALSE

	if(get_turf(src) == next_dest_loc)
		return complete_numbered_patrol_leg()

	patrol_path = get_path_to(src, next_dest_loc, 250, 0, botcard.GetAccess(), diagonal_handling=DIAGONAL_REMOVE_ALL)
	if(!length(patrol_path))
		patrol_route_failure = "waypoint [target_patrol_number] was detected, but no traversable path reaches it"
		invalidate_numbered_patrol_cache()
	return length(patrol_path) > 0


///Records arrival at a numbered waypoint and immediately prepares the following patrol leg.
/mob/living/bot/cleanbot/proc/complete_numbered_patrol_leg()
	if(!target_patrol_number || get_turf(src) != next_dest_loc)
		return FALSE

	current_patrol_number = target_patrol_number
	nearest_patrol_number = current_patrol_number
	target_patrol_number = 0
	next_dest_loc = null
	last_patrol_search = 0
	last_movement_failure_turf = null
	movement_failure_count = 0
	return refresh_numbered_patrol_path()


///Finds numbered patrol beacons registered on our frequency and Z-level.
/mob/living/bot/cleanbot/proc/find_numbered_patrol_beacons()
	invalidate_numbered_patrol_cache()

	var/list/beacon_devices = SSradio.get_devices(beacon_freq, RADIO_NAVBEACONS)
	if(!length(beacon_devices))
		return FALSE

	var/turf/our_turf = get_turf(src)
	if(!our_turf)
		return FALSE
	numbered_patrol_z = our_turf.z

	for(var/obj/structure/machinery/navbeacon/beacon in beacon_devices)
		if(beacon.patrol_number <= 0 || !beacon.anchored)
			continue

		var/turf/beacon_turf = get_turf(beacon)
		if(!beacon_turf || beacon_turf.z != our_turf?.z)
			continue

		numbered_patrols["[beacon.patrol_number]"] = beacon

	update_nearest_numbered_patrol()

	return length(numbered_patrols) > 0


///Clears the filtered beacon cache so the next patrol route performs a fresh radio registry lookup.
/mob/living/bot/cleanbot/proc/invalidate_numbered_patrol_cache()
	numbered_patrols = list()
	numbered_patrol_z = 0
	nearest_patrol_number = 0
	closest_numbered_dist = 9999


///Returns TRUE when the cache was populated for the bot's current Z-level.
///Individual beacon validity is checked only when a destination is selected, avoiding a full validation pass every leg.
/mob/living/bot/cleanbot/proc/numbered_patrol_cache_is_valid()
	var/turf/our_turf = get_turf(src)
	return our_turf && length(numbered_patrols) && numbered_patrol_z == our_turf.z


///Updates the closest numbered beacon using the already-filtered cache.
/mob/living/bot/cleanbot/proc/update_nearest_numbered_patrol()
	nearest_patrol_number = 0
	closest_numbered_dist = 9999

	for(var/number_text in numbered_patrols)
		var/obj/structure/machinery/navbeacon/beacon = numbered_patrols[number_text]
		var/turf/beacon_turf = get_turf(beacon)
		if(!beacon_turf)
			continue

		var/beacon_dist = get_dist(src, beacon_turf)
		if(beacon_dist < closest_numbered_dist)
			closest_numbered_dist = beacon_dist
			nearest_patrol_number = beacon.patrol_number


///Returns the current turf of a cached patrol beacon.
/mob/living/bot/cleanbot/proc/get_numbered_patrol_turf(patrol_number)
	var/obj/structure/machinery/navbeacon/beacon = numbered_patrols["[patrol_number]"]
	if(QDELETED(beacon) || !beacon.anchored || beacon.freq != beacon_freq || beacon.patrol_number != patrol_number)
		return null

	var/turf/beacon_turf = get_turf(beacon)
	if(!beacon_turf || beacon_turf.z != numbered_patrol_z)
		return null
	return beacon_turf


///Returns the next numbered patrol beacon, reversing direction at either end of the route.
/mob/living/bot/cleanbot/proc/get_numbered_patrol_destination()
	var/patrol_anchor = current_patrol_number || nearest_patrol_number
	if(!patrol_anchor || !length(numbered_patrols))
		return null

	var/next_patrol_number = 0
	for(var/number_text in numbered_patrols)
		var/beacon_number = text2num(number_text)
		if(patrol_direction > 0 && beacon_number > patrol_anchor)
			if(!next_patrol_number || beacon_number < next_patrol_number)
				next_patrol_number = beacon_number
		else if(patrol_direction < 0 && beacon_number < patrol_anchor)
			if(!next_patrol_number || beacon_number > next_patrol_number)
				next_patrol_number = beacon_number

	if(!next_patrol_number)
		patrol_direction *= -1
		for(var/number_text in numbered_patrols)
			var/beacon_number = text2num(number_text)
			if(patrol_direction > 0 && beacon_number > patrol_anchor)
				if(!next_patrol_number || beacon_number < next_patrol_number)
					next_patrol_number = beacon_number
			else if(patrol_direction < 0 && beacon_number < patrol_anchor)
				if(!next_patrol_number || beacon_number > next_patrol_number)
					next_patrol_number = beacon_number

	target_patrol_number = next_patrol_number
	return get_numbered_patrol_turf(target_patrol_number)


/mob/living/bot/cleanbot/UnarmedAttack(var/obj/effect/decal/cleanable/D, var/proximity)
	. = ..()
	if(!.)
		return

	if(isturf(D))
		D = locate(/obj/effect/decal/cleanable) in D
	if(!istype(D))
		return

	if(!src.Adjacent(D))
		return

	cleaning = TRUE
	D.being_cleaned = TRUE
	update_icon()
	var/clean_time = istype(D, /obj/effect/decal/cleanable/dirt) ? 10 : 50
	addtimer(CALLBACK(src, PROC_REF(do_clean), D), clean_time)

/mob/living/bot/cleanbot/proc/do_clean(var/obj/effect/decal/cleanable/D)
	if(!QDELETED(D))
		D.clean_marked = null
		D.being_cleaned = FALSE

		if(on && Adjacent(D))
			var/turf/simulated/f = get_turf(D)
			if(istype(f))
				f.dirt = 0

			D.clean_with_basic_cleaner()

	cleaning_target = null
	cleaning = FALSE
	update_icon()

/mob/living/bot/cleanbot/explode()
	on = FALSE // the first thing i do when i explode is turn off, tbh - geeves
	visible_message(SPAN_WARNING("[src] blows apart!"))
	var/turf/T = get_turf(src)
	new /obj/item/reagent_containers/glass/bucket(T)
	new /obj/item/assembly/prox_sensor(T)
	if(prob(50))
		new /obj/item/robot_parts/l_arm(T)
	spark(src, 3, GLOB.alldirs)
	qdel(src)
	return

/mob/living/bot/cleanbot/update_icon()
	if(cleaning)
		icon_state = "cleanbot-c"
	else
		icon_state = "cleanbot[on]"

/mob/living/bot/cleanbot/attack_hand(mob/user)
	ui_interact(user)

/mob/living/bot/cleanbot/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CleanBot")
		ui.open()

/mob/living/bot/cleanbot/ui_data(mob/user)
	var/list/data = list()
	data["status"] = on
	data["locked"] = locked
	data["maintenance_panel"] = open
	data["cleans_blood"] = cleans_blood
	data["should_patrol"] = should_patrol
	data["screw_loose"] = screw_loose
	data["odd_button"] = odd_button
	data["beacon_freq"] = beacon_freq
	data["current_patrol_number"] = current_patrol_number
	data["target_patrol_number"] = target_patrol_number
	return data

/mob/living/bot/cleanbot/ui_static_data(mob/user)

	var/list/data = list()
	var/list/cleanables_names = list()


	for(var/obj/effect/decal/cleanable/cleanable_type as anything in target_types)
		cleanables_names |= capitalize_first_letters(initial(cleanable_type.name))

	data["cleanable_types"] = cleanables_names
	return data

/mob/living/bot/cleanbot/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	if(.)
		return

	switch(action)

		if("toggle_status")
			if(on)
				turn_off()
			else
				turn_on()

		if("toggle_cleans_blood")
			cleans_blood = !cleans_blood
			get_targets()

		if("toggle_patrol_mode")
			set_patrol_mode(!should_patrol)

		if("go_to_patrol_waypoint")
			if(on && should_patrol)
				var/obj/effect/decal/cleanable/current_target = cleaning_target?.resolve()
				if(!cleaning && current_target?.clean_marked?.resolve() == src)
					current_target.clean_marked = null
				if(!cleaning)
					cleaning_target = null
					path = list()
				patrol_path = list()
				last_patrol_search = 0
				last_movement_failure_turf = null
				movement_failure_count = 0
				MOB_START_THINKING(src)
				if(refresh_numbered_patrol_path(TRUE))
					to_chat(usr, SPAN_NOTICE("[src] sets a route for patrol waypoint [target_patrol_number]."))
					if(!cleaning)
						follow_patrol_path()
				else
					to_chat(usr, SPAN_WARNING("[src] cannot set a patrol route: [patrol_route_failure || "unknown routing error"]."))

		if("set_frequency")
			var/new_frequency = tgui_input_number(usr, "Select frequency for navigation beacons", "Frequnecy", (beacon_freq/10), round_value = FALSE)
			if(new_frequency > 0)
				beacon_freq = new_frequency*10
				invalidate_numbered_patrol_cache()
				current_patrol_number = 0
				target_patrol_number = 0
				patrol_path = list()
				last_patrol_search = 0

		if("toggle_screw")
			screw_loose = !screw_loose
			to_chat(usr, SPAN_NOTICE("You twiddle the screw."))

		if("toggle_odd_button")
			odd_button = !odd_button
			to_chat(usr, SPAN_NOTICE("You press the weird button."))

/mob/living/bot/cleanbot/Topic(href, href_list)
	if(..())
		return
	add_fingerprint(usr)

	attack_hand(usr)

/mob/living/bot/cleanbot/attackby(obj/item/attacking_item, mob/user)
	. = ..()
	//To refresh the lock/unlock from ID hitting etc.
	SStgui.try_update_ui(user, src)

/mob/living/bot/cleanbot/turn_on()
	. = ..()
	MOB_START_THINKING(src)

/mob/living/bot/cleanbot/turn_off()
	. = ..()
	var/obj/effect/decal/cleanable/current_target = cleaning_target?.resolve()
	if(!cleaning && current_target?.clean_marked?.resolve() == src)
		current_target.clean_marked = null
	cleaning_target = null
	path = list()
	patrol_path = list()
	ignorelist = list()
	MOB_STOP_THINKING(src)


/**
 * Handles the turn on / off of patrol mode
 *
 * * state - A Boolean, `TRUE` to turn patrol mode on, `FALSE` to turn it off
 */
/mob/living/bot/cleanbot/proc/set_patrol_mode(state)
	patrol_path.Cut()
	invalidate_numbered_patrol_cache()

	if(state)
		should_patrol = TRUE
		patrol_path = list()
		last_patrol_search = 0

	else
		should_patrol = FALSE
		current_patrol_number = 0
		target_patrol_number = 0
		next_dest_loc = null

/mob/living/bot/cleanbot/emag_act(var/remaining_uses, var/mob/user)
	. = ..()
	if(!screw_loose || !odd_button)
		if(user)
			to_chat(user, SPAN_NOTICE("The [src] buzzes and beeps."))
		odd_button = TRUE
		screw_loose = TRUE
		return TRUE

/mob/living/bot/cleanbot/proc/get_targets()
	target_types = GLOB.cleanbot_types
	if(!cleans_blood)
		//Well now there's a point, this doesn't clean blood or oil
		target_types = target_types.Copy()
		target_types -= typesof(/obj/effect/decal/cleanable/blood, /obj/effect/decal/cleanable/blood/oil)

	var/obj/effect/decal/cleanable/current_target = cleaning_target?.resolve()
	if(current_target && !cleaning && !(current_target.type in target_types))
		if(current_target.clean_marked?.resolve() == src)
			current_target.clean_marked = null
		cleaning_target = null
		path = list()
/* Assembly */

/obj/item/bucket_sensor
	name = "proxy bucket"
	desc = "It's a bucket. With a sensor attached."
	icon = 'icons/mob/npc/aibots.dmi'
	icon_state = "bucket_proxy"
	force = 3
	throwforce = 10
	throw_speed = 2
	throw_range = 5
	var/created_name = "Cleanbot"

/obj/item/bucket_sensor/attackby(obj/item/attacking_item, mob/user)
	..()
	if(istype(attacking_item, /obj/item/robot_parts/l_arm) || istype(attacking_item, /obj/item/robot_parts/r_arm))
		user.drop_from_inventory(attacking_item, get_turf(src))
		qdel(attacking_item)
		var/turf/T = get_turf(src)
		var/mob/living/bot/cleanbot/A = new /mob/living/bot/cleanbot(T)
		A.name = created_name
		to_chat(user, SPAN_NOTICE("You add the robot arm to the bucket and sensor assembly. Beep boop!"))
		qdel(src)
	else if(attacking_item.tool_behaviour == TOOL_PEN)
		var/t = sanitizeSafe( tgui_input_text(user, "Enter new robot name", name, created_name, MAX_NAME_LEN), MAX_NAME_LEN )
		if(!t)
			return
		if(!in_range(src, usr) && src.loc != usr)
			return
		created_name = t
