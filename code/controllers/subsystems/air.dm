var/air_processing_killed = FALSE

/var/datum/subsystem/air/air_master
var/tick_multiplier = 2

/*

Overview:
	The air controller does everything. There are tons of procs in here.

Class Vars:
	zones - All zones currently holding one or more turfs.
	edges - All processing edges.

	tiles_to_update - Tiles scheduled to update next tick.
	zones_to_update - Zones which have had their air changed and need air archival.
	active_hotspots - All processing fire objects.

	active_zones - The number of zones which were archived last tick. Used in debug verbs.
	next_id - The next UID to be applied to a zone. Mostly useful for debugging purposes as zones do not need UIDs to function.

Class Procs:

	mark_for_update(turf/T)
		Adds the turf to the update list. When updated, update_air_properties() will be called.
		When stuff changes that might affect airflow, call this. It's basically the only thing you need.

	add_zone(zone/Z) and remove_zone(zone/Z)
		Adds zones to the zones list. Does not mark them for update.

	air_blocked(turf/A, turf/B)
		Returns a bitflag consisting of:
		AIR_BLOCKED - The connection between turfs is physically blocked. No air can pass.
		ZONE_BLOCKED - There is a door between the turfs, so zones cannot cross. Air may or may not be permeable.

	has_valid_zone(turf/T)
		Checks the presence and validity of T's zone.
		May be called on unsimulated turfs, returning 0.

	merge(zone/A, zone/B)
		Called when zones have a direct connection and equivalent pressure and temperature.
		Merges the zones to create a single zone.

	connect(turf/simulated/A, turf/B)
		Called by turf/update_air_properties(). The first argument must be simulated.
		Creates a connection between A and B.

	mark_zone_update(zone/Z)
		Adds zone to the update list. Unlike mark_for_update(), this one is called automatically whenever
		air is returned from a simulated turf.

	equivalent_pressure(zone/A, zone/B)
		Currently identical to A.air.compare(B.air). Returns 1 when directly connected zones are ready to be merged.

	get_edge(zone/A, zone/B)
	get_edge(zone/A, turf/B)
		Gets a valid connection_edge between A and B, creating a new one if necessary.

	has_same_air(turf/A, turf/B)
		Used to determine if an unsimulated edge represents a specific turf.
		Simulated edges use connection_edge/contains_zone() for the same purpose.
		Returns 1 if A has identical gases and temperature to B.

	remove_edge(connection_edge/edge)
		Called when an edge is erased. Removes it from processing.

*/

/datum/subsystem/air
	name = "Air"
	wait = 2 SECONDS
	priority = SS_PRIORITY_AIR
	display_order = SS_DISPLAY_AIR
	//flags = SS_NO_TICK_CHECK

	//Geometry lists
	var/list/zones = list()
	var/list/edges = list()

	//Geometry updates lists
	var/list/tiles_to_update = list()
	var/list/zones_to_update = list()
	var/list/active_fire_zones = list()
	var/list/active_hotspots = list()
	var/list/active_edges = list()

	var/tmp/list/deferred = list()
	var/tmp/list/processing_edges
	var/tmp/list/processing_fires
	var/tmp/list/processing_hotspots
	var/tmp/list/processing_zones

	var/active_zones = 0
	var/current_cycle = 0
	var/next_id = 1

/datum/subsystem/air/New()
	NEW_SS_GLOBAL(air_master)

