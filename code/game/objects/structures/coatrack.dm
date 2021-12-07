/obj/structure/coatrack
	name = "coat rack"
	desc = "Rack that holds coats."
	icon = 'icons/obj/coatrack.dmi'
	icon_state = "coatrack0"
	var/obj/item/clothing/suit/coat
	var/obj/item/clothing/head/hat

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
	if(!coat && istype(W, /obj/item/clothing/suit/storage/toggle))
		user.visible_message("[user] hangs [W] on \the [src].", SPAN_NOTICE("You hang [W] on the \the [src]."))
		coat = W
		user.drop_from_inventory(coat, src)
		update_icon()
	else if(!hat && istype(W, /obj/item/clothing/head) && !istype(W, /obj/item/clothing/head/helmet))
		user.visible_message("[user] hangs [W] on \the [src].", SPAN_NOTICE("You hang [W] on the \the [src]."))
		hat = W
		user.drop_from_inventory(hat, src)
		update_icon()
	else
		return ..()

/obj/structure/coatrack/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(!coat && istype(mover, /obj/item/clothing/suit/storage/toggle))
		src.visible_message("[mover] lands on \the [src].")
		coat = mover
		coat.forceMove(src)
		update_icon()
		return 0
	if(!hat && istype(mover, /obj/item/clothing/head))
		src.visible_message("[mover] lands on \the [src].")
		hat = mover
		hat.forceMove(src)
		update_icon()
		return 0
	else
		return 1

/obj/structure/coatrack/update_icon()
	cut_overlays()
	var/icon/coat_outline = icon('icons/obj/coatrack.dmi', "outline")
	if(coat)
		if(istype(coat, /obj/item/clothing/suit/storage/toggle)) // Using onmob sprites, because they're more consistent than object sprites.
			var/obj/item/clothing/suit/storage/toggle/T = coat
			if(!T.opened)
				T.opened = TRUE // Makes coats open when hung up. Cause you know, you can't really hang up a closed coat. Well you can, but...code reasons.
				T.icon_state = "[initial(T.icon_state)]_open"
			var/matrix/M = matrix()
			var/image/coat_image
			var/icon/coat_icon
			if(T.contained_sprite)
				var/coat_icon_state = "[T.icon_state][WORN_SUIT]" // Needed to bypass contained sprite phoney baloney.
				coat_icon = new(T.icon, coat_icon_state)
				if(T.build_from_parts)
					var/icon/overlay_icon = new(T.icon, "[T.icon_state]_[T.worn_overlay]")
					coat_icon.Blend(overlay_icon, ICON_OVERLAY)
			else
				coat_icon = new(INV_SUIT_DEF_ICON, T.icon_state)
				if(T.build_from_parts)
					var/icon/overlay_icon = new(INV_SUIT_DEF_ICON, "[T.icon_state]_[T.worn_overlay]")
					coat_icon.Blend(overlay_icon, ICON_OVERLAY)
			coat_icon.Blend(coat_outline, ICON_OVERLAY)
			coat_icon.SwapColor(rgb(255, 0, 220, 255), rgb(0, 0, 0, 0)) //Slice the coat in half.
			coat_image = image(coat_icon)
			M.Translate(0, 5) // Shove it up 5 pixels.
			coat_image.transform = M
			add_overlay(coat_image)		
	if(hat)
		if(istype(hat, /obj/item/clothing/head))
			var/obj/item/clothing/head/H = hat
			var/matrix/M = matrix()
			var/image/hat_image
			if(H.contained_sprite)
				var/hat_icon_state = "[H.icon_state][WORN_HEAD]" // Needed to bypass contained sprite phoney baloney.
				hat_image = image(H.icon, hat_icon_state, src.layer, EAST)
				if(H.build_from_parts)
					hat_image.add_overlay(overlay_image(H.icon, "[H.icon_state]_[H.worn_overlay]", flags=RESET_COLOR))
			else
				hat_image = image(INV_HEAD_DEF_ICON, H.icon_state, src.layer, EAST)
				if(H.build_from_parts)
					hat_image.add_overlay(overlay_image(icon, "[INV_HEAD_DEF_ICON]_[H.worn_overlay]", flags=RESET_COLOR))
			M.Turn(90) // Flip the hat over and stick it on the coatrack.
			M.Translate(-7, 7)
			hat_image.transform = M
			add_overlay(hat_image)
