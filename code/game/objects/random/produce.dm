/obj/random_produce
	name = "random produce"
	icon = 'icons/obj/seeds.dmi'
	icon_state = ""
	var/list/produce_list = list( //When adding produce, use the .name variable of the /datum/seed/
		"chili" = 1,
		"berries" = 0.25,
		"blueberries" = 0.25,
		"tomato" = 2,
		"eggplant" = 0.5,
		"apple" = 0.25,
		"mushrooms" = 0.25,
		"grapes" = 0.25,
		"greengrapes" = 0.25,
		"peanut" = 0.5,
		"cabbage" = 2,
		"banana" = 0.5,
		"corn" = 2,
		"potato" = 2,
		"soybean" = 0.5,
		"rice" = 2,
		"carrot" = 1,
		"whitebeet" = 1,
		"watermelon" = 0.1,
		"pumpkin" = 0.1,
		"lime" = 0.25,
		"lemon" = 0.25,
		"orange" = 0.25,
		"cacao" = 0.5,
		"cherry" = 0.25,
		"garlic" = 0.5,
		"onion" = 0.5
	)

/obj/random_produce/Initialize()
	. = ..()

	var/seed_chosen = pickweight(produce_list)
	var/datum/seed/chosen_seed = SSplants.seeds[seed_chosen]
	if(chosen_seed)
		chosen_seed.spawn_seed(src.loc)
	else
		log_debug("Cannot spawn random produce [seed_chosen]! Fix this by editing [type]'s produce_list!",SEVERITY_ERROR)

	return INITIALIZE_HINT_QDEL

/obj/random_produce/box // produce for spawning in chef produce boxes. better suited for the job
	produce_list = list(
			"chili" = 1,
			"berries" = 0.25,
			"tomato" = 2,
			"eggplant" = 0.5,
			"apple" = 0.25,
			"mushrooms" = 0.25,
			"cabbage" = 2,
			"banana" = 0.5,
			"corn" = 2,
			"potato" = 2,
			"soybean" = 0.5,
			"rice" = 2,
			"carrot" = 1,
			"whitebeet" = 1,
			"pumpkin" = 0.1,
			"lime" = 0.25,
			"lemon" = 0.25,
			"cacao" = 0.5,
			"cherry" = 0.25,
			"onion" = 0.5
					   )