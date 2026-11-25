/**
 * Component used for the Melee Combat skill, combining armed melee weapon handling,
 * unarmed hand-to-hand/disarm modifiers, active weapon parrying, sparring warmup,
 * and tactical disarming strikes.
 */
/datum/component/skill/melee_combat
	/// Percent chance modifier for unarmed harm intent miss chance per skill diff.
	var/harm_miss_chance_per_skill_diff = 2
	/// Percent chance modifier for blocking unarmed attacks per skill diff.
	var/block_chance_per_skill_diff = 2
	/// Push chance modifier for disarm intent per skill diff.
	var/push_chance_per_skill_diff = 2
	/// Disarm chance modifier for disarm intent per skill diff.
	var/disarm_chance_per_skill_diff = 2
	/// Multiplier modifier to melee weapon damage per skill diff.
	var/armed_damage_mod_per_skill_diff = 0.1
	/// Chance per rank below Trained to overextend a melee weapon swing on Harm intent.
	var/overextend_chance_per_skill_diff = 10
	/// Base parry chance when holding a melee weapon at Trained.
	var/base_parry_chance = 10
	/// Additional parry chance per rank above Trained.
	var/parry_chance_per_rank = 10
	/// Bonus parry chance while Sparring Warmup is active.
	var/warmup_parry_bonus = 5
	/// Base chance to disarm a target with a melee weapon on Disarm intent at Trained.
	var/disarm_strike_base_chance = 25
	/// Cooldown between tactical disarming strikes.
	var/disarm_strike_cooldown = 10 SECONDS
	var/next_disarm_strike = 0
	/// Cooldown between Professional Riposte counter-attacks on parry.
	var/riposte_cooldown = 10 SECONDS
	var/next_riposte = 0

	/// Warmup tracking (mirrors Firearms warmup).
	var/count_to_warmup = 0
	var/warmup_tier = 0
	var/warmup_end = null
	var/bonus_mins_per_rank = 5
	var/morale_value = 3

/datum/moodlet/melee_practice
	moodlet_descriptor = SPAN_GOOD("Sparring Warmup")
	initial_descriptor = SPAN_GOOD("You have received a morale modifier from close-quarters combat or sparring. Refreshing it stacks up to twice for double duration and stronger poise:")
	var/owner_lvl = SKILL_LEVEL_UNFAMILIAR

/datum/moodlet/melee_practice/get_moodlet_descriptor()
	. = ..()
	if(owner_lvl < SKILL_LEVEL_TRAINED)
		return . + "\n\t - Your chance to overextend melee weapon swings is halved."
	return . + "\n\t - Your melee weapon parry chance is increased by 5%."

/datum/component/skill/melee_combat/Initialize(level)
	. = ..()
	if (!parent)
		return

	RegisterSignal(parent, COMSIG_APPLY_HIT_EFFECT, PROC_REF(modify_hit_effect), override = TRUE)
	RegisterSignal(parent, COMSIG_MOB_ITEM_ATTACK, PROC_REF(handle_item_attack), override = TRUE)
	RegisterSignal(parent, COMSIG_HUMAN_MELEE_PARRY_CHECK, PROC_REF(handle_parry_check), override = TRUE)
	RegisterSignal(parent, COMSIG_MELEE_PRACTICE, PROC_REF(handle_practice), override = TRUE)
	RegisterSignal(parent, COMSIG_UNARMED_HARM_ATTACKER, PROC_REF(handle_harm_attack), override = TRUE)
	RegisterSignal(parent, COMSIG_UNARMED_HARM_DEFENDER, PROC_REF(handle_harm_defend), override = TRUE)
	RegisterSignal(parent, COMSIG_UNARMED_DISARM_ATTACKER, PROC_REF(handle_disarm_attack), override = TRUE)
	RegisterSignal(parent, COMSIG_UNARMED_DISARM_DEFENDER, PROC_REF(handle_disarm_defend), override = TRUE)

/datum/component/skill/melee_combat/Destroy(force)
	if (!parent)
		return ..()

	UnregisterSignal(parent, COMSIG_APPLY_HIT_EFFECT)
	UnregisterSignal(parent, COMSIG_MOB_ITEM_ATTACK)
	UnregisterSignal(parent, COMSIG_HUMAN_MELEE_PARRY_CHECK)
	UnregisterSignal(parent, COMSIG_MELEE_PRACTICE)
	UnregisterSignal(parent, COMSIG_UNARMED_HARM_ATTACKER)
	UnregisterSignal(parent, COMSIG_UNARMED_HARM_DEFENDER)
	UnregisterSignal(parent, COMSIG_UNARMED_DISARM_ATTACKER)
	UnregisterSignal(parent, COMSIG_UNARMED_DISARM_DEFENDER)
	return ..()

