// This datum holds the late choices UI for a new player
/datum/late_choices
	var/datum/vueui/ui = null
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

/datum/late_choices/CanUseTopic(var/mob/user, var/datum/topic_state/state = default_state) // this is needed because VueUI closes otherwise
	if(isnewplayer(user))
		return STATUS_INTERACTIVE
	return ..()

/datum/late_choices/Topic(href, href_list)
	// proxy Topic calls back to the user
	NP.Topic(href, href_list)

/datum/late_choices/proc/ui_open()
	if(!istype(ui))
		ui = new(NP, src, "late-choices", 330, 720, "Late-Join Choices")
		ui.header = "minimal"
		ui.auto_update_content = TRUE

	if (update_icon_on_next_open)
		do_update_character_icon(FALSE)

	ui.open()

/datum/late_choices/proc/ui_refresh()
	ui.check_for_change()

/datum/late_choices/proc/update_character_icon()
	if(ui.status > STATUS_CLOSE)
		do_update_character_icon(TRUE)
	else
		update_icon_on_next_open = TRUE

/datum/late_choices/proc/do_update_character_icon(var/send)
	update_icon_on_next_open = FALSE
	var/mob/mannequin = NP.client.prefs.update_mannequin()
	ui.add_asset("character", getFlatIcon(mannequin, SOUTH))
	if(send)
		ui.send_asset("character")
		ui.push_change(null)

/datum/late_choices/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = . || data || list()

	data["round_duration"] = get_round_duration_formatted()
	data["alert_level"] = capitalize(get_security_level())
	data["character_name"] = user.client.prefs.real_name

	var/shuttle_status = ""
	if(evacuation_controller) //In case NanoTrasen decides to reposess CentComm's shuttles.
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
	LAZYINITLIST(data["jobs_list"])
	for(var/department in jobs_by_department)
		LAZYINITLIST(data["jobs_list"][department])
		for(var/datum/job/job in jobs_by_department[department])
			LAZYINITLIST(data["jobs_list"][department][job.title])
			data["jobs_list"][department][job.title]["title"] = job.title
			data["jobs_list"][department][job.title]["head"] = job.departments[department] & JOBROLE_SUPERVISOR
			data["jobs_list"][department][job.title]["total_positions"] = job.get_total_positions()
			data["jobs_list"][department][job.title]["current_positions"] = job.current_positions

	return data
