// This datum holds the late choices UI for a new player
/datum/late_choices
	var/datum/tgui/ui
	var/update_icon_on_next_open = TRUE
	var/mob/abstract/new_player/NP

/datum/late_choices/New(var/mob/abstract/new_player/NP)
	if(!istype(NP))
		return
	src.NP = NP

/datum/late_choices/Destroy(force)
	NP.late_choices_ui = null
	ui.close()
	QDEL_NULL(ui)
	return ..()

/datum/late_choices/ui_state(mob/user)
	return new_player_state

/datum/late_choices/ui_status(mob/user, datum/ui_state/state)
	return isnewplayer(user) ? UI_INTERACTIVE : UI_CLOSE

/datum/late_choices/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	// proxy Topic calls back to the user
	NP.Topic(action, params)

/datum/late_choices/proc/ui_open()
	ui = SStgui.try_update_ui(NP, src, ui)
	if(!ui)
		ui = new(NP, src, "LateJoin", "Late Join Choices", 330, 720)
		ui.open()

	if (update_icon_on_next_open)
		do_update_character_icon(FALSE)

/datum/late_choices/proc/update_character_icon()
	if(ui.status > STATUS_CLOSE)
		do_update_character_icon(TRUE)
	else
		update_icon_on_next_open = TRUE

/datum/late_choices/proc/do_update_character_icon(var/send)
	update_icon_on_next_open = FALSE
	var/mob/mannequin = NP.client.prefs.update_mannequin()
	var/datum/asset/spritesheet/S = new()
	S.name = "character-[NP.key]"
	S.Insert("character", getFlatIcon(mannequin, SOUTH))
	S.register()
	if(send)
		ui.send_asset(S)

/datum/late_choices/ui_data(mob/user)
	var/list/data = list()
	data["round_duration"] = get_round_duration_formatted()
	data["alert_level"] = capitalize(get_security_level())
	data["character_name"] = user.client.prefs.real_name

	var/shuttle_status = ""
	if(evacuation_controller) //In case NanoTrasen decides to repossess CentComm's shuttles.
		if(evacuation_controller.has_evacuated()) //Shuttle is going to centcomm, not recalled
			shuttle_status = "post-evac"
		if(evacuation_controller.is_evacuating())
			if (evacuation_controller.emergency_evacuation) // Emergency shuttle is past the point of no recall
				shuttle_status = "evac"
			else // Crew transfer initiated
				shuttle_status = "transfer"
	data["shuttle_status"] = shuttle_status

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
	for(var/department in jobs_by_department)
		for(var/datum/job/job in jobs_by_department[department])
			data["jobs_list"] += list(list(
				"title" = job.title,
				"department" = department,
				"head" = job.departments[department] & JOBROLE_SUPERVISOR,
				"total_positions" = job.get_total_positions(),
				"current_positions" = job.current_positions
			))

	return data
