/obj/structure/proycrystal
	name = "taug crystal"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "ano80"
	density = 1

/obj/structure/proycrystal/Initialize()
	..()


/obj/structure/proycrystal/Destroy()
	src.visible_message("<span class='danger'>[src] shatters!</span>")
	return ..()

