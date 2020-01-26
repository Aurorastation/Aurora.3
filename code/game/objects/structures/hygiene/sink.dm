/obj/structure/hygiene/sink
	name = "sink"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "sink"
	desc = "A sink used for washing one's hands and face."
	anchored = 1
	var/busy = 0 	//Something's being washed at the moment
	var/amount_per_transfer_from_this = 10
	var/possible_transfer_amounts = list(5,10,15,25,30,50,60,100,120,250,300)

/obj/structure/hygiene/sink/verb/set_APTFT() //set amount_per_transfer_from_this
	set name = "Set transfer amount"
	set category = "Object"
	set src in view(1)
	var/N = input("Amount per transfer from this:","[src]") as null|anything in possible_transfer_amounts
	if (N)
		amount_per_transfer_from_this = N

/obj/structure/hygiene/sink/attack_hand(mob/user as mob)
	if (ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/temp = H.organs_by_name[BP_R_HAND]
		if (user.hand)
			temp = H.organs_by_name[BP_L_HAND]
		if(temp && !temp.is_usable())
			to_chat(user, "<span class='notice'>You try to move your [temp.name], but cannot!</span>")
			return

	if(isrobot(user) || isAI(user))
		return

	if(!Adjacent(user))
		return

	if(busy)
		to_chat(user, "<span class='warning'>Someone's already washing here.</span>")
		return

	to_chat(usr, "<span class='notice'>You start washing your hands.</span>")
	playsound(src.loc, 'sound/effects/sink_fill.ogg', 25, 1)

	busy = 1
	sleep(40)
	busy = 0

	if(!Adjacent(user)) return		//Person has moved away from the sink

	user.clean_blood()
	if(ishuman(user))
		user:update_inv_gloves()
	for(var/mob/V in viewers(src, null))
		V.show_message("<span class='notice'>[user] washes their hands using \the [src].</span>")
		playsound(src.loc, 'sound/effects/sink_empty.ogg', 25, 1)

/obj/structure/hygiene/sink/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/clothing/mask/plunger) && !isnull(clogged))
		return ..()

	if(busy)
		to_chat(user, "<span class='warning'>Someone's already washing here.</span>")
		return

	// Filling/emptying open reagent containers
	var/obj/item/reagent_containers/RG = O
	if (istype(RG) && RG.is_open_container())
		var/atype = alert(usr, "Do you want to fill or empty \the [RG] at \the [src]?", "Fill or Empty", "Fill", "Empty", "Cancel")

		if(!usr.Adjacent(src)) return
		if(RG.loc != usr && !isrobot(user)) return
		if(busy)
			to_chat(usr, "<span class='warning'>Someone's already using \the [src].</span>")
			return

		switch(atype)
			if ("Fill")
				if(RG.reagents.total_volume >= RG.volume)
					to_chat(usr, "<span class='warning'>\The [RG] is already full.</span>")
					return

				RG.reagents.add_reagent("water", min(RG.volume - RG.reagents.total_volume, amount_per_transfer_from_this))
				to_chat(oviewers(3, usr), "<span class='notice'>[usr] fills \the [RG] using \the [src].</span>")
				to_chat(usr, "<span class='notice'>You fill \the [RG] using \the [src].</span>")
				playsound(src.loc, 'sound/effects/sink_fill.ogg', 25, 1)
			if ("Empty")
				if(!RG.reagents.total_volume)
					to_chat(usr, "<span class='warning'>\The [RG] is already empty.</span>")
					return

				var/empty_amount = RG.reagents.trans_to(src, RG.amount_per_transfer_from_this)
				to_chat(oviewers(3, usr), "<span class='notice'>[usr] empties [empty_amount]u of \the [RG] into \the [src].</span>")
				to_chat(usr, "<span class='notice'>You empty [empty_amount]u of \the [RG] into \the [src].</span>")
				playsound(src.loc, 'sound/effects/sink_empty.ogg', 25, 1)
		return

	// Filling/empying Syringes
	else if (istype(O, /obj/item/reagent_containers/syringe))
		var/obj/item/reagent_containers/syringe/S = O
		switch(S.mode)
			if(0) // draw
				if(S.reagents.total_volume >= S.volume)
					to_chat(usr, "<span class='warning'>\The [S] is already full.</span>")
					return

				var/trans = min(S.volume - S.reagents.total_volume, S.amount_per_transfer_from_this)
				S.reagents.add_reagent("water", trans)
				to_chat(oviewers(3, usr), "<span class='notice'>[usr] uses \the [S] to draw water from \the [src].</span>")
				to_chat(usr, "<span class='notice'>You draw [trans] units of water from \the [src]. \The [S] now contains [S.reagents.total_volume] units.</span>")
			if(1) // inject
				if(!S.reagents.total_volume)
					to_chat(usr, "<span class='warning'>\The [S] is already empty.</span>")
					return

				var/trans = min(S.amount_per_transfer_from_this, S.reagents.total_volume)
				S.reagents.remove_any(trans)
				to_chat(oviewers(3, usr), "<span class='notice'>[usr] empties \the [S] into \the [src].</span>")
				to_chat(usr, "<span class='notice'>You empty [trans] units of water into \the [src]. \The [S] now contains [S.reagents.total_volume] units.</span>")

		return

	else if (istype(O, /obj/item/melee/baton))
		var/obj/item/melee/baton/B = O
		if(B.bcell)
			if(B.bcell.charge > 0 && B.status == 1)
				flick("baton_active", src)
				user.Stun(10)
				user.stuttering = 10
				user.Weaken(10)
				if(isrobot(user))
					var/mob/living/silicon/robot/R = user
					R.cell.charge -= 20
				else
					B.deductcharge(B.hitcost)
				user.visible_message("<span class='danger'>[user] was stunned by \the [O]!</span>")
				return 1
	// Short of a rewrite, this is necessary to stop monkeycubes being washed.
	else if(istype(O, /obj/item/reagent_containers/food/snacks/monkeycube))
		return
	else if(istype(O, /obj/item/mop))
		O.reagents.add_reagent("water", 5)
		to_chat(user, "<span class='notice'>You wet \the [O] in \the [src].</span>")
		playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
		return

	var/turf/location = user.loc
	if(!isturf(location)) return

	var/obj/item/I = O
	if(!I || !istype(I,/obj/item)) return

	to_chat(usr, "<span class='notice'>You start washing \the [I].</span>")

	busy = 1
	sleep(40)
	busy = 0

	if(user.loc != location) return				//User has moved
	if(!I) return 								//Item's been destroyed while washing
	if(user.get_active_hand() != I) return		//Person has switched hands or the item in their hands

	O.clean_blood()
	user.visible_message( \
		"<span class='notice'>[user] washes \a [I] using \the [src].</span>", \
		"<span class='notice'>You wash \a [I] using \the [src].</span>")


/obj/structure/hygiene/sink/kitchen
	name = "kitchen sink"
	icon_state = "sink_alt"


/obj/structure/hygiene/sink/puddle	//splishy splashy ^_^
	name = "puddle"
	icon_state = "puddle"
	desc = "A small pool of some liquid, ostensibly water."
	clogged = -1 // how do you clog a puddle

/obj/structure/hygiene/sink/puddle/attack_hand(mob/M as mob)
	icon_state = "puddle-splash"
	..()
	icon_state = "puddle"

/obj/structure/hygiene/sink/puddle/attackby(obj/item/O as obj, mob/user as mob)
	icon_state = "puddle-splash"
	..()
	icon_state = "puddle"