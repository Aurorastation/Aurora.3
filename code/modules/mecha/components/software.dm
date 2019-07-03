#ifdef T_BOARD_MECHA
#error T_BOARD_MECHA already defined elsewhere, we can't use it.
#endif
#define T_BOARD_MECHA(name)	"vehicle software (" + (name) + ")"

/obj/item/weapon/circuitboard/exosystem
	name = "vehicle software template"
	icon = 'icons/obj/module.dmi'
	icon_state = "std_mod"
	item_state = "electronic"
	board_type = "other"
	var/list/contains_software = list()

/obj/item/weapon/circuitboard/exosystem/engineering
	name = T_BOARD_MECHA("engineering systems")
	contains_software = list(MECH_SOFTWARE_ENGINEERING)
	origin_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)

/obj/item/weapon/circuitboard/exosystem/utility
	name = T_BOARD_MECHA("utility systems")
	contains_software = list(MECH_SOFTWARE_UTILITY)
	icon_state = "mcontroller"
	origin_tech = list(TECH_DATA = 3)

/obj/item/weapon/circuitboard/exosystem/medical
	name = T_BOARD_MECHA("medical systems")
	contains_software = list(MECH_SOFTWARE_MEDICAL)
	icon_state = "mcontroller"
	origin_tech = list(TECH_DATA = 4, TECH_MEDICAL = 2)

/obj/item/weapon/circuitboard/exosystem/weapons
	name = T_BOARD_MECHA("ballistic weapon systems")
	contains_software = list(MECH_SOFTWARE_WEAPONS)
	icon_state = "mainboard"
	origin_tech = list(TECH_DATA = 4, TECH_COMBAT = 2)

/obj/item/weapon/circuitboard/exosystem/advweapons
	name = T_BOARD_MECHA("advanced weapon systems")
	contains_software = list(MECH_SOFTWARE_ADVWEAPONS)
	icon_state = "mainboard"
	origin_tech = list(TECH_DATA = 4, TECH_COMBAT = 4)

#undef T_BOARD_MECHA