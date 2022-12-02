/obj/item/storage/wallet
	name = "wallet"
	desc = "It can hold a few small and personal things."
	storage_slots = 10
	icon = 'icons/obj/storage/wallet.dmi'
	icon_state = "wallet_leather"
	w_class = ITEMSIZE_SMALL
	max_w_class = ITEMSIZE_SMALL
	can_hold = list(
		/obj/item/spacecash,
		/obj/item/card,
		/obj/item/clothing/mask/smokable,
		/obj/item/clothing/accessory/badge,
		/obj/item/clothing/accessory/locket,
		/obj/item/clothing/ring,
		/obj/item/device/flashlight/pen,
		/obj/item/seeds,
		/obj/item/coin,
		/obj/item/stack/dice,
		/obj/item/disk,
		/obj/item/implanter,
		/obj/item/flame/lighter,
		/obj/item/flame/match,
		/obj/item/lipstick,
		/obj/item/haircomb,
		/obj/item/paper,
		/obj/item/paper_bundle,
		/obj/item/pen,
		/obj/item/photo,
		/obj/item/reagent_containers/pill,
		/obj/item/stamp,
		/obj/item/device/paicard,
		/obj/item/device/encryptionkey,
		/obj/item/fluff,
		/obj/item/storage/business_card_holder,
		/obj/item/sample,
		/obj/item/key
	)
	slot_flags = SLOT_ID
	build_from_parts = TRUE

	var/obj/item/card/id/front_id = null
	var/flipped = null
	var/flippable = 1
	var/wear_over_suit = 0

/obj/item/storage/wallet/Initialize()
	. = ..()
	AddComponent(/datum/component/base_name, name)
	update_icon()

/obj/item/storage/wallet/proc/update_name(var/base_name = initial(name))
	SEND_SIGNAL(src, COMSIG_BASENAME_SETNAME, args)
	if(front_id)
		name = "[base_name] ([front_id])"
	else
		name = "[base_name]"

/obj/item/storage/wallet/remove_from_storage(obj/item/W as obj, atom/new_location)
	. = ..(W, new_location)
	if(.)
		if(W == front_id)
			front_id = null
			update_name()
			update_icon()

/obj/item/storage/wallet/handle_item_insertion(obj/item/W as obj, prevent_warning = 0)
	. = ..(W, prevent_warning)
	if(.)
		if(!front_id && istype(W, /obj/item/card/id))
			front_id = W
			update_name()
			update_icon()

/obj/item/storage/wallet/update_icon()
	cut_overlays()
	worn_overlay = "fasteners"
	if(front_id)
		if(("[icon_state]-open") in icon_states(icon))
			icon_state = "[icon_state]-open"
			. = ..()
		var/tiny_state = "[initial(icon_state)]-generic"
		if(("[initial(icon_state)]-[front_id.icon_state]") in icon_states(icon))
			tiny_state = "[initial(icon_state)]-[front_id.icon_state]"
		var/image/tiny_image = overlay_image(icon, icon_state = tiny_state, flags = RESET_COLOR)
		add_overlay(tiny_image)
		if(("[initial(icon_state)]-film") in icon_states(icon))
			var/image/film_image = overlay_image(icon, "[initial(icon_state)]-film", flags = RESET_COLOR)
			add_overlay(film_image)
	else
		icon_state = "[initial(icon_state)]"
		. = ..()
	mob_icon_update()

/obj/item/storage/wallet/GetID()
	return front_id

/obj/item/storage/wallet/GetAccess()
	var/obj/item/I = GetID()
	if(I)
		return I.GetAccess()
	else
		return ..()


/obj/item/storage/wallet/AltClick(mob/user)
	if (user != loc || user.incapacitated() || !ishuman(user))
		return ..()

	var/obj/item/card/id/id = GetID()
	if (istype(id))
		remove_from_storage(id)
		user.put_in_hands(id)
		return

	return ..()


