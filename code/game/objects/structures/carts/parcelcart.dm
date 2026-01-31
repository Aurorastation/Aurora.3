/obj/structure/cart/storage/parcelcart
	name = "parcel cart"
	desc = "A cart for moving parcels and packages around."
	icon = 'icons/obj/parcelcart.dmi'
	icon_state = "cart"

	var/list/my_parcels = list()

	/// Amount of parcels the cart is capable to store.
	var/parcel_capacity = 17

	var/static/list/allowed_types = typecacheof(list(
		/obj/item/smallDelivery
	))

/obj/structure/cart/storage/parcelcart/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "You can use hand held parcels on the cart to store them."
	. += "It slows down at 5 packages, and slows down more when 11+ packages are loaded."

/obj/structure/cart/storage/parcelcart/get_storage_contents_list()
	storage_contents.Cut()
	var/list/lists_to_check = list(
		my_parcels
	)
	for(var/list/list_to_check in lists_to_check)
		if(list_to_check?.len) //null check
			storage_contents += list_to_check

	var/list/non_sheet_objects = list(my_parcels)

	for(var/obj/non_sheet_object in non_sheet_objects)
		if(non_sheet_object)
			storage_contents += non_sheet_object

	update_icon()

/obj/structure/cart/storage/parcelcart/Destroy()
	QDEL_NULL(my_parcels)
	return ..()

/obj/structure/cart/storage/parcelcart/attackby(obj/item/attacking_item, mob/user)
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

	else if (!has_items && (attacking_item.tool_behaviour == TOOL_WRENCH || attacking_item.tool_behaviour == TOOL_WELDER || istype(attacking_item, /obj/item/gun/energy/plasmacutter)))
		take_apart(user, attacking_item)
		return
	..()

/obj/structure/cart/storage/parcelcart/spill(var/chance = 100)
	var/turf/dropspot = get_turf(src)

	if(LAZYLEN(my_parcels) && prob(chance))
		var/obj/item/smallDelivery/smallDelivery
		for(var/I in my_parcels)
			smallDelivery = I
			smallDelivery.forceMove(dropspot)
			smallDelivery.tumble(1)
			my_parcels -= smallDelivery
		my_parcels.Cut()
	update_icon()

/obj/structure/cart/storage/parcelcart/handle_storing(var/attacking_item, var/mob/user, var/should_store, var/storage_is_full)
	if(should_store)
		user.drop_from_inventory(attacking_item, src)
		get_storage_contents_list()
		update_slowdown()
		to_chat(user, SPAN_NOTICE("You put [attacking_item] into [src]."))
	else if(storage_is_full)
		to_chat(user, SPAN_WARNING("There isn't any space to store [attacking_item] in [src]!"))
	else
		to_chat(user, SPAN_WARNING("You can't store this here!"))

/obj/structure/cart/storage/parcelcart/update_slowdown()
	if(my_parcels.len <= 4)
		slowdown = 0
	else if(my_parcels.len > 4 && my_parcels.len < 11)
		slowdown = 1
	else if(my_parcels.len >= 11)
		slowdown = 2

/obj/structure/cart/storage/parcelcart/attack_hand(mob/user)
	if(!isliving(user))
		return

	if(LAZYLEN(storage_contents))
		for(var/obj/object in storage_contents)
			storage_contents[object] = image(object.icon, object.icon_state)

		var/obj/item/chosen_item = show_radial_menu(user, src, storage_contents, require_near = TRUE, tooltips = TRUE)

		if(isnull(chosen_item))
			return
		if(chosen_item in storage_contents)
			switch(chosen_item.type)
				if(/obj/item/smallDelivery)
					if(my_parcels.len)
						user.put_in_hands(chosen_item)
						to_chat(user, SPAN_NOTICE("You take \the [my_parcels[chosen_item]] from [src]."))
						my_parcels -= chosen_item

			get_storage_contents_list()
			update_slowdown()
		else
			to_chat(user, SPAN_WARNING("\The [chosen_item] is not in the cart anymore!"))

/obj/structure/cart/storage/parcelcart/update_icon()
	ClearOverlays()
	has_items = FALSE
	if(my_parcels.len)
		var/amount_to_show = min(length(my_parcels), parcel_capacity)
		AddOverlays("pack_[amount_to_show]")
		has_items = TRUE
