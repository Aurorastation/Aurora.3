////////////////////////////////////////////////////////////////////////////////
/// Food.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/food
	drop_sound = 'sound/items/drop/food.ogg'
	pickup_sound = 'sound/items/pickup/food.ogg'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_food.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_food.dmi'
		)
	flags = OPENCONTAINER
	possible_transfer_amounts = null
	volume = 50 //Sets the default container amount for all food items.
	var/bitesize = 1
	var/bitecount = 0
	var/filling_color = "#FFFFFF" //Used by sandwiches
	var/ingredient_name // Also used by sandwiches; if null, it just uses the normal name.
	var/trash = null
	var/is_liquid = TRUE

/obj/item/reagent_containers/food/self_feed_message(var/mob/user)
	to_chat(user, "<span class='notice'>You [is_liquid ? "drink from" : "eat"] \the [src].</span>")

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
			if(slot)
				user.drop_from_inventory(src)	//so trash actually stays in the active hand.
				var/obj/item/TrashItem = new trash(user)
				user.put_in_hands(TrashItem)
			else
				var/obj/item/TrashItem = new trash(user)
				TrashItem.forceMove(get_turf(src))
		qdel(src)
