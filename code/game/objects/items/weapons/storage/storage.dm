// To clarify:
// For use_to_pickup and allow_quick_gather functionality,
// see item/attackby() (/game/objects/items.dm)
// Do not remove this functionality without good reason, cough reagent_containers cough.
// -Sayu

// Because tick_checking this code gets funky (it's bound directly into user interaction)
// We instead cap the amount of maximum storage space to 200. A loop that should be fine
// for the server to handle without dying.
#define STORAGE_SPACE_CAP 200

/obj/storage_bullshit
	layer = HUD_BASE_LAYER

/obj/item/storage
	name = "storage"
	w_class = ITEMSIZE_NORMAL

	///List of objects which this item can store (if set, it can't store anything else)
	var/list/can_hold

	///Boolean, if strict, the exact path has to be matched
	var/can_hold_strict = FALSE

	///List of objects which this item can't store (in effect only if can_hold isn't set)
	var/list/cant_hold

	///List of mobs which are currently seeing the contents of this item's storage
	var/list/is_seeing

	///Max size of objects that this object can store (in effect only if can_hold isn't set)
	var/max_w_class = ITEMSIZE_NORMAL

	///The sum of the storage costs of all the items in this storage item
	var/max_storage_space = 8

	///The number of storage slots in this container
	var/storage_slots

	///The number of columns the storage item will appear to have
	var/force_column_number

	var/obj/screen/storage/boxes

	///storage UI
	var/obj/screen/storage/storage_start

	var/obj/screen/storage/storage_continue
	var/obj/screen/storage/storage_end
	var/list/storage_screens = list()
	var/obj/screen/close/closer
	var/care_about_storage_depth = TRUE

	///Set this to make it possible to use this item in an inverse way, so you can have the item in your hand and click items on the floor to pick them up.
	var/use_to_pickup

	///A list of blacklisted items; if you click a blacklisted item, it won't try to pick it up if use_to_pickup is true
	var/list/pickup_blacklist = list()

	///Set this to make the storage item group contents of the same type and display them as a number.
	var/display_contents_with_number

	/// Set if you want the item's initials to be displayed on the bottom left of the item. only works when display_contents_with_number is true
	var/display_contents_initials

	///Set this variable to allow the object to have the 'empty' verb, which dumps all the contents on the floor.
	var/allow_quick_empty

	///Set this variable to allow the object to have the 'toggle mode' verb, which quickly collects all items from a tile.
	var/allow_quick_gather

	///Boolean, `FALSE` = pick one at a time, `TRUE` = pick all on tile
	var/collection_mode = TRUE

	///Sound played when used. null for no sound.
	var/use_sound = /singleton/sound_category/rustle_sound

	/// List of pre-filled items
	var/list/starts_with

	///Time it takes to empty bag, this is multiplies by number of objects stored
	var/empty_delay = 0 SECOND

	///Boolean, whether or not we should have the squish animation when inserting and removing objects
	var/animated = TRUE

/obj/item/storage/Destroy()
	close_all()
	QDEL_NULL(boxes)
	QDEL_NULL(storage_start)
	QDEL_NULL(storage_continue)
	QDEL_NULL(storage_end)
	QDEL_LIST(storage_screens)
	QDEL_NULL(closer)
	return ..()

/obj/item/storage/resolve_attackby(atom/A, mob/user, click_parameters)
	. = ..()

	//Can't be used to pick up things by clicking them
	if(!use_to_pickup)
		return

	//Pick up everything in a tile
	if(collection_mode)
		var/turf/location_to_pickup = null
		if(isturf(A))
			location_to_pickup = A
		else
			var/turf/possible_turf_location = get_turf(A)
			if(isturf(possible_turf_location))
				location_to_pickup = possible_turf_location

		//If we found a turf, pick up things from there
		if(location_to_pickup)
			pickup_items_from_loc_and_feedback(user, location_to_pickup)

	//Pick up one thing at a time
	else
		if(can_be_inserted(A))
			handle_item_insertion(A, FALSE, user)

/**
 * Pick up item from a location, respecting the tick time, and feedback the user
 *
 * This process can sleep
 *
 * * user - The user trying to pick up things
 * * location - A `/turf` to pick up things from
 */
