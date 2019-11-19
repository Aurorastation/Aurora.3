////////////////////////////////////////////////////////////////////////////////
/// Drinks.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/food/drinks
	name = "drink"
	desc = "yummy"
	icon = 'icons/obj/drinks.dmi'
	drop_sound = 'sound/items/drop/bottle.ogg'
	icon_state = null
	flags = OPENCONTAINER
	amount_per_transfer_from_this = 5
	volume = 50
	var/shaken = 0

/obj/item/reagent_containers/food/drinks/on_reagent_change()
	return

/obj/item/reagent_containers/food/drinks/feed_sound(var/mob/user)
	playsound(user.loc, 'sound/items/drink.ogg', rand(10, 50), 1)

/obj/item/reagent_containers/food/drinks/self_feed_message(var/mob/user)
	to_chat(user, "<span class='notice'>You drink from \the [src].</span>")

/obj/item/reagent_containers/food/drinks/attack_self(mob/user as mob)
	if(!is_open_container())
		if(user.a_intent == I_HURT && !shaken)
			shaken = 1
			user.visible_message("[user] shakes \the [src]!", "You shake \the [src]!")
			playsound(loc,'sound/items/soda_shaking.ogg', rand(10,50), 1)
			return
		if(shaken)
			for(var/datum/reagent/R in reagents.reagent_list)
				if(R.carbonated)
					boom(user)
					return
		open(user)

/obj/item/reagent_containers/food/drinks/proc/open(mob/user as mob)
	playsound(loc,'sound/effects/canopen.ogg', rand(10,50), 1)
	user.visible_message("[user] opens the [src].", "You open \the [src] with an audible pop!", "You can hear a pop,")
	flags |= OPENCONTAINER

/obj/item/reagent_containers/food/drinks/proc/boom(mob/user as mob)
	user.visible_message("<span class='danger'>\The [src] explodes all over [user] as they open it!</span>","<span class='danger'>\The [src] explodes all over you as you open it!</span>","You can hear a soda can explode.")
	playsound(loc,'sound/items/soda_burst.ogg', rand(20,50), 1)
	reagents.clear_reagents()
	flags |= OPENCONTAINER
	shaken = 0

/obj/item/reagent_containers/food/drinks/attack(mob/M as mob, mob/user as mob, def_zone)
	if(force && !(flags & NOBLUDGEON) && user.a_intent == I_HURT)
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

/obj/item/reagent_containers/food/drinks/examine(mob/user)
	if(!..(user, 1))
		return
	if(!reagents || reagents.total_volume == 0)
		to_chat(user, "<span class='notice'>\The [src] is empty!</span>")
	else if (reagents.total_volume <= volume * 0.25)
		to_chat(user, "<span class='notice'>\The [src] is almost empty!</span>")
	else if (reagents.total_volume <= volume * 0.66)
		to_chat(user, "<span class='notice'>\The [src] is half full!</span>")
	else if (reagents.total_volume <= volume * 0.90)
		to_chat(user, "<span class='notice'>\The [src] is almost full!</span>")
	else
		to_chat(user, "<span class='notice'>\The [src] is full!</span>")


////////////////////////////////////////////////////////////////////////////////
/// Drinks. END
////////////////////////////////////////////////////////////////////////////////

/obj/item/reagent_containers/food/drinks/golden_cup
	desc = "A golden cup"
	name = "golden cup"
	icon_state = "golden_cup"
	item_state = "" //nope :(
	w_class = 4
	force = 14
	throwforce = 10
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = null
	volume = 150
	flags = CONDUCT | OPENCONTAINER

///////////////////////////////////////////////Drinks
//Notes by Darem: Drinks are simply containers that start preloaded. Unlike condiments, the contents can be ingested directly
//	rather then having to add it to something else first. They should only contain liquids. They have a default container size of 50.
//	Formatting is the same as food.

