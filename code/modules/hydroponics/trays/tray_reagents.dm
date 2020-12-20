
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

/obj/item/plantspray/pests/old
	name = "bottle of pestkiller"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"

/obj/item/plantspray/pests/old/carbaryl
	name = "bottle of carbaryl"
	icon_state = "bottle16"
	toxicity = 4
	pest_kill_str = 2

/obj/item/plantspray/pests/old/lindane
	name = "bottle of lindane"
	icon_state = "bottle18"
	toxicity = 6
	pest_kill_str = 4

/obj/item/plantspray/pests/old/phosmet
	name = "bottle of phosmet"
	icon_state = "bottle15"
	toxicity = 8
	pest_kill_str = 7

// *************************************
// Weedkiller defines for hydroponics
// *************************************

/obj/item/weedkiller
	name = "bottle of weedkiller"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"
	var/toxicity = 0
	var/weed_kill_str = 0

/obj/item/weedkiller/triclopyr
	name = "bottle of glyphosate"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"
	toxicity = 4
	weed_kill_str = 2

/obj/item/weedkiller/lindane
	name = "bottle of triclopyr"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle18"
	toxicity = 6
	weed_kill_str = 4

/obj/item/weedkiller/D24
	name = "bottle of 2,4-D"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle15"
	toxicity = 8
	weed_kill_str = 7

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
	shatter = FALSE
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
		force = max(10 * fraction, 1)
		throwforce = max(8 * fraction, 1)
		hitsound = 'sound/weapons/jug_filled_impact.ogg'
		drop_sound = 'sound/weapons/jug_filled_impact.ogg'
	else
		force = 1
		throwforce = 1
		hitsound = 'sound/weapons/jug_empty_impact.ogg'
		drop_sound = 'sound/weapons/jug_empty_impact.ogg'

/obj/item/reagent_containers/glass/fertilizer/update_icon()
	cut_overlays()

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/reagentfillings.dmi', src, "plastic_jug10")

		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(1 to 10)
				filling.icon_state = "plastic_jug-10"
			if(11 to 29)
				filling.icon_state = "plastic_jug25"
			if(30 to 45)
				filling.icon_state = "plastic_jug40"
			if(46 to 61)
				filling.icon_state = "plastic_jug55"
			if(62 to 77)
				filling.icon_state = "plastic_jug70"
			if(78 to 92)
				filling.icon_state = "plastic_jug85"
			if(99 to INFINITY)
				filling.icon_state = "plastic_jug100"

		filling.color = reagents.get_color()
		add_overlay(filling)

	if(!is_open_container())
		add_overlay("lid_jug")

/obj/item/reagent_containers/glass/fertilizer/ez
	name = "jug of E-Z-Nutrient"
	icon_state = "plastic_jug_ez"
	reagents_to_add = list(/datum/reagent/toxin/fertilizer/eznutrient = 80)

/obj/item/reagent_containers/glass/fertilizer/l4z
	name = "jug of Left-4-Zed"
	icon_state = "plastic_jug_l4z"
	reagents_to_add = list(/datum/reagent/toxin/fertilizer/left4zed = 80)

/obj/item/reagent_containers/glass/fertilizer/rh
	name = "jug of Robust Harvest"
	icon_state = "plastic_jug_rh"
	reagents_to_add = list(/datum/reagent/toxin/fertilizer/robustharvest = 80)