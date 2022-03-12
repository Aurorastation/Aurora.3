/*
Standards for trash/empty states under the /drinks path:
Adding Empty States: Trash/Empty states should be placed in the drinks_empty.dmi and should be the drink's icon_state name followed by _empty (ex: whiskeybottle_empty) and the NO_EMPTY_ICON flag should be removed.
If your trash state applies to multiple drinks, to avoid duplicating sprites, use UNIQUE_EMPTY_ICON and set the empty_icon_state var to that icon state. These will still need to be placed in drinks_empty.dmi
If you add a drink with no empty icon sprite, ensure it is flagged as NO_EMPTY_ICON, else it will turn invisible when empty.
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
	flags = OPENCONTAINER
	amount_per_transfer_from_this = 5
	volume = 50
	var/shaken = 0
	var/drink_flags = NO_EMPTY_ICON
	var/empty_icon_state = null	//This icon_state should be the one set in drinks_empty.dmi and ONLY if it's a UNIQUE_EMPTY_ICON

/obj/item/reagent_containers/food/drinks/Initialize()
	. = ..()
	if(drink_flags & IS_GLASS)
		unacidable = TRUE

/obj/item/reagent_containers/food/drinks/on_reagent_change()
	update_icon()

/obj/item/reagent_containers/food/drinks/on_rag_wipe(var/obj/item/reagent_containers/glass/rag/R)
	clean_blood()

/obj/item/reagent_containers/food/drinks/update_icon()
	if(!reagents.total_volume)
		if(drink_flags & UNIQUE_EMPTY_ICON)
			icon = 'icons/obj/drinks_empty.dmi'
			icon_state = empty_icon_state
		else if(drink_flags & UNIQUE_EMPTY_ICON_FILE)
			icon_state = empty_icon_state
		else if(!(drink_flags & NO_EMPTY_ICON))
			icon = 'icons/obj/drinks_empty.dmi'
			icon_state = "[initial(icon_state)]_empty"
	else
		icon = initial(icon)	//Necessary for refilling empty drinks
		icon_state = initial(icon_state)

/obj/item/reagent_containers/food/drinks/attack_self(mob/user as mob)
	if(!is_open_container())
		if(user.a_intent == I_HURT && !shaken)
			shaken = 1
			user.visible_message("[user] shakes \the [src]!", "You shake \the [src]!")
			playsound(loc,'sound/items/soda_shaking.ogg', rand(10,50), 1)
			return
		if(shaken)
			for(var/_R in reagents.reagent_volumes)
				var/decl/reagent/R = decls_repository.get_decl(_R)
				if(R.carbonated)
					boom(user)
					return
		open(user)

/obj/item/reagent_containers/food/drinks/proc/open(mob/user as mob)
	playsound(loc,'sound/items/soda_open.ogg', rand(10,50), 1)
	user.visible_message("<b>[user]</b> opens \the [src].", SPAN_NOTICE("You open \the [src] with an audible pop!"), "You can hear a pop.")
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
	item_state = "" //nope :[
	w_class = ITEMSIZE_LARGE
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
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'
	center_of_mass = list("x"=16, "y"=9)
	reagents_to_add = list(/decl/reagent/drink/milk = 50)

/obj/item/reagent_containers/food/drinks/soymilk
	name = "soymilk"
	desc = "It's soy milk. White and nutritious goodness!"
	icon_state = "soymilk"
	item_state = "carton"
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'
	center_of_mass = list("x"=16, "y"=9)
	reagents_to_add = list(/decl/reagent/drink/milk/soymilk = 50)

/obj/item/reagent_containers/food/drinks/coffee
	name = "\improper Martian Dark Roast"
	desc = "The darkest roast this side of Olympia, guaranteed."
	icon_state = "coffee_vended"
	item_state = "coffee"
	trash = /obj/item/trash/coffee
	drink_flags = null
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/decl/reagent/drink/coffee = 30)

/obj/item/reagent_containers/food/drinks/pslatte
	name = "seasonal pumpkin spice latte"
	desc = "A limited edition pumpkin spice coffee drink!"
	icon_state = "psl_vended"
	item_state = "coffee"
	trash = /obj/item/trash/coffee
	drink_flags = UNIQUE_EMPTY_ICON
	empty_icon_state = "coffee_vended_empty"
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/decl/reagent/drink/coffee/sadpslatte = 30)

/obj/item/reagent_containers/food/drinks/tea
	name = "\improper Sol-III tea"
	desc = "A hot tea with an \"Earthy\" flavor that's much weaker than it claims to be on the cup."
	icon_state = "coffee_vended"
	item_state = "coffee"
	trash = /obj/item/trash/coffee
	drink_flags = null
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'
	center_of_mass = list("x"=16, "y"=14)
	reagents_to_add = list(/decl/reagent/drink/tea = 30)

/obj/item/reagent_containers/food/drinks/greentea
	name = "green tea"
	desc = "Tasty green tea. It's good for you!"
	icon_state = "greentea_vended"
	item_state = "coffee"
	trash = /obj/item/trash/coffee
	drink_flags = UNIQUE_EMPTY_ICON
	empty_icon_state = "coffee_vended_empty"
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'
	center_of_mass = list("x"=16, "y"=14)
	reagents_to_add = list(/decl/reagent/drink/tea/greentea = 30)

/obj/item/reagent_containers/food/drinks/hotcider
	name = "hot cider"
	desc = "A hearty apple drink, spiced just right."
	icon_state = "soy_latte_vended"
	item_state = "coffee"
	trash = /obj/item/trash/coffee
	drink_flags = UNIQUE_EMPTY_ICON
	empty_icon_state = "coffee_vended_empty"
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'
	center_of_mass = list("x"=16, "y"=14)
	reagents_to_add = list(/decl/reagent/drink/ciderhot = 30)

/obj/item/reagent_containers/food/drinks/chaitea
	name = "chai tea"
	desc = "The name is redundant but the flavor is delicious!"
	icon_state = "chai_vended"
	item_state = "coffee"
	trash = /obj/item/trash/coffee
	drink_flags = UNIQUE_EMPTY_ICON
	empty_icon_state = "coffee_vended_empty"
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'
	center_of_mass = list("x"=16, "y"=14)
	reagents_to_add = list(/decl/reagent/drink/tea/chaitea = 30)

/obj/item/reagent_containers/food/drinks/ice
	name = "\improper Admiral's ice cup"
	desc = "Solid water served in an official Getmore-brand disposable collector's cup, each one commemorating a late admiral."
	icon_state = "coffee_vended"
	item_state = "coffee"
	trash = /obj/item/trash/coffee
	drink_flags = null
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'
	center_of_mass = list("x"=15, "y"=10)
	reagents_to_add = list(/decl/reagent/drink/ice = 30)

/obj/item/reagent_containers/food/drinks/h_chocolate
	name = "\improper Red Gaia hot coco"
	desc = "A Mars favorite. Usually dispensed at a temperature hotter than any human can stand."
	icon_state = "coffee_vended"
	item_state = "coffee"
	trash = /obj/item/trash/coffee
	drink_flags = null
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'
	center_of_mass = list("x"=15, "y"=13)
	reagents_to_add = list(/decl/reagent/drink/hot_coco = 30)

/obj/item/reagent_containers/food/drinks/dry_ramen
	name = "cup ramen"
	desc = "Just add 10ml water, self heats! A taste that reminds you of your school years."
	icon_state = "ramen"
	item_state = "coffee"
	trash = /obj/item/trash/ramen
	drink_flags = null
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/decl/reagent/drink/dry_ramen = 30)
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
	desc_fluff = "Previously introduced to the vending machines by Skrellian request, this water used to come straight from the Martian poles. Ever since the Martian catastrophe, however, an Idris subsidiary has since stepped in to fill the gap in the market \
	and 'Martian Water' has become a prized collector's item."
	icon_state = "waterbottle"
	flags = 0 //starts closed
	center_of_mass = list("x"=16, "y"=8)
	drop_sound = 'sound/items/drop/disk.ogg'
	pickup_sound = 'sound/items/pickup/disk.ogg'

	reagents_to_add = list(/decl/reagent/water = 30)

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

/obj/item/reagent_containers/food/drinks/medcup
	name = "medicine cup"
	desc = "A plastic medicine cup. Like a shot glass for medicine."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "medcup"
	filling_states = "25;50;75;100"
	drop_sound = 'sound/items/drop/drinkglass.ogg'
	pickup_sound = 'sound/items/pickup/drinkglass.ogg'
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

//////////////////////////JUICES AND STUFF ///////////////////////

/obj/item/reagent_containers/food/drinks/carton
	name = "carton"
	desc = "An abstract way to organize bottles that are really cartons. Finally!"
	icon_state = "carton"
	volume = 100
	center_of_mass = list("x"=16, "y"=6)
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'

/obj/item/reagent_containers/food/drinks/carton/orangejuice
	name = "orange juice"
	desc = "Full of vitamins and deliciousness!"
	icon_state = "orangejuice"

	reagents_to_add = list(/decl/reagent/drink/orangejuice = 100)

/obj/item/reagent_containers/food/drinks/carton/cream
	name = "milk cream"
	desc = "It's cream. Made from milk. What else did you think you'd find in there?"
	icon_state = "cream"

	reagents_to_add = list(/decl/reagent/drink/milk/cream = 100)

/obj/item/reagent_containers/food/drinks/carton/tomatojuice
	name = "tomato juice"
	desc = "Well, at least it LOOKS like tomato juice. You can't tell with all that redness."
	icon_state = "tomatojuice"

	reagents_to_add = list(/decl/reagent/drink/tomatojuice = 100)

/obj/item/reagent_containers/food/drinks/carton/limejuice
	name = "lime juice"
	desc = "Sweet-sour goodness."
	icon_state = "limejuice"

	reagents_to_add = list(/decl/reagent/drink/limejuice = 100)

/obj/item/reagent_containers/food/drinks/carton/lemonjuice
	name = "lemon juice"
	desc = "This juice is VERY sour."
	icon_state = "lemoncarton"

	reagents_to_add = list(/decl/reagent/drink/lemonjuice = 100)

/obj/item/reagent_containers/food/drinks/carton/dynjuice
	name = "dyn juice"
	desc = "Juice from a Skrell medicinal herb. It's supposed to be diluted."
	icon_state = "dyncarton"

	reagents_to_add = list(/decl/reagent/drink/dynjuice = 100)

/obj/item/reagent_containers/food/drinks/carton/applejuice
	name = "apple juice"
	desc = "Juice from an apple. Yes."
	icon_state = "applejuice"

	reagents_to_add = list(/decl/reagent/drink/applejuice = 100)

/obj/item/reagent_containers/food/drinks/carton/fatshouters
	name = "fatshouters milk carton"
	desc = "Fatty fatshouters milk in a carton."

	reagents_to_add = list(/decl/reagent/drink/milk/adhomai = 100)

/obj/item/reagent_containers/food/drinks/carton/mutthir
	name = "mutthir carton"
	icon_state = "mutthir"
	desc = "A beverage made with Fatshouters' yogurt mixed with Nm’shaan's sugar and sweet herbs."
	desc_fluff = "A beverage made with Fatshouters' yogurt mixed with Nm’shaan's sugar and sweet herbs. Mutthir is usually consumed during meals by both nobles and commoners. \
	The drink can also be smoked for flavor. Mutthir is believed to have originated from the worldwide appreciated Fatshouters' fermented milk. Rock Nomads living in the Nomadic Host \
	were quick to adopt the drink to their diet."

	reagents_to_add = list(/decl/reagent/drink/milk/adhomai/mutthir = 100)

//////////////////////////drinkingglass and shaker//
//Note by Darem: This code handles the mixing of drinks. New drinks go in three places: In Chemistry-Reagents.dm (for the drink
//	itself), in Chemistry-Recipes.dm (for the reaction that changes the components into the drink), and here (for the drinking glass
//	icon states.)

/obj/item/reagent_containers/food/drinks/shaker
	name = "shaker"
	desc = "A metal shaker to mix drinks in."
	icon_state = "shaker"
	unacidable = TRUE
	amount_per_transfer_from_this = 10
	volume = 120
	center_of_mass = list("x"=16, "y"=8)
	var/last_shake = 0

/obj/item/reagent_containers/food/drinks/shaker/attack_self(mob/user)
	if(last_shake <= world.time - 10) //Spam limiter.
		last_shake = world.time
		playsound(src.loc, 'sound/items/soda_shaking.ogg', 50, 1)
	src.add_fingerprint(user)
	return

/obj/item/reagent_containers/food/drinks/teapot
	name = "teapot"
	desc = "An elegant teapot. It simply oozes class."
	icon_state = "teapot"
	item_state = "teapot"
	unacidable = TRUE
	amount_per_transfer_from_this = 10
	volume = 120
	center_of_mass = list("x"=17, "y"=7)

/obj/item/reagent_containers/food/drinks/pitcher
	name = "pitcher"
	desc = "Everyone's best friend in the morning."
	icon_state = "pitcher"
	unacidable = TRUE
	amount_per_transfer_from_this = 10
	volume = 120
	possible_transfer_amounts = list(5,10,15,30,60,120)

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

	var/obj/item/reagent_containers/food/drinks/flask/flask_cup/cup

/obj/item/reagent_containers/food/drinks/flask/vacuumflask/Initialize()
	. = ..()
	cup = new(src)

/obj/item/reagent_containers/food/drinks/flask/vacuumflask/attack_self(mob/user)
	if(cup)
		to_chat(user, SPAN_NOTICE("You remove \the [src]'s cap."))
		user.put_in_hands(cup)
		cup = null
		update_icon()

/obj/item/reagent_containers/food/drinks/flask/vacuumflask/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/reagent_containers/food/drinks/flask/flask_cup))
		if(cup)
			to_chat(user, SPAN_WARNING("\The [src] already has a cap."))
			return
		if(W.reagents.total_volume + reagents.total_volume > volume)
			to_chat(user, SPAN_WARNING("There's too much fluid in both the cap and the flask!"))
			return
		to_chat(user, SPAN_NOTICE("You put the cap onto \the [src]."))
		user.drop_from_inventory(W, src)
		cup = W
		cup.reagents.trans_to_holder(reagents, cup.reagents.total_volume)
		update_icon()
		return
	return ..()

/obj/item/reagent_containers/food/drinks/flask/vacuumflask/update_icon()
	icon_state = cup ? initial(icon_state) : "[initial(icon_state)]-nobrim"

/obj/item/reagent_containers/food/drinks/flask/flask_cup
	name = "vacuum flask cup"
	desc = "The cup that appears in your hands after you unscrew the cap of the flask and turn it over. Magic!"
	icon_state = "vacuumflask-brim"
	volume = 10
	center_of_mass = list("x" = 16, "y" = 16)

/obj/item/reagent_containers/food/drinks/flask/flask_cup/afterattack(atom/target, mob/user, proximity, params)
	if(istype(target, /obj/item/reagent_containers/food/drinks/flask/vacuumflask))
		return
	return ..()

/obj/item/reagent_containers/food/drinks/britcup
	name = "cup"
	desc = "A cup with the British flag emblazoned on it."
	icon_state = "britcup"
	volume = 30
	center_of_mass = list("x"=15, "y"=13)

/obj/item/reagent_containers/food/drinks/small_milk
	name = "small milk carton"
	desc = "It's milk. White and nutritious goodness!"
	icon_state = "mini-milk"
	item_state = "carton"
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'
	center_of_mass = list("x"=16, "y"=14)
	reagents_to_add = list(/decl/reagent/drink/milk = 20)

/obj/item/reagent_containers/food/drinks/small_milk_choco
	name = "small chocolate milk carton"
	desc = "It's milk. This one is in delicious chocolate flavor."
	icon_state = "mini-milk_choco"
	item_state = "carton"
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'
	center_of_mass = list("x"=16, "y"=14)
	reagents_to_add = list(/decl/reagent/drink/milk/chocolate = 20)

/obj/item/reagent_containers/food/drinks/small_milk_strawberry
	name = "small strawberry milk carton"
	desc = "It's milk. This one is in delicious strawberry flavor."
	icon_state = "mini-milk_strawberry"
	item_state = "carton"
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'
	center_of_mass = list("x"=16, "y"=14)
	reagents_to_add = list(/decl/reagent/drink/milk/strawberry = 20)
