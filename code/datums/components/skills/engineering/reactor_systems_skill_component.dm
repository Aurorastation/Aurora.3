/datum/component/skill/reactor_systems

/datum/component/skill/reactor_systems/Initialize()
	. = ..()
	if (!parent)
		return

	RegisterSignal(parent, COMSIG_USE_REACTOR_COMPUTER, PROC_REF(use_reactor_computer), override = TRUE)

/datum/component/skill/reactor_systems/Destroy(force)
	if (!parent)
		return ..()

	UnregisterSignal(parent, COMSIG_USE_REACTOR_COMPUTER)
	return ..()

/datum/component/skill/reactor_systems/proc/use_reactor_computer(mob/user, cancelled)
	SIGNAL_HANDLER
	if (skill_level >= SKILL_LEVEL_TRAINED)
		return

	*cancelled = TRUE
	to_chat(user, SPAN_WARNING("You must have at least Rank 3 \"Trained\" in the Reactor Systems skill in order to use this machine."))
