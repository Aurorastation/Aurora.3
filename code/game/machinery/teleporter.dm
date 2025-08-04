/obj/machinery/teleport
	name = "teleport"
	icon = 'icons/obj/teleporter.dmi'
	density = TRUE
	anchored = TRUE

/obj/machinery/teleport/pad
	name = "teleporter pad"
	desc = "It's the pad of a teleporting machine."
	icon_state = "pad"
	idle_power_usage = 10
	active_power_usage = 2000

	light_color = "#02d1c7"

	var/datum/weakref/locked_obj
	var/locked_obj_name

	var/max_teleport_range = 4 //max overmap teleport distance
	var/calibration = 0 // a percentage chance for teleporting into space instead of your target. 0 is perfectly calibrated, 100 is totally uncalibrated
	var/engaged = FALSE
	var/ignore_distance = FALSE // For antag teleporters.

/obj/machinery/teleport/pad/Initialize()
	. = ..()
	queue_icon_update()

/obj/machinery/teleport/pad/process()
	var/old_engaged = engaged
	if(locked_obj)
		if(stat & (NOPOWER|BROKEN) || !within_range(locked_obj))
			engaged = FALSE
		else
			engaged = TRUE
	if(old_engaged != engaged)
		update_icon()

/obj/machinery/teleport/pad/CollidedWith(atom/bumped_atom)
	. = ..()

	if(engaged)
		teleport(bumped_atom)
		use_power_oneoff(5000)

/obj/machinery/teleport/pad/proc/teleport(atom/movable/M as mob|obj)
	if(!locked_obj)
		audible_message(SPAN_WARNING("Failure: Cannot authenticate locked on coordinates. Please reinstate coordinate matrix."))
	var/obj/teleport_obj = locked_obj.resolve()
	if(!teleport_obj)
		locked_obj = null
		return
	if(prob(calibration)) //oh dear a problem, put em in deep space
		do_teleport(M, locate(rand((2*TRANSITIONEDGE), world.maxx - (2*TRANSITIONEDGE)), rand((2*TRANSITIONEDGE), world.maxy - (2*TRANSITIONEDGE)), pick(GetConnectedZlevels(z))), 2)
	else
		do_teleport(M, teleport_obj) //dead-on precision
	if(ishuman(M))
		calibration = min(calibration + 5, 100)

/obj/machinery/teleport/pad/update_icon()
	ClearOverlays()
	if (engaged)
		var/image/I = image(icon, src, "[initial(icon_state)]_active_overlay")
		I.plane = EFFECTS_ABOVE_LIGHTING_PLANE
		AddOverlays(I)
		set_light(4, 0.4)
	else
		set_light(0)
		if (operable())
			var/image/I = image(icon, src, "[initial(icon_state)]_idle_overlay")
			I.plane = EFFECTS_ABOVE_LIGHTING_PLANE
			AddOverlays(I)

/obj/machinery/teleport/pad/proc/within_range(var/target)
	if(ignore_distance)
		return TRUE
	if (isweakref(target))
		var/datum/weakref/target_ref = target
		target = target_ref.resolve()
	var/turf/T = get_turf(target)
	if(T)
		if (AreConnectedZLevels(z, T.z))
			return TRUE
		else if(SSatlas.current_map.use_overmap)
			var/my_sector = GLOB.map_sectors["[z]"]
			var/target_sector = GLOB.map_sectors["[T.z]"]
			if (istype(my_sector, /obj/effect/overmap/visitable) && istype(target_sector, /obj/effect/overmap/visitable))
				if(get_dist(my_sector, target_sector) < max_teleport_range)
					return TRUE

/obj/machinery/teleport/pad/proc/engage()
	if(stat & (BROKEN|NOPOWER))
		return

	use_power_oneoff(5000)
	update_use_power(POWER_USE_ACTIVE)
	visible_message(SPAN_NOTICE("Teleporter engaged!"))
	add_fingerprint(usr)
	engaged = TRUE
	queue_icon_update()

