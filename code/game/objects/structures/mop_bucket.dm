/obj/structure/mopbucket
	name = "mop bucket"
	desc = "Fits onto a standard janitorial cart. Fill it with water, but don't forget a mop!"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "mopbucket"
	density = 1
	w_class = 3
	flags = OPENCONTAINER
	var/amount_per_transfer_from_this = 5	//shit I dunno, adding this so syringes stop runtime erroring. --NeoFite
	var/bucketsize = 360 //about 3x the size relative to a regular bucket.

/obj/structure/mopbucket/Initialize()
	. = ..()
	create_reagents(bucketsize)
	janitorial_supplies |= src

/obj/structure/mobbucket/Destroy()
	janitorial_supplies -= src
	return ..()

/obj/structure/mopbucket/examine(mob/user)
	if(..(user, 1))
		to_chat(user, "Contains [reagents.total_volume] unit\s of water.")

/obj/structure/mopbucket/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/mop))
		if(reagents.total_volume < 1)
			to_chat(user, "<span class='warning'>\The [src] is out of water!</span>")
		else
			reagents.trans_to_obj(I, 5)
			to_chat(user, "<span class='notice'>You wet \the [I] in \the [src].</span>")
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
		return ..()
	update_icon()

/obj/structure/mopbucket/update_icon()
	cut_overlays()
	if(reagents.total_volume > 0)
		add_overlay("mopbucket_water")

/obj/structure/mopbucket/on_reagent_change()
	. = ..()
	if(istype(loc,/obj/structure/janitorialcart))
		var/obj/structure/janitorialcart/cart = loc
		cart.update_icon()
	else
		update_icon()