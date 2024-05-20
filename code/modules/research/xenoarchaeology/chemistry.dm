
//chemistry stuff here so that it can be easily viewed/modified

/obj/item/reagent_containers/glass/solution_tray
	name = "solution tray"
	desc = "A small, open-topped glass container for delicate research samples. It sports a re-useable strip for labelling with a pen."
	icon = 'icons/obj/device.dmi'
	icon_state = "solution_tray"
	matter = list(MATERIAL_GLASS = 5)
	w_class = ITEMSIZE_SMALL
	amount_per_transfer_from_this = 1
	possible_transfer_amounts = list(1, 2)
	volume = 2
	atom_flags = ATOM_FLAG_OPEN_CONTAINER

/obj/item/reagent_containers/glass/solution_tray/attackby(obj/item/attacking_item, mob/living/user)
	if(attacking_item.ispen())
		var/new_label = sanitizeSafe( tgui_input_text(user, "What should the new label be?", "Label solution tray", max_length = MAX_NAME_LEN), MAX_NAME_LEN )
		if(new_label)
			name = "solution tray ([new_label])"
			to_chat(user, SPAN_NOTICE("You write on the label of the solution tray."))
	else
		return ..()

/obj/item/storage/box/solution_trays
	name = "solution tray box"
	icon_state = "solution_trays"

/obj/item/storage/box/solution_trays/fill()
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

/obj/item/reagent_containers/glass/beaker/tungsten/Initialize()
	. = ..()
	reagents.add_reagent(/singleton/reagent/tungsten,50)
	update_icon()

/obj/item/reagent_containers/glass/beaker/oxygen
	name = "beaker 'oxygen'"

/obj/item/reagent_containers/glass/beaker/oxygen/Initialize()
	. = ..()
	reagents.add_reagent(/singleton/reagent/acetone,50)
	update_icon()

/obj/item/reagent_containers/glass/beaker/sodium
	name = "beaker 'sodium'"

/obj/item/reagent_containers/glass/beaker/sodium/Initialize()
	. = ..()
	reagents.add_reagent(/singleton/reagent/sodium,50)
	update_icon()

/obj/item/reagent_containers/glass/beaker/lithium
	name = "beaker 'lithium'"

/obj/item/reagent_containers/glass/beaker/lithium/Initialize()
	. = ..()
	reagents.add_reagent(/singleton/reagent/lithium,50)
	update_icon()

/obj/item/reagent_containers/glass/beaker/water
	name = "beaker 'water'"

/obj/item/reagent_containers/glass/beaker/water/Initialize()
	. = ..()
	reagents.add_reagent(/singleton/reagent/water,50)
	update_icon()

/obj/item/reagent_containers/glass/beaker/fuel
	name = "beaker 'fuel'"

/obj/item/reagent_containers/glass/beaker/fuel/Initialize()
	. = ..()
	reagents.add_reagent(/singleton/reagent/fuel,50)
	update_icon()
