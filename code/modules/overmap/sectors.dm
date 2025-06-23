//===================================================================================
//Overmap object representing zlevel(s)
//===================================================================================
/// Global object used to locate the overmap area.
GLOBAL_DATUM(map_overmap, /area/overmap)

/obj/effect/overmap/visitable
	name = "map object"
	scannable = TRUE
	sensor_range_override = TRUE
	/// Actual name of the object.
	var/designation
	/// Imagine a ship or station's class. "NTCC" Odin, "SCCV" Horizon, ...
	var/class
	unknown_id = "Bogey"
	var/obfuscated_name = "unidentified object"
	var/obfuscated_desc = "This object is not displaying its IFF signature."
	/// Whether we hide our name and class or not.
	var/obfuscated = FALSE

	/// Landmark tags of landmarks that should be added to the actual lists below on init.
	/// Generic, meaning usable by any shuttle.
	/// Can contain nested lists, as it is flattened on init.
	var/list/initial_generic_waypoints
	/// Restricted, meaning that only specific shuttles can use them.
	/// Should be an assoc list like `list("Shuttle" = list("nav_landmark_tag"), ...)`
	var/list/initial_restricted_waypoints
	/// Landmark tags of landmarks of docks that will be tracked in the docks computer program.
	/// Can contain nested lists, as it is flattened on init.
	var/list/tracked_dock_tags

	/// Waypoints that any shuttle can use
	var/list/generic_waypoints = list()
	/// Waypoints for specific shuttles
	var/list/restricted_waypoints = list()

	/// Coordinates for self placing
	var/start_x
	/// Will use random values if unset
	var/start_y

	/// Starting sector, counts as station_levels
	var/base = FALSE
	/// Can be accessed via lucky EVA
	var/in_space = TRUE

	var/has_called_distress_beacon = FALSE
	var/image/applied_distress_overlay

	var/targeting_flags = TARGETING_FLAG_ENTRYPOINTS|TARGETING_FLAG_GENERIC_WAYPOINTS
	var/list/obj/machinery/ship_weapon/ship_weapons
	var/list/obj/effect/landmark/entry_points
	var/obj/effect/overmap/targeting
	var/obj/machinery/leviathan_safeguard/levi_safeguard
	var/obj/machinery/gravity_generator/main/gravity_generator

	/// Whether ghostroles attached to this overmap object spawn with comms
	var/comms_support = FALSE
	/// Snowflake name to apply to comms equipment ("shipboard radio headset", "intercom (shipboard)", "shipboard telecommunications mainframe"), etc.
	var/comms_name = "shipboard"
	/// Snowflake name to label frequency, if not set, frequency defaults to overmap name
	var/freq_name = ""
	/// Whether away ship comms have access to the common channel / PUB_FREQ
	var/use_common = FALSE
	/// list of weakrefs to people viewing the overmap via this ship
	var/list/navigation_viewers
	var/list/consoles

	/// A list of datalink requests that we received
	var/list/datalink_requests = list()
	/// Other effects that we are datalinked with
	var/list/datalinked        = list()

	/// null | num | list. If a num or a (num, num) list, the radius or random bounds for placing this sector near the main map's overmap icon.
	var/list/place_near_main

	var/invisible_until_ghostrole_spawn = FALSE
	var/hide_from_reports = FALSE

/obj/effect/overmap/visitable/Initialize()
	. = ..()
	if(. == INITIALIZE_HINT_QDEL)
		return

	find_z_levels()     // This populates map_z and assigns z levels to the ship.
	register_z_levels() // This makes external calls to update global z level information.

	if(!SSatlas.current_map.overmap_z)
		build_overmap()

	initial_generic_waypoints = flatten_list(initial_generic_waypoints)
	tracked_dock_tags = flatten_list(tracked_dock_tags)

	move_to_starting_location()

	update_name()

	log_module_sectors("Located sector \"[name]\" at [start_x],[start_y], containing Z [english_list(map_z)]")

	LAZYADD(SSshuttle.sectors_to_initialize, src) //Queued for further init. Will populate the waypoint lists; waypoints not spawned yet will be added in as they spawn.
	SSshuttle.clear_init_queue()
	START_PROCESSING(SSovermap, src)

/obj/effect/overmap/visitable/process()
	if(get_dist(src, targeting) > 7)
		detarget(targeting)

/obj/effect/overmap/visitable/Destroy()
	for(var/obj/machinery/hologram/holopad/H as anything in SSmachinery.all_holopads)
		if(H.linked == src)
			H.linked = null
	for(var/obj/machinery/telecomms/T in SSmachinery.all_telecomms)
		if(T.linked == src)
			T.linked = null
	if(entry_points)
		entry_points.Cut()
	for(var/obj/machinery/ship_weapon/SW in ship_weapons)
		SW.linked = null
	if(ship_weapons)
		ship_weapons.Cut()
	targeting = null
	levi_safeguard = null
	gravity_generator = null
	STOP_PROCESSING(SSovermap, src)
	. = ..()

