/// Base element for permanent limb-injury quirks that apply broad skill-signal penalties.
/datum/element/limb_injury
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY

	/// Multiplier applied to effective mass for lifting, hauling, and traversal.
	var/effective_mass_mult = 1
	/// Multiplier applied to melee weapon hit power.
	var/melee_power_mult = 1

/datum/element/limb_injury/Attach(datum/target)
	. = ..()
	RegisterSignal(target, COMSIG_GET_EFFECTIVE_MASS, PROC_REF(modify_effective_mass))
	RegisterSignal(target, COMSIG_APPLY_HIT_EFFECT, PROC_REF(modify_hit_effect))

/datum/element/limb_injury/Detach(datum/target)
	UnregisterSignal(target, COMSIG_GET_EFFECTIVE_MASS)
	UnregisterSignal(target, COMSIG_APPLY_HIT_EFFECT)
	return ..()

/datum/element/limb_injury/proc/modify_effective_mass(atom/movable/owner, effective_mass)
	SIGNAL_HANDLER
	*effective_mass = *effective_mass * effective_mass_mult

/datum/element/limb_injury/proc/modify_hit_effect(owner, mob/living/target, obj/item/weapon, power, hit_zone)
	SIGNAL_HANDLER
	*power = *power * melee_power_mult

/// Upper-limb (arm/hand) permanent injury penalties across combat, firearms, surgery, engineering, and harvesting.
/datum/element/limb_injury/upper
	effective_mass_mult = 0.85
	melee_power_mult = 0.8
	var/unarmed_miss_penalty = 5
	var/unarmed_block_penalty = 5
	var/unarmed_disarm_penalty = 5
	var/accuracy_penalty = 1.0
	var/dispersion_penalty = 15
	var/safety_fumble_chance = 10
	var/surgery_success_mult = 0.9
	var/surgery_duration_mult = 1.15
	var/structure_damage_mult = 0.8
	var/mech_weld_time_mult = 1.25
	var/harvest_delay = 0.5 SECONDS

/datum/element/limb_injury/upper/Attach(datum/target)
	. = ..()
	RegisterSignal(target, COMSIG_UNARMED_HARM_ATTACKER, PROC_REF(handle_harm_attack))
	RegisterSignal(target, COMSIG_UNARMED_DISARM_ATTACKER, PROC_REF(handle_disarm_attack))
	RegisterSignal(target, COMSIG_BEFORE_GUN_FIRE, PROC_REF(handle_gun_accuracy))
	RegisterSignal(target, COMSIG_GUN_TOGGLE_FIRING_MODE, PROC_REF(handle_safety_fumble))
	RegisterSignal(target, COMSIG_GET_SURGERY_SUCCESS_MODIFIERS, PROC_REF(handle_surgery_modifiers))
	RegisterSignal(target, COMSIG_ATTACK_STRUCTURE, PROC_REF(modify_structure_damage))
	RegisterSignal(target, COMSIG_GET_MECH_WELD_MODIFIERS, PROC_REF(modify_mech_weld))
	RegisterSignal(target, COMSIG_PLANT_HARVESTER, PROC_REF(modify_harvest))

/datum/element/limb_injury/upper/Detach(datum/target)
	UnregisterSignal(target, COMSIG_UNARMED_HARM_ATTACKER)
	UnregisterSignal(target, COMSIG_UNARMED_DISARM_ATTACKER)
	UnregisterSignal(target, COMSIG_BEFORE_GUN_FIRE)
	UnregisterSignal(target, COMSIG_GUN_TOGGLE_FIRING_MODE)
	UnregisterSignal(target, COMSIG_GET_SURGERY_SUCCESS_MODIFIERS)
	UnregisterSignal(target, COMSIG_ATTACK_STRUCTURE)
	UnregisterSignal(target, COMSIG_GET_MECH_WELD_MODIFIERS)
	UnregisterSignal(target, COMSIG_PLANT_HARVESTER)
	return ..()

/datum/element/limb_injury/upper/proc/handle_harm_attack(mob/attacker, mob/defender, attacker_skill_level, miss_chance, rand_damage, block_chance)
	SIGNAL_HANDLER
	*miss_chance = *miss_chance + unarmed_miss_penalty
	*block_chance = *block_chance - unarmed_block_penalty

/datum/element/limb_injury/upper/proc/handle_disarm_attack(mob/attacker, mob/defender, attacker_skill_level, disarm_cost, push_chance, disarm_chance)
	SIGNAL_HANDLER
	*push_chance = *push_chance - unarmed_disarm_penalty
	*disarm_chance = *disarm_chance - unarmed_disarm_penalty

