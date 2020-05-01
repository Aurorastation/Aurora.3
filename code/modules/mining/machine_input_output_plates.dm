/**********************Input and output plates**************************/

/obj/machinery/mineral/input
	icon = 'icons/mob/screen/generic.dmi'
	icon_state = "x2"
	name = "Input Area"
	density = FALSE
	anchored = TRUE

/obj/machinery/mineral/input/Initialize()
	. = ..()
	icon_state = "blank"

/obj/machinery/mineral/output
	icon = 'icons/mob/screen/generic.dmi'
	icon_state = "x"
	name = "Output Area"
	density = FALSE
	anchored = TRUE

/obj/machinery/mineral/output/Initialize()
	. = ..()
	icon_state = "blank"
