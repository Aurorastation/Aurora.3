//To get rid of pesky moaners
/mob/proc/changeling_eject_hivemind()
	set category = "Changeling"
	set name = "Hivemind Eject"
	set desc = "Ejects a member of our internal hivemind."

	var/list/hivemind_choices = mind.changeling.hivemind
	var/chosen_player = input(src, "Choose a hivemind member to eject.", "Eject") in hivemind_choices
	if(!chosen_player || chosen_player == "None")
		world << "Eject found no input"
		return
	world << "Attempting to eject [chosen_player]"
	var/mob/abstract/hivemind/chosen_hivemind = chosen_player
	chosen_hivemind.ghost() // bye
	return TRUE

/mob/proc/changeling_hivemind_commune()
	set category = "Changeling"
	set name = "Hivemind Commune"
	set desc = "Speak with all members of the hivemind."

	var/message = input(src, "What do you wish to tell your Hivemind?", "Hivemind Commune") as text
	if(!message)
		return

	to_chat(src, "<font color=[COLOR_LING_I_HIVEMIND]>[src] says, \"[message]\"</font>") // tell the changeling
	for(var/H in src.mind.changeling.hivemind) // tell the other hiveminds
		to_chat(H, "<font color=[COLOR_LING_I_HIVEMIND]>[src] says, \"[message]\"</font>")

	return TRUE