/obj/structure/cart/storage/janitorialcart
	name = "custodial cart"
	desc = "The ultimate in custodial carts. Has space for water, mops, signs, trash bags, and more."
	icon = 'icons/obj/janitor.dmi'
	icon_state = "cart"

	var/amount_per_transfer_from_this = 5 //shit I dunno, adding this so syringes stop runtime erroring. --NeoFite
	var/obj/item/storage/bag/trash/my_bag = null
	var/obj/item/mop/my_mop = null
	var/obj/item/reagent_containers/spray/my_spray = null
	var/obj/item/device/lightreplacer/my_lightreplacer = null
	var/obj/structure/mopbucket/my_bucket = null
	var/signs = 0 //maximum capacity hardcoded below

/obj/structure/cart/storage/janitorialcart/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Click and drag a mop bucket onto the cart to mount it."
	. += "ALT-Click with a mop to put it away; a normal click will wet it in the bucket."
	. += "ALT-Click with a container, such as a bucket, to pour its contents into the mounted bucket. A normal click will toss it into the trash."
	. += "You can use a light replacer, spraybottle (of space cleaner) and four wet-floor signs on the cart to store them."

/obj/structure/cart/storage/janitorialcart/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(distance <= 1)
		if (my_bucket)
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
	update_icon()

// Full Variant
// Has everything.
/obj/structure/cart/storage/janitorialcart/full/Initialize()
	. = ..()
	my_bag = new /obj/item/storage/bag/trash(src)
	my_mop = new /obj/item/mop(src)
	my_spray = new /obj/item/reagent_containers/spray/cleaner(src)
	my_lightreplacer = new /obj/item/device/lightreplacer(src)
	my_bucket = new /obj/structure/mopbucket(src)

	for(signs, signs < 4, signs++)
		new /obj/item/clothing/suit/caution(src)

	update_icon()

// Full with Water Variant
// Has everything as well as water in the mop bucket.
/obj/structure/cart/storage/janitorialcart/full/water/Initialize()
	. = ..()
	my_bucket.reagents.add_reagent(/singleton/reagent/water, my_bucket.bucketsize)
	update_icon()

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
	var/atom/movable/O = dropped
	if (istype(O, /obj/structure/mopbucket) && !my_bucket)
		O.forceMove(src)
		my_bucket = O
		to_chat(user, "You mount the [O] on the janicart.")
		update_icon()
	else
		..()

//New Altclick functionality!
//Altclick the cart with a mop to stow the mop away
//Altclick the cart with a reagent container to pour things into the bucket without putting the bottle in trash
/obj/structure/cart/storage/janitorialcart/AltClick()
	if(!usr || usr.stat || usr.lying || usr.restrained() || !Adjacent(usr))	return
	var/obj/I = usr.get_active_hand()
	if(istype(I, /obj/item/mop))
		if(!my_mop)
			usr.drop_from_inventory(I,src)
			my_mop = I
			update_icon()
			updateUsrDialog()
			to_chat(usr, SPAN_NOTICE("You put [I] into [src]."))
		else
			to_chat(usr, SPAN_NOTICE("The cart already has a mop attached"))
		return
	else if(istype(I, /obj/item/reagent_containers) && my_bucket)
		var/obj/item/reagent_containers/C = I
		C.afterattack(my_bucket, usr, 1)
	else if(istype (I, /obj/item/device/lightreplacer))
		var/obj/item/device/lightreplacer/LR = I
		if (LR.store_broken)
			return my_bag.attackby(I, usr)

/obj/structure/cart/storage/janitorialcart/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/mop) || istype(attacking_item, /obj/item/reagent_containers/glass/rag) || istype(attacking_item, /obj/item/soap))
		if (my_bucket)
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

	else if(istype(attacking_item, /obj/item/reagent_containers/spray) && !my_spray)
		user.drop_from_inventory(attacking_item, src)
		my_spray = attacking_item
		update_icon()
		updateUsrDialog()
		to_chat(user, SPAN_NOTICE("You put [attacking_item] into [src]."))
		return 1

	else if(istype(attacking_item, /obj/item/device/lightreplacer) && !my_lightreplacer)
		user.drop_from_inventory(attacking_item, src)
		my_lightreplacer = attacking_item
		update_icon()
		updateUsrDialog()
		to_chat(user, SPAN_NOTICE("You put [attacking_item] into [src]."))
		return 1

	else if(istype(attacking_item, /obj/item/storage/bag/trash) && !my_bag)
		user.drop_from_inventory(attacking_item, src)
		my_bag = attacking_item
		attacking_item.forceMove(src)
		update_icon()
		updateUsrDialog()
		to_chat(user, SPAN_NOTICE("You put [attacking_item] into [src]."))
		return 1

	else if(istype(attacking_item, /obj/item/clothing/suit/caution))
		if(signs < 4)
			user.drop_from_inventory(attacking_item, src)
			signs++
			update_icon()
			updateUsrDialog()
			to_chat(user, SPAN_NOTICE("You put [attacking_item] into [src]."))
		else
			to_chat(user, SPAN_NOTICE("[src] can't hold any more signs."))
		return 1

	else if(my_bag)
		return my_bag.attackby(attacking_item, user)
		//This return will prevent afterattack from executing if the object goes into the trashbag,
		//This prevents dumb stuff like splashing the cart with the contents of a container, after putting said container into trash

	else if (!has_items && (attacking_item.iswrench() || attacking_item.iswelder() || istype(attacking_item, /obj/item/gun/energy/plasmacutter)))
		take_apart(user, attacking_item)
		return
	..()

