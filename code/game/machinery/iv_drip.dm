/obj/machinery/iv_drip
	name = "\improper IV drip"
	icon = 'icons/obj/iv_drip.dmi'
	anchored = 0
	density = 1
	var/mob/living/carbon/human/attached = null
	var/mode = 1 // 1 is injecting, 0 is taking blood.
	var/list/transfer_amount = list("Primary" = REM, "Secondary" = REM)
	var/obj/item/weapon/reagent_containers/primary = null // can be any size, is the first one attached
	var/obj/item/weapon/reagent_containers/secondary = null // must be less than or equal to 120 units in capacity

/obj/machinery/iv_drip/update_icon()
	if(src.attached)
		icon_state = "hooked"
	else
		icon_state = ""

	cut_overlays()

	if(primary)
		if(primary.reagents.total_volume)
			var/image/filling = image('icons/obj/iv_drip.dmi', src, "reagent")

			var/percent = round((primary.reagents.total_volume / primary.volume) * 100)
			switch(percent)
				if(0 to 9)		filling.icon_state = "reagent0"
				if(10 to 24) 	filling.icon_state = "reagent10"
				if(25 to 49)	filling.icon_state = "reagent25"
				if(50 to 74)	filling.icon_state = "reagent50"
				if(75 to 79)	filling.icon_state = "reagent75"
				if(80 to 90)	filling.icon_state = "reagent80"
				if(91 to INFINITY)	filling.icon_state = "reagent100"

			filling.icon += primary.reagents.get_color()
			add_overlay(filling)
	
	if(secondary)
		if(secondary.reagents.total_volume)
			var/image/filling = image('icons/obj/iv_drip.dmi', src, "reagentsecondary")

			var/percent = round((secondary.reagents.total_volume / secondary.volume) * 100)
			switch(percent)
				if(0 to 9)		filling.icon_state = "reagent0s"
				if(10 to 24) 	filling.icon_state = "reagent10s"
				if(25 to 49)	filling.icon_state = "reagent25s"
				if(50 to 74)	filling.icon_state = "reagent50s"
				if(75 to 79)	filling.icon_state = "reagent75s"
				if(80 to 90)	filling.icon_state = "reagent80s"
				if(91 to INFINITY)	filling.icon_state = "reagent100s"

			filling.icon += secondary.reagents.get_color()
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
	if (istype(W, /obj/item/weapon/reagent_containers/food))
		to_chat(user, "You can't put food on an IV drip.")
	if (istype(W, /obj/item/weapon/reagent_containers))
		var/obj/item/weapon/reagent_containers/R = W
		if(W.is_open_container())
			to_chat(user, "\The [W] must be closed to put it on an IV drip.")
		if(!isnull(primary))
			if(R.volume > 120)
				to_chat(user, span("warning", "\The [R] is too big for the secondary slot!"))
			user.drop_from_inventory(W,src)
			secondary = W
			to_chat(user, "You attach \the [W] to \the [src].")
			update_icon()
			return

		user.drop_from_inventory(W,src)
		primary = W
		to_chat(user, "You attach \the [W] to \the [src].")
		update_icon()
		return
	else
		return ..()


/obj/machinery/iv_drip/machinery_process()
	set background = 1

	if(attached)
		if(!(get_dist(src, attached) <= 1 && isturf(attached.loc)))
			var/obj/item/organ/external/affecting = attached:get_organ(pick(BP_R_ARM, BP_L_ARM))
			attached.visible_message(span("warning", "The needle is ripped out of [src.attached]'s [affecting.limb_name == BP_R_ARM ? "right arm" : "left arm"]."), span("danger", "The needle <B>painfully</B> rips out of your [affecting.limb_name == BP_R_ARM ? "right arm" : "left arm"]."))
			affecting.take_damage(brute = 5, sharp = 1)
			attached = null
			update_icon()
			return

	if(attached && primary) // should have primary if you have secondary but let's not take chances

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
			if(primary.reagents.total_volume > 0)
				primary.reagents.trans_to_mob(attached, primary_transfer_amount, CHEM_BLOOD)
				update_icon()
			if(istype(secondary) && secondary.reagents.total_volume > 0)
				secondary.reagents.trans_to_mob(attached, secondary_transfer_amount, CHEM_BLOOD)

		// Take blood
		else
			var/amount = primary.reagents.maximum_volume - primary.reagents.total_volume
			amount = min(amount, 4)
			// If the primary is full, ping
			if(amount == 0)
				if(prob(5)) visible_message("\The [src] pings.")
				return

			// If the human is losing too much blood, beep.
			if(T.get_blood_volume("blood") < BLOOD_VOLUME_SAFE) if(prob(5))
				visible_message(span("warning", "\The [src] beeps loudly."))

			var/datum/reagent/B = T.take_blood(primary,amount)

			if (B)
				primary.reagents.reagent_list |= B
				primary.reagents.update_total()
				primary.on_reagent_change()
				primary.reagents.handle_reactions()
				update_icon()

/obj/machinery/iv_drip/attack_hand(mob/user as mob)
	if (isAI(user))
		return
	if(secondary)
		secondary.forceMove(get_turf(src))
		secondary = null
		update_icon()
		return // remove one at a time
	if(primary)
		primary.forceMove(get_turf(src))
		primary = null
		update_icon()
	else
		return ..()


/obj/machinery/iv_drip/verb/toggle_mode()
	set category = "Object"
	set name = "Toggle Mode"
	set src in view(1)

	if(!istype(usr, /mob/living))
		to_chat(usr, span("warning", "You can't do that."))
		return

	if(usr.stat)
		return

	mode = !mode
	to_chat(usr, "The IV drip is now [mode ? "injecting" : "taking blood"].")

/obj/machinery/iv_drip/examine(mob/user)
	..(user)
	if (!(user in view(2)) && user!=src.loc) return

	to_chat(user, "The IV drip is [mode ? "injecting" : "taking blood"].")
	to_chat(user, span("notice", "The transfer rate is set to [src.transfer_amount] u/sec"))

	if(primary)
		if(primary.reagents && primary.reagents.reagent_list.len)
			to_chat(usr, "<span class='notice'>Attached is \a [primary] with [primary.reagents.total_volume] units of liquid.</span>")
		else
			to_chat(usr, span("notice", "Attached is an empty [primary]."))
	if(secondary)
		if(secondary.reagents && secondary.reagents.reagent_list.len)
			to_chat(usr, span("notice", "Attached is \a [secondary] with [secondary.reagents.total_volume] units of liquid."))
		else
			to_chat(usr, span("notice", "Attached is an empty [secondary]."))
	else
		to_chat(usr, span("notice", "No chemicals are attached."))

	to_chat(usr, span("notice", "[attached ? attached : "No one"] is attached."))

// Lets doctors set the rate of transfer.
/obj/machinery/iv_drip/verb/transfer_rate()
	set category = "Object"
	set name = "Set Transfer Rate"
	set src in view(1)

	if (use_check(usr))
		return
	var/container = input("Select which transfer rate you want to modify:") as null|anything in list("Primary", "Secondary")
	if(!container)
		return
	var/amount = min(input("Set transfer rate as units per second (between 4 and 0.001).", "[container] Transfer Rate") as null|num, 4)
	transfer_amount[container] = max(amount || REM, 0.001)
	to_chat(usr, span("notice", "[container] transfer rate set to [transfer_amount[container]] units per second."))

/obj/machinery/iv_drip/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(height && istype(mover) && mover.checkpass(PASSTABLE)) //allow bullets, beams, thrown objects, rats, drones, and the like through.
		return 1
	return ..()
