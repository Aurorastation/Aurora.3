/obj/random_produce
	name = "random produce"
	icon = 'icons/obj/seeds.dmi'
	icon_state = ""
	var/list/produce_list = list(
		"chili" = 1,
		"berry" = 0.25,
		"blueberry" = 0.25,
		"tomato" = 2,
		"eggplant" = 0.5,
		"apple" = 0.25,
		"grapes" = 0.25,
		"green grape" = 0.25,
		"peanut" = 0.5,
		"cabbage" = 2,
		"banana" = 0.5,
		"corn" = 2,
		"potato" = 2,
		"soybean" = 0.5,
		"rice" = 2,
		"carrots" = 1,
		"white-beet" = 1,
		"watermelon" = 0.25,
		"pumpkin" = 0.25,
		"lime" = 0.25,
		"lemon" = 0.25,
		"orange" = 0.25,
		"cocoa" = 0.5,
		"cherry" = 0.25,
		"garlic" = 0.5,
		"onion" = 0.5
	)

/obj/random_produce/Initialize(var/mapload = 1)
	. = ..()

	var/seed_chosen = pickweight(produce_list)
	var/datum/seed/chosen_seed = SSplants.seeds[seed_chosen]
	if(chosen_seed)
		chosen_seed.spawn_seed(src.loc)
	else
		log_debug("ERROR: Cannot spawn produce [seed_chosen]!",SEVERITY_ERROR)

	return INITIALIZE_HINT_QDEL
