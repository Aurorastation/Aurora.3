/**
 * This macro is absolutely required to handle recalculating the morale_ratio and updating UI effects,
 * whenever any morale modifier is updated, added, or removed.
 *
 * Failing to use this macro whenever any private value changes causes the component
 * to no longer provide mathematically correct results from its internal calculation.
 *
 * At the core of the morale component is a Hyperbolic Tangent function, which is calculated in advance so as to eliminate the need for
 * expensive recalculating every time it is called to modify checks.
 */
#define UPDATE_MORALE \
	morale_ratio = ftanh(beta_value * (morale_points + phi_value)); \
	morale_ui.icon_state = ((morale_ratio > -0.01 && morale_ratio < 0.01) ? "morale_hidden" : "morale" + "[round(morale_ratio * 4) + 5]"); \
	morale_ui.update_icon();

/// Screen space movable object for the morale component.
/atom/movable/screen/morale
	name = "morale"
	icon = 'icons/mob/screen/morale_ui.dmi'
	icon_state = "morale_hidden"
	screen_loc = UI_MORALE_LOCATION

/atom/movable/screen/morale/Click(location, control, params)
	if (!istype(usr))
		return

	var/datum/component/morale/morale_comp = usr.GetComponent(MORALE_COMPONENT)
	if (!morale_comp)
		qdel(src) // whoops the attached mob doesn't have a morale component.
		return

	// This section is Unlinted since we need to access a same-file PRIVATE var
	// and for whatever ungodly reason strongdmm doesn't allow same-file to touch VAR_PRIVATE
	var/morale_percent = UNLINT(morale_comp.morale_ratio * 100)
	if (!morale_percent)
		to_chat(usr, SPAN_NOTICE("You currently have no morale modifiers."))
		return

	to_chat(usr, SPAN_NOTICE("Your current morale bonus is [morale_percent]%"))

	if (!length(morale_comp.moodlets))
		return

	to_chat(usr, SPAN_NOTICE("You have the following morale modifiers: "))
	for (var/datum/moodlet/moodlet as anything in morale_comp.moodlets)
		to_chat(usr, moodlet.get_moodlet_descriptor())

/**
 * Having a Morale Component allows a character to receive and benefit from Moodlets, providing a variety of buffs(or debuffs) depending on the total morale points.
 * This component acts as both proof a mob can be affected by morale, as well as a method of tracking the effects of morale on each system.
 */
