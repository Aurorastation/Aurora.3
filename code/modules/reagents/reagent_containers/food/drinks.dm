/*
Standards for trash/empty states under the /drinks path:
Adding Empty States: Trash/Empty states should be placed in the same icon as the drink and should be the drink's icon_state name followed by _empty (ex: whiskeybottle_empty).
If your trash state applies to multiple drinks, to avoid duplicating sprites, set the empty_icon_state var to that icon state. These will still need to be placed in the same icon file.
If you add a drink with an empty icon sprite, ensure it is in the same folder, else it will not work.
*/


////////////////////////////////////////////////////////////////////////////////
/// Drinks.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/food/drinks
	name = "drink"
	desc = "yummy"
	icon = 'icons/obj/drinks.dmi'
	drop_sound = 'sound/items/drop/bottle.ogg'
	pickup_sound = 'sound/items/pickup/bottle.ogg'
	icon_state = null
	item_state = "glass_empty"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	amount_per_transfer_from_this = 5
	volume = 50
	var/shaken = 0
	var/drink_flags

/obj/item/reagent_containers/food/drinks/Initialize()
	. = ..()
	if(drink_flags & IS_GLASS)
		unacidable = TRUE

/obj/item/reagent_containers/food/drinks/update_icon()
	..()
	if(!reagents.total_volume)
		if(("[initial(icon_state)]_empty") in icon_states(icon)) // if there's an empty icon state, use it
			icon_state = "[initial(icon_state)]_empty"
		else if (empty_icon_state)
			icon_state = empty_icon_state
	else
		icon = initial(icon)	//Necessary for refilling empty drinks
		icon_state = initial(icon_state)

/obj/item/reagent_containers/food/drinks/on_reagent_change()
	update_icon()

/obj/item/reagent_containers/food/drinks/on_rag_wipe(var/obj/item/reagent_containers/glass/rag/R)
	clean_blood()

/obj/item/reagent_containers/food/drinks/attack_self(mob/user as mob)
	if(!is_open_container())
		if(user.a_intent == I_HURT && !shaken)
			shaken = 1
			user.visible_message("[user] shakes \the [src]!", "You shake \the [src]!")
			playsound(loc,'sound/items/soda_shaking.ogg', rand(10,50), 1)
			return
		if(shaken)
			for(var/_R in reagents.reagent_volumes)
				var/singleton/reagent/R = GET_SINGLETON(_R)
				if(R.carbonated)
					boom(user)
					return
		open(user)

/obj/item/reagent_containers/food/drinks/proc/open(mob/user as mob)
	playsound(loc,'sound/items/soda_open.ogg', rand(10,50), 1)
	user.visible_message("<b>[user]</b> opens \the [src].", SPAN_NOTICE("You open \the [src] with an audible pop!"), "You can hear a pop.")
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER

/obj/item/reagent_containers/food/drinks/proc/boom(mob/user as mob)
	user.visible_message("<span class='danger'>\The [src] explodes all over [user] as they open it!</span>","<span class='danger'>\The [src] explodes all over you as you open it!</span>","You can hear a soda can explode.")
	playsound(loc,'sound/items/Soda_Burst.ogg', rand(20,50), 1)
	reagents.clear_reagents()
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER
	shaken = 0

/obj/item/reagent_containers/food/drinks/attack(mob/M as mob, mob/user as mob, def_zone)
	if(force && !(atom_flags & ITEM_FLAG_NO_BLUDGEON) && user.a_intent == I_HURT)
		return ..()
	return 0

/obj/item/reagent_containers/food/drinks/standard_feed_mob(var/mob/user, var/mob/target)
	if(!is_open_container())
		to_chat(user, "<span class='notice'>You need to open \the [src]!</span>")
		return 1
	return ..()

/obj/item/reagent_containers/food/drinks/standard_dispenser_refill(var/mob/user, var/obj/structure/reagent_dispensers/target)
	if(!is_open_container())
		to_chat(user, "<span class='notice'>You need to open \the [src]!</span>")
		return 1
	return ..()

