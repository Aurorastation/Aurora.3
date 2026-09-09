/**
 * Intruder Job Selection Teleporter
 * Placed in the intruder prep area, allows intruders to select their crew job, company affiliation, and arrival method.
 */

/obj/structure/machinery/intruder_teleporter
	name = "infiltration deployment terminal"
	desc = "An advanced terminal that allows operatives to select their deployment profile and insertion method. \
			A label on the back states the dangers of bluespace technology... How reassuring."
	icon = 'icons/obj/computer.dmi'
	icon_state = "medlaptopb"
	anchored = TRUE
	density = TRUE
	use_power = POWER_USE_OFF

/obj/structure/machinery/intruder_teleporter/attack_hand(var/mob/user)
	if(!istype(user, /mob/living/carbon/human))
		return

	var/datum/mind/player_mind = user.mind
	if(!player_mind)
		return

	// Check if this player is an intruder
	if(!(player_mind in get_antags(MODE_INTRUDER)))
		to_chat(user, SPAN_WARNING("Access denied. This terminal is for authorized personnel only."))
		return

	if(!user.client)
		return

	var/datum/tgui_module/intruder_deployment/form = new(user, src)
	form.ui_interact(user)

/datum/tgui_module/intruder_deployment
	var/mob/intruder
	var/selected_job
	var/selected_alt_title
	var/selected_faction
	var/selected_insertion
	var/selected_announce = TRUE

/datum/tgui_module/intruder_deployment/New(mob/user)
	intruder = user

