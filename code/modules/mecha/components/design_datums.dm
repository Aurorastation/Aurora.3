/*// Components.
/datum/design/item/mech_component
	build_type = MECHFAB
	category = "Vehicle Parts"
	sort_string = "XXXXX"

/datum/design/item/mech_component/frame
	name = "exosuit frame"
	id = "exo_frame"
	req_tech = list()
	materials = list()
	build_path = /obj/item/frame_holder

/datum/design/item/mech_component/head_basic
	name = "power loader head"
	id = "exo_head"
	req_tech = list()
	materials = list()
	build_path = /obj/item/mech_component/sensors/ripley

/datum/design/item/mech_component/arms_basic
	name = "power loader arms"
	id = "exo_arms"
	req_tech = list()
	materials = list()
	build_path = /obj/item/mech_component/manipulators/ripley

/datum/design/item/mech_component/legs_basic
	name = "power loader legs"
	id = "exo_legs"
	req_tech = list()
	materials = list()
	build_path = /obj/item/mech_component/propulsion/ripley

/datum/design/item/mech_component/body_basic
	name = "power loader body"
	id = "exo_body"
	req_tech = list()
	materials = list()
	build_path = /obj/item/mech_component/chassis/ripley

/datum/design/item/mech_component/head_combat
	name = "combat exosuit head"
	id = "exo_head_combat"
	req_tech = list()
	materials = list()
	build_path = /obj/item/mech_component/sensors/gygax

/datum/design/item/mech_component/arms_combat
	name = "combat exosuit arms"
	id = "exo_arms_combat"
	req_tech = list()
	materials = list()
	build_path = /obj/item/mech_component/manipulators/gygax

/datum/design/item/mech_component/legs_combat
	name = "combat exosuit legs"
	id = "exo_legs_combat"
	req_tech = list()
	materials = list()
	build_path = /obj/item/mech_component/propulsion/gygax

/datum/design/item/mech_component/body_combat
	name = "combat exosuit body"
	id = "exo_body_combat"
	req_tech = list()
	materials = list()
	build_path = /obj/item/mech_component/chassis/gygax

/datum/design/item/mech_component/software
	name = "exosuit control module"
	id = "exo_software"
	req_tech = list()
	materials = list()
	build_path = /obj/item/mech_component/control_module

/datum/design/item/mech_component/armour
	name = "exosuit armour plating"
	id = "exo_armour"
	req_tech = list()
	materials = list()
	build_path = /obj/item/mech_component/plating

// Control module software.
/datum/design/circuit/exosystem
	req_tech = list(TECH_DATA = 3)

/datum/design/circuit/exosystem/AssembleDesignName()
	name = "vehicle software template ([name])"

/datum/design/circuit/exosystem/AssembleDesignDesc()
	desc = "Allows for vehicles to use [name]."

/datum/design/circuit/exosystem/engineering
	name = "engineering systems"
	id = "exsoft_engineering"
	build_path = /obj/item/weapon/circuitboard/exosystem/engineering
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)

/datum/design/circuit/exosystem/utility
	name = "utility systems"
	id = "exsoft_utility"
	build_path = /obj/item/weapon/circuitboard/exosystem/utility
	req_tech = list(TECH_DATA = 3)

/datum/design/circuit/exosystem/medical
	name = "medical systems"
	id = "exsoft_medical"
	build_path = /obj/item/weapon/circuitboard/exosystem/medical
	req_tech = list(TECH_DATA = 4, TECH_MEDICAL = 2)

/datum/design/circuit/exosystem/weapons
	name = "ballistic weapon systems"
	id = "exsoft_weapons"
	build_path = /obj/item/weapon/circuitboard/exosystem/weapons
	req_tech = list(TECH_DATA = 4, TECH_COMBAT = 2)

/datum/design/circuit/exosystem/advweapons
	name = "advanced weapon systems"
	id = "exsoft_advweapons"
	build_path = /obj/item/weapon/circuitboard/exosystem/advweapons
	req_tech = list(TECH_DATA = 4, TECH_COMBAT = 4)*/