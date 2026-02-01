//making this separate from /obj/effect/landmark until that mess can be dealt with
/obj/effect/shuttle_landmark
	name = "Nav Point"
	/**
	 * Preserves the original name without appended coordinates
	 *
	 * Set in `/obj/effect/shuttle_landmark/Initialize()`
	 */
	var/clean_name = "Nav Point"
	icon = 'icons/effects/map_effects_96x96.dmi'
	icon_state = "shuttle_landmark"
	anchored = TRUE
	unacidable = TRUE
	simulated = 0
	invisibility = 101
	layer = ABOVE_HUMAN_LAYER
	pixel_x = -32
	pixel_y = -32

	var/landmark_tag
	//ID of the controller on the dock side
	var/datum/computer/file/embedded_program/docking/docking_controller
	//ID of controller used for this landmark for shuttles with multiple ones.
	var/list/special_dock_targets

	//Name of the shuttle, null for generic waypoint
	var/shuttle_restricted

	/// Effects that show where the shuttle will land, to prevent unfair squishing
	var/list/landing_indicators

	/// List of ghostspawners to activate on shuttle arrival.
	/// Arrival, means any shuttle that arrives and calls `shuttle_arrived()`.
	/// Ghostspawners, means their `short_name` vars.
	var/list/ghostspawners_to_activate_on_shuttle_arrival

	/**
	 * If TRUE, announces docking over the `announce_channel` frequency
	 *
	 * Checked in `/obj/effect/shuttle_landmark/proc/shuttle_arrived` and `/obj/effect/shuttle_landmark/proc/shuttle_departure`
	 */
	var/announce_docking = FALSE

	/**
	 * Determines which frequency to announce docking over if `announce_docking` is `TRUE`
	 */
	var/announce_channel = "Common"

	/// /datum/shuttle currently inhabiting this landmark, if any
	var/datum/shuttle/occupant

	var/area_type

	var/override_landing_checks = FALSE

	///Delete this landmark after ship fly off.
	var/delete_after = FALSE

/obj/effect/shuttle_landmark/Initialize()
	. = ..()
	clean_name = name
	name = name + " ([x],[y])"
	SSshuttle.register_landmark(landmark_tag, src)
	if(!area_type)
		var/area/place = get_area(src)
		area_type = place?.type // We might be created in nullspace
	return INITIALIZE_HINT_LATELOAD

/obj/effect/shuttle_landmark/Destroy()
	docking_controller = null
	occupant = null
	return ..()

/obj/effect/shuttle_landmark/LateInitialize()
	AddComponent(/datum/component/bounding/bfs)

	if(!docking_controller)
		return
	var/docking_tag = docking_controller
	if(!istype(docking_controller))
		docking_controller = SSshuttle.docking_registry[docking_tag]
		if(!istype(docking_controller))
			LOG_DEBUG("Could not find docking controller for shuttle waypoint '[name]', docking tag was '[docking_tag]'.")

/obj/effect/shuttle_landmark/forceMove(atom/destination)
	var/obj/effect/overmap/visitable/map_origin = GLOB.map_sectors["[z]"]
	. = ..()
	var/obj/effect/overmap/visitable/map_destination = GLOB.map_sectors["[z]"]
	if(map_origin != map_destination)
		if(map_origin)
			map_origin.remove_landmark(src, shuttle_restricted)
		if(map_destination)
			map_destination.add_landmark(src, shuttle_restricted)

//Called when the landmark is added to an overmap sector.
/obj/effect/shuttle_landmark/proc/sector_set(var/obj/effect/overmap/visitable/O, shuttle_name)
	shuttle_restricted = shuttle_name

/obj/effect/shuttle_landmark/proc/deploy_landing_indicators(datum/shuttle/shuttle)
	LAZYINITLIST(landing_indicators)
	var/list/turfs = get_landing_area(shuttle)
	for(var/t in turfs)
		landing_indicators += new /obj/effect/shuttle_warning(t)

/obj/effect/shuttle_landmark/proc/clear_landing_indicators()
	QDEL_LIST(landing_indicators) // lazyclear but we delete the effects as well