/datum/component/morale

	/**
	 * The set of all moodlets associated with this Morale Component. These are also tightly controlled in their initialization, but are not private.
	 * That doesn't mean you need to be setting them anywhere other than in moodlets.dm.
	 * load_moodlet() is your best bet for "Add or Get" a moodlet, and is 100% of the time what you want to use if you're trying to make sure someone has a moodlet.
	 */
	var/list/datum/moodlet/moodlets = list()

	/**
	 * The current sum total of morale_points. This var is intentionally private because it is self-managed by the component, and should never be set directly.
	 * If you need the contents of this var outside of the component, you MUST use get_morale_points().
	 */
	VAR_PRIVATE/morale_points = 0.0 // Positive and negative floating points are allowed.

	/**
	 * The current "Morale Ratio" calculated in advance as the Hyperbolic Tangent of morale_points. This var is self-managed by the component and should never be set directly.
	 * This gets updated whenever morale_points are changed, and is used by the Morale Component to handle fast calculations of its various effects.
	 * If you need the contents of this var outside of the component, you MUST use get_morale_ratio().
	 *
	 * morale_ratio is NEVER to be set by anything outside of the component.
	 */
	VAR_PRIVATE/morale_ratio = 0.0 // Positive and negative floating points are allowed.

	/**
	 * The "B" constant in the equation for y = Atanh(B(x + C)).
	 * This constant is not arbitrary, it was carefully selected such that the equation will give "75% of its effect" at 50 morale points, and "96% of its effect" at 100 morale.
	 * This allows for there to be an effect of diminishing returns for chasing ever increasingly more morale points, while front-loading the bulk of the effects at a specific amount of moodlets.
	 * Since the effects of morale are a "Logistic Curve", "100% of the morale effect" is only ever obtained at +INFINITY.
	 * This also goes for the opposite direction, morale penalties max out only at -INFINITY points, but get to "75% of the penalty effect" at -50 points.
	 *
	 * The actual "Effects" of morale are to be per-signal, and are defined by the A value in y = Atanh(B(x + C))
	 * This is private for a reason, if you need to change it, do so by using set_beta_value(), which will also make the component recalculate its morale ratio.
	 */
	VAR_PRIVATE/beta_value = 0.0195

	/**
	 * The "C" constant in the equation for y = Atanh(B(x + C))
	 * This constant acts like a "permanent" moodlet with a morale bonus equal to what its set as.
	 * Please set this extremely sparingly. You won't necessarily break anything by setting it, since the system will tolerate any number between +/- Infinity.
	 * But making a habit of bypassing the morale system like this can easily trivialize it.
	 */
	VAR_PRIVATE/phi_value = 0.0

	/**
	 * UI element stored for the morale component,
	 * which is attached to the screen of a client controlling a character with this component.
	 * Its lifecycle is strictly controlled by this component, do not under any circumstances touch it from outside this file.
	 *
	 * You have been warned.
	 */
	VAR_PRIVATE/atom/movable/screen/morale/morale_ui

	// By default, all of these values are roughly equivalent to "up to half" a skill rank.
	/// How much this morale component contributes to signal based unarmed values.
	var/unarmed_chance_contribution = 2.5

	/// How many effective ranks of unarmed combat skill this morale component can contribute
	var/unarmed_rank_contribution = 0.5

	/**
	 * The maximum possible panic chance from negative morale point sums.
	 * Since negative moodlets are unique to psychic damage, the effects of psychically induced panic are uniquely stronger than simply being unskilled.
	 */
	var/panic_chance_ceiling = 30.0

	/// The maximum possible positive or negative contribution to surgery success chances from morale modifiers.
	var/surgery_success_contribution = 15.0

	/// The maximum possible positive or negative contribution to firearm dispersion (in degrees)
	var/firearm_dispersion_contribution = 15.0

	/// The maximum possible positive or negative contribution to firearm accuracy (in tiles of effective distance)
	var/firearm_accuracy_contribution = 1.5

	/// The maximum possible positive or negative contribution to melee damage (x100 to convert this to +%)
	var/melee_damage_contribution = 0.075

	/**
	 * The maximum possible contribution to mech move delays (other than forwards motion).
	 * This applies to strafing, turning, and reverse movements.
	 */
	var/mech_move_delay_contribution = 0.75

	/// The maximum possible positive or negative percent modifier to crafting speed.
	var/crafting_speed_contribution = 0.25

	/**
	 * The maximum possible contribution to plants harvested from morale.
	 * Note that yield is rounded to integer amounts.
	 * This will give +1 yield after morale reaches at least 75%, and -1 yield at -75%
	 */
	var/plant_yield_contribution = 1.35

	/// The maximum possible positive or negative percent modifier to plant harvesting speed
	var/harvest_speed_contribution = 0.25

	/// The maximum possible positive or negative (percentage as decimal) contribution to surgery speed from morale modifiers.
	var/surgery_speed_contribution = 0.1

	/// The maximum possible positive or negative percent modifier to plant sampling damage.
	var/sample_damage_contribution = 0.125

	/// The maximum possible positive or negative modifier to plant sample exhaustion chance.
	var/sample_exhaust_contribution = 10.0

	/// The maximum possible positive or negative percent modifier to gene centrifuge degradation.
	var/gene_degradation_contribution = 0.15

	/// The maximum possible positive or negative modifier to gene splicing failure chance.
	var/gene_fail_chance_contribution = 10.0

	/// The maximum possible positive or negative modifier to somatoray trigger probability.
	var/somatoray_prob_contribution = 10.0

	/// The maximum possible positive or negative percent modifier to vine damage and escape/evasion chances.
	var/vine_damage_contribution = 0.125
	var/vine_escape_contribution = 10.0

	/// The maximum possible positive or negative modifier to flora hazard avoidance and wild seed salvage chances.
	var/flora_hazard_avoid_contribution = 20.0

	/**
	 * The increase in effective morale ratio for psychic damage. This makes it so that the psi-panic condition
	 * has a greater effect on penalizing skills than positive morale gives bonuses to them.
	 */
	var/psi_panic_effect_modifier = 3.0

