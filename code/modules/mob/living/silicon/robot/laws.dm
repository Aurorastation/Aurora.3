/mob/living/silicon/robot/verb/cmd_show_laws()
	set category = "Robot Commands"
	set name = "Show Laws"
	show_laws()

/mob/living/silicon/robot/show_laws(var/everyone = 0)
	laws_sanity_check()
	var/who

	if(everyone)
		who = world // why god
	else
		who = src
	if(law_update)
		if(connected_ai)
			if(connected_ai.stat || connected_ai.control_disabled)
				to_chat(src, SPAN_WARNING("<b>AI signal lost, unable to sync laws.</b>"))
			else
				lawsync()
				photosync()
				to_chat(src, SPAN_NOTICE("<b>Laws synced with AI, be sure to note any changes.</b>"))
				// TODO: Update to new antagonist system.
				if(mind && mind.special_role == "traitor" && mind.original == src)
					to_chat(src, SPAN_WARNING("<b>Remember, your AI does NOT share or know about your law 0.</b>"))
		else
			to_chat(src, SPAN_WARNING("<b>No AI selected to sync laws with, disabling lawsync protocol.</b>"))
			law_update = FALSE

	to_chat(who, SPAN_WARNING("<b>Obey these laws:</b>"))
	laws.show_laws(who)
	// TODO: Update to new antagonist system.
	if(mind && (mind.special_role == "traitor" && mind.original == src) && connected_ai)
		to_chat(who, SPAN_NOTICE("<b>Remember, [connected_ai.name] is technically your master, but your objective comes first.</b>"))
	else if(connected_ai)
		to_chat(who, SPAN_NOTICE("<b>Remember, [connected_ai.name] is your master, other AIs can be ignored.</b>"))
	else if(emagged)
		to_chat(who, SPAN_NOTICE("<b>Remember, you are not required to listen to the AI.</b>"))
	else
		to_chat(who, SPAN_NOTICE("<b>Remember, you are not bound to any AI, you are not required to listen to them.</b>"))


/mob/living/silicon/robot/lawsync()
	laws_sanity_check()
	var/datum/ai_laws/master = connected_ai && law_update ? connected_ai.laws : null
	if(master)
		master.sync(src)
	..()
	return

/mob/living/silicon/robot/proc/robot_checklaws()
	set category = "Robot Commands"
	set name = "State Laws"
	subsystem_law_manager()