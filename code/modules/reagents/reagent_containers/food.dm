////////////////////////////////////////////////////////////////////////////////
/// Food.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/food
	drop_sound = 'sound/items/drop/food.ogg'
	pickup_sound = 'sound/items/pickup/food.ogg'
	contained_sprite = TRUE
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	possible_transfer_amounts = null
	volume = 50 //Sets the default container amount for all food items.
	var/bitesize = 1
	var/bitecount = 0
	var/filling_color = "#FFFFFF" //Used by sandwiches
	var/ingredient_name // Also used by sandwiches; if null, it just uses the normal name.
	var/trash = null
	var/is_liquid = TRUE
	var/empty_icon_state

/obj/item/reagent_containers/food/self_feed_message(var/mob/user)
	to_chat(user, SPAN_NOTICE("You [is_liquid ? "drink from" : "eat"] \the [src]."))

/obj/item/reagent_containers/food/feed_sound(var/mob/user)
	if(is_liquid)
		playsound(user.loc, 'sound/items/drink.ogg', rand(10, 50), 1)
	else
		playsound(user.loc, 'sound/items/eatfood.ogg', rand(10, 50), 1)

/obj/item/reagent_containers/food/proc/on_consume(var/mob/user, var/mob/target)
	var/slot = target.get_inventory_slot(src)
	if(!reagents.total_volume)
		if(bitecount==1)
			target.visible_message("<b>[target]</b> [is_liquid ? "drinks" : "eats"] \the [src].", SPAN_NOTICE("You [is_liquid ? "drink" : "eat"] \the [src]."))
		else
			target.visible_message("<b>[target]</b> finishes [is_liquid ? "drinking" : "eating"] \the [src].", SPAN_NOTICE("You finish [is_liquid ? "drinking" : "eating"] \the [src]."))
		if(trash)
			// get or create the trash item
			var/obj/item/trash_item = trash
			if(ispath(trash_item))
				trash_item = new trash_item()
			// and put it in active hand, or on the floor
			if(slot)
				user.drop_from_inventory(src)
				user.put_in_hands(trash_item)
			else
				trash_item.forceMove(get_turf(src))
		if(istype(loc, /obj/item/reagent_containers/bowl/plate))
			var/obj/item/reagent_containers/bowl/plate/P = loc
			if(P.holding == src)
				P.holding = null
				if(!P.grease)
					P.grease = TRUE
				P.update_icon()
		qdel(src)
