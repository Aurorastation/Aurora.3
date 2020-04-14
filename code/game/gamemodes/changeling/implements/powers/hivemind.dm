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

	to_chat(src, "<font color=[COLOR_LING_I_HIVEMIND]>[src] says, \"[message]\"</font>") // tell the changeling
	for(var/H in src.mind.changeling.hivemind_members) // tell the other hiveminds
		var/mob/M = mind.changeling.hivemind_members[H]
		to_chat(M, "<font color=[COLOR_LING_I_HIVEMIND]>[src] says, \"[message]\"</font>")

	return TRUE