// Grass
/obj/structure/flora/grass
	name = "\proper grass"
	desc = "Some grass."
	icon = 'icons/obj/flora/snowflora.dmi'
	density = FALSE

/obj/structure/flora/grass/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/material/scythe))
		shake_animation()
		if(attacking_item.use_tool(src, user, 10, volume = 50))
			to_chat(user, SPAN_NOTICE("You slice the grass away with the scythe!"))
			qdel(src)
	else if(istype(attacking_item, /obj/item/material/hatchet))
		shake_animation()
		if(attacking_item.use_tool(src, user, 50, volume = 50))
			to_chat(user, SPAN_NOTICE("You chop at the grass!"))
			qdel(src)

/obj/structure/flora/grass/brown
	icon_state = "snowgrass1bb"

/obj/structure/flora/grass/brown/New()
	..()
	icon_state = "snowgrass[rand(1, 3)]bb"

/obj/structure/flora/grass/green
	icon_state = "snowgrass1gb"

/obj/structure/flora/grass/green/New()
	..()
	icon_state = "snowgrass[rand(1, 3)]gb"

/obj/structure/flora/grass/both
	icon_state = "snowgrassall1"

/obj/structure/flora/grass/both/New()
	..()
	icon_state = "snowgrassall[rand(1, 3)]"
