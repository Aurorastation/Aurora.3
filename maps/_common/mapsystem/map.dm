/datum/map
	var/name = "Unnamed Map"
	var/full_name = "Unnamed Map"
	var/description // Basic info about the map. Shows up in the new player options.
	var/path

	/**
	 * A list of traits for the zlevels of the map
	 *
	 * Each element is one zlevel, starting from the bottom one up
	 */
	var/list/traits = list()

	var/list/admin_levels = list()   // Z-levels for admin functionality (Centcom, shuttle transit, etc)
	var/list/contact_levels = list() // Z-levels that can be contacted from the station, for eg announcements
	var/list/player_levels = list()  // Z-levels a character can typically reach
	var/list/sealed_levels = list()  // Z-levels that don't allow random transit at edge
	var/list/restricted_levels = list()  // Z-levels that dont allow ghosts to randomly move around
	var/list/empty_levels = null     // Empty Z-levels that may be used for various things (currently used by bluespace jump)

	var/list/map_levels              // Z-levels available to various consoles, such as the crew monitor. Defaults to station_levels if unset.

	var/list/base_turf_by_z = list() // Custom base turf by Z-level. Defaults to world.turf for unlisted Z-levels

	//This list contains the z-level numbers which can be accessed via space travel and the percentile chances to get there.
	var/list/accessible_z_levels = list()

	var/list/allowed_jobs
		//Job datums to use.
		//Works a lot better so if we get to a point where three-ish maps are used
		//We don't have to C&P ones that are only common between two of them
		//That doesn't mean we have to include them with the rest of the jobs though, especially for map specific ones.
		//Also including them lets us override already created jobs, letting us keep the datums to a minimum mostly.
		//This is probably a lot longer explanation than it needs to be.

	var/station_name  = "BAD Station"
	var/station_short = "Baddy"
	var/dock_name     = "THE PirateBay"
	var/dock_short    = "Piratebay"
	var/boss_name     = "Captain Roger"
	var/boss_short    = "Cap'"
	var/company_name  = "BadMan"
	var/company_short = "BM"
	var/station_type  = "station"

	var/command_spawn_enabled = FALSE
	var/command_spawn_message = "Someone didn't fill this in."

	var/list/spawn_types

	var/shuttle_call_restarts = FALSE // if true, calling crew transfer or evac just restarts the round in ten minute
	var/shuttle_call_restart_timer
	var/shuttle_docked_message
	var/shuttle_leaving_dock
	var/shuttle_called_message
	var/shuttle_recall_message
	var/emergency_shuttle_docked_message
	var/emergency_shuttle_leaving_dock
	var/emergency_shuttle_recall_message
	var/emergency_shuttle_called_message
	var/bluespace_docked_message
	var/bluespace_leaving_dock
	var/bluespace_called_message
	var/bluespace_recall_message

	/// The typepath of the visitable our main map is, for example /obj/effect/overmap/visitable/ship/sccv_horizon
	var/overmap_visitable_type

	/// If this map has ports of call and refuels there. Crew are implied to be able to leave to these ports.
	/// Ports of call are taken from the current map sector.
	var/ports_of_call = FALSE

	var/evac_controller_type = /datum/evacuation_controller

	var/list/station_networks = list() 		// Camera networks that will show up on the console.

	var/list/holodeck_programs = list() // map of string ids to /datum/holodeck_program instances
	var/list/holodeck_supported_programs = list()
		// map of maps - first level maps from list-of-programs string id (e.g. "BarPrograms") to another map
		// this is in order to support multiple holodeck program listings for different holodecks
		// second level maps from program friendly display names ("Picnic Area") to program string ids ("picnicarea")
		// as defined in holodeck_programs
	var/list/holodeck_restricted_programs = list() // as above... but EVIL!

	var/force_spawnpoint = FALSE
	var/allowed_spawns = list("Arrivals Shuttle","Gateway", "Cryogenic Storage", "Cyborg Storage")
	var/default_spawn = "Arrivals Shuttle"

	/// A list of paths to rotate for the lobby image, png/bmp/jpg/gif only
	var/list/lobby_icon_image_paths = list()

	var/lobby_transitions = FALSE          // If a number, transition between the lobby screens with this delay instead of picking just one.

	var/use_overmap = FALSE		//If overmap should be used (including overmap space travel override)
	var/overmap_size = 20		//Dimensions of overmap zlevel if overmap is used.
	var/overmap_z = 0		//If 0 will generate overmap zlevel on init. Otherwise will populate the zlevel provided.
	var/overmap_event_areas = 0 //How many event "clouds" will be generated
	var/list/map_shuttles = list() // A list of all our shuttles.
	var/default_sector = SECTOR_ROMANOVICH //What is the default space sector for this map

	//event messages

	var/meteors_detected_message = "A meteor storm has been detected on collision course with the station. Estimated three minutes until impact, please activate station shields, and seek shelter in the central ring."
	var/meteor_contact_message = "Contact with meteor wave imminent, all hands brace for impact."
	var/meteor_end_message = "The station has cleared the meteor shower, please return to your stations."

	var/ship_meteor_contact_message = "The NDV Icarus reports that it has downed an unknown vessel that was approaching your station. Prepare for debris impact - please evacuate the surface level if needed."
	var/ship_detected_end_message = "Ship debris colliding now, all hands brace for impact."
	var/ship_meteor_end_message = "The last of the ship debris has hit or passed by the station, it is now safe to commence repairs."

	var/dust_detected_message = "A belt of space dust is approaching the station."
	var/dust_contact_message = "The station is now passing through a belt of space dust."
	var/dust_end_message = "The station has now passed through the belt of space dust."

	var/radiation_detected_message = "High levels of radiation detected near the station. Please evacuate into one of the shielded maintenance tunnels."
	var/radiation_contact_message = "The station has entered the radiation belt. Please remain in a sheltered area until we have passed the radiation belt."
	var/radiation_end_message = "The station has passed the radiation belt. Please report to medbay if you experience any unusual symptoms. Maintenance will lose all-access again shortly."

	var/list/rogue_drone_detected_messages = list("A combat drone wing operating out of the NDV Icarus has failed to return from a sweep of this sector, if any are sighted approach with caution.",
													"Contact has been lost with a combat drone wing operating out of the NDV Icarus. If any are sighted in the area, approach with caution.",
													"Unidentified hackers have targetted a combat drone wing deployed from the NDV Icarus. If any are sighted in the area, approach with caution.")
	var/rogue_drone_end_message = "Icarus drone control reports the malfunctioning wing has been recovered safely."
	var/rogue_drone_destroyed_message = "Icarus drone control registers disappointment at the loss of the drones, but the survivors have been recovered."

	var/num_exoplanets = 0
	var/list/planet_size  //dimensions of planet zlevel, defaults to world size. Due to how maps are generated, must be (2^n+1) e.g. 17,33,65,129 etc. Map will just round up to those if set to anything other.
	var/min_offmap_players = 0
	var/away_site_budget = 0
	var/away_ship_budget = 0
	var/away_variance = 0 //how much higher the budgets can randomly go

	var/allow_borgs_to_leave = FALSE //this controls if borgs can leave the station or ship without exploding
	var/area/warehouse_basearea //this controls where the cargospawner tries to populate warehouse items
	var/area/warehouse_packagearea // used to handle spawnpoints for the packages that spawned after Initialize. See: `receptacle.dm`.

	/**
	 * A list of the shuttles on this map, used by the Shuttle Manifest program to populate itself.
	 * Formatted with the shuttle name as an index, followed by a list containing the color and icon to be used for the shuttle's drop down
	 * On the manifest. i.e. "SCCV Intrepid" = list("color" = "purple", "icon" = "compass")
	 */
	var/list/shuttle_manifests = list()
	/**
	 * A list of the missions shuttles can select for their assignment in the Shuttle Manifest program.
	 */
	var/list/shuttle_missions = list()

