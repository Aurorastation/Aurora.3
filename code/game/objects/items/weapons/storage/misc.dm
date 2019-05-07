/obj/item/weapon/storage/pill_bottle/dice
	name = "pack of dice"
	desc = "It's a small container with dice inside."
	icon = 'icons/obj/dice.dmi'
	icon_state = "dicebag"

/obj/item/weapon/storage/pill_bottle/dice/fill()
	..()
	new /obj/item/weapon/dice( src )
	new /obj/item/weapon/dice/d20( src )

/obj/item/weapon/storage/pill_bottle/dice/gaming
	name = "pack of gaming dice"
	desc = "It's a small container with gaming dice inside."
	icon_state = "magicdicebag"

/obj/item/weapon/storage/pill_bottle/dice/gaming/fill()
	..()
	new /obj/item/weapon/dice/d4(src)
	new /obj/item/weapon/dice/d8(src)
	new /obj/item/weapon/dice/d10(src)
	new /obj/item/weapon/dice/d12(src)
	new /obj/item/weapon/dice/d100(src)

/*
 * Donut Box
 */

/obj/item/weapon/storage/box/donut
	icon = 'icons/obj/food.dmi'
	icon_state = "donutbox"
	name = "donut box"
	var/startswith = 6
	can_hold = list(/obj/item/weapon/reagent_containers/food/snacks/donut)
	foldable = /obj/item/stack/material/cardboard

/obj/item/weapon/storage/box/donut/fill()
	..()
	for(var/i=1; i <= startswith; i++)
		new /obj/item/weapon/reagent_containers/food/snacks/donut/normal(src)
	update_icon()

/obj/item/weapon/storage/box/donut/update_icon()
	cut_overlays()
	var/i = 0
	for(var/obj/item/weapon/reagent_containers/food/snacks/donut/D in contents)
		add_overlay("[i][D.overlay_state]")
		i++

/obj/item/weapon/storage/box/donut/empty
	startswith = 0
	max_storage_space = 12

/obj/item/weapon/storage/box/pineapple
	icon = 'icons/obj/storage.dmi'
	icon_state = "pineapple_rings"
	name = "can of pineapple rings"
	var/startswith = 6
	can_hold = list(/obj/item/weapon/reagent_containers/food/snacks/pineapple_ring)

/obj/item/weapon/storage/box/pineapple/fill()
	for(var/i=1; i <= startswith; i++)
		new /obj/item/weapon/reagent_containers/food/snacks/pineapple_ring(src)
	update_icon()

/obj/item/weapon/storage/box/burialurn/wooden
	name = "wooden burial urn"
	desc = "A wooden urn. Almost looks kind of like a bucket, lid and all."
	icon_state = "woodenburialurn"
	can_hold = list(/obj/item/organ)

/obj/item/weapon/storage/box/burialurn
	name = "burial urn"
	desc = "A burial urn. Moderately higher quality."
	icon_state = "burialurn"
	storage_slots = 100
	can_hold = list(/obj/item/organ)