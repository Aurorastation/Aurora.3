/**
 * Component used for the Tenacity skill. Ranks placed in this skill affect how long a character can survive in critical condition before permanently dying.
 * It does not make them any tougher to actual combat damage.
 **/
/datum/component/skill/tenacity
	/**
	 * Bonus to a character's "minimum heart efficiency" per rank in this skill, which determines the floor of how effective a character's blood volume transfers oxygen when the heart isn't beating correctly.
	 * This only has an affect on a character that is both in crit, and not receiving CPR.
	 **/
	var/bonus_min_efficiency_per_rank = 0.1

	/**
	 * A character's "effective blood volume" per crit threshold calculation is increased by this amount per rank in the skill.
	 * It's a rather small amount since Brainmed's balancing is really delicate.
	 **/
	var/bonus_effective_bv_per_rank = 1.25

	/**
	 * Bonus to a character's "heart efficiency" per rank in this skill, which is used to calculate a character's effective blood volume.
	 * This factors into the percentage thresholds of blood loss at which a character's rate of dying changes.
	 * Also a very small amount, since Brainmed balancing is quite delicate.
	 **/
	var/bonus_pulse_mod_per_rank = 0.05

	/// How much of a modifier to a character's bleed resistance is provided by this component.
	var/bonus_bleed_resist_per_rank = 0.075

	/// How much of a modifier to a character's Arterial bleed resistance is provided by this component.
	var/bonus_arterial_resist_per_rank = 0.0375

/datum/component/skill/tenacity/Initialize()
	. = ..()
	if (!parent)
		return

	RegisterSignal(parent, COMSIG_HEART_PUMP_EVENT, PROC_REF(stabilize_circulation))
	RegisterSignal(parent, COMSIG_HEART_BLEED_EVENT, PROC_REF(reduce_bloodloss))

/datum/component/skill/tenacity/Destroy()
	if (!parent)
		return ..()

	UnregisterSignal(parent, COMSIG_HEART_PUMP_EVENT)
	UnregisterSignal(parent, COMSIG_HEART_BLEED_EVENT)
	return ..()

/datum/component/skill/tenacity/proc/stabilize_circulation(owner, obj/item/organ/internal/heart/heart, blood_volume, recent_pump, pulse_mod, min_efficiency)
	SIGNAL_HANDLER
	// Bonus per this skill starts at rank 2 rather than 1, they simply won't have this component at rank 1.
	var/offset_skill = skill_level - 1

	*min_efficiency = *min_efficiency * (1 + (bonus_min_efficiency_per_rank * offset_skill))
	*blood_volume = *blood_volume + (bonus_effective_bv_per_rank * offset_skill)
	*pulse_mod = *pulse_mod * (1 + (bonus_pulse_mod_per_rank * offset_skill))

/datum/component/skill/tenacity/proc/reduce_bloodloss(owner, blood_volume, cut_bloodloss_modifier, arterial_bloodloss_modifier)
	SIGNAL_HANDLER
	// Bonus per this skill starts at rank 2 rather than 1, they simply won't have this component at rank 1.
	var/offset_skill = skill_level - 1

	*cut_bloodloss_modifier = *cut_bloodloss_modifier * (1 - (offset_skill * bonus_bleed_resist_per_rank))
	*arterial_bloodloss_modifier = *arterial_bloodloss_modifier * (1 - (offset_skill * bonus_arterial_resist_per_rank))