/obj/item/reagent_containers/food/drinks/milk
	name = "space milk"
	desc = "It's milk. White and nutritious goodness!"
	icon_state = "milk"
	item_state = "carton"
	drop_sound = 'sound/items/drop/box.ogg'
	center_of_mass = list("x"=16, "y"=9)
	Initialize()
		. = ..()
		reagents.add_reagent("milk", 50)

/obj/item/reagent_containers/food/drinks/soymilk
	name = "soymilk"
	desc = "It's soy milk. White and nutritious goodness!"
	icon_state = "soymilk"
	item_state = "carton"
	drop_sound = 'sound/items/drop/box.ogg'
	center_of_mass = list("x"=16, "y"=9)
	Initialize()
		. = ..()
		reagents.add_reagent("soymilk", 50)

/obj/item/reagent_containers/food/drinks/coffee
	name = "Robust coffee"
	desc = "Careful, the beverage you're about to enjoy is extremely hot."
	icon_state = "coffee"
	item_state = "contvapour"
	drop_sound = 'sound/items/drop/box.ogg'
	center_of_mass = list("x"=16, "y"=11)
	Initialize()
		. = ..()
		reagents.add_reagent("coffee", 30)

/obj/item/reagent_containers/food/drinks/pslatte
	name = "Seasonal Pumpkin Spice Latte"
	desc = "A limited edition pumpkin spice coffee drink!"
	icon_state = "psl_vended"
	drop_sound = 'sound/items/drop/box.ogg'
	center_of_mass = list("x"=16, "y"=11)
	Initialize()
		. = ..()
		reagents.add_reagent("sadpslatte", 30)

/obj/item/reagent_containers/food/drinks/tea
	name = "Duke purple tea"
	desc = "An insult to Duke Purple is an insult to the Space Queen! Any proper gentleman will fight you, if you sully this tea."
	icon_state = "coffee"
	item_state = "coffee"
	center_of_mass = list("x"=16, "y"=14)
	Initialize()
		. = ..()
		reagents.add_reagent("tea", 30)

/obj/item/reagent_containers/food/drinks/greentea
	name = "Green Tea"
	desc = "Tasty green tea. It's good for you!"
	icon_state = "greentea_vended"
	item_state = "coffee"
	center_of_mass = list("x"=16, "y"=14)
	Initialize()
		. = ..()
		reagents.add_reagent("greentea", 30)

/obj/item/reagent_containers/food/drinks/hotcider
	name = "Hot Cider"
	desc = "A hearty apple drink, spiced just right."
	icon_state = "soy_latte"
	item_state = "coffee"
	center_of_mass = list("x"=16, "y"=14)
	Initialize()
		. = ..()
		reagents.add_reagent("ciderhot", 30)

/obj/item/reagent_containers/food/drinks/chaitea
	name = "Chai Tea"
	desc = "The name is redundant but the flavor is delicious!"
	icon_state = "chai_vended"
	item_state = "coffee"
	center_of_mass = list("x"=16, "y"=14)
	Initialize()
		. = ..()
		reagents.add_reagent("chaitea", 30)

/obj/item/reagent_containers/food/drinks/ice
	name = "ice cup"
	desc = "Careful, cold ice, do not chew."
	icon_state = "coffee"
	center_of_mass = list("x"=15, "y"=10)
	Initialize()
		. = ..()
		reagents.add_reagent("ice", 30)

/obj/item/reagent_containers/food/drinks/h_chocolate
	name = "dutch hot coco"
	desc = "Made in Space South America."
	icon_state = "hot_coco"
	item_state = "coffee"
	center_of_mass = list("x"=15, "y"=13)
	Initialize()
		. = ..()
		reagents.add_reagent("hot_coco", 30)

/obj/item/reagent_containers/food/drinks/dry_ramen
	name = "cup ramen"
	desc = "Just add 10ml water, self heats! A taste that reminds you of your school years."
	icon_state = "ramen"
	center_of_mass = list("x"=16, "y"=11)
	Initialize()
		. = ..()
		reagents.add_reagent("dry_ramen", 30)


