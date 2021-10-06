#define WHITELISTFILE "data/whitelist.txt"

var/list/whitelist = list()
var/list/whitelist_jobconfig = list()

/**
* The config/whitelist_jobconfig.json file contains a list that associates a job name with a whitelist_status.
* A job name in that case is any rank that /proc/jobban_isbanned(player, rank) checks for.
* The status needs to be present in the ss13_whitelist_statuses table and assigned to the players that should have the whitelist.
* This system only works with the sql based whitelists.
* The file based whitelists are still supported but it is not possible to assign specific whitelists to specific players. (its either all or nothing)
*/

/hook/startup/proc/loadWhitelist()
	if (config.usewhitelist)
		load_whitelist_jobconfig()
		load_whitelist()
	return 1

/proc/load_whitelist_jobconfig()
	if(fexists("config/whitelist_jobconfig.json"))
		log_debug("Whitelist JobConfig: Loading from json")
		try
			whitelist_jobconfig = json_decode(return_file_text("config/whitelist_jobconfig.json"))
		catch(var/exception/e)
			log_debug("Whitelist JobConfig: Failed to load whitelist_jobconfig.json: [e]")

/proc/load_whitelist()
	if (config.sql_whitelists)
		if (!establish_db_connection(dbcon))
			//Continue with the old code if we have no database.
			error("Database connection failed while loading whitelists. Reverting to legacy system.")
			config.sql_whitelists = 0
		else
			return

	whitelist = file2list(WHITELISTFILE)
	if (!whitelist.len)
		whitelist = null

/proc/check_whitelist_rank(mob/M, var/rank)
	if (length(whitelist_jobconfig))
		if (rank in whitelist_jobconfig)
			return check_whitelist(M, whitelist_jobconfig[rank])
		else
			return TRUE //If the rank does not exist in the whitelist config, the rank isnt whitelisted
	else
		return TRUE //If the whitelist_jobconfig isnt loaded, there are no whitelists

/proc/check_whitelist(mob/M, var/whitelist_id = 1)
	if(!config.usewhitelist)
		return TRUE

	if (config.sql_whitelists)
		if (M.client && M.client.whitelist_status)
			return (M.client.whitelist_status & whitelist_id)

		return 0
	else
		if (!whitelist)
			return 0
		return ("[M.ckey]" in whitelist)

/var/list/alien_whitelist = list()

/hook/startup/proc/loadAlienWhitelist()
	if (config.usealienwhitelist)
		load_alienwhitelist()
	return 1

/proc/load_alienwhitelist()
	if (config.sql_whitelists)
		if (!establish_db_connection(dbcon))
			//Continue with the old code if we have no database.
			error("Database connection failed while loading alien whitelists. Reverting to legacy system.")
			config.sql_whitelists = 0
		else
			var/DBQuery/query = dbcon.NewQuery("SELECT status_name, flag FROM ss13_whitelist_statuses")
			query.Execute()

			while (query.NextRow())
				if (query.item[1] in whitelisted_species)
					whitelisted_species[query.item[1]] = text2num(query.item[2])

			return

	var/text = file2text("config/alienwhitelist.txt")
	if (!text)
		log_misc("Failed to load config/alienwhitelist.txt")
		return 0
	else
		alien_whitelist = text2list(text, "\n")
		return 1

/proc/is_alien_whitelisted(mob/M, var/species)
	if (!config.usealienwhitelist)
		return 1

	if (!M || !species)
		return 0

	if(istype(species, /datum/species))
		var/datum/species/S = species
		if(!(S.spawn_flags & IS_WHITELISTED))
			return 1
		species = S.name

	else
		var/datum/species/S = global.all_species[species]
		if(S && !(S.spawn_flags & IS_WHITELISTED))
			return 1

	if (!alien_whitelist && !config.sql_whitelists)
		return 0

	if (config.sql_whitelists)
		if (M.client && M.client.whitelist_status)
			return (M.client.whitelist_status & whitelisted_species[species])
	else
		if (M && species)
			for (var/s in alien_whitelist)
				if (findtext(s,"[M.ckey] - [species]"))
					return 1
				if (findtext(s,"[M.ckey] - All"))
					return 1
	return 0

/**
 * A centralized proc for checking whether or not a player is fit for playing
 * any antag role or job role dependant on their ckey's age, job's age restriction,
 * and config settings.
 *
 * @param	C The client object whose age we want to check. Can also be a mob.
 * @param	job The job name/antag role name we want to check against.
 *
 * @return	Days left until the player can play the role if they're too young.
 *			0 if they're old enough.
 */
/proc/player_old_enough_for_role(client/C, job)
	if (!job || !C)
		return 0

	if (ismob(C))
		var/mob/M = C
		C = M.client

	if (!istype(C) || C.holder)
		return 0

	if(!establish_db_connection(dbcon))
		return 0

	var/age_to_beat = 0

	// Assume it's an antag role.
	if (bantype_to_antag_age[lowertext(job)] && config.use_age_restriction_for_antags)
		age_to_beat = bantype_to_antag_age[lowertext(job)]

	// Assume it's a job instead!
	if (!age_to_beat)
		var/datum/job/J = SSjobs.GetJob(job)
		if (J && config.use_age_restriction_for_jobs)
			age_to_beat = J.minimal_player_age

	var/diff = age_to_beat - C.player_age
	return (diff > 0) ? diff : 0

#undef WHITELISTFILE
