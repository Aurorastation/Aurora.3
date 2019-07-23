//used for pref.alternate_option
#define GET_RANDOM_JOB 0
#define BE_ASSISTANT 1
#define RETURN_TO_LOBBY 2

/datum/category_item/player_setup_item/occupation
	name = "Occupation"
	sort_order = 1

/datum/category_item/player_setup_item/occupation/load_character(var/savefile/S)
	S["alternate_option"]   >> pref.alternate_option
	S["job_preferences"]    >> pref.job_preferences
	S["faction"]            >> pref.faction

/datum/category_item/player_setup_item/occupation/save_character(var/savefile/S)
	S["alternate_option"]   << pref.alternate_option
	S["job_preferences"]    << pref.job_preferences
	S["faction"]            << pref.faction

/datum/category_item/player_setup_item/occupation/gather_load_query()
	return list(
		"ss13_characters" = list(
			"vars" = list(
				"jobs" = "job_preferences",
				"alternate_option",
				"alternate_titles" = "player_alt_titles",
				"faction"
			),
			"args" = list("id")
		)
	)

/datum/category_item/player_setup_item/occupation/gather_load_parameters()
	return list("id" = pref.current_character)

/datum/category_item/player_setup_item/occupation/gather_save_query()
	return list(
		"ss13_characters" = list(
			"jobs",
			"alternate_option",
			"alternate_titles",
			"faction",
			"id" = 1,
			"ckey" = 1
		)
	)

/datum/category_item/player_setup_item/occupation/gather_save_parameters()
	return list(
		"jobs" = json_encode(pref.job_preferences),
		"alternate_option" = pref.alternate_option,
		"id" = pref.current_character,
		"faction" = pref.faction,
		"ckey" = PREF_CLIENT_CKEY
	)

/datum/category_item/player_setup_item/occupation/sanitize_character(var/sql_load = 0)
	if (sql_load)
		pref.alternate_option = text2num(pref.alternate_option)

	pref.alternate_option  = sanitize_integer(text2num(pref.alternate_option), 0, 2, initial(pref.alternate_option))

	if (istext(pref.job_preferences))
		try
			pref.job_preferences = json_decode(pref.job_preferences)

			var/list/final = list()

			for (var/str in pref.job_preferences)
				var/path = text2path(str)

				if (isnull(path))
					to_client_chat("<span class='danger'>Removed [str] from your job preferences for no longer being a valid choice.</span>")
					continue

				var/safe_num = sanitize_integer(pref.job_preferences[str], JOB_PREFERENCE_LOW, JOB_PREFERENCE_HIGH, 0)
				if (safe_num)
					final[path] = safe_num

			pref.job_preferences = final
		catch(var/exception/e)
			log_debug("LOADING: Bad SQL format in save file. Error: [e.desc]")

	if (!islist(pref.job_preferences))
		pref.job_preferences = list()

	if (!SSjobs.safe_to_sanitize)
		if (!SSjobs.deferred_preference_sanitizations[src])
			SSjobs.deferred_preference_sanitizations[src] = CALLBACK(src, .proc/late_sanitize, sql_load)
	else
		late_sanitize(sql_load)

/datum/category_item/player_setup_item/occupation/proc/late_sanitize(sql_load)
	for (var/path in pref.job_preferences)
		if (!SSjobs.GetJobType(path))
			to_client_chat("<span class='danger'>Removed [path] from your job preferences for no longer being a valid choice.</span>")
			pref.job_preferences -= path

	sanitize_faction()

