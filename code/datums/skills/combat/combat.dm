/*
	All of the combat skills in this file are meant to be presented to the players as a "Bonus" to certain aspects of combat. However,
	factually they are actually a penalty to combat skills for anyone not in Security. This lets us have better balancing levers against antags,
	giving non-security leeway in being allowed to fight antags since they will be mechanically far weaker than actual security. Players can then be encouraged,
	rather than discouraged from picking a rifle up off the floor to fight mercs, since they get hit with a huge accuracy penalty when using it for not being security.

	Players are much happier anyways if you tell them something provides a bonus if they invest in it, even if the baseline before the bonus was less than what they had before.
	A lot like the "Rested Experience Effect" in video game design.

	As a general rule of thumb, having rank 3 in a combat skill is equivalent to "Vanilla" stats. No penalties, no bonuses.
	Rank 1 and 2 give penalties to combat characteristics. Rank 4; which isn't accessible to crew and will come in a later PR via implants/modifiers,
	instead provides a bonus to combat characteristics. All 3 combat skills and their relevant checks are also influenced by the Morale component,
	which provides up to an equivalent +/- 0.5 ranks in combat skills depending on how much positive or negative morale has been accumulated.
																																				*/
/singleton/skill/melee_combat
	name = "Melee Combat"
	description = "Melee Combat represents your training in close-quarters fighting, both unarmed and with melee weapons. " \
		+ "Higher ranks improve your unarmed accuracy, defense, and disarm resistance, unlock weapon parries and disarming strikes, and increase melee weapon damage."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have rarely, if ever, fought someone in your life, and have no training with melee weapons.<br>" \
			+ " - You are 4% more likely to miss when attempting to punch anywhere not the torso, 4% less likely to block unarmed attacks, and enemies are 4% more likely to block yours.<br>" \
			+ " - Your melee weapon attacks deal <b>20% less damage</b>.<br>" \
			+ " - You have a <b>20% chance</b> to overextend melee weapon swings on Harm intent, cancelling the swing and leaving you briefly off-balance.<br>" \
			+ " - Landing 12 strikes or sparring on a punching bag warms you up for <b>10 minutes</b> (+3 morale, halved overextension chance; stacks twice).",
		SKILL_LEVEL_FAMILIAR = "You have some experience throwing punches and swinging weapons. You are no stranger to a close-quarters fight, though anyone with real training is likely to overwhelm you.<br>" \
			+ " - You are 2% more likely to miss when attempting to punch anywhere not the torso, 2% less likely to block unarmed attacks, and enemies are 2% more likely to block yours.<br>" \
			+ " - Your melee weapon attacks deal <b>10% less damage</b>.<br>" \
			+ " - You have a <b>10% chance</b> to overextend melee weapon swings on Harm intent.<br>" \
			+ " - Landing 12 strikes or sparring on a punching bag warms you up for <b>15 minutes</b> (+3 morale, halved overextension chance; stacks twice).",
		SKILL_LEVEL_TRAINED = "You have been trained, whether by being in the military, taking close-quarters-combat classes, or through experience, to fight effectively with fists or melee weapons.<br>" \
			+ " - You suffer no unarmed maluses, no melee damage penalty, and never overextend swings.<br>" \
			+ " - Holding a melee weapon on Harm or Grab intent grants a <b>10% chance</b> to parry incoming melee weapon attacks.<br>" \
			+ " - Attacking with a melee weapon on Disarm intent has a <b>25% chance</b> to knock a held item from your target's hand (6s cooldown).<br>" \
			+ " - Landing 12 strikes or sparring warms you up for <b>20 minutes</b> (+3 morale, +5% parry chance; stacks twice).",
		SKILL_LEVEL_PROFESSIONAL = "You are a seasoned close-quarters combatant with years of formal martial training or real-world brawling and bladework.<br>" \
			+ " - Your unarmed strikes are 2% more accurate, you are 2% more likely to block unarmed attacks, and enemies are 2% less likely to block yours.<br>" \
			+ " - Your melee weapon attacks deal <b>10% more damage</b>.<br>" \
			+ " - Holding a melee weapon on Harm or Grab intent grants a <b>20% chance</b> to parry incoming melee weapon attacks.<br>" \
			+ " - <b>Riposte:</b> Parrying while on Harm intent automatically retaliates with your held weapon (10s cooldown).<br>" \
			+ " - Attacking with a melee weapon on Disarm intent has a <b>40% chance</b> to knock a held item from your target's hand (6s cooldown).<br>" \
			+ " - Landing 12 strikes or sparring warms you up for <b>25 minutes</b> (+3 morale, +5% parry chance; stacks twice)."
	)
	category = /singleton/skill_category/combat
	subcategory = SKILL_SUBCATEGORY_MELEE
	required = TRUE
	component_type = MELEE_COMBAT_SKILL_COMPONENT

