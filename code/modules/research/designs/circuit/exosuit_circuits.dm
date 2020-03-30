/datum/design/circuit/exosuit
	design_order = 2.5

/datum/design/circuit/exosuit/AssembleDesignName()
	name = "Exosuit Software Design ([name])"

/datum/design/circuit/exosuit/AssembleDesignDesc()
	desc = "Allows for the construction of \a [name] module."

/datum/design/circuit/exosuit/engineering
	name = "Engineering System Control"
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/circuitboard/exosystem/engineering

/datum/design/circuit/exosuit/utility
	name = "Utility System Control"
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/circuitboard/exosystem/utility

/datum/design/circuit/exosuit/medical
	name = "Medical System Control"
	req_tech = list(TECH_DATA = 3,TECH_BIO = 2)
	build_path = /obj/item/circuitboard/exosystem/medical

/datum/design/circuit/exosuit/weapons
	name = "Basic Weapon Control"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/exosystem/weapons

/datum/design/circuit/exosuit/advweapons
	name = "Advanced Weapon Control"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/exosystem/advweapons