/obj/item/storage/proc/pickup_items_from_loc_and_feedback(mob/user, turf/location)
	set waitfor = FALSE

	//pickup_result[1] is if there's any success, pickup_result[2] is if there's any failure
	//both are booleans
	var/list/pickup_result = pickup_items_from_loc(user, location)

	//Choose the feedback message depending on what happened and send it to the user
	var/pickup_feedback_message
	if(pickup_result[1] && !pickup_result[2])
		pickup_feedback_message = SPAN_NOTICE("You put everything in \the [src].")

	else if(pickup_result[1] && pickup_result[2])
		pickup_feedback_message = SPAN_NOTICE("You put some things in \the [src].")

	else if(!pickup_result[1] && pickup_result[2])
		pickup_feedback_message = SPAN_NOTICE("You fail to pick anything up with \the [src].")

	//Check if we got a feedback message and, if so, send it to the user
	if(pickup_feedback_message)
		to_chat(user, pickup_feedback_message)

/**
 * Pick up item from a location, respecting the tick time
 *
 * Returns a `/list` in the format of `(SUCCESS, FAILURE)` (both booleans),
 * the first indicates if there was any successful pickup, the later if there was any failed pickup
 *
 * * user - The user trying to pick up things
 * * location - A `/turf` to pick up things from
 */
/obj/item/storage/proc/pickup_items_from_loc(mob/user, turf/location)

	//In the format of list(SUCCESS, FAILURE)
	var/list/return_status = list(FALSE, FALSE)
	RETURN_TYPE(return_status)

	var/list/rejections = list()

	//So we know where the user is when the pickup starts
	var/original_location = user ? get_turf(user) : null

	for(var/obj/item/item in location)
		if(rejections[item.type]) // To limit bag spamming: any given type only complains once
			continue

		if (user && get_turf(user) != original_location)
			break

		if(!can_be_inserted(item))	// Note can_be_inserted still makes noise when the answer is no
			rejections[item.type] = TRUE	// therefore full bags are still a little spammy
			return_status[2] = TRUE
			CHECK_TICK
			continue

		return_status[1] = TRUE
		handle_item_insertion_deferred(item, user)
		CHECK_TICK	// Because people insist on picking up huge-ass piles of stuff.

	//Refresh the icon, add fingerprints and whatnot if we have picked up anything
	if(return_status[1])
		handle_storage_deferred(user)

	return return_status


/obj/item/storage/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(isobserver(user))
		. += "It contains: [counting_english_list(contents)]"

/obj/item/storage/MouseDrop(obj/over_object)
	if(!canremove)
		return
	if(!over_object || over_object == src)
		return
	if(istype(over_object, /obj/screen/inventory))
		var/obj/screen/inventory/S = over_object
		if(S.slot_id == src.equip_slot)
			return
	if(ishuman(usr) || issmall(usr)) //so monkeys can take off their backpacks -- Urist
		if(over_object == usr && Adjacent(usr)) // this must come before the screen objects only block
			src.open(usr)
			return
		if(!(istype(over_object, /obj/screen)))
			return ..()

		//makes sure that the storage is equipped, so that we can't drag it into our hand from miles away.
		//there's got to be a better way of doing this.
		if(!(src.loc == usr) || (src.loc && src.loc.loc == usr))
			return
		if(use_check_and_message(usr))
			return
		if((src.loc == usr) && !usr.unEquip(src))
			return

		switch(over_object.name)
			if("right hand")
				usr.u_equip(src)
				usr.equip_to_slot_if_possible(src, slot_r_hand)
			if("left hand")
				usr.u_equip(src)
				usr.equip_to_slot_if_possible(src, slot_l_hand)
		src.add_fingerprint(usr)

/obj/item/storage/AltClick(var/mob/usr)
	if(!canremove)
		return ..()
	if (!use_check_and_message(usr))
		add_fingerprint(usr)
		open(usr)
		return TRUE
	. = ..()

/obj/item/storage/proc/return_inv()
	. = contents.Copy()

	for(var/obj/item/storage/S in src)
		. += S.return_inv()
	for(var/obj/item/gift/G in src)
		. += G.gift
		if (istype(G.gift, /obj/item/storage))
			. += G.gift:return_inv()

