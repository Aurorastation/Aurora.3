/obj/structure/cart/storage/janitorialcart
	name = "custodial cart"
	desc = "The ultimate in custodial carts. Has space for water, mops, signs, trash bags, and more."
	icon = 'icons/obj/janitor.dmi'
	icon_state = "cart"

	var/amount_per_transfer_from_this = 5 //shit I dunno, adding this so syringes stop runtime erroring. --NeoFite
	var/obj/item/storage/bag/trash/mybag = null
	var/obj/item/mop/mymop = null
	var/obj/item/reagent_containers/spray/myspray = null
	var/obj/item/device/lightreplacer/myreplacer = null
	var/obj/structure/mopbucket/mybucket = null
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
		if (mybucket)
			var/contains = mybucket.reagents.total_volume
			. += "[icon2html(src, user)] The bucket contains <b>[contains] unit\s</b> of liquid!"
		else
			. += "[icon2html(src, user)] There is no bucket mounted on it!"
	//everything else is visible, so doesn't need to be mentioned

// Regular Variant
// No trashbag and no light replacer, this is inside the custodian's locker.
/obj/structure/cart/storage/janitorialcart/Initialize()
	. = ..()
	mymop = new /obj/item/mop(src)
	myspray = new /obj/item/reagent_containers/spray/cleaner(src)

	mybucket = new /obj/structure/mopbucket(src)

	for(signs, signs < 4, signs++)
		new /obj/item/clothing/suit/caution(src)

	update_icon()

// Full Variant
// Has everything.
/obj/structure/cart/storage/janitorialcart/full/Initialize()
	. = ..()
	mybag = new /obj/item/storage/bag/trash(src)
	mymop = new /obj/item/mop(src)
	myspray = new /obj/item/reagent_containers/spray/cleaner(src)
	myreplacer = new /obj/item/device/lightreplacer(src)

	mybucket = new /obj/structure/mopbucket(src)

	for(signs, signs < 4, signs++)
		new /obj/item/clothing/suit/caution(src)

	update_icon()

// Full with Water Variant
// Has everything as well as water in the mop bucket.
/obj/structure/cart/storage/janitorialcart/full/water/Initialize()
	. = ..()
	mybag = new /obj/item/storage/bag/trash(src)
	mymop = new /obj/item/mop(src)
	myspray = new /obj/item/reagent_containers/spray/cleaner(src)
	myreplacer = new /obj/item/device/lightreplacer(src)

	mybucket = new /obj/structure/mopbucket(src)
	mybucket.reagents.add_reagent(/singleton/reagent/water, mybucket.bucketsize)

	for(signs, signs < 4, signs++)
		new /obj/item/clothing/suit/caution(src)

	update_icon()

/obj/structure/cart/storage/janitorialcart/New()
	..()
	if(is_station_turf(get_turf(src)))
		GLOB.janitorial_supplies |= src

/obj/structure/cart/storage/janitorialcart/Destroy()
	if(src in GLOB.janitorial_supplies)
		GLOB.janitorial_supplies -= src
	QDEL_NULL(mybag)
	QDEL_NULL(mymop)
	QDEL_NULL(myspray)
	QDEL_NULL(myreplacer)
	QDEL_NULL(mybucket)
	return ..()

/obj/structure/cart/storage/janitorialcart/proc/get_short_status()
	return "Contents: [english_list(contents)]"

/obj/structure/cart/storage/janitorialcart/mouse_drop_receive(atom/dropped, mob/user, params)
	var/atom/movable/O = dropped
	if (istype(O, /obj/structure/mopbucket) && !mybucket)
		O.forceMove(src)
		mybucket = O
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
		if(!mymop)
			usr.drop_from_inventory(I,src)
			mymop = I
			update_icon()
			updateUsrDialog()
			to_chat(usr, SPAN_NOTICE("You put [I] into [src]."))
		else
			to_chat(usr, SPAN_NOTICE("The cart already has a mop attached"))
		return
	else if(istype(I, /obj/item/reagent_containers) && mybucket)
		var/obj/item/reagent_containers/C = I
		C.afterattack(mybucket, usr, 1)
	else if(istype (I, /obj/item/device/lightreplacer))
		var/obj/item/device/lightreplacer/LR = I
		if (LR.store_broken)
			return mybag.attackby(I, usr)

