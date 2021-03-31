/decl/nanomachine_effect/blood_regen
	name = "Hemoglobin-Plasma Inciter"
	desc = "Load the nanomachines with programming that encourages the bone marrow to produce more hemoglobin and plasma for the blood supply."

	use_nanomachine_in_check = FALSE

/decl/nanomachine_effect/blood_regen/do_nanomachine_effect(var/datum/nanomachine/parent, var/mob/living/carbon/human/H)
	var/missing_blood = round(H.species.blood_volume - REAGENT_VOLUME(H.vessel, /decl/reagent/blood))
	if(missing_blood > 0)
		var/regen_amount = min(missing_blood, 1.5 TIMES_SECONDS_PASSED(parent.last_process))
		H.vessel.add_reagent(/decl/reagent/blood, regen_amount)
		parent.machine_volume -= (regen_amount / 20) TIMES_SECONDS_PASSED(parent.last_process)