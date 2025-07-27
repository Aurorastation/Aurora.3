/obj/item/organ/internal/machine
	name = "generic machine organ"
	parent_organ = BP_CHEST
	organ_tag = "generic machine organ"
	robotic_sprite = FALSE

	/// The list of organ presets to use. Linked list of ORGAN_PREF to /singleton/synthetic_organ_preset. Use only if your organ has pref settings and presets.
	/// For an example, see cooling_unit.dm. Remember to also update code\modules\client\preference_setup\general\03_body.dm at line 893!
	var/list/organ_presets
	/// The default preset to fall back to if there is no pref (aka people want the base type). Must be of type /singleton/synthetic_organ_preset.
	var/default_preset
	/// The current preset, if any. Should only ever be null or an instance.
	var/singleton/synthetic_organ_preset/current_preset

	/// If an organ shows up in the diagnostics suite (the IPC organ verb).
	var/diagnostics_suite_visible = TRUE

	/// The wiring datum of this organ.
	var/datum/synthetic_internal/wiring/wiring
	/// The plating datum of this organ.
	var/datum/synthetic_internal/plating/plating
	/// The electronics datum of this organ.
	var/datum/synthetic_internal/electronics/electronics

	/// The world.time of the last damage proc.
	var/last_damage_time = 0
	/// The amount of time that has to pass between each damage proc.
	var/damage_cooldown = 60 SECONDS

/obj/item/organ/internal/machine/Initialize()
	robotize()
	. = ..()
	wiring = new(src)
	plating = new(src)
	electronics = new(src)

/obj/item/organ/internal/machine/Destroy()
	QDEL_NULL(wiring)
	QDEL_NULL(plating)
	QDEL_NULL(electronics)
	if(current_preset)
		current_preset = null
	return ..()

/obj/item/organ/internal/machine/refresh_action_button()
	. = ..()
	if(.)
		if(action_button_name)
			action.button_icon_state = initial(icon_state)
			if(action.button)
				action.button.update_icon()

/obj/item/organ/internal/machine/rejuvenate()
	. = ..()
	diagnostics_suite_visible = initial(diagnostics_suite_visible)
	wiring.heal_damage(wiring.max_wires)
	plating.heal_damage(plating.max_health)
	electronics.heal_damage(electronics.max_integrity)
	damage_cooldown = initial(damage_cooldown)

/obj/item/organ/internal/machine/process(seconds_per_tick)
	..()

	var/integrity = get_integrity()
	if(integrity < IPC_INTEGRITY_THRESHOLD_LOW)
		// This is when things start going Fucking Wrong.
		do_integrity_damage_effects(integrity)

	if(damage >= max_damage)
		die()

/obj/item/organ/internal/machine/die()
	to_chat(owner, SPAN_MACHINE_WARNING("Some of your sensors go dark - you've lost connection to your [src]!"))
	diagnostics_suite_visible = FALSE
	damage = max_damage
	status |= ORGAN_DEAD
	death_time = world.time
	STOP_PROCESSING(SSprocessing, src)
	if(owner && vital)
		owner.death()

/obj/item/organ/internal/machine/take_internal_damage(amount, silent)
	// Plating defends the internal bits. First, you have to get through it.
	if(plating.get_status() > 0)
		amount -= plating.take_damage(amount)
		if(!amount)
			return

	// After that, it's open season.
	var/datum/synthetic_internal/bits_to_hit = pick(wiring, electronics)
	bits_to_hit.take_damage(amount)

	. = ..()

/**
 * Called when prefs are synced to the organ to set the proper synthetic organ preset.
 * Remember that the base type is the default, AKA when no prefs are set that organ will spawn.
 * TODOMATT: make this work with acting/changer.
 */
/obj/item/organ/internal/machine/proc/set_organ_preset(organ_pref)
	var/singleton/synthetic_organ_preset/new_preset
	if(organ_pref && (organ_pref in organ_presets))
		new_preset = GET_SINGLETON(organ_presets[organ_pref])
	else
		new_preset = GET_SINGLETON(default_preset)

	if(!istype(new_preset))
		crash_with("Invalid organ preset [new_preset]!")

	current_preset = new_preset
	new_preset.apply_preset(src)

