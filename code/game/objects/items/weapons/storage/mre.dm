/*
MRE Stuff
 */

/obj/item/storage/box/fancy/mre
	name = "\improper MRE, menu 1"
	desc = "A vacuum-sealed bag containing a day's worth of nutrients for an adult in strenuous situations. There is no visible expiration date on the package."
	icon = 'icons/obj/food.dmi'
	icon_state = "mre"
	storage_slots = 7
	opened = FALSE
	closable = FALSE
	icon_overlays = FALSE
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'
	use_sound = 'sound/items/storage/wrapper.ogg'
	open_sound = 'sound/items/rip1.ogg'
	open_message = "You tear open the bag, breaking the vacuum seal."
	var/main_meal = /obj/item/storage/box/fancy/mrebag
	var/meal_desc = "This one is menu 1, meat pizza."
	starts_with = list(
		/obj/item/storage/box/fancy/mrebag/dessert = 1,
		/obj/item/storage/box/fancy/crackers = 1,
		/obj/random/mre/spread = 1,
		/obj/random/mre/drink = 1,
		/obj/item/reagent_containers/food/condiment/small/packet/capsaicin = 1,
		/obj/item/material/kitchen/utensil/fork/plastic = 1
	)

/obj/item/storage/box/fancy/mre/fill()
	new main_meal(src)
	. = ..()
	make_exact_fit()

/obj/item/storage/mre/attack_self(mob/user)
	open(user)

/obj/item/storage/box/fancy/mre/examine(mob/user)
	. = ..()
	to_chat(user, meal_desc)

/obj/item/storage/box/fancy/mre/menu2
	name = "\improper MRE, menu 2"
	meal_desc = "This one is menu 2, margherita."
	main_meal = /obj/item/storage/box/fancy/mrebag/menu2
	starts_with = list(
		/obj/item/storage/box/fancy/mrebag/dessert = 1,
		/obj/item/storage/box/fancy/crackers = 1,
		/obj/random/mre/spread = 1,
		/obj/random/mre/drink = 1,
		/obj/item/reagent_containers/food/condiment/small/packet/salt = 1,
		/obj/item/material/kitchen/utensil/fork/plastic = 1
	)

/obj/item/storage/box/fancy/mre/menu3
	name = "\improper MRE, menu 3"
	meal_desc = "This one is menu 3, vegetable pizza."
	main_meal = /obj/item/storage/box/fancy/mrebag/menu3
	starts_with = list(
		/obj/item/storage/box/fancy/mrebag/dessert = 1,
		/obj/item/storage/box/fancy/crackers = 1,
		/obj/random/mre/spread = 1,
		/obj/random/mre/drink = 1,
		/obj/item/reagent_containers/food/condiment/small/packet/pepper = 1,
		/obj/item/material/kitchen/utensil/fork/plastic = 1
	)

/obj/item/storage/box/fancy/mre/menu4
	name = "\improper MRE, menu 4"
	meal_desc = "This one is menu 4, hamburger."
	main_meal = /obj/item/storage/box/fancy/mrebag/menu4
	starts_with = list(
		/obj/item/storage/box/fancy/mrebag/dessert = 1,
		/obj/item/storage/box/fancy/crackers = 1,
		/obj/random/mre/spread = 1,
		/obj/random/mre/drink = 1,
		/obj/item/reagent_containers/food/condiment/small/packet/mayo = 1,
		/obj/item/material/kitchen/utensil/spork/plastic = 1
	)

/obj/item/storage/box/fancy/mre/menu5
	name = "\improper MRE, menu 5"
	meal_desc = "This one is menu 5, taco."
	main_meal = /obj/item/storage/box/fancy/mrebag/menu5
	starts_with = list(
		/obj/item/storage/box/fancy/mrebag/dessert = 1,
		/obj/item/storage/box/fancy/crackers = 1,
		/obj/random/mre/spread = 1,
		/obj/random/mre/drink = 1,
		/obj/item/reagent_containers/food/condiment/small/packet/ketchup = 1,
		/obj/item/material/kitchen/utensil/spork/plastic = 1
	)

/obj/item/storage/box/fancy/mre/menu6
	name = "\improper MRE, menu 6"
	meal_desc = "This one is menu 6, meatbread."
	main_meal = /obj/item/storage/box/fancy/mrebag/menu6
	starts_with = list(
		/obj/item/storage/box/fancy/mrebag/dessert = 1,
		/obj/item/storage/box/fancy/crackers = 1,
		/obj/random/mre/spread = 1,
		/obj/random/mre/drink = 1,
		/obj/random/mre/sauce/sugarfree = 1,
		/obj/item/material/kitchen/utensil/fork/plastic = 1
	)

/obj/item/storage/box/fancy/mre/menu7
	name = "\improper MRE, menu 7"
	meal_desc = "This one is menu 7, salad."
	main_meal = /obj/item/storage/box/fancy/mrebag/menu7
	starts_with = list(
		/obj/item/storage/box/fancy/mrebag/dessert = 1,
		/obj/item/storage/box/fancy/crackers = 1,
		/obj/random/mre/spread = 1,
		/obj/random/mre/drink = 1,
		/obj/item/reagent_containers/food/condiment/small/packet/soy = 1,
		/obj/item/material/kitchen/utensil/spoon/plastic = 1
	)

