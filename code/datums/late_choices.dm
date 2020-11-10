// This datum holds the late choices UI for a new player
// It should exist only as long as the menu is open
/datum/late_choices
	var/datum/vueui/ui
	var/mob/abstract/new_player/NP

/datum/late_choices/CanUseTopic(var/mob/user, var/datum/topic_state/state = default_state) // this is needed because VueUI closes otherwise
	if(isnewplayer(user))
		return STATUS_INTERACTIVE
	return ..()

/datum/late_choices/Topic(href, href_list)
	// proxy Topic calls back to the user
	NP.Topic(href, href_list)

/datum/late_choices/New(var/mob/abstract/new_player/NP)
	if(!istype(NP))
		return
	src.NP = NP
	ui_open(NP)

/datum/late_choices/proc/ui_open(mob/user)
	ui = new(user, src, "late-choices", 330, 720, "Late-Join Choices")
	ui.header = "minimal"
	var/mob/mannequin = user.client.prefs.update_mannequin()
	ui.add_asset("character", getFlatIcon(mannequin, SOUTH))
	ui.open()

/datum/late_choices/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = . || data || list()

	VUEUI_SET_CHECK(data["round_duration"], get_round_duration_formatted(), ., data)
	VUEUI_SET_CHECK(data["alert_level"], capitalize(get_security_level()), ., data)
	VUEUI_SET_CHECK_IFNOTSET(data["character_name"], user.client.prefs.real_name, ., data)

	var/shuttle_status = ""
	if(emergency_shuttle) //In case Nanotrasen decides to reposess CentComm's shuttles.
		if(emergency_shuttle.going_to_centcom()) //Shuttle is going to centcomm, not recalled
			shuttle_status = "post-evac"
		if(emergency_shuttle.online())
			if (emergency_shuttle.evac) // Emergency shuttle is past the point of no recall
				shuttle_status = "evac"
			else // Crew transfer initiated
				shuttle_status = "transfer"
	VUEUI_SET_CHECK(data["shuttle_status"], shuttle_status, ., data)
	VUEUI_SET_CHECK(data["alert_level"], capitalize(get_security_level()), ., data)

	var/unique_role_available = FALSE
	for(var/ghost_role in SSghostroles.spawners)
		var/datum/ghostspawner/G = SSghostroles.spawners[ghost_role]
		if(!G.show_on_job_select)
			continue
		if(G.cant_see(NP))
			continue
		unique_role_available = TRUE
		break

	VUEUI_SET_CHECK(data["unique_role_available"], unique_role_available, ., data)

	var/jobs_available = 0
	var/list/list/datum/job/jobs_by_department = DEPARTMENTS_LIST_INIT
	for(var/datum/job/job in SSjobs.occupations)
		if(NP.IsJobAvailable(job.title))
			jobs_available++
			var/department = job.department
			if(!(department in jobs_by_department)) // no department set or it's something weird
				department = DEPARTMENT_MISCELLANEOUS
			if(job.head_position) // make sure heads are first
				jobs_by_department[department] = list(job) + jobs_by_department[department]
				if(department != DEPARTMENT_COMMAND) // add heads to command
					jobs_by_department[DEPARTMENT_COMMAND] += job
			else
				jobs_by_department[department] += job

	VUEUI_SET_CHECK(data["jobs_available"], jobs_available, ., data)
	LAZYINITLIST(data["jobs_list"])
	for(var/department in jobs_by_department)
		LAZYINITLIST(data["jobs_list"][department])
		for(var/datum/job/job in jobs_by_department[department])
			LAZYINITLIST(data["jobs_list"][department][job.title])
			VUEUI_SET_CHECK_IFNOTSET(data["jobs_list"][department][job.title]["title"], job.title, ., data)
			VUEUI_SET_CHECK(data["jobs_list"][department][job.title]["head"], job.head_position, ., data)
			VUEUI_SET_CHECK_IFNOTSET(data["jobs_list"][department][job.title]["total_positions"], job.get_total_positions(), ., data)
			VUEUI_SET_CHECK(data["jobs_list"][department][job.title]["current_positions"], job.current_positions, ., data)

/datum/late_choices/vueui_on_close(var/datum/vueui/ui)
	// We must remove self from the holding mob when the UI closes.
	// That should be enough for us to get garbage collected.
	NP.late_choices_ui = null
