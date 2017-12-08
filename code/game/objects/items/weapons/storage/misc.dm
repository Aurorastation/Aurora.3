	name = "pack of dice"
	desc = "It's a small container with dice inside."
	icon = 'icons/obj/dice.dmi'
	icon_state = "dicebag"

	..()

	name = "pack of gaming dice"
	desc = "It's a small container with gaming dice inside."
	icon_state = "magicdicebag"

	..()

/*
 * Donut Box
 */

	icon = 'icons/obj/food.dmi'
	icon_state = "donutbox"
	name = "donut box"
	var/startswith = 6
	foldable = /obj/item/stack/material/cardboard

	..()
	for(var/i=1; i <= startswith; i++)
	update_icon()

	cut_overlays()
	var/i = 0
		add_overlay("[i][D.overlay_state]")
		i++

	startswith = 0
