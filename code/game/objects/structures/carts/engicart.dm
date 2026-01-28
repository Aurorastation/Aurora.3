/obj/structure/cart/storage/engineeringcart
	name = "engineering cart"
	desc = "A cart for your engineering-related storage needs."
	icon = 'icons/obj/engicart.dmi'
	icon_state = "cart"

	var/list/my_glass = list()
	var/list/my_metal = list()
	var/list/my_plasteel = list()
	var/obj/item/device/lightreplacer/my_lightreplacer = null
	var/obj/item/storage/toolbox/mechanical/my_blue_toolbox = null
	var/obj/item/storage/toolbox/electrical/my_yellow_toolbox = null
	var/obj/item/storage/toolbox/emergency/my_red_toolbox = null
	/// Amount of stacks the cart is capable of storing.
	var/stack_capacity = 2

	var/static/list/allowed_types = typecacheof(list(
		/obj/item/stack/material/glass,
		/obj/item/stack/material/steel,
		/obj/item/stack/material/plasteel,
		/obj/item/device/lightreplacer,
		/obj/item/storage/toolbox/mechanical,
		/obj/item/storage/toolbox/electrical,
		/obj/item/storage/toolbox/emergency
	))

/obj/structure/cart/storage/engineeringcart/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "You can use steel, plasteel, glass sheets, toolboxes and light replacers on the cart to store them."
	. += "The cart can contain up to [stack_capacity] stacks of each type of sheet."

/obj/structure/cart/storage/engineeringcart/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(distance <= 1)
		if(locate(/obj/item/stack/material) in storage_contents)
			var/metal_amount
			var/plasteel_amount
			var/glass_amount
			var/obj/item/stack/material/steel/stored_steel
			var/obj/item/stack/material/plasteel/stored_plasteel
			var/obj/item/stack/material/glass/stored_glass
			if(LAZYLEN(my_metal))
				for(var/metal in my_metal) // we already handle the type-check in `atttackby()` so it's safe to assume the lists contain what they're intended to
					stored_steel = metal
					metal_amount += stored_steel.amount
				. += "[icon2html(stored_steel, user)] This cart contains <b>[metal_amount] sheet\s</b> of steel!"
			if(LAZYLEN(my_plasteel))
				for(var/metal in my_plasteel)
					stored_plasteel = metal
					plasteel_amount += stored_plasteel.amount
				. += "[icon2html(stored_plasteel, user)] This cart contains <b>[plasteel_amount] sheet\s</b> of plasteel!"
			if(LAZYLEN(my_glass))
				for(var/metal in my_glass)
					stored_glass = metal
					glass_amount += stored_glass.amount
				. += "[icon2html(stored_glass, user)] This cart contains <b>[glass_amount] sheet\s</b> of glass!"
		else
			. += "[icon2html(src, user)] There is no material in this cart!"

/obj/structure/cart/storage/engineeringcart/get_storage_contents_list()
	storage_contents.Cut()
	var/list/lists_to_check = list(
		my_glass, my_metal, my_plasteel
	)
	for(var/list/list_to_check in lists_to_check)
		if(list_to_check?.len) //null check
			storage_contents += list_to_check

	var/list/non_sheet_objects = list(my_lightreplacer, my_blue_toolbox, my_yellow_toolbox, my_red_toolbox)

	for(var/obj/non_sheet_object in non_sheet_objects)
		if(non_sheet_object)
			storage_contents += non_sheet_object

	update_icon()

/obj/structure/cart/storage/engineeringcart/Destroy()
	QDEL_NULL(my_glass)
	QDEL_NULL(my_metal)
	QDEL_NULL(my_plasteel)
	QDEL_NULL(my_lightreplacer)
	QDEL_NULL(my_blue_toolbox)
	QDEL_NULL(my_yellow_toolbox)
	QDEL_NULL(my_red_toolbox)
	return ..()

