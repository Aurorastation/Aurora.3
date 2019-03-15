//used for pref.alternate_option
#define GET_RANDOM_JOB 0
#define BE_ASSISTANT 1
#define RETURN_TO_LOBBY 2

/datum/category_item/player_setup_item/occupation
	name = "Occupation"
	sort_order = 1

/datum/category_item/player_setup_item/occupation/load_character(var/savefile/S)
	S["alternate_option"]	>> pref.alternate_option
	S["job_civilian_high"]	>> pref.job_civilian_high
	S["job_civilian_med"]	>> pref.job_civilian_med
	S["job_civilian_low"]	>> pref.job_civilian_low
	S["job_medsci_high"]	>> pref.job_medsci_high
	S["job_medsci_med"]		>> pref.job_medsci_med
	S["job_medsci_low"]		>> pref.job_medsci_low
	S["job_engsec_high"]	>> pref.job_engsec_high
	S["job_engsec_med"]		>> pref.job_engsec_med
	S["job_engsec_low"]		>> pref.job_engsec_low
	S["job_adhomai_high"]	>> pref.job_adhomai_high
	S["job_adhomai_med"]	>> pref.job_adhomai_med
	S["job_adhomai_low"]	>> pref.job_adhomai_low
	S["player_alt_titles"]	>> pref.player_alt_titles

/datum/category_item/player_setup_item/occupation/save_character(var/savefile/S)
	S["alternate_option"]	<< pref.alternate_option
	S["job_civilian_high"]	<< pref.job_civilian_high
	S["job_civilian_med"]	<< pref.job_civilian_med
	S["job_civilian_low"]	<< pref.job_civilian_low
	S["job_medsci_high"]	<< pref.job_medsci_high
	S["job_medsci_med"]		<< pref.job_medsci_med
	S["job_medsci_low"]		<< pref.job_medsci_low
	S["job_engsec_high"]	<< pref.job_engsec_high
	S["job_engsec_med"]		<< pref.job_engsec_med
	S["job_engsec_low"]		<< pref.job_engsec_low
	S["job_adhomai_high"]	<< pref.job_adhomai_high
	S["job_adhomai_med"]	<< pref.job_adhomai_med
	S["job_adhomai_low"]	<< pref.job_adhomai_low
	S["player_alt_titles"]	<< pref.player_alt_titles

