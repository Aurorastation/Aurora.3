/decl/nanomachine_effect
	var/name = "Nanomachine Effect"
	var/desc = "If you can see this, someone made a massive mistake! Please report this on Github."
	var/nanomachines_per_use = 0.2

/decl/nanomachine_effect/proc/check_nanomachine_effect(var/datum/nanomachine/parent, var/mob/living/carbon/human/H)
	if(parent.machine_volume < parent.safety_threshold)
		return FALSE
	parent.machine_volume -= nanomachines_per_use * ((world.time - parent.last_process) / 10)
	return TRUE

/decl/nanomachine_effect/proc/do_nanomachine_effect(var/datum/nanomachine/parent, var/mob/living/carbon/human/H)
	return