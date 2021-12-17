/obj/structure/lectern
	name = "lectern"
	desc = "Someone important is going to stand behind that and talk about important things."
	icon = 'icons/obj/lectern.dmi'
	icon_state = "lectern"
	density = FALSE
	anchored = TRUE
	layer = BELOW_MOB_LAYER
	obj_flags = OBJ_FLAG_ROTATABLE

/obj/structure/lectern/Initialize(mapload)
	. = ..()
	update_icon()

/obj/structure/lectern/update_icon()
	if(dir == NORTH)
		layer = BELOW_MOB_LAYER
	else
		layer = ABOVE_MOB_LAYER

/obj/structure/lectern/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if(W.iswrench())
		if(!anchored)
			playsound(src.loc, W.usesound, 75, 1)
			user.visible_message("[user.name] secures [src] to the floor.", \
				"You secure the external reinforcing bolts to the floor.", \
				"You hear a ratchet")
			anchored = 1
		else
			playsound(src.loc, W.usesound, 75, 1)
			user.visible_message("[user.name] unsecures [src] from the floor.", \
				"You unsecure the external reinforcing bolts from the floor.", \
				"You hear a ratchet")
			anchored = 0
		return
	return ..()
