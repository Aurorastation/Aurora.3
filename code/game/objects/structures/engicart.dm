/obj/structure/engineeringcart
	name = "engineering cart"
	desc = "A cart for your engineering-related storage needs."
	icon = 'icons/obj/engicart.dmi'
	icon_state = "cart"
	anchored = FALSE
	density = TRUE
	climbable = TRUE
	build_amt = 15
	material = DEFAULT_TABLE_REINF_MATERIAL
	slowdown = 0
	var/has_items = FALSE

	var/list/my_glass = list()
	var/list/my_metal = list()
	var/list/my_plasteel = list()
	/// Used for displaying and handling radial menu. Collective list of every single item this object contains.
	var/list/storage_contents = list()
	var/obj/item/device/lightreplacer/my_lightreplacer = null
	var/obj/item/storage/toolbox/mechanical/my_blue_toolbox = null
	var/obj/item/storage/toolbox/electrical/my_yellow_toolbox = null
	var/obj/item/storage/toolbox/emergency/my_red_toolbox = null
	var/driving
	var/mob/living/pulling
	/// Amount of stacks the cart is capable to store.
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

/obj/structure/engineeringcart/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "You can use steel, plasteel, glass sheets, toolboxes and light replacers on the cart to store them."
	. += "\
		You can <b>CTRL-Click</b> to start dragging this cart. This object has a special dragging behaviour: when dragged, character's movement \
		directs the cart and the character is subsequently pulled by it. \
		"

/obj/structure/engineeringcart/disassembly_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "An empty engineering cart can be taken apart with a <b>wrench</b> or a <b>welder</b>. Or a <b>plasma cutter</b>, if you're that hardcore."

/obj/structure/engineeringcart/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(distance <= 1)
		if(locate(/obj/item/stack/material) in storage_contents)
			var/metal_amount
			var/plasteel_amount
			var/glass_amount
			var/obj/item/stack/material/steel/S
			var/obj/item/stack/material/plasteel/P
			var/obj/item/stack/material/glass/G
			if(LAZYLEN(my_metal))
				for(var/I in my_metal) // we already handle the type-check in `atttackby()` so it's safe to assume the lists contain what they're intended to
					S = I
					metal_amount += S.amount
				. += "[icon2html(S, user)] This cart contains <b>[metal_amount] sheet\s</b> of steel!"
			if(LAZYLEN(my_plasteel))
				for(var/I in my_plasteel)
					P = I
					plasteel_amount += P.amount
				. += "[icon2html(P, user)] This cart contains <b>[plasteel_amount] sheet\s</b> of plasteel!"
			if(LAZYLEN(my_glass))
				for(var/I in my_glass)
					G = I
					glass_amount += G.amount
				. += "[icon2html(G, user)] This cart contains <b>[glass_amount] sheet\s</b> of glass!"
		else
			. += "[icon2html(src, user)] There is no material in this cart!"

/obj/structure/engineeringcart/proc/get_storage_contents_list()
	storage_contents.Cut()
	var/list/lists_to_check = list(
		my_glass, my_metal, my_plasteel
	)
	for(var/list/list_to_check in lists_to_check)
		if(list_to_check?.len) //null check
			storage_contents += list_to_check

	var/list/non_sheet_objects = list(my_lightreplacer, my_blue_toolbox, my_yellow_toolbox, my_red_toolbox)

	for(var/obj/O in non_sheet_objects)
		if(O)
			storage_contents += O

/obj/structure/engineeringcart/Destroy()
	QDEL_NULL(my_glass)
	QDEL_NULL(my_metal)
	QDEL_NULL(my_plasteel)
	QDEL_NULL(my_lightreplacer)
	QDEL_NULL(my_blue_toolbox)
	QDEL_NULL(my_yellow_toolbox)
	QDEL_NULL(my_red_toolbox)
	return ..()

