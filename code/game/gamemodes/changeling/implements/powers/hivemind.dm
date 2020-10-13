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
	if(!chosen_player)
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
	message = capitalize(message)

	var/static/list/correct_punctuation = list("!" = TRUE, "." = TRUE, "?" = TRUE, "-" = TRUE, "~" = TRUE, "*" = TRUE, "/" = TRUE, ">" = TRUE, "\"" = TRUE, "'" = TRUE, "," = TRUE, ":" = TRUE, ";" = TRUE)
	var/ending = copytext(message, length(message), (length(message) + 1))
	if(ending && !correct_punctuation[ending])
		message += "."

	return "<font color=[COLOR_LING_HIVEMIND]><b>[src]</b> says, \"[message]\"</font>"

/mob/living/carbon/human/proc/changeling_release_morph()
	set category = "Changeling"
	set name = "Hivemind Release Morph"
	set desc = "Releases a member of our internal hivemind as a morph, at the cost of one of our limbs."

	if(!mind?.changeling)
		return

	if(!length(mind.changeling.hivemind_members))
		to_chat(src, SPAN_WARNING("We have no internal hivemind members to release!"))
		return

	var/chosen_player = input("Choose a hivemind member to release as a morph.", "Hivemind Morph") as null|anything in mind.changeling.hivemind_members
	if(!chosen_player)
		return

	var/list/selectable_limb = list()
	for(var/organ_name in list(BP_L_ARM, BP_R_ARM, BP_L_LEG, BP_R_LEG))
		var/obj/item/organ/external/limb = organs_by_name[organ_name]
		if(limb && !limb.is_stump())
			selectable_limb += limb

	if(!length(selectable_limb))
		to_chat(src, SPAN_WARNING("We have no limbs to sacrifice!"))
		return

	var/obj/item/organ/external/chosen_limb = input("Choose a limb to sacrifice.", "Limb Sacrifice") as null|anything in selectable_limb
	if(!chosen_limb)
		return

	chosen_limb.droplimb(TRUE, DROPLIMB_BLUNT)

	var/mob/abstract/hivemind/M = mind.changeling.hivemind_members[chosen_player]
	M.release_as_morph()
	return TRUE