/datum/category_item/player_setup_item/occupation/gather_load_query()
	return list(
		"ss13_characters" = list(
			"vars" = list(
				"jobs" = "unsanitized_jobs",
				"alternate_option",
				"alternate_titles" = "player_alt_titles"
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
			"id" = 1,
			"ckey" = 1
		)
	)

/datum/category_item/player_setup_item/occupation/gather_save_parameters()
	var/list/compiled_jobs = list(
		"job_civilian_high" = pref.job_civilian_high,
		"job_civilian_med" = pref.job_civilian_med,
		"job_civilian_low" = pref.job_civilian_low,
		"job_medsci_high" = pref.job_medsci_high,
		"job_medsci_med" = pref.job_medsci_med,
		"job_medsci_low" = pref.job_medsci_low,
		"job_engsec_high" = pref.job_engsec_high,
		"job_engsec_med" = pref.job_engsec_med,
		"job_engsec_low" = pref.job_engsec_low,
		"job_adhomai_high" = pref.job_adhomai_high,
		"job_adhomai_med" = pref.job_adhomai_med,
		"job_adhomai_low" = pref.job_adhomai_low
	)

	return list(
		"jobs" = list2params(compiled_jobs),
		"alternate_option" = pref.alternate_option,
		"alternate_titles" = list2params(pref.player_alt_titles),
		"id" = pref.current_character,
		"ckey" = PREF_CLIENT_CKEY
	)

/datum/category_item/player_setup_item/occupation/sanitize_character(var/sql_load = 0)
	if (sql_load)
		pref.alternate_option = text2num(pref.alternate_option)
		pref.player_alt_titles = params2list(pref.player_alt_titles)

		var/list/jobs = params2list(pref.unsanitized_jobs)

		// In case we return 0 data from the database.
		if (!jobs || !jobs.len)
			pref.alternate_option	= 0
			pref.job_civilian_high	= 0
			pref.job_civilian_med	= 0
			pref.job_civilian_low	= 0
			pref.job_medsci_high	= 0
			pref.job_medsci_med		= 0
			pref.job_medsci_low		= 0
			pref.job_engsec_high	= 0
			pref.job_engsec_med 	= 0
			pref.job_engsec_low 	= 0
			pref.job_adhomai_high	= 0
			pref.job_adhomai_med 	= 0
			pref.job_adhomai_low 	= 0
		else
			for (var/preference in jobs)
				try
					pref.vars[preference] = text2num(jobs[preference])
				catch(var/exception/e)
					log_debug("LOADING: Bad job preference key: [preference].")
					log_debug(e.desc)

	pref.alternate_option  = sanitize_integer(text2num(pref.alternate_option), 0, 2, initial(pref.alternate_option))
	pref.job_civilian_high = sanitize_integer(text2num(pref.job_civilian_high), 0, 65535, initial(pref.job_civilian_high))
	pref.job_civilian_med  = sanitize_integer(text2num(pref.job_civilian_med), 0, 65535, initial(pref.job_civilian_med))
	pref.job_civilian_low  = sanitize_integer(text2num(pref.job_civilian_low), 0, 65535, initial(pref.job_civilian_low))
	pref.job_medsci_high   = sanitize_integer(text2num(pref.job_medsci_high), 0, 65535, initial(pref.job_medsci_high))
	pref.job_medsci_med    = sanitize_integer(text2num(pref.job_medsci_med), 0, 65535, initial(pref.job_medsci_med))
	pref.job_medsci_low    = sanitize_integer(text2num(pref.job_medsci_low), 0, 65535, initial(pref.job_medsci_low))
	pref.job_engsec_high   = sanitize_integer(text2num(pref.job_engsec_high), 0, 65535, initial(pref.job_engsec_high))
	pref.job_engsec_med    = sanitize_integer(text2num(pref.job_engsec_med), 0, 65535, initial(pref.job_engsec_med))
	pref.job_engsec_low    = sanitize_integer(text2num(pref.job_engsec_low), 0, 65535, initial(pref.job_engsec_low))
	pref.job_adhomai_high   = sanitize_integer(text2num(pref.job_adhomai_high), 0, 65535, initial(pref.job_adhomai_high))
	pref.job_adhomai_med    = sanitize_integer(text2num(pref.job_adhomai_med), 0, 65535, initial(pref.job_adhomai_med))
	pref.job_adhomai_low    = sanitize_integer(text2num(pref.job_adhomai_low), 0, 65535, initial(pref.job_adhomai_low))

	if (!pref.player_alt_titles)
		pref.player_alt_titles = new()

	for(var/datum/job/job in SSjobs.occupations)
		var/alt_title = pref.player_alt_titles[job.title]
		if(alt_title && !(alt_title in job.alt_titles))
			pref.player_alt_titles -= job.title

/datum/category_item/player_setup_item/occupation/content(mob/user, limit = 16, list/splitJobs = list("Chief Engineer", "Head of Security"))
	var/list/dat = list(
		"<tt><center>",
		"<b>Choose occupation chances</b><br>Unavailable occupations are crossed out.<br>",
		"<table width='100%' cellpadding='1' cellspacing='0'><tr><td width='20%'>", // Table within a table for alignment, also allows you to easily add more colomns.
		"<table width='100%' cellpadding='1' cellspacing='0'>"
	)
	var/index = -1

	//The job before the current job. I only use this to get the previous jobs color when I'm filling in blank rows.
	var/datum/job/lastJob
	for(var/datum/job/job in SSjobs.occupations)
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
		if((pref.job_civilian_low & ASSISTANT) && (rank != current_map.assistant_job))
			dat += "<font color=orange>[rank]</font></td><td></td></tr>"
			continue
		if((rank in command_positions) || (rank == "AI"))//Bold head jobs
			dat += "<b>[rank]</b>"
		else
			dat += "[rank]"

		dat += "</td><td width='40%'>"

		dat += "<a href='?src=\ref[src];set_job=[rank]'>"

		if(rank == current_map.assistant_job)//Assistant is special
			if(pref.job_civilian_low & ASSISTANT)
				dat += " <font color=green>\[Yes]</font>"
			else
				dat += " <font color=red>\[No]</font>"
			if(job.alt_titles) //Blatantly cloned from a few lines down.
				dat += "</a></td></tr><tr bgcolor='[lastJob.selection_color]'><td width='60%' align='center'>&nbsp</td><td><a href='?src=\ref[src];select_alt_title=\ref[job]'>\[[pref.GetPlayerAltTitle(job)]\]</a></td></tr>"
			dat += "</a></td></tr>"
			continue

		if(pref.GetJobDepartment(job, 1) & job.flag)
			dat += " <font color=blue>\[High]</font>"
		else if(pref.GetJobDepartment(job, 2) & job.flag)
			dat += " <font color=green>\[Medium]</font>"
		else if(pref.GetJobDepartment(job, 3) & job.flag)
			dat += " <font color=orange>\[Low]</font>"
		else
			dat += " <font color=red>\[NEVER]</font>"
		if(job.alt_titles)
			dat += "</a></td></tr><tr bgcolor='[lastJob.selection_color]'><td width='60%' align='center'>&nbsp</td><td><a href='?src=\ref[src];select_alt_title=\ref[job]'>\[[pref.GetPlayerAltTitle(job)]\]</a></td></tr>"
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

	else if(href_list["select_alt_title"])
		var/datum/job/job = locate(href_list["select_alt_title"])
		if (job)
			var/choices = list(job.title) + job.alt_titles
			var/choice = input("Choose an title for [job.title].", "Choose Title", pref.GetPlayerAltTitle(job)) as anything in choices|null
			if(choice && CanUseTopic(user))
				SetPlayerAltTitle(job, choice)
				return TOPIC_REFRESH

	else if(href_list["set_job"])
		if(SetJob(user, href_list["set_job"])) return TOPIC_REFRESH

	return ..()

/datum/category_item/player_setup_item/occupation/proc/SetPlayerAltTitle(datum/job/job, new_title)
	// remove existing entry
	pref.player_alt_titles -= job.title
	// add one if it's not default
	if(job.title != new_title)
		pref.player_alt_titles[job.title] = new_title

/datum/category_item/player_setup_item/occupation/proc/SetJob(mob/user, role)
	var/datum/job/job = SSjobs.GetJob(role)
	if(!job)
		return 0

	if(role == current_map.assistant_job)
		if(pref.job_civilian_low & job.flag)
			pref.job_civilian_low &= ~job.flag
		else
			pref.job_civilian_low |= job.flag
		return 1

	if(pref.GetJobDepartment(job, 1) & job.flag)
		SetJobDepartment(job, 1)
	else if(pref.GetJobDepartment(job, 2) & job.flag)
		SetJobDepartment(job, 2)
	else if(pref.GetJobDepartment(job, 3) & job.flag)
		SetJobDepartment(job, 3)
	else//job = Never
		SetJobDepartment(job, 4)

	return 1

/datum/category_item/player_setup_item/occupation/proc/SetJobDepartment(var/datum/job/job, var/level)
	if(!job || !level)	return 0
	switch(level)
		if(1)//Only one of these should ever be active at once so clear them all here
			pref.job_civilian_high = 0
			pref.job_medsci_high = 0
			pref.job_engsec_high = 0
			return 1
		if(2)//Set current highs to med, then reset them
			pref.job_civilian_med |= pref.job_civilian_high
			pref.job_medsci_med |= pref.job_medsci_high
			pref.job_engsec_med |= pref.job_engsec_high
			pref.job_civilian_high = 0
			pref.job_medsci_high = 0
			pref.job_engsec_high = 0

	switch(job.department_flag)
		if(CIVILIAN)
			switch(level)
				if(2)
					pref.job_civilian_high = job.flag
					pref.job_civilian_med &= ~job.flag
				if(3)
					pref.job_civilian_med |= job.flag
					pref.job_civilian_low &= ~job.flag
				else
					pref.job_civilian_low |= job.flag
		if(MEDSCI)
			switch(level)
				if(2)
					pref.job_medsci_high = job.flag
					pref.job_medsci_med &= ~job.flag
				if(3)
					pref.job_medsci_med |= job.flag
					pref.job_medsci_low &= ~job.flag
				else
					pref.job_medsci_low |= job.flag
		if(ENGSEC)
			switch(level)
				if(2)
					pref.job_engsec_high = job.flag
					pref.job_engsec_med &= ~job.flag
				if(3)
					pref.job_engsec_med |= job.flag
					pref.job_engsec_low &= ~job.flag
				else
					pref.job_engsec_low |= job.flag
		if(ADHOMAI)
			switch(level)
				if(2)
					pref.job_adhomai_high = job.flag
					pref.job_adhomai_med &= ~job.flag
				if(3)
					pref.job_adhomai_med |= job.flag
					pref.job_adhomai_low &= ~job.flag
				else
					pref.job_adhomai_low |= job.flag
	return 1

/datum/category_item/player_setup_item/occupation/proc/ResetJobs()
	pref.job_civilian_high = 0
	pref.job_civilian_med = 0
	pref.job_civilian_low = 0

	pref.job_medsci_high = 0
	pref.job_medsci_med = 0
	pref.job_medsci_low = 0

	pref.job_engsec_high = 0
	pref.job_engsec_med = 0
	pref.job_engsec_low = 0

	pref.job_adhomai_high = 0
	pref.job_adhomai_med = 0
	pref.job_adhomai_low = 0

	pref.player_alt_titles.Cut()

/datum/preferences/proc/GetPlayerAltTitle(datum/job/job)
	return (job.title in player_alt_titles) ? player_alt_titles[job.title] : job.title

/datum/preferences/proc/GetJobDepartment(var/datum/job/job, var/level)
	if(!job || !level)	return 0
	switch(job.department_flag)
		if(CIVILIAN)
			switch(level)
				if(1)
					return job_civilian_high
				if(2)
					return job_civilian_med
				if(3)
					return job_civilian_low
		if(MEDSCI)
			switch(level)
				if(1)
					return job_medsci_high
				if(2)
					return job_medsci_med
				if(3)
					return job_medsci_low
		if(ENGSEC)
			switch(level)
				if(1)
					return job_engsec_high
				if(2)
					return job_engsec_med
				if(3)
					return job_engsec_low
		if(ADHOMAI)
			switch(level)
				if(1)
					return job_adhomai_high
				if(2)
					return job_adhomai_med
				if(3)
					return job_adhomai_low
	return 0
