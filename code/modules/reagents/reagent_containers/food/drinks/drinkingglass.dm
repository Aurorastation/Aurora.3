

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
	fragile = 2

/obj/item/reagent_containers/food/drinks/drinkingglass/on_reagent_change()
	var/decl/reagent/R = reagents.get_primary_reagent_decl()
	if (LAZYLEN(reagents.reagent_volumes) && R)
		icon_state = R.glass_icon_state || "nothing"
		name = R.glass_name || "glass of something"
		desc = R.glass_desc || "You can't really tell what this is."
		center_of_mass = R.glass_center_of_mass || list("x"=16, "y"=10)
	else
		icon_state = "glass_empty"
		name = "glass"
		desc = "Your standard drinking glass."
		center_of_mass = list("x"=16, "y"=10)

// for /obj/machinery/vending/sovietsoda
/obj/item/reagent_containers/food/drinks/drinkingglass/soda
	reagents_to_add = list(/decl/reagent/drink/sodawater = 50)

/obj/item/reagent_containers/food/drinks/drinkingglass/cola
	reagents_to_add = list(/decl/reagent/drink/space_cola = 50)
