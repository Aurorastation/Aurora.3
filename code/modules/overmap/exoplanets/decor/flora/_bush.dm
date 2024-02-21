/obj/structure/flora/bush
	name = "bush"
	desc = "A bush."
	icon = 'icons/obj/flora/snowflora.dmi'
	icon_state = "snowbush1"
	density = FALSE

/obj/structure/flora/bush/Initialize()
	. = ..()
	icon_state = "snowbush[rand(1, 6)]"

/obj/structure/flora/bush/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/material/scythe))
		shake_animation()
		if(attacking_item.use_tool(src, user, 50, volume = 50))
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
	else if(istype(attacking_item, /obj/item/material/hatchet))
		shake_animation()
		if(attacking_item.use_tool(src, user, 50, volume = 50))
			to_chat(user, SPAN_NOTICE("You chop at the bush!"))
			qdel(src)

/obj/structure/flora/ausbushes
	name = "bush"
	desc = "A bush."
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "firstbush_1"
	density = FALSE

/obj/structure/flora/ausbushes/New()
	..()
	icon_state = "firstbush_[rand(1, 4)]"
