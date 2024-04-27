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

/obj/item/storage/slimes/orient2hud(mob/user as mob, defer_overlays = FALSE)
	var/list/numbered_contents_by_name = list()

	for(var/obj/item/I in contents)
		var/datum/numbered_display/display = numbered_contents_by_name[I.name]
		if(display)
			display.number++
		else
			numbered_contents_by_name[I.name] = new /datum/numbered_display(I)

	numbered_contents_by_name = sortAssoc(numbered_contents_by_name)

	var/list/datum/numbered_display/numbered_contents = list()
	for(var/display_name in numbered_contents_by_name)
		numbered_contents += numbered_contents_by_name[display_name]

	var/row_num = 0
	var/col_count = force_column_number ? force_column_number : min(7, storage_slots) - 1
	if(length(numbered_contents) > 7)
		row_num = round((length(numbered_contents) - 1) / 7) // 7 is the maximum allowed width.
	slot_orient_objs(row_num, col_count, numbered_contents)

/obj/item/storage/slimes/handle_name_initials(var/sample_name)
	var/name_initials = ..()
	return replacetext(name_initials, "SE", "")
