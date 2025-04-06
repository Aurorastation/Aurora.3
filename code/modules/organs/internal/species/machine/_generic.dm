/obj/item/organ/internal/machine
	name = "generic machine organ"
	parent_organ = BP_CHEST
	organ_tag = "generic machine organ"

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

/obj/item/organ/internal/machine/process(seconds_per_tick)
	. = ..()

	var/integrity = get_integrity()
	if(integrity < 75)
		// This is when things start going Fucking Wrong.
		integrity_damage(integrity)

/obj/item/organ/internal/machine/take_internal_damage(amount, silent)
	. = ..()
	// Plating defends the internal bits. First, you have to get through it.
	if(plating.get_status() > 0)
		plating.take_damage(amount)
		return

	// After that, it's open season.
	var/bits_to_hit = pick("wiring", "electronics")
	switch(bits_to_hit)
		if("wiring")
			wiring.take_damage(amount)
		if("electronics")
			electronics.take_damage(amount)

/**
 * This is a function used to return an overall integrity number that takes
 * the average of wiring + electronics.
 * Those are the soft bits - plating is what defends them.
 * Returns a percentage.
 */
/obj/item/organ/internal/machine/proc/get_integrity()
	return (wiring.get_status() + electronics.get_status() + plating.get_status()) / 3

/**
 * This function returns the damage level of an organ, only calculating its damage and max_damage.
 * Returns a percentage.
 */
/obj/item/organ/internal/machine/proc/get_damage_percent()
	if(!damage)
		return 0

	return (damage / max_damage) * 100
/**
 * This proc is overridden by the organ to do cool damage events based on integrity.
 * Only called below 75.
 */
/obj/item/organ/internal/machine/proc/integrity_damage(integrity)
	var/obj/item/organ/internal/machine/posibrain/brain = owner.internal_organs_by_name[BP_BRAIN]
	if(!istype(brain)) //???
		log_debug("[src]: [owner] somehow didn't have a posibrain.")

	switch(integrity)
		if(50 to 75)
			brain.take_internal_damage(1)
			low_integrity_damage(integrity)
		if(25 to 50)
			brain.take_internal_damage(2)
			medium_integrity_damage(integrity)
		if(0 to 25)
			brain.take_internal_damage(3)
			high_integrity_damage(integrity)

/**
 * The proc called to do low-intensity integrity damage (50 to 75% damage).
 */
/obj/item/organ/internal/machine/proc/low_integrity_damage(integrity)
	if(last_damage_time + damage_cooldown > world.time)
		return FALSE

/**
 * The proc called to do mediumlow-intensity integrity damage (25 to 50% damage).
 */
/obj/item/organ/internal/machine/proc/medium_integrity_damage(integrity)
	if(last_damage_time + damage_cooldown > world.time)
		return FALSE

/**
 * The proc called to do high-intensity integrity damage (0 to 25% damage).
 */
/obj/item/organ/internal/machine/proc/high_integrity_damage(integrity)
	if(last_damage_time + damage_cooldown > world.time)
		return FALSE
