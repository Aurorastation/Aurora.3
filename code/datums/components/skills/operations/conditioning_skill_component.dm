/datum/component/skill/conditioning
	/**
	 * A standard humanoid can be assumed to have a "Comfortable Maximum Lift" around 1.25x their mass.
	 * Certain species have a significantly higher multiplier.
	 * But regardless of species, each purchased rank in Conditioning increases this limit by 0.25x.
	 * This is done by making the game situationally treat the character's mass as a larger number.
	 **/
	var/bonus_mass_per_rank = 0.25

/datum/component/skill/conditioning/Initialize(level)
	. = ..()
	RegisterSignal(parent, COMSIG_GET_EFFECTIVE_MASS, PROC_REF(get_mass_modifiers), override = TRUE)

/datum/component/skill/conditioning/Destroy(force)
	UnregisterSignal(parent, COMSIG_GET_EFFECTIVE_MASS)
	return ..()

/datum/component/skill/conditioning/proc/get_mass_modifiers(atom/movable/owner, effective_mass)
	SIGNAL_HANDLER
	*effective_mass = *effective_mass * (1 + (bonus_mass_per_rank * (skill_level - 1)))

/// Returns Conditioning directly as a rank, without applying species strength or equipment modifiers.
/mob/proc/get_conditioning_skill_level()
	var/conditioning_level = GET_SKILL_LEVEL(src, CONDITIONING_SKILL_COMPONENT)
	return conditioning_level ? conditioning_level : SKILL_LEVEL_UNFAMILIAR

/// Each rank above Unfamiliar reduces physical traversal times by 15% of their base value.
/mob/proc/get_conditioning_action_delay(base_delay)
	return base_delay * (1 - (0.15 * (get_conditioning_skill_level() - SKILL_LEVEL_UNFAMILIAR)))