/datum/subsystem/air/Initialize(timeofday)
	var/simulated_turf_count = 0
	for(var/turf/simulated/S in world)
		simulated_turf_count++
		S.update_air_properties()

	admin_notice({"<span class='info'>
Total Simulated Turfs: [simulated_turf_count]
Total Zones: [zones.len]
Total Edges: [edges.len]
Total Active Edges: [active_edges.len ? "<span class='danger'>[active_edges.len]</span>" : "None"]
Total Unsimulated Turfs: [world.maxx*world.maxy*world.maxz - simulated_turf_count]
</span>"}, R_DEBUG)
	..()

/datum/subsystem/air/fire(resumed = FALSE)	
	if (!resumed)
		current_cycle++
		processing_edges = active_edges.Copy()
		processing_fires = active_fire_zones.Copy()
		processing_hotspots = active_hotspots.Copy()

	while (tiles_to_update.len)
		var/turf/T = tiles_to_update[tiles_to_update.len]
		tiles_to_update.len--

		if (QDELETED(T))
			continue

		//check if the turf is self-zone-blocked
		if(T.c_airblock(T) & ZONE_BLOCKED)
			deferred += T
			continue

		T.update_air_properties()
		T.post_update_air_properties()
		T.needs_air_update = 0
		#ifdef ZASDBG
		T.overlays -= mark
		updated++
		#endif

		if (MC_TICK_CHECK)
			return

	while (deferred.len)
		var/turf/T = deferred[deferred.len]
		deferred.len--

		T.update_air_properties()
		T.post_update_air_properties()
		T.needs_air_update = 0
		#ifdef ZASDBG
		T.overlays -= mark
		updated++
		#endif

		if (MC_TICK_CHECK)
			return

	while (processing_edges.len)
		var/connection_edge/edge = processing_edges[processing_edges.len]
		processing_edges.len--

		if (!edge)
			continue
		
		edge.tick()
		
		if (MC_TICK_CHECK)
			return

	while (processing_fires.len)
		var/zone/Z = processing_fires[processing_fires.len]
		processing_fires.len--

		Z.process_fire()

		if (MC_TICK_CHECK)
			return

	while (processing_hotspots.len)
		var/obj/fire/F = processing_hotspots[processing_hotspots.len]
		processing_hotspots.len--

		F.process()

		if (MC_TICK_CHECK)
			return
	
	while (zones_to_update.len)
		var/zone/Z = zones_to_update[zones_to_update.len]
		zones_to_update.len--

		Z.tick()
		Z.needs_update = FALSE

/datum/subsystem/air/proc/add_zone(zone/z)
	zones.Add(z)
	z.name = "Zone [next_id++]"
	mark_zone_update(z)

/datum/subsystem/air/proc/remove_zone(zone/z)
	zones.Remove(z)
	zones_to_update.Remove(z)


/datum/subsystem/air/proc/air_blocked(turf/A, turf/B)
	#ifdef ZASDBG
	ASSERT(isturf(A))
	ASSERT(isturf(B))
	#endif
	var/ablock = A.c_airblock(B)
	if(ablock == BLOCKED) return BLOCKED
	return ablock | B.c_airblock(A)

/datum/subsystem/air/proc/has_valid_zone(turf/simulated/T)
	#ifdef ZASDBG
	ASSERT(istype(T))
	#endif
	return istype(T) && T.zone && !T.zone.invalid

/datum/subsystem/air/proc/merge(zone/A, zone/B)
	#ifdef ZASDBG
	ASSERT(istype(A))
	ASSERT(istype(B))
	ASSERT(!A.invalid)
	ASSERT(!B.invalid)
	ASSERT(A != B)
	#endif
	if(A.contents.len < B.contents.len)
		A.c_merge(B)
		mark_zone_update(B)
	else
		B.c_merge(A)
		mark_zone_update(A)

/datum/subsystem/air/proc/connect(turf/simulated/A, turf/simulated/B)
	#ifdef ZASDBG
	ASSERT(istype(A))
	ASSERT(isturf(B))
	ASSERT(A.zone)
	ASSERT(!A.zone.invalid)
	//ASSERT(B.zone)
	ASSERT(A != B)
	#endif

	var/block = air_master.air_blocked(A,B)
	if(block & AIR_BLOCKED) return

	var/direct = !(block & ZONE_BLOCKED)
	var/space = !istype(B)

	if(!space)
		if(min(A.zone.contents.len, B.zone.contents.len) < ZONE_MIN_SIZE || (direct && (equivalent_pressure(A.zone,B.zone) || current_cycle == 0)))
			merge(A.zone,B.zone)
			return

	var
		a_to_b = get_dir(A,B)
		b_to_a = get_dir(B,A)

	if(!A.connections) A.connections = new
	if(!B.connections) B.connections = new

	if(A.connections.get(a_to_b)) return
	if(B.connections.get(b_to_a)) return
	if(!space)
		if(A.zone == B.zone) return


	var/connection/c = new /connection(A,B)

	A.connections.place(c, a_to_b)
	B.connections.place(c, b_to_a)

	if(direct) c.mark_direct()

/datum/subsystem/air/proc/mark_for_update(turf/T)
	#ifdef ZASDBG
	ASSERT(isturf(T))
	#endif
	if(T.needs_air_update) return
	tiles_to_update |= T
	#ifdef ZASDBG
	T.overlays += mark
	#endif
	T.needs_air_update = 1

/datum/subsystem/air/proc/mark_zone_update(zone/Z)
	#ifdef ZASDBG
	ASSERT(istype(Z))
	#endif
	if(Z.needs_update) return
	zones_to_update.Add(Z)
	Z.needs_update = 1

/datum/subsystem/air/proc/mark_edge_sleeping(connection_edge/E)
	#ifdef ZASDBG
	ASSERT(istype(E))
	#endif
	if(E.sleeping) return
	active_edges.Remove(E)
	E.sleeping = 1

/datum/subsystem/air/proc/mark_edge_active(connection_edge/E)
	#ifdef ZASDBG
	ASSERT(istype(E))
	#endif
	if(!E.sleeping) return
	active_edges.Add(E)
	E.sleeping = 0

/datum/subsystem/air/proc/equivalent_pressure(zone/A, zone/B)
	return A.air.compare(B.air)

/datum/subsystem/air/proc/get_edge(zone/A, zone/B)

	if(istype(B))
		for(var/connection_edge/zone/edge in A.edges)
			if(edge.contains_zone(B)) return edge
		var/connection_edge/edge = new/connection_edge/zone(A,B)
		edges.Add(edge)
		edge.recheck()
		return edge
	else
		for(var/connection_edge/unsimulated/edge in A.edges)
			if(has_same_air(edge.B,B)) return edge
		var/connection_edge/edge = new/connection_edge/unsimulated(A,B)
		edges.Add(edge)
		edge.recheck()
		return edge

/datum/subsystem/air/proc/has_same_air(turf/A, turf/B)
	if(A.oxygen != B.oxygen) return 0
	if(A.nitrogen != B.nitrogen) return 0
	if(A.phoron != B.phoron) return 0
	if(A.carbon_dioxide != B.carbon_dioxide) return 0
	if(A.temperature != B.temperature) return 0
	return 1

/datum/subsystem/air/proc/remove_edge(connection_edge/E)
	edges.Remove(E)
	if(!E.sleeping) active_edges.Remove(E)
