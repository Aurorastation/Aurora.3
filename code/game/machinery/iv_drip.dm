/obj/machinery/iv_drip
	name = "\improper IV drip"
	icon = 'icons/obj/iv_drip.dmi'
	anchored = 0
	density = 1


/obj/machinery/iv_drip/var/mob/living/carbon/human/attached = null
/obj/machinery/iv_drip/var/mode = 1 // 1 is injecting, 0 is taking blood.
/obj/machinery/iv_drip/var/transfer_amount = REM
/obj/machinery/iv_drip/var/obj/item/reagent_containers/beaker = null

/obj/machinery/iv_drip/update_icon()
	if(src.attached)
		icon_state = "hooked"
	else
		icon_state = ""

	cut_overlays()

	if(beaker)
		var/datum/reagents/reagents = beaker.reagents
		if(reagents.total_volume)
			var/image/filling = image('icons/obj/iv_drip.dmi', src, "reagent")

			var/percent = round((reagents.total_volume / beaker.volume) * 100)
			switch(percent)
				if(0 to 9)		filling.icon_state = "reagent0"
				if(10 to 24) 	filling.icon_state = "reagent10"
				if(25 to 49)	filling.icon_state = "reagent25"
				if(50 to 74)	filling.icon_state = "reagent50"
				if(75 to 79)	filling.icon_state = "reagent75"
				if(80 to 90)	filling.icon_state = "reagent80"
				if(91 to INFINITY)	filling.icon_state = "reagent100"

			filling.icon += reagents.get_color()
			add_overlay(filling)

/obj/machinery/iv_drip/MouseDrop(over_object, src_location, over_location)
	..()

	if(attached)
		visible_message("[src.attached] is detached from \the [src]")
		src.attached = null
		src.update_icon()
		return

	if(in_range(src, usr) && ishuman(over_object) && get_dist(over_object, src) <= 1)
		visible_message("[usr] attaches \the [src] to \the [over_object].")
		src.attached = over_object
		src.update_icon()


/obj/machinery/iv_drip/attackby(obj/item/W as obj, mob/user as mob)

	if (istype(W, /obj/item/reagent_containers/blood/ripped))
		to_chat(user, "You can't use a ripped bloodpack.")
		return
	if (istype(W, /obj/item/reagent_containers))
		if(!isnull(src.beaker))
			to_chat(user, "There is already a reagent container loaded!")
			return

		user.drop_from_inventory(W,src)
		src.beaker = W
		to_chat(user, "You attach \the [W] to \the [src].")
		src.update_icon()
		return
	else
		return ..()


/obj/machinery/iv_drip/machinery_process()
	set background = 1

	if(src.attached)

		if(!(get_dist(src, src.attached) <= 1 && isturf(src.attached.loc)))
			var/obj/item/organ/external/affecting = src.attached:get_organ(pick("r_arm", "l_arm"))
			src.attached.visible_message("<span class='warning'>The needle is ripped out of [src.attached]'s [affecting.limb_name == "r_arm" ? "right arm" : "left arm"].</span>", "<span class='danger'>The needle <B>painfully</B> rips out of your [affecting.limb_name == "r_arm" ? "right arm" : "left arm"].</span>")
			affecting.take_damage(brute = 5, sharp = 1)
			src.attached = null
			src.update_icon()
			return

	if(src.attached && src.beaker)

		var/mob/living/carbon/human/T = attached

		if(!istype(T))
			return

		if(!T.dna)
			return

		if(NOCLONE in T.mutations)
			return

		if(T.species.flags & NO_BLOOD)
			return

		// Give blood
		if(mode)
			if(src.beaker.volume > 0)
				src.beaker.reagents.trans_to_mob(src.attached, transfer_amount, CHEM_BLOOD)
				update_icon()

		// Take blood
		else
			var/amount = beaker.reagents.maximum_volume - beaker.reagents.total_volume
			amount = min(amount, 4)
			// If the beaker is full, ping
			if(amount == 0)
				if(prob(5)) visible_message("\The [src] pings.")
				return

			// If the human is losing too much blood, beep.
			if(T.vessel.get_reagent_amount("blood") < BLOOD_VOLUME_SAFE) if(prob(5))
				visible_message("<span class='warning'>\The [src] beeps loudly.</span>")

			var/datum/reagent/B = T.take_blood(beaker,amount)

			if (B)
				beaker.reagents.reagent_list |= B
				beaker.reagents.update_total()
				beaker.on_reagent_change()
				beaker.reagents.handle_reactions()
				update_icon()

/obj/machinery/iv_drip/attack_hand(mob/user as mob)
	if (isAI(user))
		return
	if(src.beaker)
		src.beaker.forceMove(get_turf(src))
		src.beaker = null
		update_icon()
	else
		return ..()


/obj/machinery/iv_drip/verb/toggle_mode()
	set category = "Object"
	set name = "Toggle Mode"
	set src in view(1)

	if(!istype(usr, /mob/living))
		to_chat(usr, "<span class='warning'>You can't do that.</span>")
		return

	if(usr.stat)
		return

	mode = !mode
	to_chat(usr, "The IV drip is now [mode ? "injecting" : "taking blood"].")

/obj/machinery/iv_drip/examine(mob/user)
	..(user)
	if (!(user in view(2)) && user!=src.loc) return

	to_chat(user, "The IV drip is [mode ? "injecting" : "taking blood"].")
	to_chat(user, "<span class='notice'>The transfer rate is set to [src.transfer_amount] u/sec</span>")

	if(beaker)
		if(beaker.reagents && beaker.reagents.reagent_list.len)
			to_chat(usr, "<span class='notice'>Attached is \a [beaker] with [beaker.reagents.total_volume] units of liquid.</span>")
		else
			to_chat(usr, "<span class='notice'>Attached is an empty [beaker].</span>")
	else
		to_chat(usr, "<span class='notice'>No chemicals are attached.</span>")

	to_chat(usr, "<span class='notice'>[attached ? attached : "No one"] is attached.</span>")

// Let's doctors set the rate of transfer. Useful if you want to set the rate at the rate of metabolisation.
// No longer have to take someone to dialysis because they have leftover sleeptox after surgery.
/obj/machinery/iv_drip/verb/transfer_rate()
	set category = "Object"
	set name = "Set Transfer Rate"
	set src in view(1)

	if (!ishuman(usr) && !issilicon(usr))
		return
	if (usr.stat || usr.restrained() || !Adjacent(usr))
		return
	set_rate:
		var/amount = input("Set transfer rate as u/sec (between 4 and 0.001)") as num
		if ((0.001 > amount || amount > 4) && amount != 0)
			to_chat(usr, "<span class='warning'>Entered value must be between 0.001 and 4.</span>")
			goto set_rate
		if (transfer_amount == 0)
			transfer_amount = REM
			return
		transfer_amount = amount
		to_chat(usr, "<span class='notice'>Transfer rate set to [src.transfer_amount] u/sec</span>")

/obj/machinery/iv_drip/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(height && istype(mover) && mover.checkpass(PASSTABLE)) //allow bullets, beams, thrown objects, rats, drones, and the like through.
		return 1
	return ..()