/obj/effect/overmap/visitable/proc/move_to_starting_location()
	var/map_low = OVERMAP_EDGE
	var/map_high = SSatlas.current_map.overmap_size - OVERMAP_EDGE
	var/turf/home
	if (place_near_main)
		var/obj/effect/overmap/visitable/main = GLOB.map_sectors["1"] ? GLOB.map_sectors["1"] : GLOB.map_sectors[GLOB.map_sectors[1]]
		if(islist(place_near_main))
			place_near_main = Roundm(Frand(place_near_main[1], place_near_main[2]), 0.1)
		home = CircularRandomTurfAround(main, abs(place_near_main), map_low, map_low, map_high, map_high)
		start_x = home.x
		start_y = home.y
		LOG_DEBUG("place_near_main moving [src] near [main] ([main.x],[main.y]) with radius [place_near_main], got ([home.x],[home.y])")
	else
		start_x = start_x || rand(map_low, map_high)
		start_y = start_y || rand(map_low, map_high)
		home = locate(start_x, start_y, SSatlas.current_map.overmap_z)

	if(!invisible_until_ghostrole_spawn)
		forceMove(home)

//This is called later in the init order by SSshuttle to populate sector objects. Importantly for subtypes, shuttles will be created by then.
/obj/effect/overmap/visitable/proc/populate_sector_objects()
	for(var/obj/machinery/hologram/holopad/H as anything in SSmachinery.all_holopads)
		H.attempt_hook_up(src)
	for(var/obj/machinery/telecomms/T in SSmachinery.all_telecomms)
		T.attempt_hook_up(src)

/obj/effect/overmap/visitable/proc/get_areas()
	return get_filtered_areas(list(/proc/area_belongs_to_zlevels = map_z))

/obj/effect/overmap/visitable/proc/find_z_levels()
	map_z = GetConnectedZlevels(z)

/obj/effect/overmap/visitable/proc/register_z_levels()
	for(var/zlevel in map_z)
		GLOB.map_sectors["[zlevel]"] = src

	SSatlas.current_map.player_levels |= map_z
	if(!in_space)
		SSatlas.current_map.sealed_levels |= map_z
	if(base)
		// SSatlas.current_map.station_levels |= map_z
		SSatlas.current_map.contact_levels |= map_z
		SSatlas.current_map.map_levels |= map_z

//Helper for init.
/obj/effect/overmap/visitable/proc/check_ownership(obj/object)
	if((object.z in map_z) && !(get_area(object) in SSshuttle.shuttle_areas))
		return 1

//If shuttle_name is false, will add to generic waypoints; otherwise will add to restricted. Does not do checks.
/obj/effect/overmap/visitable/proc/add_landmark(obj/effect/shuttle_landmark/landmark, shuttle_name)
	landmark.sector_set(src, shuttle_name)
	if(shuttle_name)
		LAZYADD(restricted_waypoints[shuttle_name], landmark)
	else
		generic_waypoints += landmark

/obj/effect/overmap/visitable/proc/remove_landmark(obj/effect/shuttle_landmark/landmark, shuttle_name)
	if(shuttle_name)
		var/list/shuttles = restricted_waypoints[shuttle_name]
		LAZYREMOVE(shuttles, landmark)
	else
		generic_waypoints -= landmark

/obj/effect/overmap/visitable/proc/get_waypoints(var/shuttle_name)
	. = list()
	for(var/obj/effect/overmap/visitable/contained in src)
		. += contained.get_waypoints(shuttle_name)
	for(var/thing in generic_waypoints)
		.[thing] = name
	if(shuttle_name in restricted_waypoints)
		for(var/thing in restricted_waypoints[shuttle_name])
			.[thing] = name

/obj/effect/overmap/visitable/proc/generate_skybox()
	return

/obj/effect/overmap/visitable/proc/toggle_distress_status()
	has_called_distress_beacon = !has_called_distress_beacon
	if(has_called_distress_beacon)
		var/image/distress_overlay = image('icons/obj/overmap/overmap_effects.dmi', "distress")
		applied_distress_overlay = distress_overlay
		AddOverlays(applied_distress_overlay)
		filters = filter(type = "outline", size = 2, color = COLOR_RED)
	else
		CutOverlays(applied_distress_overlay)
		filters = null

/obj/effect/overmap/visitable/proc/update_name()
	if(!designation)
		return
	if(obfuscated)
		return
	if(comms_support)
		update_away_freq(name, get_real_name())
	SEND_SIGNAL(src, COMSIG_BASENAME_SETNAME, args)
	name = get_real_name()

/obj/effect/overmap/visitable/proc/get_real_name()
	return class ? "[class] [designation]" : designation

/obj/effect/overmap/visitable/proc/set_new_designation(var/new_name)
	designation = new_name
	update_name()

/obj/effect/overmap/visitable/proc/set_new_class(var/new_class)
	class = new_class
	update_name()

/obj/effect/overmap/visitable/proc/update_obfuscated(var/new_state) //TRUE is obfuscated.
	if(new_state)
		name = obfuscated_name
		desc = obfuscated_desc
	else
		update_name()

