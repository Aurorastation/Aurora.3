/**
 * Component used for the Robotics skill. Like the Surgery skill, this component is used to determine which surgical procedures a character is allowed to perform on IPCs.
 * This skill does not apply to surgeries performed on "Organics", but it can allow for repairs to prosthetic limbs.
 */
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

/datum/component/skill/robotics/proc/use_mech_fab(mob/user, cancelled)
	SIGNAL_HANDLER
	if (cancelled || skill_level >= SKILL_LEVEL_TRAINED)
		return

	*cancelled = TRUE
	to_chat(user, SPAN_WARNING("You have no idea how this machine works."))
