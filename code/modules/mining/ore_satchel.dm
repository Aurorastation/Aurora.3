/obj/item/storage/bag/ore
	name = "mining satchel"
	desc = "This little bugger can be used to store and transport ores."
	desc_info = "You can attach a warp extraction pack to it, then click on an ore box that has a warp extraction beacon signaller attached to it to link them. Then ore put into this will be bluespace teleported into the ore box."
	icon = 'icons/obj/storage/bags.dmi'
	icon_state = "satchel"
	slot_flags = SLOT_BELT | SLOT_POCKET
	storage_slots = 50
	max_storage_space = 100
	can_hold = list(/obj/item/ore)
	var/obj/structure/ore_box/linked_box

	///The mob we're listening to
	var/mob/listeningTo

	var/linked_beacon = FALSE // can't hold an actual beacon beclause storage code a shit
	var/linked_beacon_uses = 3 // to hold the amount of uses the beacon had, storage code a shit.

/obj/item/storage/bag/ore/Destroy()
	if(listeningTo)
		UnregisterSignal(listeningTo, COMSIG_MOVABLE_MOVED)
	listeningTo = null

	linked_box = null
	linked_beacon = FALSE
	. = ..()

/obj/item/storage/bag/ore/equipped(mob/user, slot)
	. = ..()
	if(listeningTo == user)
		return
	if(listeningTo)
		UnregisterSignal(listeningTo, COMSIG_MOVABLE_MOVED)
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(pickup_ores))
	listeningTo = user

/obj/item/storage/bag/ore/dropped(mob/user)
	. = ..()
	if(listeningTo)
		UnregisterSignal(listeningTo, COMSIG_MOVABLE_MOVED)
		listeningTo = null

/obj/item/storage/bag/ore/proc/pickup_ores(mob/living/user)
	SIGNAL_HANDLER

	var/turf/location = get_turf(user)

	if(location)
		pickup_items_from_loc_and_feedback(user, location, explicit_request = FALSE)

/obj/item/storage/bag/ore/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(is_adjacent && linked_beacon)
		. += FONT_SMALL(SPAN_NOTICE("It has a <b>warp extraction pack</b> inside."))

/obj/item/storage/bag/ore/drone
	// this used to be 400. The inventory system FUCKING DIED at this.
	max_storage_space = 200

// An ore satchel that starts with an attached warp pack
/obj/item/storage/bag/ore/bluespace
	linked_beacon = TRUE

/obj/item/storage/bag/ore/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/extraction_pack))
		var/obj/item/extraction_pack/E = attacking_item
		if(linked_beacon)
			to_chat(user, SPAN_WARNING("\The [src] already has a warp extraction pack!"))
			return
		linked_beacon = TRUE
		linked_beacon_uses = E.uses_left
		to_chat(user, SPAN_NOTICE("You attach \the [E] to \the [src]."))
		qdel(E)
	else if(attacking_item.isscrewdriver())
		if(!linked_beacon)
			to_chat(user, SPAN_WARNING("\The [src] doesn't have a linked extraction pack!"))
			return
		var/obj/item/extraction_pack/E = new /obj/item/extraction_pack(get_turf(user))
		E.uses_left = linked_beacon_uses
		user.put_in_hands(linked_beacon)
		to_chat(user, SPAN_NOTICE("You detach the warp extraction pack."))
		linked_box = null
		linked_beacon = FALSE
	else
		..()

// called when you click on a turf to pick up ores
/obj/item/storage/bag/ore/handle_storage_deferred(mob/user)
	if(check_linked_box(user))
		move_ore_to_ore_box()
	..()

// called when you attack the bag with the ore to put one in
/obj/item/storage/bag/ore/handle_item_insertion(obj/item/W, prevent_warning = FALSE, mob/user = usr)
	..()
	if(check_linked_box(user))
		move_ore_to_ore_box()

/obj/item/storage/bag/ore/proc/check_linked_box(var/mob/user)
	if(linked_box)
		if(!linked_box.warp_core)
			to_chat(user, SPAN_WARNING("\The [linked_box] lost its warp beacon!"))
			linked_box = null
			return FALSE
		return TRUE

/obj/item/storage/bag/ore/proc/move_ore_to_ore_box()
	for(var/obj/ore in contents)
		remove_from_storage_deferred(ore, get_turf(src))
		ore.forceMove(linked_box)
