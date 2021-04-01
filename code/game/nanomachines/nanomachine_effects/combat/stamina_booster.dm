/decl/nanomachine_effect/stamina_booster
	name = "Acid Neutralizer"
	desc = "Configure the nanomachines to target lactic acid modules, lowering fatigue and granting increased stamina."

	has_process_effect = FALSE
	has_chem_effect = TRUE

	nanomachines_per_use = 0.3

/decl/nanomachine_effect/stamina_booster/do_nanomachine_effect(var/datum/nanomachine/parent, var/mob/living/carbon/human/H)
	H.add_up_to_chemical_effect(CE_ADRENALINE, 0.5)