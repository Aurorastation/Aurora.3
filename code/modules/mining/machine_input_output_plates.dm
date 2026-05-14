/**********************Input and output plates**************************/

/obj/machinery/mineral/input
	icon = 'icons/hud/mob/generic.dmi'
	icon_state = "x2"
	name = "Input Area"
	invisibility = INVISIBILITY_ABSTRACT
	density = FALSE
	anchored = TRUE

/obj/machinery/mineral/input/Initialize()
	. = ..()
	icon_state = "blank"

/obj/machinery/mineral/output
	icon = 'icons/hud/mob/generic.dmi'
	icon_state = "x"
	name = "Output Area"
	invisibility = INVISIBILITY_ABSTRACT
	density = FALSE
	anchored = TRUE

/obj/machinery/mineral/output/Initialize()
	. = ..()
	icon_state = "blank"
