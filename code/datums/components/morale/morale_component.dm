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

	if (!length(morale_comp.moodlets))
		to_chat(usr, SPAN_NOTICE("You currently have no morale modifiers."))
		return

	// This section is Unlinted since we need to access a same-file PRIVATE var
	// and for whatever ungodly reason strongdmm doesn't allow same-file to touch VAR_PRIVATE
	UNLINT(to_chat(usr, SPAN_NOTICE("Your current morale bonus is [morale_comp.morale_ratio * 100]%")))
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
	var/panic_chance_ceiling = 10.0

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

/datum/component/morale/proc/get_morale_ratio()
	return morale_ratio

/datum/component/morale/proc/get_morale_points()
	return morale_points

/datum/component/morale/proc/add_morale_points(input)
	morale_points += input
	morale_ratio = ftanh(beta_value * morale_points)

	// I get to do this freakishly compact state setting because I can
	// logically prove via VAR_PRIVATE that this is only ever set via a hyperbolic tangent
	// And that because a hyperbolic tangent will only ever return a value between -1 and 1,
	// the range of this equation becomes the set of integers between 1 and 9 inclusive.
	morale_ui.icon_state = ((morale_ratio > -0.1 && morale_ratio < 0.1) ? "morale_hidden" : "morale" + "[round(morale_ratio * 4) + 5]")

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
	return ..()

/datum/component/morale/process(seconds_per_tick)
	if (!length(moodlets))
		return PROCESS_KILL

	var/current_time = REALTIMEOFDAY
	var/list_trimmed = FALSE
	for (var/datum/moodlet/moodlet as anything in moodlets)
		if (moodlet.time_to_die > current_time || QDELING(moodlet))
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
	*power = *power * (1 + (melee_damage_contribution * morale_ratio))

/datum/component/morale/proc/handle_accuracy(mob/shooter, accuracy_decrease, dispersion_increase)
	SIGNAL_HANDLER
	*accuracy_decrease = *accuracy_decrease - firearm_accuracy_contribution * morale_ratio
	*dispersion_increase = *dispersion_increase - firearm_dispersion_contribution * morale_ratio

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

	*delay_modifier = *delay_modifier - mech_move_delay_contribution * morale_ratio

/datum/component/morale/proc/handle_user_strafe(mob/living/user, direction, delay_modifier)
	SIGNAL_HANDLER
	if (parent != user)
		return

	if (morale_points < 0 && prob(floor(panic_chance_ceiling * -morale_ratio)))
		user.visible_message(
			SPAN_DANGER("\The [user] fumbles with their mech's controls in a blind panic!"),
			SPAN_DANGER("You fumble with your mech's controls in a blind panic!"))
		*direction = angle2dir(dir2angle(direction) + 180)

	*delay_modifier = *delay_modifier - mech_move_delay_contribution * morale_ratio

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

/datum/component/morale/proc/handle_surgery_modifiers(mob/living/user, success_rate)
	SIGNAL_HANDLER
	*success_rate = *success_rate + surgery_success_contribution * morale_ratio

/datum/component/morale/proc/get_morale_hud(mob/living/carbon/human/user)
	SIGNAL_HANDLER
	if (QDELING(src))
		return // draw nothing.

	user.client?.screen |= morale_ui

/datum/component/morale/proc/handle_crafting_speed(mob/user, doafter_time)
	SIGNAL_HANDLER
	*doafter_time = *doafter_time * (1 - (crafting_speed_contribution * morale_ratio))

/datum/component/morale/proc/modify_yield(owner, datum/seed/plant, total_yield, cancelled, doafter)
	SIGNAL_HANDLER
	*total_yield = *total_yield + plant_yield_contribution * morale_ratio
	*doafter = *doafter * (1 - (harvest_speed_contribution * morale_ratio))