/obj/effect/overmap/visitable/sector
	name = "generic sector"
	desc = "Sector with some stuff in it."
	icon_state = "sector"
	anchored = 1

	/// Ground survey result for use by survey probes to generate survey reports after surveying.
	/// A string. Child implementations should set and/or append to the string.
	/// Stations or ships should keep it null, as they cannot be surveyed with a survey probe.
	/// Lore planets and static away sites that are planets should keep it to static text trivia.
	/// For random planets, should be filled with random trivia or blurbs or the like.
	var/ground_survey_result = null
	/// Fluff descriptions found from soil sampling
	var/list/soil_data = list()
	/// Fluff desctiptions found on water sampling
	var/list/water_data = list()
	/// Magnetic survey result for use by survey probes. Randomly generated by most planets. Lore planets should have static text.
	var/magnet_survey_result = null

/obj/effect/overmap/visitable/sector/Initialize()
	. = ..()
	generate_ground_survey_result()
	generate_magnet_survey_result()

// Because of the way these are spawned, they will potentially have their invisibility adjusted by the turfs they are mapped on
// prior to being moved to the overmap. This blocks that. Use set_invisibility to adjust invisibility as needed instead.
/obj/effect/overmap/visitable/sector/hide()

/obj/effect/overmap/visitable/proc/handle_sensor_state_change(var/on)
	return

/// Generate ground survey result text, by setting the `ground_survey_result` var.
/// Called once at init of the sector.
/// Randomly generated planets should call parent and append to `ground_survey_result`.
/// Lore planets or away sites should just set it to one static string.
/obj/effect/overmap/visitable/sector/proc/generate_ground_survey_result()
	ground_survey_result = ""

/obj/effect/overmap/visitable/sector/proc/generate_magnet_survey_result()
	magnet_survey_result = ""

/proc/build_overmap()
	set waitfor = FALSE
	if(!SSatlas.current_map.use_overmap)
		return 1

	log_module_sectors("Building overmap...")
	var/datum/space_level/overmap_spacelevel = SSmapping.add_new_zlevel("Overmap", ZTRAITS_OVERMAP, contain_turfs = FALSE)
	SSatlas.current_map.overmap_z = overmap_spacelevel.z_value

	log_module_sectors("Putting overmap on [SSatlas.current_map.overmap_z]")
	var/area/overmap/A = new
	GLOB.map_overmap = A
	for (var/square in block(locate(1,1,SSatlas.current_map.overmap_z), locate(SSatlas.current_map.overmap_size,SSatlas.current_map.overmap_size,SSatlas.current_map.overmap_z)))
		var/turf/T = square
		if(T.x == SSatlas.current_map.overmap_size || T.y == SSatlas.current_map.overmap_size)
			T = T.ChangeTurf(/turf/unsimulated/map/edge)
		else
			T = T.ChangeTurf(/turf/unsimulated/map)
		T.change_area(T.loc, A)

	SSatlas.current_map.sealed_levels |= SSatlas.current_map.overmap_z

	log_module_sectors("Overmap build complete.")
	return 1

/// A circular random coordinate pair from 0, unit by default, scaled by radius, then rounded if round.
/proc/CircularRandomCoordinate(radius = 1, round)
	var/angle = rand(0, 359)
	var/x = cos(angle) * radius
	var/y = sin(angle) * radius
	if (round)
		x = round(x)
		y = round(y)
	return list(x, y)

/**
* A circular random coordinate with radius on center_x, center_y,
* reflected into low_x,low_y -> high_x,high_y, clamped in low,high,
* and rounded if round is set
*
* Generally this proc is useful for placement around a point (eg a
* player) that must stay within map boundaries, or some similar circle
* in box constraint
*
* A "donut" pattern can be achieved by varying the number supplied as
* radius outside the scope of the proc, eg as BoundedCircularRandomCoordinate(Frand(1, 3), ...)
*/
/proc/BoundedCircularRandomCoordinate(radius, center_x, center_y, low_x, low_y, high_x, high_y, round)
	var/list/xy = CircularRandomCoordinate(radius, round)
	var/dx = xy[1]
	var/dy = xy[2]
	var/x = center_x + dx
	var/y = center_y + dy
	if (x < low_x || x > high_x)
		x = center_x - dx
	if (y < low_y || y > high_y)
		y = center_y - dy
	return list(
		clamp(x, low_x, high_x),
		clamp(y, low_y, high_y)
	)

/// Pick a random turf using BoundedCircularRandomCoordinate about x,y on level z
/proc/CircularRandomTurf(radius, z, center_x, center_y, low_x = 1, low_y = 1, high_x = world.maxx, high_y = world.maxy)
	var/list/xy = BoundedCircularRandomCoordinate(radius, center_x, center_y, low_x, low_y, high_x, high_y, TRUE)
	return locate(xy[1], xy[2], z)


/// Pick a random turf using BoundedCircularRandomCoordinate around the turf of target
/proc/CircularRandomTurfAround(atom/target, radius, low_x = 1, low_y = 1, high_x = world.maxx, high_y = world.maxy)
	var/turf/turf = get_turf(target)
	return CircularRandomTurf(radius, turf.z, turf.x, turf.y, low_x, low_y, high_x, high_y)
