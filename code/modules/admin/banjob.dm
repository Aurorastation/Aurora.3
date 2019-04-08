#define CKEY_OR_MOB(tgt, ref)		\
	if (istext(ref)) {				\
		tgt = ckey(ref);			\
		var/mob/CKM = locate(ref);	\
		if (CKM && istype(CKM)) {	\
			if (CKM.ckey) {			\
				tgt = CKM.ckey;		\
			} else {				\
				tgt = null;			\
			}						\
		}							\
	} else if (ismob(ref)) {		\
		var/mob/CKM = ref;			\
		tgt = CKM.ckey;				\
	}

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
 * Global hook for loading jobbans.
 *
 * @return	num		1
 */
/hook/startup/proc/loadJobBans()
	if (config.ban_legacy_system)
		jobban_loadbanfile()
	else
		jobban_loaddatabase()

	return 1

/**
 * Logs a new jobban for a user.
 * Will save the bans to a save file if we're using the legacy system. Otherwise,
 * should be called via DB_ban_record.
 *
 * @param	str|mob player	The mob object or ckey of the player we're looking for.
 * @param	str rank	The string name of the rank we want to ban the user from.
 * @param	str reason	The reason for the ban.
 * @param	num minutes	The length of the ban in minutes. -1 for permanent.
 * @param	datum/admins holder		The holder of the admin doing the unbanning.
 *						required to access the DB ban procs.
 */
/proc/jobban_fullban(player, rank, reason, minutes)
	var/key = null

	CKEY_OR_MOB(key, player)

	if (!key)
		return

	// Create a new record if the client isn't logged already.
	if (!jobban_keylist[key])
		jobban_keylist[key] = list()

	// Sanity catch. This shouldn't happen, but better safe than sorry.
	if (jobban_keylist[key][rank] && !jobban_isexpired(jobban_keylist[key][rank], player, rank))
		log_and_message_admins("Attempted to apply a jobban to [key] while they already have an active ban. Job: [rank].")
		return

	// Set the expirey time in case of temp bans.
	var/unban_time = minutes
	if (minutes > -1)
		unban_time = world.realtime + (minutes MINUTES)

	// Create the entry.
	jobban_keylist[key][rank] = list(reason, unban_time)

	// Log the ban to the appropriate place.
	if (config.ban_legacy_system)
		jobban_savebanfile()
	else
		DB_ban_record(minutes < 0 ? BANTYPE_JOB_PERMA : BANTYPE_JOB_TEMP, null, minutes, reason, rank, banckey = key)

/**
 * Checks if the player attached to the given mob M is banned from
 * the given rank. Returns 0 if client is not banned, a reason (str)
 * if is banned.
 *
 * If an antagonist role is sent, then the global "Antagonist" ban rank
 * is also checked for.
 *
 * @param	str|mob player	The mob object or ckey of the player we're looking for.
 * @param	str rank	The rank name that we're looking for a ban on.
 *
 * @return	mixed		str containing the ban reason if user is banned.
 *						null if user is not banned from given role.
 */
/proc/jobban_isbanned(player, rank)
	var/ckey = null
	CKEY_OR_MOB(ckey, player)

	if (ckey)
		if (guest_jobbans(rank))
			if (config.guest_jobban && IsGuestKey(ckey))
				return "GUEST JOB-BAN"
			if (config.usewhitelist && ismob(player) && !check_whitelist(player))
				return "WHITELISTED"

		var/age_whitelist = player_old_enough_for_role(player, rank)
		if (age_whitelist)
			return "AGE WHITELISTED"

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
		var/list/entry = jobban_keylist[ckey]

		// If this is false, then we have no entry. As such, they have no active
		// bans!
		if (entry)
			// Look for the rank specific ban.
			var/list/ban = entry[rank]

			// We have it, return it!
			if (ban && !jobban_isexpired(ban, player, rank))
				return ban[1]

			// Catch for global antagonist bans as a failsafe.
			if (antag_ban)
				ban = entry["Antagonist"]
				if (ban && !jobban_isexpired(ban, player, rank))
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
 * Loads all currently active bans from the database. Sets expiration
 * times to 0, as the query refreshes records every time it's pulled.
 * Unlike the hard file bans.
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
 * Saves the current bans into the data/job_full.ban file.
 */