/datum/category_item/player_setup_item/occupation/content(mob/user, limit = 16, list/splitJobs = list("Chief Engineer", "Head of Security"))
	if (SSjobs.init_state != SS_INITSTATE_DONE)
		return "<center><large>Jobs controller not initialized yet. Please wait a bit and reload this section.</large></center>"

	var/list/dat = list(
		"<center><b>Character faction</b><br>",
		"<small>This will influence the jobs you can select from, and the starting equipment.</small><br>",
		"<b><a href='?src=\ref[src];faction_preview=[html_encode(pref.faction)]'>[pref.faction]</a></b></center><br><hr>"
	)

	dat += list(
		"<tt><center>",
		"<b>Choose occupation chances</b><br>Unavailable occupations are crossed out.<br>",
		"<table width='100%' cellpadding='1' cellspacing='0'><tr><td width='20%'>", // Table within a table for alignment, also allows you to easily add more colomns.
		"<table width='100%' cellpadding='1' cellspacing='0'>"
	)
	var/index = -1

	//The job before the current job. I only use this to get the previous jobs color when I'm filling in blank rows.
	var/datum/job/lastJob

	var/datum/faction/faction = SSjobs.name_factions[pref.faction] || SSjobs.default_faction

	for(var/datum/job/job in faction.get_occupations())
		index += 1
		if((index >= limit) || (job.title in splitJobs))
			if((index < limit) && (lastJob != null))
				//If the cells were broken up by a job in the splitJob list then it will fill in the rest of the cells with
				//the last job's selection color. Creating a rather nice effect.
				for(var/i = 0, i < (limit - index), i += 1)
					dat += "<tr bgcolor='[lastJob.selection_color]'><td width='60%' align='right'><a>&nbsp</a></td><td><a>&nbsp</a></td></tr>"
			dat += "</table></td><td width='20%'><table width='100%' cellpadding='1' cellspacing='0'>"
			index = 0

		dat += "<tr bgcolor='[job.selection_color]'><td width='60%' align='right'>"
		var/rank = job.title
		lastJob = job
		var/ban_reason = jobban_isbanned(user, rank)
		if(ban_reason == "WHITELISTED")
			dat += "<del>[rank]</del></td><td><b> \[WHITELISTED]</b></td></tr>"
			continue
		else if (ban_reason == "AGE WHITELISTED")
			var/available_in_days = player_old_enough_for_role(user.client, rank)
			dat += "<del>[rank]</del></td><td> \[IN [(available_in_days)] DAYS]</td></tr>"
			continue
		else if (ban_reason)
			dat += "<del>[rank]</del></td><td><b> \[<a href='?src=\ref[user.client];view_jobban=\ref[rank];'>BANNED</a>]</b></td></tr>"
			continue
		if(pref.HasJobSelected(SSjobs.GetJob("Assistant"), JOB_PREFERENCE_LOW) && (rank != "Assistant"))
			dat += "<font color=orange>[rank]</font></td><td></td></tr>"
			continue
		if((rank in command_positions) || (rank == "AI"))//Bold head jobs
			dat += "<b>[rank]</b>"
		else
			dat += "[rank]"

		dat += "</td><td width='40%'>"

		dat += "<a href='?src=\ref[src];set_job=[rank]'>"

		if(rank == "Assistant")//Assistant is special
			if(pref.HasJobSelected(job, JOB_PREFERENCE_LOW))
				dat += " <font color=green>\[Yes]</font>"
			else
				dat += " <font color=red>\[No]</font>"
//			if(job.has_alt_titles()) //Blatantly cloned from a few lines down.
//				dat += "</a></td></tr><tr bgcolor='[lastJob.selection_color]'><td width='60%' align='center'>&nbsp</td><td><a href='?src=\ref[src];select_alt_title=\ref[job]'>\[[pref.GetPlayerAltTitle(job)]\]</a></td></tr>"
			dat += "</a></td></tr>"
			continue

		if(pref.HasJobSelected(job, JOB_PREFERENCE_HIGH))
			dat += " <font color=blue>\[High]</font>"
		else if(pref.HasJobSelected(job, JOB_PREFERENCE_MEDIUM))
			dat += " <font color=green>\[Medium]</font>"
		else if(pref.HasJobSelected(job, JOB_PREFERENCE_LOW))
			dat += " <font color=orange>\[Low]</font>"
		else
			dat += " <font color=red>\[NEVER]</font>"

		// FIGURE OUT ALT TITLES HERE.

		dat += "</a></td></tr>"

	dat += "</td'></tr></table>"

	dat += "</center></table>"

	switch(pref.alternate_option)
		if(GET_RANDOM_JOB)
			dat += "<center><br><u><a href='?src=\ref[src];job_alternative=1'><font color=green>Get random job if preferences unavailable</font></a></u></center><br>"
		if(BE_ASSISTANT)
			dat += "<center><br><u><a href='?src=\ref[src];job_alternative=1'><font color=red>Be assistant if preference unavailable</font></a></u></center><br>"
		if(RETURN_TO_LOBBY)
			dat += "<center><br><u><a href='?src=\ref[src];job_alternative=1'><font color=purple>Return to lobby if preference unavailable</font></a></u></center><br>"

	dat += "<center><a href='?src=\ref[src];reset_jobs=1'>\[Reset\]</a></center>"
	dat += "</tt>"

	. = dat.Join()

/datum/category_item/player_setup_item/occupation/OnTopic(href, href_list, user)
	if(href_list["reset_jobs"])
		ResetJobs()
		return TOPIC_REFRESH

	else if(href_list["job_alternative"])
		if(pref.alternate_option == GET_RANDOM_JOB || pref.alternate_option == BE_ASSISTANT)
			pref.alternate_option += 1
		else if(pref.alternate_option == RETURN_TO_LOBBY)
			pref.alternate_option = 0
		return TOPIC_REFRESH