/singleton/skill/firearms
	name = "Firearms"
	description = "Firearms represents your training in using all forms of ranged weapons. Having a high rank in in this skill provides bonuses to accuracy when shooting."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	category = /singleton/skill_category/combat
	subcategory = SKILL_SUBCATEGORY_RANGED
	required = TRUE
	component_type = FIREARMS_SKILL_COMPONENT
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have little-to-no knowledge of how firearms work at all, getting unsteadied and inaccurate quickly.<br>" \
			+ " - Firearms you shoot have a 30-degree spread-angle increase when unsteadied (45 degrees for non-energy), and count as <b>1 tile further</b>.<br>" \
			+ " - You can fire <b>three normal shots</b> before becoming unsteadied for <b>4.5 seconds</b>; heavy-recoil guns jolt harder while unsteadied.<br>" \
			+ " - You have a <b>30% chance</b> of fumbling safeties, firing modes, or scopes (<b>which can hurt your eye</b>), a <b>15%–30% chance</b> to drop magazines when unloading, and a <b>20% chance</b> to fumble clearing jams (+5% jam chance).<br>" \
			+ " - Staying still for 1 second stabilizes for two penalty-free shots. Firing 18 shots warms you up for <b>10 minutes</b> (stacks twice).",
		SKILL_LEVEL_FAMILIAR = "You have fired a gun once or twice in your life, but are by no means fully trained. At least you know how to not shoot yourself in the foot or get scope-eye.<br>" \
			+ " - Firearms you shoot have a 30-degree spread-angle increase when unsteadied (45 degrees for non-energy), and count as <b>0.5 tiles further</b>.<br>" \
			+ " - You can fire <b>five normal shots</b> before becoming unsteadied for <b>2.5 seconds</b>.<br>" \
			+ " - You have a <b>15% chance</b> of fumbling safeties, firing modes, or scopes.<br>" \
			+ " - Staying still for 1 second stabilizes for two penalty-free shots. Firing 18 shots warms you up for <b>15 minutes</b> (stacks twice).",
		SKILL_LEVEL_TRAINED = "You have both training and actual experience with firearms, equivalent to military, police, or armed security service.<br>" \
			+ " - You suffer no skill penalties, never fumble or become unsteadied, clear jams <b>twice as fast</b>, reload faster, and suffer reduced dual-wielding penalties.<br>" \
			+ " - Scoping or staying still while wielding a gun on Harm intent for 5 seconds grants <b>Focused Aim</b> (-15° spread, 0.5 tiles closer on your next shot; 45s cooldown), and you get <b>Last round! / Empty!</b> alerts.<br>" \
			+ " - You're warmed up for <b>20 minutes</b> after firing 18 shots, gaining +3 morale points (stacks twice for +6).",
		SKILL_LEVEL_PROFESSIONAL = "You have many years of combat marksmanship experience, such as special forces, SWAT marksmen, or hardened mercenaries.<br>" \
			+ " - Firearms count as <b>0.5 tiles closer</b>, and stabilizing for 1 second grants two shots at <b>1 tile closer</b> with <b>-30° spread</b>.<br>" \
			+ " - <b>Snap-Shot:</b> Running on Harm intent for 5 seconds primes your next shot with <b>-15° spread</b> (45s cooldown). <b>Focused Aim</b> (5s stationary on Harm intent, 45s cooldown) grants <b>1.5 tiles closer</b> and <b>-30° spread</b>.<br>" \
			+ " - <b>Tap-Rack-Bang:</b> You clear any jam in a single action, halve jam chances, quick-load magazines with no delay, and greatly reduce dual-wielding penalties.<br>" \
			+ " - You're warmed up for <b>25 minutes</b> after firing 18 shots, gaining a <b>55%–65% chance</b> of boosted accuracy and +3 to +7 morale."
	)

