/obj/structure/mopbucket
	name = "mop bucket"
	desc = "Fits onto a standard janitorial cart. Fill it with water, but don't forget a mop!"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "mopbucket"
	density = 1
	w_class = WEIGHT_CLASS_NORMAL
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	var/amount_per_transfer_from_this = 5	//shit I dunno, adding this so syringes stop runtime erroring. --NeoFite
	var/bucketsize = 600 //about 2x the size relative to a regular bucket.

/obj/structure/mopbucket/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(distance <= 1)
		. += "It contains <b>[reagents.total_volume] unit\s</b> of water."

/obj/structure/mopbucket/Initialize()
	. = ..()
	create_reagents(bucketsize)

	if(is_station_turf(get_turf(src)))
		GLOB.janitorial_supplies |= src

/obj/structure/mopbucket/Destroy()
	if(src in GLOB.janitorial_supplies)
		GLOB.janitorial_supplies -= src
	return ..()

/obj/structure/mopbucket/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/mop))
		if(reagents.total_volume < 1)
			to_chat(user, SPAN_WARNING("\The [src] is out of water!"))
		else
			reagents.trans_to_obj(attacking_item, 5)
			to_chat(user, SPAN_NOTICE("You wet \the [attacking_item] in \the [src]."))
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
		return ..()
	update_icon()

/obj/structure/mopbucket/update_icon()
	ClearOverlays()
	if(reagents.total_volume > 0)
		AddOverlays("mopbucket_water")

/obj/structure/mopbucket/on_reagent_change()
	. = ..()
	if(istype(loc,/obj/structure/cart/storage/janitorialcart))
		var/obj/structure/cart/storage/janitorialcart/cart = loc
		cart.update_icon()
	else
		update_icon()
