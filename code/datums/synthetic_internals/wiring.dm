// The synthetic's wiring. Represents the fragile connections between organs and limbs.

/datum/synthetic_internal/wiring
	name = "internal wiring"
	desc = "The wiring that connects components together and allows them to talk to eachother."
	/// The maximum wires on this organ. Wires represent physical connections between components. They are less plentiful than plating, but they are worse to lose.
	var/max_wires = 15
	/// The wires left on this organ. Wires represent physical connections between components. They are less plentiful than plating, but they are worse to lose.
	var/wires = 15
