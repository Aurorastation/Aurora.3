/datum/map
	var/name = "Unnamed Map"
	var/full_name = "Unnamed Map"
	var/path

	var/list/station_levels = list() // Z-levels the station exists on
	var/list/admin_levels = list()   // Z-levels for admin functionality (Centcom, shuttle transit, etc)
	var/list/contact_levels = list() // Z-levels that can be contacted from the station, for eg announcements
	var/list/player_levels = list()  // Z-levels a character can typically reach
	var/list/sealed_levels = list()  // Z-levels that don't allow random transit at edge
	var/list/restricted_levels = list()  // Z-levels that dont allow ghosts to randomly move around

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
	var/system_name   = "Uncharted System"

	var/command_spawn_enabled = FALSE
	var/command_spawn_message = "Someone didn't fill this in."

	var/list/spawn_types

	var/shuttle_docked_message
	var/shuttle_leaving_dock
	var/shuttle_called_message
	var/shuttle_recall_message
	var/emergency_shuttle_docked_message
	var/emergency_shuttle_leaving_dock
	var/emergency_shuttle_recall_message
	var/emergency_shuttle_called_message

	var/list/station_networks = list() 		// Camera networks that will show up on the console.

	var/list/holodeck_programs = list() // map of string ids to /datum/holodeck_program instances
	var/list/holodeck_supported_programs = list()
		// map of maps - first level maps from list-of-programs string id (e.g. "BarPrograms") to another map
		// this is in order to support multiple holodeck program listings for different holodecks
		// second level maps from program friendly display names ("Picnic Area") to program string ids ("picnicarea")
		// as defined in holodeck_programs
	var/list/holodeck_restricted_programs = list() // as above... but EVIL!

	var/allowed_spawns = list("Arrivals Shuttle","Gateway", "Cryogenic Storage", "Cyborg Storage")
	var/default_spawn = "Arrivals Shuttle"

	var/lobby_icon                         // The icon which contains the lobby image(s)
	var/list/lobby_screens = list("title") // The list of lobby screen to pick() from. If left unset the first icon state is always selected.

	var/has_space_ruins = FALSE	//if this map picks and creates a space ruin

/datum/map/New()
	if(!map_levels)
		map_levels = station_levels.Copy()
	if(!allowed_jobs)
		allowed_jobs = subtypesof(/datum/job)
	if (!spawn_types)
		spawn_types = subtypesof(/datum/spawnpoint)

/datum/map/proc/generate_asteroid()
	return

// Override to set custom access requirements for camera networks.
/datum/map/proc/get_network_access(var/network)
	return 0

// By default transition randomly to another zlevel
/datum/map/proc/get_transit_zlevel(var/current_z_level)
	var/list/candidates = current_map.accessible_z_levels.Copy()
	candidates.Remove(num2text(current_z_level))

	if(!candidates.len)
		return current_z_level
	return text2num(pickweight(candidates))

/datum/map/proc/setup_shuttles()

// Called right after SSatlas finishes loading the map & multiz is setup.
/datum/map/proc/finalize_load()