/obj/item/storage/proc/show_to(mob/user as mob)
	if(user.s_active != src)
		for(var/obj/item/I in src)
			if(I.on_found(user))
				return
	if(user.s_active)
		user.s_active.hide_from(user)
	user.client.screen -= boxes
	user.client.screen -= storage_start
	user.client.screen -= storage_continue
	user.client.screen -= storage_end
	user.client.screen -= closer
	user.client.screen -= contents
	user.client.screen += closer
	user.client.screen += contents
	if(storage_slots)
		user.client.screen += boxes
	else
		user.client.screen += storage_start
		user.client.screen += storage_continue
		user.client.screen += storage_end
	user.s_active = src
	LAZYADD(is_seeing, user)
	return

/obj/item/storage/proc/hide_from(mob/user as mob)

	if(!user.client)
		return
	user.client.screen -= boxes
	user.client.screen -= storage_start
	user.client.screen -= storage_continue
	user.client.screen -= storage_end
	user.client.screen -= closer
	user.client.screen -= contents
	if(user.s_active == src)
		user.s_active = null

	LAZYREMOVE(is_seeing, user)

/obj/item/storage/proc/open(mob/user as mob)
	if (use_sound)
		playsound(src.loc, src.use_sound, 50, 0, -5)
	if(animated)
		animate_parent()

	orient2hud(user)
	if (user.s_active)
		user.s_active.close(user)
	show_to(user)

/obj/item/storage/proc/close(mob/user as mob)
	hide_from(user)
	user.s_active = null
	if(!length(can_see_contents()))
		storage_start.vis_contents = list()
		QDEL_LIST(storage_screens)
		storage_screens = list()

/obj/item/storage/proc/close_all()
	for(var/mob/M in can_see_contents())
		close(M)
		. = 1

/obj/item/storage/proc/can_see_contents()
	var/list/cansee = list()
	for(var/mob/M in is_seeing)
		if(M.s_active == src && M.client)
			cansee |= M
		else
			LAZYREMOVE(is_seeing, M)
	return cansee


/obj/item/storage/proc/update_storage_ui()
	for(var/mob/seer as anything in is_seeing)
		orient2hud(seer)
		if(seer.s_active)
			seer.s_active.show_to(seer)

//This proc draws out the inventory and places the items on it. tx and ty are the upper left tile and mx, my are the bottm right.
//The numbers are calculated from the bottom-left The bottom-left slot being 1,1.
/obj/item/storage/proc/orient_objs(tx, ty, mx, my)
	var/cx = tx
	var/cy = ty
	src.boxes.screen_loc = "[tx]:,[ty] to [mx],[my]"
	for(var/obj/O in src.contents)
		O.screen_loc = "[cx],[cy]"
		O.hud_layerise()
		cx++
		if (cx > mx)
			cx = tx
			cy--
	src.closer.screen_loc = "[mx+1],[my]"
	return

//This proc draws out the inventory and places the items on it. It uses the standard position.
/obj/item/storage/proc/slot_orient_objs(var/rows, var/cols, var/list/obj/item/display_contents)
	var/cx = 4
	var/cy = 2+rows
	src.boxes.screen_loc = "4:16,2:16 to [4+cols]:16,[2+rows]:16"

	if(display_contents_with_number)
		for(var/datum/numbered_display/ND in display_contents)
			ND.sample_object.screen_loc = "[cx]:16,[cy]:16"
			ND.sample_object.maptext = SMALL_FONTS(7, "[(ND.number > 1)? "[ND.number]" : ""]")
			ND.sample_object.hud_layerise()
			if(display_contents_initials)
				ND.sample_object.cut_overlays() // a limitation of this code is that overlays get blasted off the item, since we need to add one to add the second maptext. woe is me
				var/object_initials = handle_name_initials(ND.sample_object.name)
				var/image/name_overlay = image(null)
				name_overlay.maptext = SMALL_FONTS(7, object_initials)
				name_overlay.maptext_x = 22 - ((length(object_initials) - 1) * 6)
				ND.sample_object.add_overlay(name_overlay)
			cx++
			if (cx > (4+cols))
				cx = 4
				cy--
	else
		for(var/obj/O in contents)
			O.screen_loc = "[cx]:16,[cy]:16"
			O.maptext = ""
			O.hud_layerise()
			cx++
			if (cx > (4+cols))
				cx = 4
				cy--
	closer.screen_loc = "[4+cols+1]:16,2:16"

