
/obj/structure/flora/ausbushes
	name = "bush"
	desc = "A bush."
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "firstbush_1"
	density = FALSE

/obj/structure/flora/ausbushes/New()
	..()
	icon_state = "firstbush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/material/scythe))
		if(prob(50))
			new /obj/item/stack/material/wood(get_turf(src), 2)
		if(prob(40))
			new /obj/item/stack/material/wood(get_turf(src), 4)
		if(prob(10))
			var/pickberry = pick(list(/obj/item/seeds/berryseed, /obj/item/seeds/blueberryseed))
			new /obj/item/stack/material/wood(get_turf(src), 4)
			new pickberry(get_turf(src), 4)
			to_chat(user, SPAN_NOTICE("You find some seeds as you hack the bush away."))
		to_chat(user, SPAN_NOTICE("You slice at the bush!"))
		qdel(src)
		playsound(src, 'sound/effects/woodcutting.ogg', 50, TRUE)
	if(istype(W, /obj/item/material/hatchet)) // No items.
		to_chat(user, SPAN_NOTICE("You chop at the bush!"))
		qdel(src)
		playsound(src, 'sound/effects/woodcutting.ogg', 50, TRUE)
