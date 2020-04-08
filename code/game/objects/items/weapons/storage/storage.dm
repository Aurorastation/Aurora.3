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
	layer = SCREEN_LAYER

/obj/item/storage
	name = "storage"
	icon = 'icons/obj/storage.dmi'
	w_class = 3
	var/list/can_hold  //List of objects which this item can store (if set, it can't store anything else)
	var/list/cant_hold //List of objects which this item can't store (in effect only if can_hold isn't set)
	var/list/is_seeing //List of mobs which are currently seeing the contents of this item's storage
	var/max_w_class = 3 //Max size of objects that this object can store (in effect only if can_hold isn't set)
	var/max_storage_space = 8 //The sum of the storage costs of all the items in this storage item.
	var/storage_slots //The number of storage slots in this container.
	var/obj/screen/storage/boxes
	var/obj/screen/storage/storage_start //storage UI
	var/obj/screen/storage/storage_continue
	var/obj/screen/storage/storage_end
	var/obj/screen/storage/stored_start
	var/obj/screen/storage/stored_continue
	var/obj/screen/storage/stored_end
	var/obj/screen/close/closer
	var/use_to_pickup	//Set this to make it possible to use this item in an inverse way, so you can have the item in your hand and click items on the floor to pick them up.
	var/list/pickup_blacklist = list() // If you click a blacklisted item, it won't try to pick it up if use_to_pickup is true
	var/display_contents_with_number	//Set this to make the storage item group contents of the same type and display them as a number.
	var/allow_quick_empty	//Set this variable to allow the object to have the 'empty' verb, which dumps all the contents on the floor.
	var/allow_quick_gather	//Set this variable to allow the object to have the 'toggle mode' verb, which quickly collects all items from a tile.
	var/collection_mode = 1  //0 = pick one at a time, 1 = pick all on tile
	var/use_sound = "rustle"	//sound played when used. null for no sound.
	var/list/starts_with // for pre-filled items
	var/empty_delay = 0 SECOND // time it takes to empty bag. this is multiplies by number of objects stored

/obj/item/storage/Destroy()
	close_all()
	QDEL_NULL(boxes)
	QDEL_NULL(storage_start)
	QDEL_NULL(storage_continue)
	QDEL_NULL(storage_end)
	QDEL_NULL(stored_start)
	QDEL_NULL(stored_continue)
	QDEL_NULL(stored_end)
	QDEL_NULL(closer)
	return ..()

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
			if(BP_R_HAND)
				usr.u_equip(src)
				usr.put_in_r_hand(src,FALSE)
			if(BP_L_HAND)
				usr.u_equip(src)
				usr.put_in_l_hand(src,FALSE)
		src.add_fingerprint(usr)

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

	orient2hud(user)
	if (user.s_active)
		user.s_active.close(user)
	show_to(user)

/obj/item/storage/proc/close(mob/user as mob)
	hide_from(user)
	user.s_active = null
	return

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

//This proc draws out the inventory and places the items on it. tx and ty are the upper left tile and mx, my are the bottm right.
//The numbers are calculated from the bottom-left The bottom-left slot being 1,1.
/obj/item/storage/proc/orient_objs(tx, ty, mx, my)
	var/cx = tx
	var/cy = ty
	src.boxes.screen_loc = "[tx]:,[ty] to [mx],[my]"
	for(var/obj/O in src.contents)
		O.screen_loc = "[cx],[cy]"
		O.layer = SCREEN_LAYER+0.01
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
			ND.sample_object.maptext = "<font color='white'>[(ND.number > 1)? "[ND.number]" : ""]</font>"
			ND.sample_object.layer = SCREEN_LAYER+0.01
			cx++
			if (cx > (4+cols))
				cx = 4
				cy--
	else
		for(var/obj/O in contents)
			O.screen_loc = "[cx]:16,[cy]:16"
			O.maptext = ""
			O.layer = SCREEN_LAYER+0.01
			cx++
			if (cx > (4+cols))
				cx = 4
				cy--
	closer.screen_loc = "[4+cols+1]:16,2:16"
	return

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

	for(var/obj/item/O in contents)
		startpoint = endpoint + 1
		endpoint += storage_width * O.get_storage_cost()/max_storage_space

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
		storage_start.add_overlay(list(stored_start, stored_continue, stored_end))

		O.screen_loc = "4:[round((startpoint+endpoint)/2)+2],2:16"
		O.maptext = ""
		O.layer = SCREEN_LAYER+0.01

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
		var/col_count = min(7,storage_slots) -1
		if (adjusted_contents > 7)
			row_num = round((adjusted_contents-1) / 7) // 7 is the maximum allowed width.
		src.slot_orient_objs(row_num, col_count, numbered_contents)
	return