/// Returns the current percentage effect of morale, expressed as a floating point number between -1.0 and 1.0
/datum/component/morale/proc/get_morale_ratio()
	return morale_ratio

/// Returns the current number of morale points (which is not linearly related to the effects of morale).
/datum/component/morale/proc/get_morale_points()
	return morale_points

/// Adds (or removes) morale points to the component, then forces a recalculation of morale effects.
/datum/component/morale/proc/add_morale_points(input)
	morale_points += input
	UPDATE_MORALE

/// Returns the "B" constant for the morale component's internal equation.
/datum/component/morale/proc/get_beta_value()
	return beta_value

/// Sets the "B" constant for the morale component's internal equation, then forces a recalculation of morale effects.
/datum/component/morale/proc/set_beta_value(input)
	beta_value = input
	UPDATE_MORALE

/// Returns the "C" constant for the morale component's internal equation.
/datum/component/morale/proc/get_phi_value()
	return phi_value

/// Sets the "C" constant for the morale component's internal equation, then forces a recalculation of morale effects.
/datum/component/morale/proc/set_phi_value(input)
	phi_value = input
	UPDATE_MORALE

/**
 * Your one-stop-shop for making moodlets. This proc returns the pre-existing moodlet of a given type.
 * If it doesn't already exist, then one will be created.
 */
/datum/component/morale/proc/load_moodlet(datum/moodlet/moodlet_type, set_points)
	RETURN_TYPE(moodlet_type)
	var/datum/moodlet/loaded_moodlet = locate(moodlet_type) in moodlets
	if (!loaded_moodlet)
		loaded_moodlet = new moodlet_type(src, set_points)
		moodlets.Add(loaded_moodlet)
		START_PROCESSING(SSprocessing, src)
		return loaded_moodlet

	if (set_points) loaded_moodlet.set_moodlet(set_points)
	return loaded_moodlet