/datum/component/skill/melee_combat/proc/check_warmup_expiry(mob/living/owner)
	if(warmup_tier && warmup_end && world.time >= warmup_end)
		warmup_tier = 0
		warmup_end = null
		to_chat(owner, SPAN_WARNING("You feel your close-quarters rhythm has faded."))

/datum/component/skill/melee_combat/proc/handle_practice(mob/living/owner)
	SIGNAL_HANDLER
	record_warmup(owner)

/datum/component/skill/melee_combat/proc/record_warmup(mob/living/owner)
	if(!isliving(owner))
		return
	check_warmup_expiry(owner)
	count_to_warmup++
	if(count_to_warmup % 12 != 0)
		return

	var/datum/component/morale/morale_comp = owner.GetComponent(MORALE_COMPONENT)
	if(warmup_tier < 2)
		warmup_tier++

	warmup_end = world.time + (((skill_level * bonus_mins_per_rank) + 5) * warmup_tier MINUTES)
	var/datum/moodlet/warmed_up = morale_comp ? morale_comp.load_moodlet(/datum/moodlet/melee_practice, morale_value) : null
	warmed_up?.duration = abs(warmup_end - world.time)
	warmed_up?.refresh_moodlet()

	for(var/datum/moodlet/melee_practice/moodlet in morale_comp?.moodlets)
		moodlet.owner_lvl = skill_level
	if(warmup_tier == 2)
		warmed_up?.set_moodlet(morale_value + skill_level)

	var/time_left = warmup_end - world.time
	var/minutes = round((time_left - (time_left % 600)) / 600)
	if(morale_comp)
		to_chat(owner, "[SPAN_GOOD("You feel warmed up from close-quarters combat:")]" \
			+ "\n\t - worth [warmup_tier == 2 ? morale_value + skill_level : morale_value] morale points" \
			+ "\n\t - remaining duration: [minutes] minutes")
	owner.balloon_alert(owner, warmup_tier == 2 ? "WARMED UP!" : "Warmed up!")
	count_to_warmup = 0

/datum/component/skill/melee_combat/proc/handle_item_attack(mob/living/user, mob/living/target_mob, mob/living/attacker, obj/item/weapon)
	SIGNAL_HANDLER
	if(!istype(weapon) || weapon.force <= 0 || istype(weapon, /obj/item/gun))
		return
	if(!isliving(target_mob) || target_mob == user || user.a_intent != I_HURT)
		return
	check_warmup_expiry(user)
	if(skill_level >= skill_diff_reference)
		return

	var/fumble_chance = (skill_diff_reference - skill_level) * overextend_chance_per_skill_diff
	if(warmup_tier >= 1)
		fumble_chance *= 0.5
	if(!prob(fumble_chance))
		return

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN * 1.5)
	user.do_attack_animation(target_mob, used_item = weapon)
	playsound(user, 'sound/weapons/punchmiss2.ogg', 50, 1, -1)
	user.visible_message(
		SPAN_DANGER("[user] overextends [user.get_pronoun("his")] swing with \the [weapon], stumbling slightly!"),
		SPAN_DANGER("You overextend your swing with \the [weapon], leaving yourself off-balance!")
	)
	user.balloon_alert(user, "Overextended!")
	return COMPONENT_CANCEL_ATTACK_CHAIN

/datum/component/skill/melee_combat/proc/handle_parry_check(mob/living/carbon/human/defender, obj/item/incoming_weapon, mob/living/attacker, parried)
	SIGNAL_HANDLER
	if(!istype(defender) || attacker == defender || *parried)
		return
	if(skill_level < skill_diff_reference)
		return
	if(!(defender.a_intent in list(I_HURT, I_GRAB)) || !defender.canmove || defender.incapacitated())
		return

	check_warmup_expiry(defender)
	var/obj/item/parry_weapon = null
	for(var/obj/item/held in list(defender.get_active_hand(), defender.get_inactive_hand()))
		if(istype(held) && held.force > 0 && !istype(held, /obj/item/gun) && !istype(held, /obj/item/grab))
			parry_weapon = held
			break
	if(!parry_weapon)
		return

	var/parry_chance = base_parry_chance + (skill_level - skill_diff_reference) * parry_chance_per_rank
	if(warmup_tier >= 1)
		parry_chance += warmup_parry_bonus
	if(!prob(parry_chance))
		return

	*parried = TRUE
	playsound(defender, 'sound/weapons/bladeparry.ogg', 50, 1, -1)
	defender.visible_message(
		SPAN_WARNING("[defender] parries [attacker]'s \the [incoming_weapon] with \the [parry_weapon]!"),
		SPAN_NOTICE("You parry [attacker]'s \the [incoming_weapon] with \the [parry_weapon]!")
	)
	defender.balloon_alert(defender, "Parried!")

	if(skill_level >= SKILL_LEVEL_PROFESSIONAL && defender.a_intent == I_HURT && world.time >= next_riposte && isliving(attacker) && defender.Adjacent(attacker))
		next_riposte = world.time + riposte_cooldown
		addtimer(CALLBACK(src, PROC_REF(perform_riposte), defender, attacker, parry_weapon), 1)

