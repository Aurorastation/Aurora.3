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

/obj/item/reagent_containers/glass/beaker/vial/random
	flags = 0
	var/list/random_reagent_list = list(list("water" = 15) = 1, list("cleaner" = 15) = 1)

/obj/item/reagent_containers/glass/beaker/vial/random/toxin
	random_reagent_list = list(
		list("mindbreaker" = 10, "space_drugs" = 20)	= 3,
		list("carpotoxin" = 15)							= 2,
		list("impedrezene" = 15)						= 2,
		list("dextrotoxin" = 10)						= 1)

/obj/item/reagent_containers/glass/beaker/vial/random/Initialize()
	. = ..()
	if(is_open_container())
		flags ^= OPENCONTAINER

	var/list/picked_reagents = pickweight(random_reagent_list)
	for(var/reagent in picked_reagents)
		reagents.add_reagent(reagent, picked_reagents[reagent])

	var/list/names = new
	for(var/datum/reagent/R in reagents.reagent_list)
		names += R.name

	desc = "Contains [english_list(names)]."
	update_icon()


/obj/item/reagent_containers/glass/beaker/vial/venenum
	flags = 0

/obj/item/reagent_containers/glass/beaker/vial/venenum/Initialize()
	. = ..()
	if(is_open_container())
		flags ^= OPENCONTAINER
	reagents.add_reagent("venenum",volume)
	desc = "Contains venenum."
	update_icon()

/obj/item/reagent_containers/glass/beaker/vial/hallucinagen
	name = "vial of hallucinagens"
	desc = "A potent cocktail of mindbreaker and space drugs. Guaranteed to unhinge a person from reality."
	
/obj/item/reagent_containers/glass/beaker/vial/hallucinagen/Initialize()
	. = ..()
	reagents.add_reagent("mindbreaker", 10) 
	reagents.add_reagent("space_drugs" = 20)
	update_icon()

/obj/item/reagent_containers/glass/beaker/vial/carpotoxin
	name = "vial of carpotoxin"
	desc = "A vial of concentrated carpotoxin. While deadly on its own, it can also be used in an ingredient for other, more potent mixtures. Completely unathi-safe."
	
/obj/item/reagent_containers/glass/beaker/vial/carpotoxin/Initialize()
	. = ..()
	reagents.add_reagent("carpotoxin", 20)
	update_icon()

/obj/item/reagent_containers/glass/beaker/vial/unathipoison
	name = "vial of unathi poison"
	desc = "A potent mixture of concentrated frost oils and ethenol. Extremely deadly to unathi."
	
/obj/item/reagent_containers/glass/beaker/vial/unathipoison/Initialize()
	. = ..()
	reagents.add_reagent("frosttoxin", 15)
	update_icon()

/obj/item/reagent_containers/glass/beaker/vial/bugpoison
	name = "vial of cardox"
	desc = "A toxic phoron-cleaning chemical agent that is particularly deadly to vaurca."
	
/obj/item/reagent_containers/glass/beaker/vial/bugpoison/Initialize()
	. = ..()
	reagents.add_reagent("cardox", 30)
	update_icon()

/obj/item/reagent_containers/glass/beaker/vial/dragonsand
	name = "vial of dragonsand suspension"
	desc = "A potent substance that superheats the victim's body, causing them to ignite and burn to death painfully."
	
/obj/item/reagent_containers/glass/beaker/vial/tajarapoison/Initialize()
	. = ..()
	reagents.add_reagent("firetoxin", 15)
	update_icon()