/datum/tgui_module/intruder_deployment/ui_interact(mob/living/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new /datum/tgui(user, src, "IntruderTeleporter")
		ui.open()

/datum/tgui_module/intruder_deployment/ui_data(mob/user)
	var/list/data = list(
		"selected_job" = selected_job,
		"selected_alt_title" = selected_alt_title,
		"selected_faction" = selected_faction,
		"selected_insertion" = selected_insertion,
		"selected_announce" = selected_announce
	)
	return data

/datum/tgui_module/intruder_deployment/proc/is_job_available(datum/job/job)
	if(!job)
		return FALSE

	// Exclude certain jobs from being selectable by intruders
	if(istype(job, /datum/job/captain) \
		|| istype(job, /datum/job/xo) \
		|| istype(job, /datum/job/hos) \
		|| istype(job, /datum/job/chief_engineer) \
		|| istype(job, /datum/job/cmo) \
		|| istype(job, /datum/job/rd) \
		|| istype(job, /datum/job/operations_manager) \
		|| istype(job, /datum/job/hra) \
		|| istype(job, /datum/job/ai) \
		|| istype(job, /datum/job/cyborg))
		return FALSE

	// Check slot capacity
	if(!job.is_position_available())
		return FALSE

	// Security-specific restrictions
	if(job.title == "Security Officer")
		return is_security_slot_available()

	return TRUE

/datum/tgui_module/intruder_deployment/proc/is_security_slot_available()
	var/datum/antagonist/intruder_antag = get_antag_data(MODE_INTRUDER)
	if(!intruder_antag)
		return FALSE

	var/total_security = 0
	var/intruder_security = 0

	for(var/datum/mind/mind in SSticker.minds)
		var/datum/job/job = SSjobs.GetJob(mind.assigned_role)
		if(!istype(job, /datum/job/officer) \
			&& !istype(job, /datum/job/hos) \
			&& !istype(job, /datum/job/warden) \
			&& !istype(job, /datum/job/investigator) \
			&& !istype(job, /datum/job/intern_sec))
			continue

		if(mind in intruder_antag.current_antagonists)
			intruder_security++
		else
			total_security++

	// Require 2+ non-intruder security for 1st intruder, 4+ for 2nd
	if(total_security < 2)
		return FALSE
	if(intruder_security >= 1 && total_security < 4)
		return FALSE
	if(intruder_security >= 2)
		return FALSE

	return TRUE

/datum/tgui_module/intruder_deployment/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("select_job")
			var/list/available_jobs = list()
			for(var/datum/job/job in SSjobs.occupations)
				if(!is_job_available(job))
					continue
				available_jobs += list(job.title)
			if(!available_jobs.len)
				return FALSE
			selected_job = tgui_input_list(intruder, "Select a crew position.", "Crew Position Selection", available_jobs)
			selected_alt_title = null
			selected_faction = null
			selected_insertion = null
			selected_announce = TRUE

		if("select_alt_title")
			if(!selected_job)
				return FALSE
			var/datum/job/job = SSjobs.GetJob(selected_job)
			if(!job)
				return FALSE
			selected_alt_title = tgui_input_list(intruder, "Select a title.", "Title Selection", intruder.client.prefs.GetValidTitles(job))
			selected_faction = null
			selected_insertion = null
			selected_announce = TRUE

		if("select_faction")
			if(!selected_job || !selected_alt_title)
				return FALSE
			var/datum/job/job = SSjobs.GetJob(selected_job)
			if(!job)
				return FALSE
			var/list/factions = list()
			for(var/datum/faction/faction as anything in SSjobs.factions)
				if(job.type in unpacklist(faction.allowed_role_types))
					factions += faction.name
			if(job.alt_factions)
				factions |= job.alt_factions[selected_alt_title]
			if(!factions.len)
				return FALSE
			selected_faction = tgui_input_list(intruder, "Select a company affiliation.", "Company Affiliation Selection", factions)
			selected_insertion = null
			selected_announce = TRUE

		if("select_insertion")
			selected_insertion = tgui_input_list(intruder, "Select an insertion method.", "Insertion Method Selection", list("Residential Lift", "Stealth"))
			if(selected_insertion == "Stealth")
				selected_announce = FALSE

		if("select_announce")
			selected_announce = tgui_input_list(intruder, "Select whether to announce your arrival.", "Arrival Announcement Selection", list("Yes", "No")) == "Yes"

		if("deploy")
			if(!selected_job || !selected_alt_title || !selected_faction || !selected_insertion)
				return FALSE
			deploy_intruder(intruder, selected_job, selected_alt_title, selected_faction, selected_insertion, selected_announce)
			qdel(src)

	return TRUE

/datum/tgui_module/intruder_deployment/proc/deploy_intruder(mob/living/carbon/human/intruder, job_title, alt_title, faction, arrival_method, announce)
	if(!intruder.mind)
		return FALSE

	var/datum/job/selected_job = SSjobs.GetJob(job_title)
	if(!selected_job)
		to_chat(intruder, SPAN_WARNING("Error: Job not found."))
		return FALSE

	if(!selected_job.is_position_available())
		to_chat(intruder, SPAN_WARNING("Error: Job slot no longer available."))
		return FALSE

	// Assign job and title
	selected_job.current_positions++
	intruder.mind.assigned_role = job_title
	intruder.mind.role_alt_title = alt_title
	intruder.mind.selected_faction = SSjobs.name_factions[faction]

	// Determine spawn location
	var/turf/spawn_loc = get_spawn_location(arrival_method)
	if(!spawn_loc)
		spawn_loc = intruder.loc

	// Place uplink in new gear
	var/datum/antagonist/intruder/intruder_antag = get_antag_data(MODE_INTRUDER)
	if(intruder_antag)
		intruder_antag.spawn_uplink(intruder)

	// Create manifest records
	var/datum/record/general/manifest_record = new(intruder)
	var/datum/record/general/locked/locked_record = manifest_record.Copy(new /datum/record/general/locked(intruder))
	SSrecords.add_record(locked_record)
	SSrecords.add_record(manifest_record)

	// Relocate intruder
	intruder.forceMove(spawn_loc)

	// Handle announcement
	if(arrival_method == "Residential Lift" && announce)
		AnnounceArrival(intruder, alt_title, "is inbound from the Arrivals Shuttle")

	to_chat(intruder, SPAN_NOTICE("Deployment sequence initiated. Welcome to [station_name()]."))
	return TRUE

/datum/tgui_module/intruder_deployment/proc/get_spawn_location(arrival_method)
	if(arrival_method == "Residential Lift")
		if(length(GLOB.latejoin_living_quarters_lift))
			return pick(GLOB.latejoin_living_quarters_lift)

	// Stealth: Prefer maintenance, fallback to late-join
	var/turf/T = pick_area_turf(/area/horizon/maintenance, list(/proc/is_station_turf, /proc/not_turf_contains_dense_objects))
	if(T)
		return T

	if(length(GLOB.latejoin_living_quarters_lift))
		return pick(GLOB.latejoin_living_quarters_lift)

	return null
