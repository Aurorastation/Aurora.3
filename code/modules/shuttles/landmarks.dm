//making this separate from /obj/effect/landmark until that mess can be dealt with
/obj/effect/shuttle_landmark
	name = "Nav Point"
	icon = 'icons/effects/map_effects_96x96.dmi'
	icon_state = "shuttle_landmark"
	anchored = TRUE
	unacidable = TRUE
	simulated = 0
	invisibility = 101
	layer = ABOVE_ALL_MOB_LAYER
	pixel_x = -32
	pixel_y = -32

	var/landmark_tag
	//ID of the controller on the dock side
	var/datum/computer/file/embedded_program/docking/docking_controller
	//ID of controller used for this landmark for shuttles with multiple ones.
	var/list/special_dock_targets

	//when the shuttle leaves this landmark, it will leave behind the base area
	//also used to determine if the shuttle can arrive here without obstruction
	var/area/base_area
	//Will also leave this type of turf behind if set.
	var/turf/base_turf
	//Name of the shuttle, null for generic waypoint
	var/shuttle_restricted
	var/landmark_flags = 0

	/// Effects that show where the shuttle will land, to prevent unfair squishing
	var/list/landing_indicators

/obj/effect/shuttle_landmark/Initialize()
	. = ..()
	name = name + " ([x],[y])"
	SSshuttle.register_landmark(landmark_tag, src)
	return INITIALIZE_HINT_LATELOAD

/obj/effect/shuttle_landmark/LateInitialize()
	if(landmark_flags & SLANDMARK_FLAG_AUTOSET)
		base_area = get_area(src)
		var/turf/T = get_turf(src)
		if(T)
			base_turf = T.type
	else
		base_area = locate(base_area || world.area)

	if(!docking_controller)
		return
	var/docking_tag = docking_controller
	if(!istype(docking_controller))
		docking_controller = SSshuttle.docking_registry[docking_tag]
		if(!istype(docking_controller))
			LOG_DEBUG("Could not find docking controller for shuttle waypoint '[name]', docking tag was '[docking_tag]'.")

/obj/effect/shuttle_landmark/forceMove()
	var/obj/effect/overmap/visitable/map_origin = map_sectors["[z]"]
	. = ..()
	var/obj/effect/overmap/visitable/map_destination = map_sectors["[z]"]
	if(map_origin != map_destination)
		if(map_origin)
			map_origin.remove_landmark(src, shuttle_restricted)
		if(map_destination)
			map_destination.add_landmark(src, shuttle_restricted)

//Called when the landmark is added to an overmap sector.
/obj/effect/shuttle_landmark/proc/sector_set(var/obj/effect/overmap/visitable/O, shuttle_name)
	shuttle_restricted = shuttle_name

/obj/effect/shuttle_landmark/proc/is_valid(var/datum/shuttle/shuttle)
	if(shuttle.current_location == src)
		return FALSE
	for(var/area/A in shuttle.shuttle_area)
		var/list/translation = get_turf_translation(get_turf(shuttle.current_location), get_turf(src), A.contents)
		if(check_collision(base_area, list_values(translation)))
			return FALSE
	var/conn = GetConnectedZlevels(z)
	for(var/w in (z - shuttle.multiz) to z)
		if(!(w in conn))
			return FALSE
	return TRUE

/obj/effect/shuttle_landmark/proc/deploy_landing_indicators(var/datum/shuttle/shuttle)
	LAZYINITLIST(landing_indicators)
	for(var/area/A in shuttle.shuttle_area)
		var/list/translation = get_turf_translation(get_turf(shuttle.current_location), get_turf(src), A.contents)
		for(var/target_turf in list_values(translation))
			landing_indicators += new /obj/effect/shuttle_warning(target_turf)

/obj/effect/shuttle_landmark/proc/clear_landing_indicators()
	QDEL_NULL_LIST(landing_indicators) // lazyclear but we delete the effects as well

/obj/effect/shuttle_landmark/proc/cannot_depart(datum/shuttle/shuttle)
	return FALSE

/obj/effect/shuttle_landmark/proc/shuttle_arrived(datum/shuttle/shuttle)
	clear_landing_indicators()

/proc/check_collision(area/target_area, list/target_turfs)
	for(var/target_turf in target_turfs)
		var/turf/target = target_turf
		if(!target)
			return TRUE //collides with edge of map
		if(target.loc != target_area)
			return TRUE //collides with another area
		if(target.density)
			return TRUE //dense turf
	return FALSE

//Self-naming/numbering ones.
/obj/effect/shuttle_landmark/automatic
	name = "Navpoint"
	landmark_tag = "navpoint"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

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

//Subtype that calls explosion on init to clear space for shuttles
/obj/effect/shuttle_landmark/automatic/clearing
	dir = NORTH // compatible with Horizon's shuttles
	var/radius = LANDING_ZONE_RADIUS

/obj/effect/shuttle_landmark/automatic/clearing/LateInitialize()
	// with directional shuttle landmarks, the landmark is at the airlock of the shuttle,
	// so the shuttle extends south from this automatic landmark,
	// and and so we explode around not this landmark,
	// but instead around where the center of shuttle could be
	var/turf/C = locate(src.x, src.y - LANDING_ZONE_RADIUS, src.z)
	for(var/turf/T in RANGE_TURFS(LANDING_ZONE_RADIUS, C))
		if(T.density)
			T.ChangeTurf(get_base_turf_by_area(T))
		for(var/obj/structure/S in T)
			qdel(S)
	..()

/obj/item/device/spaceflare
	name = "bluespace flare"
	desc = "Burst transmitter used to broadcast all needed information for shuttle navigation systems. Has a flare attached for marking the spot where you probably shouldn't be standing."
	icon_state = "bluflare"
	light_color = "#3728ff"
	var/active

/obj/item/device/spaceflare/attack_self(var/mob/user)
	if(!active)
		visible_message("<span class='notice'>[user] pulls the cord, activating \the [src].</span>")
		activate()

/obj/item/device/spaceflare/proc/activate()
	if(active)
		return
	var/turf/T = get_turf(src)
	var/mob/M = loc
	if(istype(M) && !M.unEquip(src, T))
		return

	active = 1
	anchored = 1

	var/obj/effect/shuttle_landmark/automatic/mark = new(T)
	mark.name = "beacon signal ([T.x],[T.y])"
	T.hotspot_expose(1500, 5)
	update_icon()

/obj/item/device/spaceflare/update_icon()
	if(active)
		icon_state = "bluflare_on"
		set_light(0.3, 0.1, 6, 2, "85d1ff")

//This one activates away site ghostroles on the z-level.
/obj/effect/shuttle_landmark/automatic/ghostrole_activation
	var/triggered_away_sites = FALSE
	var/landmark_position

/obj/effect/shuttle_landmark/automatic/ghostrole_activation/shuttle_arrived(datum/shuttle/shuttle)
	. = ..()
	if(!triggered_away_sites && !isStationLevel(loc.z))
		for(var/s in SSghostroles.spawners)
			var/datum/ghostspawner/G = SSghostroles.spawners[s]
			for(var/obj/effect/ghostspawpoint/L in SSghostroles.spawnpoints[s])
				landmark_position = L.loc.z
			if(landmark_position == src.loc.z)
				if(!(G.enabled))
					G.enable()
		triggered_away_sites = TRUE