/obj/item/storage/proc/handle_name_initials(var/sample_name)
	var/name_initials = ""
	var/list/split_name = splittext(sample_name, " ")
	for(var/name_section in split_name)
		name_initials += uppertext(name_section[1])
	return name_initials

/obj/item/storage/proc/space_orient_objs(list/obj/item/display_contents, defer_overlays = FALSE)

	var/baseline_max_storage_space = 16 //should be equal to default backpack capacity
	var/storage_cap_width = 2 //length of sprite for start and end of the box representing total storage space
	var/stored_cap_width = 4 //length of sprite for start and end of the box representing the stored item
	var/storage_width = min( round( 224 * max_storage_space/baseline_max_storage_space ,1) ,284) //length of sprite for the box representing total storage space

	storage_start.cut_overlays()

	var/matrix/M = matrix()
	M.Scale((storage_width-storage_cap_width*2+3)/32,1)
	storage_continue.transform = M

	storage_start.screen_loc = "4:16,2:16"
	storage_continue.screen_loc = "4:[storage_cap_width+(storage_width-storage_cap_width*2)/2+2],2:16"
	storage_end.screen_loc = "4:[19+storage_width-storage_cap_width],2:16"

	var/startpoint = 0
	var/endpoint = 1

	storage_start.vis_contents = list()
	QDEL_LIST(storage_screens)
	storage_screens = list()

	for(var/obj/item/O in contents)
		startpoint = endpoint + 1
		endpoint += storage_width * O.get_storage_cost()/max_storage_space

		var/obj/screen/storage/background/stored_start = new /obj/screen/storage/background(null, O, "stored_start")
		var/obj/screen/storage/background/stored_continue = new /obj/screen/storage/background(null, O, "stored_continue")
		var/obj/screen/storage/background/stored_end = new /obj/screen/storage/background(null, O, "stored_end")

		var/matrix/M_start = matrix()
		var/matrix/M_continue = matrix()
		var/matrix/M_end = matrix()
		M_start.Translate(startpoint,0)
		M_continue.Scale((endpoint-startpoint-stored_cap_width*2)/32,1)
		M_continue.Translate(startpoint+stored_cap_width+(endpoint-startpoint-stored_cap_width*2)/2 - 16,0)
		M_end.Translate(endpoint-stored_cap_width,0)
		stored_start.transform = M_start
		stored_continue.transform = M_continue
		stored_end.transform = M_end

		storage_screens += list(stored_start, stored_continue, stored_end)
		storage_start.add_vis_contents(list(stored_start, stored_continue, stored_end))

		O.screen_loc = "4:[round((startpoint+endpoint)/2)+2],2:16"
		O.maptext = ""
		O.hud_layerise()

	if (!defer_overlays)
		storage_start.compile_overlays()

	closer.screen_loc = "4:[storage_width+19],2:16"
	return

/datum/numbered_display
	var/obj/item/sample_object
	var/number

/datum/numbered_display/New(obj/item/sample as obj)
	if(!istype(sample))
		qdel(src)
	sample_object = sample
	number = 1

//This proc determins the size of the inventory to be displayed. Please touch it only if you know what you're doing.
/obj/item/storage/proc/orient2hud(mob/user as mob, defer_overlays = FALSE)

	var/adjusted_contents = contents.len

	//Numbered contents display
	var/list/datum/numbered_display/numbered_contents
	if(display_contents_with_number)
		numbered_contents = list()
		adjusted_contents = 0
		for(var/obj/item/I in contents)
			var/found = 0
			for(var/datum/numbered_display/ND in numbered_contents)
				if(ND.sample_object.type == I.type)
					ND.number++
					found = 1
					break
			if(!found)
				adjusted_contents++
				numbered_contents.Add( new/datum/numbered_display(I) )

	if(storage_slots == null)
		space_orient_objs(numbered_contents, defer_overlays)
	else
		var/row_num = 0
		var/col_count = force_column_number ? force_column_number : min(7, storage_slots) - 1
		if (adjusted_contents > 7)
			row_num = round((adjusted_contents-1) / 7) // 7 is the maximum allowed width.
		src.slot_orient_objs(row_num, col_count, numbered_contents)
	return

/**
 * Checks if an item can be inserted in the storage
 *
 * Returns `TRUE` if it can be inserted, `FALSE` otherwise
 *
 * * item_to_check - The `/obj` to check if it can be inserted
 * * stop_messages - Boolean, if `TRUE`, prevents this proc from giving feedback messages
 */