/obj/structure/cart/storage/engineeringcart/attackby(obj/item/attacking_item, mob/user)
	if(is_type_in_typecache(attacking_item, allowed_types))
		var/should_store = FALSE
		var/storage_is_full = FALSE
		if(istype(attacking_item, /obj/item/stack/material)) //---- stack materials
			switch(attacking_item.type)
				if(/obj/item/stack/material/glass, /obj/item/stack/material/glass/full)
					if(my_glass.len < stack_capacity)
						my_glass += attacking_item
						should_store = TRUE
					else
						storage_is_full = TRUE

				if(/obj/item/stack/material/steel, /obj/item/stack/material/steel/full)
					if(my_metal.len < stack_capacity)
						my_metal += attacking_item
						should_store = TRUE
					else
						storage_is_full = TRUE

				if(/obj/item/stack/material/plasteel, /obj/item/stack/material/plasteel/full)
					if(my_plasteel.len < stack_capacity)
						my_plasteel += attacking_item
						should_store = TRUE
					else
						storage_is_full = TRUE

		if(istype(attacking_item, /obj/item/storage/toolbox)) //---- toolboxes
			switch(attacking_item.type)
				if(/obj/item/storage/toolbox/mechanical)
					if(!my_blue_toolbox)
						my_blue_toolbox = attacking_item
						should_store = TRUE
					else
						storage_is_full = TRUE

				if(/obj/item/storage/toolbox/electrical)
					if(!my_yellow_toolbox)
						my_yellow_toolbox = attacking_item
						should_store = TRUE
					else
						storage_is_full = TRUE

				if(/obj/item/storage/toolbox/emergency)
					if(!my_red_toolbox)
						my_red_toolbox = attacking_item
						should_store = TRUE
					else
						storage_is_full = TRUE

		if(istype(attacking_item, /obj/item/device/lightreplacer)) //---- light replacer
			if(!my_lightreplacer)
				my_lightreplacer = attacking_item
				should_store = TRUE
			else
				storage_is_full = TRUE

		handle_storing(attacking_item, user, should_store, storage_is_full)
		return TRUE

	else if (!has_items && (attacking_item.tool_behaviour == TOOL_WRENCH || attacking_item.tool_behaviour == TOOL_WELDER || istype(attacking_item, /obj/item/gun/energy/plasmacutter)))
		take_apart(user, attacking_item)
		return
	..()

/obj/structure/cart/storage/engineeringcart/spill(var/chance = 100)
	var/turf/dropspot = get_turf(src)
	if(LAZYLEN(my_glass) && prob(chance))
		var/obj/item/stack/material/glass/stored_glass
		for(var/I in my_glass)
			stored_glass = I
			stored_glass.forceMove(dropspot)
			stored_glass.tumble(1)
			my_glass -= stored_glass
		my_glass.Cut()

	if(LAZYLEN(my_metal) && prob(chance))
		var/obj/item/stack/material/steel/stored_steel
		for(var/I in my_metal)
			stored_steel = I
			stored_steel.forceMove(dropspot)
			stored_steel.tumble(1)
			my_metal -= stored_steel
		my_metal.Cut()

	if(LAZYLEN(my_plasteel) && prob(chance))
		var/obj/item/stack/material/plasteel/stored_plasteel
		for(var/I in my_plasteel)
			stored_plasteel = I
			stored_plasteel.forceMove(dropspot)
			stored_plasteel.tumble(1)
			my_plasteel -= stored_plasteel
		my_plasteel.Cut()

	if(my_lightreplacer && prob(chance))
		my_lightreplacer.forceMove(dropspot)
		my_lightreplacer.tumble(2)
		my_lightreplacer = null

	if(my_blue_toolbox && prob(chance))
		my_blue_toolbox.forceMove(dropspot)
		my_blue_toolbox.tumble(2)
		my_blue_toolbox = null

	if(my_yellow_toolbox && prob(chance))
		my_yellow_toolbox.forceMove(dropspot)
		my_yellow_toolbox.tumble(2)
		my_yellow_toolbox = null

	if(my_red_toolbox && prob(chance))
		my_red_toolbox.forceMove(dropspot)
		my_red_toolbox.tumble(2)
		my_red_toolbox = null

	update_icon()

/obj/structure/cart/storage/engineeringcart/handle_storing(var/attacking_item, var/mob/user, var/should_store, var/storage_is_full)
	if(should_store)
		user.drop_from_inventory(attacking_item, src)
		get_storage_contents_list()
		to_chat(user, SPAN_NOTICE("You put [attacking_item] into [src]."))
	else if(storage_is_full)
		to_chat(user, SPAN_WARNING("There isn't any space to store [attacking_item] in [src]!"))
	else
		to_chat(user, SPAN_WARNING("You can't store this here!"))

