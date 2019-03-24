#define WHITELISTFILE "data/whitelist.txt"

var/list/whitelist = list()

/hook/startup/proc/loadWhitelist()
	if (config.usewhitelist)
		load_whitelist()
	return 1

/proc/load_whitelist()
	if (config.sql_whitelists)
		establish_db_connection(dbcon)

		if (!dbcon.IsConnected())
			//Continue with the old code if we have no database.
			error("Database connection failed while loading whitelists. Reverting to legacy system.")
			config.sql_whitelists = 0
		else
			return

	whitelist = file2list(WHITELISTFILE)
	if (!whitelist.len)
		whitelist = null

/proc/check_whitelist(mob/M)
	if (config.sql_whitelists)
		var/head_of_staff_whitelist = 1
		if (M.client && M.client.whitelist_status)
			return (M.client.whitelist_status & head_of_staff_whitelist)

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
		establish_db_connection(dbcon)

		if (!dbcon.IsConnected())
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

	if (istype(species, /datum/species))
		if (!(S.spawn_flags & IS_WHITELISTED))
			return TRUE

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
