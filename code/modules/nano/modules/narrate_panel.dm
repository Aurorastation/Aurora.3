/datum/tgui_module/narrate_panel/ui_interact(var/mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "NarratePanel", "Narrate Panel", 800, 400)
		ui.open()

/datum/tgui_module/narrate_panel/ui_data(mob/user)
	var/list/data = list()
	data["narrate_styles"] = list("danger", "notice", "warning", "alien", "cult")
	data["narrate_locations"] = list("View", "Range", "Z-Level", "Global")
	data["narrate_filters"] = list("None", "Skrell-like Psi-sensitives", "Human-like Psi-sensitives", "Silicons", "Silicons + Implants")
	return data

/datum/tgui_module/narrate_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/abstract/ghost/ghost = ui.user
	if(!istype(ghost))
		return FALSE

	if(action == "narrate")
		var/narrate_text = sanitizeSafe(params["narrate_text"])
		if(!length(narrate_text))
			to_chat(ghost, SPAN_WARNING("No text was supplied!"))
			return FALSE

		var/narrate_style = params["narrate_style"]
		if(!narrate_style)
			to_chat(ghost, SPAN_WARNING("No text style was supplied!"))
			return FALSE

		var/narrate_size = text2num(params["narrate_size"])
		if(!isnum(narrate_size))
			to_chat(ghost, SPAN_WARNING("No text size was supplied!"))
			return FALSE

		var/narrate_range = text2num(params["narrate_range"])
		if(!isnum(narrate_range))
			to_chat(ghost, SPAN_WARNING("No narrate range was supplied!"))
			return FALSE

		var/narrate_location = params["narrate_location"]
		if(!narrate_location)
			to_chat(ghost, SPAN_WARNING("No narrate location was supplied!"))
			return FALSE

		var/list/mobs_to_message = list()
		switch(narrate_location)
			if("View")
				for(var/mob/M in get_hearers_in_view(narrate_range, ghost))
					mobs_to_message |= M

			if("Range")
				for(var/mob/M in get_hearers_in_range(narrate_range, ghost))
					mobs_to_message |= M

			if("Z-Level")
				for(var/mob/M in GLOB.player_list)
					if(GET_Z(M) == ghost.z)
						mobs_to_message |= M

			if("Global")
				mobs_to_message = GLOB.player_list.Copy()

		// Create a copy of the message receivers. We have to iterate the copy of the list in order to safely remove entries from the list of message receivers.
		// Otherwise we'll get memory exceptions.
		var/list/filtered_list = mobs_to_message.Copy()
		var/narrate_filter = params["narrate_filter"]
		switch(narrate_filter)
			if ("Skrell-like Psi-sensitives")
				for(var/mob/filteree in filtered_list)
					// This will check for anyone who is capable of receiving and interpreting telepathic messages.
					// It will include Skrell who don't have a mindshield or the Low Psi-sensitivity trait.
					// It will also include characters who have Psi-receivers, the High Psi-sensitivity trait, or are under the effects of Psycho-nootropic drugs.
					if (!filteree.has_zona_bovinae() || filteree.is_psi_blocked() || filteree.check_psi_sensitivity() < PSI_RANK_SENSITIVE)
						mobs_to_message.Remove(filteree)
						continue
			if ("Human-like Psi-sensitives")
				for(var/mob/filteree in filtered_list)
					// This will check for anyone who has a Zona Bovina capable of hearing psionics at all.
					if (!filteree.has_zona_bovinae() || filteree.is_psi_blocked() || filteree.check_psi_sensitivity() < 0)
						mobs_to_message.Remove(filteree)
						continue
			if ("Silicons")
				for(var/mob/filteree in filtered_list)
					// List will include Borgs, Robots, Shipbounds, pAIs, and IPCs.
					if(issilicon(filteree) || isipc(filteree) || ispAI(filteree))
						continue

					// Remove anyone not made of silicon.
					mobs_to_message.Remove(filteree)
			if ("Silicons + Implants")
				for(var/mob/filteree in filtered_list)
					// List will include Borgs, Robots, Shipbounds, pAIs, and IPCs.
					if(issilicon(filteree) || isipc(filteree) || ispAI(filteree))
						continue


					if (!ishuman(filteree))
						// The mob in question can't have a brain at all, filter it early.
						mobs_to_message.Remove(filteree)
						continue

					var/mob/living/carbon/human/brain_haver = filteree
					// Check for silicon brain implants.
					var/obj/item/organ/internal/brain = brain_haver.internal_organs_by_name[BP_BRAIN]
					if (brain && ((brain.status & ORGAN_ASSISTED) || (brain.status & ORGAN_ROBOT)))
						continue

					// Remove anyone not made of silicon or doesn't have a cranial implant.
					mobs_to_message.Remove(filteree)
		for(var/mob/actor in mobs_to_message)
			to_chat(actor, "<font size=[narrate_size]><span class='[narrate_style]'>[narrate_text]</span></font>")
