/obj/structure/cart/storage/janitorialcart
	name = "custodial cart"
	desc = "The ultimate in custodial carts. Has space for water, mops, signs, trash bags, and more."
	icon = 'icons/obj/janitor.dmi'
	icon_state = "cart"

	var/obj/item/storage/bag/trash/my_bag = null
	var/obj/item/mop/my_mop = null
	var/obj/item/reagent_containers/spray/my_spray = null
	var/obj/item/device/lightreplacer/my_lightreplacer = null
	var/obj/structure/mopbucket/my_bucket = null
	var/signs = 0
	var/max_signs = 4

	var/static/list/allowed_types = typecacheof(list(
		/obj/item/storage/bag/trash,
		/obj/item/mop,
		/obj/item/reagent_containers/spray,
		/obj/item/device/lightreplacer,
		/obj/item/clothing/suit/caution
	))

/obj/structure/cart/storage/janitorialcart/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Click and drag a mop bucket (the square kind, not a standard bucket) onto the cart to mount it."
	. += "You can use a light replacer, spray bottle, trash bag, and up to [max_signs] wet-floor signs on the cart to store them."
	. += "Click the cart with a mop, rag, or soap to wet them from the bucket."
	. += "When a trash bag is attached, you can click on the cart with an item to throw it in the trash."
	. += "ALT-Click the cart with a mop to store it on the cart."
	. += "ALT-Click the cart with a reagent container (such as a bucket, glass, etc.) to pour its contents into the mounted bucket. A normal click will toss it into the trash bag (if able)."
	. += "ALT-click the cart with an advanced light replacer to dump any broken lights in the trash."

/obj/structure/cart/storage/janitorialcart/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(distance <= 1)
		if(my_bucket)
			var/contains = my_bucket.reagents.total_volume
			. += "[icon2html(src, user)] The bucket contains <b>[contains] unit\s</b> of liquid!"
		else
			. += "[icon2html(src, user)] There is no bucket mounted on it!"
	//everything else is visible, so doesn't need to be mentioned

// Regular Variant
// No trashbag and no light replacer, this is inside the custodian's locker.
/obj/structure/cart/storage/janitorialcart/Initialize()
	. = ..()
	my_bucket = new /obj/structure/mopbucket(src)
	get_storage_contents_list()

// Full Variant
// Has everything.
/obj/structure/cart/storage/janitorialcart/full/Initialize()
	. = ..()
	my_bag = new /obj/item/storage/bag/trash(src)
	my_mop = new /obj/item/mop(src)
	my_spray = new /obj/item/reagent_containers/spray/cleaner(src)
	my_lightreplacer = new /obj/item/device/lightreplacer(src)

	for(signs, signs < max_signs, signs++)
		new /obj/item/clothing/suit/caution(src)

// Full with Water Variant
// Has everything as well as water in the mop bucket.
/obj/structure/cart/storage/janitorialcart/full/water/Initialize()
	. = ..()
	my_bucket.reagents.add_reagent(/singleton/reagent/water, my_bucket.bucketsize)

/obj/structure/cart/storage/janitorialcart/New()
	..()
	if(is_station_turf(get_turf(src)))
		GLOB.janitorial_supplies |= src

/obj/structure/cart/storage/janitorialcart/Destroy()
	if(src in GLOB.janitorial_supplies)
		GLOB.janitorial_supplies -= src
	QDEL_NULL(my_bag)
	QDEL_NULL(my_mop)
	QDEL_NULL(my_spray)
	QDEL_NULL(my_lightreplacer)
	QDEL_NULL(my_bucket)
	return ..()

/obj/structure/cart/storage/janitorialcart/proc/get_short_status()
	return "Contents: [english_list(contents)]"

/obj/structure/cart/storage/janitorialcart/mouse_drop_receive(atom/dropped, mob/user, params)
	var/atom/movable/mopbucket = dropped
	if(istype(mopbucket, /obj/structure/mopbucket) && !my_bucket && do_after(user, 20))
		mopbucket.forceMove(src)
		my_bucket = mopbucket
		to_chat(user, "You mount the [mopbucket] on the janicart.")
		get_storage_contents_list()
	else
		..()

/obj/structure/cart/storage/janitorialcart/handle_storing(var/attacking_item, var/mob/user, var/should_store, var/storage_is_full)
	if(should_store)
		user.drop_from_inventory(attacking_item, src)
		get_storage_contents_list()
		to_chat(user, SPAN_NOTICE("You put [attacking_item] into [src]."))
	else if(storage_is_full)
		to_chat(user, SPAN_WARNING("There isn't any space to store [attacking_item] in [src]!"))
	else
		to_chat(user, SPAN_WARNING("You can't store this here!"))