/proc/jobban_savebanfile()
	var/savefile/S = new("data/job_full.ban")
	S["bans"] << jobban_keylist

/**
 * Removes a jobban entry from the code and calls the config appropriate
 * record removal method. In case of legacy bans, jobban file is updated.
 *
 * For the DB system, the DB_ban_unban_by_id method calls this to remove the local
 * instance of the ban.
 *
 * @param	str|mob player	The mob object or ckey of the player we're looking for.
 * @param	str rank	The job from which we want to unban the given player.
 */
/proc/jobban_unban(player, rank)
	var/ckey = null

	CKEY_OR_MOB(ckey, player)

	if (!ckey)
		log_debug("JOBBAN: jobban_unban called without a mob and a backup ckey.")
		return

	// Check for a player record.
	var/list/entry = jobban_keylist[ckey]
	if (entry)
		// Find the specific ban.
		var/list/ban = entry[rank]
		if (ban)
			// Remove said ban. Lists pass by ref, so this is fine.
			entry[rank] = null
			entry -= rank

			// If the entry is now empty, remove the entire ckey from the list.
			if (!entry.len)
				jobban_keylist[ckey] = null
				jobban_keylist -= ckey

			// Update appropriate ban files.
			if (config.ban_legacy_system)
				jobban_savebanfile()

/**
 * Checks whether or not a jobban is expired. If a ban is expired,
 * it'll call jobban_unban to lift the ban. This allows for temporary
 * jobbans with the old file system.
 *
 * Does not work on the MySQL system. The bans for that refresh every
 * round, as per the queries.
 *
 * @param	list tuple	The list containing reason and expiery time to check.
 * @param	str|mob player	The mob object or ckey of the player we're looking for.
 * @param	str rank	The job we're checking. To be passed into jobban_unban in case
 *						of an expired ban.
 *
 * @return	num		TRUE if ban is expired.
 *					FALSE if ban is not expired.
 */
/proc/jobban_isexpired(var/list/tuple, var/player, var/rank)
	if (config.ban_legacy_system && tuple[2] && (tuple[2] > 0) && (tuple[2] < world.realtime))
		// It's expired. Remove it.
		jobban_unban(player, rank)

		return TRUE

	return FALSE

/**
 * Updates the ban_unban_log.txt file by appending formatted_log to its
 * contents.
 *
 * @param	str formatted_log The new content to be appended to the log file.
 */
/proc/ban_unban_log_save(var/formatted_log)
	text2file(formatted_log, "data/ban_unban_log.txt")

/**
 * Opens the jobban panel, showing the bans of the passed mob or ckey.
 *
 * @param	str|mob tgt_ref The target we want to view jobbans of. Can be a reference
 * to a mob object (gotten with \ref[M]) or an actual mob object.
 */
