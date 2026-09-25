/datum/component/skill/cooking

/datum/component/skill/cooking/Initialize(level)
	. = ..()
	RegisterSignal(parent, COMSIG_GET_BUTCHERING_MODIFIERS, PROC_REF(modify_butchering), override = TRUE)

/datum/component/skill/cooking/Destroy(force)
	UnregisterSignal(parent, COMSIG_GET_BUTCHERING_MODIFIERS)
	return ..()

/datum/component/skill/cooking/proc/modify_butchering(owner, mob/living/simple_animal/target, base_meat_amount, butchering_bonus)
	SIGNAL_HANDLER
	if (skill_level <= SKILL_LEVEL_UNFAMILIAR)
		return

	to_chat(owner, SPAN_NOTICE("Your skill with cooking lets you harvest more parts."))
	var/skill_difference = skill_level - SKILL_LEVEL_UNFAMILIAR
	*base_meat_amount = *base_meat_amount + skill_difference
	if (skill_level >= SKILL_LEVEL_PROFESSIONAL)
		*butchering_bonus = *butchering_bonus + skill_difference
