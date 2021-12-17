/obj/structure/lectern
	name = "lectern"
	desc = "Someone important is going to stand behind that and talk about important things."
	icon = 'icons/obj/lectern.dmi'
	icon_state = "lectern"
	density = FALSE
	anchored = TRUE
	layer = ABOVE_MOB_LAYER

/obj/structure/lectern/Initialize(mapload)
	update_icon()
	. = ..()

/obj/structure/lectern/update_icon()
	if(dir == NORTH)
		layer = BELOW_MOB_LAYER
	else
		layer = ABOVE_MOB_LAYER
