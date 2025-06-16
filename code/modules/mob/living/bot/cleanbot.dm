// Updated by Nadrew, bits and pieces taken from Baycode, but fairly heavily modified to function here (and because a few bits of the baycode was ehh)

// The main issue in the old code was the Life() loop and the fact that it could go infinite really easily.
// The fix involved labeling the various loops involved so they could be continued and broken properly.
// It also decreases the amount of calls to AStar() and handle_target()

///A list of *types* that cleanbots will look for
GLOBAL_LIST_INIT_TYPED(cleanbot_types, /obj/effect/decal/cleanable, typesof(/obj/effect/decal/cleanable/blood, /obj/effect/decal/cleanable/vomit, /obj/effect/decal/cleanable/flour, \
						/obj/effect/decal/cleanable/crayon, /obj/effect/decal/cleanable/liquid_fuel, /obj/effect/decal/cleanable/mucus, /obj/effect/decal/cleanable/dirt))

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

	var/obj/cleanbot_listener/listener

	///Used for patrol pathing, navbeacons have this by default
	var/beacon_freq = BEACONS_FREQ

	///The time at which a "findbeacon" signal was broadcasted; it's used for us to find the list of available beacons in patrol mode, to know where to go
	var/signal_sent = 0
	var/closest_dist = 9999
	var/next_dest
	var/next_dest_loc

	var/screw_loose = FALSE
	var/odd_button = FALSE
	var/should_patrol = FALSE
	var/cleans_blood = TRUE

	///A list of `/obj/effect/decal/cleanable` *types* that this borg can target for cleaning
	var/list/target_types = list()

	var/maximum_search_range = 7

	///Boolean, if it's cleaning something *right now* and waiting for the timer to say it's done
	var/cleaning = FALSE

	///The turf we got the last movement failure on, since doors have to be bumped to be opened
	var/turf/last_movement_failure_turf

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

	listener = new /obj/cleanbot_listener(src)
	listener.cleanbot = src

	if(is_station_turf(get_turf(src)))
		GLOB.janitorial_supplies |= src

	SSradio.add_object(listener, beacon_freq, filter = RADIO_NAVBEACONS)

/mob/living/bot/cleanbot/Destroy()
	path = null
	patrol_path = null
	cleaning_target = null
	ignorelist = null
	next_dest_loc = null

	QDEL_NULL(listener)
	SSradio.remove_object(listener, beacon_freq)

	if(src in GLOB.janitorial_supplies)
		GLOB.janitorial_supplies -= src
	return ..()

/mob/living/bot/cleanbot/proc/handle_target()
	//Get the actual cleanable decal to target
	var/obj/effect/decal/cleanable/cleaning_target_cache = cleaning_target?.resolve()
	var/mob/living/bot/cleanbot/turf_targeting_cleanbot = cleaning_target_cache?.clean_marked?.resolve()

	//If already marked by another borg, ignore it
	if(turf_targeting_cleanbot != src)
		cleaning_target = null
		path = list()
		ignorelist |= cleaning_target
		return

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
			path -= path[1]
			return TRUE

		//Something blocked us, look for a different target, we might come back to this in a while
		else
			for(var/obj/machinery/door/a_door in path[1])
				if(last_movement_failure_turf != path[1])
					last_movement_failure_turf = path[1]
					return

				//This is the second failure, invalidate the target
				else
					ignorelist |= cleaning_target
					cleaning_target_cache.clean_marked = null
					cleaning_target = null
					path = list()
					break



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
		ignorelist += gib
		addtimer(CALLBACK(src, PROC_REF(remove_from_ignore), gib), 600)

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

	//We have a path to a target already, follow it
	if(length(path))
		handle_target()

	//Otherwise, look around for a target, or patrol
	else

		//If we could a spot to clean or not
		var/found_spot

		for(var/obj/effect/decal/cleanable/D in view(maximum_search_range, src))
			var/datum/weakref/cleanable_weakref = WEAKREF(D)

			var/mob/living/bot/cleanbot/turf_targeting_cleanbot = D.clean_marked?.resolve()

			//Someone already wants this cleanable and it's not us, keep looking
			if(!isnull(turf_targeting_cleanbot) && turf_targeting_cleanbot != src)
				continue

			var/mob/living/bot/cleanbot/other_bot = locate() in get_turf(D)
			if(other_bot && other_bot.cleaning && other_bot != src)
				continue

			// If the object has been slated to be ignored we continue the loop.
			if((cleanable_weakref in ignorelist))
				continue

			// A matching /cleanable was found, now we want to path trace to it and see if we can reach it.
			if((D.type in target_types))
				patrol_path = list()
				cleaning_target = cleanable_weakref
				D.clean_marked = WEAKREF(src)
				found_spot = handle_target()
				if(found_spot)
					break // If the target location is found and pathed properly, break the search loop.
				else
					cleaning_target = null // Otherwise we want to try the next cleanable in view, if any.
					D.clean_marked = null


		if(!found_spot && !cleaning_target) // No targets in range
			if(!patrol_path || !patrol_path.len)
				if(!signal_sent || signal_sent > world.time + 200) // Waited enough or didn't send yet
					var/datum/radio_frequency/frequency = SSradio.return_frequency(beacon_freq)
					if(!frequency)
						return

					closest_dist = 9999
					next_dest = null
					next_dest_loc = null

					var/datum/signal/signal = new()
					signal.source = src
					signal.transmission_method = TRANSMISSION_RADIO
					signal.data = list("findbeacon" = "patrol")
					frequency.post_signal(src, signal, filter = RADIO_NAVBEACONS)
					signal_sent = world.time
				else
					if(next_dest)
						next_dest_loc = listener.memorized[next_dest]
						if(next_dest_loc)
							patrol_path = get_path_to(loc, next_dest_loc, 120, 0, botcard.GetAccess(), diagonal_handling=DIAGONAL_REMOVE_ALL)
							signal_sent = 0
			else if(should_patrol)
				if(patrol_path[1] == loc)
					patrol_path -= patrol_path[1]
					return

				var/moved = step_towards(src, patrol_path[1])
				if(moved)
					patrol_path -= patrol_path[1]


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
	if(D)
		if(istype(D.loc, /turf/simulated))
			var/turf/simulated/f = loc
			f.dirt = 0

		if(!D)
			return

		D.clean_marked = null
		D.being_cleaned = FALSE
		cleaning_target = null

		qdel(D)

	cleaning = FALSE
	update_icon()