/obj/item/reagent_containers/food/drinks/standard_pour_into(var/mob/user, var/atom/target)
	if(!is_open_container())
		to_chat(user, "<span class='notice'>You need to open \the [src]!</span>")
		return 1
	return ..()

/obj/item/reagent_containers/food/drinks/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if (distance > 1)
		return
	if(!reagents || reagents.total_volume == 0)
		. += "<span class='notice'>\The [src] is empty!</span>"
	else if (reagents.total_volume <= volume * 0.25)
		. += "<span class='notice'>\The [src] is almost empty!</span>"
	else if (reagents.total_volume <= volume * 0.66)
		. += "<span class='notice'>\The [src] is half full!</span>"
	else if (reagents.total_volume <= volume * 0.90)
		. += "<span class='notice'>\The [src] is almost full!</span>"
	else
		. += "<span class='notice'>\The [src] is full!</span>"


////////////////////////////////////////////////////////////////////////////////
/// Drinks. END
////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////Drinks
//Notes by Darem: Drinks are simply containers that start preloaded. Unlike condiments, the contents can be ingested directly
//	rather then having to add it to something else first. They should only contain liquids. They have a default container size of 50.
//	Formatting is the same as food.
/obj/item/reagent_containers/food/drinks/coffee
	name = "\improper Martian Dark Roast"
	desc = "The darkest roast this side of Olympia, guaranteed."
	icon_state = "coffee_vended"
	item_state = "coffee"
	trash = /obj/item/trash/coffee
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/drink/coffee = 30)

/obj/item/reagent_containers/food/drinks/pslatte
	name = "seasonal pumpkin spice latte"
	desc = "A limited edition pumpkin spice coffee drink!"
	icon_state = "psl_vended"
	item_state = "coffee"
	trash = /obj/item/trash/coffee
	empty_icon_state = "coffee_vended_empty"
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/drink/coffee/sadpslatte = 30)

/obj/item/reagent_containers/food/drinks/tea
	name = "\improper Sol-III tea"
	desc = "A hot tea with an \"Earthy\" flavor that's much weaker than it claims to be on the cup."
	icon_state = "coffee_vended"
	item_state = "coffee"
	trash = /obj/item/trash/coffee
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'
	center_of_mass = list("x"=16, "y"=14)
	reagents_to_add = list(/singleton/reagent/drink/tea = 30)

/obj/item/reagent_containers/food/drinks/greentea
	name = "green tea"
	desc = "Tasty green tea. It's good for you!"
	icon_state = "greentea_vended"
	item_state = "coffee"
	trash = /obj/item/trash/coffee
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'
	center_of_mass = list("x"=16, "y"=14)
	reagents_to_add = list(/singleton/reagent/drink/tea/greentea = 30)

/obj/item/reagent_containers/food/drinks/hotcider
	name = "hot cider"
	desc = "A hearty apple drink, spiced just right."
	icon_state = "soy_latte_vended"
	item_state = "coffee"
	trash = /obj/item/trash/coffee
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'
	center_of_mass = list("x"=16, "y"=14)
	reagents_to_add = list(/singleton/reagent/drink/ciderhot = 30)

/obj/item/reagent_containers/food/drinks/chaitea
	name = "chai tea"
	desc = "The name is redundant but the flavor is delicious!"
	icon_state = "chai_vended"
	item_state = "coffee"
	trash = /obj/item/trash/coffee
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'
	center_of_mass = list("x"=16, "y"=14)
	reagents_to_add = list(/singleton/reagent/drink/tea/chaitea = 30)

/obj/item/reagent_containers/food/drinks/ice
	name = "\improper Admiral's ice cup"
	desc = "Solid water served in an official Getmore-brand disposable collector's cup, each one commemorating a late admiral."
	icon_state = "coffee_vended"
	item_state = "coffee"
	trash = /obj/item/trash/coffee
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'
	center_of_mass = list("x"=15, "y"=10)
	reagents_to_add = list(/singleton/reagent/drink/ice = 30)

