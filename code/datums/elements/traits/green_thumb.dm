/// Element used by the Green Thumb quirk to improve plant harvesting yield and speed.
/datum/element/green_thumb
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY

	/// Bonus yield added when harvesting plants.
	var/bonus_yield = 1
	/// Harvest do-after reduction.
	var/harvest_speedup = 0.5 SECONDS

/datum/element/green_thumb/Attach(datum/target)
	. = ..()
	RegisterSignal(target, COMSIG_PLANT_HARVESTER, PROC_REF(modify_yield))

/datum/element/green_thumb/Detach(datum/target)
	UnregisterSignal(target, COMSIG_PLANT_HARVESTER)
	return ..()

/datum/element/green_thumb/proc/modify_yield(owner, datum/seed/plant, total_yield, cancelled, doafter)
	SIGNAL_HANDLER
	*total_yield = *total_yield + bonus_yield
	*doafter = max(0, *doafter - harvest_speedup)