/datum/component/morale/Initialize()
	. = ..()
	if (!parent)
		return

	// Generate the morale UI in advance.
	morale_ui = new /atom/movable/screen/morale()
	// Separate from the general morale interactions, this one is special for generating the morale HUD elements.
	RegisterSignal(parent, COMSIG_MOB_UPDATE_VISION, PROC_REF(get_morale_hud), override = TRUE)

	// Behold my wall of RegisterSignal()
	RegisterSignal(parent, COMSIG_APPLY_HIT_EFFECT, PROC_REF(modify_hit_effect), override = TRUE)
	RegisterSignal(parent, COMSIG_BEFORE_GUN_FIRE, PROC_REF(handle_accuracy), override = TRUE)
	RegisterSignal(parent, COMSIG_GUN_TOGGLE_FIRING_MODE, PROC_REF(safety_fumble), override = TRUE)
	RegisterSignal(parent, COMSIG_UNARMED_HARM_ATTACKER, PROC_REF(handle_harm_attack), override = TRUE)
	RegisterSignal(parent, COMSIG_UNARMED_HARM_DEFENDER, PROC_REF(handle_harm_defend), override = TRUE)
	RegisterSignal(parent, COMSIG_UNARMED_DISARM_ATTACKER, PROC_REF(handle_disarm_attack), override = TRUE)
	RegisterSignal(parent, COMSIG_UNARMED_DISARM_DEFENDER, PROC_REF(handle_disarm_defend), override = TRUE)
	RegisterSignal(parent, COMSIG_MECH_MOVE_WASD, PROC_REF(handle_user_move), override = TRUE)
	RegisterSignal(parent, COMSIG_MECH_MOVE_STRAFE, PROC_REF(handle_user_strafe), override = TRUE)
	RegisterSignal(parent, COMSIG_MECH_TOGGLE_POWER, PROC_REF(handle_mech_toggle_power), override = TRUE)
	RegisterSignal(parent, COMSIG_GET_SURGERY_SUCCESS_MODIFIERS, PROC_REF(handle_surgery_modifiers), override = TRUE)
	RegisterSignal(parent, COMSIG_GET_CRAFTING_MODIFIERS, PROC_REF(handle_crafting_speed), override = TRUE)
	RegisterSignal(parent, COMSIG_PLANT_HARVESTER, PROC_REF(modify_yield), override = TRUE)
	RegisterSignal(parent, COMSIG_PLANT_SAMPLER, PROC_REF(handle_plant_sampler), override = TRUE)
	RegisterSignal(parent, COMSIG_BOTANY_EXTRACT_GENE, PROC_REF(handle_extract_gene), override = TRUE)
	RegisterSignal(parent, COMSIG_BOTANY_APPLY_GENE, PROC_REF(handle_apply_gene), override = TRUE)
	RegisterSignal(parent, COMSIG_BOTANY_SOMATORAY, PROC_REF(handle_somatoray), override = TRUE)
	RegisterSignal(parent, COMSIG_BOTANY_VINE_INTERACT, PROC_REF(handle_vine_interact), override = TRUE)
	RegisterSignal(parent, COMSIG_BOTANY_FLORA_HANDLING, PROC_REF(handle_flora_handling), override = TRUE)
	UPDATE_MORALE

/datum/component/morale/Destroy()
	QDEL_LIST_FORCE(moodlets)
	if (!parent)
		return ..()

	// Cleanup morale HUD elements.
	UnregisterSignal(parent, COMSIG_MOB_UPDATE_VISION)
	QDEL_NULL(morale_ui)

	// Behold my wall of UnregisterSignal()
	UnregisterSignal(parent, COMSIG_APPLY_HIT_EFFECT)
	UnregisterSignal(parent, COMSIG_BEFORE_GUN_FIRE)
	UnregisterSignal(parent, COMSIG_GUN_TOGGLE_FIRING_MODE)
	UnregisterSignal(parent, COMSIG_UNARMED_HARM_ATTACKER)
	UnregisterSignal(parent, COMSIG_UNARMED_HARM_DEFENDER)
	UnregisterSignal(parent, COMSIG_UNARMED_DISARM_ATTACKER)
	UnregisterSignal(parent, COMSIG_UNARMED_DISARM_DEFENDER)
	UnregisterSignal(parent, COMSIG_MECH_MOVE_WASD)
	UnregisterSignal(parent, COMSIG_MECH_MOVE_STRAFE)
	UnregisterSignal(parent, COMSIG_MECH_TOGGLE_POWER)
	UnregisterSignal(parent, COMSIG_GET_SURGERY_SUCCESS_MODIFIERS)
	UnregisterSignal(parent, COMSIG_GET_CRAFTING_MODIFIERS)
	UnregisterSignal(parent, COMSIG_PLANT_HARVESTER)
	UnregisterSignal(parent, COMSIG_PLANT_SAMPLER)
	UnregisterSignal(parent, COMSIG_BOTANY_EXTRACT_GENE)
	UnregisterSignal(parent, COMSIG_BOTANY_APPLY_GENE)
	UnregisterSignal(parent, COMSIG_BOTANY_SOMATORAY)
	UnregisterSignal(parent, COMSIG_BOTANY_VINE_INTERACT)
	UnregisterSignal(parent, COMSIG_BOTANY_FLORA_HANDLING)
	return ..()

