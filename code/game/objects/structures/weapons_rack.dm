/obj/structure/weapons_rack
	name = "weapon rack"
	desc = "A rack designed to store weapons."
	icon = 'icons/obj/machinery/weapons_rack.dmi'
	icon_state = "rack_base"
	anchored = TRUE
	density = TRUE

	///The maximum number of weapons that can be stored in the rack
	VAR_PRIVATE/max_weapons_loaded = 4

	///Boolean, if the rack is locked (no weapon can be added or removed)
	VAR_PRIVATE/locked = FALSE

	///Boolean, if the rack is forced open (eg. it was cut open, melted open or whatever)
	VAR_PRIVATE/forced_open = FALSE

	VAR_PRIVATE/obj/effect/visual_holder

/obj/structure/weapons_rack/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()

	if(locate(/obj/item/gun) in src)
		. += "<br/>It contains:<br/>"
	for(var/obj/item/gun/G in src.contents)
		. += "\A [G.name]"

	if(locked)
		. += SPAN_WARNING("It is locked.")

/obj/structure/weapons_rack/Initialize(mapload)
	..()
	visual_holder = new()
	visual_holder.vis_flags |= VIS_INHERIT_ID
	visual_holder.appearance_flags |= KEEP_TOGETHER|RESET_TRANSFORM

	//This is used to hide any stray pixels that the rifles could have, eg. for overboarding the rack sprite
	var/mask_for_rifles_filter = filter(type="alpha", icon = icon(src.icon, "rack_mask"))
	visual_holder.filters += mask_for_rifles_filter

	src.vis_contents += visual_holder

	return INITIALIZE_HINT_LATELOAD

/obj/structure/weapons_rack/LateInitialize()
	. = ..()

	for(var/obj/item/gun in get_turf(src))
		gun.forceMove(src)

		//This protects us from mapper mistakes
		//don't worry, they will find a way to get this to bug out, just not this particular one
		if(length(src.contents) > max_weapons_loaded)
			stack_trace("Weapon rack at [src.x],[src.y],[src.z] is full and still find weapons to load on init in the turf!")
			qdel(gun)

		if(length(req_one_access))
			locked = TRUE

	update_icon()

/obj/structure/weapons_rack/Destroy()
	QDEL_NULL(visual_holder)

	. = ..()

/obj/structure/weapons_rack/attackby(obj/item/attacking_item, mob/user, params)
	. = ..()

	//Hit with a gun, to add it to the rack
	if(istype(attacking_item, /obj/item/gun))
		//No adding or removing weapons from the rack while locked
		if(locked)
			to_chat(user, SPAN_WARNING("The rack is locked."))
			return

		if(length(src.contents) >= max_weapons_loaded)
			to_chat(user, SPAN_WARNING("The rack is full."))
			return

		if(!user.unEquip(attacking_item))
			return

		attacking_item.forceMove(src)
		update_icon()

	//Hit with ID, to lock/unlock the rack
	else if(istype(attacking_item, /obj/item/card/id))
		var/obj/item/card/id/identification_card = attacking_item
		if(!forced_open && has_access(req_one_access = src.req_one_access, accesses = identification_card.access))
			balloon_alert_to_viewers("[locked ? "unlocked" : "locked"]")
			playsound(src, 'sound/items/metal_shutter.ogg', 50, TRUE, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)
			toggle_lock(user)

		else
			balloon_alert(user, "it won't budge!")
			to_chat(user, SPAN_WARNING("You lack the required access to operate this rack's lock, or the lock mechanism is broken."))

	else if(locked && attacking_item.iswelder())
		var/obj/item/weldingtool/WT = attacking_item

		balloon_alert_to_viewers("cutting through the lock...")

		if(WT.use_tool(src, user, 20 SECONDS, extra_checks = CALLBACK(src, PROC_REF(can_be_opened))))
			//Last check because use_tool() is shitcoded
			if(forced_open || !can_be_opened())
				return
			toggle_lock(user)
			balloon_alert_to_viewers("lock cut")
			forced_open = TRUE

		else
			to_chat(user, SPAN_NOTICE("\The [src] was unlocked while you were working on it!"))


