GLOBAL_LIST_EMPTY(empty_playable_ai_cores)

/hook/pregame_start/proc/spawn_empty_ai()
	//No gamemode disables the AI anyways, and this would prevent this hook from working correctly, so it's a problem for whoever might want to implement a gamemode that doesn't
	//allow an AI in the future, which is likely (hopefully?) never
	// if("AI" in SSticker.mode.disabled_jobs)
	// 	return 1	// Don't make empty AI's if you can't have them (also applies to Malf)
	for(var/obj/effect/landmark/start/S in GLOB.landmarks_list)
		if(S.name != "AI")
			continue
		if(locate(/mob/living) in S.loc)
			continue
		GLOB.empty_playable_ai_cores += new /obj/structure/AIcore/deactivated(get_turf(S))

	return 1

/mob/living/silicon/ai/proc/do_wipe_core()
	GLOB.empty_playable_ai_cores += new /obj/structure/AIcore/deactivated(loc)
	GLOB.global_announcer.autosay("[src] has been moved to intelligence storage.", "Artificial Intelligence Oversight")

	//Handle job slot/tater cleanup.
	var/job = mind.assigned_role

	SSjobs.FreeRole(job)

	if(mind.objectives.len)
		qdel(mind.objectives)
		mind.special_role = null

	clear_antag_roles(mind)

	ghostize(0)
	qdel(src)

/mob/living/silicon/ai/verb/wipe_core()
	set name = "Wipe Core"
	set category = "OOC"
	set desc = "Wipe your core. This is functionally equivalent to cryo or robotic storage, freeing up your job slot."

	if(SSticker.mode && SSticker.mode.name == "AI malfunction")
		to_chat(usr, "<span class='danger'>You cannot use this verb in malfunction. If you need to leave, please adminhelp.</span>")
		return

	if(carded)
		to_chat(usr, "<span class='danger'>No connection to station intelligence storage. You must be in an AI Core to store yourself (adminhelp if you need to leave).</span>")
		return

	// Guard against misclicks, this isn't the sort of thing we want happening accidentally
	if(alert("WARNING: This will immediately wipe your core and ghost you, removing your character from the round permanently (similar to cryo and robotic storage). Are you entirely sure you want to do this?",
					"Wipe Core", "No", "No", "Yes") != "Yes")
		return

	// We warned you.
	do_wipe_core()