/datum/element/limb_injury/upper/proc/handle_gun_accuracy(mob/shooter, accuracy_decrease, dispersion_increase)
	SIGNAL_HANDLER
	*accuracy_decrease = *accuracy_decrease + accuracy_penalty
	*dispersion_increase = *dispersion_increase + dispersion_penalty

/datum/element/limb_injury/upper/proc/handle_safety_fumble(mob/shooter, obj/item/gun/shoota, cancelled)
	SIGNAL_HANDLER
	if(cancelled || !prob(safety_fumble_chance))
		return
	*cancelled = TRUE

/datum/element/limb_injury/upper/proc/handle_surgery_modifiers(mob/living/user, mob/living/carbon/target, success_rate, duration)
	SIGNAL_HANDLER
	*success_rate = *success_rate * surgery_success_mult
	*duration = *duration * surgery_duration_mult

/datum/element/limb_injury/upper/proc/modify_structure_damage(owner, obj/structure/target, damage)
	SIGNAL_HANDLER
	*damage = *damage * structure_damage_mult

/datum/element/limb_injury/upper/proc/modify_mech_weld(mob/owner, obj/item/mech_component/mech_part, do_after_time, repair_value)
	SIGNAL_HANDLER
	*do_after_time = *do_after_time * mech_weld_time_mult

/datum/element/limb_injury/upper/proc/modify_harvest(owner, datum/seed/plant, total_yield, cancelled, doafter)
	SIGNAL_HANDLER
	*doafter = *doafter + harvest_delay

/datum/element/limb_injury/upper/arm
	effective_mass_mult = 0.85
	melee_power_mult = 0.8
	unarmed_miss_penalty = 6
	unarmed_block_penalty = 6
	unarmed_disarm_penalty = 6

/datum/element/limb_injury/upper/hand
	effective_mass_mult = 0.9
	melee_power_mult = 0.85
	unarmed_miss_penalty = 4
	unarmed_block_penalty = 4
	unarmed_disarm_penalty = 4
	accuracy_penalty = 1.5
	dispersion_penalty = 20
	safety_fumble_chance = 15
	surgery_success_mult = 0.85
	surgery_duration_mult = 1.25
	structure_damage_mult = 0.85

/// Lower-limb (leg/foot) permanent injury penalties across carrying capacity and combat stability.
/datum/element/limb_injury/lower
	effective_mass_mult = 0.75
	melee_power_mult = 0.85
	var/unarmed_miss_penalty = 6
	var/unarmed_block_penalty = 6
	var/unarmed_disarm_penalty = 6

/datum/element/limb_injury/lower/Attach(datum/target)
	. = ..()
	RegisterSignal(target, COMSIG_UNARMED_HARM_DEFENDER, PROC_REF(handle_harm_defend))
	RegisterSignal(target, COMSIG_UNARMED_DISARM_DEFENDER, PROC_REF(handle_disarm_defend))

/datum/element/limb_injury/lower/Detach(datum/target)
	UnregisterSignal(target, COMSIG_UNARMED_HARM_DEFENDER)
	UnregisterSignal(target, COMSIG_UNARMED_DISARM_DEFENDER)
	return ..()

/datum/element/limb_injury/lower/proc/handle_harm_defend(mob/defender, mob/attacker, defender_skill_level, miss_chance, rand_damage, block_chance)
	SIGNAL_HANDLER
	*miss_chance = *miss_chance - unarmed_miss_penalty
	*block_chance = *block_chance + unarmed_block_penalty

/datum/element/limb_injury/lower/proc/handle_disarm_defend(mob/defender, mob/attacker, defender_skill_level, disarm_cost, push_chance, disarm_chance)
	SIGNAL_HANDLER
	*push_chance = *push_chance + unarmed_disarm_penalty
	*disarm_chance = *disarm_chance + unarmed_disarm_penalty

/datum/element/limb_injury/lower/leg
	effective_mass_mult = 0.75
	melee_power_mult = 0.85
	unarmed_miss_penalty = 6
	unarmed_block_penalty = 6
	unarmed_disarm_penalty = 6

/datum/element/limb_injury/lower/foot
	effective_mass_mult = 0.8
	melee_power_mult = 0.9
	unarmed_miss_penalty = 4
	unarmed_block_penalty = 4
	unarmed_disarm_penalty = 4
