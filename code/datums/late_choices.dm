// This datum holds the late choices UI for a new player
/datum/late_choices
	var/update_icon_on_next_open = TRUE
	var/datum/tgui/our_ui
	var/icon/character_image
	var/mob/abstract/new_player/NP

/datum/late_choices/New(var/mob/abstract/new_player/NP)
	if(!istype(NP))
		return
	src.NP = NP

/datum/late_choices/Destroy(force)
	NP.late_choices_ui = null
	our_ui?.close()
	QDEL_NULL(our_ui)
	return ..()

/datum/late_choices/ui_state(mob/user)
	return GLOB.new_player_state

/datum/late_choices/ui_status(mob/user, datum/ui_state/state)
	return isnewplayer(user) ? UI_INTERACTIVE : UI_CLOSE

/datum/late_choices/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	// proxy Topic calls back to the user
	NP.Topic(action, params)

/datum/late_choices/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "LateJoin", "Late Join Choices", 330, 720)
		if(!character_image)
			do_update_character_icon()
		ui.open()
		our_ui = ui

	if (update_icon_on_next_open)
		do_update_character_icon()

/datum/late_choices/ui_close(mob/user)
	. = ..()
	our_ui = null

/datum/late_choices/proc/update_character_icon()
	if(our_ui && our_ui.status < UI_INTERACTIVE)
		do_update_character_icon()
	else
		update_icon_on_next_open = TRUE

/datum/late_choices/proc/do_update_character_icon()
	update_icon_on_next_open = FALSE
	var/mob/mannequin = NP.client.prefs.update_mannequin()
	for(var/mutable_appearance/I in mannequin.overlays)
		if(I.plane == EMISSIVE_PLANE)
			mannequin.overlays -= I
	character_image = getFlatIcon(mannequin, SOUTH, no_anim = TRUE)

/datum/late_choices/ui_data(mob/user)
	var/list/data = list()
	data["round_duration"] = get_round_duration_formatted()
	data["alert_level"] = capitalize(get_security_level())
	data["character_name"] = user.client.prefs.real_name

	var/shuttle_status = ""
	if(GLOB.evacuation_controller) //In case NanoTrasen decides to repossess CentComm's shuttles.
		if(GLOB.evacuation_controller.has_evacuated()) //Shuttle is going to centcomm, not recalled
			shuttle_status = "post-evac"
		if(GLOB.evacuation_controller.is_evacuating())
			if(GLOB.evacuation_controller.evacuation_type == TRANSFER_EMERGENCY) // Emergency shuttle is past the point of no recall
				shuttle_status = "evac"
			else // Crew transfer initiated
				shuttle_status = TRANSFER_CREW
	data["shuttle_status"] = shuttle_status
	data["character_image"] = icon2base64(character_image)

	var/unique_role_available = FALSE
	for(var/ghost_role in SSghostroles.spawners)
		var/datum/ghostspawner/G = SSghostroles.spawners[ghost_role]
		if(!G.show_on_job_select)
			continue
		if(G.cant_see(NP))
			continue
		unique_role_available = TRUE
		break

	data["unique_role_available"] = unique_role_available

	var/jobs_available = 0
	var/list/list/datum/job/jobs_by_department = DEPARTMENTS_LIST_INIT
	for(var/datum/job/job in SSjobs.occupations)
		if(NP.IsJobAvailable(job.title))
			jobs_available++
			var/list/departments
			if(job.departments.len > 0 && all_in_list(job.departments, jobs_by_department))
				departments = job.departments
			else // no department set or there's something weird
				departments = list(DEPARTMENT_MISCELLANEOUS = JOBROLE_DEFAULT)

			for(var/department in departments)
				if(departments[department] & JOBROLE_SUPERVISOR) // they are a supervisor/head, put them on top
					jobs_by_department[department] = list(job) + jobs_by_department[department]
				else
					jobs_by_department[department] += job // add them to their departments

	data["jobs_available"] = jobs_available
	data["jobs_list"] = list()
	data["departments"] = list()
	for(var/department in jobs_by_department)
		for(var/datum/job/job in jobs_by_department[department])
			data["departments"] |= department
			data["jobs_list"] += list(list(
				"title" = job.title,
				"department" = department,
				"head" = job.departments[department] & JOBROLE_SUPERVISOR,
				"total_positions" = job.get_total_positions(),
				"current_positions" = job.current_positions
			))

	return data
