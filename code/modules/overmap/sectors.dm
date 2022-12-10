//===================================================================================
//Overmap object representing zlevel(s)
//===================================================================================
var/global/area/overmap/map_overmap // Global object used to locate the overmap area.

/obj/effect/overmap/visitable
	name = "map object"
	scannable = TRUE
	var/designation //Actual name of the object.
	var/class //Imagine a ship or station's class. "NTCC" Odin, "SCCV" Horizon, ...
	var/obfuscated_name = "unidentified object"
	var/obfuscated_desc = "This object is not displaying its IFF signature."
	var/obfuscated = FALSE //Whether we hide our name and class or not.

	var/list/initial_generic_waypoints //store landmark_tag of landmarks that should be added to the actual lists below on init.
	var/list/initial_restricted_waypoints //For use with non-automatic landmarks (automatic ones add themselves).

	var/list/generic_waypoints = list()    //waypoints that any shuttle can use
	var/list/restricted_waypoints = list() //waypoints for specific shuttles

	var/start_x			//Coordinates for self placing
	var/start_y			//will use random values if unset

	var/base = 0		//starting sector, counts as station_levels
	var/in_space = 1	//can be accessed via lucky EVA

	var/has_called_distress_beacon = FALSE
	var/image/applied_distress_overlay

	var/targeting_flags = TARGETING_FLAG_ENTRYPOINTS|TARGETING_FLAG_GENERIC_WAYPOINTS
	var/list/obj/machinery/ship_weapon/ship_weapons
	var/list/obj/effect/landmark/entry_points
	var/obj/effect/overmap/targeting
	var/obj/machinery/leviathan_safeguard/levi_safeguard
	var/obj/machinery/gravity_generator/main/gravity_generator

	var/comms_support = FALSE		// Whether ghostroles attached to this overmap object spawn with comms
	var/comms_name = "shipboard"	// Snowflake name to apply to comms equipment ("shipboard radio headset", "intercom (shipboard)", "shipboard telecommunications mainframe"), etc.

/obj/effect/overmap/visitable/Initialize()
	. = ..()
	if(. == INITIALIZE_HINT_QDEL)
		return

	find_z_levels()     // This populates map_z and assigns z levels to the ship.
	register_z_levels() // This makes external calls to update global z level information.

	if(!current_map.overmap_z)
		build_overmap()
		
	start_x = start_x || rand(OVERMAP_EDGE, current_map.overmap_size - OVERMAP_EDGE)
	start_y = start_y || rand(OVERMAP_EDGE, current_map.overmap_size - OVERMAP_EDGE)

	forceMove(locate(start_x, start_y, current_map.overmap_z))

	update_name()

	testing("Located sector \"[name]\" at [start_x],[start_y], containing Z [english_list(map_z)]")

	LAZYADD(SSshuttle.sectors_to_initialize, src) //Queued for further init. Will populate the waypoint lists; waypoints not spawned yet will be added in as they spawn.
	SSshuttle.clear_init_queue()
	START_PROCESSING(SSprocessing, src)

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
	STOP_PROCESSING(SSprocessing, src)
	. = ..()

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
		map_sectors["[zlevel]"] = src

	current_map.player_levels |= map_z
	if(!in_space)
		current_map.sealed_levels |= map_z
	if(base)
		current_map.station_levels |= map_z
		current_map.contact_levels |= map_z
		current_map.map_levels |= map_z

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
		var/image/distress_overlay = image('icons/obj/overmap.dmi', "distress")
		applied_distress_overlay = distress_overlay
		add_overlay(applied_distress_overlay)
		filters = filter(type = "outline", size = 2, color = COLOR_RED)
	else
		cut_overlay(applied_distress_overlay)
		filters = null

/obj/effect/overmap/visitable/proc/update_name()
	if(!designation)
		return
	if(obfuscated)
		return
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

// Because of the way these are spawned, they will potentially have their invisibility adjusted by the turfs they are mapped on
// prior to being moved to the overmap. This blocks that. Use set_invisibility to adjust invisibility as needed instead.
/obj/effect/overmap/visitable/sector/hide()

/proc/build_overmap()
	if(!current_map.use_overmap)
		return 1

	testing("Building overmap...")
	world.maxz++
	current_map.overmap_z = world.maxz
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_NEW_Z, world.maxz)

	testing("Putting overmap on [current_map.overmap_z]")
	var/area/overmap/A = new
	global.map_overmap = A
	for (var/square in block(locate(1,1,current_map.overmap_z), locate(current_map.overmap_size,current_map.overmap_size,current_map.overmap_z)))
		var/turf/T = square
		if(T.x == current_map.overmap_size || T.y == current_map.overmap_size)
			T = T.ChangeTurf(/turf/unsimulated/map/edge)
		else
			T = T.ChangeTurf(/turf/unsimulated/map)
		ChangeArea(T, A)

	current_map.sealed_levels |= current_map.overmap_z

	testing("Overmap build complete.")
	return 1
