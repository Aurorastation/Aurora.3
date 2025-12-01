// Admin verbs for NPC Crew system

/client/proc/check_npc_crew_status()
	set name = "Check NPC Crew Status"
	set category = "Admin.Game"

	if(!check_rights(R_ADMIN))
		return

	if(!SSnpc_crew || !SSnpc_crew.enabled)
		to_chat(src, SPAN_WARNING("NPC Crew system is not enabled."))
		return

	var/msg = "<b>NPC Crew Status</b><br>"
	msg += "Active NPCs: [SSnpc_crew.get_npc_count()] / [SSnpc_crew.max_npcs]<br><br>"

	for(var/datum/npc_crew_member/npc in SSnpc_crew.npcs)
		var/job_title = npc.assigned_job ? npc.assigned_job.title : "Unknown"
		var/status = npc.body ? (npc.body.stat == CONSCIOUS ? "Alive" : "Incapacitated") : "No body"
		var/loc = npc.body ? "[get_area(npc.body)]" : "N/A"
		var/npc_name = npc.body ? npc.body.real_name : "Unknown"
		msg += "<b>[npc_name]</b> - [job_title]<br>"
		msg += "  Status: [status], Location: [loc]<br>"
		msg += "  Personality: [npc.get_personality_description()]<br><br>"

	to_chat(src, msg)

/client/proc/force_spawn_npc()
	set name = "Force Spawn NPC"
	set category = "Admin.Game"

	if(!check_rights(R_ADMIN))
		return

	if(!SSnpc_crew)
		to_chat(src, SPAN_WARNING("NPC Crew subsystem not initialized."))
		return

	var/list/job_choices = list()
	for(var/datum/job/J in SSjobs.occupations)
		job_choices[J.title] = J

	var/choice = input(src, "Select job for NPC:", "Spawn NPC") as null|anything in job_choices
	if(!choice)
		return

	var/datum/job/selected_job = job_choices[choice]
	if(SSnpc_crew.spawn_npc_for_job(selected_job))
		to_chat(src, SPAN_NOTICE("Spawned NPC [choice]."))
	else
		to_chat(src, SPAN_WARNING("Failed to spawn NPC."))