/singleton/skill/leadership
	name = "Leadership"
	description = "Leadership represents a characters skill with inspiring others. Having ranks in this skill grants access to the \"Deliver Speech\" action. Which can be used to give a morale modifier either in an area, or to a single person. " \
		+ "Additional ranks increase the morale modifier provided."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	category = /singleton/skill_category/combat
	subcategory = SKILL_SUBCATEGORY_SUPPORT
	component_type = LEADERSHIP_SKILL_COMPONENT
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have no skill with motivational speeches.",
		SKILL_LEVEL_FAMILIAR = "You gain the \"Deliver Speech\" ability, which provides +3.333 morale points to recipients (1.5x for single-target) for 15 minutes.",
		SKILL_LEVEL_TRAINED = "Your \"Deliver Speech\" provides +6.666 morale points (1.5x for single-target) for 15 minutes.<br>" \
			+ " - <b>Second Wind:</b> Single-target speeches also restore 25 stamina and reduce pain shock on the recipient (3 minute cooldown).",
		SKILL_LEVEL_PROFESSIONAL = "Your \"Deliver Speech\" provides +10 morale points (1.5x for single-target) for 15 minutes, plus Second Wind.<br>" \
			+ " - Single-target speeches also cleanse the recipient's worst instance of psychic damage.<br>" \
			+ " - <b>Stand Fast!:</b> Area speeches rally hearers for 90 seconds, suppressing morale panic penalties and reducing stamina drain by 25% (5 minute cooldown).<br>" \
			+ " - <b>Lead from the Front:</b> Conscious allies in view with your speech moodlet passively recover stamina faster."
	)
	skill_cost_map = alist(
		SKILL_LEVEL_UNFAMILIAR = 0,
		SKILL_LEVEL_FAMILIAR = 1,
		SKILL_LEVEL_TRAINED = 2,
		SKILL_LEVEL_PROFESSIONAL = 4
	)

/singleton/skill/tenacity
	name = "Tenacity"
	/// Alternate displayed name when configuring an IPC character.
	var/ipc_name = "Fault-Tolerant Architecture"
	description = "Tenacity represents a character's \"Will to Live\". It affects a character's ability to cling to life when in critical condition, effectively allowing them to live for a little bit longer before medics can reach them. " \
		+ "It does not affect a character's overall toughness and difficulty to take down in a fight, only how much time they have to be saved when they do go down.<br>" \
		+ "This skill does nothing for organic characters that do not have a heart."
	/// Alternate general description displayed when configuring an IPC character.
	var/ipc_description = "Fault-Tolerant Architecture represents a synthetic's fault-tolerance and redundancy protocols. It affects a chassis's ability to resist cascading internal failures when critically damaged, effectively allowing it to remain recoverable for a little bit longer before machinists can reach it. " \
		+ "It does not affect a character's external armor or difficulty to take down in a fight, only how resilient their internal components are to cascading failure."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	category = /singleton/skill_category/combat
	subcategory = SKILL_SUBCATEGORY_SUPPORT
	component_type = TENACITY_SKILL_COMPONENT
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have no modifiers from Tenacity.",
		SKILL_LEVEL_FAMILIAR = "You take slightly longer to die while in critical condition.<br>" \
			+ " - Your 'minimum heart efficiency' when in asystole is increased by 10%.<br>" \
			+ " - Your blood volume is counted as being +1.25% higher for the purpose of dying thresholds.<br>" \
			+ " - Your heart is 5% more effective at pumping blood.<br>" \
			+ " - You bleed out 7.5% slower from (non-arterial) wounds.<br>" \
			+ " - You bleed out 3.75% slower from severed arteries.",
		SKILL_LEVEL_TRAINED = "You take a little bit longer to die while in critical condition, and gain the <b>Self-Triage</b> action.<br>" \
			+ " - Your 'minimum heart efficiency' when in asystole is increased by 20%.<br>" \
			+ " - Your blood volume is counted as being +2.5% higher for the purpose of dying thresholds.<br>" \
			+ " - Your heart is 10% more effective at pumping blood, and resists high-pulse strain.<br>" \
			+ " - You bleed out 15% slower from (non-arterial) wounds and 7.5% slower from severed arteries.<br>" \
			+ " - You recover from shock faster and can assess your worst wounds with Self-Triage.",
		SKILL_LEVEL_PROFESSIONAL = "You take longer to die while in critical condition, and unlock <b>Last Stand</b>.<br>"\
			+ " - Your 'minimum heart efficiency' when in asystole is increased by 30%.<br>" \
			+ " - Your blood volume is counted as being +3.75% higher for the purpose of dying thresholds.<br>" \
			+ " - Your heart is 15% more effective at pumping blood, and resists high-pulse strain.<br>" \
			+ " - You bleed out 22.5% slower from (non-arterial) wounds and 11.25% slower from severed arteries.<br>" \
			+ " - <b>Last Stand:</b> Once every 15 minutes, hitting critical shock (or using Self-Triage at high shock) buys a 20-second grace window that clamps shock below blackout, stabilizes your pulse, and restores 15 stamina.",
	)
	/// Alternate skill level descriptions displayed when configuring an IPC character.
	var/alist/ipc_skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have no modifiers from Fault-Tolerant Architecture.",
		SKILL_LEVEL_FAMILIAR = "Your internal components are slightly more resistant to cascading failure.<br>" \
			+ " - The cooldown between low-integrity organ failure events is increased by 10 seconds.<br>" \
			+ " - Your positronic brain's automatic neural pathway patching cooldown is reduced by 3 seconds.<br>" \
			+ " - Your internal organs have +10% maximum wiring and electronics integrity.",
		SKILL_LEVEL_TRAINED = "Your internal components are a little bit more resistant to cascading failure, and you gain the <b>System Diagnostic</b> action.<br>" \
			+ " - The cooldown between low-integrity organ failure events is increased by 20 seconds.<br>" \
			+ " - Your positronic brain's automatic neural pathway patching cooldown is reduced by 6 seconds.<br>" \
			+ " - Your internal organs have +20% maximum wiring and electronics integrity.",
		SKILL_LEVEL_PROFESSIONAL = "Your internal components are more resistant to cascading failure, and unlock <b>Fail-Safe Kernel</b>.<br>" \
			+ " - The cooldown between low-integrity organ failure events is increased by 30 seconds.<br>" \
			+ " - Your positronic brain's automatic neural pathway patching cooldown is reduced by 9 seconds.<br>" \
			+ " - Your internal organs have +30% maximum wiring and electronics integrity.<br>" \
			+ " - <b>Fail-Safe Kernel:</b> Once every 15 minutes, an impending internal failure (or using System Diagnostic while damaged) locks out cascading organ failures for 20 seconds and triggers an immediate neural pathway patch.",
	)
	skill_cost_map = alist(
		SKILL_LEVEL_UNFAMILIAR = 0,
		SKILL_LEVEL_FAMILIAR = 1,
		SKILL_LEVEL_TRAINED = 2,
		SKILL_LEVEL_PROFESSIONAL = 4
	)
	/// Bonus to an IPC's internal organ integrity event cooldown per rank above Unfamiliar.
	var/ipc_bonus_integrity_cooldown_per_rank = 10 SECONDS
	/// Reduction to an IPC's positronic brain self-patching cooldown per rank above Unfamiliar.
	var/ipc_bonus_patching_cooldown_per_rank = 3 SECONDS
	/// Multiplier bonus to an IPC's internal organ wiring and electronics health pools per rank above Unfamiliar.
	var/ipc_bonus_internals_health_per_rank = 0.1