/obj/item/storage/proc/can_be_inserted(obj/item/item_to_check, stop_messages = FALSE)
	SHOULD_NOT_SLEEP(TRUE)

	if(!istype(item_to_check))
		return FALSE

	if(usr && usr.isEquipped(item_to_check) && !usr.canUnEquip(item_to_check))
		return FALSE

	if(!item_to_check.dropsafety())
		return FALSE

	//Check if the item is in the storage already
	if(src.loc == item_to_check)
		return FALSE

	//Check if the storage is full, or in blacklist
	if(storage_slots != null && contents.len >= storage_slots)
		if(!stop_messages || is_type_in_list(item_to_check, pickup_blacklist)) // the is_type_in_list is a bit risky, but you tend to not want to pick up things in your blacklist anyway
			to_chat(usr, SPAN_NOTICE("\The [src] is full, make some space."))
		return FALSE

	//Check if the item is anchored
	if(item_to_check.anchored)
		return FALSE

	//Whitelist check for item holding
	if(LAZYLEN(can_hold))
		var/can_hold_item = can_hold_strict ? (item_to_check.type in can_hold) : is_type_in_list(item_to_check, can_hold)
		if(!can_hold_item)
			if(!stop_messages && ! istype(item_to_check, /obj/item/device/hand_labeler))
				to_chat(usr, SPAN_NOTICE("\The [src] cannot hold \the [item_to_check]."))
			return FALSE
		var/max_instances = can_hold[item_to_check.type]
		if(max_instances && instances_of_type_in_list(item_to_check, contents, TRUE) >= max_instances)
			if(!stop_messages && !istype(item_to_check, /obj/item/device/hand_labeler))
				to_chat(usr, SPAN_NOTICE("\The [src] has no more space specifically for \the [item_to_check]."))
			return FALSE

	//Blacklist check for item holding
	if(LAZYLEN(cant_hold) && is_type_in_list(item_to_check, cant_hold))
		if(!stop_messages)
			to_chat(usr, SPAN_NOTICE("\The [src] cannot hold [item_to_check]."))
		return FALSE

	//Size (lenght) check for item holding
	if (max_w_class != null && item_to_check.w_class > max_w_class)
		if(!stop_messages)
			to_chat(usr, SPAN_NOTICE("\The [item_to_check] is too long for this [src]."))
		return FALSE

	var/total_storage_space = item_to_check.get_storage_cost()
	for(var/obj/item/I in contents)
		total_storage_space += I.get_storage_cost() //Adds up the combined w_classes which will be in the storage item if the item is added to it.

	if(total_storage_space > max_storage_space)
		if(!stop_messages)
			to_chat(usr, SPAN_NOTICE("\The [src] is too full, make some space."))
		return FALSE

	//To prevent the stacking of same sized storage items
	if(item_to_check.w_class >= src.w_class && (istype(item_to_check, /obj/item/storage)))
		if(!stop_messages)
			to_chat(usr, SPAN_NOTICE("\The [src] cannot hold [item_to_check] as it's a storage item of the same size."))
		return FALSE

	return TRUE

//This proc handles items being inserted. It does not perform any checks of whether an item can or can't be inserted. That's done by can_be_inserted()
//The stop_warning parameter will stop the insertion message from being displayed. It is intended for cases where you are inserting multiple items at once,
//such as when picking up all the items on a tile with one click.
/obj/item/storage/proc/handle_item_insertion(obj/item/W as obj, prevent_warning = 0, mob/user = usr)
	if(!istype(W)) return 0
	if(user)
		user.prepare_for_slotmove(W)
	W.forceMove(src)
	W.on_enter_storage(src)
	if(use_sound)
		playsound(src.loc, src.use_sound, 50, 0, -5)
	if(animated)
		animate_parent()
	if(user)
		W.dropped(user)
		if(!istype(W, /obj/item/forensics))
			add_fingerprint(user)

		if(!prevent_warning)
			for(var/mob/M in viewers(user, null))
				if(M == usr)
					continue
				else if (M in range(1)) //If someone is standing close enough, they can tell what it is...
					M.show_message(SPAN_NOTICE("\The [user] puts [W] into [src]."))
				else if (W && W.w_class >= ITEMSIZE_NORMAL) //Otherwise they can only see large or normal items from a distance...
					M.show_message(SPAN_NOTICE("\The [user] puts [W] into [src]."))
		orient2hud(user)
		if(user.s_active)
			user.s_active.show_to(user)
	queue_icon_update()
	return 1