/mob/living/bot/cleanbot/explode()
	on = FALSE // the first thing i do when i explode is turn off, tbh - geeves
	visible_message(SPAN_WARNING("[src] blows apart!"))
	var/turf/T = get_turf(src)
	new /obj/item/reagent_containers/glass/bucket(T)
	new /obj/item/device/assembly/prox_sensor(T)
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

		if("set_frequency")
			var/new_frequency = tgui_input_number(usr, "Select frequency for navigation beacons", "Frequnecy", (beacon_freq/10), round_value = FALSE)
			if(new_frequency > 0)
				SSradio.remove_object(listener, beacon_freq)
				beacon_freq = new_frequency*10
				SSradio.add_object(listener, beacon_freq, RADIO_NAVBEACONS)

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
	closest_dist = initial(closest_dist)
	patrol_path.Cut()

	if(state)
		should_patrol = TRUE
		patrol_path = list()
		signal_sent = 0

	else
		should_patrol = FALSE

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

/* Radio object that listens to signals */

/obj/cleanbot_listener
	var/mob/living/bot/cleanbot/cleanbot = null
	var/list/memorized = list()

/obj/cleanbot_listener/receive_signal(var/datum/signal/signal)
	var/recv = signal.data["beacon"]
	var/valid = signal.data["patrol"]
	if(!recv || !valid || !cleanbot)
		return

	var/turf/signal_sender_turf = get_turf(signal.source)
	var/turf/our_cleanbot_turf = get_turf(cleanbot)

	//Nullspace, some other shit, either way, abort
	if(!istype(signal_sender_turf) || !istype(our_cleanbot_turf))
		return

	//At the moment, the path system does not understand zlevels, so this only works on the same zlevel, deal with it, then you can just turn this into:
	// if(!AreConnectedZLevels(signal.source.loc?.z, cleanbot.loc?.z))
	if(signal_sender_turf.z != our_cleanbot_turf.z)
		return

	var/dist = get_dist(cleanbot, signal_sender_turf)
	memorized[recv] = signal_sender_turf

	if(dist < cleanbot.closest_dist) // We check all signals, choosing the closest beacon; then we move to the NEXT one after the closest one
		cleanbot.closest_dist = dist
		cleanbot.next_dest = signal.data["next_patrol"]

/obj/cleanbot_listener/Destroy()
	cleanbot = null
	SSradio.remove_object_all(src)
	return ..()

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
	else if(attacking_item.ispen())
		var/t = sanitizeSafe( tgui_input_text(user, "Enter new robot name", name, created_name, MAX_NAME_LEN), MAX_NAME_LEN )
		if(!t)
			return
		if(!in_range(src, usr) && src.loc != usr)
			return
		created_name = t