/obj/effect/shuttle_landmark/proc/get_landing_area(datum/shuttle/shuttle)
	var/datum/component/bounding/bfs/lz_bounds = GetComponent(/datum/component/bounding/bfs)
	var/obj/effect/overmap/visitable/ship/landable/ovr = shuttle.overmap_shuttle
	var/list/L0 = lz_bounds.return_ordered_turfs(x, y, z, dir)
	var/list/L1 = lz_bounds.return_ordered_turfs(ovr.x, ovr.y, ovr.z, ovr.dir)

	var/list/landing_turfs = list()
	var/stop = min(L0.len, L1.len)
	for(var/i in 1 to stop)
		var/turf/T0 = L0[i]
		var/turf/T1 = L1[i]
		if(!(T0.loc in shuttle.shuttle_area) || istype(T0.loc, /area/shuttle/transit))
			continue  // not part of the shuttle
		landing_turfs += T1

	return landing_turfs

/obj/effect/shuttle_landmark/proc/cannot_depart(datum/shuttle/shuttle)
	return FALSE

/obj/effect/shuttle_landmark/proc/activate_ghostroles()
	if(!islist(ghostspawners_to_activate_on_shuttle_arrival))
		return
	for(var/spawner_name in ghostspawners_to_activate_on_shuttle_arrival)
		var/datum/ghostspawner/spawner = SSghostroles.spawners[spawner_name]
		if(istype(spawner))
			INVOKE_ASYNC(spawner, TYPE_PROC_REF(/datum/ghostspawner, enable))

/obj/effect/shuttle_landmark/proc/shuttle_inbound(datum/shuttle/shuttle)
	RegisterSignal(shuttle, COMSIG_SHUTTLE_INBOUND, PROC_REF(shuttle_arrived))

/obj/effect/shuttle_landmark/proc/shuttle_arrived(datum/shuttle/shuttle)
	SIGNAL_HANDLER
	UnregisterSignal(shuttle, COMSIG_SHUTTLE_INBOUND)
	clear_landing_indicators()
	activate_ghostroles()
	occupant = shuttle
	if(announce_docking)
		var/datum/shuttle/multi/antag/antag_shuttle
		if(istype(shuttle, /datum/shuttle/multi/antag))
			antag_shuttle = shuttle
		if(!antag_shuttle || (antag_shuttle && !antag_shuttle.cloaked))
			var/message = "[shuttle.name] has docked at [src.clean_name]."
			GLOB.global_announcer.autosay(message, "Docking Oversight", announce_channel)
	RegisterSignal(shuttle, COMSIG_SHUTTLE_OUTBOUND, PROC_REF(shuttle_departed))

/obj/effect/shuttle_landmark/proc/shuttle_departed(datum/shuttle/shuttle)
	SIGNAL_HANDLER
	occupant = null
	if(announce_docking)
		var/datum/shuttle/multi/antag/antag_shuttle
		if(istype(shuttle, /datum/shuttle/multi/antag))
			antag_shuttle = shuttle
		if(!antag_shuttle || (antag_shuttle && !antag_shuttle.cloaked))
			var/message = "[shuttle.name] has undocked from [src.clean_name]."
			GLOB.global_announcer.autosay(message, "Docking Oversight", announce_channel)
	UnregisterSignal(shuttle, COMSIG_SHUTTLE_OUTBOUND)

/proc/check_collision(list/target_turfs)
	for(var/target_turf in target_turfs)
		var/turf/target = target_turf

		if(!target)
			return TRUE //collides with edge of map

		// IMPORTANT: The below area check is commented out as it is not compatible with the Horizon,
		// which has docking ports with clashing turfs + areas! There's no good reason for this not to
		// be re-enabled once the server's primary map doesn't have such poorly mapped docking ports.
		// It being disabled shouldn't cause too many problems in the meantime. Hopefully.
		// if(target.loc != target_area)
		// 	return TRUE //clashes with another area

		if(target.density)
			return TRUE //dense turf

	return FALSE

//Self-naming/numbering ones.
/obj/effect/shuttle_landmark/automatic
	name = "Navpoint"
	landmark_tag = "navpoint"

/obj/effect/shuttle_landmark/automatic/Initialize()
	landmark_tag += "-[x]-[y]-[z]"
	return ..()