//This is called if the cart is caught in an explosion, or destroyed by weapon fire
/obj/structure/cart/storage/janitorialcart/spill(var/chance = 100)
	var/turf/dropspot = get_turf(src)
	if (my_mop && prob(chance))
		my_mop.forceMove(dropspot)
		my_mop.tumble(2)
		my_mop = null

	if (my_spray && prob(chance))
		my_spray.forceMove(dropspot)
		my_spray.tumble(3)
		my_spray = null

	if (my_lightreplacer && prob(chance))
		my_lightreplacer.forceMove(dropspot)
		my_lightreplacer.tumble(3)
		my_lightreplacer = null

	if (my_bucket && prob(chance*0.5))//bucket is heavier, harder to knock off
		my_bucket.forceMove(dropspot)
		my_bucket.tumble(1)
		my_bucket = null

	if (signs)
		for (var/obj/item/clothing/suit/caution/Sign in src)
			if (prob(min((chance*2),100)))
				signs--
				Sign.forceMove(dropspot)
				Sign.tumble(3)
				if (signs < 0)//safety for something that shouldn't happen
					signs = 0
					update_icon()
					return

	if (my_bag && prob(min((chance*2),100)))//Bag is flimsy
		my_bag.forceMove(dropspot)
		my_bag.tumble(1)
		my_bag.spill()//trashbag spills its contents too
		my_bag = null

	update_icon()

/obj/structure/cart/storage/janitorialcart/attack_hand(mob/user)
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
				if(/obj/item/storage/bag/trash)
					if(my_bag)
						user.put_in_hands(my_bag)
						to_chat(user, SPAN_NOTICE("You take [my_bag] from [src]."))
						my_bag = null
				if(/obj/item/mop)
					if(my_mop)
						user.put_in_hands(my_mop)
						to_chat(user, SPAN_NOTICE("You take [my_mop] from [src]."))
						my_mop = null
				if(/obj/item/reagent_containers/spray)
					if(my_spray)
						user.put_in_hands(my_spray)
						to_chat(user, SPAN_NOTICE("You take [my_spray] from [src]."))
						my_spray = null
				if(/obj/item/device/lightreplacer, /obj/item/device/lightreplacer/advanced)
					if(my_lightreplacer)
						user.put_in_hands(my_lightreplacer)
						to_chat(user, SPAN_NOTICE("You take [my_lightreplacer] from [src]."))
						my_lightreplacer = null
				if(/obj/structure/mopbucket)
					if(my_bucket)
						user.put_in_hands(my_bucket)
						to_chat(user, SPAN_NOTICE("You take [my_bucket] from [src]."))
						my_bucket = null
				if(/obj/item/clothing/suit/caution)
					if(signs)
						user.put_in_hands(src[chosen_item])
						to_chat(user, SPAN_NOTICE("You take [signs[chosen_item]] from [src]."))
						signs -= 1

			get_storage_contents_list()
			update_icon()
		else
			to_chat(user, SPAN_WARNING("\The [chosen_item] is not in the cart anymore!"))

/obj/structure/cart/storage/janitorialcart/get_storage_contents_list()
	storage_contents.Cut()
	var/list/objects = list(my_bag, my_mop, my_spray, my_lightreplacer, my_bucket)

	for(var/obj/O in objects)
		if(O)
			storage_contents += O
	for(var/obj/item/clothing/suit/caution in src)
		if(caution)
			storage_contents += caution

/obj/structure/cart/storage/janitorialcart/update_icon()
	ClearOverlays()
	has_items = 0
	if(my_bucket)
		AddOverlays("cart_bucket")
		has_items = 1
		if(my_bucket.reagents.total_volume > 0)
			AddOverlays("cart_water")
	if(my_bag)
		AddOverlays("cart_garbage")
		has_items = 1
	if(my_mop)
		AddOverlays("cart_mop")
		has_items = 1
	if(my_spray)
		AddOverlays("cart_spray")
		has_items = 1
	if(my_lightreplacer)
		if (istype(my_lightreplacer, /obj/item/device/lightreplacer/advanced))
			AddOverlays("cart_adv_lightreplacer")
		else
			AddOverlays("cart_replacer")
		has_items = 1
	if(signs)
		AddOverlays("cart_sign[signs]")
		has_items = 1
