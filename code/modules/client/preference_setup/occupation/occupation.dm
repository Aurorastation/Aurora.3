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
	S["player_alt_titles"]	>> pref.player_alt_titles
	S["faction"]            >> pref.faction

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
	S["player_alt_titles"]	<< pref.player_alt_titles
	S["faction"]            << pref.faction

/datum/category_item/player_setup_item/occupation/gather_load_query()
	return list(
		"ss13_characters" = list(
			"vars" = list(
				"jobs" = "unsanitized_jobs",
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
	var/list/compiled_jobs = list(
		"job_civilian_high" = pref.job_civilian_high,
		"job_civilian_med" = pref.job_civilian_med,
		"job_civilian_low" = pref.job_civilian_low,
		"job_medsci_high" = pref.job_medsci_high,
		"job_medsci_med" = pref.job_medsci_med,
		"job_medsci_low" = pref.job_medsci_low,
		"job_engsec_high" = pref.job_engsec_high,
		"job_engsec_med" = pref.job_engsec_med,
		"job_engsec_low" = pref.job_engsec_low
	)

	return list(
		"jobs" = list2params(compiled_jobs),
		"alternate_option" = pref.alternate_option,
		"alternate_titles" = list2params(pref.player_alt_titles),
		"id" = pref.current_character,
		"faction" = pref.faction,
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
		else
			for (var/preference in jobs)
				try
					pref.vars[preference] = text2num(jobs[preference])
				catch(var/exception/e)
					LOG_DEBUG("LOADING: Bad job preference key: [preference].")
					log_debug(e.desc)

	pref.alternate_option  = sanitize_integer(text2num(pref.alternate_option), 0, 1, initial(pref.alternate_option))
	pref.job_civilian_high = sanitize_integer(text2num(pref.job_civilian_high), 0, 65535, initial(pref.job_civilian_high))
	pref.job_civilian_med  = sanitize_integer(text2num(pref.job_civilian_med), 0, 65535, initial(pref.job_civilian_med))
	pref.job_civilian_low  = sanitize_integer(text2num(pref.job_civilian_low), 0, 65535, initial(pref.job_civilian_low))
	pref.job_medsci_high   = sanitize_integer(text2num(pref.job_medsci_high), 0, 65535, initial(pref.job_medsci_high))
	pref.job_medsci_med    = sanitize_integer(text2num(pref.job_medsci_med), 0, 65535, initial(pref.job_medsci_med))
	pref.job_medsci_low    = sanitize_integer(text2num(pref.job_medsci_low), 0, 65535, initial(pref.job_medsci_low))
	pref.job_engsec_high   = sanitize_integer(text2num(pref.job_engsec_high), 0, 65535, initial(pref.job_engsec_high))
	pref.job_engsec_med    = sanitize_integer(text2num(pref.job_engsec_med), 0, 65535, initial(pref.job_engsec_med))
	pref.job_engsec_low    = sanitize_integer(text2num(pref.job_engsec_low), 0, 65535, initial(pref.job_engsec_low))

	if (!pref.player_alt_titles)
		pref.player_alt_titles = new()

	if (!SSjobs.safe_to_sanitize)
		if (!SSjobs.deferred_preference_sanitizations[src])
			SSjobs.deferred_preference_sanitizations[src] = CALLBACK(src, PROC_REF(late_sanitize), sql_load)
	else
		late_sanitize(sql_load)

/datum/category_item/player_setup_item/occupation/proc/late_sanitize(sql_load)
	for (var/datum/job/job in SSjobs.occupations)
		var/alt_title = pref.player_alt_titles[job.title]
		if(alt_title && !(alt_title in job.alt_titles))
			pref.player_alt_titles -= job.title
		var/list/available = pref.GetValidTitles(job)
		if(LAZYLEN(available) == 1)
			SetPlayerAltTitle(job, LAZYACCESS(available, 1))

	sanitize_faction()

/datum/category_item/player_setup_item/occupation/content(mob/user, limit = 16, list/splitJobs = list("Chief Engineer", "Head of Security"))
	if (!SSjobs.initialized || !SSrecords.initialized)
		return "<center><large>Jobs controller not initialized yet. Please wait a bit and reload this section.</large></center>"

	var/list/dat = list(
		"<style>span.none{color: black} span.low{color: #DDD} span.med{color: yellow} span.high{color: lime} a:hover span{color: #40628a !important}</style>",
		"<center><b>Character Faction</b><br>",
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

	var/datum/faction/faction = SSjobs.name_factions[pref.faction] || SSjobs.default_faction
	for(var/datum/job/job in SSjobs.occupations)
		index += 1
		if((index >= limit) || (job.title in splitJobs))
			dat += "</table></td><td width='20%'><table width='100%' cellpadding='1' cellspacing='0'>"
			index = 0

		var/rank = job.title
		var/head = (rank in command_positions) || (rank == "AI")
		dat += "<tr style='background-color: [hex2cssrgba(job.selection_color, head ? 1 : 0.5)];'><td width='60%' align='right'>"

		var/list/available = pref.GetValidTitles(job)
		var/dispRank = LAZYLEN(available) ? LAZYACCESS(available, 1) : rank
		var/ban_reason = jobban_isbanned(user, rank)
		if(ban_reason == "WHITELISTED")
			dat += "<del>[dispRank]</del></td><td><b> \[WHITELISTED]</b></td></tr>"
			continue
		else if (ban_reason == "AGE WHITELISTED")
			var/available_in_days = player_old_enough_for_role(user.client, rank)
			dat += "<del>[dispRank]</del></td><td> \[IN [(available_in_days)] DAYS]</td></tr>"
			continue
		else if(!LAZYLEN(pref.GetValidTitles(job))) // we have no available jobs the character is old enough for
			dat += "<del>[dispRank]</del></td><td> \[MINIMUM AGE: [LAZYLEN(job.alt_ages) ? min(job.get_alt_character_age(), job.get_minimum_character_age(user.get_species())) : job.get_minimum_character_age(user.get_species())]]</td></tr>"
			continue
		if(!(job in faction.get_occupations()))
			dat += "<del>[dispRank]</del></td><td><b> \[FACTION RESTRICTED]</b></td></tr>"
			continue
		else if (ban_reason)
			dat += "<del>[dispRank]</del></td><td><b> \[<a href='?src=\ref[user.client];view_jobban=[rank];'>BANNED</a>]</b></td></tr>"
			continue
		if(job.blacklisted_species) // check for restricted species
			var/datum/species/S = GLOB.all_species[pref.species]
			if(S.name in job.blacklisted_species)
				dat += "<del>[dispRank]</del></td><td><b> \[SPECIES RESTRICTED]</b></td></tr>"
				continue
		var/datum/citizenship/C = SSrecords.citizenships[pref.citizenship]
		if(C.job_species_blacklist[job.title] && (pref.species in C.job_species_blacklist[job.title]))
			dat += "<del>[dispRank]</del></td><td><b> \[SPECIES RESTRICTED]</b></td></tr>"
			continue
		if(job.blacklisted_citizenship)
			if(C.name in job.blacklisted_citizenship)
				dat += "<del>[dispRank]</del></td><td><b> \[BACKGROUND RESTRICTED]</b></td></tr>"
				continue
		if(job.alt_titles && (LAZYLEN(pref.GetValidTitles(job)) > 1))
			dispRank = "<span width='60%' align='center'>&nbsp<a href='?src=\ref[src];select_alt_title=\ref[job]'>\[[pref.GetPlayerAltTitle(job)]\]</a></span>"
		if((pref.job_civilian_low & ASSISTANT) && (rank != "Assistant"))
			dat += "<span class='none'>[dispRank]</span></td><td></td></tr>"
			continue
		if(head)//Bold head jobs
			dat += "<b>[dispRank]</b>"
		else
			dat += "[dispRank]"

		dat += "</td><td width='40%'>"

		dat += "<a href='?src=\ref[src];set_job=[rank]'>"

		if(rank == "Assistant")//Assistant is special
			if(pref.job_civilian_low & ASSISTANT)
				dat += " <span class='high'>\[Yes]</span>"
			else
				dat += " <span class='none'>\[No]</span>"
			dat += "</a></td></tr>"
			continue

		if(pref.GetJobDepartment(job, 1) & job.flag)
			dat += " <span class='high'>\[High]</span>"
		else if(pref.GetJobDepartment(job, 2) & job.flag)
			dat += " <span class='med'>\[Medium]</span>"
		else if(pref.GetJobDepartment(job, 3) & job.flag)
			dat += " <span class='low'>\[Low]</span>"
		else
			dat += " <span class='none'>\[NEVER]</span>"
		dat += "</a></td></tr>"

	dat += "</td'></tr></table>"

	dat += "</center></table>"

	switch(pref.alternate_option)
		if(BE_ASSISTANT)
			dat += "<center><br><u><a href='?src=\ref[src];job_alternative=1'>Be assistant if preference unavailable</a></u></center><br>"
		if(RETURN_TO_LOBBY)
			dat += "<center><br><u><a href='?src=\ref[src];job_alternative=1'><span class='high'>Return to lobby if preference unavailable</span></a></u></center><br>"

	dat += "<center><a href='?src=\ref[src];reset_jobs=1'>\[Reset\]</a></center>"
	dat += "</tt>"

	. = dat.Join()

/datum/category_item/player_setup_item/occupation/OnTopic(href, href_list, mob/user)
	if(href_list["reset_jobs"])
		ResetJobs()
		return TOPIC_REFRESH

	else if(href_list["job_alternative"])
		if(pref.alternate_option == BE_ASSISTANT)
			pref.alternate_option = RETURN_TO_LOBBY
		else if(pref.alternate_option == RETURN_TO_LOBBY)
			pref.alternate_option = BE_ASSISTANT
		return TOPIC_REFRESH

	else if(href_list["select_alt_title"])
		var/datum/job/job = locate(href_list["select_alt_title"])
		if (!job)
			return ..()
		var/list/choices = pref.GetValidTitles(job)
		if(!LAZYLEN(choices))
			return ..()// should never happen
		var/choice = input("Choose a title for [job.title].", "Choose Title", pref.GetPlayerAltTitle(job)) as anything in choices|null
		if(choice && CanUseTopic(user))
			SetPlayerAltTitle(job, choice)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["set_job"])
		if(SetJob(user, href_list["set_job"]))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["faction_preview"])
		show_faction_menu(user, html_decode(href_list["faction_preview"]))
		return TOPIC_NOACTION

	else if(href_list["faction_select"])
		validate_and_set_faction(html_decode(href_list["faction_select"]))
		show_faction_menu(user, html_decode(href_list["faction_select"]))
		return TOPIC_REFRESH_UPDATE_PREVIEW

	return ..()

/datum/category_item/player_setup_item/occupation/proc/sanitize_faction()
	if (!SSjobs.name_factions[pref.faction])
		pref.faction = SSjobs.default_faction.name
		to_client_chat(SPAN_DANGER("Your faction selection has been reset to [pref.faction]."))
		to_client_chat(SPAN_DANGER("Your jobs have been reset due to this!"))
		ResetJobs()
		return TOPIC_REFRESH_UPDATE_PREVIEW

	var/datum/species/S = pref.get_species_datum()
	var/datum/faction/faction = SSjobs.name_factions[pref.faction]
	for(var/datum/job/job in SSjobs.occupations)
		for(var/department = 1 to NUM_JOB_DEPTS)
			if(pref.GetJobDepartment(job, department) & job.flag)
				if(!(job in faction.get_occupations()))
					to_client_chat(SPAN_DANGER("Your faction selection does not permit this job, [job.title] as [pref.faction]."))
					to_client_chat(SPAN_DANGER("Your jobs have been reset due to this!"))
					ResetJobs()
					return TOPIC_REFRESH_UPDATE_PREVIEW
				if(pref.species in job.blacklisted_species)
					to_client_chat(SPAN_DANGER("Your faction selection does not permit this species-occupation combination, [pref.species] as [job.title]."))
					to_client_chat(SPAN_DANGER("Your jobs have been reset due to this!"))
					ResetJobs()
					return TOPIC_REFRESH_UPDATE_PREVIEW
				if(!is_type_in_typecache(S, faction.allowed_species_types) && length(faction.allowed_species_types))
					to_client_chat(SPAN_DANGER("Your faction selection does not permit this species, [pref.species] as [pref.faction]."))
					to_client_chat(SPAN_DANGER("Your jobs have been reset due to this!"))
					ResetJobs()
					return TOPIC_REFRESH_UPDATE_PREVIEW

/datum/category_item/player_setup_item/occupation/proc/SetPlayerAltTitle(datum/job/job, new_title)
	// remove existing entry
	pref.player_alt_titles -= job.title
	// add one if it's not default
	if(job.title != new_title)
		pref.player_alt_titles[job.title] = new_title

/datum/category_item/player_setup_item/occupation/proc/SetJob(mob/user, role)
	var/datum/job/job = SSjobs.GetJob(role)
	if(!job)
		return FALSE

	if(role == "Assistant")
		if(pref.job_civilian_low & job.flag)
			pref.job_civilian_low &= ~job.flag
		else
			pref.job_civilian_low |= job.flag

		SSticker.cycle_player(user, job)
		return TRUE

	if(pref.GetJobDepartment(job, 1) & job.flag) // HIGH -> NONE
		SetJobDepartment(job, 1)
		SSticker.cycle_player(user, job)
	else if(pref.GetJobDepartment(job, 2) & job.flag) // MED -> HIGH
		SetJobDepartment(job, 2)
		SSticker.cycle_player(user, job)
	else if(pref.GetJobDepartment(job, 3) & job.flag) // LOW -> MED
		SetJobDepartment(job, 3)
	else // NONE -> LOW
		SetJobDepartment(job, 4)

	return 1

/datum/category_item/player_setup_item/occupation/proc/SetJobDepartment(var/datum/job/job, var/level)
	if(!job || !level)
		return FALSE
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
		if(SERVICE)
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

	pref.player_alt_titles.Cut()

/datum/category_item/player_setup_item/occupation/proc/show_faction_menu(mob/user, selected_faction) //note : selected faction is what you choose to see, pref.faction is the actual chosen faction
	simple_asset_ensure_is_sent(user, /datum/asset/simple/faction_icons)

	var/list/dat = list("<center><h2>")

	var/list/factions = list()
	for (var/datum/faction/faction in SSjobs.factions)
		if(!faction.is_visible(user))
			continue

		if (faction.name == selected_faction)
			factions += "[faction.name]"
		else
			factions += "<a href='?src=\ref[src];faction_preview=[html_encode(faction.name)]'>[faction.name]</a>"

	dat += factions.Join(" ")

	var/datum/faction/faction = SSjobs.name_factions[selected_faction]
	if(!istype(faction))
		to_client_chat(SPAN_DANGER("Invalid faction chosen. Resetting to [SSjobs.default_faction.name]."))
		selected_faction = SSjobs.default_faction.name
		faction = SSjobs.name_factions[selected_faction]
		return

	dat += "</h2></center><hr/>"
	dat += "<table padding='8px'>"
	dat += "<tr>"
	dat += "<td width = 500>[faction.description]</td>"
	dat += "<td width = 200 align='center'>"
	dat += {"<img style="height:132px;" src="[faction.get_logo_name()]">"}

	dat += "<br/><b>Departments:</br></b>"
	dat += "<small><b>[faction.departments]</b></small>"
	dat += "</td>"
	dat += "</tr>"
	dat += "</table><center><hr/>"

	dat += "You can learn more about this faction on <a href='?src=\ref[user.client];JSlink=wiki;wiki_page=[replacetext(faction.name, " ", "_")]'>the wiki</a>."

	if (selected_faction == pref.faction)
		dat += "<br>\[Faction selected\]"
	else if (faction.can_select(pref,user))
		dat += "<br>\[<a href='?src=\ref[src];faction_select=[html_encode(selected_faction)]'>Select faction</a>\]"
	else
		dat += "<br><span class='warning'>[faction.get_selection_error(pref, user)]</span>"
	dat += "</center>"

	user << browse(dat.Join(), "window=factionpreview;size=750x450")

/datum/category_item/player_setup_item/occupation/proc/validate_and_set_faction(selected_faction)
	var/datum/faction/faction = SSjobs.name_factions[selected_faction]

	if (!faction)
		to_client_chat("<span class='danger'>Invalid faction chosen. Resetting to default.</span>")
		selected_faction = SSjobs.default_faction.name

	ResetJobs() // How to be horribly lazy.

	pref.faction = selected_faction

	to_client_chat("<span class='notice'>New faction chosen. Job preferences reset.</span>")

/datum/preferences/proc/GetPlayerAltTitle(datum/job/job)
	return player_alt_titles[job.title] || job.title

/datum/preferences/proc/GetValidTitles(datum/job/job)
	if (!job)
		return
	var/choices = list(job.title) + job.alt_titles
	if((GLOB.all_species[src.species].spawn_flags & NO_AGE_MINIMUM))
		return choices
	for(var/t in choices)
		if (src.age >= (job.get_alt_character_age(species, t) || job.get_minimum_character_age(species)))
			continue
		choices -= t
	return choices

/datum/preferences/proc/GetJobDepartment(var/datum/job/job, var/level)
	if(!job || !level)
		return FALSE
	switch(job.department_flag)
		if(SERVICE)
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
	return 0
