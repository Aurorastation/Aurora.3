/datum/component/skill/robotics

/datum/component/skill/robotics/Initialize()
	. = ..()
	if (!parent)
		return

	RegisterSignal(parent, COMSIG_USE_MECH_FAB, PROC_REF(use_mech_fab), override = TRUE)

/datum/component/skill/robotics/Destroy()
	if (!parent)
		return ..()

	UnregisterSignal(parent, COMSIG_USE_MECH_FAB)
	return ..()

/datum/component/skill/robotics/proc/use_mech_fab(var/mob/user, var/cancelled)
	SIGNAL_HANDLER
	if (cancelled || skill_level >= SKILL_LEVEL_TRAINED)
		return

	*cancelled = TRUE
	to_chat(user, SPAN_WARNING("You must have at least Rank 3 \"Trained\" in the Robotics skill in order to use this machine."))
