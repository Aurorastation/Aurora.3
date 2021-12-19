/obj/structure/coatrack
	name = "coat rack"
	desc = "Rack that holds coats."
	icon = 'icons/obj/coatrack.dmi'
	icon_state = "coatrack0"
	var/obj/item/clothing/suit/coat
	var/obj/item/clothing/head/hat
	var/list/allowed_coats = list(/obj/item/clothing/suit/storage/toggle/labcoat, /obj/item/clothing/suit/storage/toggle/det_trench,
							/obj/item/clothing/suit/storage/toggle/forensics, /obj/item/clothing/suit/storage/toggle/trench,
							/obj/item/clothing/suit/storage/det_jacket, /obj/item/clothing/accessory/poncho/tajarancloak)
	var/list/allowed_hats = list(/obj/item/clothing/head/det, /obj/item/clothing/head/beret/security, /obj/item/clothing/head/softcap/security)

/obj/structure/coatrack/attack_hand(mob/user as mob)
	if (!ishuman(user))
		return
	if(user.incapacitated())
		return
	if (!user.can_use_hand())
		return
	if(coat)
		user.visible_message("[user] takes [coat] off \the [src].", SPAN_NOTICE("You take [coat] off the \the [src]."))
		user.put_in_hands(coat)
		coat = null
		update_icon()
	else if(hat)
		user.visible_message("[user] takes [hat] off \the [src].", SPAN_NOTICE("You take [hat] off the \the [src]."))
		user.put_in_hands(hat)
		hat = null
		update_icon()

/obj/structure/coatrack/attackby(obj/item/W as obj, mob/user as mob)
	if (is_type_in_list(W, allowed_coats) && !coat)
		user.visible_message("[user] hangs [W] on \the [src].", SPAN_NOTICE("You hang [W] on the \the [src]."))
		coat = W
		user.drop_from_inventory(coat, src)
		update_icon()
	else if (is_type_in_list(W, allowed_hats) && !hat)
		user.visible_message("[user] hangs [W] on \the [src].", SPAN_NOTICE("You hang [W] on the \the [src]."))
		hat = W
		user.drop_from_inventory(hat, src)
		update_icon()
	else
		to_chat(user, SPAN_NOTICE("You cannot hang [W] on [src]."))
		return ..()

/obj/structure/coatrack/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if (is_type_in_list(mover, allowed_coats) && !coat)
		src.visible_message("[mover] lands on \the [src].")
		coat = mover
		coat.forceMove(src)
		update_icon()
		return 0
	if (is_type_in_list(mover, allowed_hats) && !hat)
		src.visible_message("[mover] lands on \the [src].")
		hat = mover
		hat.forceMove(src)
		update_icon()
		return 0
	else
		return 1

/obj/structure/coatrack/update_icon()
	cut_overlays()
	if (coat)
		if(istype(coat, /obj/item/clothing/suit/storage/toggle))
			var/obj/item/clothing/suit/storage/toggle/T = coat
			T.icon_state = initial(T.icon_state)
			T.opened = FALSE
		add_overlay("coat_[coat.icon_state]")
	if (hat)
		if(istype(hat, /obj/item/clothing/head/softcap/security/idris) || istype(hat, /obj/item/clothing/head/softcap/security/corp))
			add_overlay("hat_softcap_[hat.icon_state]")
		else
			add_overlay("hat_[hat.icon_state]")
