/decl/nanomachine_effect/muscle_clamp
	name = "Muscle Clamp"
	desc = "Some of the nanomachines will fuse themselves with the muscles supporting the body, allowing people unused to normal-to-high gravity to function normally."

	has_chem_effect = TRUE
	nanomachines_per_use = 0.1

/decl/nanomachine_effect/muscle_clamp/do_nanomachine_effect(var/datum/nanomachine/parent, var/mob/living/carbon/human/H)
	H.add_chemical_effect(CE_RMT)