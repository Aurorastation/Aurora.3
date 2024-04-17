/datum/design/circuit/ship
	p_category = "Ship Component Circuit Designs"

/datum/design/circuit/ship/engine
	name = "Gas Propulsion Thruster"
	req_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/unary_atmos/engine

/datum/design/circuit/ship/engine/ion
	name = "Ion Propulsion Engine"
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6)
	materials = list(MATERIAL_GOLD = 250, MATERIAL_GLASS = 2000)
	build_path = /obj/item/circuitboard/engine/ion

/datum/design/circuit/ship/sensors_weak
	name = "Low-Power Sensor Suite"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 3, TECH_BLUESPACE = 1)
	build_path = /obj/item/circuitboard/shipsensors/weak

/datum/design/circuit/ship/sensors
	name = "Sensor Suite"
	req_tech = list(TECH_POWER = 4, TECH_ENGINEERING = 5, TECH_BLUESPACE = 3)
	build_path = /obj/item/circuitboard/shipsensors

/datum/design/circuit/ship/sensors_strong
	name = "High-Power Sensor Suite"
	req_tech = list(TECH_POWER = 6, TECH_ENGINEERING = 8, TECH_BLUESPACE = 5)
	build_path = /obj/item/circuitboard/shipsensors/strong
	materials = list(MATERIAL_GOLD = 250, MATERIAL_GLASS = 2000)

/datum/design/circuit/ship/iff
	name = "IFF Transponder"
	req_tech = list(TECH_POWER = 4, TECH_ENGINEERING = 5, TECH_DATA = 3)
	build_path = /obj/item/circuitboard/iff_beacon
