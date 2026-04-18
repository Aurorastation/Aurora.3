// Place purely decorative objects here that doesn't fall under any specific category (legal fake objects).

ABSTRACT_TYPE(/obj/structure/decor)
	name = "base type"
	anchored = TRUE
	layer = STRUCTURE_LAYER

// ---- Ladders

/obj/structure/decor/fluff_ladder
	name = "ladder"
	icon = 'icons/obj/structures.dmi'
	icon_state = "ladder01"

/obj/structure/decor/fluff_ladder/up
	icon_state = "ladder10"

/obj/structure/decor/fluff_ladder/tall
	icon_state = "ladder11"

// ---- Suspension cable

/obj/structure/decor/suspension_cable
	name = "suspension cable"
	desc = "A lightweight, high-strength cable designed for robotic suspension."
	icon = 'icons/obj/power_cond_white.dmi'
	color = "#B6B64B"
	layer = ABOVE_HUMAN_LAYER

/obj/structure/decor/suspension_cable/right
	icon_state = "8-9"

/obj/structure/decor/suspension_cable/left
	icon_state = "4-5"

// ---- Suspension bar

/obj/structure/decor/suspension_bar
	name = "suspension bar"
	desc = "A rigid bar that holds or supports other components."
	icon = 'icons/atmos/pipes.dmi'
	icon_state = "intact"
	color = "#444444"
	layer = ABOVE_HUMAN_LAYER

// ---- Ship guns

/obj/structure/decor/fluff_francisca
	name = "compact francisca rotary gun"
	desc = "While this piece of metal resembles a Francisca-series rotary gun manufactured by Kumar Arms, it appears to have undergone some modifications. \
	It also doesn't seem to be complete."
	icon = 'icons/obj/machinery/ship_guns/francisca_compact.dmi'
	icon_state = "weapon_base"
	density = TRUE
