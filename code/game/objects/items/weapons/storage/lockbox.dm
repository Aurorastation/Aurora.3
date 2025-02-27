//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/storage/lockbox
	name = "lockbox"
	desc = "A locked box."
	icon = 'icons/obj/storage/briefcase.dmi'
	icon_state = "lockbox+l"
	item_state = "lockbox+l"
	contained_sprite = TRUE
	w_class = WEIGHT_CLASS_BULKY
	max_w_class = WEIGHT_CLASS_NORMAL
	max_storage_space = DEFAULT_BOX_STORAGE //The sum of the w_classes of all the items in this storage item.
	req_access = list(ACCESS_ARMORY)
	var/locked = 1
	var/broken = 0
	var/icon_locked = "lockbox+l"
	var/icon_closed = "lockbox"
	var/icon_broken = "lockbox+b"


/obj/item/storage/lockbox/attackby(obj/item/attacking_item, mob/user, params)
	if(istype(attacking_item, /obj/item/card/id))
		if(src.broken)
			to_chat(user, SPAN_WARNING("It appears to be broken."))
			return
		if(src.allowed(user))
			src.locked = !( src.locked )
			if(src.locked)
				src.icon_state = src.icon_locked
				item_state = icon_state
				to_chat(user, SPAN_NOTICE("You lock \the [src]!"))
				return
			else
				src.icon_state = src.icon_closed
				item_state = icon_state
				to_chat(user, SPAN_NOTICE("You unlock \the [src]!"))
				return
		else
			to_chat(user, SPAN_WARNING("Access Denied"))
	else if(istype(attacking_item, /obj/item/melee/energy/blade))
		if(emag_act(INFINITY, user, attacking_item, "The locker has been sliced open by [user] with an energy blade!", "You hear metal being sliced and sparks flying."))
			var/obj/item/melee/energy/blade/blade = attacking_item
			blade.spark_system.queue()
			playsound(src.loc, 'sound/weapons/blade.ogg', 50, 1)
			playsound(src.loc, /singleton/sound_category/spark_sound, 50, 1)
	if(!locked)
		..()
	else
		to_chat(user, SPAN_WARNING("It's locked!"))
	return

/obj/item/storage/lockbox/show_to(mob/user as mob)
	if(locked)
		to_chat(user, SPAN_WARNING("It's locked!"))
	else
		..()
	return

/obj/item/storage/lockbox/emag_act(var/remaining_charges, var/mob/user, var/emag_source, var/visual_feedback = "", var/audible_feedback = "")
	if(!broken)
		if(visual_feedback)
			visual_feedback = SPAN_WARNING("[visual_feedback]")
		else
			visual_feedback = SPAN_WARNING("The locker has been sliced open by [user] with an electromagnetic card!")
		if(audible_feedback)
			audible_feedback = SPAN_WARNING("[audible_feedback]")
		else
			audible_feedback = SPAN_WARNING("You hear a faint electrical spark.")

		broken = 1
		locked = 0
		desc = "It appears to be broken."
		icon_state = src.icon_broken
		item_state = icon_state
		visible_message(visual_feedback, audible_feedback)
		return 1

/obj/item/storage/lockbox/loyalty
	name = "lockbox of mind shield implants"
	req_access = list(ACCESS_SECURITY)
	starts_with = list(
		/obj/item/implantcase/mindshield = 3,
		/obj/item/implanter/mindshield = 1
	)

/obj/item/storage/lockbox/anti_augment
	name = "lockbox of augmentation disrupter implants"
	req_access = list(ACCESS_SECURITY)
	starts_with = list(
		/obj/item/implantcase/anti_augment = 3,
		/obj/item/implanter/anti_augment = 1
	)

/obj/item/storage/lockbox/clusterbang
	name = "lockbox of clusterbangs"
	desc = "You have a bad feeling about opening this."
	req_access = list(ACCESS_SECURITY)
	starts_with = list(/obj/item/grenade/flashbang/clusterbang = 1)

/obj/item/storage/lockbox/lawgiver
	name = "weapons lockbox"
	desc = "A high security weapons lockbox"
	req_access = list(ACCESS_ARMORY)
	starts_with = list(/obj/item/gun/energy/lawgiver = 1)

/obj/item/storage/lockbox/medal
	name = "medal box"
	desc = "A locked box used to store medals."
	icon_state = "medalbox+l"
	item_state = "briefcase"
	w_class = WEIGHT_CLASS_NORMAL
	max_w_class = WEIGHT_CLASS_SMALL
	req_access = list(ACCESS_CAPTAIN)
	icon_locked = "medalbox+l"
	icon_closed = "medalbox"
	icon_broken = "medalbox+b"
