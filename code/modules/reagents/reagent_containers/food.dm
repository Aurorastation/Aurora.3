////////////////////////////////////////////////////////////////////////////////
/// Food.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/food
	drop_sound = 'sound/items/drop/food.ogg'
	flags = OPENCONTAINER
	possible_transfer_amounts = null
	volume = 50 //Sets the default container amount for all food items.
	var/filling_color = "#FFFFFF" //Used by sandwiches
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
	if(!reagents.total_volume)
		if(trash)
			user.drop_from_inventory(src)	//so trash actually stays in the active hand.
			var/obj/item/TrashItem = new trash(user)
			user.put_in_hands(TrashItem)
			target.visible_message(span("notice", "[target] finishes [is_liquid ? "drinking" : "eating"] \the [src]."),
								   span("notice","You finish [is_liquid ? "drinking" : "eating"] \the [src]."))
			qdel(src)