/**
 * This is for inserting more than one thing at a time,
 * you should call `handle_storage_deferred` after all the items have been inserted
 */
/obj/item/storage/proc/handle_item_insertion_deferred(obj/item/W, mob/user)
	SHOULD_NOT_SLEEP(TRUE)

	if (!istype(W))
		return FALSE

	if (user)
		user.prepare_for_slotmove(W)

	W.forceMove(src)
	W.on_enter_storage(src)
	if (user)
		W.dropped(user)

/obj/item/storage/proc/handle_storage_deferred(mob/user)
	add_fingerprint(user)
	user.update_icon()
	orient2hud(user)
	if (user.s_active)
		user.s_active.show_to(user)
	queue_icon_update()

//Call this proc to handle the removal of an item from the storage item. The item will be moved to the atom sent as new_target
/obj/item/storage/proc/remove_from_storage(obj/item/W, atom/new_location)
	if(!istype(W))
		return FALSE

	if(animated)
		animate_parent()

	if(istype(src, /obj/item/storage/box/fancy))
		var/obj/item/storage/box/fancy/F = src
		F.update_icon(TRUE)

	for(var/mob/M in range(1, get_turf(src)))
		if(M.s_active == src)
			if(M.client)
				M.client.screen -= W

	if(new_location)
		if(ismob(loc))
			W.dropped(usr)
		if(ismob(new_location))
			W.hud_layerise()
		else
			W.reset_plane_and_layer()
		W.forceMove(new_location)
	else
		W.forceMove(get_turf(src))

	if(usr)
		src.orient2hud(usr)
		if(usr.s_active)
			usr.s_active.show_to(usr)
	if(W.maptext)
		W.maptext = ""
	if(display_contents_initials)
		W.cut_overlays()
	W.on_exit_storage(src)
	update_icon()
	return TRUE

/obj/item/storage/proc/remove_from_storage_deferred(obj/item/W, atom/new_location, mob/user)
	if(!istype(W))
		return FALSE

	// fuck if I know.
	for(var/mob/M in range(1, get_turf(src)))
		if(M.s_active == src)
			if(M.client)
				M.client.screen -= W

	if(new_location)
		if(ismob(loc))
			W.dropped(user)
		if(ismob(new_location))
			W.hud_layerise()
		else
			W.reset_plane_and_layer()
		W.forceMove(new_location)
	else
		W.forceMove(get_turf(src))

	if(W.maptext)
		W.maptext = ""

	W.on_exit_storage(src)

	return TRUE

/obj/item/storage/proc/post_remove_from_storage_deferred(atom/oldloc, mob/user)
	orient2hud(user)
	if (user.s_active)
		user.s_active.show_to(user)

	// who knows what the fuck this does
	if (istype(src, /obj/item/storage/box/fancy))
		update_icon(1)
	else
		update_icon()

//This proc is called when you want to place an item into the storage item.
//Its a safe proc for adding things to the storage that does the necessary checks. Object will not be moved if it fails
/obj/item/storage/proc/insert_into_storage(obj/item/W as obj, var/prevent_messages = 1)
	if(!can_be_inserted(W, prevent_messages))
		return

	return handle_item_insertion(W, prevent_messages)

/obj/item/storage/attackby(obj/item/attacking_item, mob/user)
	..()

	if(!attacking_item.dropsafety())
		return.

	if(istype(attacking_item, /obj/item/device/lightreplacer))
		var/obj/item/device/lightreplacer/LP = attacking_item
		var/amt_inserted = 0
		var/turf/T = get_turf(user)
		for(var/obj/item/light/L in src.contents)
			if(L.status == 0)
				if(LP.uses < LP.max_uses)
					LP.AddUses(1)
					amt_inserted++
					remove_from_storage(L, T)
					qdel(L)
		if(amt_inserted)
			to_chat(user, "You inserted [amt_inserted] light\s into \the [LP.name]. You have [LP.uses] light\s remaining.")
			return

	if(!can_be_inserted(attacking_item))
		return

	if(istype(attacking_item, /obj/item/tray))
		var/obj/item/tray/T = attacking_item
		if(T.current_weight > 0)
			T.spill(user)
			to_chat(user, "<span class='warning'>Trying to place a loaded tray into [src] was a bad idea.</span>")
			return

	if(istype(attacking_item, /obj/item/device/hand_labeler))
		var/obj/item/device/hand_labeler/HL = attacking_item
		if(HL.mode == 1)
			return

	attacking_item.add_fingerprint(user)
	return handle_item_insertion(attacking_item, null, user)