//This proc return 1 if the item can be picked up and 0 if it can't.
//Set the stop_messages to stop it from printing messages
/obj/item/storage/proc/can_be_inserted(obj/item/W as obj, stop_messages = 0)
	if(!istype(W)) return //Not an item

	if(usr && usr.isEquipped(W) && !usr.canUnEquip(W))
		return 0

	if(!dropsafety(W))
		return 0

	if(src.loc == W)
		return 0 //Means the item is already in the storage item
	if(storage_slots != null && contents.len >= storage_slots)
		if(!stop_messages || is_type_in_list(W, pickup_blacklist)) // the is_type_in_list is a bit risky, but you tend to not want to pick up things in your blacklist anyway
			to_chat(usr, "<span class='notice'>[src] is full, make some space.</span>")
		return 0 //Storage item is full

	if(W.anchored)
		return 0

	if(LAZYLEN(can_hold))
		if(!is_type_in_list(W, can_hold))
			if(!stop_messages && ! istype(W, /obj/item/hand_labeler))
				to_chat(usr, "<span class='notice'>[src] cannot hold \the [W].</span>")
			return 0
		var/max_instances = can_hold[W.type]
		if(max_instances && instances_of_type_in_list(W, contents, TRUE) >= max_instances)
			if(!stop_messages && !istype(W, /obj/item/hand_labeler))
				to_chat(usr, "<span class='notice'>[src] has no more space specifically for \the [W].</span>")
			return 0

	if(LAZYLEN(cant_hold) && is_type_in_list(W, cant_hold))
		if(!stop_messages)
			to_chat(usr, "<span class='notice'>[src] cannot hold [W].</span>")
		return 0

	if (max_w_class != null && W.w_class > max_w_class)
		if(!stop_messages)
			to_chat(usr, "<span class='notice'>[W] is too long for this [src].</span>")
		return 0

	var/total_storage_space = W.get_storage_cost()
	for(var/obj/item/I in contents)
		total_storage_space += I.get_storage_cost() //Adds up the combined w_classes which will be in the storage item if the item is added to it.

	if(total_storage_space > max_storage_space)
		if(!stop_messages)
			to_chat(usr, "<span class='notice'>[src] is too full, make some space.</span>")
		return 0

	if(W.w_class >= src.w_class && (istype(W, /obj/item/storage)))
		if(!stop_messages)
			to_chat(usr, "<span class='notice'>[src] cannot hold [W] as it's a storage item of the same size.</span>")
		return 0 //To prevent the stacking of same sized storage items.

	return 1

