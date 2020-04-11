//To get rid of pesky moaners
/mob/proc/changeling_eject_hivemind()
	set category = "Changeling"
	set name = "Hivemind Eject"
	set desc = "Ejects a member of our internal hivemind."

	/*var/list/choices_please = list()
	for(var/H in mind.changeling.hivemind_members)
		choices_please += H
		world << "[H] added to choices. list length is [choices_please.len]"*/
	var/chosen_player = input("Choose a hivemind member to eject.", "Eject") as null|anything in mind.changeling.hivemind_members
	if(!chosen_player || chosen_player == "None")
		world << "Eject found no input. Wow! Very unepic, bro! Not very dab!"
		return
	world << "Attempting to eject [chosen_player]"
	mind.changeling.hivemind_members[chosen_player].ghost() // bye
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
		world << "To_chat sent to [M]"

	return TRUE