/obj/item/reagent_containers/food/drinks/h_chocolate
	name = "\improper Red Gaia hot coco"
	desc = "A Mars favorite. Usually dispensed at a temperature hotter than any human can stand."
	icon_state = "coffee_vended"
	item_state = "coffee"
	trash = /obj/item/trash/coffee
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'
	center_of_mass = list("x"=15, "y"=13)
	reagents_to_add = list(/singleton/reagent/drink/hot_coco = 30)

/obj/item/reagent_containers/food/drinks/dry_ramen
	name = "cup ramen"
	desc = "Just add 10ml water, self heats! A taste that reminds you of your school years."
	icon_state = "ramen"
	item_state = "coffee"
	trash = /obj/item/trash/ramen
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/drink/dry_ramen = 30)
	is_liquid = FALSE

/obj/item/reagent_containers/food/drinks/dry_ramen/on_reagent_change()
	..()
	if(reagents.has_reagent("dry_ramen"))
		is_liquid = FALSE
	else
		is_liquid = TRUE

/obj/item/reagent_containers/food/drinks/waterbottle
	name = "bottled water"
	desc = "A fresh bottle of water from the finest bottling plants on Silversun."
	desc_extended = "Previously introduced to the vending machines by Skrellian request, this water used to come straight from the Martian poles. Ever since the Martian catastrophe, however, an Idris subsidiary has since stepped in to fill the gap in the market \
	and 'Martian Water' has become a prized collector's item."
	icon = 'icons/obj/item/reagent_containers/food/drinks/soda.dmi' // it's no soda, but shows up in vending machines nonetheless
	icon_state = "smallbottle"
	atom_flags = 0 //starts closed
	center_of_mass = list("x"=16, "y"=8)
	drop_sound = 'sound/items/drop/disk.ogg'
	pickup_sound = 'sound/items/pickup/disk.ogg'
	volume = 30
	reagents_to_add = list(/singleton/reagent/water = 30)

/obj/item/reagent_containers/food/drinks/waterbottle/update_icon()
	cut_overlays()

	if(reagents?.total_volume)
		var/mutable_appearance/filling = mutable_appearance(icon, "[icon_state]-[get_filling_state()]")
		filling.color = reagents.get_color()
		add_overlay(filling)

//heehoo bottle flipping
/obj/item/reagent_containers/food/drinks/waterbottle/throw_impact()
	. = ..()
	if(!QDELETED(src))
		if(prob(10)) // landed upright in some way
			if(prob(10)) // landed upright on ITS CAP (1% chance)
				src.visible_message(SPAN_NOTICE("\The [src] lands upright on its cap!"))
				animate(src, transform = matrix(prob(50)? 180 : -180, MATRIX_ROTATE), time = 3, loop = 0)
			else
				src.visible_message(SPAN_NOTICE("\The [src] lands upright!"))
		else // landed on it's side
			animate(src, transform = matrix(prob(50)? 90 : -90, MATRIX_ROTATE), time = 3, loop = 0)

/obj/item/reagent_containers/food/drinks/waterbottle/pickup()
	. = ..()
	animate(src, transform = null, time = 1, loop = 0)

/obj/item/reagent_containers/food/drinks/waterbottle/large
	name = "large bottled water"
	volume = 100
	reagents_to_add = list(/singleton/reagent/water = 100)

/obj/item/reagent_containers/food/drinks/sillycup
	name = "paper cup"
	desc = "A paper water cup."
	icon_state = "water_cup_e"
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'
	possible_transfer_amounts = null
	volume = 10
	center_of_mass = list("x"=16, "y"=12)

/obj/item/reagent_containers/food/drinks/sillycup/on_reagent_change()
	if(reagents.total_volume)
		icon_state = "water_cup"
	else
		icon_state = "water_cup_e"

/obj/item/reagent_containers/food/drinks/takeaway_cup_idris
	name = "takeaway cup"
	desc = "A takeaway cup, sporting the Idris logo."
	icon_state = "takeaway_cup_idris"
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'
	possible_transfer_amounts = null
	volume = 30

