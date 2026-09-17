/datum/component/skill/mechanical_engineering
	/// +%bonus damage versus Structures
	var/bonus_damage_per_rank = 0.05

/datum/component/skill/mechanical_engineering/Initialize(level)
	. = ..()
	RegisterSignal(parent, COMSIG_ATTACK_STRUCTURE, PROC_REF(modify_structure_damage), override = TRUE)
	RegisterSignal(parent, COMSIG_GET_MECH_WELD_MODIFIERS, PROC_REF(modify_mech_weld), override = TRUE)

/datum/component/skill/mechanical_engineering/Destroy(force)
	UnregisterSignal(parent, COMSIG_ATTACK_STRUCTURE)
	UnregisterSignal(parent, COMSIG_GET_MECH_WELD_MODIFIERS)
	return ..()

/datum/component/skill/mechanical_engineering/proc/modify_structure_damage(owner, obj/structure/target, damage)
	SIGNAL_HANDLER
	if (skill_level == SKILL_LEVEL_UNFAMILIAR)
		return

	if (prob(20))
		// Give the player some feedback that the skill is providing a damage bonus, but no need to spam the chat.
		to_chat(owner, SPAN_NOTICE("Your attack exploits a structural weakness of \the [target]"))

	*damage = *damage * (1 + bonus_damage_per_rank * (skill_level))

/datum/component/skill/mechanical_engineering/proc/modify_mech_weld(mob/owner, obj/item/mech_component/mech_part, do_after_time, repair_value)
	SIGNAL_HANDLER
	if (skill_level == SKILL_LEVEL_UNFAMILIAR)
		return

	var/effective_skill = skill_level - 1
	to_chat(owner, SPAN_NOTICE("Your skill with mechanical engineering makes repairing \the [mech_part] easier."))
	*do_after_time = *do_after_time * (1 - 0.25 * effective_skill)
	*repair_value = *repair_value * skill_level