/obj/item/storage/dropped(mob/user)
	return ..()

/obj/item/storage/attack_hand(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.l_store == src && !H.get_active_hand())	//Prevents opening if it's in a pocket.
			H.put_in_hands(src)
			H.l_store = null
			return
		if(H.r_store == src && !H.get_active_hand())
			H.put_in_hands(src)
			H.r_store = null
			return

	if (src.loc == user)
		src.open(user)
	else
		..()
		for(var/mob/M in range(1, get_turf(src)) - user)
			if (M.s_active == src)
				src.close(M)
	src.add_fingerprint(user)
	return

/obj/item/storage/handle_middle_mouse_click(var/mob/user)
	if(Adjacent(user))
		open(user)
		return TRUE
	return FALSE

/obj/item/storage/verb/toggle_gathering_mode()
	set name = "Switch Gathering Method"
	set category = "Object"
	set src in usr

	collection_mode = !collection_mode
	switch (collection_mode)
		if(1)
			to_chat(usr, "[src] now picks up all items in a tile at once.")
		if(0)
			to_chat(usr, "[src] now picks up one item at a time.")


/obj/item/storage/verb/quick_empty()
	set name = "Empty Contents"
	set category = "Object"
	set src in usr

	if((!ishuman(usr) && (src.loc != usr)) || usr.stat || usr.restrained())
		return

	if(empty_delay)
		usr.visible_message("\The [usr] starts to empty the contents of \the [src]...", SPAN_NOTICE("You start emptying the contents of \the [src]..."))

	if(!do_after(usr, contents.len * empty_delay))
		return

	var/turf/T = get_turf(src)
	hide_from(usr)
	for(var/obj/item/I in contents)
		remove_from_storage_deferred(I, T, usr)

		CHECK_TICK

	post_remove_from_storage_deferred(loc, usr)
	usr.visible_message("<b>\The [usr]</b> empties the contents of \the [src].", , SPAN_NOTICE("You empty the contents of \the [src]."))

// Override this to fill the storage object with stuff.
/obj/item/storage/proc/fill()
	if(LAZYLEN(starts_with))
		for(var/t in starts_with)
			if(!ispath(t))
				crash_with("[t] in [src]'s starts_with list is not a path!")
				continue
			for(var/i=0, i<starts_with[t], i++)
				new t(src)
	return

/obj/item/storage/Initialize(mapload, defer_shrinkwrap = FALSE)
	. = ..()

	if (max_storage_space > STORAGE_SPACE_CAP)
		LOG_DEBUG("STORAGE: [type] exceed STORAGE_SPACE_CAP. It has been reset to [STORAGE_SPACE_CAP].")
		max_storage_space = STORAGE_SPACE_CAP

	fill()

	if(!allow_quick_empty)
		verbs -= /obj/item/storage/verb/quick_empty

	if(!allow_quick_gather)
		verbs -= /obj/item/storage/verb/toggle_gathering_mode

	boxes = new /obj/screen/storage{icon_state = "block"}
	boxes.master = src

	storage_start = new /obj/screen/storage{icon_state = "storage_start"}
	storage_start.master = src
	storage_start.layer = HUD_BASE_LAYER

	storage_continue = new /obj/screen/storage{icon_state = "storage_continue"}
	storage_continue.master = src
	storage_continue.layer = HUD_BASE_LAYER

	storage_end = new /obj/screen/storage{icon_state = "storage_end"}
	storage_end.master = src
	storage_end.layer = HUD_BASE_LAYER

	closer = new /obj/screen/close{
		icon_state = "x";
	}
	closer.master = src
	closer.layer = HUD_BASE_LAYER
	orient2hud(null, mapload)

	if (defer_shrinkwrap)	// Caller wants to defer shrinkwrapping until after the current callstack; probably putting something in.
		INVOKE_ASYNC(src, PROC_REF(shrinkwrap))
	else
		shrinkwrap()

