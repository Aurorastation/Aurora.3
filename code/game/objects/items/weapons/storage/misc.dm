/obj/item/weapon/storage/pill_bottle/dice
	name = "pack of dice"
	desc = "It's a small container with dice inside."
	icon = 'icons/obj/dice.dmi'
	icon_state = "dicebag"
	use_sound = "rustle"
	drop_sound = 'sound/items/drop/hat.ogg'
	starts_with = list(
		/obj/item/weapon/dice = 1,
		/obj/item/weapon/dice/d20 = 1
	)

/obj/item/weapon/storage/pill_bottle/dice/gaming
	name = "pack of gaming dice"
	desc = "It's a small container with gaming dice inside."
	icon_state = "magicdicebag"
	starts_with = list(
		/obj/item/weapon/dice/d4 = 1,
		/obj/item/weapon/dice/d8 = 1,
		/obj/item/weapon/dice/d10 = 1,
		/obj/item/weapon/dice/d12 = 1,
		/obj/item/weapon/dice/d100 = 1
	)

/*
 * Donut Box
 */

/obj/item/weapon/storage/box/donut
	icon = 'icons/obj/food.dmi'
	icon_state = "donutbox"
	name = "donut box"
	can_hold = list(/obj/item/weapon/reagent_containers/food/snacks/donut)
	foldable = /obj/item/stack/material/cardboard
	starts_with = list(/obj/item/weapon/reagent_containers/food/snacks/donut/normal = 6)

/obj/item/weapon/storage/box/donut/fill()
	. = ..()
	update_icon()

/obj/item/weapon/storage/box/donut/update_icon()
	cut_overlays()
	var/i = 0
	for(var/obj/item/weapon/reagent_containers/food/snacks/donut/D in contents)
		add_overlay("[i][D.overlay_state]")
		i++

/obj/item/weapon/storage/box/donut/empty
	starts_with = null
	max_storage_space = 12

/obj/item/weapon/storage/box/pineapple
	icon = 'icons/obj/storage.dmi'
	icon_state = "pineapple_rings"
	name = "can of pineapple rings"
	starts_with = list(/obj/item/weapon/reagent_containers/food/snacks/pineapple_ring = 6)
	can_hold = list(/obj/item/weapon/reagent_containers/food/snacks/pineapple_ring)

/obj/item/weapon/storage/box/pineapple/fill()
	. = ..()
	update_icon()
