/datum/antagonist/proc/create_global_objectives()
	if(GLOB.config.objectives_disabled)
		return 0
	if(global_objectives && global_objectives.len)
		return 0
	return 1

/datum/antagonist/proc/create_objectives(var/datum/mind/player)
	if(GLOB.config.objectives_disabled)
		return 0
	if(create_global_objectives() || global_objectives.len)
		player.objectives |= global_objectives
	return 1

/datum/antagonist/proc/get_special_objective_text()
	return ""

/datum/antagonist/proc/check_victory()
	var/result = 1
	if(GLOB.config.objectives_disabled)
		return 1
	if(global_objectives && global_objectives.len)
		for(var/datum/objective/O in global_objectives)
			if(!O.completed && !O.check_completion())
				result = 0
		if(result && victory_text)
			to_world(SPAN_DANGER("<font size = 3>[victory_text]</font>"))
			if(victory_feedback_tag) feedback_set_details("round_end_result","[victory_feedback_tag]")
		else if(loss_text)
			to_world(SPAN_DANGER("<font size = 3>[loss_text]</font>"))
			if(loss_feedback_tag) feedback_set_details("round_end_result","[loss_feedback_tag]")

/**
 * Prompts the user to input an ambition, that is displayed at the end of the round text to everyone
 *
 * Only to be called as a verb, not programmatically
 */
/mob/living/proc/write_ambition()
	set name = "Set Ambition"
	set category = "IC.Antag"

	if(!(usr?.mind))
		return

	if(!is_special_character(usr))
		to_chat(src, SPAN_WARNING("While you may perhaps have goals, this verb's meant to only be visible to antagonists.  Please make a bug report!"))
		return

	var/new_ambitions = tgui_input_text(src, "Write a short sentence of what your character hopes to accomplish \
												today as an antagonist.  Remember that this is purely optional. \
												It will be shown at the end of the round for everybody else.",
												"Ambitions", html_decode(usr.mind.ambitions), multiline = TRUE)

	if(isnull(new_ambitions))
		return

	new_ambitions = sanitize(new_ambitions)
	usr.mind.ambitions = new_ambitions

	if(new_ambitions)
		to_chat(src, SPAN_NOTICE("You've set your goal to be '[new_ambitions]'."))
	else
		to_chat(src, SPAN_NOTICE("You leave your ambitions behind."))
