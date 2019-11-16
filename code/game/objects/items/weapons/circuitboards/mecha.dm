#ifdef T_BOARD_MECHA
#error T_BOARD_MECHA already defined elsewhere, we can't use it.
#endif
#define T_BOARD_MECHA(name)	"exosuit module circuit board (" + (name) + ")"

/obj/item/circuitboard/mecha
	name = "exosuit circuit board"
	icon = 'icons/obj/module.dmi'
	icon_state = "std_mod"
	item_state = "electronic"
	board_type = "other"


/obj/item/circuitboard/mecha/ripley
	origin_tech = list(TECH_DATA = 3)

/obj/item/circuitboard/mecha/ripley/peripherals
	name = T_BOARD_MECHA("Ripley peripherals control")
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/ripley/main
	name = T_BOARD_MECHA("Ripley central control")
	icon_state = "mainboard"


/obj/item/circuitboard/mecha/gygax
	origin_tech = list(TECH_DATA = 4)

/obj/item/circuitboard/mecha/gygax/peripherals
	name = T_BOARD_MECHA("Gygax peripherals control")
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/gygax/targeting
	name = T_BOARD_MECHA("Gygax weapon control and targeting")
	icon_state = "mcontroller"
	origin_tech = list(TECH_DATA = 4, TECH_COMBAT = 4)

/obj/item/circuitboard/mecha/gygax/main
	name = T_BOARD_MECHA("Gygax central control")
	icon_state = "mainboard"


/obj/item/circuitboard/mecha/durand
	origin_tech = list(TECH_DATA = 4)

/obj/item/circuitboard/mecha/durand/peripherals
	name = T_BOARD_MECHA("Durand peripherals control")
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/durand/targeting
	name = T_BOARD_MECHA("Durand weapon control and targeting")
	icon_state = "mcontroller"
	origin_tech = list(TECH_DATA = 4, TECH_COMBAT = 4)

/obj/item/circuitboard/mecha/durand/main
	name = T_BOARD_MECHA("Durand central control")
	icon_state = "mainboard"


/obj/item/circuitboard/mecha/honker
		origin_tech = list(TECH_DATA = 4)

/obj/item/circuitboard/mecha/honker/peripherals
	name = T_BOARD_MECHA("H.O.N.K peripherals control")
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/honker/targeting
	name = T_BOARD_MECHA("H.O.N.K weapon control and targeting")
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/honker/main
	name = T_BOARD_MECHA("H.O.N.K central control")
	icon_state = "mainboard"


/obj/item/circuitboard/mecha/odysseus
	origin_tech = list(TECH_DATA = 3)

/obj/item/circuitboard/mecha/odysseus/peripherals
	name = T_BOARD_MECHA("Odysseus peripherals control")
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/odysseus/main
	name = T_BOARD_MECHA("Odysseus central control")
	icon_state = "mainboard"

/obj/item/circuitboard/mecha/hermes
	origin_tech = list(TECH_DATA = 2)

/obj/item/circuitboard/mecha/hermes/peripherals
	name = T_BOARD_MECHA("Hermes peripherals control")
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/hermes/main
	name = T_BOARD_MECHA("Hermes central control")
	icon_state = "mainboard"

/obj/item/circuitboard/mecha/phazon
	origin_tech = list(TECH_DATA = 5, TECH_BLUESPACE = 5)

/obj/item/circuitboard/mecha/phazon/peripherals
	name = T_BOARD_MECHA("Phazon peripherals control")
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/phazon/targeting
	name = T_BOARD_MECHA("Phazon weapon control and targeting")
	icon_state = "mcontroller"
	origin_tech = list(TECH_DATA = 5, TECH_COMBAT = 6, TECH_BLUESPACE = 5)

/obj/item/circuitboard/mecha/phazon/main
	name = T_BOARD_MECHA("Phazon central control")
	icon_state = "mainboard"

//Undef the macro, shouldn't be needed anywhere else
#undef T_BOARD_MECHA
