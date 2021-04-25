/obj/item/storage/box/fancy/csi_markers
	name = "crime scene markers box"
	desc = "A cardboard box for crime scene marker cards."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "markerbox"
	icon_type = "marker"
	w_class = ITEMSIZE_TINY
	storage_slots = 7
	can_hold = list(/obj/item/csi_marker)
	starts_with = list(
		/obj/item/csi_marker/n1 = 1,
		/obj/item/csi_marker/n2 = 1,
		/obj/item/csi_marker/n3 = 1,
		/obj/item/csi_marker/n4 = 1,
		/obj/item/csi_marker/n5 = 1,
		/obj/item/csi_marker/n6 = 1,
		/obj/item/csi_marker/n7 = 1
	)

/obj/item/csi_marker
	name = "crime scene marker"
	desc = "Plastic cards used to mark points of interests on the scene. Just like in the holoshows!"
	icon = 'icons/obj/forensics.dmi'
	icon_state = "card1"
	drop_sound = 'sound/items/drop/card.ogg'
	pickup_sound = 'sound/items/pickup/card.ogg'
	w_class = ITEMSIZE_TINY
	flags = NOBLUDGEON
	randpixel = 1
	layer = ABOVE_MOB_LAYER //so you can mark bodies
	var/number = 1

/obj/item/csi_marker/afterattack(turf/H, mob/user, proximity)
	if(!proximity)
		return
	if(!user.Adjacent(H))
		return
	if(H.density)
		return

	user.drop_from_inventory(src, get_turf(H))

/obj/item/csi_marker/Initialize(mapload)
	. = ..()
	desc += " This one is marked with a [number]."
	update_icon()

/obj/item/csi_marker/update_icon()
	icon_state = "card[Clamp(number,1,7)]"

/obj/item/csi_marker/n1
	number = 1

/obj/item/csi_marker/n2
	number = 2

/obj/item/csi_marker/n3
	number = 3

/obj/item/csi_marker/n4
	number = 4

/obj/item/csi_marker/n5
	number = 5

/obj/item/csi_marker/n6
	number = 6

/obj/item/csi_marker/n7
	number = 7
