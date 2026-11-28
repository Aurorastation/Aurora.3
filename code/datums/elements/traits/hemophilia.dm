/// Element used by the Hemophilia quirks to amplify bloodloss and circulatory strain.
/datum/element/hemophilia
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY

	/// Multiplier applied to standard cut bloodloss.
	var/cut_bloodloss_mult = 1.5
	/// Multiplier applied to arterial bloodloss.
	var/arterial_bloodloss_mult = 1.35
	/// Multiplier applied to heart pulse efficiency.
	var/pulse_mod_mult = 0.9
	/// Multiplier applied to minimum heart efficiency in critical condition.
	var/min_efficiency_mult = 0.9

/datum/element/hemophilia/Attach(datum/target)
	. = ..()
	RegisterSignal(target, COMSIG_HEART_BLEED_EVENT, PROC_REF(handle_bleed))
	RegisterSignal(target, COMSIG_HEART_PUMP_EVENT, PROC_REF(handle_pump))

/datum/element/hemophilia/Detach(datum/target)
	UnregisterSignal(target, COMSIG_HEART_BLEED_EVENT)
	UnregisterSignal(target, COMSIG_HEART_PUMP_EVENT)
	return ..()

/datum/element/hemophilia/proc/handle_bleed(owner, blood_volume, cut_bloodloss_modifier, arterial_bloodloss_modifier)
	SIGNAL_HANDLER
	*cut_bloodloss_modifier = *cut_bloodloss_modifier * cut_bloodloss_mult
	*arterial_bloodloss_modifier = *arterial_bloodloss_modifier * arterial_bloodloss_mult

/datum/element/hemophilia/proc/handle_pump(owner, obj/item/organ/internal/heart/heart, blood_volume, recent_pump, pulse_mod, min_efficiency)
	SIGNAL_HANDLER
	*pulse_mod = *pulse_mod * pulse_mod_mult
	*min_efficiency = *min_efficiency * min_efficiency_mult

/// Stronger variant used by Major Hemophilia.
/datum/element/hemophilia/major
	cut_bloodloss_mult = 2.0
	arterial_bloodloss_mult = 1.75
	pulse_mod_mult = 0.8
	min_efficiency_mult = 0.8

/// Beneficial variant used by Quick Clotting.
/datum/element/hemophilia/quick_clotting
	cut_bloodloss_mult = 0.75
	arterial_bloodloss_mult = 0.75
	pulse_mod_mult = 1.05
	min_efficiency_mult = 1.1
