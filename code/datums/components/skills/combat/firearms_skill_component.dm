/**
 * Component used for the Firearms skill. Mobs with this component will have their weapon handling characteristics modified by their skill rank
 * but only if this component is present. Essentially it provides a penalty to gun accuracy at ranks below the "Skill Diff", and a bonus for ranks above it.
 */
/datum/component/skill/firearms
	/// Accuracy modifier to fired guns per point of "Skill Diff" as an "Effective increase" in tiles to the target being shot.
	var/accuracy_per_skill_diff = 0.5

	/// Dispersion modifier to fired guns as an arc-length in Degrees.
	var/dispersion = 30

	/// %chance per point of "Skill Diff" to fumble changing a weapon's safety or firing mode.
	var/gun_fumble_per_skill_diff = 15
	/// How long a character must not move from a tile to get stabilized, which assures some penalty-free shots.
	var/stabilize_delay
	var/stabilized
	var/stabilized_shots
	var/last_tile
	/// Shots until skill penalties kick in. 3 for Unfamiliar, 5 for Familiar, but unneeded for Trained and up
	var/count_to_unsteady
	var/unsteadied
	/// How long you're unsteadied for after reaching the threshold. 4 seconds for Unfamiliar, 2 for Familiar
	var/next_steady
	/** Firing practice warms you up long-term: every 18, stack up to 2 warmup tiers lasting for a duration & reducing penalties
	 *The 18 isn't random, it's between the common ammo capacities of 15 -> 20 shots. Trained only gets morale from warmups as they
	 *are meant to be the unchanged level, but Professional gets actual accuracy buffs.
	 */
	var/count_to_warmup
	var/bonus_mins_per_rank = 5
	/// Warmup tier boost chance to be referenced in moodlet description, 55 for tier 1 and 65 for tier 2
	var/accuracy_boost_chance = 55
	/// +10m for Unskilled, +5 per rank
	var/warmup_end
	var/warmup_tier
	/// Slightly less than a Familiar Leadership buff
	var/morale_value = 3

/datum/moodlet/firearms_practice // Macros can't be multi-line, so occasional raw html for readibility
	moodlet_descriptor = SPAN_GOOD("Firing Warmup")
	initial_descriptor = "<span class='good'>You have recieved a morale modifier from practicing firing." \
	+ " You can refresh this bonus and stack it an extra time for double the duration, and a higher effect:</span>"
	var/mob/owner // To get the accuracy boost chance
	var/owner_lvl // Owner skill level, used for hiding boost_text
	var/accuracy_text = "without skill penalties"// set in warmup() to always be immediately up-to-date

/datum/moodlet/firearms_practice/Destroy(force)
	owner = null
	return ..()

/datum/moodlet/firearms_practice/get_moodlet_descriptor()
	var/boost_chance = owner.GetComponent(FIREARMS_SKILL_COMPONENT).accuracy_boost_chance
	var/boost_text = "\n\t - You have a [boost_chance]% chance of firing a shot [accuracy_text]."
	. = ..()
	if(owner_lvl >= SKILL_LEVEL_TRAINED)
		return .
	else
		if(owner_lvl >= SKILL_LEVEL_PROFESSIONAL)
			accuracy_text = "with boosted accuracy, equal to being a tile closer"
			boost_text = "\n\t - You have [boost_chance]% chance of firing a shot [accuracy_text]"
			return . += boost_text
		return . += boost_text

/datum/component/skill/firearms/Initialize(var/level = SKILL_LEVEL_UNFAMILIAR)
	. = ..()
	if (!parent)
		return

	RegisterSignal(parent, COMSIG_BEFORE_GUN_FIRE, PROC_REF(handle_accuracy), override = TRUE)
	RegisterSignal(parent, COMSIG_GUN_TOGGLE_FIRING_MODE, PROC_REF(gun_fumble), override = TRUE)
	RegisterSignal(parent, COMSIG_GUN_TOGGLE_SAFETY, PROC_REF(gun_fumble), override = TRUE)
	RegisterSignal(parent, COMSIG_GUN_SCOPE, PROC_REF(gun_fumble), override = TRUE)
	RegisterSignal(parent, COMSIG_TURF_ENTERED, PROC_REF(set_stabilize), override = TRUE)
	RegisterSignal(parent, COMSIG_GUN_FIRED, PROC_REF(warmup), override = TRUE)

/datum/component/skill/firearms/Destroy()
	if (!parent)
		return ..()

	UnregisterSignal(parent, COMSIG_BEFORE_GUN_FIRE)
	UnregisterSignal(parent, COMSIG_GUN_TOGGLE_FIRING_MODE)
	UnregisterSignal(parent, COMSIG_GUN_TOGGLE_SAFETY)
	UnregisterSignal(parent, COMSIG_TURF_ENTERED)
	UnregisterSignal(parent, COMSIG_GUN_FIRED)
	return ..()

