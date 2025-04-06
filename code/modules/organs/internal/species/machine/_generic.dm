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

/obj/item/organ/internal/machine/Initialize()
	robotize()
	. = ..()
	wiring = new(src)
	plating = new(src)
	electronics = new(src)

/obj/item/organ/internal/machine/process(seconds_per_tick)
	. = ..()
	var/wire_status = wiring.get_status()
	if(wire_status <= 75)
		wire_damage(wire_status)

	var/plating_status = plating.get_status()
	if(plating_status <= 75)
		plating_damage(wire_status)

	var/electronics_status = electronics.get_status()
	if(electronics_status <= 75)
		electronics_damage(wire_status)

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
 * the average of wiring + plating + electronics.
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
 * The proc that is automatically called by process() on the organ when the wiring is more than 25% damaged.
 */
/obj/item/organ/internal/machine/proc/wire_damage(wire_health)
	if(wiring.last_damage_time < wiring.get_damage_cooldown())
		return FALSE

/**
 * The proc that is automatically called by process() on the organ when the plating is more than 25% damaged.
 */
/obj/item/organ/internal/machine/proc/plating_damage(plating_health)
	if(plating.last_damage_time < plating.get_damage_cooldown())
		return FALSE

/**
 * The proc that is automatically called by process() on the organ when the electronics are more than 25% damaged.
 */
/obj/item/organ/internal/machine/proc/electronics_damage(electronics_health)
	if(electronics.last_damage_time < electronics.get_damage_cooldown())
		return FALSE