/datum/admins/proc/jobban_panel(var/tgt_ref = null)
	if (!tgt_ref)
		return

	// Check against usr's perms.
	if (!check_rights(R_ADMIN|R_MOD|R_BAN))
		return

	var/ckey = null
	CKEY_OR_MOB(ckey, tgt_ref)

	if (!ckey)
		to_chat(src.owner, "This mob has no ckey.")
		return

	var/dat = ""
	var/header = "<head><title>Job-Ban Panel: [ckey]</title></head>"
	var/body
	var/jobs = ""

	/***********************************WARNING!************************************
						The jobban stuff looks mangled and disgusting
								But it looks beautiful in-game
										-Nodrak
	************************************WARNING!***********************************/
	var/counter = 0
	//Regular jobs
	//Command (Blue)
	jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
	jobs += "<tr align='center' bgcolor='ccccff'><th colspan='[length(command_positions)]'><a href='?src=\ref[src];jobban_job=commanddept;jobban_tgt=[ckey]'>Command Positions</a></th></tr><tr align='center'>"
	for (var/jobPos in command_positions)
		if (!jobPos)
			continue
		var/datum/job/job = SSjobs.GetJob(jobPos)
		if (!job)
			continue

		if (jobban_isbanned(ckey, job.title))
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban_job=[job.title];jobban_tgt=[ckey]'><font color=red>[replacetext(job.title, " ", "&nbsp")]</font></a></td>"
			counter++
		else
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban_job=[job.title];jobban_tgt=[ckey]'>[replacetext(job.title, " ", "&nbsp")]</a></td>"
			counter++

		if (counter >= 6) //So things dont get squiiiiished!
			jobs += "</tr><tr>"
			counter = 0
	jobs += "</tr></table>"

	//Security (Red)
	counter = 0
	jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
	jobs += "<tr bgcolor='ffddf0'><th colspan='[length(security_positions)]'><a href='?src=\ref[src];jobban_job=securitydept;jobban_tgt=[ckey]'>Security Positions</a></th></tr><tr align='center'>"
	for (var/jobPos in security_positions)
		if (!jobPos)
			continue
		var/datum/job/job = SSjobs.GetJob(jobPos)
		if (!job)
			continue

		if (jobban_isbanned(ckey, job.title))
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban_job=[job.title];jobban_tgt=[ckey]'><font color=red>[replacetext(job.title, " ", "&nbsp")]</font></a></td>"
			counter++
		else
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban_job=[job.title];jobban_tgt=[ckey]'>[replacetext(job.title, " ", "&nbsp")]</a></td>"
			counter++

		if (counter >= 5) //So things dont get squiiiiished!
			jobs += "</tr><tr align='center'>"
			counter = 0
	jobs += "</tr></table>"

	//Engineering (Yellow)
	counter = 0
	jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
	jobs += "<tr bgcolor='fff5cc'><th colspan='[length(engineering_positions)]'><a href='?src=\ref[src];jobban_job=engineeringdept;jobban_tgt=[ckey]'>Engineering Positions</a></th></tr><tr align='center'>"
	for (var/jobPos in engineering_positions)
		if (!jobPos)
			continue
		var/datum/job/job = SSjobs.GetJob(jobPos)
		if (!job)
			continue

		if (jobban_isbanned(ckey, job.title))
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban_job=[job.title];jobban_tgt=[ckey]'><font color=red>[replacetext(job.title, " ", "&nbsp")]</font></a></td>"
			counter++
		else
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban_job=[job.title];jobban_tgt=[ckey]'>[replacetext(job.title, " ", "&nbsp")]</a></td>"
			counter++

		if (counter >= 5) //So things dont get squiiiiished!
			jobs += "</tr><tr align='center'>"
			counter = 0
	jobs += "</tr></table>"

	//Medical (White)
	counter = 0
	jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
	jobs += "<tr bgcolor='ffeef0'><th colspan='[length(medical_positions)]'><a href='?src=\ref[src];jobban_job=medicaldept;jobban_tgt=[ckey]'>Medical Positions</a></th></tr><tr align='center'>"
	for (var/jobPos in medical_positions)
		if (!jobPos)
			continue
		var/datum/job/job = SSjobs.GetJob(jobPos)
		if (!job)
			continue

		if (jobban_isbanned(ckey, job.title))
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban_job=[job.title];jobban_tgt=[ckey]'><font color=red>[replacetext(job.title, " ", "&nbsp")]</font></a></td>"
			counter++
		else
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban_job=[job.title];jobban_tgt=[ckey]'>[replacetext(job.title, " ", "&nbsp")]</a></td>"
			counter++

		if (counter >= 5) //So things dont get squiiiiished!
			jobs += "</tr><tr align='center'>"
			counter = 0
	jobs += "</tr></table>"

	//Science (Purple)
	counter = 0
	jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
	jobs += "<tr bgcolor='e79fff'><th colspan='[length(science_positions)]'><a href='?src=\ref[src];jobban_job=sciencedept;jobban_tgt=[ckey]'>Science Positions</a></th></tr><tr align='center'>"
	for (var/jobPos in science_positions)
		if (!jobPos)
			continue
		var/datum/job/job = SSjobs.GetJob(jobPos)
		if (!job)
			continue

		if (jobban_isbanned(ckey, job.title))
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban_job=[job.title];jobban_tgt=[ckey]'><font color=red>[replacetext(job.title, " ", "&nbsp")]</font></a></td>"
			counter++
		else
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban_job=[job.title];jobban_tgt=[ckey]'>[replacetext(job.title, " ", "&nbsp")]</a></td>"
			counter++

		if (counter >= 5) //So things dont get squiiiiished!
			jobs += "</tr><tr align='center'>"
			counter = 0
	jobs += "</tr></table>"

	//Cargo (Brown ish)
	counter = 0
	jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
	jobs += "<tr bgcolor='f49d50'><th colspan='[length(cargo_positions)]'><a href='?src=\ref[src];jobban_job=cargodept;jobban_tgt=[ckey]'>Cargo Positions</a></th></tr><tr align='center'>"
	for (var/jobPos in cargo_positions)
		if (!jobPos)
			continue
		var/datum/job/job = SSjobs.GetJob(jobPos)
		if (!job)
			continue

		if (jobban_isbanned(ckey, job.title))
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban_job=[job.title];jobban_tgt=[ckey]'><font color=red>[replacetext(job.title, " ", "&nbsp")]</font></a></td>"
			counter++
		else
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban_job=[job.title];jobban_tgt=[ckey]'>[replacetext(job.title, " ", "&nbsp")]</a></td>"
			counter++

		if (counter >= 5)
			jobs += "</tr><tr align='center'>"
			counter = 0

	//Civilian (Grey)
	counter = 0
	jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
	jobs += "<tr bgcolor='dddddd'><th colspan='[length(civilian_positions)]'><a href='?src=\ref[src];jobban_job=civiliandept;jobban_tgt=[ckey]'>Civilian Positions</a></th></tr><tr align='center'>"
	for (var/jobPos in civilian_positions)
		if (!jobPos)
			continue
		var/datum/job/job = SSjobs.GetJob(jobPos)
		if (!job)
			continue

		if (jobban_isbanned(ckey, job.title))
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban_job=[job.title];jobban_tgt=[ckey]'><font color=red>[replacetext(job.title, " ", "&nbsp")]</font></a></td>"
			counter++
		else
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban_job=[job.title];jobban_tgt=[ckey]'>[replacetext(job.title, " ", "&nbsp")]</a></td>"
			counter++

		if (counter >= 5) //So things dont get squiiiiished!
			jobs += "</tr><tr align='center'>"
			counter = 0

	if (jobban_isbanned(ckey, "Internal Affairs Agent"))
		jobs += "<td width='20%'><a href='?src=\ref[src];jobban_job=Internal Affairs Agent;jobban_tgt=[ckey]'><font color=red>Internal Affairs Agent</font></a></td>"
	else
		jobs += "<td width='20%'><a href='?src=\ref[src];jobban_job=Internal Affairs Agent;jobban_tgt=[ckey]'>Internal Affairs Agent</a></td>"

	jobs += "</tr></table>"

	//Adhomai jobs
	counter = 0
	jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
	jobs += "<tr bgcolor='007fff '><th colspan='[length(adhomai_positions)]'><a href='?src=\ref[src];jobban_job=adhomaidep;jobban_tgt=[ckey]'>Adhomai Positions</a></th></tr><tr align='center'>"
	for (var/jobPos in adhomai_positions)
		if (!jobPos)
			continue
		var/datum/job/job = SSjobs.GetJob(jobPos)
		if (!job)
			continue

		if (jobban_isbanned(ckey, job.title))
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban_job=[job.title];jobban_tgt=[ckey]'><font color=red>[replacetext(job.title, " ", "&nbsp")]</font></a></td>"
			counter++
		else
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban_job=[job.title];jobban_tgt=[ckey]'>[replacetext(job.title, " ", "&nbsp")]</a></td>"
			counter++

		if (counter >= 5)
			jobs += "</tr><tr align='center'>"
			counter = 0

	//Non-Human (Green)
	counter = 0
	jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
	jobs += "<tr bgcolor='ccffcc'><th colspan='[length(nonhuman_positions)+1]'><a href='?src=\ref[src];jobban_job=nonhumandept;jobban_tgt=[ckey]'>Non-human Positions</a></th></tr><tr align='center'>"
	for (var/jobPos in nonhuman_positions)
		if (!jobPos)
			continue
		var/datum/job/job = SSjobs.GetJob(jobPos)
		if (!job)
			continue

		if (jobban_isbanned(ckey, job.title))
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban_job=[job.title];jobban_tgt=[ckey]'><font color=red>[replacetext(job.title, " ", "&nbsp")]</font></a></td>"
			counter++
		else
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban_job=[job.title];jobban_tgt=[ckey]'>[replacetext(job.title, " ", "&nbsp")]</a></td>"
			counter++

		if (counter >= 5) //So things dont get squiiiiished!
			jobs += "</tr><tr align='center'>"
			counter = 0

	//pAI isn't technically a job, but it goes in here.

	if (jobban_isbanned(ckey, "pAI"))
		jobs += "<td width='20%'><a href='?src=\ref[src];jobban_job=pAI;jobban_tgt=[ckey]'><font color=red>pAI</font></a></td>"
	else
		jobs += "<td width='20%'><a href='?src=\ref[src];jobban_job=pAI;jobban_tgt=[ckey]'>pAI</a></td>"
	if (jobban_isbanned(ckey, "AntagHUD"))
		jobs += "<td width='20%'><a href='?src=\ref[src];jobban_job=AntagHUD;jobban_tgt=[ckey]'><font color=red>AntagHUD</font></a></td>"
	else
		jobs += "<td width='20%'><a href='?src=\ref[src];jobban_job=AntagHUD;jobban_tgt=[ckey]'>AntagHUD</a></td>"
	jobs += "</tr></table>"

	//Antagonist (Orange)
	var/isbanned_dept = jobban_isbanned(ckey, "Antagonist")
	jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
	jobs += "<tr bgcolor='ffeeaa'><th colspan='10'><a href='?src=\ref[src];jobban_job=Antagonist;jobban_tgt=[ckey]'>Antagonist Positions</a></th></tr><tr align='center'>"

	// Antagonists.
	counter = 0
	for (var/antag_type in all_antag_types)
		var/datum/antagonist/antag = all_antag_types[antag_type]
		if (!antag || !antag.bantype)
			continue
		if (isbanned_dept || jobban_isbanned(ckey, antag.bantype))
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban_job=[antag.bantype];jobban_tgt=[ckey]'><font color=red>[replacetext("[antag.role_text]", " ", "&nbsp")]</font></a></td>"
		else
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban_job=[antag.bantype];jobban_tgt=[ckey]'>[replacetext("[antag.role_text]", " ", "&nbsp")]</a></td>"

		counter++

		if (counter >= 5) //So things dont get squiiiiished!
			jobs += "</tr><tr align='center'>"
			counter = 0

	jobs += "</tr></table>"

	//Other races  (BLUE, because I have no idea what other color to make this)
	jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
	jobs += "<tr bgcolor='ccccff'><th colspan='1'>Other Races</th></tr><tr align='center'>"

	if (jobban_isbanned(ckey, "Dionaea"))
		jobs += "<td width='20%'><a href='?src=\ref[src];jobban_job=Dionaea;jobban_tgt=[ckey]'><font color=red>Dionaea</font></a></td>"
	else
		jobs += "<td width='20%'><a href='?src=\ref[src];jobban_job=Dionaea;jobban_tgt=[ckey]'>Dionaea</a></td>"
	jobs += "</tr></table>"
	body = "<body>[jobs]</body>"
	dat = "<tt>[header][body]</tt>"
	usr << browse(dat, "window=jobban_panel;size=800x490")
	return

