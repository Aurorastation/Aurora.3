/datum/component/skill/gardening
	var/bonus_yield_per_rank = 1
	var/harvest_speedup_per_rank = 0.333 SECONDS

/datum/component/skill/gardening/Initialize(level)
	. = ..()
	if(!parent)
		return

	RegisterSignal(parent, COMSIG_PLANT_HARVESTER, PROC_REF(modify_yield), override = TRUE)

/datum/component/skill/gardening/Destroy(force)
	if (!parent)
		return ..()

	UnregisterSignal(parent, COMSIG_PLANT_HARVESTER)
	return ..()

/datum/component/skill/gardening/proc/modify_yield(var/owner, var/datum/seed/plant, var/total_yield, var/cancelled, var/doafter)
	*total_yield = *total_yield + bonus_yield_per_rank * (skill_level - 1)
	*doafter = *doafter - harvest_speedup_per_rank * (skill_level - 1)
