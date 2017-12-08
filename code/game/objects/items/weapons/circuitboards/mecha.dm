#ifdef T_BOARD_MECHA
#error T_BOARD_MECHA already defined elsewhere, we can't use it.
#endif
#define T_BOARD_MECHA(name)	"exosuit module circuit board (" + (name) + ")"

	name = "exosuit circuit board"
	icon = 'icons/obj/module.dmi'
	icon_state = "std_mod"
	item_state = "electronic"
	board_type = "other"


	origin_tech = list(TECH_DATA = 3)

	name = T_BOARD_MECHA("Ripley peripherals control")
	icon_state = "mcontroller"

	name = T_BOARD_MECHA("Ripley central control")
	icon_state = "mainboard"


	origin_tech = list(TECH_DATA = 4)

	name = T_BOARD_MECHA("Gygax peripherals control")
	icon_state = "mcontroller"

	icon_state = "mcontroller"
	origin_tech = list(TECH_DATA = 4, TECH_COMBAT = 4)

	name = T_BOARD_MECHA("Gygax central control")
	icon_state = "mainboard"


	origin_tech = list(TECH_DATA = 4)

	name = T_BOARD_MECHA("Durand peripherals control")
	icon_state = "mcontroller"

	icon_state = "mcontroller"
	origin_tech = list(TECH_DATA = 4, TECH_COMBAT = 4)

	name = T_BOARD_MECHA("Durand central control")
	icon_state = "mainboard"


		origin_tech = list(TECH_DATA = 4)

	name = T_BOARD_MECHA("H.O.N.K peripherals control")
	icon_state = "mcontroller"

	icon_state = "mcontroller"

	name = T_BOARD_MECHA("H.O.N.K central control")
	icon_state = "mainboard"


	origin_tech = list(TECH_DATA = 3)

	name = T_BOARD_MECHA("Odysseus peripherals control")
	icon_state = "mcontroller"

	name = T_BOARD_MECHA("Odysseus central control")
	icon_state = "mainboard"

	origin_tech = list(TECH_DATA = 5, TECH_BLUESPACE = 5)

	name = T_BOARD_MECHA("Phazon peripherals control")
	icon_state = "mcontroller"

	icon_state = "mcontroller"
	origin_tech = list(TECH_DATA = 5, TECH_COMBAT = 6, TECH_BLUESPACE = 5)

	name = T_BOARD_MECHA("Phazon central control")
	icon_state = "mainboard"

//Undef the macro, shouldn't be needed anywhere else
#undef T_BOARD_MECHA
