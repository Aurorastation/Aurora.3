/obj/item/storage/lockbox
	name = "lockbox"
	desc = "A locked box."
	icon_state = "lockbox+l"
	item_state = "lockbox"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/storage/lefthand_briefcase.dmi',
		slot_r_hand_str = 'icons/mob/items/storage/righthand_briefcase.dmi'
		)
	w_class = ITEMSIZE_LARGE
	max_w_class = ITEMSIZE_NORMAL
	max_storage_space = 14 //The sum of the w_classes of all the items in this storage item.
	req_access = list(access_armory)
	var/locked = TRUE
	var/broken = FALSE
	var/icon_locked = "lockbox+l"
	var/icon_closed = "lockbox"
	var/icon_broken = "lockbox+b"

/obj/item/storage/lockbox/attackby(obj/item/I, mob/user)
	var/obj/item/card/id/ID = I.GetID()
	if(istype(ID))
		if(broken)
			to_chat(user, SPAN_WARNING("It appears to be broken."))
			return
		if(allowed(user))
			locked = !locked
			if(locked)
				icon_state = icon_locked
				to_chat(user, SPAN_NOTICE("You lock \the [src]!"))
				return
			else
				icon_state = icon_closed
				to_chat(user, SPAN_NOTICE("You unlock \the [src]!"))
				return
		else
			to_chat(user, SPAN_WARNING("Access denied."))
			return

	if(istype(I, /obj/item/melee/energy/blade))
		if(emag_act(INFINITY, user, I, "The locker has been sliced open by [user] with an energy blade!", "You hear metal being sliced and sparks flying."))
			var/obj/item/melee/energy/blade/blade = I
			blade.spark_system.queue()
			playsound(src.loc, 'sound/weapons/blade.ogg', 50, 1)
			playsound(src.loc, /decl/sound_category/spark_sound, 50, 1)
			return

	if(locked)
		to_chat(user, SPAN_WARNING("It's locked!"))
		return

	return ..()

/obj/item/storage/lockbox/show_to(mob/user)
	if(locked)
		to_chat(user, SPAN_WARNING("It's locked!"))
		return
	return ..()

/obj/item/storage/lockbox/emag_act(var/remaining_charges, var/mob/user, var/emag_source, var/visual_feedback = "", var/audible_feedback = "")
	if(!broken)
		if(visual_feedback)
			visual_feedback = SPAN_WARNING(visual_feedback)
		else
			visual_feedback = SPAN_WARNING("The locker has been sliced open by [user] with an electromagnetic card!")

		if(audible_feedback)
			audible_feedback = SPAN_WARNING(audible_feedback)
		else
			audible_feedback = SPAN_WARNING("You hear a faint electrical spark.")

		broken = TRUE
		locked = FALSE
		desc += " It appears to be broken."
		icon_state = icon_broken
		visible_message(visual_feedback, audible_feedback)
		return 1

/obj/item/storage/lockbox/loyalty
	name = "lockbox of mind shield implants"
	req_access = list(access_security)
	starts_with = list(
		/obj/item/implantcase/loyalty = 3,
		/obj/item/implanter/loyalty = 1
	)

/obj/item/storage/lockbox/anti_augment
	name = "lockbox of augmentation disrupter implants"
	req_access = list(access_security)
	starts_with = list(
		/obj/item/implantcase/anti_augment = 3,
		/obj/item/implanter/anti_augment = 1
	)

/obj/item/storage/lockbox/clusterbang
	name = "lockbox of clusterbangs"
	desc = "You have a bad feeling about opening this."
	req_access = list(access_security)
	starts_with = list(/obj/item/grenade/flashbang/clusterbang = 1)

/obj/item/storage/lockbox/lawgiver
	name = "weapons lockbox"
	desc = "A high security weapons lockbox."
	req_access = list(access_armory)
	starts_with = list(/obj/item/gun/energy/lawgiver = 1)

/obj/item/storage/lockbox/medal
	name = "captain's medal box"
	desc = "A locked box used to store medals."
	icon_state = "medalbox+l"
	item_state = "box"
	w_class = ITEMSIZE_NORMAL
	max_w_class = ITEMSIZE_SMALL
	req_access = list(access_captain)
	icon_locked = "medalbox+l"
	icon_closed = "medalbox"
	icon_broken = "medalbox+b"
	starts_with = list(
		/obj/item/clothing/accessory/medal/conduct = 3,
		/obj/item/clothing/accessory/medal/corporate = 3,
		/obj/item/clothing/accessory/medal/wound_ribbon = 3,
		/obj/item/clothing/accessory/medal/silver/valor = 3
	)

/obj/item/storage/lockbox/medal/hop
	name = "personnel medal box"
	desc = "A locked box used to store medals. This one is given to the Head of Personnel."
	req_access = list(access_hop)
	starts_with = list(
		/obj/item/clothing/accessory/medal/conduct = 2,
		/obj/item/clothing/accessory/medal/corporate = 1,
		/obj/item/clothing/accessory/medal/silver/valor = 1
	)

/obj/item/storage/lockbox/medal/head
	name = "command medal box"
	desc = "A locked box used to store medals. This one is distributed to the Heads of Staff."
	req_access = list(access_heads)
	starts_with = list(/obj/item/clothing/accessory/medal/conduct = 2)