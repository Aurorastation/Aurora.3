// Synthetic internals represent things that are not physically modelled as an organ, but are rather part of the organ.
// That means wiring, plating, and electronics. Damaging organs has adverse effects on these components.
// The goal is to emulate damaging effects similar to arterial bleeding, infections, etc. on organics.

// The specific effects of each synthetic internal can vary organ by organ. They all have different health measurements as well.
// These measurements can change depending on the organ they are attached to.

/datum/synthetic_internal
	/// The name of the internal component. Shows up in analysis tools.
	var/name = "default synthetic internal"
	/// The description. Shows up in analysis tools.
	var/desc = "A default synthetic internal component."
	/// The organ this synthetic internal belongs to.
	var/obj/item/organ/internal/machine/organ

/datum/synthetic_internal/New(obj/item/organ/internal/machine/attached_organ)
	. = ..()
	if(istype(attached_organ))
		organ = attached_organ
	else
		LOG_DEBUG("Synthetic internal [type] generated on invalid organ [attached_organ]. Aborting.")
		qdel(src)

/datum/synthetic_internal/Destroy(force)
	organ = null
	return ..()

/**
 * The proc that handles taking damage. As some components take damage differently,
 * this is overridden by them.
 */
/datum/synthetic_internal/proc/take_damage(amount)
	return

/**
 * The proc that handles restoring damage. As some components restore damage differently,
 * this is overridden by them.
 */
/datum/synthetic_internal/proc/heal_damage(amount)
	return

/**
 * This proc returns the status of this synthetic internal as a percentage.
 * It will return 100 if the component is 100% healthy, a value between 0 and 100 if not, and 0 if broken.
 * This logic can be overridden for custom behaviour.
 */
/datum/synthetic_internal/proc/get_status()
	return

/**
 * This proc returns the status of this internal component, but imprecisely.
 * Basically what could be obvious at an eye-glance.
 */
/datum/synthetic_internal/proc/analyse_integrity_imprecise()
	return

/**
 * This proc returns the status of this internal component, but precisely.
 * Basically the results of an in-depth analysis with an appropriate tool.
 */
/datum/synthetic_internal/proc/analyze_integrity_precise()
	return

/**
 * Replaces the health by setting a new max health and setting the health to the new max_health value.
 * Needs to be overridden on every subtype.
 */
/datum/synthetic_internal/proc/replace_health(new_max_health)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("Not implemented!")
