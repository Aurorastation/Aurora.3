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
