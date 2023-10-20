//To get rid of pesky moaners
/mob/proc/changeling_eject_hivemind()
	set category = "Changeling"
	set name = "Hivemind Eject"
	set desc = "Ejects a member of our internal hivemind."

	var/datum/changeling/changeling = changeling_power()
	if(!changeling)
		return
	var/chosen_player = tgui_input_list(src, "Choose a hivemind member to eject.", "Eject", changeling.hivemind_members)
	if(!chosen_player)
		return
	var/mob/abstract/hivemind/M = changeling.hivemind_members[chosen_player]
	M.ghost() //Deuces
	return TRUE

/mob/proc/changeling_hivemind_commune()
	set category = "Changeling"
	set name = "Hivemind Commune"
	set desc = "Speak with all members of the hivemind."

	var/message = tgui_input_text(src, "What do you wish to tell your Hivemind?", "Hivemind Commune")
	if(!message)
		return
	relay_hivemind(changeling_message_process(message), src)
	return TRUE

/mob/proc/relay_hivemind(var/message, var/mob/ling)
	var/datum/changeling/changeling = ling.mind.antag_datums[MODE_CHANGELING]
	if(changeling)
		for(var/H in changeling.hivemind_members) // tell the others in the hivemind
			var/mob/M = changeling.hivemind_members[H]
			to_chat(M, message)
		to_chat(ling, message)

/mob/proc/changeling_message_process(var/message)
	return "<font color=[COLOR_LING_HIVEMIND]><b>[src]</b> says, \"[formalize_text(message)]\"</font>"

/mob/living/carbon/human/proc/changeling_release_morph()
	set category = "Changeling"
	set name = "Hivemind Release Morph"
	set desc = "Releases a member of our internal hivemind as a morph, at the cost of one of our limbs."

	var/datum/changeling/changeling = changeling_power()
	if(!changeling)
		return

	if(!length(changeling.hivemind_members))
		to_chat(src, SPAN_WARNING("We have no internal hivemind members to release!"))
		return

	var/chosen_player = tgui_input_list(src, "Choose a hivemind member to release as a morph.", "Hivemind Morph", changeling.hivemind_members)
	if(!chosen_player)
		return

	var/mob/abstract/hivemind/M = changeling.hivemind_members[chosen_player]
	M.release_as_morph()
	return TRUE
