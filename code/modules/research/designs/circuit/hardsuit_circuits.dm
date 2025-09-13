/datum/design/circuit/hardsuit
	p_category = "Hardsuit Circuit Designs"

/datum/design/circuit/hardsuit/AssembleDesignDesc()
	desc = "Contains the software required to make this model of hardsuit."

/datum/design/circuit/hardsuit/industrial
	name = "Industrial Suit Central Circuit Board"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/rig_assembly/civilian/industrial

/datum/design/circuit/hardsuit/eva
	name = "EVA suit central circuit Board"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/rig_assembly/civilian/eva

/datum/design/circuit/hardsuit/eva/pilot
	name = "pilot suit central circuit Board"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/rig_assembly/civilian/eva/pilot

/datum/design/circuit/hardsuit/ce
	name = "Advanced Voidsuit Central Circuit Board"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/rig_assembly/civilian/ce

/datum/design/circuit/hardsuit/hazmat
	name = "AMI Suit Central Circuit Board"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/rig_assembly/civilian/hazmat

/datum/design/circuit/hardsuit/medical
	name = "Rescue Suit Central Circuit Board"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/rig_assembly/civilian/medical

/datum/design/circuit/hardsuit/hazard
	name = "Hazard Hardsuit Central Circuit Board"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/rig_assembly/combat/hazard

/datum/design/circuit/hardsuit/hazard_target
	name = "Hazard Hardsuit Control And Targeting Board"
	req_tech = list(TECH_DATA = 3, TECH_COMBAT = 3)
	build_path = /obj/item/circuitboard/rig_assembly/combat/targeting/hazard

/datum/design/circuit/hardsuit/combat
	name = "Combat Hardsuit Central Circuit Board"
	req_tech = list(TECH_DATA = 6)
	build_path = /obj/item/circuitboard/rig_assembly/combat/combat

/datum/design/circuit/hardsuit/combat_target
	name = "Combat Hardsuit Control And Targeting Board"
	req_tech = list(TECH_DATA = 6, TECH_COMBAT = 5)
	build_path = /obj/item/circuitboard/rig_assembly/combat/targeting/combat

/datum/design/circuit/hardsuit/hacker
	name = "Cybersuit Hardsuit Central Circuit Board"
	req_tech = list(TECH_DATA = 6, TECH_ILLEGAL = 3)
	build_path = /obj/item/circuitboard/rig_assembly/illegal/hacker

/datum/design/circuit/hardsuit/hacker_target
	name = "Cybersuit Hardsuit Control And Targeting Board"
	req_tech = list(TECH_DATA = 6, TECH_COMBAT = 3, TECH_ILLEGAL = 3)
	build_path = /obj/item/circuitboard/rig_assembly/illegal/targeting/hacker

/datum/design/circuit/hardsuit/falcata
	name = "Falcata Exoskeleton Central Circuit Board"
	build_path = /obj/item/circuitboard/rig_assembly/combat/falcata

/datum/design/circuit/hardsuit/falcata_target
	name = "Falcata Exoskeleton Control And Targeting Board"
	build_path = /obj/item/circuitboard/rig_assembly/combat/targeting/falcata
