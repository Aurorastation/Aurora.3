/obj/item/storage/pill_bottle/dice
	name = "pack of dice"
	desc = "It's a small container with dice inside."
	icon = 'icons/obj/dice.dmi'
	icon_state = "dicebag"
	use_sound = "rustle"
	drop_sound = 'sound/items/drop/hat.ogg'
	starts_with = list(
		/obj/item/dice = 1,
		/obj/item/dice/d20 = 1
	)

/obj/item/storage/pill_bottle/dice/gaming
	name = "pack of gaming dice"
	desc = "It's a small container with gaming dice inside."
	icon_state = "magicdicebag"
	starts_with = list(
		/obj/item/dice/d4 = 1,
		/obj/item/dice/d8 = 1,
		/obj/item/dice/d10 = 1,
		/obj/item/dice/d12 = 1,
		/obj/item/dice/d100 = 1
	)

/obj/item/storage/card
	name = "card box"
	desc = "A small leather case to show how classy you are compared to everyone else."
	icon_state = "card_holder_empty"
	can_hold = list(/obj/item/deck, /obj/item/battle_monsters/deck, /obj/item/hand, /obj/item/pack/, /obj/item/card) //sneaky folks can hide ID and other cards
	storage_slots = 1 //can hold one deck
	use_sound = "sound/items/drop/shoes.ogg"
	drop_sound = "sound/items/drop/hat.ogg"

/obj/item/storage/card/update_icon()
	if(contents.len)
		icon_state = "card_holder_items"
	else
		icon_state = "card_holder_empty"
	return

/*
 * Donut Box
 */

/obj/item/storage/box/donut
	icon = 'icons/obj/food.dmi'
	icon_state = "donutbox"
	center_of_mass = list("x" = 16,"y" = 9)
	name = "donut box"
	can_hold = list(/obj/item/reagent_containers/food/snacks/donut)
	foldable = /obj/item/stack/material/cardboard
	starts_with = list(/obj/item/reagent_containers/food/snacks/donut/normal = 6)

/obj/item/storage/box/donut/fill()
	. = ..()
	update_icon()

/obj/item/storage/box/donut/update_icon()
	cut_overlays()
	var/i = 0
	for(var/obj/item/reagent_containers/food/snacks/donut/D in contents)
		add_overlay("[i][D.overlay_state]")
		i++

/obj/item/storage/box/donut/empty
	starts_with = null
	max_storage_space = 12

/obj/item/storage/box/pineapple
	icon = 'icons/obj/storage.dmi'
	icon_state = "pineapple_rings"
	name = "can of pineapple rings"
	starts_with = list(/obj/item/reagent_containers/food/snacks/pineapple_ring = 6)
	can_hold = list(/obj/item/reagent_containers/food/snacks/pineapple_ring)

/obj/item/storage/box/pineapple/fill()
	. = ..()
	update_icon()
