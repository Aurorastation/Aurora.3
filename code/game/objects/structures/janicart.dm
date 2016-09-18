/obj/structure/janitorialcart
	name = "janitorial cart"
	desc = "The ultimate in janitorial carts! Has space for water, mops, signs, trash bags, and more!"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "cart"
	anchored = 0
	density = 1
	climbable = 1
	flags = OPENCONTAINER
	//copypaste sorry
	var/amount_per_transfer_from_this = 5 //shit I dunno, adding this so syringes stop runtime erroring. --NeoFite
	var/obj/item/weapon/storage/bag/trash/mybag	= null
	var/obj/item/weapon/mop/mymop = null
	var/obj/item/weapon/reagent_containers/spray/myspray = null
	var/obj/item/device/lightreplacer/myreplacer = null
	var/obj/structure/mopbucket/mybucket = null
	var/signs = 0	//maximum capacity hardcoded below
	var/has_items = 0//This is set true whenever the cart has anything loaded/mounted on it
	var/dismantled = 0//This is set true after the object has been dismantled to avoid an infintie loop

///obj/structure/janitorialcart/New()


/obj/structure/janitorialcart/examine(mob/user)
	if(..(user, 1))
		if (mybucket)
			var/contains = mybucket.reagents.total_volume
			world << "Contains is [contains]"
			user << "\icon[src] The bucket contains [contains] unit\s of liquid!"
		else
			user << "\icon[src] There is no bucket mounted on it!"
	//everything else is visible, so doesn't need to be mentioned


/obj/structure/janitorialcart/MouseDrop_T(atom/movable/O as mob|obj, mob/living/user as mob)
	if (istype(O, /obj/structure/mopbucket) && !mybucket)
		O.loc = src
		mybucket = O
		user << "You mount the [O] on the janicart."
		update_icon()
	else
		..()

//New Altclick functionality!
//Altclick the cart with a mop to stow the mop away
//Altclick the cart with a reagent container to pour things into the bucket without putting the bottle in trash
/obj/structure/janitorialcart/AltClick()
	var/obj/I = usr.get_active_hand()
	if(istype(I, /obj/item/weapon/mop))
		if(!mymop)
			usr.drop_item()
			mymop = I
			I.forceMove(src)
			update_icon()
			updateUsrDialog()
			usr << "<span class='notice'>You put [I] into [src].</span>"
		else
			usr << "<span class='notice'>The cart already has a mop attached</span>"
		return
	else if(istype(I, /obj/item/weapon/reagent_containers) && mybucket)
		var/obj/item/weapon/reagent_containers/C = I
		C.afterattack(mybucket, usr, 1)
	else if(istype (I, /obj/item/device/lightreplacer))
		var/obj/item/device/lightreplacer/LR = I
		if (LR.store_broken)
			return mybag.attackby(I, usr)


/obj/structure/janitorialcart/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/mop) || istype(I, /obj/item/weapon/reagent_containers/glass/rag) || istype(I, /obj/item/weapon/soap))
		if (mybucket)
			if(I.reagents.total_volume < I.reagents.maximum_volume)
				if(mybucket.reagents.total_volume < 1)
					user << "<span class='notice'>[mybucket] is empty!</span>"
				else
					mybucket.reagents.trans_to_obj(I, 5)	//
					user << "<span class='notice'>You wet [I] in [mybucket].</span>"
					playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
			else
				user << "<span class='notice'>[I] can't absorb anymore liquid!</span>"
		else
			user << "<span class='notice'>There is no bucket mounted here to dip [I] into!</span>"
		return 1

	else if(istype(I, /obj/item/weapon/reagent_containers/spray) && !myspray)
		user.drop_item()
		myspray = I
		I.forceMove(src)
		update_icon()
		updateUsrDialog()
		user << "<span class='notice'>You put [I] into [src].</span>"
		return 1

	else if(istype(I, /obj/item/device/lightreplacer) && !myreplacer)
		user.drop_item()
		myreplacer = I
		I.forceMove(src)
		update_icon()
		updateUsrDialog()
		user << "<span class='notice'>You put [I] into [src].</span>"
		return 1

	else if(istype(I, /obj/item/weapon/storage/bag/trash) && !mybag)
		user.drop_item()
		mybag = I
		I.forceMove(src)
		update_icon()
		updateUsrDialog()
		user << "<span class='notice'>You put [I] into [src].</span>"
		return 1

	else if(istype(I, /obj/item/weapon/caution))
		if(signs < 4)
			user.drop_item()
			I.forceMove(src)
			signs++
			update_icon()
			updateUsrDialog()
			user << "<span class='notice'>You put [I] into [src].</span>"
		else
			user << "<span class='notice'>[src] can't hold any more signs.</span>"
		return 1

	else if(mybag)
		return mybag.attackby(I, user)
		//This return will prevent afterattack from executing if the object goes into the trashbag,
		//This prevents dumb stuff like splashing the cart with the contents of a container, after putting said container into trash

	else if (!has_items && (istype(I, /obj/item/weapon/wrench) || istype(I, /obj/item/weapon/weldingtool) || istype(I, /obj/item/weapon/pickaxe/plasmacutter)))
		dismantle(user)
		return
	..()