/obj/item/reagent_containers/food/drinks/sillycup
	name = "paper cup"
	desc = "A paper water cup."
	icon_state = "water_cup_e"
	drop_sound = 'sound/items/drop/paper.ogg'
	possible_transfer_amounts = null
	volume = 10
	center_of_mass = list("x"=16, "y"=12)
	Initialize()
		. = ..()
	on_reagent_change()
		if(reagents.total_volume)
			icon_state = "water_cup"
		else
			icon_state = "water_cup_e"

/obj/item/reagent_containers/food/drinks/medcup
	name = "medicine cup"
	desc = "A plastic medicine cup. Like a shot glass for medicine."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "medcup"
	drop_sound = 'sound/items/drop/glass.ogg'
	possible_transfer_amounts = null
	volume = 15

/obj/item/reagent_containers/food/drinks/medcup/on_reagent_change()
	update_icon()

/obj/item/reagent_containers/food/drinks/medcup/pickup(mob/user)
	..()
	update_icon()

/obj/item/reagent_containers/food/drinks/medcup/dropped(mob/user)
	..()
	update_icon()

/obj/item/reagent_containers/food/drinks/medcup/update_icon()
	cut_overlays()

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/reagentfillings.dmi', src, "[icon_state]25")

		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent) // offset by about 12.5 so it seems more gradual
			if(0 to 37)
				filling.icon_state = "[icon_state]25"
			if(38 to 62)
				filling.icon_state = "[icon_state]50"
			if(63 to 87)
				filling.icon_state = "[icon_state]75"
			if(87 to INFINITY)
				filling.icon_state = "[icon_state]100"

		filling.color = reagents.get_color()
		add_overlay(filling)

//////////////////////////drinkingglass and shaker//
//Note by Darem: This code handles the mixing of drinks. New drinks go in three places: In Chemistry-Reagents.dm (for the drink
//	itself), in Chemistry-Recipes.dm (for the reaction that changes the components into the drink), and here (for the drinking glass
//	icon states.

/obj/item/reagent_containers/food/drinks/shaker
	name = "shaker"
	desc = "A metal shaker to mix drinks in."
	icon_state = "shaker"
	amount_per_transfer_from_this = 10
	volume = 120
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/teapot
	name = "teapot"
	desc = "An elegant teapot. It simply oozes class."
	icon_state = "teapot"
	item_state = "teapot"
	amount_per_transfer_from_this = 10
	volume = 120
	center_of_mass = list("x"=17, "y"=7)

/obj/item/reagent_containers/food/drinks/flask
	name = "captain's flask"
	desc = "A metal flask belonging to the captain"
	icon_state = "flask"
	volume = 60
	center_of_mass = list("x"=17, "y"=7)

/obj/item/reagent_containers/food/drinks/flask/shiny
	name = "shiny flask"
	desc = "A shiny metal flask. It appears to have a Greek symbol inscribed on it."
	icon_state = "shinyflask"

/obj/item/reagent_containers/food/drinks/flask/lithium
	name = "lithium flask"
	desc = "A flask with a Lithium Atom symbol on it."
	icon_state = "lithiumflask"

/obj/item/reagent_containers/food/drinks/flask/detflask
	name = "detective's flask"
	desc = "A metal flask with a leather band and golden badge belonging to the detective."
	icon_state = "detflask"
	volume = 60
	center_of_mass = list("x"=17, "y"=8)

/obj/item/reagent_containers/food/drinks/flask/barflask
	name = "flask"
	desc = "For those who can't be bothered to hang out at the bar to drink."
	icon_state = "barflask"
	volume = 60
	center_of_mass = list("x"=17, "y"=7)

/obj/item/reagent_containers/food/drinks/flask/vacuumflask
	name = "vacuum flask"
	desc = "Keeping your drinks at the perfect temperature since 1892."
	icon_state = "vacuumflask"
	volume = 60
	center_of_mass = list("x"=15, "y"=4)

/obj/item/reagent_containers/food/drinks/britcup
	name = "cup"
	desc = "A cup with the British flag emblazoned on it."
	icon_state = "britcup"
	volume = 30
	center_of_mass = list("x"=15, "y"=13)