/datum/map/New()
	if(!map_levels)
		map_levels = SSmapping.levels_by_trait(ZTRAIT_STATION)

	if(!allowed_jobs)
		allowed_jobs = subtypesof(/datum/job)
		for(var/thing in EVENT_ROLES) //ideally this should prevent event roles from being open on the horizon
			allowed_jobs.Remove(thing)
	if (!spawn_types)
		spawn_types = subtypesof(/datum/spawnpoint)
	if(!LAZYLEN(planet_size))
		planet_size = list(world.maxx, world.maxy)

// Override to set custom access requirements for camera networks.
/datum/map/proc/get_network_access(var/network)
	return 0

// By default transition randomly to another zlevel
/datum/map/proc/get_transit_zlevel(var/current_z_level)
	var/list/candidates = SSatlas.current_map.accessible_z_levels.Copy()
	candidates.Remove(num2text(current_z_level))

	if(!candidates.len)
		return current_z_level
	return text2num(pickweight(candidates))

/datum/map/proc/get_empty_zlevel()
	if(empty_levels == null)
		var/datum/space_level/empty_level = SSmapping.add_new_zlevel("Empty Level", ZTRAITS_AWAY, contain_turfs = FALSE)
		empty_levels = list(empty_level.z_value)
	return pick(empty_levels)

