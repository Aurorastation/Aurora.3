////////////////////////////////////////////////////////////////////////////////
/// Food.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/food
	flags = OPENCONTAINER
	possible_transfer_amounts = null
	volume = 50 //Sets the default container amount for all food items.
	var/filling_color = "#FFFFFF" //Used by sandwiches
	drop_sound = 'sound/items/drop/food.ogg'
	var/is_liquid = FALSE // Handles whether you can eat with a fork & which eating sound is played

/obj/item/reagent_containers/food/self_feed_message(var/mob/user)
	to_chat(user, "<span class='notice'>You [is_liquid? "drink" : "eat"] \the [src].</span>")
	

/obj/item/reagent_containers/food/feed_sound(var/mob/user)
	if(is_liquid)
		playsound(user.loc, 'sound/items/drink.ogg', rand(10, 50), 1)
	else
		playsound(user.loc, 'sound/items/eatfood.ogg', rand(10, 50), 1)