/obj/structure/engineeringcart/attackby(obj/item/attacking_item, mob/user)
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

			handle_storing(attacking_item, user, should_store, storage_is_full)
			return TRUE

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

			handle_storing(attacking_item, user, should_store, storage_is_full)
			return TRUE

		if(istype(attacking_item, /obj/item/device/lightreplacer)) //---- light replacer
			if(!my_lightreplacer)
				my_lightreplacer = attacking_item
				should_store = TRUE
			else
				storage_is_full = TRUE

			handle_storing(attacking_item, user, should_store, storage_is_full)
			return TRUE

	else if (!has_items && (attacking_item.iswrench() || attacking_item.iswelder() || istype(attacking_item, /obj/item/gun/energy/plasmacutter)))
		take_apart(user, attacking_item)
		return
	..()

// copied from janicart code
/obj/structure/engineeringcart/proc/take_apart(var/mob/user = null, var/obj/I)
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

/obj/structure/engineeringcart/ex_act(severity)
	spill(100 / severity)
	..()

/obj/structure/engineeringcart/proc/spill(var/chance = 100)
	var/turf/dropspot = get_turf(src)
	if(LAZYLEN(my_glass) && prob(chance))
		var/obj/item/stack/material/glass/G
		for(var/I in my_glass)
			G = I
			G.forceMove(dropspot)
			G.tumble(1)
			my_glass -= G
		my_glass.Cut()

	if(LAZYLEN(my_metal) && prob(chance))
		var/obj/item/stack/material/glass/M
		for(var/I in my_metal)
			M = I
			M.forceMove(dropspot)
			M.tumble(1)
			my_metal -= M
		my_metal.Cut()

	if(LAZYLEN(my_plasteel) && prob(chance))
		var/obj/item/stack/material/glass/P
		for(var/I in my_plasteel)
			P = I
			P.forceMove(dropspot)
			P.tumble(1)
			my_plasteel -= P
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

/obj/structure/engineeringcart/proc/handle_storing(var/attacking_item, var/mob/user, var/should_store, var/storage_is_full)
	if(should_store)
		user.drop_from_inventory(attacking_item, src)
		get_storage_contents_list()
		update_icon()
		to_chat(user, SPAN_NOTICE("You put [attacking_item] into [src]."))
	else if(storage_is_full)
		to_chat(user, SPAN_WARNING("There isn't any space to store [attacking_item] in [src]!"))
	else
		to_chat(user, SPAN_WARNING("You can't store this here!"))

/obj/structure/engineeringcart/attack_hand(mob/user)
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
				if(/obj/item/device/lightreplacer)
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
			update_icon()
		else
			to_chat(user, SPAN_WARNING("\The [chosen_item] is not in the cart anymore!"))

/obj/structure/engineeringcart/update_icon()
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


/// For future reference, this kind of pulling functions are dependant on a type-check in `mob_movement.dm` line:332
/obj/structure/engineeringcart/relaymove(mob/living/user, direction)
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

/obj/structure/engineeringcart/Move()
	. = ..()
	if (pulling && (get_dist(src, pulling) > 1))
		pulling.pulledby = null
		to_chat(pulling, SPAN_WARNING("You lost your grip!"))
		pulling = null
	if(has_gravity())
		playsound(src, 'sound/effects/roll.ogg', 50, 1)

/obj/structure/engineeringcart/CtrlClick(var/mob/user)
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

/obj/structure/engineeringcart/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
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
			return prob(30)
		else
			return !density

/obj/structure/engineeringcart/half_filled

/obj/structure/engineeringcart/half_filled/Initialize()
	. = ..()
	my_blue_toolbox = new /obj/item/storage/toolbox/mechanical(src)
	my_yellow_toolbox = new /obj/item/storage/toolbox/electrical(src)
	my_red_toolbox = new /obj/item/storage/toolbox/emergency(src)
	get_storage_contents_list()
	update_icon()

/obj/structure/engineeringcart/full

/obj/structure/engineeringcart/full/Initialize()
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
	update_icon()