/**
 * Handles the insertion of a new job ban. Currently called from /datum/admins/Topic().
 *
 * Relays a new ban to jobban_fullban and also manages database insertions where needed.
 *
 * @param	str tgt_ref	The \ref[] of the target mob we want to dinbannu.
 * @param	str job		The name of the job we want to ban the target from.
 *
 * @return	num		1 if something was done.
 * 					0 otherwise.
 */
/datum/admins/proc/jobban_handle(var/tgt_ref, var/job)
	if (!check_rights(R_MOD, 0) && !check_rights(R_ADMIN, 0))
		to_chat(usr, "<span class='warning'>You do not have the appropriate permissions to add job bans!</span>")
		return 0

	if (check_rights(R_MOD, 0) && !check_rights(R_ADMIN, 0) && !config.mods_can_job_tempban) // If mod and tempban disabled
		to_chat(usr, "<span class='warning'>Mod jobbanning is disabled!</span>")
		return 0

	var/ckey = null
	CKEY_OR_MOB(ckey, tgt_ref)

	if (!ckey)
		to_chat(usr, "<span class='warning'>No valid target sent. Cancelling.</span>")
		return 0

	if (admin_datums[ckey])
		if (ckey != usr.ckey)										//we can jobban ourselves
			var/datum/admins/other_holder = admin_datums[ckey]
			if(other_holder && (other_holder.rights & R_BAN))		//they can ban too. So we can't ban them
				alert("You cannot perform this action. You must be of a higher administrative rank!")
				return 0

	//get jobs for department if specified, otherwise just returnt he one job in a list.
	var/list/joblist = list()
	switch (job)
		if ("commanddept")
			for (var/jobPos in command_positions)
				if (!jobPos)
					continue
				var/datum/job/temp = SSjobs.GetJob(jobPos)
				if (!temp)
					continue
				joblist += temp.title
		if ("securitydept")
			for (var/jobPos in security_positions)
				if (!jobPos)
					continue
				var/datum/job/temp = SSjobs.GetJob(jobPos)
				if (!temp)
					continue
				joblist += temp.title
		if ("engineeringdept")
			for (var/jobPos in engineering_positions)
				if (!jobPos)
					continue
				var/datum/job/temp = SSjobs.GetJob(jobPos)
				if (!temp)
					continue
				joblist += temp.title
		if ("medicaldept")
			for (var/jobPos in medical_positions)
				if (!jobPos)
					continue
				var/datum/job/temp = SSjobs.GetJob(jobPos)
				if (!temp)
					continue
				joblist += temp.title
		if ("sciencedept")
			for (var/jobPos in science_positions)
				if (!jobPos)
					continue
				var/datum/job/temp = SSjobs.GetJob(jobPos)
				if (!temp)
					continue
				joblist += temp.title
		if ("civiliandept")
			for (var/jobPos in civilian_positions)
				if (!jobPos)
					continue
				var/datum/job/temp = SSjobs.GetJob(jobPos)
				if (!temp)
					continue
				joblist += temp.title
		if ("nonhumandept")
			joblist += "pAI"
			for (var/jobPos in nonhuman_positions)
				if (!jobPos)
					continue
				var/datum/job/temp = SSjobs.GetJob(jobPos)
				if (!temp)
					continue
				joblist += temp.title
		if ("cargodept")
			for (var/jobPos in cargo_positions)
				if (!jobPos)
					continue
				var/datum/job/temp = SSjobs.GetJob(jobPos)
				if (!temp)
					continue
				joblist += temp.title
		if ("adhomaidep")
			for (var/jobPos in adhomai_positions)
				if (!jobPos)
					continue
				var/datum/job/temp = SSjobs.GetJob(jobPos)
				if (!temp)
					continue
				joblist += temp.title
		else
			joblist += job

	//Create a list of unbanned jobs within joblist
	var/list/notbannedlist = list()
	for (var/R in joblist)
		if (!jobban_isbanned(ckey, R))
			notbannedlist += R

	//Banning comes first
	if (notbannedlist.len) //at least 1 unbanned job exists in joblist so we have stuff to ban.
		switch (alert("Temporary Ban?",,"Yes","No", "Cancel"))
			if ("Yes")
				if (!check_rights(R_MOD,0) && !check_rights(R_BAN, 0))
					to_chat(usr, "<span class='warning'>You Cannot issue temporary job-bans!</span>")
					return 0
				var/mins = input(usr, "How long (in minutes)?", "Ban time", 1440) as num|null
				if (!mins)
					return 0
				if (check_rights(R_MOD, 0) && !check_rights(R_BAN, 0) && mins > config.mod_job_tempban_max)
					to_chat(usr, "<span class='warning'>Moderators can only job tempban up to [config.mod_job_tempban_max] minutes!</span>")
					return 0
				var/reason = sanitize(input(usr,"Reason?","Please State Reason","") as text|null)
				if (!reason)
					return 0

				var/msg
				for (var/R in notbannedlist)
					ban_unban_log_save("[key_name(usr)] temp-jobbanned [ckey] from [R] for [mins] minutes. reason: [reason]")
					log_admin("[key_name(usr)] temp-jobbanned [ckey] from [R] for [mins] minutes",admin_key=key_name(usr))
					feedback_inc("ban_job_tmp", 1)
					feedback_add_details("ban_job_tmp","- [R]")
					jobban_fullban(ckey, R, reason, mins)

					if (!msg)
						msg = R
					else
						msg += ", [R]"
				if (config.ban_legacy_system)
					notes_add(ckey, "Banned from [msg] - [reason]", usr)
				else
					notes_add_sql(ckey, "Banned from [msg] - [reason]", usr)
				message_admins("<span class='notice'>[key_name_admin(usr)] banned [ckey] from [msg] for [mins] minutes.</span>", 1)
				if (ismob(tgt_ref))
					var/mob/M = tgt_ref
					to_chat(M, "<span class='danger'><BIG>You have been jobbanned by [usr.client.ckey] from: [msg].</BIG></span>")
					to_chat(M, "<span class='danger'>The reason is: [reason]</span>")
					to_chat(M, "<span class='warning'>This jobban will be lifted in [mins] minutes.</span>")
				jobban_panel(ckey)
				return 1
			if ("No")
				if (!check_rights(R_BAN))
					return
				var/reason = sanitize(input(usr,"Reason?","Please State Reason","") as text|null)
				if (reason)
					var/msg
					for (var/R in notbannedlist)
						ban_unban_log_save("[key_name(usr)] perma-jobbanned [ckey] from [R]. reason: [reason]")
						log_admin("[key_name(usr)] perma-banned [ckey] from [R]",admin_key=key_name(usr))
						feedback_inc("ban_job", 1)
						feedback_add_details("ban_job", "- [R]")
						jobban_fullban(ckey, R, reason, -1)
						if (!msg)
							msg = R
						else
							msg += ", [R]"

					if (config.ban_legacy_system)
						notes_add(ckey, "Banned  from [msg] - [reason]", usr)
					else
						notes_add_sql(ckey, "Banned from [msg] - [reason]", usr)
					message_admins("<span class='notice'>[key_name_admin(usr)] banned [ckey] from [msg]</span>", 1)
					if (ismob(tgt_ref))
						var/mob/M = tgt_ref
						to_chat(M, "<span class='danger'><BIG>You have been jobbanned by [usr.client.ckey] from: [msg].</BIG></span>")
						to_chat(M, "<span class='danger'>The reason is: [reason]</span>")
						to_chat(M, "<span class='warning'>Jobban can be lifted only upon request.</span>")
					jobban_panel(ckey)
					return 1
			if("Cancel")
				return

	//Unbanning joblist
	//all jobs in joblist are banned already OR we didn't give a reason (implying they shouldn't be banned)
	if (joblist.len) //at least 1 banned job exists in joblist so we have stuff to unban.
		if (!config.ban_legacy_system)
			// This is important. jobban_unban() can't actually lift DB bans. So the DB unban
			// panel must be used instead.
			to_chat(usr, "Unfortunately, database based unbanning cannot be done through this panel")
			DB_ban_panel(ckey)
			return 0

		var/msg
		for (var/R in joblist)
			var/reason = jobban_isbanned(ckey, R)
			if (!reason)
				continue //skip if it isn't jobbanned anyway
			switch (alert("Job: '[R]' Reason: '[reason]' Un-jobban?","Please Confirm","Yes","No"))
				if ("Yes")
					ban_unban_log_save("[key_name(usr)] unjobbanned [ckey] from [R]")
					log_admin("[key_name(usr)] unbanned [ckey] from [R]",admin_key=key_name(usr),ckey=ckey)
					jobban_unban(ckey, R) // Refer to the jobban API.
					feedback_inc("ban_job_unban",1)
					feedback_add_details("ban_job_unban","- [R]")
					if (!msg)
						msg = R
					else
						msg += ", [R]"
				else
					continue
		if (msg)
			message_admins("<span class='notice'>[key_name_admin(usr)] unbanned [ckey] from [msg]</span>", 1)
			if (ismob(tgt_ref))
				var/mob/M = tgt_ref
				to_chat(M, "<span class='danger'><BIG>You have been un-jobbanned by [usr.client.ckey] from [msg].</BIG></span>")
			jobban_panel(ckey)
		return 1
	return 0 //we didn't do anything!

#undef CKEY_OR_MOB