/obj/item/storage/wallet/random/fill()
	..()
	var/item1_type = pick(                \
		/obj/item/spacecash/c10,   \
		/obj/item/spacecash/c100,  \
		/obj/item/spacecash/c1000, \
		/obj/item/spacecash/c20,   \
		/obj/item/spacecash/c200,  \
		/obj/item/spacecash/c50,   \
		/obj/item/spacecash/c500   \
	)
	var/item2_type
	if(prob(50))
		item2_type = pick(                    \
			/obj/item/spacecash/c10,   \
			/obj/item/spacecash/c100,  \
			/obj/item/spacecash/c1000, \
			/obj/item/spacecash/c20,   \
			/obj/item/spacecash/c200,  \
			/obj/item/spacecash/c50,   \
			/obj/item/spacecash/c500   \
		)
	var/item3_type = pick(            \
		/obj/item/coin/silver, \
		/obj/item/coin/silver, \
		/obj/item/coin/gold,   \
		/obj/item/coin/iron,   \
		/obj/item/coin/iron,   \
		/obj/item/coin/iron    \
	)

	if(item1_type)
		new item1_type(src)
	if(item2_type)
		new item2_type(src)
	if(item3_type)
		new item3_type(src)

/obj/item/storage/wallet/proc/mob_icon_update()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_wear_id()

/obj/item/storage/wallet/verb/flip_side()
	set name = "Flip wallet side"
	set category = "Object"
	set src in usr
	if(use_check_and_message(usr, use_flags = USE_DISALLOW_SILICONS))
		return
	if (!flippable)
		to_chat(usr, "You cannot flip \the [src] as it is not a flippable item.")
		return

	src.flipped = !src.flipped
	if(src.flipped)
		src.overlay_state = "[overlay_state]_flip"
	else
		src.overlay_state = initial(overlay_state)
	to_chat(usr, "You change \the [src] to be on your [src.flipped ? "left" : "right"] side.")
	mob_icon_update()

/obj/item/storage/wallet/verb/toggle_icon_layer()
	set name = "Switch Wallet Layer"
	set category = "Object"
	set src in usr

	if(use_check_and_message(usr, use_flags = USE_DISALLOW_SILICONS))
		return
	if(wear_over_suit == -1)
		to_chat(usr, "<span class='notice'>\The [src] cannot be worn above your suit!</span>")
		return
	wear_over_suit = !wear_over_suit
	mob_icon_update()

/obj/item/storage/wallet/colourable
	icon_state = "wallet"

/obj/item/storage/wallet/purse
	name = "wallet purse"
	desc = "A stylish long wallet purse with several slots."
	icon_state = "wallet_purse"

/obj/item/storage/wallet/lanyard
	name = "lanyard"
	desc = "A thick cord with a hook and plastic film designed for the hunter of elk, lover of women, sovereign of the moon."
	storage_slots = 2
	icon_state = "lanyard"
	item_state = "lanyard"
	overlay_state = "lanyard"
	attack_verb = list("whipped", "lashed", "lightly garroted")
	w_class = ITEMSIZE_TINY
	max_w_class = ITEMSIZE_TINY
	can_hold = list(
		/obj/item/card,
		/obj/item/clothing/accessory/badge,
		/obj/item/clothing/accessory/locket,
		/obj/item/disk,
		/obj/item/paper,
		/obj/item/paper_bundle,
		/obj/item/pen,
		/obj/item/photo)
	flippable = 0 //until a cleaner way is implemented to just simply have the verb not show up at all
	var/plastic_film_overlay_state = "plasticfilm"
	var/front_id_overlay_state

	drop_sound = 'sound/items/drop/cloth.ogg'
	pickup_sound = 'sound/items/pickup/cloth.ogg'

	var/image/plastic_film

/obj/item/storage/wallet/lanyard/update_icon()
	if(front_id)
		front_id_overlay_state = front_id.icon_state
	. = ..()
	if(("[initial(icon_state)]-film") in icon_states(icon))
		var/image/film_image = overlay_image(icon, "[initial(icon_state)]-film", flags = RESET_COLOR)
		add_overlay(film_image)

/obj/item/storage/wallet/lanyard/get_mob_overlay(mob/living/carbon/human/H, mob_icon, mob_state, slot)
	var/image/I = ..()
	if(front_id)
		I.add_overlay(image('icons/mob/lanyard_overlays.dmi', icon_state = "lanyard-[front_id_overlay_state]"))
	else
		if(!plastic_film)
			plastic_film = image('icons/mob/lanyard_overlays.dmi', icon_state = "[plastic_film_overlay_state]")
		I.add_overlay(plastic_film)
	return I
