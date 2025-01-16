/// This component is used to represent synthetic innards that are NOT organs.
/// Primarily, abstract things like plating, wiring, and electronics on the inside.
/// Additionally, it also represents the synthetic's software components. In short, all things that we can't do with the existing synthetic framework.

/datum/component/synthetic_internals
	var/mob/living/carbon/human/synthetic
	/// The synthetic's wiring. Represents the fragile connections between organs and limbs.
	var/datum/synthetic_internal/wiring/wiring
	/// The synthetic's plating. Represents its natural armour, which will degrade as it's damaged.
	var/datum/synthetic_internal/plating/plating
	/// The synthetic's electronics. Represents both the hardware and software component.
	var/datum/synthetic_internal/electronics/electronics

/datum/component/synthetic_internals/Initialize(...)
	. = ..()
	if(!isipc(parent))
		log_debug("Synthetic internals attached to non-synthetic parent: [parent]!")
		qdel(src)
	synthetic = parent

/datum/component/synthetic_internals/Destroy(force)
	. = ..()
	synthetic = null