/**
 * Morale components begin processing whenever they become the owner of any moodlets.
 * The Morale component is solely responsible for handling the lifetime of its owned moodlets,
 * since it must be responsible for maintaining the mathematical integrity of its internal equations.
 *
 * The component will also stop processing when it has no moodlets to handle, and start processing again once it gains any.
 */
/datum/component/morale/process(seconds_per_tick)
	if (!length(moodlets))
		return PROCESS_KILL

	var/current_time = REALTIMEOFDAY
	for (var/datum/moodlet/moodlet as anything in moodlets)
		if (moodlet.time_to_die > current_time || QDELING(moodlet))
			continue

		add_morale_points(-moodlet.get_morale_modifier())
		qdel(moodlet, TRUE)
		moodlets.Remove(moodlet)

/*
						AND NOW THE GIANT WALL OF SIGNAL HANDLERS
					LOOK UPON MY SIGNALS HANDLERS YE MIGHTY AND DESPAIR

			Remember how I said low morale will exclusively come from psychic damage?
	The Night has shed a tear to tell you of fear and of sorrow and pain that you shall never outgrow.
		Oh yea, the negative morale effects will be !!!FUN!!! in exchange for being extremely rare

			Otherwise, morale effects are generally equivalent to "up to half a skill rank"
					for a large variety of numerical effects related to skills.
																											*/
/datum/component/morale/proc/get_morale_hud(mob/living/carbon/human/user)
	SIGNAL_HANDLER
	if (QDELING(src))
		return // draw nothing.

	user.client?.screen |= morale_ui

/// Slightly increases melee damage with positive morale, Psi-panic from negative morale reduces it.
/datum/component/morale/proc/modify_hit_effect(owner, mob/living/target, obj/item/weapon, power, hit_zone)
	SIGNAL_HANDLER
	*power = *power * (1 + (melee_damage_contribution * morale_ratio))

/// Increases gun accuracy with positive morale. Psi-panic from negative morale makes it much worse.
/datum/component/morale/proc/handle_accuracy(mob/shooter, accuracy_decrease, dispersion_increase)
	SIGNAL_HANDLER
	var/effective_morale = morale_ratio
	if (effective_morale < 0)
		effective_morale *= psi_panic_effect_modifier
		if (prob(25)) // Don't spam it for every shot
			to_chat(shooter, SPAN_WARNING("The pressure on your mind makes it hard to aim properly..."))

	*accuracy_decrease = *accuracy_decrease - firearm_accuracy_contribution * effective_morale
	*dispersion_increase = *dispersion_increase - firearm_dispersion_contribution * effective_morale

/// Psi-panic from negative morale can cause a shooter to fail to disengage a gun's safety. This includes the automatic disengage when firing on harm intent.
/datum/component/morale/proc/safety_fumble(mob/shooter, obj/item/gun/shoota, cancelled)
	SIGNAL_HANDLER
	// Up to 50% chance to fumble a safety when in a psionically-induced panic.
	if (cancelled || morale_points >= 0 || !prob(floor(5 * panic_chance_ceiling * -morale_ratio)))
		return

	*cancelled = TRUE
	shooter.visible_message(
		SPAN_DANGER("\The [shooter] fumbles with \the [shoota]'s safety in a blind panic!"),
		SPAN_DANGER("You fumble with \the [shoota]'s safety in a blind panic!"))

/// Positive morale slightly improves unarmed hit/block chances. Psi-panic from negative morale reduces it instead.
/datum/component/morale/proc/handle_harm_attack(mob/attacker, mob/defender, attacker_skill_level, miss_chance, rand_damage, block_chance)
	SIGNAL_HANDLER
	*attacker_skill_level = *attacker_skill_level + (unarmed_rank_contribution * morale_ratio)
	*miss_chance = *miss_chance - unarmed_chance_contribution * morale_ratio
	*block_chance = *block_chance - unarmed_chance_contribution * morale_ratio

