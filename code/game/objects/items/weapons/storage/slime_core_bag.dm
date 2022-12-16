/obj/item/storage/slimes
	name = "slime core bag"
	desc = "A pressurized and thermoregulated bag for the storage and transport of slime cores."
	icon = 'icons/mob/npc/slimes.dmi'
	icon_state = "slimebag"

	storage_slots = 100
	max_storage_space = 100
	max_w_class = ITEMSIZE_NORMAL
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT
	can_hold = list(/obj/item/slime_extract)

	allow_quick_gather = TRUE
	allow_quick_empty = TRUE
	use_to_pickup = TRUE

	display_contents_with_number = TRUE
	display_contents_initials = TRUE

	drop_sound = 'sound/items/drop/backpack.ogg'
	pickup_sound = 'sound/items/pickup/backpack.ogg'

/obj/item/storage/slimes/handle_name_initials(var/sample_name)
	var/name_initials = ..()
	return replacetext(name_initials, "SE", "")