/obj/item/storage/box/fancy/mre/menu8
	name = "\improper MRE, menu 8"
	meal_desc = "This one is menu 8, hot chili."
	main_meal = /obj/item/storage/box/fancy/mrebag/menu8
	starts_with = list(
		/obj/item/storage/box/fancy/mrebag/dessert = 1,
		/obj/item/storage/box/fancy/crackers = 1,
		/obj/random/mre/spread = 1,
		/obj/random/mre/drink = 1,
		/obj/item/reagent_containers/food/condiment/small/packet/capsaicin = 1,
		/obj/item/material/kitchen/utensil/spoon/plastic = 1
	)

/obj/item/storage/box/fancy/mre/menu9
	name = "vegan MRE"
	meal_desc = "This one is menu 9, boiled rice (skrell-safe)."
	icon_state = "vegmre"
	main_meal = /obj/item/storage/box/fancy/mrebag/menu9
	starts_with = list(
		/obj/item/storage/box/fancy/mrebag/dessert/menu9 = 1,
		/obj/item/storage/box/fancy/crackers = 1,
		/obj/random/mre/spread/vegan = 1,
		/obj/random/mre/drink = 1,
		/obj/item/reagent_containers/food/condiment/small/packet/soy = 1,
		/obj/item/material/kitchen/utensil/spoon/plastic = 1
	)

/obj/item/storage/box/fancy/mre/menu10
	name = "protein MRE"
	meal_desc = "This one is menu 10, protein."
	icon_state = "meatmre"
	main_meal = /obj/item/storage/box/fancy/mrebag/menu10
	starts_with = list(
		/obj/item/reagent_containers/food/snacks/proteinbar = 1,
		/obj/item/reagent_containers/food/condiment/small/packet/protein = 1,
		/obj/random/mre/sauce/sugarfree = 1,
		/obj/item/material/kitchen/utensil/fork/plastic = 1
	)

/obj/item/storage/box/fancy/mre/menu11 // This is contraband, so normal players usually won't see it unless they actively seek it out
	name = "crayon MRE"
	meal_desc = "This one doesn't have a menu listing. How very odd."
	icon_state = "crayonmre"
	main_meal = /obj/item/storage/box/fancy/crayons
	starts_with = list(
		/obj/item/storage/box/fancy/mrebag/dessert/menu11 = 1,
		/obj/random/mre/sauce/crayon = 1,
		/obj/random/mre/sauce/crayon = 1,
		/obj/random/mre/sauce/crayon = 1
	)

/obj/item/storage/box/fancy/mre/menu11/special // antag item
	meal_desc = "This one doesn't have a menu listing. How odd. It has the initials \"A.B.\" written on the back."

/obj/item/storage/box/fancy/mre/random
	meal_desc = "The menu label is faded out."
	main_meal = /obj/random/mre/main

/obj/item/storage/box/fancy/mrebag
	name = "main course"
	desc = "A vacuum-sealed bag containing a MRE's main course. Self-heats when opened."
	icon = 'icons/obj/food.dmi'
	icon_state = "pouch_medium"
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'
	use_sound = 'sound/items/storage/wrapper.ogg'
	storage_slots = 1
	opened = FALSE
	closable = FALSE
	icon_overlays = FALSE
	w_class = ITEMSIZE_SMALL
	open_sound = 'sound/effects/bubbles.ogg'
	open_message = "The pouch heats up as you break the vacuum seal."
	starts_with = list(/obj/item/reagent_containers/food/snacks/meatpizzaslice/filled = 1)

/obj/item/storage/box/fancy/mrebag/menu2
	starts_with = list(/obj/item/reagent_containers/food/snacks/margheritaslice/filled = 1)

/obj/item/storage/box/fancy/mrebag/menu3
	starts_with = list(/obj/item/reagent_containers/food/snacks/vegetablepizzaslice/filled = 1)

/obj/item/storage/box/fancy/mrebag/menu4
	starts_with = list(/obj/item/reagent_containers/food/snacks/burger = 1)

/obj/item/storage/box/fancy/mrebag/menu5
	starts_with = list(/obj/item/reagent_containers/food/snacks/taco = 1)

/obj/item/storage/box/fancy/mrebag/menu6
	starts_with = list(/obj/item/reagent_containers/food/snacks/meatbreadslice/filled = 1)

/obj/item/storage/box/fancy/mrebag/menu7
	starts_with = list(/obj/item/reagent_containers/food/snacks/salad/tossedsalad = 1)

/obj/item/storage/box/fancy/mrebag/menu8
	starts_with = list(/obj/item/reagent_containers/food/snacks/hotchili = 1)

/obj/item/storage/box/fancy/mrebag/menu9
	starts_with = list(/obj/item/reagent_containers/food/snacks/boiledrice = 1)

/obj/item/storage/box/fancy/mrebag/menu10
	starts_with = list(/obj/item/reagent_containers/food/snacks/meatcube = 1)

/obj/item/storage/box/fancy/mrebag/dessert
	name = "dessert"
	desc = "A vacuum-sealed bag containing a MRE's dessert."
	icon_state = "pouch_small"
	open_sound = 'sound/items/rip1.ogg'
	open_message = "You tear open the bag, breaking the vacuum seal."
	starts_with = list(/obj/random/mre/dessert = 1)

/obj/item/storage/box/fancy/mrebag/dessert/menu9
	starts_with = list(/obj/item/reagent_containers/food/snacks/plumphelmetbiscuit = 1)

/obj/item/storage/box/fancy/mrebag/dessert/menu11
	starts_with = list(/obj/item/pen/crayon/rainbow = 1)