/obj/machinery/teleport/pad/proc/disengage()
	if(stat & (BROKEN|NOPOWER))
		return

	update_use_power(POWER_USE_IDLE)
	locked_obj = null
	locked_obj_name = null
	visible_message(SPAN_NOTICE("Teleporter disengaged!"))
	engaged = FALSE
	queue_icon_update()

/obj/machinery/teleport/pad/power_change()
	..()
	queue_icon_update()

/obj/machinery/teleport/pad/proc/start_recalibration()
	audible_message(SPAN_NOTICE("Recalibrating..."))
	addtimer(CALLBACK(src, PROC_REF(recalibrate)), 5 SECONDS, TIMER_UNIQUE)

/obj/machinery/teleport/pad/proc/recalibrate()
	calibration = 0
	audible_message(SPAN_NOTICE("Calibration complete."))

/obj/machinery/teleport/pad/ninja
	ignore_distance = TRUE

// -------------- odyssey teleporter

/// Teleports actors to the odyssey scenario away site.
/// Uses holomap POIs as possible destinations.
/obj/machinery/teleport_odyssey
	name = "actor teleport pad"
	desc = "Teleports odyssey actors to the odyssey scenario away site. Very convenient."
	icon = 'icons/obj/teleporter.dmi'
	icon_state = "pad_active"
	density = TRUE
	anchored = TRUE

/obj/machinery/teleport_odyssey/attack_hand(mob/user)
	// find valid POIs for the odyssey scenario site
	var/list/obj/effect/landmark/minimap_poi/possible_pois = list()
	for(var/obj/effect/landmark/minimap_poi/poi in SSholomap.pois)
		if(poi.z in SSodyssey.scenario_zlevels)
			possible_pois += poi
	if(!length(possible_pois))
		tgui_alert(user, "Can't find any teleport destinations.", "Teleport Error")

	// actor check for id access
	if(length(SSodyssey.scenario?.actor_accesses))
		// check if they have an id at all
		var/obj/item/card/id/user_id = user.GetIdCard()
		if(!user_id || !istype(user_id))
			var/choice = tgui_alert(user,
				"Current odyssey scenario has defined ID access, but you do not seem to have an ID on you. You can get one from the actor vendor.",
				"Teleport Warning", list("Continue Teleport", "Cancel Teleport")
			)
			if(choice != "Continue Teleport")
				return

		// check if they have actor accesses set on the scenario definition
		var/list/scenario_access_ids = list()
		for(var/datum/access/access_datum as anything in SSodyssey.scenario.actor_accesses)
			scenario_access_ids += access_datum::id
		if(isemptylist(user_id.access & scenario_access_ids))
			var/choice = tgui_alert(user,
				"Current odyssey scenario has defined ID access, but you do not seem to have an ID with any such access. You can change access of your ID using the actor access terminal.",
				"Teleport Warning", list("Continue Teleport", "Cancel Teleport")
			)
			if(choice != "Continue Teleport")
				return

	// actor check for radio headset
	if(SSodyssey.scenario?.radio_frequency_name)
		var/mob/living/living = user
		if(istype(living) && !living.check_contents_for(/obj/item/device/radio/headset/ship/odyssey))
			var/choice = tgui_alert(user,
				"Current odyssey scenario has defined radio channel, but you do not seem to have a headset that can transmit that channel. You can get one from the actor vendor.",
				"Teleport Warning", list("Continue Teleport", "Cancel Teleport")
			)
			if(choice != "Continue Teleport")
				return

	// ask the user
	var/obj/effect/landmark/minimap_poi/poi = tgui_input_list(user,
		"Choose teleport destination, to go to the odyssey scenario site. You cannot go back to this area after teleporting.", "Teleport Destination",
		possible_pois
	)

	// teleport them
	if(poi)
		user.forceMove(get_turf(poi))
