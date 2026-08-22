/datum/category_item/player_setup_item/occupation
	name = "Occupation"
	sort_order = 1
	/// The module datum for the faction select interface, if it's currently open.
	var/datum/tgui_module/faction_select/faction_ui

/datum/category_item/player_setup_item/occupation/load_character(var/savefile/S)
	S["alternate_option"]	>> pref.alternate_option
	S["selected_job"]		>> pref.selected_job
	S["job_civilian_high"]	>> pref.job_civilian_high
	S["job_civilian_med"]	>> pref.job_civilian_med
	S["job_civilian_low"]	>> pref.job_civilian_low
	S["job_medsci_high"]	>> pref.job_medsci_high
	S["job_medsci_med"]		>> pref.job_medsci_med
	S["job_medsci_low"]		>> pref.job_medsci_low
	S["job_engsec_high"]	>> pref.job_engsec_high
	S["job_engsec_med"]		>> pref.job_engsec_med
	S["job_engsec_low"]		>> pref.job_engsec_low
	S["job_event_high"]	>> pref.job_event_high
	S["job_event_med"]		>> pref.job_event_med
	S["job_event_low"]		>> pref.job_event_low
	S["player_alt_titles"]	>> pref.player_alt_titles
	S["faction"]            >> pref.faction

/datum/category_item/player_setup_item/occupation/save_character(var/savefile/S)
	S["alternate_option"]	<< pref.alternate_option
	S["selected_job"]		<< pref.selected_job
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
		"selected_job" = pref.selected_job
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
		pref.selected_job = null
		pref.clear_job_priorities()

		var/list/jobs = params2list(pref.unsanitized_jobs)

		// In case we return 0 data from the database.
		if (!jobs || !jobs.len)
			pref.alternate_option	= 0
			pref.selected_job = null
		else
			for (var/preference in jobs)
				try
					if(preference == "selected_job")
						pref.selected_job = jobs[preference]
					else
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
	pref.job_event_high   = sanitize_integer(text2num(pref.job_event_high), 0, 65535, initial(pref.job_event_high))
	pref.job_event_med    = sanitize_integer(text2num(pref.job_event_med), 0, 65535, initial(pref.job_event_med))
	pref.job_event_low    = sanitize_integer(text2num(pref.job_event_low), 0, 65535, initial(pref.job_event_low))
	pref.selected_job = sanitize_text(pref.selected_job)


	if (!pref.player_alt_titles)
		pref.player_alt_titles = new()

	if (!SSjobs.safe_to_sanitize)
		if (!SSjobs.deferred_preference_sanitizations[src])
			SSjobs.deferred_preference_sanitizations[src] = CALLBACK(src, PROC_REF(late_sanitize), sql_load)
	else
		late_sanitize(sql_load)

/datum/category_item/player_setup_item/occupation/proc/late_sanitize(sql_load)
	// Migrate the former priority system: retain its single High job as Selected
	// and discard all Medium/Low fallback choices.
	var/datum/job/legacy_selected_job = pref.return_legacy_high_job()
	if(legacy_selected_job && !pref.selected_job)
		pref.selected_job = legacy_selected_job.title
	pref.clear_job_priorities()

	for (var/datum/job/job in SSjobs.occupations)
		var/alt_title = pref.player_alt_titles[job.title]
		if(alt_title && !(alt_title in job.alt_titles))
			pref.player_alt_titles -= job.title
		var/list/available = pref.GetValidTitles(job)
		if(LAZYLEN(available) == 1)
			SetPlayerAltTitle(job, LAZYACCESS(available, 1))

	sanitize_faction()

/datum/category_item/player_setup_item/occupation/proc/get_display_department(datum/job/job)
	if(istype(job, /datum/job/captain) || istype(job, /datum/job/xo))
		return DEPARTMENT_COMMAND

	for(var/department in job.departments)
		if(department != DEPARTMENT_COMMAND)
			return department

	if(DEPARTMENT_COMMAND in job.departments)
		return DEPARTMENT_COMMAND

	return DEPARTMENT_MISCELLANEOUS