/obj/structure/cart/storage/engineeringcart/attack_hand(mob/user)
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
				if(/obj/item/stack/material/glass, /obj/item/stack/material/glass/full)
					if(my_glass.len)
						user.put_in_hands(chosen_item)
						to_chat(user, SPAN_NOTICE("You take [my_glass[chosen_item]] from [src]."))
						my_glass -= chosen_item
				if(/obj/item/stack/material/steel, /obj/item/stack/material/steel/full)
					if(my_metal.len)
						user.put_in_hands(chosen_item)
						to_chat(user, SPAN_NOTICE("You take [my_metal[chosen_item]] from [src]."))
						my_metal -= chosen_item
				if(/obj/item/stack/material/plasteel, /obj/item/stack/material/plasteel/full)
					if(my_plasteel.len)
						user.put_in_hands(chosen_item)
						to_chat(user, SPAN_NOTICE("You take [my_plasteel[chosen_item]] from [src]."))
						my_plasteel -= chosen_item
				if(/obj/item/device/lightreplacer, /obj/item/device/lightreplacer/advanced)
					if(my_lightreplacer)
						user.put_in_hands(my_lightreplacer)
						to_chat(user, SPAN_NOTICE("You take [my_lightreplacer] from [src]."))
						my_lightreplacer = null
				if(/obj/item/storage/toolbox/mechanical)
					if(my_blue_toolbox)
						user.put_in_hands(my_blue_toolbox)
						to_chat(user, SPAN_NOTICE("You take [my_blue_toolbox] from [src]."))
						my_blue_toolbox = null
				if(/obj/item/storage/toolbox/electrical)
					if(my_yellow_toolbox)
						user.put_in_hands(my_yellow_toolbox)
						to_chat(user, SPAN_NOTICE("You take [my_yellow_toolbox] from [src]."))
						my_yellow_toolbox = null
				if(/obj/item/storage/toolbox/emergency)
					if(my_red_toolbox)
						user.put_in_hands(my_red_toolbox)
						to_chat(user, SPAN_NOTICE("You take [my_red_toolbox] from [src]."))
						my_red_toolbox = null

			get_storage_contents_list()
		else
			to_chat(user, SPAN_WARNING("\The [chosen_item] is not in the cart anymore!"))

/obj/structure/cart/storage/engineeringcart/update_icon()
	ClearOverlays()
	has_items = FALSE
	if(my_plasteel.len)
		AddOverlays("cart_plasteel")
		has_items = TRUE
	if(my_metal.len)
		AddOverlays("cart_metal")
		has_items = TRUE
	if(my_glass.len)
		AddOverlays("cart_glass")
		has_items = TRUE
	if(my_lightreplacer)
		AddOverlays("cart_flashlight")
		has_items = TRUE
	if(my_blue_toolbox)
		AddOverlays("cart_bluetoolbox")
		has_items = TRUE
	if(my_yellow_toolbox)
		AddOverlays("cart_yellowtoolbox")
		has_items = TRUE
	if(my_red_toolbox)
		AddOverlays("cart_redtoolbox")
		has_items = TRUE

/obj/structure/cart/storage/engineeringcart/half_filled

/obj/structure/cart/storage/engineeringcart/half_filled/Initialize()
	. = ..()
	my_blue_toolbox = new /obj/item/storage/toolbox/mechanical(src)
	my_yellow_toolbox = new /obj/item/storage/toolbox/electrical(src)
	my_red_toolbox = new /obj/item/storage/toolbox/emergency(src)
	get_storage_contents_list()

/obj/structure/cart/storage/engineeringcart/full

/obj/structure/cart/storage/engineeringcart/full/Initialize()
	. = ..()
	my_lightreplacer = new /obj/item/device/lightreplacer(src)
	my_blue_toolbox = new /obj/item/storage/toolbox/mechanical(src)
	my_yellow_toolbox = new /obj/item/storage/toolbox/electrical(src)
	my_red_toolbox = new /obj/item/storage/toolbox/emergency(src)
	my_glass += new /obj/item/stack/material/glass/full(src)
	my_glass += new /obj/item/stack/material/glass/full(src)
	my_metal += new /obj/item/stack/material/steel/full(src)
	my_metal += new /obj/item/stack/material/steel/full(src)
	my_plasteel += new /obj/item/stack/material/plasteel/full(src)
	my_plasteel += new /obj/item/stack/material/plasteel/full(src)
	get_storage_contents_list()