/datum/component/skill/firearms/proc/set_stabilize(mob/user, turf/new_turf, old_loc)
	if(!istype(user.get_active_hand(), /obj/item/gun))
		return
	stabilize_delay = world.time + 1 SECOND
	if(!last_tile)
		last_tile = new_turf
	addtimer(CALLBACK(src, PROC_REF(check_stabilize), user), stabilize_delay - world.time)

/datum/component/skill/firearms/proc/check_stabilize(mob/shooter)
	if(stabilize_delay && world.time >= stabilize_delay && last_tile == shooter.loc && istype(shooter.get_active_hand(), /obj/item/gun))
		stabilized_shots = 0
		to_chat(shooter, SPAN_NOTICE("<i>You feel stable and confident for your next two shots here.</i>"))
		stabilized = TRUE
		shooter.balloon_alert(shooter, "Stabilized shots!")
		playsound(shooter, 'sound/weapons/push.ogg', 30)
		stabilize_delay = null
	last_tile = null

/datum/component/skill/firearms/proc/set_steady(mob/shooter, forced)
	if(next_steady && world.time >= next_steady || forced)
		next_steady = null
		unsteadied = FALSE
		playsound(shooter, 'sound/weapons/magazine_insert.ogg', 70)
		to_chat(shooter, SPAN_NOTICE("<i>Your grip feels steadier again.</i>"))
		shooter.balloon_alert(shooter, "Steadied shots!")

/datum/component/skill/firearms/proc/warmup(mob/shooter) // Trained and up ICly would always be steadied
	if(!stabilized && skill_level < SKILL_LEVEL_TRAINED && !unsteadied && count_to_unsteady < 5)
		count_to_unsteady++
	if(skill_level < SKILL_LEVEL_TRAINED || skill_level >= SKILL_LEVEL_PROFESSIONAL && stabilized && last_tile == shooter.loc)
		stabilized_shots++
	count_to_warmup++
	if(count_to_warmup % 18 == 0)
		var/datum/component/morale/morale_comp = shooter.GetComponent(MORALE_COMPONENT)
		if(warmup_tier < 2)
			warmup_tier++
		if(!warmup_end || warmup_tier)
			if(!morale_comp)
				return
			warmup_end = world.time + (((skill_level * bonus_mins_per_rank) + 5) * warmup_tier MINUTES) // 10m for Unfamiliar
			var/datum/moodlet/warmed_up = morale_comp.load_moodlet(/datum/moodlet/firearms_practice, morale_value)
			warmed_up.duration = abs(warmup_end - world.time)
			warmed_up.refresh_moodlet()
			for(var/datum/moodlet/firearms_practice/moodlet in morale_comp.moodlets) // Moodlets are unique, so not an actual loop
				moodlet.owner = parent
				moodlet.owner_lvl = skill_level
			if(warmup_tier == 2)
				accuracy_boost_chance = 65
				warmed_up.set_moodlet(morale_value + skill_level)
		if(warmup_tier == 2)
			var/time_left = warmup_end - world.time
			var/minutes = round((time_left - (time_left % 600))/600)
			if(skill_level < SKILL_LEVEL_TRAINED || skill_level >= SKILL_LEVEL_PROFESSIONAL)
				to_chat(shooter, SPAN_NOTICE("You feel you'll be more accurate now after warming up."))
			to_chat(shooter, "<span class='good'>You have refreshed your morale modifier from further firing:</span>" \
			+ "\n\t - worth [morale_value + 2] points" \
			+ "\n\t - remaining duration: [minutes] minutes"
			)
			if(skill_level >= SKILL_LEVEL_PROFESSIONAL)
				to_chat(shooter, "\t - a [accuracy_boost_chance]% chance of firing a shot with boosted accuracy, equal to being a tile closer, under the duration.")
			else
				if(skill_level < SKILL_LEVEL_TRAINED)
					to_chat(shooter, "\t - a [accuracy_boost_chance]% chance of firing a shot without skill penalties under the duration.")

			shooter.balloon_alert(shooter, "WARMED UP!")
		else
			var/time_left = warmup_end - world.time
			var/minutes = round((time_left - (time_left % 600))/600)
			to_chat(shooter, "\t - worth [morale_value] points" \
			+ "\n\t - remaining duration: [minutes] minutes"
			)
			if(skill_level >= SKILL_LEVEL_PROFESSIONAL)
				to_chat(shooter, "\t - [accuracy_boost_chance]% chance of firing a shot with boosted accuracy, equal to being a tile closer, under the duration.")
			else
				if(skill_level < SKILL_LEVEL_TRAINED)
					to_chat(shooter, "\t - [accuracy_boost_chance]% chance of firing a shot without skill penalties under the duration.")
				to_chat(shooter, SPAN_NOTICE("You feel you've gotten the hang of this for a while."))
			shooter.balloon_alert(shooter, "Warmed up!")
		count_to_warmup = 0

	if(stabilized && stabilized_shots == 2)
		stabilized = FALSE
		stabilized_shots = 0

	if((skill_level >= SKILL_LEVEL_FAMILIAR && count_to_unsteady == 5) || (skill_level < SKILL_LEVEL_FAMILIAR && count_to_unsteady == 3))
		unsteadied = TRUE
		count_to_unsteady = 0
		next_steady = world.time + ((4/skill_level) + 0.5) SECONDS
		addtimer(CALLBACK(src, PROC_REF(set_steady), shooter), next_steady - world.time)
		playsound(shooter, 'sound/weapons/magazine_eject.ogg', 70) // since you're out of realistically-usable ammo for a bit
		to_chat(shooter, SPAN_DANGER("<i>Your grip becomes unsteadied!</i>"))
		shooter.balloon_alert(shooter, "Unsteadied shots!")

