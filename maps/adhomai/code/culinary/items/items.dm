/obj/random_produce_adhomai
	name = "random produce"
	icon = 'icons/obj/seeds.dmi'
	icon_state = ""
	var/produce_list = list( //When adding produce, use the .name variable of the /datum/seed/
		"nifberries" = 2,
		"nfrihi" = 2,
		"nmshaan" = 1,
		"mtear" = 2,
		"earthenroot" = 2
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