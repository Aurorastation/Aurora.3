//To get rid of pesky moaners
/mob/proc/changeling_eject_hivemind()
	set category = "Changeling"
	set name = "Hivemind Eject"
	set desc = "Ejects a member of our internal hivemind."

	if(!(mind?.changeling))
		return
	if(!mind.changeling.hivemind_members.len)
		return
	var/chosen_player = input("Choose a hivemind member to eject.", "Eject") as null|anything in mind.changeling.hivemind_members
	if(!chosen_player || chosen_player == "None")
		return
	var/mob/abstract/hivemind/M = mind.changeling.hivemind_members[chosen_player]
	M.ghost() //Deuces
	return TRUE

/mob/proc/changeling_hivemind_commune()
	set category = "Changeling"
	set name = "Hivemind Commune"
	set desc = "Speak with all members of the hivemind."

	var/message = input(src, "What do you wish to tell your Hivemind?", "Hivemind Commune") as text
	if(!message)
		return
	relay_hivemind(changeling_message_process(message), src)
	return TRUE

/mob/proc/relay_hivemind(var/message, var/mob/ling)
	if(ling.mind?.changeling)
		for(var/H in ling.mind.changeling.hivemind_members) // tell the others in the hivemind
			var/mob/M = ling.mind.changeling.hivemind_members[H]
			to_chat(M, message)
		to_chat(ling, message)

/mob/proc/changeling_message_process(var/message)
	return "<font color=[COLOR_LING_HIVEMIND]>[src] says, \"[message]\"</font>"