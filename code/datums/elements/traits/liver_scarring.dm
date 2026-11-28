/// Element used by Scarred Organ: Liver to reduce toxin and reagent filtering.
/datum/element/liver_scarring
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY

	/// Multiplier applied to liver filter strength.
	var/filter_strength_mult = 0.65
	/// Multiplier applied to liver toxin healing rate.
	var/toxin_healing_mult = 0.75

/datum/element/liver_scarring/Attach(datum/target)
	. = ..()
	RegisterSignal(target, COMSIG_LIVER_FILTER_EVENT, PROC_REF(modify_liver))

/datum/element/liver_scarring/Detach(datum/target)
	UnregisterSignal(target, COMSIG_LIVER_FILTER_EVENT)
	return ..()

/datum/element/liver_scarring/proc/modify_liver(owner, filter_effect, filter_strength, toxin_healing_rate, canceled)
	SIGNAL_HANDLER
	*filter_strength = *filter_strength * filter_strength_mult
	*toxin_healing_rate = *toxin_healing_rate * toxin_healing_mult

/// Beneficial variant used by Iron Stomach.
/datum/element/liver_scarring/iron_stomach
	filter_strength_mult = 1.2
	toxin_healing_mult = 1.2

/datum/element/liver_scarring/iron_stomach/Attach(datum/target)
	. = ..()
	ADD_TRAIT(target, TRAIT_IRON_STOMACH, TRAIT_SOURCE_QUIRK)

/datum/element/liver_scarring/iron_stomach/Detach(datum/target)
	REMOVE_TRAIT(target, TRAIT_IRON_STOMACH, TRAIT_SOURCE_QUIRK)
	return ..()
