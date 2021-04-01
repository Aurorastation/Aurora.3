/decl/nanomachine_effect
	var/name = "Nanomachine Effect"
	var/desc = "If you can see this, someone made a massive mistake! Please report this on Github."

	var/program_capacity_usage = 1 // how many programming slots this occupies

	var/has_process_effect = TRUE
	var/has_chem_effect = FALSE

	var/nanomachines_per_use = 0.2

/decl/nanomachine_effect/proc/check_nanomachine_effect(var/datum/nanomachine/parent, var/mob/living/carbon/human/H)
	if(parent.machine_volume < parent.safety_threshold)
		return FALSE
	parent.deterioration += nanomachines_per_use
	return TRUE

/decl/nanomachine_effect/proc/do_nanomachine_effect(var/datum/nanomachine/parent, var/mob/living/carbon/human/H)
	return

/decl/nanomachine_effect/proc/add_effect(var/datum/nanomachine/parent)
	return

/decl/nanomachine_effect/proc/remove_effect(var/datum/nanomachine/parent)
	return