/obj/structure/cart/storage/janitorialcart/get_storage_contents_list()
	storage_contents.Cut()
	var/list/objects = list(my_bag, my_mop, my_spray, my_lightreplacer, my_bucket)

	for(var/obj/object in objects)
		if(object)
			storage_contents += object

	for(var/obj/item/clothing/suit/caution/wetfloorsign in src)
		if(wetfloorsign)
			storage_contents += wetfloorsign

	update_icon()

//New Altclick functionality!
//Altclick the cart with a mop to stow the mop away
//Altclick the cart with a reagent container to pour things into the bucket without putting the bottle in trash
/obj/structure/cart/storage/janitorialcart/AltClick()
	var/mob/user = usr
	if(!user || !istype(user) || user.stat || user.lying || user.restrained() || !Adjacent(user))	return
	var/obj/held_item = user.get_active_hand()
	var/should_store = FALSE
	var/storage_is_full = FALSE

	/// If it's a mop, try to store it.
	if(istype(held_item, /obj/item/mop))
		if(!my_mop)
			my_mop = held_item
			should_store = TRUE
		else
			storage_is_full = TRUE

		handle_storing(held_item, user, should_store, storage_is_full)
		return TRUE

	/// If its a reagent container, try to dump it in the bucket.
	else if(istype(held_item, /obj/item/reagent_containers) && my_bucket)
		var/obj/item/reagent_containers/held_container = held_item
		held_container.afterattack(my_bucket, user, 1)

	/// If its an advanced light replacer, try to dump the broken lights in the trash.
	else if(istype(held_item, /obj/item/device/lightreplacer))
		var/obj/item/device/lightreplacer/held_lightreplacer = held_item
		if(held_lightreplacer.store_broken)
			return my_bag.attackby(held_item, user)

/obj/structure/cart/storage/janitorialcart/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/mop) || istype(attacking_item, /obj/item/reagent_containers/glass/rag) || istype(attacking_item, /obj/item/soap))
		if(my_bucket)
			if(attacking_item.reagents.total_volume < attacking_item.reagents.maximum_volume)
				if(my_bucket.reagents.total_volume < 1)
					to_chat(user, SPAN_NOTICE("[my_bucket] is empty!"))
					update_icon()
				else
					my_bucket.reagents.trans_to_obj(attacking_item, 5)	//
					to_chat(user, SPAN_NOTICE("You wet [attacking_item] in [my_bucket]."))
					playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
					update_icon()
			else
				to_chat(user, SPAN_NOTICE("[attacking_item] can't absorb anymore liquid!"))
		else
			to_chat(user, SPAN_NOTICE("There is no bucket mounted here to dip [attacking_item] into!"))
		return 1

	if(is_type_in_typecache(attacking_item, allowed_types))
		var/should_store = FALSE
		var/storage_is_full = FALSE

		if(istype(attacking_item, /obj/item/device/lightreplacer)) //---- light replacer
			if(!my_lightreplacer)
				my_lightreplacer = attacking_item
				should_store = TRUE
			else
				storage_is_full = TRUE

		else if(istype(attacking_item, /obj/item/storage/bag/trash)) //---- trash bag
			if(!my_bag)
				my_bag = attacking_item
				should_store = TRUE
			else
				storage_is_full = TRUE

		else if(istype(attacking_item, /obj/item/reagent_containers/spray)) //---- spray
			if(!my_spray)
				my_spray = attacking_item
				should_store = TRUE
			else
				storage_is_full = TRUE

		else if(istype(attacking_item, /obj/item/clothing/suit/caution)) //---- sign(s)
			if(signs < max_signs)
				should_store = TRUE
				signs++
			else
				storage_is_full = TRUE
		handle_storing(attacking_item, user, should_store, storage_is_full)
		return

	else if(my_bag)
		// This return will prevent afterattack from executing if the object goes into the trashbag,
		// This prevents dumb stuff like splashing the cart with the contents of a container, after putting said container into trash.
		return my_bag.attackby(attacking_item, user)

	else if (!has_items && (attacking_item.tool_behaviour == TOOL_WRENCH || attacking_item.tool_behaviour == TOOL_WELDER || istype(attacking_item, /obj/item/gun/energy/plasmacutter)))
		take_apart(user, attacking_item)
		return

	..()