//////////////////////////drinkingglass and shaker//
//Note by Darem: This code handles the mixing of drinks. New drinks go in three places: In Chemistry-Reagents.dm (for the drink
//	itself), in Chemistry-Recipes.dm (for the reaction that changes the components into the drink), and here (for the drinking glass
//	icon states.)

/obj/item/reagent_containers/food/drinks/shaker
	name = "shaker"
	desc = "A metal shaker to mix drinks in."
	desc_info = "Alt Click the shaker to twist the cap closed/loose. If the cap is loose, use the shaker to remove it. Without a cap, use the shaker again to remove the top. \
	If the shaker has a top fitted, you can Alt Click the shaker to change the transfer amount. Without a top, the transfer amount changes to max automatically."
	icon = 'icons/obj/shaker.dmi'
	icon_state = "shaker"
	item_state = "shaker"
	contained_sprite = TRUE
	filling_states = "10;25;50;75;80;100"
	unacidable = TRUE
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(10, 30, 60)
	volume = 120
	center_of_mass = list("x"=16, "y"=8)
	var/last_shake = 0
	var/twisted = FALSE
	var/obj/item/shaker_top/top
	var/obj/item/reagent_containers/food/drinks/shaker_cup/cap

/obj/item/reagent_containers/food/drinks/shaker/Initialize()
	. = ..()
	top = new(src)
	cap = new(src)
	update_icon()

/obj/item/reagent_containers/food/drinks/shaker/Destroy()
	QDEL_NULL(top)
	QDEL_NULL(cap)
	return ..()

/obj/item/reagent_containers/food/drinks/shaker/update_icon()
	cut_overlays()
	if(top)
		icon_state = "shakertop"
		item_state = "shakertop"
	else
		icon_state = initial(icon_state)
		item_state = icon_state
		if(reagents.total_volume)
			var/mutable_appearance/filling = mutable_appearance('icons/obj/shaker.dmi', "[icon_state]-[get_filling_state()]")
			filling.color = reagents.get_color()
			add_overlay(filling)
	if(cap)
		add_overlay("shaker_cap")
	update_held_icon()

/obj/item/reagent_containers/food/drinks/shaker/AltClick(mob/user)
	if(cap)
		toggle_twist()
		return
	if(top)
		set_APTFT()
	return

/obj/item/reagent_containers/food/drinks/shaker/attack_self(mob/user)
	if(!twisted)
		if(cap)
			to_chat(user, SPAN_NOTICE("You remove \the [src]'s [cap]."))
			user.put_in_hands(cap)
			atom_flags |= ATOM_FLAG_OPEN_CONTAINER
			cap = null
			playsound(src.loc, /singleton/sound_category/shaker_lid_off, 50, 1)
			update_icon()
			return
		if(top)
			toggle_top()
			return
		to_chat(user, SPAN_WARNING("It would be a bad idea to shake it without it being closed."))
		return
	if(last_shake <= world.time - 10) //Spam limiter.
		last_shake = world.time
		playsound(src.loc, /singleton/sound_category/shaker_shaking, 50, 1)
	src.add_fingerprint(user)
	return

/obj/item/reagent_containers/food/drinks/shaker/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/reagent_containers/food/drinks/shaker_cup))
		if(cap)
			to_chat(user, SPAN_WARNING("\The [src] already has \a [cap]."))
			return TRUE
		if(attacking_item.reagents.total_volume > 0)
			var/obj/item/reagent_containers/food/drinks/shaker_cup/C = attacking_item
			C.standard_pour_into(user, src)
			return TRUE
		if(!top)
			to_chat(user, SPAN_WARNING("\The [src] lacks a top to fit \the [attacking_item] on."))
			return TRUE
		to_chat(user, SPAN_NOTICE("You put \the [attacking_item] onto \the [src]."))
		user.drop_from_inventory(attacking_item, src)
		atom_flags ^= ATOM_FLAG_OPEN_CONTAINER
		cap = attacking_item
		playsound(src.loc, /singleton/sound_category/shaker_lid_off, 50, 1)
		update_icon()
		return TRUE
	if(istype(attacking_item, /obj/item/shaker_top))
		if(top)
			to_chat(user, SPAN_WARNING("\The [src] already has \a [top]."))
			return TRUE
		to_chat(user, SPAN_NOTICE("You fit \the [attacking_item] onto \the [src]."))
		amount_per_transfer_from_this = 10
		user.drop_from_inventory(attacking_item, src)
		top = attacking_item
		playsound(src.loc, /singleton/sound_category/shaker_lid_off, 50, 1)
		update_icon()
		return TRUE
	return ..()