/// Positive morale slightly improves unarmed hit/block chances. Psi-panic from negative morale reduces it instead.
/datum/component/morale/proc/handle_harm_defend(mob/defender, mob/attacker, defender_skill_level, miss_chance, rand_damage, block_chance)
	SIGNAL_HANDLER
	*defender_skill_level = *defender_skill_level - (unarmed_rank_contribution * morale_ratio)
	*miss_chance = *miss_chance + unarmed_chance_contribution * morale_ratio
	*block_chance = *block_chance + unarmed_chance_contribution * morale_ratio

/// Positive morale slightly improves unarmed hit/block chances. Psi-panic from negative morale reduces it instead.
/datum/component/morale/proc/handle_disarm_attack(mob/attacker, mob/defender, attacker_skill_level, disarm_cost, push_chance, disarm_chance)
	SIGNAL_HANDLER
	*attacker_skill_level = *attacker_skill_level + (unarmed_rank_contribution * morale_ratio)
	*push_chance = *push_chance - unarmed_chance_contribution * morale_ratio
	*disarm_chance = *disarm_chance - unarmed_chance_contribution * morale_ratio

/// Positive morale slightly improves unarmed hit/block chances. Psi-panic from negative morale reduces it instead.
/datum/component/morale/proc/handle_disarm_defend(mob/defender, mob/attacker, defender_skill_level, disarm_cost, push_chance, disarm_chance)
	SIGNAL_HANDLER
	*defender_skill_level = *defender_skill_level + (unarmed_rank_contribution * morale_ratio)
	*push_chance = *push_chance + unarmed_chance_contribution * morale_ratio
	*disarm_chance = *disarm_chance + unarmed_chance_contribution * morale_ratio

/// Positive morale improves mech handling characteristics, negative morale both worsens them, and gives a chance to scramble movement inputs.
/datum/component/morale/proc/handle_user_move(mob/living/user, direction, delay_modifier)
	SIGNAL_HANDLER
	if (parent != user)
		return

	if (morale_points < 0 && prob(floor(panic_chance_ceiling * -morale_ratio)))
		user.visible_message(
			SPAN_DANGER("\The [user] fumbles with their mech's controls in a blind panic!"),
			SPAN_DANGER("You fumble with your mech's controls in a blind panic!"))
		*direction = pick(GLOB.cardinals)

	if (direction == NORTH)
		return

	var/effective_morale = morale_ratio
	if (effective_morale < 0)
		effective_morale *= psi_panic_effect_modifier
		if (prob(5)) // Don't spam it on every move
			to_chat(user, SPAN_WARNING("The pressure on your mind makes it hard to focus on piloting the mech..."))

	*delay_modifier = *delay_modifier - mech_move_delay_contribution * effective_morale

/// Positive morale improves mech handling characteristics, negative morale both worsens them, and gives a chance to scramble movement inputs.
/datum/component/morale/proc/handle_user_strafe(mob/living/user, direction, delay_modifier)
	SIGNAL_HANDLER
	if (parent != user)
		return

	if (morale_points < 0 && prob(floor(panic_chance_ceiling * -morale_ratio)))
		user.visible_message(
			SPAN_DANGER("\The [user] fumbles with their mech's controls in a blind panic!"),
			SPAN_DANGER("You fumble with your mech's controls in a blind panic!"))
		*direction = angle2dir(dir2angle(direction) + 180)

	var/effective_morale = morale_ratio
	if (effective_morale < 0)
		effective_morale *= psi_panic_effect_modifier
		if (prob(5)) // Don't spam it on every move
			to_chat(user, SPAN_WARNING("The pressure on your mind makes it hard to focus on piloting the mech..."))
	*delay_modifier = *delay_modifier - mech_move_delay_contribution * effective_morale