/datum/category_item/player_setup_item/occupation/proc/get_department_order()
	return list(
		DEPARTMENT_COMMAND,
		DEPARTMENT_ENGINEERING,
		DEPARTMENT_MEDICAL,
		DEPARTMENT_SCIENCE,
		DEPARTMENT_SECURITY,
		DEPARTMENT_CARGO,
		DEPARTMENT_SERVICE,
		DEPARTMENT_CIVILIAN,
		DEPARTMENT_EQUIPMENT,
		DEPARTMENT_COMMAND_SUPPORT,
		DEPARTMENT_MISCELLANEOUS,
		DEPARTMENT_OFFSHIP
	)

/datum/category_item/player_setup_item/occupation/proc/get_job_ui_data(datum/job/job, mob/user, datum/faction/faction)
	var/rank = job.title
	var/head = (rank in command_positions) || (rank == "AI")
	var/list/available = pref.GetValidTitles(job)
	var/display_title = LAZYLEN(available) ? LAZYACCESS(available, 1) : rank
	var/status
	var/status_tone = "unavailable"
	var/unavailable = TRUE
	var/selectable = FALSE
	var/alt_title_ref
	var/status_href
	var/button_label
	var/ban_reason = jobban_isbanned(user, rank)

	if(ban_reason == "WHITELISTED")
		status = "Whitelist required"
		button_label = "Whitelist Required"
	else if(ban_reason == "AGE WHITELISTED")
		status = "Available in [player_old_enough_for_role(user.client, rank)] days"
		button_label = "Age Restricted"
	else if(!LAZYLEN(available))
		var/minimum_age = job.get_minimum_character_age(pref.species)
		for(var/alt_title in job.alt_ages)
			var/alt_age = job.get_alt_character_age(pref.species, alt_title)
			if(isnum(alt_age) && (!isnum(minimum_age) || alt_age < minimum_age))
				minimum_age = alt_age
		status = "Minimum age: [minimum_age]"
		button_label = "Age Restricted"
	else if(!(job in faction.get_occupations()))
		var/list/allowed_factions = list()
		for(var/faction_name in SSjobs.name_factions)
			var/datum/faction/allowed_faction = SSjobs.name_factions[faction_name]
			if(job in allowed_faction.get_occupations())
				allowed_factions += allowed_faction.name
		status = length(allowed_factions) ? "Requires one of:\n[bulleted_list(allowed_factions)]" : "Faction restricted"
		button_label = "Faction Restricted"
	else if(ban_reason)
		status = "You are banned from this role"
		button_label = "Banned"
		status_href = "byond://?src=[REF(user.client)];view_jobban=[rank]"
	else
		var/species_restricted = FALSE
		if(job.blacklisted_species)
			var/datum/species/S = GLOB.all_species[pref.species]
			species_restricted = (S.name in job.blacklisted_species)

		var/datum/citizenship/C = SSrecords.citizenships[pref.citizenship]
		if(!species_restricted && C.job_species_blacklist[job.title] && (pref.species in C.job_species_blacklist[job.title]))
			species_restricted = TRUE

		if(species_restricted)
			status = "Species restricted"
			button_label = "Species Restricted"
		else if(job.blacklisted_citizenship && (C.name in job.blacklisted_citizenship))
			status = "Background restricted"
			button_label = "Background Restricted"
		else
			var/list/missing_skills = list()
			for(var/key, value in job.skill_requirements)
				if(!key || pref.skills[key] >= value)
					continue
				var/singleton/skill/skill = GET_SINGLETON(key)
				missing_skills += "[skill.name] [value]"

			if(length(missing_skills))
				status = "Missing skills:\n[jointext(missing_skills, "\n")]"
				button_label = "Missing Skills"
			else
				unavailable = FALSE
				if(job.alt_titles && (LAZYLEN(available) > 1))
					display_title = "\[[pref.GetPlayerAltTitle(job)]\]"
					alt_title_ref = REF(job)

				selectable = TRUE
				if(pref.GetJobDepartment(job, 1) & job.flag)
					status = "Selected"
					status_tone = "high"
				else
					status = "NEVER"
					status_tone = "never"

	return list(
		"title" = display_title,
		"rank" = rank,
		"color" = hex2cssrgba(job.selection_color, head ? 1 : 0.5),
		"bold" = head,
		"unavailable" = unavailable,
		"selectable" = selectable,
		"selected" = (pref.GetJobDepartment(job, 1) & job.flag) != 0,
		"button_label" = button_label,
		"status" = status,
		"status_tone" = status_tone,
		"status_href" = status_href,
		"alt_title_ref" = alt_title_ref
	)