/datum/map/proc/setup_shuttles()
	return

/datum/map/proc/build_exoplanets()
	if(!use_overmap)
		return

	if(!GLOB.config.exoplanets["enable_loading"])
		log_admin("Not building exoplanets because the config specifies not to")
		return

	var/datum/space_sector/sector = SSatlas.current_sector
	var/list/possible_exoplanets = sector.possible_exoplanets
	var/list/guaranteed_exoplanets = sector.guaranteed_exoplanets

	if(length(guaranteed_exoplanets))
		for(var/j in guaranteed_exoplanets)
			var/guaranteed_exoplanet_type = j
			log_module_exoplanets("Building new exoplanet with type: [guaranteed_exoplanet_type] and size: [planet_size[1]] [planet_size[2]]")
			var/obj/effect/overmap/visitable/sector/exoplanet/P = new guaranteed_exoplanet_type(null, planet_size[1], planet_size[2])
			P.build_level()

	if(!length(possible_exoplanets))
		log_module_exoplanets("No possible exoplanets found!")
		return

	var/exoplanets_budget = isnum(GLOB.config.exoplanets["exoplanets_budget"]) ? (GLOB.config.exoplanets["exoplanets_budget"]) : (min(possible_exoplanets.len, num_exoplanets))
	for(var/i = 0, i < exoplanets_budget, i++)

		//Check that we didn't ran out of exoplanets to make
		if(!length(possible_exoplanets))
			break

		var/exoplanet_type = pick_n_take(possible_exoplanets)
		log_module_exoplanets("Building new exoplanet with type: [exoplanet_type] and size: [planet_size[1]] [planet_size[2]]")
		var/obj/effect/overmap/visitable/sector/exoplanet/new_planet = new exoplanet_type(null, planet_size[1], planet_size[2])
		new_planet.build_level()

/* It is perfectly possible to create loops with TEMPLATE_FLAG_ALLOW_DUPLICATES and force/allow. Don't. */
/proc/resolve_site_selection(datum/map_template/ruin/away_site/site, list/selected, list/available, list/unavailable, list/by_type)
	var/spawn_cost = 0
	var/player_cost = 0
	var/ship_cost = 0
	if (site in selected)
		if (!(site.template_flags & TEMPLATE_FLAG_ALLOW_DUPLICATES))
			return list(spawn_cost, player_cost, ship_cost)
	if (!(site.template_flags & TEMPLATE_FLAG_ALLOW_DUPLICATES))
		available -= site
	spawn_cost += site.spawn_cost
	player_cost += site.player_cost
	ship_cost += site.ship_cost
	selected += site

	for (var/forced_type in site.force_ruins)
		var/list/costs = resolve_site_selection(by_type[forced_type], selected, available, unavailable, by_type)
		spawn_cost += costs[1]
		player_cost += costs[2]
		ship_cost += costs[3]

	for (var/banned_type in site.ban_ruins)
		var/datum/map_template/ruin/away_site/banned = by_type[banned_type]
		if (banned in unavailable)
			continue
		unavailable += banned
		available -= banned

	for (var/allowed_type in site.allow_ruins)
		var/datum/map_template/ruin/away_site/allowed = by_type[allowed_type]
		if (allowed in available)
			continue
		if (allowed in unavailable)
			continue
		if (allowed in selected)
			if (!(allowed.template_flags & TEMPLATE_FLAG_ALLOW_DUPLICATES))
				continue
		available[allowed] = allowed.spawn_weight

	return list(spawn_cost, player_cost, ship_cost)

