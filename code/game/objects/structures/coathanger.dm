/obj/structure/coatrack
	name = "coat rack"
	desc = "Rack that holds coats."
	icon = 'icons/obj/coatrack.dmi'
	icon_state = "coatrack0"
	var/obj/item/clothing/suit/coat
	var/list/allowed = list(/obj/item/clothing/suit/storage/toggle/labcoat, /obj/item/clothing/suit/storage/toggle/det_trench,
							/obj/item/clothing/suit/storage/forensics, /obj/item/clothing/suit/storage/toggle/trench)

/obj/structure/coatrack/attack_hand(mob/user as mob)
	if (!ishuman(user))
		return
	if(user.incapacitated())
		return
	if (!user.can_use_hand())
		return
	if(coat)
		user.visible_message("[user] takes [coat] off \the [src].", "You take [coat] off the \the [src]")
		coat.forceMove(get_turf(user))
		user.put_in_hands(coat)
		coat = null
		update_icon()

/obj/structure/coatrack/attackby(obj/item/W as obj, mob/user as mob)
	var/can_hang = 0
	if(is_type_in_list(W, allowed))
		can_hang = 1
	if (can_hang && !coat)
		user.visible_message("[user] hangs [W] on \the [src].", "You hang [W] on the \the [src]")
		coat = W
		user.drop_from_inventory(coat, src)
		update_icon()
	else
		user << "<span class='notice'>You cannot hang [W] on [src]</span>"
		return ..()

/obj/structure/coatrack/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	var/can_hang = 0
	if(is_type_in_list(mover, allowed))
		can_hang = 1

	if (can_hang && !coat)
		src.visible_message("[mover] lands on \the [src].")
		coat = mover
		coat.forceMove(src)
		update_icon()
		return 0
	else
		return 1

/obj/structure/coatrack/update_icon()
	cut_overlays()
	if (coat)
		if(istype(coat, /obj/item/clothing/suit/storage/toggle))
			var/obj/item/clothing/suit/storage/toggle/T = coat
			if(T.icon_state == T.icon_open) // avoid icon conflicts
				T.icon_state = T.icon_closed
				T.item_state = T.icon_closed
		add_overlay("coat_[coat.icon_state]")