/datum/category_item/player_setup_item/occupation/ui_data(mob/user)
	if(!SSjobs.initialized || !SSrecords.initialized || !SSghostroles.initialized)
		return list(
			"kind" = "notice",
			"name" = name,
			"ref" = REF(src),
			"message" = "Jobs and offship roles are still initializing. Please wait a bit and reload this section."
		)

	var/list/departments = list()
	var/list/offship_ships = list()
	var/list/department_order = get_department_order()
	var/datum/faction/faction = SSjobs.name_factions[pref.faction] || SSjobs.default_faction
	for(var/department in department_order)
		var/list/jobs = list()
		for(var/datum/job/job in SSjobs.occupations)
			if(get_display_department(job) == department)
				jobs += list(get_job_ui_data(job, user, faction))
		if(length(jobs))
			departments += list(list(
				"name" = department,
				"jobs" = jobs
			))

	for(var/role_id in SSghostroles.roundstart_offship_catalog)
		var/datum/ghostspawner/human/spawner = SSghostroles.roundstart_offship_catalog[role_id]
		if(!istype(spawner))
			continue

		var/ship_name = spawner.roundstart_ship_name
		if(!offship_ships[ship_name])
			offship_ships[ship_name] = list()

		var/selection_error = spawner.get_roundstart_selection_error(user, pref)
		var/restriction_label
		if(selection_error)
			if(!(pref.faction in spawner.roundstart_factions))
				restriction_label = "Faction Restricted"
			else if(!(pref.species in spawner.possible_species))
				restriction_label = "Species Restricted"
			else if(spawner.uses_species_whitelist && !is_alien_whitelisted(user, pref.species))
				restriction_label = "Whitelist Required"
			else
				restriction_label = "Unavailable"
		var/datum/ghostspawner/human/active_spawner = SSghostroles.spawners[role_id]
		var/availability = "Not available this round"
		var/currently_available = FALSE
		if(istype(active_spawner))
			if(!active_spawner.enabled)
				availability = "Disabled this round"
			else if(active_spawner.max_count && active_spawner.count >= active_spawner.max_count)
				availability = "Full this round"
			else
				currently_available = TRUE
				availability = "Available ([active_spawner.max_count ? max(active_spawner.max_count - active_spawner.count, 0) : "Unlimited"] slot[active_spawner.max_count == 1 ? "" : "s"] remaining)"
		offship_ships[ship_name] += list(list(
			"id" = spawner.short_name,
			"name" = spawner.name,
			"description" = spawner.desc,
			"selected" = pref.selected_job == spawner.short_name,
			"selectable" = !selection_error,
			"button_label" = restriction_label,
			"status" = selection_error || availability,
			"status_tone" = selection_error ? "bad" : (currently_available ? "good" : "label")
		))

	var/list/offships = list()
	for(var/ship_name in offship_ships)
		offships += list(list(
			"name" = ship_name,
			"roles" = offship_ships[ship_name]
		))

	var/alternative = pref.alternate_option == BE_ASSISTANT ? "Be assistant if preference unavailable" : "Return to lobby if preference unavailable"
	return list(
		"kind" = "occupation",
		"name" = name,
		"ref" = REF(src),
		"faction" = pref.faction,
		"departments" = departments,
		"offships" = offships,
		"alternative" = alternative
	)

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
		var/choice = input("Choose a title for [job.title]. Be aware that choosing an alternative title does not absolve you from the job's regular duties!", "Choose Title", pref.GetPlayerAltTitle(job)) as anything in choices|null
		if(choice && CanUseTopic(user))
			SetPlayerAltTitle(job, choice)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["set_job"])
		if(SetJob(user, href_list["set_job"]))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["faction_select"])
		if(!faction_ui)
			faction_ui = new(src)
		faction_ui.ui_interact(user)
		return TOPIC_NOACTION

	return ..()