//This proc handles items being inserted. It does not perform any checks of whether an item can or can't be inserted. That's done by can_be_inserted()
//The stop_warning parameter will stop the insertion message from being displayed. It is intended for cases where you are inserting multiple items at once,
//such as when picking up all the items on a tile with one click.
/obj/item/storage/proc/handle_item_insertion(obj/item/W as obj, prevent_warning = 0, mob/user = usr)
	if(!istype(W)) return 0
	if(user)
		user.prepare_for_slotmove(W)
	W.forceMove(src)
	W.on_enter_storage(src)
	if(user)
		W.dropped(user)
		if(!istype(W, /obj/item/forensics))
			add_fingerprint(user)

		if(!prevent_warning)
			for(var/mob/M in viewers(user, null))
				if (M == usr)
					to_chat(usr, "<span class='notice'>You put \the [W] into [src].</span>")
				else if (M in range(1)) //If someone is standing close enough, they can tell what it is...
					M.show_message("<span class='notice'>\The [user] puts [W] into [src].</span>")
				else if (W && W.w_class >= 3) //Otherwise they can only see large or normal items from a distance...
					M.show_message("<span class='notice'>\The [user] puts [W] into [src].</span>")

		orient2hud(user)
		if(user.s_active)
			user.s_active.show_to(user)
	queue_icon_update()
	return 1

// This is for inserting more than one thing at a time, you should call handle_storage_deferred after all the items have been inserted.
/obj/item/storage/proc/handle_item_insertion_deferred(obj/item/W, mob/user)
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
	user.update_icons()
	orient2hud(user)
	if (user.s_active)
		user.s_active.show_to(user)
	queue_icon_update()

//Call this proc to handle the removal of an item from the storage item. The item will be moved to the atom sent as new_target
/obj/item/storage/proc/remove_from_storage(obj/item/W as obj, atom/new_location)
	if(!istype(W)) return 0

	if(istype(src, /obj/item/storage/fancy))
		var/obj/item/storage/fancy/F = src
		F.update_icon(1)

	for(var/mob/M in range(1, src.loc))
		if (M.s_active == src)
			if (M.client)
				M.client.screen -= W

	if(new_location)
		if(ismob(loc))
			W.dropped(usr)
		if(ismob(new_location))
			W.layer = SCREEN_LAYER+0.01
		else
			W.layer = initial(W.layer)
		W.forceMove(new_location)
	else
		W.forceMove(get_turf(src))

	if(usr)
		src.orient2hud(usr)
		if(usr.s_active)
			usr.s_active.show_to(usr)
	if(W.maptext)
		W.maptext = ""
	W.on_exit_storage(src)
	update_icon()
	return 1

/obj/item/storage/proc/remove_from_storage_deferred(obj/item/W, atom/new_location, mob/user)
	if (!istype(W))
		return FALSE

	// fuck if I know.
	for(var/mob/M in range(1, src.loc))
		if (M.s_active == src)
			if (M.client)
				M.client.screen -= W

	if (new_location)
		if (ismob(loc))
			W.dropped(user)
		if (ismob(new_location))
			W.layer = SCREEN_LAYER+0.01
		else
			W.layer = initial(W.layer)

		W.forceMove(new_location)
	else
		W.forceMove(get_turf(src))

	if (W.maptext)
		W.maptext = ""

	W.on_exit_storage(src)

	return TRUE

/obj/item/storage/proc/post_remove_from_storage_deferred(atom/oldloc, mob/user)
	orient2hud(user)
	if (user.s_active)
		user.s_active.show_to(user)

	// who knows what the fuck this does
	if (istype(src, /obj/item/storage/fancy))
		update_icon(1)
	else
		update_icon()

//This proc is called when you want to place an item into the storage item.
//Its a safe proc for adding things to the storage that does the necessary checks. Object will not be moved if it fails
/obj/item/storage/proc/insert_into_storage(obj/item/W as obj, var/prevent_messages = 1)
	if(!can_be_inserted(W, prevent_messages))
		return

	return handle_item_insertion(W, prevent_messages)


/obj/item/storage/attackby(obj/item/W as obj, mob/user as mob)
	..()

	if(!dropsafety(W))
		return.

	if(istype(W, /obj/item/device/lightreplacer))
		var/obj/item/device/lightreplacer/LP = W
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

	if(!can_be_inserted(W))
		return

	if(istype(W, /obj/item/tray))
		var/obj/item/tray/T = W
		if(T.current_weight > 0)
			T.spill(user)
			to_chat(user, "<span class='warning'>Trying to place a loaded tray into [src] was a bad idea.</span>")
			return

	W.add_fingerprint(user)
	return handle_item_insertion(W)

