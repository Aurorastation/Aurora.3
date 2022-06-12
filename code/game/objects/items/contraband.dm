//Let's get some REAL contraband stuff in here. Because come on, getting brigged for LIPSTICK is no fun.

//Illicit drugs~
/obj/item/storage/pill_bottle/happy
	name = "bottle of Happy pills"
	desc = "Highly illegal drug. When you want to see the rainbow."
	starts_with = list(/obj/item/reagent_containers/pill/happy = 7)

/obj/item/storage/pill_bottle/zoom
	name = "bottle of Zoom pills"
	desc = "Highly illegal drug. Trade brain for speed."
	starts_with = list(/obj/item/reagent_containers/pill/zoom = 7)

/obj/item/storage/pill_bottle/joy
	name = "bottle of Joy pills"
	desc = "Highly illegal drug. Bang - and your stress is gone."
	starts_with = list(/obj/item/reagent_containers/pill/joy = 3)

/obj/item/storage/pill_bottle/smart
	name = "bottle of Smart pills"
	desc = "Highly illegal drug. For exam season."
	starts_with = list(/obj/item/reagent_containers/pill/skrell_nootropic = 7)

/obj/item/reagent_containers/glass/beaker/vial/random
	flags = 0
	var/list/random_reagent_list = list(list(/decl/reagent/water = 15) = 1, list(/decl/reagent/spacecleaner = 15) = 1)

/obj/item/reagent_containers/glass/beaker/vial/random/toxin
	random_reagent_list = list(
		list(/decl/reagent/mindbreaker = 10, /decl/reagent/space_drugs = 20)	= 3,
		list(/decl/reagent/mercury = 15)										= 3,
		list(/decl/reagent/toxin/carpotoxin = 15)								= 2,
		list(/decl/reagent/impedrezene = 15)									= 2,
		list(/decl/reagent/toxin/dextrotoxin = 10)								= 1,
		list(/decl/reagent/toxin/spectrocybin = 15)								= 1,
		list(/decl/reagent/joy = 10, /decl/reagent/water = 20)					= 1,
		list(/decl/reagent/ammonia = 15)										= 3)

/obj/item/reagent_containers/glass/beaker/vial/random/Initialize()
	. = ..()
	if(is_open_container())
		flags ^= OPENCONTAINER

	var/list/picked_reagents = pickweight(random_reagent_list)
	for(var/reagent in picked_reagents)
		reagents.add_reagent(reagent, picked_reagents[reagent])

	var/list/names = new
	for(var/_R in reagents.reagent_volumes)
		var/decl/reagent/R = decls_repository.get_decl(_R)
		names += R.name

	desc = "Contains [english_list(names)]."
	update_icon()


/obj/item/reagent_containers/glass/beaker/vial/venenum
	flags = 0

/obj/item/reagent_containers/glass/beaker/vial/venenum/Initialize()
	. = ..()
	if(is_open_container())
		flags ^= OPENCONTAINER
	reagents.add_reagent(/decl/reagent/venenum,volume)
	desc = "Contains venenum."
	update_icon()
