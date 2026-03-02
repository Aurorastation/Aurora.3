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
	name = T_BOARD_HARDSUIT("industrial")

/obj/item/circuitboard/rig_assembly/civilian/eva
	name = T_BOARD_HARDSUIT("EVA")

/obj/item/circuitboard/rig_assembly/civilian/eva/pilot
	name = T_BOARD_HARDSUIT("pilot")

/obj/item/circuitboard/rig_assembly/civilian/ce
	name = T_BOARD_HARDSUIT("advanced void")
	origin_tech = list(TECH_DATA = 5)

/obj/item/circuitboard/rig_assembly/civilian/hazmat
	name = T_BOARD_HARDSUIT("AMI")

/obj/item/circuitboard/rig_assembly/civilian/medical
	name = T_BOARD_HARDSUIT("rescue")

/////////////////////
////COMBAT BOARDS////
/////////////////////

/obj/item/circuitboard/rig_assembly/combat
	origin_tech = list(TECH_DATA = 5)

/obj/item/circuitboard/rig_assembly/combat/targeting
	origin_tech = list(TECH_DATA = 5, TECH_COMBAT = 4)

/obj/item/circuitboard/rig_assembly/combat/hazard
	name = T_BOARD_HARDSUIT("hazard")
	origin_tech = list(TECH_DATA = 4)

/obj/item/circuitboard/rig_assembly/combat/targeting/hazard
	name = T_BOARD_HARDSUIT_TARGETING("hazard")
	origin_tech = list(TECH_DATA = 4, TECH_COMBAT = 4)

/obj/item/circuitboard/rig_assembly/combat/combat
	name = T_BOARD_HARDSUIT("combat")
	origin_tech = list(TECH_DATA = 7)

/obj/item/circuitboard/rig_assembly/combat/targeting/combat
	name = T_BOARD_HARDSUIT_TARGETING("combat")
	origin_tech = list(TECH_DATA = 7, TECH_COMBAT = 6)

/obj/item/circuitboard/rig_assembly/combat/falcata
	name = T_BOARD_HARDSUIT("falcata exoskeleton")
	origin_tech = list(TECH_COMBAT = 1)

/obj/item/circuitboard/rig_assembly/combat/targeting/falcata
	name = T_BOARD_HARDSUIT_TARGETING("falcata exoskeleton")
	origin_tech = list(TECH_COMBAT = 1)

//////////////////////
////ILLEGAL BOARDS////
//////////////////////

/obj/item/circuitboard/rig_assembly/illegal
	origin_tech = list(TECH_DATA = 7, TECH_ILLEGAL = 4)

/obj/item/circuitboard/rig_assembly/illegal/targeting
	origin_tech = list(TECH_DATA = 7, TECH_COMBAT = 4, TECH_ILLEGAL = 4)

/obj/item/circuitboard/rig_assembly/illegal/hacker
	name = T_BOARD_HARDSUIT("cybersuit")

/obj/item/circuitboard/rig_assembly/illegal/targeting/hacker
	name = T_BOARD_HARDSUIT_TARGETING("cybersuit")

/obj/item/circuitboard/rig_assembly/illegal/stealth
	name = T_BOARD_HARDSUIT("stealth")
	origin_tech = list(TECH_DATA = 7, TECH_ILLEGAL = 6)

/obj/item/circuitboard/rig_assembly/illegal/targeting/stealth
	name = T_BOARD_HARDSUIT_TARGETING("stealth")
	origin_tech = list(TECH_DATA = 7, TECH_COMBAT = 6, TECH_ILLEGAL = 6)