// Adjusts this storage object's max capacity to exactly the storage required by its contents. Will not decrease max storage capacity, only increase it.
/obj/item/storage/proc/shrinkwrap()
	var/total_storage_space = 0
	for(var/obj/item/I in contents)
		total_storage_space += I.get_storage_cost()
	max_storage_space = max(total_storage_space,max_storage_space) //prevents spawned containers from being too small for their contents

/obj/item/storage/emp_act(severity)
	. = ..()

	if(!istype(src.loc, /mob/living))
		for(var/obj/O in contents)
			O.emp_act(severity)

/obj/item/storage/attack_self(mob/user as mob)
	//Clicking on itself will empty it, if it has the verb to do that.
	if(user.get_active_hand() == src)
		if(src.verbs.Find(/obj/item/storage/verb/quick_empty))
			src.quick_empty()
			return 1

/obj/item/storage/CtrlClick(mob/user)
	if(user.get_active_hand() == src)
		if(src.verbs.Find(/obj/item/storage/verb/quick_empty))
			src.quick_empty()
			return
	..()

/obj/item/storage/proc/make_exact_fit()
	storage_slots = contents.len

	can_hold = list()
	max_w_class = 0
	max_storage_space = 0
	for(var/obj/item/I in src)
		can_hold[I.type]++
		max_w_class = max(I.w_class, max_w_class)
		max_storage_space += I.get_storage_cost()

//Useful for spilling the contents of containers all over the floor
/obj/item/storage/proc/spill(var/dist = 2, var/turf/T = null)
	if (!T || !istype(T, /turf))//If its not on the floor this might cause issues
		T = get_turf(src)

	for (var/obj/O in contents)
		remove_from_storage(O, T)
		O.tumble(2)

// putting a sticker on something puts it in its contents, storage items use their contents to store their items
/obj/item/storage/can_attach_sticker(var/mob/user, var/obj/item/sticker/S)
	return FALSE

/obj/item/storage/proc/animate_parent()
	var/matrix/M = src.transform
	animate(src, time = 1.5, loop = 0, transform = src.transform.Scale(1.07, 0.9))
	animate(time = 2, transform = M)

//Returns the storage depth of an atom. This is the number of storage items the atom is contained in before reaching toplevel (the area).
//Returns -1 if the atom was not found on container.
/atom/proc/storage_depth(atom/container)
	var/depth = 0
	var/atom/cur_atom = src

	if(istype(cur_atom.loc, /obj/item/storage))
		var/obj/item/storage/S = cur_atom.loc
		if(!S.care_about_storage_depth)
			return 1

	while (cur_atom && !(cur_atom in container.contents))
		if (isarea(cur_atom))
			return -1
		if (istype(cur_atom.loc, /obj/item/storage))
			depth++
		cur_atom = cur_atom.loc

	if (!cur_atom)
		return -1	//inside something with a null loc.

	return depth

//Like storage depth, but returns the depth to the nearest turf
//Returns -1 if no top level turf (a loc was null somewhere, or a non-turf atom's loc was an area somehow).
/atom/proc/storage_depth_turf()
	var/depth = 0
	var/atom/cur_atom = src

	if(istype(cur_atom.loc, /obj/item/storage))
		var/obj/item/storage/S = cur_atom.loc
		if(!S.care_about_storage_depth)
			return 1

	while (cur_atom && !isturf(cur_atom))
		if (isarea(cur_atom))
			return -1
		if (istype(cur_atom.loc, /obj/item/storage))
			depth++
		cur_atom = cur_atom.loc

	if (!cur_atom)
		return -1	//inside something with a null loc.

	return depth

/obj/item/proc/get_storage_cost()
	if (storage_cost)
		return storage_cost
	else
		if(w_class == ITEMSIZE_TINY)
			return 1
		if(w_class == ITEMSIZE_SMALL)
			return 2
		if(w_class == ITEMSIZE_NORMAL)
			return 4
		if(w_class == ITEMSIZE_LARGE)
			return 8
		if(w_class == ITEMSIZE_HUGE)
			return 16
		else
			return 1000

		//return 2**(w_class-1) //1,2,4,8,16,...

#undef STORAGE_SPACE_CAP