/obj/structure/cart/storage/janitorialcart/attack_hand(mob/user)
	if(!isliving(user))
		return

	if(LAZYLEN(storage_contents))
		for(var/obj/object in storage_contents)
			storage_contents[object] = image(object.icon, object.icon_state)

		var/obj/item/chosen_item = show_radial_menu(user, src, storage_contents, require_near = TRUE, tooltips = TRUE)

		if(isnull(chosen_item))
			return

		if(chosen_item in storage_contents)
			if(istype(chosen_item, /obj/item/storage/bag/trash) && my_bag)
				user.put_in_hands(my_bag)
				to_chat(user, SPAN_NOTICE("You take [my_bag] from [src]."))
				my_bag = null
			if(istype(chosen_item, /obj/item/mop) && my_mop)
				user.put_in_hands(my_mop)
				to_chat(user, SPAN_NOTICE("You take [my_mop] from [src]."))
				my_mop = null
			if(istype(chosen_item, /obj/item/reagent_containers/spray) && my_spray)
				user.put_in_hands(my_spray)
				to_chat(user, SPAN_NOTICE("You take [my_spray] from [src]."))
				my_spray = null
			if(istype(chosen_item, /obj/item/device/lightreplacer) && my_lightreplacer)
				user.put_in_hands(my_lightreplacer)
				to_chat(user, SPAN_NOTICE("You take [my_lightreplacer] from [src]."))
				my_lightreplacer = null
			if(istype(chosen_item, /obj/structure/mopbucket) && my_bucket)
				my_bucket.forceMove(get_turf(user))
				to_chat(user, SPAN_NOTICE("You unmount [my_bucket] from [src]."))
				my_bucket.update_icon()
				my_bucket = null
			if(istype(chosen_item, /obj/item/clothing/suit/caution))
				if(signs)
					var/obj/item/clothing/suit/caution/wetfloorsign = locate() in src
					if(wetfloorsign)
						user.put_in_hands(wetfloorsign)
						to_chat(user, SPAN_NOTICE("You take \a [wetfloorsign] from [src]."))
						signs--
					else
						warning("[src] signs ([signs]) didn't match contents")
						signs = 0

			get_storage_contents_list()
		else
			to_chat(user, SPAN_WARNING("\The [chosen_item] is not in the cart anymore!"))

//This is called if the cart is caught in an explosion, or destroyed by weapon fire
/obj/structure/cart/storage/janitorialcart/spill(var/chance = 100)
	var/turf/dropspot = get_turf(src)
	if(my_mop && prob(chance))
		my_mop.forceMove(dropspot)
		my_mop.tumble(2)
		my_mop = null

	if(my_spray && prob(chance))
		my_spray.forceMove(dropspot)
		my_spray.tumble(3)
		my_spray = null

	if(my_lightreplacer && prob(chance))
		my_lightreplacer.forceMove(dropspot)
		my_lightreplacer.tumble(3)
		my_lightreplacer = null

	if(my_bucket && prob(chance*0.5))//bucket is heavier, harder to knock off
		my_bucket.forceMove(dropspot)
		my_bucket.tumble(1)
		my_bucket = null

	if(signs)
		for (var/obj/item/clothing/suit/caution/Sign in src)
			if(prob(min((chance*2),100)))
				signs--
				Sign.forceMove(dropspot)
				Sign.tumble(3)
				if(signs < 0)//safety for something that shouldn't happen
					signs = 0
					update_icon()
					return

	if(my_bag && prob(min((chance*2),100)))//Bag is flimsy
		my_bag.forceMove(dropspot)
		my_bag.tumble(1)
		my_bag.spill()//trashbag spills its contents too
		my_bag = null

	update_icon()

/obj/structure/cart/storage/janitorialcart/update_icon()
	ClearOverlays()
	has_items = FALSE
	if(my_bucket)
		AddOverlays("cart_bucket")
		has_items = TRUE
		if(my_bucket.reagents.total_volume > 0)
			AddOverlays("cart_water")
	if(my_bag)
		AddOverlays("cart_garbage")
		has_items = TRUE
	if(my_mop)
		AddOverlays("cart_mop")
		has_items = TRUE
	if(my_spray)
		AddOverlays("cart_spray")
		has_items = TRUE
	if(my_lightreplacer)
		if(istype(my_lightreplacer, /obj/item/device/lightreplacer/advanced))
			AddOverlays("cart_adv_replacer")
		else
			AddOverlays("cart_replacer")
		has_items = TRUE
	if(signs)
		AddOverlays("cart_sign[signs]")
		has_items = TRUE
