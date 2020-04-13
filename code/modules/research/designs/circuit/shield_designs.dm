/datum/design/circuit/shield
	req_tech = list(TECH_BLUESPACE = 4, TECH_PHORON = 3)
	materials = list(MATERIAL_GLASS = 2000, MATERIAL_GOLD = 1000)
	design_order = 5

/datum/design/circuit/shield/AssembleDesignName()
	name = "Shield Generator Circuit Design ([name])"

/datum/design/circuit/shield/AssembleDesignDesc()
	if(!desc)
		desc = "Allows for the construction of \a [name] shield generator."

/datum/design/circuit/shield/bubble
	name = "Bubble"
	build_path = /obj/item/circuitboard/shield_gen

/datum/design/circuit/shield/hull
	name = "Hull"
	build_path = /obj/item/circuitboard/shield_gen_ex

/datum/design/circuit/shield/capacitor
	name = "Capacitor"
	desc = "Allows for the construction of a shield capacitor circuit board."
	req_tech = list(TECH_MAGNET = 3, TECH_POWER = 4)
	build_path = /obj/item/circuitboard/shield_cap