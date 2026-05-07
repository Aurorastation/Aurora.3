/datum/component/skill/carousing
	/// The amount of bonus liver efficiency per bought rank of the Carousing skill
	var/filter_strength_mod_per_rank = 0.05

/datum/component/skill/carousing/Initialize(level)
	. = ..()
	if (!parent)
		return

	RegisterSignal(parent, COMSIG_LIVER_FILTER_EVENT, PROC_REF(modify_liver))

/datum/component/skill/carousing/Destroy(force)
	if (!parent)
		return ..()

	UnregisterSignal(parent, COMSIG_LIVER_FILTER_EVENT)
	return ..()

/datum/component/skill/carousing/proc/modify_liver(owner, filter_effect, filter_strength, toxin_healing_rate, canceled)
	SIGNAL_HANDLER
	*filter_strength = *filter_strength * (1 + (skill_level - 1) * filter_strength_mod_per_rank)