/obj/item/storage/dropped(mob/user as mob)
	return

/obj/item/storage/attack_hand(mob/user as mob)
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
		for(var/mob/M in range(1))
			if (M.s_active == src)
				src.close(M)
	src.add_fingerprint(user)
	return

/obj/item/storage/verb/toggle_gathering_mode()
	set name = "Switch Gathering Method"
	set category = "Object"

	collection_mode = !collection_mode
	switch (collection_mode)
		if(1)
			to_chat(usr, "[src] now picks up all items in a tile at once.")
		if(0)
			to_chat(usr, "[src] now picks up one item at a time.")


/obj/item/storage/verb/quick_empty()
	set name = "Empty Contents"
	set category = "Object"

	if((!ishuman(usr) && (src.loc != usr)) || usr.stat || usr.restrained())
		return

	if(empty_delay)
		visible_message("\The [usr] starts to empty the contents of \the [src].")

	if(!do_after(usr, contents.len * empty_delay, act_target=usr))
		return

	var/turf/T = get_turf(src)
	hide_from(usr)
	for(var/obj/item/I in contents)
		remove_from_storage_deferred(I, T, usr)

		CHECK_TICK

	post_remove_from_storage_deferred(loc, usr)

	if(empty_delay)
		visible_message("\The [usr] empties the contents of \the [src].")

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
		log_debug("STORAGE: [type] exceed STORAGE_SPACE_CAP. It has been reset to [STORAGE_SPACE_CAP].")
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

	storage_continue = new /obj/screen/storage{icon_state = "storage_continue"}
	storage_continue.master = src

	storage_end = new /obj/screen/storage{icon_state = "storage_end"}
	storage_end.master = src

	stored_start = new /obj/storage_bullshit{icon_state = "stored_start"} //we just need these to hold the icon

	stored_continue = new /obj/storage_bullshit{icon_state = "stored_continue"}

	stored_end = new /obj/storage_bullshit{icon_state = "stored_end"}

	closer = new /obj/screen/close{
		icon_state = "x";
		layer = SCREEN_LAYER
	}
	closer.master = src
	orient2hud(null, mapload)

	if (defer_shrinkwrap)	// Caller wants to defer shrinkwrapping until after the current callstack; probably putting something in.
		addtimer(CALLBACK(src, .proc/shrinkwrap), 0)
	else
		shrinkwrap()

// Adjusts this storage object's max capacity to exactly the storage required by its contents. Will not decrease max storage capacity, only increase it.
/obj/item/storage/proc/shrinkwrap()
	var/total_storage_space = 0
	for(var/obj/item/I in contents)
		total_storage_space += I.get_storage_cost()
	max_storage_space = max(total_storage_space,max_storage_space) //prevents spawned containers from being too small for their contents

/obj/item/storage/emp_act(severity)
	if(!istype(src.loc, /mob/living))
		for(var/obj/O in contents)
			O.emp_act(severity)
	..()

/obj/item/storage/attack_self(mob/user as mob)
	//Clicking on itself will empty it, if it has the verb to do that.
	if(user.get_active_hand() == src)
		if(src.verbs.Find(/obj/item/storage/verb/quick_empty))
			src.quick_empty()
			return 1

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


//Returns the storage depth of an atom. This is the number of storage items the atom is contained in before reaching toplevel (the area).
//Returns -1 if the atom was not found on container.
/atom/proc/storage_depth(atom/container)
	var/depth = 0
	var/atom/cur_atom = src

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
		if(w_class == 1)
			return 1
		if(w_class == 2)
			return 2
		if(w_class == 3)
			return 4
		if(w_class == 4)
			return 8
		if(w_class == 5)
			return 16
		else
			return 1000

		//return 2**(w_class-1) //1,2,4,8,16,...

#undef STORAGE_SPACE_CAP