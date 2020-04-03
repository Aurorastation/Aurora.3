/*
 *	These absorb the functionality of the plant bag, ore satchel, etc.
 *	They use the use_to_pickup, quick_gather, and quick_empty functions
 *	that were already defined in weapon/storage, but which had been
 *	re-implemented in other classes.
 *
 *	Contains:
 *		Trash Bag
 *		Mining Satchel
 *		Plant Bag
 *		Sheet Snatcher
 *		Cash Bag
 *		Book Bag (New thing)
 *		Slime Bag (New thing) ~Chaoko99
  *
 *	-Sayu
 */

//  Generic non-item
/obj/item/storage/bag
	allow_quick_gather = 1
	allow_quick_empty = 1
	display_contents_with_number = 0 // UNStABLE AS FuCK, turn on when it stops crashing clients
	use_to_pickup = 1
	slot_flags = SLOT_BELT
	var/use_deferred = TRUE
	drop_sound = 'sound/items/drop/backpack.ogg'

// -----------------------------
//          Trash bag
// -----------------------------
/obj/item/storage/bag/trash
	name = "trash bag"
	desc = "It's the heavy-duty black polymer kind. Time to take out the trash!"
	icon = 'icons/obj/janitor.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_janitor.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_janitor.dmi',
		)
	icon_state = "trashbag0"
	item_state = "trashbag"

	w_class = 4
	max_w_class = 2
	max_storage_space = 56
	can_hold = null // any
	cant_hold = list(/obj/item/disk/nuclear)
	drop_sound = 'sound/items/drop/wrapper.ogg'

/obj/item/storage/bag/trash/update_icon()
	if(contents.len == 0)
		icon_state = "trashbag0"
	else if(contents.len < 21)
		icon_state = "trashbag1"
	else if(contents.len < 42)
		icon_state = "trashbag2"
	else icon_state = "trashbag3"

/obj/item/storage/bag/trash/attackby(var/obj/item/I, var/mob/user)
	if (istype (I, /obj/item/device/lightreplacer))
		var/count = 0
		var/obj/item/device/lightreplacer/R = I
		var/bagfull = 0
		if (R.store_broken)
			for(var/obj/item/light/L in R.contents)
				if(!can_be_inserted(L))//This displays its own error message if the bag is full
					bagfull = 1
					break
				count++
				if (use_deferred)
					handle_item_insertion_deferred(L, user)
				else
					handle_item_insertion(L, TRUE)

			if (use_deferred)
				handle_storage_deferred(user)

			if (count)
				to_chat(user, "<span class='notice'>You empty [count] broken bulbs into the trashbag.</span>")
			else if (!bagfull)
				to_chat(user, "<span class='notice'>There are no broken bulbs to empty out.</span>")
			return 1
	..()

/obj/item/storage/bag/trash/bluespace
	name = "bluespace trash bag"
	desc = "A highly advanced trashbag with a huge storage capacity!"
	icon_state = "trashbagb0"

	max_storage_space = 128

/obj/item/storage/bag/trash/bluespace/update_icon()
	if(contents.len == 0)
		icon_state = "trashbagb0"
	else if(contents.len < 42)
		icon_state = "trashbagb1"
	else if(contents.len < 84)
		icon_state = "trashbagb2"
	else icon_state = "trashbagb3"

// -----------------------------
//        Plastic Bag
// -----------------------------

/obj/item/storage/bag/plasticbag
	name = "plastic bag"
	desc = "It's a very flimsy, very noisy alternative to a bag."
	icon = 'icons/obj/trash.dmi'
	icon_state = "plasticbag"
	item_state = "plasticbag"

	w_class = 4
	max_w_class = 2
	can_hold = null // any
	cant_hold = list(/obj/item/disk/nuclear)
	drop_sound = 'sound/items/drop/wrapper.ogg'

// -----------------------------
//          Plant bag
// -----------------------------

/obj/item/storage/bag/plants
	name = "plant bag"
	icon = 'icons/obj/hydroponics_machines.dmi'
	icon_state = "plantbag"
	max_storage_space = 100
	max_w_class = 3
	w_class = 2
	can_hold = list(/obj/item/reagent_containers/food/snacks/grown,/obj/item/seeds,/obj/item/grown)

// -----------------------------
//        Slime core bag
// -----------------------------

/obj/item/storage/bag/slimes
	name = "slime core bag"
	icon = 'icons/mob/npc/slimes.dmi'
	icon_state = "slimebag"
	desc = "A pressurized and thermoregulated bag for the storage and transport of slime cores."
	max_storage_space = 100
	max_w_class = 3
	w_class = 2
	can_hold = list(/obj/item/slime_extract)

// -----------------------------
//        Sheet Snatcher
// -----------------------------
// Because it stacks stacks, this doesn't operate normally.
// However, making it a storage/bag allows us to reuse existing code in some places. -Sayu

/obj/item/storage/bag/sheetsnatcher
	name = "sheet snatcher"
	icon = 'icons/obj/mining.dmi'
	icon_state = "sheetsnatcher"
	desc = "A patented storage system designed for any kind of mineral sheet."

	var/capacity = 300; //the number of sheets it can carry.
	w_class = 3
	storage_slots = 7

	allow_quick_empty = 1 // this function is superceded
	use_deferred = FALSE

