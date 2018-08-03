
///////////////////////////////////////////////Condiments
//Notes by Darem: The condiments food-subtype is for stuff you don't actually eat but you use to modify existing food. They all
//	leave empty containers when used up and can be filled/re-filled with other items. Formatting for first section is identical
//	to mixed-drinks code. If you want an object that starts pre-loaded, you need to make it in addition to the other code.

//Food items that aren't eaten normally and leave an empty container behind.
/obj/item/weapon/reagent_containers/food/condiment
	name = "condiment container"
	desc = "Just your average condiment container."
	icon = 'icons/obj/food.dmi'
	icon_state = "emptycondiment"
	flags = OPENCONTAINER
	possible_transfer_amounts = list(1,5,10)
	center_of_mass = list("x"=16, "y"=6)
	volume = 50

/obj/item/weapon/reagent_containers/food/condiment/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	return

/obj/item/weapon/reagent_containers/food/condiment/attack_self(var/mob/user as mob)
	return

/obj/item/weapon/reagent_containers/food/condiment/attack(var/mob/M as mob, var/mob/user as mob, var/def_zone)
	if(standard_feed_mob(user, M))
		return

/obj/item/weapon/reagent_containers/food/condiment/afterattack(var/obj/target, var/mob/user, var/proximity)
	if(!proximity)
		return

	if(standard_dispenser_refill(user, target))
		return
	if(standard_pour_into(user, target))
		return

	if(istype(target, /obj/item/weapon/reagent_containers/food/snacks)) // These are not opencontainers but we can transfer to them
		if(!reagents || !reagents.total_volume)
			user << "<span class='notice'>There is no condiment left in \the [src].</span>"
			return

		if(!target.reagents.get_free_space())
			user << "<span class='notice'>You can't add more condiment to \the [target].</span>"
			return

		var/trans = reagents.trans_to_obj(target, amount_per_transfer_from_this)
		user << "<span class='notice'>You add [trans] units of the condiment to \the [target].</span>"

/obj/item/weapon/reagent_containers/food/condiment/feed_sound(var/mob/user)
	playsound(user.loc, 'sound/items/drink.ogg', rand(10, 50), 1)

/obj/item/weapon/reagent_containers/food/condiment/self_feed_message(var/mob/user)
	user << "<span class='notice'>You swallow some of contents of \the [src].</span>"

/obj/item/weapon/reagent_containers/food/condiment/on_reagent_change()
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
				center_of_mass = list("x"=16, "y"=10)
			if("blackpepper")
				name = "pepper mill"
				desc = "Often used to flavor food or make people sneeze."
				icon_state = "peppermillsmall"
				center_of_mass = list("x"=16, "y"=10)
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
				center_of_mass = list("x"=16, "y"=6)
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
				name = "misc condiment bottle"
				if (reagents.reagent_list.len==1)
					desc = "Looks like it is [reagents.get_master_reagent_name()], but you are not sure."
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

/obj/item/weapon/reagent_containers/food/condiment/enzyme
	name = "universal enzyme"
	desc = "Used in cooking various dishes."
	icon_state = "enzyme"

/obj/item/weapon/reagent_containers/food/condiment/enzyme/Initialize()
	. = ..()
	reagents.add_reagent("enzyme", 50)

/obj/item/weapon/reagent_containers/food/condiment/sugar
	name = "sugar"
	desc = "Tastey space sugar!"

/obj/item/weapon/reagent_containers/food/condiment/sugar/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 50)

/obj/item/weapon/reagent_containers/food/condiment/saltshaker		//Seperate from above since it's a small shaker rather then
	name = "salt shaker"											//	a large one.
	desc = "Salt. From space oceans, presumably."
	icon_state = "saltshakersmall"
	possible_transfer_amounts = list(1,20) //for clown turning the lid off
	amount_per_transfer_from_this = 1
	volume = 20

/obj/item/weapon/reagent_containers/food/condiment/saltshaker/Initialize()
	. = ..()
	reagents.add_reagent("sodiumchloride", 20)

/obj/item/weapon/reagent_containers/food/condiment/peppermill
	name = "pepper mill"
	desc = "Often used to flavor food or make people sneeze."
	icon_state = "peppermillsmall"
	possible_transfer_amounts = list(1,20) //for clown turning the lid off
	amount_per_transfer_from_this = 1
	volume = 20

/obj/item/weapon/reagent_containers/food/condiment/peppermill/Initialize()
	. = ..()
	reagents.add_reagent("blackpepper", 20)

/obj/item/weapon/reagent_containers/food/condiment/flour
	name = "flour sack"
	desc = "A big bag of flour. Good for baking!"
	icon = 'icons/obj/food.dmi'
	icon_state = "flour"
	item_state = "flour"
	volume = 220

/obj/item/weapon/reagent_containers/food/condiment/flour/Initialize()
	. = ..()
	reagents.add_reagent("flour", 200)
	src.pixel_x = rand(-10.0, 10)
	src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/food/condiment/spacespice
	name = "space spices"
	desc = "An exotic blend of spices for cooking. It must flow."
	icon_state = "spacespicebottle"
	possible_transfer_amounts = list(1,40) //for clown turning the lid off
	amount_per_transfer_from_this = 1
	volume = 40

/obj/item/weapon/reagent_containers/food/condiment/spacespice/Initialize()
	. = ..()
	reagents.add_reagent("spacespice", 40)

/obj/item/weapon/reagent_containers/food/condiment/barbecue
	name = "barbecue sauce"
	desc = "Barbecue sauce, it's labeled 'sweet and spicy'."
	icon_state = "barbecue"

/obj/item/weapon/reagent_containers/food/condiment/barbecue/Initialize()
	..()
	reagents.add_reagent("barbecue", 50)

/obj/item/weapon/reagent_containers/food/condiment/garlicsauce
	name = "garlic sauce"
	desc = "Garlic sauce, perfect for spicing up a plate of garlic."

/obj/item/weapon/reagent_containers/food/condiment/garlicsauce/Initialize()
	..()
	reagents.add_reagent("garlicsauce", 50)