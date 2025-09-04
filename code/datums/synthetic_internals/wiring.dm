// The synthetic's wiring. Represents the fragile connections between organs and limbs.

/datum/synthetic_internal/wiring
	name = "internal wiring"
	desc = "The wiring that connects components together and allows them to talk to eachother."
	/// The maximum wires on this organ. Wires represent physical connections between components. They are less plentiful than plating, but they are worse to lose.
	var/max_wires = 20
	/// The wires left on this organ. Wires represent physical connections between components. They are less plentiful than plating, but they are worse to lose.
	var/wires = 20

/datum/synthetic_internal/wiring/get_status()
	return (wires / max_wires) * 100

/datum/synthetic_internal/wiring/take_damage(amount)
	wires = max(wires - round(amount, 1), 0)

/datum/synthetic_internal/wiring/heal_damage(amount)
	wires = min(wires + amount, max_wires)
