/datum/component/skill/unarmed_combat
	var/skill_diff_reference = SKILL_LEVEL_TRAINED
	/// Percent chance modifier for harm intent
	var/harm_miss_chance_per_skill_diff = 5
	/// Percent chance modifier for blocking unarmed attacks
	var/block_chance_per_skill_diff = 5
	/// Push chance modifier for disarm intent
	var/push_chance_per_skill_diff = 5
	/// Disarm chance modifier for disarm intent
	var/disarm_chance_per_skill_diff = 5

/datum/component/skill/unarmed_combat/Initialize()
	. = ..()
	if (!parent)
		return

	RegisterSignal(parent, COMSIG_UNARMED_HARM_ATTACKER, PROC_REF(handle_harm_attack), override = TRUE)
	RegisterSignal(parent, COMSIG_UNARMED_HARM_DEFENDER, PROC_REF(handle_harm_defend), override = TRUE)
	RegisterSignal(parent, COMSIG_UNARMED_DISARM_ATTACKER, PROC_REF(handle_disarm_attack), override = TRUE)
	RegisterSignal(parent, COMSIG_UNARMED_DISARM_DEFENDER, PROC_REF(handle_disarm_defend), override = TRUE)

/datum/component/skill/unarmed_combat/Destroy(force)
	if (!parent)
		return ..()

	UnregisterSignal(parent, COMSIG_UNARMED_HARM_ATTACKER)
	UnregisterSignal(parent, COMSIG_UNARMED_HARM_DEFENDER)
	UnregisterSignal(parent, COMSIG_UNARMED_DISARM_ATTACKER)
	UnregisterSignal(parent, COMSIG_UNARMED_DISARM_DEFENDER)
	return ..()

/datum/component/skill/unarmed_combat/proc/handle_harm_attack(mob/attacker, mob/defender, attacker_skill_level, miss_chance, rand_damage, block_chance)
	SIGNAL_HANDLER
	*attacker_skill_level += skill_level - 1
	*miss_chance += (skill_diff_reference - skill_level) * harm_miss_chance_per_skill_diff
	*block_chance += (skill_diff_reference - skill_level) * block_chance_per_skill_diff

/datum/component/skill/unarmed_combat/proc/handle_harm_defend(mob/defender, mob/attacker, defender_skill_level, miss_chance, rand_damage, block_chance)
	SIGNAL_HANDLER
	*defender_skill_level += skill_level - 1
	*miss_chance -= (skill_diff_reference - skill_level) * harm_miss_chance_per_skill_diff
	*block_chance -= (skill_diff_reference - skill_level) * block_chance_per_skill_diff

/datum/component/skill/unarmed_combat/proc/handle_disarm_attack(mob/attacker, mob/defender, attacker_skill_level, disarm_cost, push_chance, disarm_chance)
	SIGNAL_HANDLER
	*attacker_skill_level += skill_level - 1
	*push_chance -= (skill_diff_reference - skill_level) * push_chance_per_skill_diff
	*disarm_chance -= (skill_diff_reference - skill_level) * disarm_chance_per_skill_diff

/datum/component/skill/unarmed_combat/proc/handle_disarm_defend(mob/defender, mob/attacker, defender_skill_level, disarm_cost, push_chance, disarm_chance)
	SIGNAL_HANDLER
	*defender_skill_level += skill_level - 1
	*push_chance += (skill_diff_reference - skill_level) * push_chance_per_skill_diff
	*disarm_chance += (skill_diff_reference - skill_level) * push_chance_per_skill_diff
