
/obj/item/plantspray
	icon = 'icons/obj/hydroponics_machines.dmi'
	item_state = "spray"
	flags = NOBLUDGEON
	slot_flags = SLOT_BELT
	throwforce = 4
	w_class = ITEMSIZE_SMALL
	throw_speed = 2
	throw_range = 10
	var/toxicity = 4
	var/pest_kill_str = 0
	var/weed_kill_str = 0

/obj/item/plantspray/weeds // -- Skie
	name = "weed-spray"
	desc = "It's a toxic mixture, in spray form, to kill small weeds."
	icon_state = "weedspray"
	weed_kill_str = 6

/obj/item/plantspray/pests
	name = "pest-spray"
	desc = "It's some pest eliminator spray! <I>Do not inhale!</I>"
	icon_state = "pestspray"
	pest_kill_str = 6

// *************************************
// Nutrient defines for hydroponics
// *************************************

/obj/item/reagent_containers/glass/fertilizer
	name = "jug"
	desc = "A decent sized plastic jug. Can hold up to 80 units."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "plastic_jug"
	item_state = "plastic_jug"
	flags = 0
	possible_transfer_amounts = list(5, 10, 20, 40, 80)
	volume = 80
	w_class = ITEMSIZE_NORMAL

	hitsound = 'sound/weapons/jug_empty_impact.ogg'
	drop_sound = 'sound/weapons/jug_empty_impact.ogg'

	fragile = 0
	unacidable = FALSE

	force = 1
	throwforce = 1

/obj/item/reagent_containers/glass/fertilizer/Initialize()
	. = ..()

	src.pixel_x = rand(-5.0, 5)
	src.pixel_y = rand(-5.0, 5)

/obj/item/reagent_containers/glass/fertilizer/on_reagent_change()
	. = ..()
	update_icon()
	if(reagents.total_volume)
		var/fraction = reagents.total_volume / volume
		force = max(5 * fraction, 1)
		throwforce = max(5 * fraction, 1)
		hitsound = 'sound/weapons/jug_filled_impact.ogg'
		drop_sound = 'sound/weapons/jug_filled_impact.ogg'
	else
		force = 1
		throwforce = 1
		hitsound = 'sound/weapons/jug_empty_impact.ogg'
		drop_sound = 'sound/weapons/jug_empty_impact.ogg'

/obj/item/reagent_containers/glass/fertilizer/update_icon()
	cut_overlays()

	if(!is_open_container())
		add_overlay("lid_jug")

/obj/item/reagent_containers/glass/fertilizer/ez
	name = "jug of E-Z-Nutrient"
	icon_state = "plastic_jug_ez"
	reagents_to_add = list(/decl/reagent/toxin/fertilizer/eznutrient = 80)

/obj/item/reagent_containers/glass/fertilizer/l4z
	name = "jug of Left-4-Zed"
	icon_state = "plastic_jug_l4z"
	reagents_to_add = list(/decl/reagent/toxin/fertilizer/left4zed = 80)

/obj/item/reagent_containers/glass/fertilizer/rh
	name = "jug of Robust Harvest"
	icon_state = "plastic_jug_rh"
	reagents_to_add = list(/decl/reagent/toxin/fertilizer/robustharvest = 80)
