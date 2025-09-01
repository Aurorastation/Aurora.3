/obj/structure/parcelcart
	name = "parcel cart"
	desc = "A cart for moving parcels and packages around."
	icon = 'icons/obj/parcelcart.dmi'
	icon_state = "cart"
	anchored = FALSE
	density = TRUE
	climbable = TRUE
	build_amt = 15
	material = DEFAULT_WALL_MATERIAL
	slowdown = 0
	var/has_items = FALSE

	var/list/my_parcels = list()

	/// Used for displaying and handling radial menu. Collective list of every single item this object contains.
	var/list/storage_contents = list()
	var/driving
	var/mob/living/pulling
	/// Amount of parcels the cart is capable to store.
	var/parcel_capacity = 17

	var/static/list/allowed_types = typecacheof(list(
		/obj/item/smallDelivery
	))

/obj/structure/parcelcart/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "You can use hand held parcels on the cart to store them."
	. += "\
		You can <b>CTRL-Click</b> to start dragging this cart. This object has a special dragging behaviour: when dragged, character's movement \
		directs the cart and the character is subsequently pulled by it. \
		"
	. += "It slows down at 5 packages, and becomes even slower when there is 11 packages or more loaded."

/obj/structure/parcelcart/disassembly_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "An empty parcel  cart can be taken apart with a <b>wrench</b> or a <b>welder</b>. Or a <b>plasma cutter</b>, if you're that hardcore."

/obj/structure/parcelcart/proc/get_storage_contents_list()
	storage_contents.Cut()
	var/list/lists_to_check = list(
		my_parcels
	)
	for(var/list/list_to_check in lists_to_check)
		if(list_to_check?.len) //null check
			storage_contents += list_to_check

	var/list/non_sheet_objects = list(my_parcels)

	for(var/obj/O in non_sheet_objects)
		if(O)
			storage_contents += O

/obj/structure/parcelcart/Destroy()
	QDEL_NULL(my_parcels)
	return ..()

/obj/structure/parcelcart/attackby(obj/item/attacking_item, mob/user)
	if(is_type_in_typecache(attacking_item, allowed_types))
		var/should_store = FALSE
		var/storage_is_full = FALSE
		if(my_parcels.len < parcel_capacity)
			my_parcels += attacking_item
			should_store = TRUE
		else
			storage_is_full = TRUE

		handle_storing(attacking_item, user, should_store, storage_is_full)
		return TRUE

	else if (!has_items && (attacking_item.iswrench() || attacking_item.iswelder() || istype(attacking_item, /obj/item/gun/energy/plasmacutter)))
		take_apart(user, attacking_item)
		return
	..()

// copied from the engineering cart
/obj/structure/parcelcart/proc/take_apart(var/mob/user = null, var/obj/I)
	if(has_items)
		spill()

	if(user)

		if(iswelder(I))
			var/obj/item/welder = I
			welder.play_tool_sound(get_turf(src), 50)

		user.visible_message("<b>[user]</b> starts taking apart the [src]...", SPAN_NOTICE("You start disassembling the [src]..."))
		if (!do_after(user, 30, do_flags = DO_DEFAULT & ~DO_USER_SAME_HAND))
			return

	dismantle()

/obj/structure/parcelcart/ex_act(severity)
	spill(100 / severity)
	..()

/obj/structure/parcelcart/proc/spill(var/chance = 100)
	var/turf/dropspot = get_turf(src)

	if(LAZYLEN(my_parcels) && prob(chance))
		var/obj/item/smallDelivery/M
		for(var/I in my_parcels)
			M = I
			M.forceMove(dropspot)
			M.tumble(1)
			my_parcels -= M
		my_parcels.Cut()
	update_icon()

/obj/structure/parcelcart/proc/handle_storing(var/attacking_item, var/mob/user, var/should_store, var/storage_is_full)
	if(should_store)
		user.drop_from_inventory(attacking_item, src)
		get_storage_contents_list()
		update_slowdown()
		update_icon()
		to_chat(user, SPAN_NOTICE("You put [attacking_item] into [src]."))
	else if(storage_is_full)
		to_chat(user, SPAN_WARNING("There isn't any space to store [attacking_item] in [src]!"))
	else
		to_chat(user, SPAN_WARNING("You can't store this here!"))

