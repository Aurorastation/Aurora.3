/obj/item/storage/bag/ore
	name = "mining satchel"
	desc = "This little bugger can be used to store and transport ores."
	description_info = "You can attach a warp extraction pack to it, then click on an ore box that has a warp extraction beacon signaller attached to it to link them. Then ore put into this will be bluespace teleported into the ore box."
	icon = 'icons/obj/mining.dmi'
	icon_state = "satchel"
	slot_flags = SLOT_BELT | SLOT_POCKET
	max_storage_space = 100
	can_hold = list(/obj/item/ore)
	var/obj/structure/ore_box/linked_box
	var/linked_beacon = FALSE // can't hold an actual beacon beclause storage code a shit
	var/linked_beacon_uses = 3 // to hold the amount of uses the beacon had, storage code a shit.

/obj/item/storage/bag/ore/examine(mob/user)
	..()
	if(user.Adjacent(src) && linked_beacon)
		to_chat(user, FONT_SMALL(SPAN_NOTICE("It has a <b>warp extraction pack</b> inside.")))

/obj/item/storage/bag/ore/drone
	// this used to be 400. The inventory system FUCKING DIED at this.
	max_storage_space = 200

// An ore satchel that starts with an attached warp pack
/obj/item/storage/bag/ore/bluespace
	linked_beacon = TRUE

/obj/item/storage/bag/ore/Destroy()
	linked_box = null
	linked_beacon = FALSE
	return ..()

/obj/item/storage/bag/ore/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/extraction_pack))
		var/obj/item/extraction_pack/E = W
		if(linked_beacon)
			to_chat(user, SPAN_WARNING("\The [src] already has a warp extraction pack!"))
			return
		linked_beacon = TRUE
		linked_beacon_uses = E.uses_left
		to_chat(user, SPAN_NOTICE("You attach \the [E] to \the [src]."))
		qdel(E)
	else if(W.isscrewdriver())
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