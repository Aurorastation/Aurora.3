/obj/item/circuitboard/rig_assembly
	name = "rig circuit board"
	icon = 'icons/obj/module.dmi'
	icon_state = "std_mod"
	item_state = "electronic"
	board_type = "other"

///////////////////////
////CIVILIAN BOARDS////
///////////////////////

/obj/item/circuitboard/rig_assembly/civilian
	origin_tech = list(TECH_DATA = 4)

/obj/item/circuitboard/rig_assembly/civilian/industrial
	name = "industrial suit central circuit board"

/obj/item/circuitboard/rig_assembly/civilian/eva
	name = "EVA suit central circuit board"

/obj/item/circuitboard/rig_assembly/civilian/ce
	name = "advanced void suit central circuit board"
	origin_tech = list(TECH_DATA = 5)

/obj/item/circuitboard/rig_assembly/civilian/hazmat
	name = "AMI suit central circuit board"

/obj/item/circuitboard/rig_assembly/civilian/medical
	name = "rescue suit central circuit board"

/////////////////////
////COMBAT BOARDS////
/////////////////////

/obj/item/circuitboard/rig_assembly/combat
	origin_tech = list(TECH_DATA = 5)

/obj/item/circuitboard/rig_assembly/combat/targeting
	origin_tech = list(TECH_DATA = 5, TECH_COMBAT = 4)

/obj/item/circuitboard/rig_assembly/combat/hazard
	name = "hazard rig central circuit board"

/obj/item/circuitboard/rig_assembly/combat/targeting/hazard
	name = "hazard rig control and targeting board"

/obj/item/circuitboard/rig_assembly/combat/combat
	name = "combat rig central circuit board"
	origin_tech = list(TECH_DATA = 7)

/obj/item/circuitboard/rig_assembly/combat/targeting/combat
	name = "combat rig control and targeting board"
	origin_tech = list(TECH_DATA = 7, TECH_COMBAT = 6)

//////////////////////
////ILLEGAL BOARDS////
//////////////////////

/obj/item/circuitboard/rig_assembly/illegal
	origin_tech = list(TECH_DATA = 7, TECH_ILLEGAL = 4)

/obj/item/circuitboard/rig_assembly/illegal/targeting
	origin_tech = list(TECH_DATA = 7, TECH_COMBAT = 4, TECH_ILLEGAL = 4)

/obj/item/circuitboard/rig_assembly/illegal/hacker
	name = "cybersuit rig central circuit board"

/obj/item/circuitboard/rig_assembly/illegal/targeting/hacker
	name = "cybersuit rig control and targeting board"

/obj/item/circuitboard/rig_assembly/illegal/stealth
	name = "stealth rig central circuit board"
	origin_tech = list(TECH_DATA = 7, TECH_ILLEGAL = 6)

/obj/item/circuitboard/rig_assembly/illegal/targeting/stealth
	name = "stealth rig control and targeting board"
	origin_tech = list(TECH_DATA = 7, TECH_COMBAT = 6, TECH_ILLEGAL = 6)

