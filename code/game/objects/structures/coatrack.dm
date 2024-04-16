/obj/structure/coatrack
	name = "coat rack"
	desc = "Rack that holds coats, or hats, if you're so inclined."
	icon = 'icons/obj/coatrack.dmi'
	icon_state = "coatrack"
	layer = ABOVE_HUMAN_LAYER
	var/obj/item/clothing/coat
	var/obj/item/clothing/head/hat
	var/list/custom_sprites = list(/obj/item/clothing/head/beret/security, /obj/item/clothing/accessory/poncho/tajarancloak) // Custom manual sprite override.

/obj/structure/coatrack/attack_hand(mob/user as mob)
	if(use_check_and_message(user))
		return
	if(coat && hat)
		var/response = ""
		response = alert(user, "Do you remove the coat, or the hat?", "Coat Rack Selection", "Coat", "Hat", "Cancel")
		if(response == "Coat")
			remove_coat(user)
		if(response == "Hat")
			remove_hat(user)
	if(coat)
		remove_coat(user)
	if(hat)
		remove_hat(user)
	add_fingerprint(user)
	return

/obj/structure/coatrack/proc/remove_coat(mob/user as mob)
	user.visible_message("[user] takes [coat] off \the [src].", SPAN_NOTICE("You take [coat] off the \the [src]."))
	user.put_in_hands(coat)
	coat = null
	update_icon()

/obj/structure/coatrack/proc/remove_hat(mob/user as mob)
	user.visible_message("[user] takes [hat] off \the [src].", SPAN_NOTICE("You take [hat] off the \the [src]."))
	user.put_in_hands(hat)
	hat = null
	update_icon()

/obj/structure/coatrack/attackby(obj/item/attacking_item, mob/user)
	if(use_check_and_message(user))
		return
	if(!coat && (istype(attacking_item, /obj/item/clothing/suit/storage/toggle) || istype(attacking_item, /obj/item/clothing/accessory/poncho)))
		user.visible_message("[user] hangs [attacking_item] on \the [src].", SPAN_NOTICE("You hang [attacking_item] on the \the [src]."))
		coat = attacking_item
		user.drop_from_inventory(coat, src)
		playsound(src, attacking_item.drop_sound, DROP_SOUND_VOLUME)
		update_icon()
	else if(!hat && istype(attacking_item, /obj/item/clothing/head) && !istype(attacking_item, /obj/item/clothing/head/helmet))
		user.visible_message("[user] hangs [attacking_item] on \the [src].", SPAN_NOTICE("You hang [attacking_item] on the \the [src]."))
		hat = attacking_item
		user.drop_from_inventory(hat, src)
		playsound(src, attacking_item.drop_sound, DROP_SOUND_VOLUME)
		update_icon()
	else if(istype(attacking_item, /obj/item/clothing))
		to_chat(user, SPAN_WARNING("You can't hang that up."))
	else
		return ..()

/obj/structure/coatrack/update_icon()
	cut_overlays()
	if(coat)
		if(is_type_in_list(coat, custom_sprites))
			add_overlay(coat.icon_state)
		else if(istype(coat, /obj/item/clothing/suit/storage/toggle)) // Using onmob sprites, because they're more consistent than object sprites.
			var/obj/item/clothing/suit/storage/toggle/T = coat
			if(!T.opened)
				T.opened = TRUE // Makes coats open when hung up. Cause you know, you can't really hang up a closed coat. Well you can, but...code reasons.
				T.icon_state = "[T.icon_state]_open"
			handle_coat_image(T)
		else if(istype(coat, /obj/item/clothing/accessory/poncho)) // Pain.
			var/obj/item/clothing/accessory/poncho/T = coat
			handle_coat_image(T)
	if(hat)
		if(is_type_in_list(hat, custom_sprites))
			add_overlay(hat.icon_state)
		else if(istype(hat, /obj/item/clothing/head))
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
			M.Translate(-6, 6)
			hat_image.transform = M
			add_overlay(hat_image)

/obj/structure/coatrack/proc/handle_coat_image(var/obj/item/clothing/T)
	var/icon/coat_outline = icon('icons/obj/coatrack.dmi', "outline")
	var/matrix/M = matrix()
	var/coat_icon_state = T.icon_state
	var/coat_icon_file = INV_SUIT_DEF_ICON
	if(T.contained_sprite)
		coat_icon_state = "[T.icon_state][WORN_SUIT]" // Needed to bypass contained sprite phoney baloney.
		coat_icon_file = T.icon

	var/icon/coat_icon = new(coat_icon_file, coat_icon_state)

	coat_icon.Blend(coat_outline, ICON_OVERLAY)
	coat_icon.SwapColor(rgb(255, 0, 220, 255), rgb(0, 0, 0, 0)) //Slice the coat in half.
	var/image/coat_image = image(coat_icon)
	if(T.color)
		coat_image.color = T.color

	if(T.build_from_parts)
		var/icon/overlay_icon = new(coat_icon_file, "[coat_icon_state]_[T.worn_overlay]")
		overlay_icon.Blend(coat_outline, ICON_OVERLAY)
		overlay_icon.SwapColor(rgb(255, 0, 220, 255), rgb(0, 0, 0, 0)) // Slice the overlay in half and slap it on the coat.
		var/image/overlay_image = image(overlay_icon)
		overlay_image.appearance_flags = RESET_COLOR
		coat_image.add_overlay(overlay_image)

	M.Translate(-1, 5) // Stick it on the coat rack.
	coat_image.transform = M
	add_overlay(coat_image)