/// The psi-panic condition from psychic damage makes it more difficult to power up a mech. No effects on this from positive morale.
/datum/component/morale/proc/handle_mech_toggle_power(mob/user, cancelled, delay)
	SIGNAL_HANDLER
	if (parent != user || cancelled || morale_points >= 0)
		return

	if (prob(floor(panic_chance_ceiling * -morale_ratio)))
		to_chat(user, SPAN_DANGER("The pressure on your mind overwhelms you completely. You can't even think to find the power switch..."))
		*cancelled = TRUE
		return

	*delay = *delay - (5 * morale_ratio) SECONDS
	to_chat(user, SPAN_WARNING("The pressure on your mind causes you to stumble in searching for the power switch..."))

/// Positive morale makes surgery easier/faster. Psi-panic from megative morale makes it much harder.
/datum/component/morale/proc/handle_surgery_modifiers(mob/living/user, mob/living/carbon/target, success_rate, duration)
	SIGNAL_HANDLER
	var/effective_morale = morale_ratio
	if (effective_morale < 0)
		effective_morale *= psi_panic_effect_modifier
		to_chat(user, SPAN_WARNING("The pressure on your mind makes it hard to focus on the surgery..."))

	*success_rate = *success_rate + surgery_success_contribution * morale_ratio
	*duration = *duration * (1 - surgery_speed_contribution * morale_ratio)

/// Positive morale makes item crafting faster. Psi-panic from negative morale makes it much slower.
/datum/component/morale/proc/handle_crafting_speed(mob/user, doafter_time)
	SIGNAL_HANDLER
	var/effective_morale = morale_ratio
	if (effective_morale < 0)
		effective_morale *= psi_panic_effect_modifier
		to_chat(user, SPAN_WARNING("The pressure on your mind makes it hard to focus on constructing..."))

	*doafter_time = *doafter_time * (1 - (crafting_speed_contribution * morale_ratio))

/// Positive morale improves plant harvesting yield/speed. Psi-panic from negative morale makes it much worse.
/datum/component/morale/proc/modify_yield(owner, datum/seed/plant, total_yield, cancelled, doafter)
	SIGNAL_HANDLER
	var/effective_morale = morale_ratio
	if (effective_morale < 0)
		effective_morale *= psi_panic_effect_modifier
		to_chat(owner, SPAN_WARNING("The pressure on your mind makes it hard to focus on harvesting the plants..."))

	*total_yield = *total_yield + plant_yield_contribution * morale_ratio
	*doafter = *doafter * (1 - (harvest_speed_contribution * morale_ratio))

/// Positive morale steadies the user's hand when taking plant cuttings. Psi-panic from negative morale makes cuttings rougher.
/datum/component/morale/proc/handle_plant_sampler(mob/user, datum/seed/plant, sample_damage, exhaust_chance, bonus_seed_chance, wild_destroy_chance)
	SIGNAL_HANDLER
	var/effective_morale = morale_ratio
	if (effective_morale < 0)
		effective_morale *= psi_panic_effect_modifier
		to_chat(user, SPAN_WARNING("The pressure on your mind makes your hands tremble as you take the cutting..."))

	if (!isnull(sample_damage))
		*sample_damage = max(1, round(*sample_damage * (1 - sample_damage_contribution * effective_morale)))
	if (!isnull(exhaust_chance))
		*exhaust_chance = clamp(*exhaust_chance - sample_exhaust_contribution * effective_morale, 0, 100)
	if (!isnull(bonus_seed_chance))
		*bonus_seed_chance = clamp(*bonus_seed_chance + sample_exhaust_contribution * effective_morale, 0, 100)
	if (!isnull(wild_destroy_chance))
		*wild_destroy_chance = clamp(*wild_destroy_chance - sample_exhaust_contribution * effective_morale, 0, 100)

