/obj/random_produce_adhomai
	name = "random produce"
	icon = 'icons/obj/seeds.dmi'
	icon_state = ""
	var/produce_list = list( //When adding produce, use the .name variable of the /datum/seed/
		"nifberries" = 2,
		"nfrihi" = 2,
		"mtear" = 1,
		"shand" = 1,
		"earthenroot" = 1
	)

/obj/random_produce_adhomai/Initialize()
	. = ..()

	var/seed_chosen = pickweight(produce_list)
	var/datum/seed/chosen_seed = SSplants.seeds[seed_chosen]
	if(chosen_seed)
		chosen_seed.spawn_seed(src.loc)
	else
		log_debug("Cannot spawn random produce [seed_chosen]! Fix this by editing [type]'s produce_list!",SEVERITY_ERROR)

	return INITIALIZE_HINT_QDEL