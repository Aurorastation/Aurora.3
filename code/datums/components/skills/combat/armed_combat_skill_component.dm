/**
 * Component used for the Armed Combat skill. For its initial implementation, this component works by *slightly* modifying the damage dealt by attacks done with melee weapons.
 * For the majority of non-security crew, this basically means a small nerf to damage if they didn't invest any points into the skill.
 */
/datum/component/skill/armed_combat

/datum/component/skill/armed_combat/Initialize(level)
	. = ..()
	if (!parent)
		return

	RegisterSignal(parent, COMSIG_APPLY_HIT_EFFECT, PROC_REF(modify_hit_effect), override = TRUE)

/datum/component/skill/armed_combat/Destroy(force)
	if (!parent)
		return ..()

	UnregisterSignal(parent, COMSIG_APPLY_HIT_EFFECT)
	return ..()

/datum/component/skill/armed_combat/proc/modify_hit_effect(owner, mob/living/target, obj/item/weapon, power, hit_zone)
	SIGNAL_HANDLER
	*power = *power * (1 + 0.1 * (skill_level - skill_diff_reference))