/datum/component/skill/firearms/proc/handle_accuracy(mob/living/shooter, accuracy_decrease, dispersion_increase, obj/item/gun/bang)
	SIGNAL_HANDLER
	var/skill_diff = skill_diff_reference - skill_level
	// When stabilized, steadied, or warmed up: return before any negative skill adjustments. Ordered on reliability.
	if(last_tile && last_tile != shooter.loc)
		stabilized = FALSE
		stabilized_shots = 0
	if(stabilized) // First to go because it's the most common and contextual
		if(skill_level >= SKILL_LEVEL_PROFESSIONAL)
			*accuracy_decrease = *accuracy_decrease - 1 // +1 tile closer, equal to +2 ranks as a boon for the higher level cost
			*dispersion_increase = *dispersion_increase - dispersion // 30-degree dispersion DECREASE
		return .
	if(!unsteadied)
		return
	if(warmup_tier && world.time >= warmup_end)
		warmup_tier = 0
		warmup_end = null
		accuracy_boost_chance = 55
		to_chat(shooter, SPAN_WARNING("You feel your aim has wavered without practice."))
		return
	if((warmup_tier == 1 && prob(55)) || (warmup_tier == 2 && prob(65))) // Last to go as its effect is least common, & unpredictable
		if(skill_level < SKILL_LEVEL_TRAINED || skill_level >= SKILL_LEVEL_PROFESSIONAL)
			playsound(shooter, 'sound/weapons/ammo_load.ogg', 90) // Actually tough to notice with gun fire
			shooter.visible_message(SPAN_DANGER("[shooter] adjusts [shooter.get_pronoun("his")] angling!"),
			SPAN_DANGER("You micro-adjust for better aim before firing."))
		if(skill_level >= SKILL_LEVEL_PROFESSIONAL)
			*accuracy_decrease = *accuracy_decrease - 1
			*dispersion_increase = *dispersion_increase + dispersion * skill_diff
		return .
	// Count target as being half a tile further away from shooter per difference between a skilled professional, and shooter's skill level
	*accuracy_decrease = *accuracy_decrease + accuracy_per_skill_diff * skill_diff
	// Untrained shooters get an increased firing arc for their guns to 30 degrees.
	if(skill_level < SKILL_LEVEL_TRAINED)
		*dispersion_increase = *dispersion_increase + dispersion
		if(!istype(bang, /obj/item/gun/energy))
			*dispersion_increase += 15 // recoil

/datum/component/skill/firearms/proc/gun_fumble(mob/living/shooter, obj/item/gun/shoota, cancelled, signaltype)
	SIGNAL_HANDLER
	if(warmup_tier == 2 || skill_level >= skill_diff_reference)
		return // Trained and up will never fumble. Except if morale has anything to say about that...
	if(!prob(gun_fumble_per_skill_diff * (skill_diff_reference - skill_level)))
		return // if they pass the skill check.
	*cancelled = TRUE
	shooter.visible_message(
		SPAN_DANGER("\The [shooter] fumbles with \the [shoota]!"),
		SPAN_DANGER("You fumble with \the [shoota]!"))
	if(signaltype == COMSIG_GUN_SCOPE && skill_level < SKILL_LEVEL_FAMILIAR)
		shooter.adjustHalLoss(rand(5, 15))
		shooter.eye_blurry += 20
		shooter.visible_message(SPAN_DANGER("The scope gets in [shooter.get_pronoun("his")] eye!"), SPAN_DANGER("The scope gets in your eye!"))
