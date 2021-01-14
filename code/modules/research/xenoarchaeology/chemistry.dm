
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
	flags = OPENCONTAINER

obj/item/reagent_containers/glass/solution_tray/attackby(obj/item/W as obj, mob/living/user as mob)
	if(W.ispen())
		var/new_label = sanitizeSafe(input("What should the new label be?","Label solution tray"), MAX_NAME_LEN)
		if(new_label)
			name = "solution tray ([new_label])"
			to_chat(user, "<span class='notice'>You write on the label of the solution tray.</span>")
		return
	..(W, user)

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
	reagents_to_add = list(/datum/reagent/tungsten = 50)

/obj/item/reagent_containers/glass/beaker/oxygen
	name = "beaker 'acetone'"
	reagents_to_add = list(/datum/reagent/acetone = 50)

/obj/item/reagent_containers/glass/beaker/sodium
	name = "beaker 'sodium'"
	reagents_to_add = list(/datum/reagent/sodium = 50)

/obj/item/reagent_containers/glass/beaker/lithium
	name = "beaker 'lithium'"
	reagents_to_add = list(/datum/reagent/lithium = 50)

/obj/item/reagent_containers/glass/beaker/water
	name = "beaker 'water'"
	reagents_to_add = list(/datum/reagent/water = 50)

/obj/item/reagent_containers/glass/beaker/fuel
	name = "beaker 'fuel'"
	reagents_to_add = list(/datum/reagent/fuel = 50)