/datum/category_item/player_setup_item/occupation/proc/on_ui_close()
	faction_ui = null

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
		return SetOffshipRole(user, role)
	var/already_selected = pref.selected_job == job.title
	pref.clear_job_priorities()
	if(!already_selected)
		pref.set_selected_job(job)
	else
		pref.selected_job = null
	SSticker.cycle_player(user, job)
	return TRUE

/datum/category_item/player_setup_item/occupation/proc/SetOffshipRole(mob/abstract/new_player/user, role_id)
	var/datum/ghostspawner/human/spawner = SSghostroles.roundstart_offship_catalog[role_id]
	if(!istype(spawner))
		return FALSE

	if(pref.selected_job == spawner.short_name)
		pref.selected_job = null
		SSticker.cycle_player(user)
		return TRUE

	var/selection_error = spawner.get_roundstart_selection_error(user, pref)
	if(selection_error)
		to_chat(user, SPAN_WARNING("You cannot select [spawner.name]: [selection_error]"))
		return FALSE

	ResetJobs()
	pref.selected_job = spawner.short_name
	SSticker.cycle_player(user)
	return TRUE

/datum/category_item/player_setup_item/occupation/proc/ResetJobs()
	pref.clear_job_priorities()
	pref.selected_job = null

	pref.player_alt_titles.Cut()

/datum/category_item/player_setup_item/occupation/proc/validate_and_set_faction(datum/faction/faction)
	ResetJobs() // How to be horribly lazy.
	pref.faction = faction.name
	to_client_chat(SPAN_NOTICE("New faction chosen! Job preferences reset."))

/datum/preferences/proc/GetPlayerAltTitle(datum/job/job)
	return player_alt_titles[job.title] || job.title

/datum/preferences/proc/GetValidTitles(datum/job/job)
	if (!job)
		return
	var/choices = list(job.title) + job.alt_titles
	if(!isnull(job.alt_factions))
		for(var/t in choices)
			if (src.faction in job.alt_factions[t])
				continue
			choices -= t
	if(!isnull(job.alt_citizenships))
		for(var/t in choices)
			if (src.citizenship in job.alt_citizenships[t])
				continue
			choices -= t
	if((GLOB.all_species[src.species].spawn_flags & NO_AGE_MINIMUM))
		return choices
	for(var/t in choices)
		if (src.age >= (job.get_alt_character_age(species, t) || job.get_minimum_character_age(species)))
			continue
		choices -= t
	return choices

/// Clears obsolete priority data after it has been migrated.
/datum/preferences/proc/clear_job_priorities()
	job_civilian_high = 0
	job_civilian_med = 0
	job_civilian_low = 0
	job_medsci_high = 0
	job_medsci_med = 0
	job_medsci_low = 0
	job_engsec_high = 0
	job_engsec_med = 0
	job_engsec_low = 0
	job_event_high = 0
	job_event_med = 0
	job_event_low = 0

/// Stores one station job in the shared selection field.
/datum/preferences/proc/set_selected_job(datum/job/job)
	if(!job)
		return FALSE
	clear_job_priorities()
	selected_job = job.title
	return TRUE

/datum/preferences/proc/GetJobDepartment(var/datum/job/job, var/level)
	if(!job || !level)
		return FALSE
	return level == 1 && selected_job == job.title ? job.flag : 0