/obj/structure/cart/storage/janitorialcart/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/mop) || istype(attacking_item, /obj/item/reagent_containers/glass/rag) || istype(attacking_item, /obj/item/soap))
		if (mybucket)
			if(attacking_item.reagents.total_volume < attacking_item.reagents.maximum_volume)
				if(mybucket.reagents.total_volume < 1)
					to_chat(user, SPAN_NOTICE("[mybucket] is empty!"))
					update_icon()
				else
					mybucket.reagents.trans_to_obj(attacking_item, 5)	//
					to_chat(user, SPAN_NOTICE("You wet [attacking_item] in [mybucket]."))
					playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
					update_icon()
			else
				to_chat(user, SPAN_NOTICE("[attacking_item] can't absorb anymore liquid!"))
		else
			to_chat(user, SPAN_NOTICE("There is no bucket mounted here to dip [attacking_item] into!"))
		return 1

	else if(istype(attacking_item, /obj/item/reagent_containers/spray) && !myspray)
		user.drop_from_inventory(attacking_item, src)
		myspray = attacking_item
		update_icon()
		updateUsrDialog()
		to_chat(user, SPAN_NOTICE("You put [attacking_item] into [src]."))
		return 1

	else if(istype(attacking_item, /obj/item/device/lightreplacer) && !myreplacer)
		user.drop_from_inventory(attacking_item, src)
		myreplacer = attacking_item
		update_icon()
		updateUsrDialog()
		to_chat(user, SPAN_NOTICE("You put [attacking_item] into [src]."))
		return 1

	else if(istype(attacking_item, /obj/item/storage/bag/trash) && !mybag)
		user.drop_from_inventory(attacking_item, src)
		mybag = attacking_item
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

	else if(mybag)
		return mybag.attackby(attacking_item, user)
		//This return will prevent afterattack from executing if the object goes into the trashbag,
		//This prevents dumb stuff like splashing the cart with the contents of a container, after putting said container into trash

	else if (!has_items && (attacking_item.iswrench() || attacking_item.iswelder() || istype(attacking_item, /obj/item/gun/energy/plasmacutter)))
		take_apart(user, attacking_item)
		return
	..()

//This is called if the cart is caught in an explosion, or destroyed by weapon fire
/obj/structure/cart/storage/janitorialcart/spill(var/chance = 100)
	var/turf/dropspot = get_turf(src)
	if (mymop && prob(chance))
		mymop.forceMove(dropspot)
		mymop.tumble(2)
		mymop = null

	if (myspray && prob(chance))
		myspray.forceMove(dropspot)
		myspray.tumble(3)
		myspray = null

	if (myreplacer && prob(chance))
		myreplacer.forceMove(dropspot)
		myreplacer.tumble(3)
		myreplacer = null

	if (mybucket && prob(chance*0.5))//bucket is heavier, harder to knock off
		mybucket.forceMove(dropspot)
		mybucket.tumble(1)
		mybucket = null

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

	if (mybag && prob(min((chance*2),100)))//Bag is flimsy
		mybag.forceMove(dropspot)
		mybag.tumble(1)
		mybag.spill()//trashbag spills its contents too
		mybag = null

	update_icon()

/obj/structure/cart/storage/janitorialcart/attack_hand(mob/user)
	ui_interact(user)
	return

/obj/structure/cart/storage/janitorialcart/ui_interact(var/mob/user, var/ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	data["name"] = capitalize(name)
	data["bag"] = mybag ? capitalize(mybag.name) : null
	data["bucket"] = mybucket ? capitalize(mybucket.name) : null
	data["mop"] = mymop ? capitalize(mymop.name) : null
	data["spray"] = myspray ? capitalize(myspray.name) : null
	data["replacer"] = myreplacer ? capitalize(myreplacer.name) : null
	data["signs"] = signs ? "[signs] sign\s" : null

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "janitorcart.tmpl", "Janitorial cart", 240, 160)
		ui.set_initial_data(data)
		ui.open()

/obj/structure/cart/storage/janitorialcart/Topic(href, href_list)
	if(!in_range(src, usr))
		return
	if(!isliving(usr))
		return
	var/mob/living/user = usr
	if(href_list["take"])
		switch(href_list["take"])
			if("garbage")
				if(mybag)
					user.put_in_hands(mybag)
					to_chat(user, SPAN_NOTICE("You take [mybag] from [src]."))
					mybag = null
			if("mop")
				if(mymop)
					user.put_in_hands(mymop)
					to_chat(user, SPAN_NOTICE("You take [mymop] from [src]."))
					mymop = null
			if("spray")
				if(myspray)
					user.put_in_hands(myspray)
					to_chat(user, SPAN_NOTICE("You take [myspray] from [src]."))
					myspray = null
			if("replacer")
				if(myreplacer)
					user.put_in_hands(myreplacer)
					to_chat(user, SPAN_NOTICE("You take [myreplacer] from [src]."))
					myreplacer = null
			if("sign")
				if(signs)
					var/obj/item/clothing/suit/caution/Sign = locate() in src
					if(Sign)
						user.put_in_hands(Sign)
						to_chat(user, SPAN_NOTICE("You take \a [Sign] from [src]."))
						signs--
					else
						warning("[src] signs ([signs]) didn't match contents")
						signs = 0
			if("bucket")
				if(mybucket)
					mybucket.forceMove(get_turf(user))
					to_chat(user, SPAN_NOTICE("You unmount [mybucket] from [src]."))
					mybucket.update_icon()
					mybucket = null

	update_icon()
	updateUsrDialog()

/obj/structure/cart/storage/janitorialcart/update_icon()
	ClearOverlays()
	has_items = 0
	if(mybucket)
		AddOverlays("cart_bucket")
		has_items = 1
		if(mybucket.reagents.total_volume > 0)
			AddOverlays("cart_water")
	if(mybag)
		AddOverlays("cart_garbage")
		has_items = 1
	if(mymop)
		AddOverlays("cart_mop")
		has_items = 1
	if(myspray)
		AddOverlays("cart_spray")
		has_items = 1
	if(myreplacer)
		if (istype(myreplacer, /obj/item/device/lightreplacer/advanced))
			AddOverlays("cart_adv_lightreplacer")
		else
			AddOverlays("cart_replacer")
		has_items = 1
	if(signs)
		AddOverlays("cart_sign[signs]")
		has_items = 1