/obj/item/storage/bag/sheetsnatcher/can_be_inserted(obj/item/W as obj, stop_messages = 0)
	if(!istype(W,/obj/item/stack/material))
		if(!stop_messages)
			to_chat(usr, "The snatcher does not accept [W].")
		return 0
	var/current = 0
	for(var/obj/item/stack/material/S in contents)
		current += S.amount
	if(capacity == current)//If it's full, you're done
		if(!stop_messages)
			to_chat(usr, "<span class='warning'>The snatcher is full.</span>")
		return 0
	return 1


// Modified handle_item_insertion.  Would prefer not to, but...
/obj/item/storage/bag/sheetsnatcher/handle_item_insertion(obj/item/W as obj, prevent_warning = 0)
	var/obj/item/stack/material/S = W
	if(!istype(S)) return 0

	var/amount
	var/inserted = 0
	var/current = 0
	for(var/obj/item/stack/material/S2 in contents)
		current += S2.amount
	if(capacity < current + S.amount)//If the stack will fill it up
		amount = capacity - current
	else
		amount = S.amount

	for(var/obj/item/stack/material/sheet in contents)
		if(S.type == sheet.type) // we are violating the amount limitation because these are not sane objects
			sheet.amount += amount	// they should only be removed through procs in this file, which split them up.
			S.amount -= amount
			inserted = 1
			break

	if(!inserted || !S.amount)
		usr.remove_from_mob(S)
		usr.update_icons()	//update our overlays
		if (usr.client && usr.s_active != src)
			usr.client.screen -= S
		S.dropped(usr)
		if(!S.amount)
			qdel(S)
		else
			S.forceMove(src)

	orient2hud(usr)
	if(usr.s_active)
		usr.s_active.show_to(usr)
	update_icon()
	return 1


// Sets up numbered display to show the stack size of each stored mineral
// NOTE: numbered display is turned off currently because it's broken
/obj/item/storage/bag/sheetsnatcher/orient2hud(mob/user as mob)
	var/adjusted_contents = contents.len

	//Numbered contents display
	var/list/datum/numbered_display/numbered_contents
	if(display_contents_with_number)
		numbered_contents = list()
		adjusted_contents = 0
		for(var/obj/item/stack/material/I in contents)
			adjusted_contents++
			var/datum/numbered_display/D = new/datum/numbered_display(I)
			D.number = I.amount
			numbered_contents.Add( D )

	var/row_num = 0
	var/col_count = min(7,storage_slots) -1
	if (adjusted_contents > 7)
		row_num = round((adjusted_contents-1) / 7) // 7 is the maximum allowed width.
	src.slot_orient_objs(row_num, col_count, numbered_contents)
	return


// Modified quick_empty verb drops appropriate sized stacks
/obj/item/storage/bag/sheetsnatcher/quick_empty()
	var/location = get_turf(src)
	for(var/obj/item/stack/material/S in contents)
		while(S.amount)
			var/obj/item/stack/material/N = new S.type(location)
			var/stacksize = min(S.amount,N.max_amount)
			N.amount = stacksize
			S.amount -= stacksize
		if(!S.amount)
			qdel(S) // todo: there's probably something missing here
	orient2hud(usr)
	if(usr.s_active)
		usr.s_active.show_to(usr)
	update_icon()

// Instead of removing
/obj/item/storage/bag/sheetsnatcher/remove_from_storage(obj/item/W as obj, atom/new_location)
	var/obj/item/stack/material/S = W
	if(!istype(S)) return 0

	//I would prefer to drop a new stack, but the item/attack_hand code
	// that calls this can't receive a different object than you clicked on.
	//Therefore, make a new stack internally that has the remainder.
	// -Sayu

	if(S.amount > S.max_amount)
		var/obj/item/stack/material/temp = new S.type(src)
		temp.amount = S.amount - S.max_amount
		S.amount = S.max_amount

	return ..(S,new_location)

// -----------------------------
//    Sheet Snatcher (Cyborg)
// -----------------------------

/obj/item/storage/bag/sheetsnatcher/borg
	name = "sheet snatcher 9000"
	desc = ""
	capacity = 500//Borgs get more because >specialization

// -----------------------------
//           Cash Bag
// -----------------------------

/obj/item/storage/bag/money
	icon = 'icons/obj/storage.dmi'
	name = "money bag"
	desc = "A bag for carrying lots of money. It's got a big dollar sign printed on the front."
	icon_state = "moneybag"
	flags = CONDUCT
	max_storage_space = 100
	w_class = 4
	can_hold = list(/obj/item/coin,/obj/item/spacecash)

/obj/item/storage/bag/money/vault

/obj/item/storage/bag/money/vault/New()
	..()
	new /obj/item/coin/silver(src)
	new /obj/item/coin/silver(src)
	new /obj/item/coin/silver(src)
	new /obj/item/coin/silver(src)
	new /obj/item/coin/gold(src)
	new /obj/item/coin/gold(src)

// -----------------------------
//           Book bag
// -----------------------------


/obj/item/storage/bag/books
	name = "book bag"
	desc = "A bag for books."
	icon = 'icons/obj/library.dmi'
	icon_state = "bookbag"
	storage_slots = 7
	max_storage_space = 200
	max_w_class = 3
	w_class = 3
	can_hold = list(/obj/item/book, /obj/item/spellbook)

