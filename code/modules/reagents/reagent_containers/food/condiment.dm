
///////////////////////////////////////////////Condiments
//Notes by Darem: The condiments food-subtype is for stuff you don't actually eat but you use to modify existing food. They all
//	leave empty containers when used up and can be filled/re-filled with other items. Formatting for first section is identical
//	to mixed-drinks code. If you want an object that starts pre-loaded, you need to make it in addition to the other code.

//Food items that aren't eaten normally and leave an empty container behind.
/obj/item/reagent_containers/food/condiment
	name = "condiment container"
	desc = "Just your average condiment container."
	icon = 'icons/obj/food.dmi'
	icon_state = "emptycondiment"
	flags = OPENCONTAINER
	possible_transfer_amounts = list(1,5,10)
	center_of_mass = list("x"=16, "y"=6)
	volume = 50
	var/next_shake

/obj/item/reagent_containers/food/condiment/proc/shake(var/mob/user)
	if(world.time >= next_shake)
		if(reagents.total_volume > 0)
			user.visible_message(pick(SPAN_NOTICE("[user] shakes \the [src]."), SPAN_NOTICE("[user] gives \the [src] a good shake.")), SPAN_NOTICE("You give \the [src] a good shake."))
			playsound(get_turf(src),'sound/items/condiment_shaking.ogg', rand(10,50), 1)
		else
			user.visible_message(pick(SPAN_NOTICE("[user] shakes \the [src], but it makes no noise."), SPAN_NOTICE("[user] gives \the [src] a good shake, but it makes no noise.")), SPAN_NOTICE("You give \the [src] a good shake, but it makes no noise."))
		next_shake = world.time + 30

/obj/item/reagent_containers/food/condiment/feed_sound(var/mob/user)
	playsound(user.loc, 'sound/items/drink.ogg', rand(10, 50), 1)

/obj/item/reagent_containers/food/condiment/self_feed_message(var/mob/user)
	to_chat(user, "<span class='notice'>You swallow some of contents of \the [src].</span>")

/obj/item/reagent_containers/food/condiment/on_reagent_change()
	if(icon_state == "saltshakersmall" || icon_state == "peppermillsmall" || icon_state == "flour" || icon_state == "spacespicebottle")
		return
	if(reagents.reagent_list.len > 0)
		switch(reagents.get_master_reagent_id())
			if("ketchup")
				name = "ketchup"
				desc = "You feel more American already."
				icon_state = "ketchup"
				center_of_mass = list("x"=16, "y"=6)
			if("capsaicin")
				name = "hotsauce"
				desc = "You can almost TASTE the stomach ulcers now!"
				icon_state = "hotsauce"
				center_of_mass = list("x"=16, "y"=6)
			if("enzyme")
				name = "universal enzyme"
				desc = "Used in cooking various dishes."
				icon_state = "enzyme"
				center_of_mass = list("x"=16, "y"=6)
			if("soysauce")
				name = "soy sauce"
				desc = "A salty soy-based flavoring."
				icon_state = "soysauce"
				center_of_mass = list("x"=16, "y"=6)
			if("frostoil")
				name = "coldsauce"
				desc = "Leaves the tongue numb in its passage."
				icon_state = "coldsauce"
				center_of_mass = list("x"=16, "y"=6)
			if("sodiumchloride")
				name = "salt shaker"
				desc = "Salt. From space oceans, presumably."
				icon_state = "saltshaker"
				center_of_mass = list("x"=17, "y"=11)
			if("blackpepper")
				name = "pepper mill"
				desc = "Often used to flavor food or make people sneeze."
				icon_state = "peppermillsmall"
				center_of_mass = list("x"=17, "y"=11)
			if("cornoil")
				name = "corn oil"
				desc = "A delicious oil used in cooking. Made from corn."
				icon_state = "oliveoil"
				center_of_mass = list("x"=16, "y"=6)
			if("sugar")
				name = "sugar"
				desc = "Tastey space sugar!"
				center_of_mass = list("x"=16, "y"=6)
			if("spacespice")
				name = "bottle of space spice"
				desc = "An exotic blend of spices for cooking. It must flow."
				icon_state = "spacespicebottle"
				center_of_mass = list("x"=16, "y"=10)
			if("barbecue")
				name = "barbecue sauce"
				desc = "Barbecue sauce, it's labeled 'sweet and spicy'."
				icon_state = "barbecue"
				center_of_mass = list("x"=16, "y"=6)
			if("garlicsauce")
				name = "garlic sauce"
				desc = "Garlic sauce, perfect for spicing up a plate of garlic."
				center_of_mass = list("x"=16, "y"=6)
			else
				desc = "A mixture of various condiments. [reagents.get_master_reagent_name()] is one of them."
				icon_state = "mixedcondiments"
				center_of_mass = list("x"=16, "y"=6)
	else
		icon_state = "emptycondiment"
		name = "condiment bottle"
		desc = "An empty condiment bottle."
		center_of_mass = list("x"=16, "y"=6)
		return

