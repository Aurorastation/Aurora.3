/decl/nanomachine_effect
	var/name = "Nanomachine Effect"
	var/desc = "If you can see this, someone made a massive mistake! Please report this on Github."

	var/has_process_effect = TRUE
	var/has_chem_effect = FALSE

	var/use_nanomachine_in_check = TRUE
	var/nanomachines_per_use = 0.2

/decl/nanomachine_effect/proc/check_nanomachine_effect(var/datum/nanomachine/parent, var/mob/living/carbon/human/H)
	if(parent.machine_volume < parent.safety_threshold)
		return FALSE
	if(use_nanomachine_in_check)
		parent.machine_volume -= nanomachines_per_use TIMES_SECONDS_PASSED(parent.last_process)
	return TRUE

/decl/nanomachine_effect/proc/do_nanomachine_effect(var/datum/nanomachine/parent, var/mob/living/carbon/human/H)
	return