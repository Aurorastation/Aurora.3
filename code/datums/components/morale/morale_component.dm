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
	 * The "B" constant in the equation for y = Atanh(Bx + C).
	 * This constant is not arbitrary, it was carefully selected such that the equation will give "75% of its effect" at 50 morale points, and "96% of its effect" at 100 morale.
	 * This allows for there to be an effect of diminishing returns for chasing ever increasingly more morale points, while front-loading the bulk of the effects at a specific amount of moodlets.
	 * Since the effects of morale are a "Logistic Curve", "100% of the morale effect" is only ever obtained at +INFINITY.
	 * This also goes for the opposite direction, morale penalties max out only at -INFINITY points, but get to "75% of the penalty effect" at -50 points.
	 *
	 * The actual "Effects" of morale are to be per-signal, and are defined by the A value in y = Atanh(Bx + C)
	 * This is private for a reason, if you need to change it, do so by using set_beta_value(), which will also make the component recalculate its morale ratio.
	 */
	VAR_PRIVATE/beta_value = 0.0195

	// By default, all of these values are roughly equivalent to "up to half" a skill rank.
	/// How much this morale component contributes to signal based unarmed values.
	var/unarmed_chance_contribution = 2.5

	/// How many effective ranks of unarmed combat skill this morale component can contribute
	var/unarmed_rank_contribution = 0.5

	/**
	 * The maximum possible panic chance from negative morale point sums.
	 * Since negative moodlets are unique to psychic damage, the effects of psychically induced panic are uniquely stronger than simply being unskilled.
	 */
	var/panic_chance_ceiling = 10

/datum/component/morale/proc/get_morale_ratio()
	return morale_ratio

/datum/component/morale/proc/get_morale_points()
	return morale_points

/datum/component/morale/proc/add_morale_points(input)
	morale_points += input
	morale_ratio = ftanh(beta_value * morale_points)

/datum/component/morale/proc/set_beta_value(input)
	beta_value = input
	morale_ratio = ftanh(beta_value * morale_points)

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
		return loaded_moodlet

	if (set_points) loaded_moodlet.set_moodlet(set_points)
	return loaded_moodlet

/datum/component/morale/Initialize()
	. = ..()
	if (!parent)
		return

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

/datum/component/morale/Destroy()
	QDEL_LIST_FORCE(moodlets)
	if (!parent)
		return ..()

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
	return ..()

/datum/component/morale/process(seconds_per_tick)
	var/current_time = REALTIMEOFDAY
	var/list_trimmed = FALSE
	for (var/datum/moodlet/moodlet as anything in moodlets)
		if (moodlet.time_to_die < current_time || QDELING(moodlet))
			continue

		morale_points -= moodlet.get_morale_modifier()
		qdel(moodlet, TRUE)
		moodlets.Remove(moodlet)
		list_trimmed = TRUE

	if (!list_trimmed)
		return

	morale_ratio = ftanh(morale_points)

/*
						AND NOW THE GIANT WALL OF SIGNAL HANDLERS
					LOOK UPON MY SIGNALS HANDLERS YE MIGHTY AND DESPAIR

			Remember how I said low morale will exclusively come from psychic damage?
	The Night has shed a tear to tell you of fear and of sorrow and pain that you shall never outgrow.
		Oh yea, the negative morale effects will be !!!FUN!!! in exchange for being extremely rare

			Otherwise, morale effects are generally equivalent to "up to half a skill rank"
					for a large variety of numerical effects related to skills.
																											*/
/datum/component/morale/proc/modify_hit_effect(owner, mob/living/target, obj/item/weapon, power, hit_zone)
	SIGNAL_HANDLER
	*power = *power * (1 + (0.05 * morale_ratio))

/datum/component/morale/proc/handle_accuracy(mob/shooter, accuracy_decrease, dispersion_increase)
	SIGNAL_HANDLER
	*accuracy_decrease = *accuracy_decrease - morale_ratio
	*dispersion_increase = *dispersion_increase - 10 * morale_ratio

/datum/component/morale/proc/safety_fumble(mob/shooter, obj/item/gun/shoota, cancelled)
	SIGNAL_HANDLER
	// Up to 50% chance to fumble a safety when in a psionically-induced panic.
	if (cancelled || morale_points >= 0 || !prob(floor(5 * panic_chance_ceiling * -morale_ratio)))
		return

	*cancelled = TRUE
	shooter.visible_message(
		SPAN_DANGER("\The [shooter] fumbles with \the [shoota]'s safety in a blind panic!"),
		SPAN_DANGER("You fumble with \the [shoota]'s safety in a blind panic!"))

/datum/component/morale/proc/handle_harm_attack(mob/attacker, mob/defender, attacker_skill_level, miss_chance, rand_damage, block_chance)
	SIGNAL_HANDLER
	*attacker_skill_level = *attacker_skill_level + (unarmed_rank_contribution * morale_ratio)
	*miss_chance = *miss_chance - unarmed_chance_contribution * morale_ratio
	*block_chance = *block_chance - unarmed_chance_contribution * morale_ratio

/datum/component/morale/proc/handle_harm_defend(mob/defender, mob/attacker, defender_skill_level, miss_chance, rand_damage, block_chance)
	SIGNAL_HANDLER
	*defender_skill_level = *defender_skill_level - (unarmed_rank_contribution * morale_ratio)
	*miss_chance = *miss_chance + unarmed_chance_contribution * morale_ratio
	*block_chance = *block_chance + unarmed_chance_contribution * morale_ratio

/datum/component/morale/proc/handle_disarm_attack(mob/attacker, mob/defender, attacker_skill_level, disarm_cost, push_chance, disarm_chance)
	SIGNAL_HANDLER
	*attacker_skill_level = *attacker_skill_level + (unarmed_rank_contribution * morale_ratio)
	*push_chance = *push_chance - unarmed_chance_contribution * morale_ratio
	*disarm_chance = *disarm_chance - unarmed_chance_contribution * morale_ratio

/datum/component/morale/proc/handle_disarm_defend(mob/defender, mob/attacker, defender_skill_level, disarm_cost, push_chance, disarm_chance)
	SIGNAL_HANDLER
	*defender_skill_level = *defender_skill_level + (unarmed_rank_contribution * morale_ratio)
	*push_chance = *push_chance + unarmed_chance_contribution * morale_ratio
	*disarm_chance = *disarm_chance + unarmed_chance_contribution * morale_ratio

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

	*delay_modifier = *delay_modifier - 0.5 * morale_ratio

/datum/component/morale/proc/handle_user_strafe(mob/living/user, direction, delay_modifier)
	SIGNAL_HANDLER
	if (parent != user)
		return

	if (morale_points < 0 && prob(floor(panic_chance_ceiling * -morale_ratio)))
		user.visible_message(
			SPAN_DANGER("\The [user] fumbles with their mech's controls in a blind panic!"),
			SPAN_DANGER("You fumble with your mech's controls in a blind panic!"))
		*direction = angle2dir(dir2angle(direction) + 180)

	*delay_modifier = *delay_modifier - 0.5 * morale_ratio

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
