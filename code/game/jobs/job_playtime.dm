// Admin Verbs
/client/proc/cmd_check_player_playtime()	//Allows admins to determine who the newer players are.
	set category = "Admin"
	set name = "Check Player Playtime"

	if(!check_rights(R_ADMIN|R_MOD))
		return
	
	var/msg = "<html><head><title>Playtime Report</title></head><body>"
	var/datum/job/theirjob
	var/jtext
	msg += "<TABLE border ='1'><TR><TH>Player</TH><TH>Job</TH><TH>Crew</TH>"
	for(var/thisdept in PLAYTIME_DEPT_TYPE_LIST)
		msg += "<TH>[thisdept]</TH>"
	msg += "</TR>"
	for(var/client/C in clients)
		msg += "<TR>"
		msg += "<TD>[key_name_admin(C.mob)]</TD>"

		jtext = "-"
		if(C.mob.mind?.assigned_role)
			theirjob = SSjobs.GetJob(C.mob.mind.assigned_role)
			if(theirjob)
				jtext = theirjob.title
		msg += "<TD>[jtext]</TD>"

		msg += "<TD><A href='?_src_=holder;getplaytimewindow=[ref(C.mob)]'>" + C.get_playtime_type(PLAYTIME_TYPE_CREW) + "</a></TD>"
		msg += "[C.get_playtime_dept_string()]"
		msg += "</TR>"

	msg += "</TABLE></BODY></HTML>"
	src << browse(msg, "window=Player_playtime_check")


/datum/admins/proc/cmd_show_playtime_panel(client/C)
	if(!C)
		to_chat(usr, "ERROR: Client not found.")
		return
	if(!check_rights(R_ADMIN|R_MOD))
		return
	var/body = "<html><head><title>Playtime for [C.key]</title></head><BODY><BR>Playtime:"
	body += C.get_playtime_report()
	body += "</BODY></HTML>"
	usr << browse(body, "window=playerplaytime[C.ckey];size=550x615")


// Procs
/datum/job/proc/available_in_playtime(client/C)
	if(!C)
		return 0
	if(!playtime_requirements || !playtime_type)
		return 0
	if(!config.use_playtime_restrictions)
		return 0
	if(config.use_playtime_restrictions_admin_bypass && check_rights(R_ADMIN, 0, C.mob))
		return 0
	var/list/play_records = params2list(C.prefs.playtime)
	var/my_playtime = text2num(play_records[get_playtime_req_type()])
	var/job_requirement = text2num(get_playtime_req_amount())
	if(my_playtime >= job_requirement)
		return 0
	else
		return (job_requirement - my_playtime)

/datum/job/proc/get_playtime_req_amount()
	return playtime_requirements

/datum/job/proc/get_playtime_req_type()
	return playtime_type

/mob/proc/get_playtime_report()
	if(client)
		return client.get_playtime_report()
	else
		return "[src] has no client."

/client/proc/get_playtime_report()
	if(!config.use_playtime_tracking)
		return "Tracking is disabled in the server configuration file."
	var/list/play_records = params2list(prefs.playtime)
	if(!play_records.len)
		return "[key] has no records."
	var/return_text = "<UL>"
	var/list/playtime_data = list()
	for(var/category in playtime_jobsmap)
		if(text2num(play_records[category]))
			playtime_data[category] = text2num(play_records[category])
		else
			playtime_data[category] = 0
	for(var/dep in playtime_data)
		if(playtime_data[dep] > 0)
			if(playtime_data[PLAYTIME_TYPE_LIVING] > 0)
				return_text += "<LI>[dep]: [get_playtime_format(playtime_data[dep])]</LI>"
	if(config.use_playtime_restrictions_admin_bypass && check_rights(R_ADMIN, 0, mob))
		return_text += "<LI>Admin</LI>"
	return_text += "</UL>"
	if(config.use_playtime_restrictions)
		var/list/jobs_locked = list()
		var/list/jobs_unlocked = list()
		for(var/datum/job/job in SSjobs.occupations)
			if(job.playtime_requirements && job.playtime_type)
				if(!job.available_in_playtime(mob.client))
					jobs_unlocked += job.title
				else
					var/xp_req = job.get_playtime_req_amount()
					jobs_locked += "[job.title] ([get_playtime_format(text2num(play_records[job.get_playtime_req_type()]))] / [get_playtime_format(xp_req)] as [job.get_playtime_req_type()])"
		if(jobs_unlocked.len)
			return_text += "<BR><BR>Jobs Unlocked:<UL><LI>"
			return_text += jobs_unlocked.Join("</LI><LI>")
			return_text += "</LI></UL>"
		if(jobs_locked.len)
			return_text += "<BR><BR>Jobs Not Unlocked:<UL><LI>"
			return_text += jobs_locked.Join("</LI><LI>")
			return_text += "</LI></UL>"
	return return_text

/client/proc/get_playtime_type(etype)
	return get_playtime_format(get_playtime_type_num(etype))

/client/proc/get_playtime_type_num(etype)
	var/list/play_records = params2list(prefs.playtime)
	return text2num(play_records[etype])

/client/proc/get_playtime_dept_string()
	var/list/play_records = params2list(prefs.playtime)
	var/list/result_text = list()
	for(var/thistype in PLAYTIME_DEPT_TYPE_LIST)
		var/thisvalue = text2num(play_records[thistype])
		if(thisvalue)
			result_text.Add("<TD>[get_playtime_format(thisvalue)]</TD>")
		else
			result_text.Add("<TD>-</TD>")
	return result_text.Join("")


/proc/get_playtime_format(playtimenum)
	if(playtimenum > 60)
		return num2text(round(playtimenum / 60)) + "h"
	else if(playtimenum > 0)
		return num2text(playtimenum) + "m"
	else
		return "none"