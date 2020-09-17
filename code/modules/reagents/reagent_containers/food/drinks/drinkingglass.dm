

/obj/item/reagent_containers/food/drinks/drinkingglass
	name = "glass"
	desc = "Your standard drinking glass."
	icon_state = "glass_empty"
	amount_per_transfer_from_this = 5
	volume = 30
	unacidable = TRUE //glass
	center_of_mass = list("x"=16, "y"=10)
	drop_sound = 'sound/items/drop/drinkglass.ogg'
	pickup_sound = 'sound/items/pickup/drinkglass.ogg'
	matter = list(MATERIAL_GLASS = 300)
	drink_flags = NO_EMPTY_ICON	//This should not be removed unless a total overhaul of drink reagent sprites is done.
	shatter = TRUE

/obj/item/reagent_containers/food/drinks/drinkingglass/on_reagent_change()
	if (reagents.reagent_list.len > 0)
		var/datum/reagent/R = reagents.get_master_reagent()

		if(R.glass_icon_state)
			icon_state = R.glass_icon_state
		else
			icon_state = "nothing"

		if(R.glass_name)
			name = R.glass_name
		else
			name = "glass of something"

		if(R.glass_desc)
			desc = R.glass_desc
		else
			desc = "You can't really tell what this is."

		if(R.glass_center_of_mass)
			center_of_mass = R.glass_center_of_mass
		else
			center_of_mass = list("x"=16, "y"=10)
	else
		icon_state = "glass_empty"
		name = "glass"
		desc = "Your standard drinking glass."
		center_of_mass = list("x"=16, "y"=10)

// for /obj/machinery/vending/sovietsoda	
/obj/item/reagent_containers/food/drinks/drinkingglass/soda/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/sodawater, 50)
	on_reagent_change()

/obj/item/reagent_containers/food/drinks/drinkingglass/cola/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/space_cola, 50)
	on_reagent_change()