/datum/component/skill/melee_combat/proc/perform_riposte(mob/living/carbon/human/defender, mob/living/attacker, obj/item/weapon)
	if(QDELETED(defender) || QDELETED(attacker) || QDELETED(weapon))
		return
	if(weapon.loc != defender || defender.a_intent != I_HURT || defender.incapacitated() || !defender.Adjacent(attacker))
		return
	var/prev_next_move = defender.next_move
	defender.visible_message(
		SPAN_DANGER("[defender] ripostes [attacker] with \the [weapon]!"),
		SPAN_DANGER("You riposte [attacker] with \the [weapon]!")
	)
	defender.balloon_alert(defender, "Riposte!")
	weapon.attack(attacker, defender, defender.zone_sel ? defender.zone_sel.selecting : BP_CHEST)
	defender.next_move = prev_next_move

/datum/component/skill/melee_combat/proc/modify_hit_effect(mob/living/owner, mob/living/target, obj/item/weapon, power, hit_zone)
	SIGNAL_HANDLER
	*power = *power * (1 + armed_damage_mod_per_skill_diff * (skill_level - skill_diff_reference))
	if(isliving(target) && target != owner)
		record_warmup(owner)

	// Tactical technique: Disarming Strike on Disarm intent with a melee weapon at Trained+
	if(skill_level >= skill_diff_reference && owner.a_intent == I_DISARM && ishuman(target) && target != owner)
		if(istype(weapon) && weapon.force >= 5 && !istype(weapon, /obj/item/gun) && world.time >= next_disarm_strike)
			var/mob/living/carbon/human/H = target
			var/obj/item/target_held = H.get_active_hand() || H.get_inactive_hand()
			var/strike_chance = disarm_strike_base_chance + (skill_level - skill_diff_reference) * 15
			if(target_held && !istype(target_held, /obj/item/grab) && prob(strike_chance))
				next_disarm_strike = world.time + disarm_strike_cooldown
				H.drop_from_inventory(target_held)
				playsound(H, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
				owner.visible_message(
					SPAN_DANGER("[owner] hooks \the [weapon] and knocks \the [target_held] from [H]'s grasp!"),
					SPAN_NOTICE("You hook \the [weapon] and knock \the [target_held] from [H]'s grasp!")
				)
				owner.balloon_alert(owner, "Disarmed!")

/datum/component/skill/melee_combat/proc/handle_harm_attack(mob/attacker, mob/defender, attacker_skill_level, miss_chance, rand_damage, block_chance)
	SIGNAL_HANDLER
	*attacker_skill_level = *attacker_skill_level + skill_level - 1
	*miss_chance = *miss_chance + (skill_diff_reference - skill_level) * harm_miss_chance_per_skill_diff
	*block_chance = *block_chance + (skill_diff_reference - skill_level) * block_chance_per_skill_diff
	if(isliving(defender) && defender != attacker)
		record_warmup(attacker)

/datum/component/skill/melee_combat/proc/handle_harm_defend(mob/defender, mob/attacker, defender_skill_level, miss_chance, rand_damage, block_chance)
	SIGNAL_HANDLER
	*defender_skill_level = *defender_skill_level + skill_level - 1
	*miss_chance = *miss_chance - (skill_diff_reference - skill_level) * harm_miss_chance_per_skill_diff
	*block_chance = *block_chance - (skill_diff_reference - skill_level) * block_chance_per_skill_diff

/datum/component/skill/melee_combat/proc/handle_disarm_attack(mob/attacker, mob/defender, attacker_skill_level, disarm_cost, push_chance, disarm_chance)
	SIGNAL_HANDLER
	*attacker_skill_level = *attacker_skill_level + skill_level - 1
	*push_chance = *push_chance - (skill_diff_reference - skill_level) * push_chance_per_skill_diff
	*disarm_chance = *disarm_chance - (skill_diff_reference - skill_level) * disarm_chance_per_skill_diff

/datum/component/skill/melee_combat/proc/handle_disarm_defend(mob/defender, mob/attacker, defender_skill_level, disarm_cost, push_chance, disarm_chance)
	SIGNAL_HANDLER
	*defender_skill_level = *defender_skill_level + skill_level - 1
	*push_chance = *push_chance + (skill_diff_reference - skill_level) * push_chance_per_skill_diff
	*disarm_chance = *disarm_chance + (skill_diff_reference - skill_level) * disarm_chance_per_skill_diff