/obj/structure/janitorialcart/proc/dismantle(var/mob/user = null)
	if (!dismantled)
		if (has_items)
			spill()

		if (user)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			user.visible_message("[user] starts taking apart the [src]", "You start disasembling the [src]")
			if (!do_after(user, 30, needhand = 0))
				return

		new /obj/item/stack/material/steel(src.loc, 15)
		dismantled = 1
		qdel(src)

/obj/structure/janitorialcart/ex_act(severity)
	spill(100 / severity)
	..()

//This is called if the cart is caught in an explosion, or destroyed by weapon fire
/obj/structure/janitorialcart/proc/spill(var/chance = 100)
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
		for (var/obj/item/weapon/caution/Sign in src)
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



/obj/structure/janitorialcart/attack_hand(mob/user)
	ui_interact(user)
	return

/obj/structure/janitorialcart/ui_interact(var/mob/user, var/ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	data["name"] = capitalize(name)
	data["bag"] = mybag ? capitalize(mybag.name) : null
	data["bucket"] = mybucket ? capitalize(mybucket.name) : null
	data["mop"] = mymop ? capitalize(mymop.name) : null
	data["spray"] = myspray ? capitalize(myspray.name) : null
	data["replacer"] = myreplacer ? capitalize(myreplacer.name) : null
	data["signs"] = signs ? "[signs] sign\s" : null

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "janitorcart.tmpl", "Janitorial cart", 240, 160)
		ui.set_initial_data(data)
		ui.open()

/obj/structure/janitorialcart/Topic(href, href_list)
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
					user << "<span class='notice'>You take [mybag] from [src].</span>"
					mybag = null
			if("mop")
				if(mymop)
					user.put_in_hands(mymop)
					user << "<span class='notice'>You take [mymop] from [src].</span>"
					mymop = null
			if("spray")
				if(myspray)
					user.put_in_hands(myspray)
					user << "<span class='notice'>You take [myspray] from [src].</span>"
					myspray = null
			if("replacer")
				if(myreplacer)
					user.put_in_hands(myreplacer)
					user << "<span class='notice'>You take [myreplacer] from [src].</span>"
					myreplacer = null
			if("sign")
				if(signs)
					var/obj/item/weapon/caution/Sign = locate() in src
					if(Sign)
						user.put_in_hands(Sign)
						user << "<span class='notice'>You take \a [Sign] from [src].</span>"
						signs--
					else
						warning("[src] signs ([signs]) didn't match contents")
						signs = 0
			if("bucket")
				if(mybucket)
					mybucket.forceMove(get_turf(user))
					user << "<span class='notice'>You unmount [mybucket] from [src].</span>"
					mybucket = null

	update_icon()
	updateUsrDialog()


/obj/structure/janitorialcart/update_icon()
	overlays = null
	has_items = 0
	if(mybucket)
		overlays += "cart_bucket"
		has_items = 1
	if(mybag)
		overlays += "cart_garbage"
		has_items = 1
	if(mymop)
		overlays += "cart_mop"
		has_items = 1
	if(myspray)
		overlays += "cart_spray"
		has_items = 1
	if(myreplacer)
		if (istype(myreplacer, /obj/item/device/lightreplacer/advanced))
			overlays += "cart_adv_lightreplacer"
		else
			overlays += "cart_replacer"
		has_items = 1
	if(signs)
		overlays += "cart_sign[signs]"
		has_items = 1