/*
	else if(href_list["select_alt_title"])
		var/datum/job/job = locate(href_list["select_alt_title"])
		if (job)
			var/choices = list(job.title) + job.alt_titles
			var/choice = input("Choose an title for [job.title].", "Choose Title", pref.GetPlayerAltTitle(job)) as anything in choices|null
			if(choice && CanUseTopic(user))
				SetPlayerAltTitle(job, choice)
				return TOPIC_REFRESH
*/

	else if(href_list["set_job"])
		if(SetJob(user, href_list["set_job"]))
			return TOPIC_REFRESH

	else if(href_list["faction_preview"])
		show_faction_menu(user, html_decode(href_list["faction_preview"]))
		return TOPIC_NOACTION

	else if(href_list["faction_select"])
		validate_and_set_faction(html_decode(href_list["faction_select"]))
		show_faction_menu(user, html_decode(href_list["faction_select"]))
		return TOPIC_REFRESH

	return ..()

/datum/category_item/player_setup_item/occupation/proc/sanitize_faction()
	if (!SSjobs.name_factions[pref.faction])
		pref.faction = SSjobs.default_faction.name

		to_client_chat("<span class='danger'>Your faction selection has been reset to [pref.faction].</span>")
		to_client_chat("<span class='danger'>Your jobs have been reset due to this!</span>")
		ResetJobs()

/datum/category_item/player_setup_item/occupation/proc/SetPlayerAltTitle(datum/job/job, new_title)
	//TO MEME
	return

/datum/category_item/player_setup_item/occupation/proc/SetJob(mob/user, role)
	var/datum/job/job = SSjobs.GetJob(role)
	if(!job)
		return 0

	if(role == "Assistant")
		if(pref.HasJobSelected(job, JOB_PREFERENCE_LOW))
			SetJobDepartment(job, JOB_PREFERENCE_NEVER)
		else
			SetJobDepartment(job, JOB_PREFERENCE_LOW)
		return 1

	if(pref.HasJobSelected(job, JOB_PREFERENCE_HIGH))
		SetJobDepartment(job, JOB_PREFERENCE_NEVER)
	else if(pref.HasJobSelected(job, JOB_PREFERENCE_MEDIUM))
		SetJobDepartment(job, JOB_PREFERENCE_HIGH)
	else if(pref.HasJobSelected(job, JOB_PREFERENCE_LOW))
		SetJobDepartment(job, JOB_PREFERENCE_MEDIUM)
	else//job = Never
		SetJobDepartment(job, JOB_PREFERENCE_LOW)

	return 1

/datum/category_item/player_setup_item/occupation/proc/SetJobDepartment(var/datum/job/job, var/level)
	if(!job || !level)
		return 0

	if (level == JOB_PREFERENCE_NEVER)
		pref.job_preferences -= job.type
	else
		pref.job_preferences[job.type] = level

	return 1

/datum/category_item/player_setup_item/occupation/proc/ResetJobs()
	pref.job_preferences.Cut()

/datum/category_item/player_setup_item/occupation/proc/show_faction_menu(user, selected_faction)
	simple_asset_ensure_is_sent(user, /datum/asset/simple/faction_icons)

	var/list/dat = list("<center>")

	for (var/datum/faction/faction in SSjobs.factions)
		if (faction.name == selected_faction)
			dat += " [faction.name] "
		else
			dat += " <a href='?src=\ref[src];faction_preview=[html_encode(faction.name)]'>[faction.name]</a> "

	var/datum/faction/faction = SSjobs.name_factions[selected_faction]

	if (selected_faction == pref.faction)
		dat += "<br>\[Faction already selected\]"
	else if (faction.can_select(pref))
		dat += "<br>\[<a href='?src=\ref[src];faction_select=[html_encode(selected_faction)]'>Select faction</a>\]"
	else
		dat += "<br><span class='warning'>[faction.get_selection_error(pref)]</span>"

	dat += "</center><hr><center><large><u>[faction.name]</u></large>"
	dat += {"<br><img style="height:100px;" src="[faction.get_logo_name()]"></center>"}

	if (faction.is_default)
		dat += "<br><center><small>This faction is the default faction aboard this installation.</small></center>"

	dat += "<br><br>[faction.description]"

	show_browser(user, dat.Join(), "window=factionpreview")

/datum/category_item/player_setup_item/occupation/proc/validate_and_set_faction(selected_faction)
	var/datum/faction/faction = SSjobs.name_factions[selected_faction]

	if (!faction)
		to_client_chat("<span class='danger'>Invalid faction chosen. Resetting to default.</span>")
		selected_faction = SSjobs.default_faction.name

	ResetJobs() // How to be horribly lazy.

	pref.faction = selected_faction

	to_client_chat("<span class='notice'>New faction chosen. Job preferences reset.</span>")

/datum/preferences/proc/HasJobSelected(datum/job/job, level)
	if (!job || !level)
		return FALSE

	return job_preferences[job.type] == level