/obj/structure/weapons_rack/attack_hand(mob/living/user)
	. = ..()
	if(length(src.contents))
		//No adding or removing weapons from the rack while locked
		if(locked)
			to_chat(user, SPAN_WARNING("The rack is locked."))
			return

		//Build a list of options for the radial menu, based on our content
		var/list/radial_options = list()
		for(var/obj/item/gun/gun_in_rack in src.contents)
			radial_options[gun_in_rack] = image(gun_in_rack.icon, gun_in_rack.icon_state)

		//Show the user the radial menu
		var/obj/item/gun/rifle_to_take = show_radial_menu(user, src, radial_options, require_near = TRUE, tooltips = TRUE)

		//No choice was made, return
		if(isnull(rifle_to_take))
			return

		//Assuming the rifle is still in the rack when the user chooses it, deliver the rifle
		if(rifle_to_take in src.contents)
			rifle_to_take.forceMove(get_turf(user))
			user.put_in_hands(rifle_to_take)
			update_icon()

		else
			to_chat(user, SPAN_WARNING("\The [rifle_to_take] is not in the rack anymore!"))


#define BASE_OFFSET_RIFLE_SLOT -1
#define INTER_OFFSET_RIFLE_SLOT 7
/obj/structure/weapons_rack/update_icon()
	. = ..()
	visual_holder.overlays.Cut()
	ClearOverlays()

	for(var/i in 1 to length(src.contents))
		var/obj/item/gun/G = src.contents[i]
		var/matrix/transform_matrix = matrix(G.transform)

		transform_matrix.Turn(-90)
		transform_matrix.Scale(0.8, 0.8)
		transform_matrix.Translate((((world.icon_size/2)+BASE_OFFSET_RIFLE_SLOT) - world.icon_size) + (i*INTER_OFFSET_RIFLE_SLOT), 0)

		//Why not the rifle itself you might ask? Because there's the safety icon on it
		var/mutable_appearance/weapon_appearance = mutable_appearance(G.icon, G.icon_state, plane = src.plane, flags = G.appearance_flags, layer = G.layer)
		weapon_appearance.transform = transform_matrix

		visual_holder.overlays += weapon_appearance

	if(locked)
		AddOverlays(image(src.icon, "locked_overlay", layer = ABOVE_OBJ_LAYER))

#undef BASE_OFFSET_RIFLE_SLOT
#undef INTER_OFFSET_RIFLE_SLOT

/obj/structure/weapons_rack/emag_act(remaining_charges, mob/user, emag_source)
	. = ..()

	to_chat(user, SPAN_NOTICE("You start to fiddle with the electronic lock of \the [src]."))
	if(do_after(user, 10 SECONDS, src, extra_checks = CALLBACK(src, PROC_REF(can_be_opened))))
		to_chat(user, SPAN_NOTICE("You manage to unlock \the [src]."))
		toggle_lock(user)

/obj/structure/weapons_rack/ex_act(severity)
	if(severity > 1 && can_be_opened())
		toggle_lock()
		forced_open = TRUE

	if(severity > 2)
		for(var/obj/item/gun/G in src.contents)
			if(prob(10))
				//Uh oh, the munitions cooked in the gun!
				fragem(get_turf(G), 4, 7, 3, 3, 10, 1, TRUE)
				qdel(G)
			else
				throw_at_random(TRUE, 4, 7)

	. = ..()

/obj/structure/weapons_rack/fire_act(exposed_temperature, exposed_volume)
	. = ..()

	if(exposed_temperature > 1811) //Melting temperature of steel, in kelvin
		//You melted the door
		if(can_be_opened())
			if(prob(20))
				toggle_lock()
				forced_open = TRUE

		else
			var/picked = pick_weight(list("burn_weapon" = 2, "explode_ammos" = 10, "nothing" = 80))

			//Burn down one of the guns
			if(picked == "burn_weapon" && length(src.contents))
				var/obj/item/gun/G = pick(src.contents)
				G.forceMove(get_turf(src))
				qdel(G)

			//Just some explosion effect
			else if(picked == "explode_ammos")
				INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(fragem), get_turf(src), 2, 3, 3, 3, 10, 1, TRUE)


/**
 * Locks/unlocks the rack
 *
 * * user - A `/mob` that is unlocking the rack, optional
 */
/obj/structure/weapons_rack/proc/toggle_lock(mob/user, force_lock_state)
	SHOULD_NOT_SLEEP(TRUE)

	if(user)
		add_fibers(user)
		add_fingerprint(user)

	locked = !locked
	update_icon()

/**
 * Checks if the locker can be opened (NOT permissions, as in "did someone else already open it" kind of thing)
 *
 */
/obj/structure/weapons_rack/proc/can_be_opened()
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_BE_PURE(TRUE)

	//Can't open it, it's forced open
	if(forced_open)
		return FALSE

	if(locked)
		return TRUE
	else
		return FALSE
