
//chemistry stuff here so that it can be easily viewed/modified

/obj/item/reagent_containers/glass/solution_tray
	name = "solution tray"
	desc = "A small, open-topped glass container for delicate research samples. It sports a re-useable strip for labelling with a pen."
	icon = 'icons/obj/device.dmi'
	icon_state = "solution_tray"
	matter = list("glass" = 5)
	w_class = 2.0
	amount_per_transfer_from_this = 1
	possible_transfer_amounts = list(1, 2)
	volume = 2
	flags = OPENCONTAINER

obj/item/reagent_containers/glass/solution_tray/attackby(obj/item/W as obj, mob/living/user as mob)
	if(W.ispen())
		var/new_label = sanitizeSafe(input("What should the new label be?","Label solution tray"), MAX_NAME_LEN)
		if(new_label)
			name = "solution tray ([new_label])"
			to_chat(user, "<span class='notice'>You write on the label of the solution tray.</span>")
	else
		..(W, user)

/obj/item/storage/box/solution_trays
	name = "solution tray box"
	icon_state = "solution_trays"

	fill()
		..()
		new /obj/item/reagent_containers/glass/solution_tray( src )
		new /obj/item/reagent_containers/glass/solution_tray( src )
		new /obj/item/reagent_containers/glass/solution_tray( src )
		new /obj/item/reagent_containers/glass/solution_tray( src )
		new /obj/item/reagent_containers/glass/solution_tray( src )
		new /obj/item/reagent_containers/glass/solution_tray( src )
		new /obj/item/reagent_containers/glass/solution_tray( src )

/obj/item/reagent_containers/glass/beaker/tungsten
	name = "beaker 'tungsten'"
	Initialize()
		. = ..()
		reagents.add_reagent("tungsten",50)
		update_icon()

/obj/item/reagent_containers/glass/beaker/oxygen
	name = "beaker 'oxygen'"
	Initialize()
		. = ..()
		reagents.add_reagent("acetone",50)
		update_icon()

/obj/item/reagent_containers/glass/beaker/sodium
	name = "beaker 'sodium'"
	Initialize()
		. = ..()
		reagents.add_reagent("sodium",50)
		update_icon()

/obj/item/reagent_containers/glass/beaker/lithium
	name = "beaker 'lithium'"

	Initialize()
		. = ..()
		reagents.add_reagent("lithium",50)
		update_icon()

/obj/item/reagent_containers/glass/beaker/water
	name = "beaker 'water'"

	Initialize()
		. = ..()
		reagents.add_reagent("water",50)
		update_icon()

/obj/item/reagent_containers/glass/beaker/fuel
	name = "beaker 'fuel'"

	Initialize()
		. = ..()
		reagents.add_reagent("fuel",50)
		update_icon()
