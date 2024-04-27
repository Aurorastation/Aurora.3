/obj/item/reagent_containers/food/drinks/jyalra
	name = "jyalra"
	desc = "A popular junk food item from the Nralakk Federation. Jyalra is a savoury puree made from dyn that has been peeled and mashed into a dark blue pulp."
	desc_extended = "Jyalra is created by peeling and mashing dyn until it becomes a thick blue puree. Unlike the fruit, it has a dry, savoury flavour to it. While used as a meal replacement by busy scientists, it is considered junk food by the Skrell and is eaten more as a snack than a proper meal."
	icon = 'icons/obj/item/reagent_containers/food/drinks/jyalra.dmi'
	icon_state = "jyalra"
	item_state = "jyalra"
	empty_icon_state = "jyalra_empty"
	drop_sound = 'sound/items/drop/disk.ogg'
	pickup_sound = 'sound/items/pickup/disk.ogg'
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/drink/jyalra = 40)

/obj/item/reagent_containers/food/drinks/jyalra/cheese
	name = "jyalra with nycii"
	desc = "A popular junk food item from the Nralakk Federation. Jyalra is a savoury puree made from dyn that has been peeled and mashed into a dark blue pulp. Nycii, a type of Skrellian cheese, has been added to the puree for flavour."
	icon_state = "jyalracheese"
	item_state = "jyalracheese"
	reagents_to_add = list(/singleton/reagent/drink/jyalracheese = 40)

/obj/item/reagent_containers/food/drinks/jyalra/apple
	name = "jyalra with apples"
	desc = "A popular junk food item from the Nralakk Federation. Jyalra is a savoury puree made from dyn that has been peeled and mashed into a dark blue pulp. Apples have been added to make the meal sweeter."
	icon_state = "jyalraapple"
	item_state = "jyalraapple"

/obj/item/reagent_containers/food/drinks/jyalra/cherry
	name = "jyalra with cherries"
	desc = "A popular junk food item from the Nralakk Federation. Jyalra is a savoury puree made from dyn that has been peeled and mashed into a dark blue pulp. Cherries have been added to make the meal sweeter."
	icon_state = "jyalracherry"
	item_state = "jyalracherry"
