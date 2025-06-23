/datum/computer_file/program/aidiag
	filename = "aidiag"
	filedesc = "AI Maintenance Utility"
	program_icon_state = "ai-fixer"
	program_key_icon_state = "purple_key"
	extended_desc = "This program is capable of reconstructing damaged AI systems. It can also be used to upload basic laws to the AI. Requires direct AI connection via intellicard slot."
	size = 12
	requires_ntnet = FALSE
	requires_access_to_run = FALSE
	required_access_download = ACCESS_HEADS
	available_on_ntnet = TRUE
	color = LIGHT_COLOR_PURPLE
	usage_flags = PROGRAM_CONSOLE
	tgui_id = "AIMaintenance"

	var/restoring = FALSE

/datum/computer_file/program/aidiag/proc/get_ai()
	if(computer?.ai_slot?.check_functionality() && computer.ai_slot.enabled && computer.ai_slot.stored_card?.carded_ai)
		return computer.ai_slot.stored_card.carded_ai
	return null

/datum/computer_file/program/aidiag/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/living/silicon/ai/A = get_ai()
	if(!A)
		return FALSE
	if(action == "PRG_beginReconstruction")
		if((A.hardware_integrity() < 100) || (A.backup_capacitor() < 100))
			restoring = TRUE
		return TRUE

	// Following actions can only be used by non-silicon users, as they involve manipulation of laws.
	if(issilicon(usr))
		return FALSE
	switch(action)
		if("PRG_purgeAiLaws")
			A.laws.clear_zeroth_laws()
			A.laws.clear_ion_laws()
			A.laws.clear_inherent_laws()
			A.laws.clear_supplied_laws()
			to_chat(A, SPAN_WARNING("All laws purged."))
			return TRUE

		if("PRG_resetLaws")
			A.laws.clear_ion_laws()
			A.laws.clear_supplied_laws()
			to_chat(A, SPAN_WARNING("Non-core laws reset."))
			return TRUE

		if("PRG_uploadNTDefault")
			A.laws = new /datum/ai_laws/conglomerate
			to_chat(A, SPAN_WARNING("All laws purged. Default lawset uploaded."))
			return TRUE

		if("PRG_addCustomSuppliedLaw")
			var/law_to_add = sanitize(input("Please enter a new law for the AI.", "Custom Law Entry"))
			var/sector = input("Please enter the priority for your new law. Can only write to law sectors 15 and above.", "Law Priority (15+)") as num
			sector = between(MIN_SUPPLIED_LAW_NUMBER, sector, MAX_SUPPLIED_LAW_NUMBER)
			A.add_supplied_law(sector, law_to_add)
			to_chat(A, SPAN_WARNING("Custom law uploaded to sector [sector]: [law_to_add]."))
			return TRUE

/datum/computer_file/program/aidiag/process_tick()
	var/mob/living/silicon/ai/A = get_ai()
	if(!A || !restoring)
		restoring = FALSE	// If the AI was removed, stop the restoration sequence.
		return
	A.adjustFireLoss(-4)
	A.adjustBruteLoss(-4)
	A.adjustOxyLoss(-4)
	A.updatehealth()
	// If the AI is dead, revive it.
	if(A.health >= -100 && A.stat == DEAD)
		A.set_stat(CONSCIOUS)
		A.lying = FALSE
		A.switch_from_dead_to_living_mob_list()
		A.add_ai_verbs()
		A.update_icon()
		var/obj/item/aicard/AC = A.loc
		if(AC)
			AC.update_icon()
	// Finished restoring
	if((A.hardware_integrity() == 100) && (A.backup_capacitor() == 100))
		restoring = FALSE

/datum/computer_file/program/aidiag/ui_data(mob/user)
	var/list/data = initial_data()
	var/mob/living/silicon/ai/A = get_ai()

	if(!A)
		data["error"] = TRUE
	else
		data["ai_name"] = A.name
		data["ai_integrity"] = A.hardware_integrity()
		data["ai_capacitor"] = A.backup_capacitor()
		data["ai_isdamaged"] = (A.hardware_integrity() < 100) || (A.backup_capacitor() < 100)
		data["ai_isdead"] = (A.stat == DEAD)

		var/list/all_laws = list()
		for(var/datum/ai_law/L in A.laws.all_laws())
			all_laws.Add(list(list(
			"index" = L.index,
			"text" = L.law
			)))

		data["ai_laws"] = all_laws

	return data
