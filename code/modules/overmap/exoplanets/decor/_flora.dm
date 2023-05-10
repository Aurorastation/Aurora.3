/obj/structure/flora
	name = "flora parent object"
	desc = DESC_PARENT
	anchored = TRUE
	density = TRUE
	var/cutting

/obj/structure/flora/proc/dig_up(mob/user)
	user.visible_message(SPAN_NOTICE("\The [user] begins digging up \the [src]..."))
	if(do_after(user, 150))
		if(Adjacent(user))
			user.visible_message(SPAN_NOTICE("\The [user] removes \the [src]!"))
			qdel(src)

/obj/structure/flora/proc/can_dig()
	return FALSE

/obj/structure/flora/attackby(obj/item/I, mob/user)
	if(I.is_shovel() && can_dig())
		dig_up(user)
		return
	..()
