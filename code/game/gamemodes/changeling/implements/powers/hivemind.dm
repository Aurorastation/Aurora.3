//To get rid of pesky moaners
/mob/proc/changeling_eject_hivemind()
	set category = "Changeling"
	set name = "Hivemind Eject"
	set desc = "Ejects a hivemind from ourselves."

	var/list/mob/hiveminds_to_eject = list()

	for(var/mob/abstract/hivemind/H in src.mind.changeling.hivemind)
		hiveminds_to_eject += H
	hiveminds_to_eject += "None"

	var/mob/abstract/hivemind/chosen_hivemind = input("Choose a hivemind to eject.") in hiveminds_to_eject
	if(!chosen_hivemind || chosen_hivemind == "None")
		return
	else
		chosen_hivemind.ghost() // bye

	return TRUE