//old style retardo-cart
/obj/structure/bed/chair/janicart
	name = "janicart"
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "pussywagon"
	anchored = 1
	density = 1
	flags = OPENCONTAINER
	//copypaste sorry
	var/amount_per_transfer_from_this = 5 //shit I dunno, adding this so syringes stop runtime erroring. --NeoFite
	var/obj/item/weapon/storage/bag/trash/mybag	= null
	var/callme = "pimpin' ride"	//how do people refer to it?


/obj/structure/bed/chair/janicart/New()
	create_reagents(100)
	update_layer()


/obj/structure/bed/chair/janicart/examine(mob/user)
	if(!..(user, 1))
		return

	user << "\icon[src] This [callme] contains [reagents.total_volume] unit\s of water!"
	if(mybag)
		user << "\A [mybag] is hanging on the [callme]."


/obj/structure/bed/chair/janicart/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/mop))
		if(reagents.total_volume > 1)
			reagents.trans_to_obj(I, 2)
			user << "<span class='notice'>You wet [I] in the [callme].</span>"
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
		else
			user << "<span class='notice'>This [callme] is out of water!</span>"
	else if(istype(I, /obj/item/key))
		user << "Hold [I] in one of your hands while you drive this [callme]."
	else if(istype(I, /obj/item/weapon/storage/bag/trash))
		user << "<span class='notice'>You hook the trashbag onto the [callme].</span>"
		user.drop_item()
		I.loc = src
		mybag = I


/obj/structure/bed/chair/janicart/attack_hand(mob/user)
	if(mybag)
		mybag.loc = get_turf(user)
		user.put_in_hands(mybag)
		mybag = null
	else
		..()


/obj/structure/bed/chair/janicart/relaymove(mob/user, direction)
	if(user.stat || user.stunned || user.weakened || user.paralysis)
		unbuckle_mob()
	if(istype(user.l_hand, /obj/item/key) || istype(user.r_hand, /obj/item/key))
		step(src, direction)
		update_mob()
	else
		user << "<span class='notice'>You'll need the keys in one of your hands to drive this [callme].</span>"


/obj/structure/bed/chair/janicart/Move()
	..()
	if(buckled_mob)
		if(buckled_mob.buckled == src)
			buckled_mob.loc = loc


/obj/structure/bed/chair/janicart/post_buckle_mob(mob/living/M)
	update_mob()
	return ..()


/obj/structure/bed/chair/janicart/update_layer()
	if(dir == SOUTH)
		layer = FLY_LAYER
	else
		layer = OBJ_LAYER


/obj/structure/bed/chair/janicart/unbuckle_mob()
	var/mob/living/M = ..()
	if(M)
		M.pixel_x = 0
		M.pixel_y = 0
	return M


/obj/structure/bed/chair/janicart/set_dir()
	..()
	update_layer()
	if(buckled_mob)
		if(buckled_mob.loc != loc)
			buckled_mob.buckled = null //Temporary, so Move() succeeds.
			buckled_mob.buckled = src //Restoring

	update_mob()


/obj/structure/bed/chair/janicart/proc/update_mob()
	if(buckled_mob)
		buckled_mob.set_dir(dir)
		switch(dir)
			if(SOUTH)
				buckled_mob.pixel_x = 0
				buckled_mob.pixel_y = 7
			if(WEST)
				buckled_mob.pixel_x = 13
				buckled_mob.pixel_y = 7
			if(NORTH)
				buckled_mob.pixel_x = 0
				buckled_mob.pixel_y = 4
			if(EAST)
				buckled_mob.pixel_x = -13
				buckled_mob.pixel_y = 7


/obj/structure/bed/chair/janicart/bullet_act(var/obj/item/projectile/Proj)
	if(buckled_mob)
		if(prob(85))
			return buckled_mob.bullet_act(Proj)
	visible_message("<span class='warning'>[Proj] ricochets off the [callme]!</span>")


/obj/item/key
	name = "key"
	desc = "A keyring with a small steel key, and a pink fob reading \"Pussy Wagon\"."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "keys"
	w_class = 1