/**
 * This is a function used to return an overall integrity number that takes
 * the average of wiring + electronics. Those are the soft bits - plating is what defends them.
 * Returns a percentage.
 */
/obj/item/organ/internal/machine/proc/get_integrity()
	var/wiring_status = wiring ? wiring.get_status() : 0
	var/electronics_status = electronics ? electronics.get_status() : 0
	return (wiring_status + electronics_status) / 2

/**
 * This function returns the damage level of an organ, only calculating its damage and max_damage.
 * Returns a percentage.
 */
/obj/item/organ/internal/machine/proc/get_damage_percent()
	if(!damage)
		return 0

	return (damage / max_damage) * 100

/**
 * This function returns a damage multiplier, starting from 1 and dropping to 0, depending on damage.
 * Returns a multiplier between 0 and 1.
 */
/obj/item/organ/internal/machine/proc/get_damage_multiplier()
	if(!damage)
		return 1

	return 1 - (damage / max_damage)

/**
 * This proc is used to determine which integrity damage threshold we are at, and execute the proper proc..
 * Only called below 75%.
 */
/obj/item/organ/internal/machine/proc/do_integrity_damage_effects(integrity)
	if(!owner)
		return

	var/obj/item/organ/internal/machine/posibrain/brain = owner.internal_organs_by_name[BP_BRAIN]
	if(!istype(brain)) //???
		crash_with("[src]: [owner] somehow didn't have a posibrain.")

	// The cooldowns are handled in the other procs because feasibly we might want to add different cooldowns for different organs and different thresholds.
	if(can_do_integrity_damage())
		switch(integrity)
			if(50 to 75)
				low_integrity_damage(integrity)
			if(25 to 50)
				medium_integrity_damage(integrity)
			if(0 to 25)
				high_integrity_damage(integrity)

/**
 * Returns the damage percentage of total integrity.
 * Basically the opposite of get_integrity(). Useful for damage probabilities, where you want a scaling number the more integrity damage there is on an organ.
 */
/obj/item/organ/internal/machine/proc/get_integrity_damage_probability(integrity)
	// integrity is a probability, so first of all check the difference between max probability and probaiblity
	// 100 - 100 = 0 | 100 - 50 = 50
	var/damage_probability = 100 - integrity
	return damage_probability

/**
 * Returns TRUE if the cooldown for integrity damage has expired.
 */
/obj/item/organ/internal/machine/proc/can_do_integrity_damage()
	if(last_damage_time + damage_cooldown > world.time)
		return FALSE
	return TRUE

/**
 * The proc called to do low-intensity integrity damage (50 to 75% damage).
 */
/obj/item/organ/internal/machine/proc/low_integrity_damage(integrity)
	last_damage_time = world.time
	return TRUE

/**
 * The proc called to do mediumlow-intensity integrity damage (25 to 50% damage).
 */
/obj/item/organ/internal/machine/proc/medium_integrity_damage(integrity)
	last_damage_time = world.time
	var/obj/item/organ/internal/machine/posibrain/brain = owner.internal_organs_by_name[BP_BRAIN]
	if(istype(brain))
		brain.damage_integrity(1)
	return TRUE

/**
 * The proc called to do high-intensity integrity damage (0 to 25% damage).
 */
/obj/item/organ/internal/machine/proc/high_integrity_damage(integrity)
	last_damage_time = world.time
	var/obj/item/organ/internal/machine/posibrain/brain = owner.internal_organs_by_name[BP_BRAIN]
	if(istype(brain))
		brain.damage_integrity(2)
	return TRUE

/**
 * Returns extra diagnostics info, viewable from the diagnostics unit verbs or through a robot scanner.
 */
/obj/item/organ/internal/machine/proc/get_diagnostics_info()
	return