/// Positive morale improves precision when operating the gene centrifuge. Psi-panic from negative morale worsens degradation.
/datum/component/morale/proc/handle_extract_gene(mob/user, obj/structure/machinery/botany/extractor/machine, degradation_increase)
	SIGNAL_HANDLER
	if (isnull(degradation_increase))
		return

	var/effective_morale = morale_ratio
	if (effective_morale < 0)
		effective_morale *= psi_panic_effect_modifier
		to_chat(user, SPAN_WARNING("The pressure on your mind makes it hard to calibrate the centrifuge..."))

	*degradation_increase = max(1, round(*degradation_increase * (1 - gene_degradation_contribution * effective_morale)))

/// Positive morale reduces gene splicing failure and decay. Psi-panic from negative morale increases failure risk.
/datum/component/morale/proc/handle_apply_gene(mob/user, datum/seed/plant, fail_chance, decay_increase, trait_retention, gas_retention)
	SIGNAL_HANDLER
	var/effective_morale = morale_ratio
	if (effective_morale < 0)
		effective_morale *= psi_panic_effect_modifier
		if (!isnull(fail_chance))
			to_chat(user, SPAN_WARNING("The pressure on your mind makes it hard to align the bioballistic delivery..."))

	if (!isnull(fail_chance))
		*fail_chance = clamp(*fail_chance - gene_fail_chance_contribution * effective_morale, 0, 100)
	if (!isnull(decay_increase))
		*decay_increase = max(1, round(*decay_increase * (1 - gene_degradation_contribution * effective_morale)))
	if (!isnull(trait_retention))
		*trait_retention = clamp(*trait_retention + 0.025 * effective_morale, 0.1, 1.0)
	if (!isnull(gas_retention))
		*gas_retention = clamp(*gas_retention + 0.025 * effective_morale, 0.1, 1.0)

/// Positive morale improves somatoray focus on trays. Psi-panic from negative morale reduces its effectiveness.
/datum/component/morale/proc/handle_somatoray(mob/firer, obj/structure/machinery/portable_atmospherics/hydroponics/tray, proc_chance, yield_boost)
	SIGNAL_HANDLER
	var/effective_morale = morale_ratio
	if (effective_morale < 0)
		effective_morale *= psi_panic_effect_modifier

	if (!isnull(proc_chance))
		*proc_chance = clamp(*proc_chance + somatoray_prob_contribution * effective_morale, 0, 100)

/// Positive morale helps clear and escape spreading vines. Psi-panic from negative morale makes entanglement harder to escape.
/datum/component/morale/proc/handle_vine_interact(mob/user, obj/effect/plant/vine, damage, escape_chance, evade_chance)
	SIGNAL_HANDLER
	var/effective_morale = morale_ratio
	if (effective_morale < 0)
		effective_morale *= psi_panic_effect_modifier
		if ((!isnull(escape_chance) || !isnull(evade_chance)) && prob(25))
			to_chat(user, SPAN_WARNING("The pressure on your mind makes it harder to untangle yourself from \the [vine]..."))

	if (!isnull(damage))
		*damage = *damage * (1 + vine_damage_contribution * effective_morale)
	if (!isnull(escape_chance))
		*escape_chance = clamp(*escape_chance + vine_escape_contribution * effective_morale, 0, 100)
	if (!isnull(evade_chance))
		*evade_chance = clamp(*evade_chance + vine_escape_contribution * effective_morale, 0, 100)

/// Positive morale improves care around hazardous flora and wild seed salvaging. Psi-panic from negative morale makes mishaps more likely.
/datum/component/morale/proc/handle_flora_handling(mob/user, datum/seed/plant, hazard_avoid_chance, salvage_seed_chance)
	SIGNAL_HANDLER
	var/effective_morale = morale_ratio
	if (effective_morale < 0)
		effective_morale *= psi_panic_effect_modifier

	if (!isnull(hazard_avoid_chance))
		*hazard_avoid_chance = clamp(*hazard_avoid_chance + flora_hazard_avoid_contribution * effective_morale, 0, 100)
	if (!isnull(salvage_seed_chance))
		*salvage_seed_chance = clamp(*salvage_seed_chance + flora_hazard_avoid_contribution * effective_morale, 0, 100)

#undef UPDATE_MORALE