/datum/map/proc/send_welcome()
	return

/datum/map/proc/load_holodeck_programs()
	return

/datum/map/proc/build_away_sites()
#ifdef UNIT_TEST
	log_admin("Unit testing, so not loading away sites")
	return // don't build away sites during unit testing
#else
	if(!GLOB.config.awaysites["enable_loading"])
		log_admin("Not loading away sites because the config specifies not to")
		return

	log_admin("Loading away sites...")

	var/list/guaranteed = list()
	var/list/selected = list()
	var/list/available = list()
	var/list/unavailable = list()
	var/list/by_type = list()

	for (var/site_id in SSmapping.away_sites_templates)
		var/datum/map_template/ruin/away_site/site = SSmapping.away_sites_templates[site_id]
		if (((site.template_flags & TEMPLATE_FLAG_SPAWN_GUARANTEED) && (site.spawns_in_current_sector())) || (site_id in GLOB.config.awaysites["guaranteed_sites"]))
			guaranteed += site
			if ((site.template_flags & TEMPLATE_FLAG_ALLOW_DUPLICATES) && !(site.template_flags & TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED))
				available[site] = site.spawn_weight
		else if((site.template_flags & TEMPLATE_FLAG_PORT_SPAWN) && (site.spawns_in_current_sector()))
			if(SSatlas.is_port_call_day()) //we check here as we only want sites with PORT_SPAWN flag to spawn if this is true, else we want it not considered.
				guaranteed += site
				if ((site.template_flags & TEMPLATE_FLAG_ALLOW_DUPLICATES) && !(site.template_flags & TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED))
					available[site] = site.spawn_weight
		else if (!(site.template_flags & TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED) && (site.spawns_in_current_sector()))
			available[site] = site.spawn_weight
		by_type[site.type] = site

	var/points = isnum(GLOB.config.awaysites["away_site_budget"]) ? (GLOB.config.awaysites["away_site_budget"]) : (rand(away_site_budget, away_site_budget + away_variance))
	var/players = -min_offmap_players
	var/shippoints = isnum(GLOB.config.awaysites["away_ship_budget"]) ? (GLOB.config.awaysites["away_ship_budget"]) : (rand(away_ship_budget, away_ship_budget + away_variance))
	var/totalbudget = shippoints + points
	for (var/client/C)
		++players

	for (var/datum/map_template/ruin/away_site/site in guaranteed)
		var/list/costs = resolve_site_selection(site, selected, available, unavailable, by_type)
		points -= costs[1]
		players -= costs[2]
		shippoints -= costs[3]

	while ((points > 0 || shippoints > 0) && length(available))
		var/datum/map_template/ruin/away_site/site = pickweight(available)
		if ((site.spawn_cost && site.spawn_cost > points) || (site.player_cost && site.player_cost > players) || (site.ship_cost && site.ship_cost > shippoints))
			unavailable += site
			available -= site
			continue
		var/list/costs = resolve_site_selection(site, selected, available, unavailable, by_type)
		points -= costs[1]
		players -= costs[2]
		shippoints -= costs[3]

	log_admin("Finished selecting away sites ([english_list(selected)]) for [totalbudget - (points + shippoints)] cost of [totalbudget] budget.")

	for(var/datum/map_template/template in selected)
		var/bounds = template.load_new_z()
		if(bounds)
			log_admin("Loaded away site [template]!")
		else
			log_admin("Failed loading away site [template]!")
#endif