/obj/item/reagent_containers/food/drinks/shaker/on_pour()
	if(!top)
		playsound(src, 'sound/effects/pour_big.ogg', 50, 1)
		return
	return ..()

/obj/item/reagent_containers/food/drinks/shaker/verb/toggle_twist()
	set category = "Object"
	set name = "Twist Cap"
	set src in usr

	if(!cap)
		to_chat(usr, SPAN_WARNING("\The [src] doesn't have a cap!"))
		return
	twisted = !twisted
	to_chat(usr, SPAN_NOTICE("You twist \the [cap] [twisted ? "closed for a tight seal" : "loose"]."))
	update_icon()

/obj/item/reagent_containers/food/drinks/shaker/verb/toggle_top()
	set category = "Object"
	set name = "Remove Top"
	set src in usr

	if(cap)
		to_chat(usr, SPAN_WARNING("You must remove \the [cap] first!"))
		return
	if(!top)
		to_chat(usr, SPAN_WARNING("\The [src] doesn't have a top to remove!"))
		return
	to_chat(usr, SPAN_NOTICE("You remove \the [src]'s [top]."))
	amount_per_transfer_from_this = 120
	usr.put_in_hands(top)
	top = null
	playsound(src.loc, /singleton/sound_category/shaker_lid_off, 50, 1)
	update_icon()

/obj/item/shaker_top
	name = "shaker top"
	desc = "A metal shaker top with an in-built filter on the bottom."
	desc_info = "When fitted on a shaker, you can Alt Click the shaker to change transfer amount of the shaker."
	icon = 'icons/obj/shaker.dmi'
	icon_state = "shaker_top"
	item_state = "shaker_top"
	contained_sprite = TRUE
	drop_sound = 'sound/items/drop/bottle.ogg'
	pickup_sound = null
	center_of_mass = list("x" = 16, "y" = 16)

/obj/item/reagent_containers/food/drinks/shaker_cup
	name = "shaker cap"
	desc = "A metal shaker cap that also doubles as a metal cup to measure liquids, or to drink from."
	desc_info = "Alt Click the cap to change the transfer amount."
	icon = 'icons/obj/shaker.dmi'
	icon_state = "shaker_cup"
	item_state = "shaker_cup"
	contained_sprite = TRUE
	filling_states = "50;100"
	pickup_sound = null
	volume = 10
	possible_transfer_amounts = list(1,2,3,4,5,10)
	center_of_mass = list("x" = 16, "y" = 16)

/obj/item/reagent_containers/food/drinks/shaker_cup/update_icon()
	cut_overlays()

	if(reagents?.total_volume)
		var/mutable_appearance/filling = mutable_appearance('icons/obj/shaker.dmi', "[icon_state]-[get_filling_state()]")
		filling.color = reagents.get_color()
		add_overlay(filling)

/obj/item/reagent_containers/food/drinks/shaker_cup/AltClick(mob/user)
	set_APTFT()

/obj/item/reagent_containers/food/drinks/britcup
	name = "cup"
	desc = "A cup with the British flag emblazoned on it."
	icon_state = "britcup"
	volume = 30
	center_of_mass = list("x"=15, "y"=13)

/obj/item/reagent_containers/food/drinks/boba
	name = "boba pearls"
	desc = "Tapioca balls, so you can eat your drinks! Yum yum!" // the yum yum is sarcastic these things feel like chewing on rubber.
	icon_state = "boba"
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/drink/boba = 60)
	is_liquid = FALSE
