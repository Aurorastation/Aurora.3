/obj/item/organ/internal/augment/bioaug/auxiliary_heart
	name = "auxiliary heart"
	desc = "Intended for soldiers and the elderly, the auxiliary heart is a small secondary heart implanted below the original." \
		+ "Should the original heart shut down, the secondary heart will activate to help keep the user alive until the original can be restarted." \
		+ "This doesn't work if the original heart is completely destroyed, as there needs to be a reasonably intact cardiovascular system."
	icon_state = "auxiliary_heart"
	organ_tag = BP_AUG_AUX_HEART
	parent_organ = BP_CHEST

/obj/item/organ/internal/augment/bioaug/auxiliary_heart/Initialize()
	. = ..()
	if(!owner)
		return

	RegisterSignal(owner, COMSIG_HEART_PUMP_EVENT, PROC_REF(stabilize_circulation))

/obj/item/organ/internal/augment/bioaug/auxiliary_heart/replaced()
	. = ..()
	if(!owner)
		return

	RegisterSignal(owner, COMSIG_HEART_PUMP_EVENT, PROC_REF(stabilize_circulation))

/obj/item/organ/internal/augment/bioaug/auxiliary_heart/removed()
	. = ..()
	if(!owner)
		return

	UnregisterSignal(owner, COMSIG_HEART_PUMP_EVENT)

/obj/item/organ/internal/augment/bioaug/auxiliary_heart/proc/stabilize_circulation(var/implantee, var/obj/item/organ/internal/heart/heart, var/blood_volume, var/recent_pump, var/pulse_mod, var/min_efficiency)
	SIGNAL_HANDLER
	*min_efficiency *= 1.5
	*blood_volume += 2.5 // This doesn't affect actual blood volume, only the "effective" volume used for calculating thresholds.
