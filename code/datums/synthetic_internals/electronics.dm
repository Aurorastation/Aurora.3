// The synthetic's electronics. Represents both the hardware and software component.
// The integrity of electronics only goes from 0% to 100%. It does not vary, unlike other components.

/datum/synthetic_internal/electronics
	name = "internal electronics"
	desc = "The electronics and the code responsible for many internal functions."
	/// The maximum integrity percentage of the internals. Represents code coherence and physical damage.
	var/max_integrity = 100
	/// The integrity of the internals in percentage. Represents code coherence and physical damage.
	var/integrity = 100

/datum/synthetic_internal/electronics/get_status()
	return (integrity / max_integrity) * 100

/datum/synthetic_internal/electronics/take_damage(amount)
	// Integrity is really slow to damage. Hacking does a way better job than just shooting the thing.
	integrity = max(integrity - (amount * 0.75), 0)

/datum/synthetic_internal/electronics/heal_damage(amount)
	integrity = min(integrity + amount, max_integrity)
