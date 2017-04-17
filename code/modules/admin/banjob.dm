//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

var/list/jobban_keylist = list() // Global jobban list.

/*
 * Expected format:
 * list("canonckey1" = list("jobname"  = list("reason", time),
 *							"jobname2" = list("reason", time)),
 *		"canonckey2" = list("jobname"  = list("reason", time)))
 *
 * And yes, this is all actually savefile compatible, as they can load and
 * save associated lists quite neatly. Assoc lists remove the stupid amounts
 * of for-looping and string searching, and allow you to simply grab a ban with:
 *
 * jobban_keylist[ckey][job]
 *
 * If record doesn't exist, he's not banned there. As easy as that.
 *
 * "time" should be BYOND realtime. For MySQL bans, it's not relevant, so we
 * can get away with just using this. For permanent bans, leave 0.
 *
 * - Skull132, 17APR2017
 */

/**
 * @name	loadJobBans
 * @desc	Global hook for loading jobbans.
 *
 * @return	num		1
 */
/hook/startup/proc/loadJobBans()
	if (config.ban_legacy_system)
		jobban_loaddatabase()
	else
		jobban_loadbanfile()
	return 1

/**
 * @name	jobban_fullban
 * @desc	Logs a new jobban for a user.
 *			Will then log the ban to the database (if SQL bans), or orders the
 *			save file to be resaved.
 *
 * @param	mob M		The mob containing the user we wish to apply the jobban to.
 * @param	str rank	The string name of the rank we want to ban the user from.
 * @param	str reason	The reason for the ban.
 * @param	num minutes	The length of the ban in minutes. -1 for permanent.
 * @param	datum/admins holder		The holder of the admin doing the unbanning.
 *						required to access the DB ban procs.
 *
 * @return	null
 */
/proc/jobban_fullban(mob/M, rank, reason, minutes, datum/admins/holder)
	if (!M || !M.ckey)
		return

	// Because we have to be certain. This is a bit stupid, but okay. We're validating
	// both usr and checking if the holder exists. Usr should have lowest rights,
	// in case of href hacking.
	if (!holder || !check_rights(R_BAN, 0))
		return

	var/key = M.ckey

	// Create a new record if the client isn't logged already.
	if (!jobban_keylist[key])
		jobban_keylist[key] = list()

	// Sanity catch. This shouldn't happen, but better safe than sorry.
	if (jobban_keylist[key][rank] && !jobban_isexpired(jobban_keylist[key][rank], M, rank))
		log_and_message_admins("Attempted to apply a jobban to [key] while they already have an active ban. Job: [rank].")
		return

	// Set the expirey time in case of temp bans.
	if (minutes > -1)
		minutes = world.realtime + (minutes MINUTES)

	// Create the entry.
	jobban_keylist[key][rank] = list(reason, minutes)

	// Log the ban to the appropriate place.
	if (config.ban_legacy_system)
		jobban_savebanfile()
	else
		var/bantype = (minutes < 0) ? BANTYPE_JOB_PERMA : BANTYPE_JOB_TEMP
		holder.DB_ban_record(bantype, M, minutes, reason, rank)
		return

/**
 * @name	jobban_isbanned
 * @desc	Checks if the player attached to the given mob M is banned from
 *			the given rank. Returns 0 if client is not banned, a reason (str)
 *			if is banned.
 *
 *			If an antagonist role is sent, then the global "Antagonist" ban rank
 *			is also checked for.
 *
 * @param	mob M		The mob holding the client to be checked for a jobban.
 * @param	str rank	The rank name that we're looking for a ban on.
 *
 * @return	mixed		str containing the ban reason if user is banned.
 *						null if user is not banned from given role.
 */
/proc/jobban_isbanned(mob/M, rank)
	if (M && M.ckey && rank)
		if (guest_jobbans(rank))
			if (config.guest_jobban && IsGuestKey(M.ckey))
				return "Guest Job-ban"
			if (config.usewhitelist && !check_whitelist(M))
				return "Whitelisted Job"

		var/static/list/antag_bantypes

		if (isnull(antag_bantypes))
			antag_bantypes = list()
			for (var/antag_type in all_antag_types)
				var/datum/antagonist/antag = all_antag_types[antag_type]
				if (antag && antag.bantype)
					antag_bantypes |= antag.bantype

		// We manage antagonist bans at this end point.
		// Alternative is to manage it at each call to jobban_isbanned, however,
		// there is no actual reason why you should be able to play an antag if you're banned from all of them.
		var/antag_ban = FALSE
		if (rank in antag_bantypes)
			antag_ban = TRUE

		// Get the user's ckey.
		var/list/entry = jobban_keylist[M.ckey]

		// If this is false, then we have no entry. As such, they have no active
		// bans!
		if (entry)
			// Look for the rank specific ban.
			var/list/ban = entry[rank]

			// We have it, return it!
			if (ban && !jobban_isexpired(ban, entry))
				return ban[1]

			// Catch for global antagonist bans as a failsafe.
			if (antag_ban)
				ban = entry["Antagonist"]
				if (ban && !jobban_isexpired(ban, entry))
					return ban[1]

	return null

/**
 * @name	jobban_loadbanfile()
 * @desc	Loads all currently saved jobbans from the data/job_full.ban file.
 *
 * @return	null
 */