/singleton/skill/tenacity/get_name(datum/preferences/pref)
	var/datum/species/species = GLOB.all_species[pref?.species]
	if(species && (species.flags & IS_MECHANICAL))
		return ipc_name
	return ..()

/singleton/skill/tenacity/get_description(datum/preferences/pref)
	var/datum/species/species = GLOB.all_species[pref?.species]
	if(species && (species.flags & IS_MECHANICAL))
		return ipc_description
	return ..()

/singleton/skill/tenacity/get_skill_level_descriptions(datum/preferences/pref)
	var/datum/species/species = GLOB.all_species[pref?.species]
	if(species && (species.flags & IS_MECHANICAL))
		return ipc_skill_level_descriptions
	return ..()

/singleton/skill/tenacity/on_spawn(mob/owner, skill_level)
	if(!isipc(owner))
		return ..()

	var/mob/living/carbon/human/character = owner
	if(!istype(character))
		return

	var/offset_skill = max(skill_level - 1, 0)
	for(var/obj/item/organ/internal/machine/organ in character.internal_organs)
		organ.integrity_event_cooldown = initial(organ.integrity_event_cooldown) + (ipc_bonus_integrity_cooldown_per_rank * offset_skill)
		if(organ.wiring)
			organ.wiring.replace_health(round(initial(organ.wiring.max_wires) * (1 + (ipc_bonus_internals_health_per_rank * offset_skill)), 1))
		if(organ.electronics)
			organ.electronics.replace_health(round(initial(organ.electronics.max_integrity) * (1 + (ipc_bonus_internals_health_per_rank * offset_skill)), 1))

	var/obj/item/organ/internal/machine/posibrain/posibrain = character.internal_organs_by_name[BP_BRAIN]
	if(istype(posibrain))
		posibrain.patching_cooldown = initial(posibrain.patching_cooldown) - (ipc_bonus_patching_cooldown_per_rank * offset_skill)

