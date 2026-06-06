/datum/component/skill/xenobiology
	/// +%bonus damage versus Space Fauna (EG: Space Carp, Space Bears, Asteroid Worms, Gnats, Etc.)
	var/bonus_damage_per_rank = 0.05

/datum/component/skill/xenobiology/Initialize(level)
	. = ..()
	RegisterSignal(parent, COMSIG_APPLY_HIT_EFFECT, PROC_REF(modify_hit_effect), override = TRUE)
	RegisterSignal(parent, COMSIG_GET_BUTCHERING_MODIFIERS, PROC_REF(modify_butchering), override = TRUE)

/datum/component/skill/xenobiology/Destroy(force)
	UnregisterSignal(parent, COMSIG_APPLY_HIT_EFFECT)
	UnregisterSignal(parent, COMSIG_GET_BUTCHERING_MODIFIERS)
	return ..()

/datum/component/skill/xenobiology/proc/modify_hit_effect(owner, mob/living/target, obj/item/weapon, power, hit_zone)
	SIGNAL_HANDLER
	if (target.ckey || !HAS_TRAIT(target, TRAIT_MC_SPACE_FAUNA))
		return

	if (prob(20))
		// Give the player some feedback that the skill is providing a damage bonus, but no need to spam the chat.
		to_chat(owner, SPAN_NOTICE("Your attack exploits a weak spot on [target]"))

	*power = *power * (1 + bonus_damage_per_rank * (skill_level))

/datum/component/skill/xenobiology/proc/modify_butchering(owner, mob/living/simple_animal/target, base_meat_amount, butchering_bonus)
	SIGNAL_HANDLER
	if (!HAS_TRAIT(target, TRAIT_MC_SPACE_FAUNA) || skill_level <= SKILL_LEVEL_UNFAMILIAR)
		return

	to_chat(owner, SPAN_NOTICE("Your familiarity with [target] lets you harvest more parts."))
	var/skill_difference = skill_level - SKILL_LEVEL_UNFAMILIAR
	*base_meat_amount = *base_meat_amount + skill_difference
	if (skill_level >= SKILL_LEVEL_PROFESSIONAL)
		*butchering_bonus = *butchering_bonus + skill_difference