/obj/effect/shuttle_landmark/automatic/sector_set(var/obj/effect/overmap/visitable/O)
	..()
	name = "[initial(name)] ([x],[y])"

//Subtypes for exclusively Horizon shuttles
/obj/effect/shuttle_landmark/automatic/intrepid/sector_set(var/obj/effect/overmap/visitable/O)
	..()
	name = "SCCV Intrepid Landing Beacon ([x],[y])"

/obj/effect/shuttle_landmark/automatic/spark/sector_set(var/obj/effect/overmap/visitable/O)
	..()
	name = "SCCV Spark Landing Beacon ([x],[y])"

/obj/effect/shuttle_landmark/automatic/canary/sector_set(var/obj/effect/overmap/visitable/O)
	..()
	name = "SCCV Canary Landing Beacon ([x],[y])"

/obj/effect/shuttle_landmark/transit
	name = "In Transit"
	landmark_tag = "transit"
	var/datum/turf_reservation/reserved_area
	var/area/shuttle/transit/assigned_area
	var/datum/shuttle/owner

	var/spawn_time

	delete_after = TRUE

/obj/effect/shuttle_landmark/transit/Initialize()
	landmark_tag += "-[SSshuttle.transit.len + 1]"
	. = ..()
	SSshuttle.transit += src
	spawn_time = world.time

/obj/effect/shuttle_landmark/transit/Destroy(force = FALSE)
	if(force)
		if(occupant)
			log_world("A transit landmark was destroyed while a shuttle was occupying it.")
		SSshuttle.transit -= src
		if(owner)
			if(owner.assigned_transit == src)
				log_world("A transit landmark was qdeled while it was assigned to [owner].")
				owner.assigned_transit = null
			owner = null
		if(!QDELETED(reserved_area))
			qdel(reserved_area)
		reserved_area = null
	return ..()

//Subtype that calls explosion on init to clear space for shuttles
/obj/effect/shuttle_landmark/automatic/clearing
	dir = NORTH // compatible with Horizon's shuttles
	var/radius = LANDING_ZONE_RADIUS

/obj/effect/shuttle_landmark/automatic/clearing/LateInitialize()
	var/turf/C = locate(src.x, src.y, src.z)
	for(var/turf/T in RANGE_TURFS(LANDING_ZONE_RADIUS, C))
		if(T.density)
			T.scrape_away()
		for(var/obj/structure/S in T)
			qdel(S)
	..()

/obj/item/spaceflare
	name = "bluespace flare"
	desc = "Burst transmitter used to broadcast all needed information for shuttle navigation systems. Has a flare attached for marking the spot where you probably shouldn't be standing."
	icon = 'icons/obj/space_flare.dmi'
	icon_state = "bluflare"
	light_color = "#3728ff"
	origin_tech = list(TECH_BLUESPACE = 4, TECH_MAGNET = 3, TECH_DATA = 2)
	/// Boolean. Whether or not the spaceflare has been activated.
	var/active = FALSE
	/// The shuttle landmark synced to this beacon. This is set when the beacon is activated.
	var/obj/effect/shuttle_landmark/automatic/spaceflare/landmark

/obj/item/spaceflare/attack_self(var/mob/user)
	if(activate(user))
		user.visible_message(SPAN_NOTICE("\The [user] pulls the cord, activating \the [src]."), SPAN_NOTICE("You pull the cord, activating \the [src]."), SPAN_ITALIC("You hear the sound of something being struck and ignited."))

/obj/item/spaceflare/proc/activate(mob/user)
	if(active)
		to_chat(user, SPAN_WARNING("\The [src] is already active."))
		return FALSE
	var/turf/T = get_turf(src)
	if(isspaceturf(T) || isopenspace(T))
		to_chat(user, SPAN_WARNING("\The [src] needs to be activated on solid ground."))
		return FALSE
	if(istype(user) && !user.unEquip(src, T))
		return FALSE
	if(loc != T)
		return FALSE

	active = TRUE
	anchored = TRUE

	log_and_message_admins("activated a bluespace flare in [get_area(src)]", user, get_turf(src))
	landmark = new(T, src)
	update_icon()
	return TRUE

