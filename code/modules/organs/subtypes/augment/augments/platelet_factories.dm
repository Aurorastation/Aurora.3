/obj/item/organ/internal/augment/bioaug/platelet_factories
	name = "platelet factories"
	desc = "Designed for military applications, this implant massively increases the user's blood clotting factor." \
		+ "This provides an extreme resistance to arterial bleeds, effectively all but preventing exsanguination." \
		+ "This augment has a reputation for causing heart attacks and strokes at a high rate, and is usually combined with an auxiliary heart for safety."
	icon_state = "platelet_factories"
	organ_tag = BP_AUG_PLATELET_FACTORIES
	parent_organ = BP_CHEST

/obj/item/organ/internal/augment/bioaug/platelet_factories/Initialize()
	. = ..()
	if(!owner)
		return

	RegisterSignal(owner, COMSIG_HEART_PUMP_EVENT, PROC_REF(stroke_risk))
	RegisterSignal(owner, COMSIG_HEART_BLEED_EVENT, PROC_REF(reduce_bloodloss))

/obj/item/organ/internal/augment/bioaug/platelet_factories/replaced()
	. = ..()
	if(!owner)
		return

	RegisterSignal(owner, COMSIG_HEART_PUMP_EVENT, PROC_REF(stroke_risk))
	RegisterSignal(owner, COMSIG_HEART_BLEED_EVENT, PROC_REF(reduce_bloodloss))

/obj/item/organ/internal/augment/bioaug/platelet_factories/removed()
	. = ..()
	if(!owner)
		return

	UnregisterSignal(owner, COMSIG_HEART_PUMP_EVENT)
	UnregisterSignal(owner, COMSIG_HEART_BLEED_EVENT)

/obj/item/organ/internal/augment/bioaug/platelet_factories/proc/stroke_risk(var/implantee, var/obj/item/organ/internal/heart/heart, var/blood_volume, var/recent_pump, var/pulse_mod, var/min_efficiency)
	SIGNAL_HANDLER
	*min_efficiency *= 0.85
	*pulse_mod *= 0.95

/obj/item/organ/internal/augment/bioaug/platelet_factories/proc/reduce_bloodloss(var/implantee, var/blood_volume, var/cut_bloodloss_modifier, var/arterial_bloodloss_modifier)
	SIGNAL_HANDLER
	*cut_bloodloss_modifier *= 0.1
	*arterial_bloodloss_modifier *= 0.25