/obj/structure/parcelcart/proc/update_slowdown()
	if(my_parcels.len <= 4)
		slowdown = 0
	else if(my_parcels.len > 4 && my_parcels.len < 11)
		slowdown = 1
	else if(my_parcels.len >= 11)
		slowdown = 2

/obj/structure/parcelcart/attack_hand(mob/user)
	if(!isliving(user))
		return

	if(LAZYLEN(storage_contents))
		for(var/obj/O in storage_contents)
			storage_contents[O] = image(O.icon, O.icon_state)

		var/obj/item/chosen_item = show_radial_menu(user, src, storage_contents, require_near = TRUE, tooltips = TRUE)

		if(isnull(chosen_item))
			return
		if(chosen_item in storage_contents)
			switch(chosen_item.type)
				if(/obj/item/smallDelivery)
					if(my_parcels.len)
						user.put_in_hands(chosen_item)
						to_chat(user, SPAN_NOTICE("You take [my_parcels[chosen_item]] from [src]."))
						my_parcels -= chosen_item

			get_storage_contents_list()
			update_slowdown()
			update_icon()
		else
			to_chat(user, SPAN_WARNING("\The [chosen_item] is not in the cart anymore!"))

/obj/structure/parcelcart/update_icon()
	ClearOverlays()
	has_items = FALSE
	if(my_parcels.len)
		var/amount_to_show = min(length(my_parcels), parcel_capacity)
		AddOverlays("pack_[amount_to_show]")
		has_items = TRUE

/obj/structure/parcelcart/relaymove(mob/living/user, direction)
	. = ..()

	if(user.stat || user.stunned || user.weakened || user.paralysis || user.lying || user.restrained())
		if(user==pulling)
			pulling = null
			user.pulledby = null
			to_chat(user, SPAN_WARNING("You lost your grip!"))
		return
	if(user.pulling && (user == pulling))
		pulling = null
		user.pulledby = null
		return
	if(pulling && (get_dist(src, pulling) > 1))
		pulling = null
		user.pulledby = null
		if(user==pulling)
			return
	if(pulling && (get_dir(src.loc, pulling.loc) == direction))
		to_chat(user, SPAN_WARNING("You cannot go there."))
		return

	driving = 1
	var/turf/T = null
	if(pulling)
		T = pulling.loc
		if(get_dist(src, pulling) >= 1)
			step(pulling, get_dir(pulling.loc, src.loc))
	step(src, direction)
	set_dir(direction)
	if(pulling)
		if(pulling.loc == src.loc)
			pulling.forceMove(T)
		else
			spawn(0)
			if(get_dist(src, pulling) > 1)
				pulling = null
				user.pulledby = null
			pulling.set_dir(get_dir(pulling, src))
	driving = 0

/obj/structure/parcelcart/Move()
	. = ..()
	if (pulling && (get_dist(src, pulling) > 1))
		pulling.pulledby = null
		to_chat(pulling, SPAN_WARNING("You lost your grip!"))
		pulling = null
	if(has_gravity())
		playsound(src, 'sound/effects/roll.ogg', 50, 1)

/obj/structure/parcelcart/CtrlClick(var/mob/user)
	if(in_range(src, user))
		if(!ishuman(user))	return
		if(!pulling)
			pulling = user
			user.pulledby = src
			if(user.pulling)
				user.stop_pulling()
			user.set_dir(get_dir(user, src))
			to_chat(user, "You grip \the [name]'s handles.")
		else
			to_chat(usr, "You let go of \the [name]'s handles.")
			pulling.pulledby = null
			pulling = null
		return

/obj/structure/parcelcart/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0))
		return TRUE
	if(mover?.movement_type & PHASING)
		return TRUE
	if(istype(mover) && mover.pass_flags & PASSTABLE)
		return TRUE
	if(istype(mover, /mob/living) && mover == pulling)
		return TRUE
	else
		if(istype(mover, /obj/projectile))
			return prob(20)
		else
			return !density