/obj/item/spaceflare/proc/deactivate(silent = FALSE)
	if (!active)
		return FALSE

	active = FALSE
	anchored = FALSE
	QDEL_NULL(landmark)
	update_icon()
	if (!silent)
		visible_message(SPAN_WARNING("\The [src] stops burning and deactivates."))
	return TRUE

/obj/item/spaceflare/update_icon()
	if (active)
		icon_state = "[initial(icon_state)]_on"
		set_light(0.3, 0.1, 6, 2, "85d1ff")
	else
		icon_state = initial(icon_state)
		set_light(0)

/obj/item/spaceflare/Destroy()
	deactivate(TRUE)
	. = ..()

/obj/item/spaceflare/attack_hand(mob/user)
	if(active)
		var/choice = tgui_alert(user, "Do you want to deactivate \the [src]?", "Bluespace Flare", list("Yes","No"))
		if(choice == "Yes")
			user.visible_message(SPAN_NOTICE("\The [user] presses a button, deactivating \the [src]'s signal"), SPAN_NOTICE("You press a button on the side of \the [src], shutting down its signal."), SPAN_ITALIC("You hear the sound of a flare fizzling out."))
			deactivate()
	else
		..()

//Activated by a bluespace flare
/obj/effect/shuttle_landmark/automatic/spaceflare
	name = "Bluespace Beacon Signal"
	/// The beacon object synced to this landmark. If this is ever null or qdeleted the landmark should delete itself.
	var/obj/item/spaceflare/beacon

/obj/effect/shuttle_landmark/automatic/spaceflare/Initialize(mapload, obj/item/spaceflare/beacon)
	. = ..()

	if(!istype(beacon))
		stack_trace("\A [src] was initialized with an invalid or nonexistent beacon.")
		return INITIALIZE_HINT_QDEL

	if(beacon.landmark && beacon.landmark != src)
		stack_trace("\A [src] was initialized with a beacon that already has a synced landmark.")
		return INITIALIZE_HINT_QDEL

	src.beacon = beacon
	RegisterSignal(beacon, COMSIG_MOVABLE_MOVED, PROC_REF(update_beacon_moved), TRUE)
	//GLOB.moved_event.register(beacon, src, /obj/effect/shuttle_landmark/automatic/spaceflare/proc/update_beacon_moved)

/obj/effect/shuttle_landmark/automatic/spaceflare/Destroy()
	UnregisterSignal(beacon, COMSIG_MOVABLE_MOVED)
	//GLOB.moved_event.unregister(beacon, src, /obj/effect/shuttle_landmark/automatic/spaceflare/proc/update_beacon_moved)
	if (beacon?.active)
		stack_trace("\A [src] was destroyed with a still active beacon.")
		beacon.deactivate()
	beacon = null
	. = ..()

/obj/effect/shuttle_landmark/automatic/spaceflare/proc/update_beacon_moved(atom/movable/moving_instance, atom/old_loc, atom/new_loc)
	if(!isturf(new_loc) || isspaceturf(new_loc) || isopenturf(new_loc))
		stack_trace("\A [src]'s beacon was moved to a non-turf or unacceptable location.")
		beacon.deactivate()
		return
	forceMove(new_loc)
	name = "[initial(name)] ([x],[y])"

//This one activates away site ghostroles on the z-level.
/obj/effect/shuttle_landmark/automatic/ghostrole_activation
	var/triggered_away_sites = FALSE
	var/landmark_position

/obj/effect/shuttle_landmark/automatic/ghostrole_activation/shuttle_arrived(datum/shuttle/shuttle)
	. = ..()
	if(!triggered_away_sites && !is_station_level(loc.z))
		for(var/s in SSghostroles.spawners)
			var/datum/ghostspawner/G = SSghostroles.spawners[s]
			for(var/obj/effect/ghostspawpoint/L in SSghostroles.spawnpoints[s])
				landmark_position = L.loc.z
			if(landmark_position == src.loc.z)
				if(!(G.enabled))
					INVOKE_ASYNC(G, TYPE_PROC_REF(/datum/ghostspawner, enable))
		triggered_away_sites = TRUE