/obj/item/reagent_containers/food/condiment/enzyme
	name = "universal enzyme"
	desc = "Used in cooking various dishes."
	icon_state = "enzyme"
	center_of_mass = list("x"=16, "y"=6)

/obj/item/reagent_containers/food/condiment/enzyme/Initialize()
	. = ..()
	reagents.add_reagent("enzyme", 50)

/obj/item/reagent_containers/food/condiment/sugar
	name = "sugar"
	desc = "Tastey space sugar!"
	center_of_mass = list("x"=16, "y"=6)

/obj/item/reagent_containers/food/condiment/sugar/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 50)

/obj/item/reagent_containers/food/condiment/saltshaker		//Seperate from above since it's a small shaker rather then
	name = "salt shaker"											//	a large one.
	desc = "Salt. From space oceans, presumably."
	icon_state = "saltshakersmall"
	center_of_mass = list("x"=17, "y"=11)
	possible_transfer_amounts = list(1,20) //for clown turning the lid off
	amount_per_transfer_from_this = 1
	volume = 20

/obj/item/reagent_containers/food/condiment/saltshaker/attack_self(mob/user)
	shake(user)

/obj/item/reagent_containers/food/condiment/saltshaker/Initialize()
	. = ..()
	reagents.add_reagent("sodiumchloride", 20)

/obj/item/reagent_containers/food/condiment/peppermill
	name = "pepper mill"
	desc = "Often used to flavor food or make people sneeze."
	icon_state = "peppermillsmall"
	center_of_mass = list("x"=17, "y"=11)
	possible_transfer_amounts = list(1,20) //for clown turning the lid off
	amount_per_transfer_from_this = 1
	volume = 20

/obj/item/reagent_containers/food/condiment/peppermill/attack_self(mob/user)
	shake(user)

/obj/item/reagent_containers/food/condiment/peppermill/Initialize()
	. = ..()
	reagents.add_reagent("blackpepper", 20)

/obj/item/reagent_containers/food/condiment/flour
	name = "flour sack"
	desc = "A big bag of flour. Good for baking!"
	icon = 'icons/obj/food.dmi'
	icon_state = "flour"
	item_state = "flour"
	center_of_mass = list("x"=16, "y"=8)
	volume = 220

/obj/item/reagent_containers/food/condiment/flour/Initialize()
	. = ..()
	reagents.add_reagent("flour", 200)
	randpixel_xy()

/obj/item/reagent_containers/food/condiment/spacespice
	name = "space spices"
	desc = "An exotic blend of spices for cooking. It must flow."
	icon_state = "spacespicebottle"
	center_of_mass = list("x"=16, "y"=10)
	possible_transfer_amounts = list(1,40) //for clown turning the lid off
	amount_per_transfer_from_this = 1
	volume = 40

/obj/item/reagent_containers/food/condiment/spacespice/attack_self(mob/user)
	shake(user)

/obj/item/reagent_containers/food/condiment/spacespice/Initialize()
	. = ..()
	reagents.add_reagent("spacespice", 40)

/obj/item/reagent_containers/food/condiment/barbecue
	name = "barbecue sauce"
	desc = "Barbecue sauce, it's labeled 'sweet and spicy'."
	icon_state = "barbecue"
	center_of_mass = list("x"=16, "y"=6)

/obj/item/reagent_containers/food/condiment/barbecue/Initialize()
	..()
	reagents.add_reagent("barbecue", 50)

/obj/item/reagent_containers/food/condiment/garlicsauce
	name = "garlic sauce"
	desc = "Garlic sauce, perfect for spicing up a plate of garlic."
	center_of_mass = list("x"=16, "y"=6)

/obj/item/reagent_containers/food/condiment/garlicsauce/Initialize()
	..()
	reagents.add_reagent("garlicsauce", 50)
