/// Element used by the Frail quirk to reduce effective mass and combat effectiveness.
/datum/element/frail
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY

	/// Multiplier applied to effective mass for lifting, hauling, and traversal.
	var/effective_mass_mult = 0.75
	/// Multiplier applied to melee weapon hit power.
	var/melee_power_mult = 0.8
	/// Flat percent penalty added to unarmed miss chance and subtracted from opponent miss chance.
	var/unarmed_miss_penalty = 6
	/// Flat percent penalty subtracted from unarmed block chance and added to opponent block chance.
	var/unarmed_block_penalty = 6
	/// Flat percent penalty applied to unarmed push/disarm offense and defense.
	var/unarmed_disarm_penalty = 6

/datum/element/frail/Attach(datum/target)
	. = ..()
	RegisterSignal(target, COMSIG_GET_EFFECTIVE_MASS, PROC_REF(modify_effective_mass))
	RegisterSignal(target, COMSIG_APPLY_HIT_EFFECT, PROC_REF(modify_hit_effect))
	RegisterSignal(target, COMSIG_UNARMED_HARM_ATTACKER, PROC_REF(handle_harm_attack))
	RegisterSignal(target, COMSIG_UNARMED_HARM_DEFENDER, PROC_REF(handle_harm_defend))
	RegisterSignal(target, COMSIG_UNARMED_DISARM_ATTACKER, PROC_REF(handle_disarm_attack))
	RegisterSignal(target, COMSIG_UNARMED_DISARM_DEFENDER, PROC_REF(handle_disarm_defend))

/datum/element/frail/Detach(datum/target)
	UnregisterSignal(target, COMSIG_GET_EFFECTIVE_MASS)
	UnregisterSignal(target, COMSIG_APPLY_HIT_EFFECT)
	UnregisterSignal(target, COMSIG_UNARMED_HARM_ATTACKER)
	UnregisterSignal(target, COMSIG_UNARMED_HARM_DEFENDER)
	UnregisterSignal(target, COMSIG_UNARMED_DISARM_ATTACKER)
	UnregisterSignal(target, COMSIG_UNARMED_DISARM_DEFENDER)
	return ..()

/datum/element/frail/proc/modify_effective_mass(atom/movable/owner, effective_mass)
	SIGNAL_HANDLER
	*effective_mass = *effective_mass * effective_mass_mult

/datum/element/frail/proc/modify_hit_effect(owner, mob/living/target, obj/item/weapon, power, hit_zone)
	SIGNAL_HANDLER
	*power = *power * melee_power_mult

/datum/element/frail/proc/handle_harm_attack(mob/attacker, mob/defender, attacker_skill_level, miss_chance, rand_damage, block_chance)
	SIGNAL_HANDLER
	*miss_chance = *miss_chance + unarmed_miss_penalty
	*block_chance = *block_chance - unarmed_block_penalty

/datum/element/frail/proc/handle_harm_defend(mob/defender, mob/attacker, defender_skill_level, miss_chance, rand_damage, block_chance)
	SIGNAL_HANDLER
	*miss_chance = *miss_chance - unarmed_miss_penalty
	*block_chance = *block_chance + unarmed_block_penalty

/datum/element/frail/proc/handle_disarm_attack(mob/attacker, mob/defender, attacker_skill_level, disarm_cost, push_chance, disarm_chance)
	SIGNAL_HANDLER
	*push_chance = *push_chance - unarmed_disarm_penalty
	*disarm_chance = *disarm_chance - unarmed_disarm_penalty

/datum/element/frail/proc/handle_disarm_defend(mob/defender, mob/attacker, defender_skill_level, disarm_cost, push_chance, disarm_chance)
	SIGNAL_HANDLER
	*push_chance = *push_chance + unarmed_disarm_penalty
	*disarm_chance = *disarm_chance + unarmed_disarm_penalty

/// Beneficial variant used by Athletic.
/datum/element/frail/athletic
	effective_mass_mult = 1.2
	melee_power_mult = 1.1
	unarmed_miss_penalty = -4
	unarmed_block_penalty = -4
	unarmed_disarm_penalty = -4