/proc/jobban_loadbanfile()
	var/savefile/S = new("data/job_full.ban")
	S["bans"] >> jobban_keylist
	log_admin("Loading jobban_rank")

	if (!jobban_keylist)
		jobban_keylist = list()
		log_admin("jobban_keylist was empty")

/**
 * @name	jobban_loaddatabase()
 * @desc	Loads all currently active bans from the database. Sets expiration
 *			times to 0, as the query refreshes records every time it's pulled.
 *			Unlike the hard file bans.
 *
 * @return	null
 */
/proc/jobban_loaddatabase()
	// No database. Weee.
	if (!establish_db_connection(dbcon))
		error("Database connection failed. Reverting to the legacy ban system.")
		log_misc("Database connection failed. Reverting to the legacy ban system.")
		config.ban_legacy_system = 1
		jobban_loadbanfile()
		return

	// All jobbans in one query. Because we don't actually care.
	var/DBQuery/query = dbcon.NewQuery("SELECT id, ckey, job, reason FROM ss13_ban WHERE isnull(unbanned) AND ((bantype = 'JOB_PERMABAN') OR (bantype = 'JOB_TEMPBAN' AND expiration_time > Now()))")
	query.Execute()

	while (query.NextRow())
		var/ckey = ckey(query.item[2])
		var/job = query.item[3]
		var/reason = query.item[4]

		if (!jobban_keylist[ckey])
			jobban_keylist[ckey] = list()

		if (!jobban_keylist[ckey][job])
			// Insert it with 0 time because the expiration of a temp jobban for
			// MySQL is dependent on the database and query itself. So we can just
			// politely not care.
			jobban_keylist[ckey][job] = list(reason, -1)
		else
			// Woups. What happened here...?
			log_and_message_admins("JOBBANS: Duplicate jobban entry in MySQL for [ckey]. Ban ID: #[query.item[1]]")

/**
 * @name	jobban_savebanfile()
 * @desc	Saves the current bans into the data/job_full.ban file.
 *
 * @return	null
 */
/proc/jobban_savebanfile()
	var/savefile/S = new("data/job_full.ban")
	S["bans"] << jobban_keylist

/**
 * @name	jobban_unban()
 * @desc	Removes a jobban entry from the code and calls the config appropriate
 *			record removal method. In case of legacy bans, jobban file is updated,
 *			otherwise, DB queries are ran.
 *
 * @param	mob M		The mob holding the ckey to be unbanned.
 * @param	str rank	The job from which we want to unban the given player.
 * @param	str ckey	A ckey of the player to be unbanned. This works as a backup
 *						in case a mob is never sent.
 * @param	datum/admins holder	The holder of the admin doing the unbanning.
 *						required to access the DB ban procs.
 *
 * @return	null
 */
/proc/jobban_unban(mob/M, rank, ckey = null, datum/admins/holder)
	if (M && M.ckey)
		ckey = M.ckey
	else if (!ckey)
		log_debug("JOBBAN: jobban_unban called without a mob and a backup ckey.")
		return

	// Check for a player record.
	var/list/entry = jobban_keylist[ckey]
	if (entry)
		// Find the specific ban.
		var/list/ban = entry[rank]
		if (ban)
			// Remove said ban. Lists pass by ref, so this is fine.
			entry -= rank

			// If the entry is now empty, remove the entire ckey from the list.
			if (!entry.len)
				jobban_keylist -= ckey

			// Update appropriate ban files.
			if (config.ban_legacy_system)
				jobban_savebanfile()
			else if (holder && check_rights(R_BAN, 0))
				holder.DB_ban_unban(ckey, BANTYPE_JOB_PERMA, rank)

/**
 * @name	jobban_isexpired
 * @desc	Checks whether or not a jobban is expired. If a ban is expired,
 *			it'll call jobban_unban to lift the ban. This allows for temporary
 *			jobbans with the old file system.
 *
 *			Does not work on the MySQL system. The bans for that refresh every
 *			round, as per the queries.
 *
 * @param	list tuple	The list containing reason and expiery time to check.
 * @param	mob M		The mob whose ban we're checking. To be passed into jobban_unban
 *						in the case of an expired ban.
 * @param	str rank	The job we're checking. To be passed into jobban_unban in case
 *						of an expired ban.
 * @param	str ckey	The ckey of the player being checked. Can be null, is null
 *						by default. To be sent to jobban_unban.
 *
 * @return	num		TRUE if ban is expired.
 *					FALSE if ban is not expired.
 */
/proc/jobban_isexpired(var/list/tuple, var/mob/M, var/rank, var/ckey = null)
	if (config.ban_legacy_system && tuple[2] && (tuple[2] > 0) && (tuple[2] < world.realtime))
		// It's expired. Remove it.
		jobban_unban(M, rank, ckey, null)

		return TRUE

	return FALSE

/**
 * @name	ban_unban_log_save
 * @desc	Updates the ban_unban_log.txt file by appending formatted_log to its
 *			contents.
 *
 * @param	str formatted_log	The new content to be appended to the log file.
 *
 * @return	null
 */
/proc/ban_unban_log_save(var/formatted_log)
	text2file(formatted_log,"data/ban_unban_log.txt")
