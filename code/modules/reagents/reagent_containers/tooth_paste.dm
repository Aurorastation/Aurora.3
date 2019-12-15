/obj/item/reagent_containers/toothpaste
	name = "tube of toothpaste"
	desc = "A simple tube full of toothpaste."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "toothpaste"
	flags = OPENCONTAINER
	possible_transfer_amounts = null
	amount_per_transfer_from_this = 5
	volume = 20

/obj/item/reagent_containers/toothpaste/Initialize()
	. = ..()
	reagents.add_reagent("toothpaste", 20)

/obj/item/reagent_containers/toothpaste/on_reagent_change()
	update_icon()

/obj/item/reagent_containers/toothpaste/update_icon()
	var/percent = round((reagents.total_volume / volume) * 100)
	switch(percent)
		if(0 to 9)			icon_state = "toothpaste_empty"
		if(10 to 50) 		icon_state = "toothpaste_half"
		if(51 to INFINITY)	icon_state = "toothpaste"

/obj/item/reagent_containers/toothpaste/attack_self(mob/user as mob)
	return

/obj/item/reagent_containers/toothbrush
	name = "toothbrush"
	desc = "An essential tool in dental hygiene."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "toothbrush_b"
	flags = OPENCONTAINER
	possible_transfer_amounts = null
	amount_per_transfer_from_this = 5
	volume = 5

/obj/item/reagent_containers/toothbrush/on_reagent_change()
	update_icon()

/obj/item/reagent_containers/toothbrush/update_icon()
	cut_overlays()

	if(reagents.has_reagent("toothpaste"))
		add_overlay("toothpaste_overlay")

/obj/item/reagent_containers/toothbrush/attack_self(mob/user as mob)
	if(!reagents.total_volume)
		to_chat(user, "<span class='warning'>The [initial(name)] is dry!</span>")
	else
		playsound(loc, 'sound/effects/toothbrush.ogg', 15, 1)
		if(do_after(user, 30))
			user.visible_message(
			"<span class='notice'>\The [user] brushes [user.get_pronoun(1)] teeth with \the [src]</span>",
			"<span class='notice'>You brush your teeth with \the [src].</span>")
			reagents.trans_to_mob(user, amount_per_transfer_from_this, CHEM_BREATHE)
			update_icon()
	return

/obj/item/reagent_containers/toothbrush/feed_sound(var/mob/user)
	return

/obj/item/reagent_containers/toothbrush/proc/remove_contents(mob/user, atom/trans_dest = null)
	if(!trans_dest && !user.loc)
		return

/obj/item/reagent_containers/toothbrush/attack(atom/target as obj|turf|area, mob/user as mob , flag)
	if(isliving(target))
		var/mob/living/M = target
		if(ishuman(M))
			if(!reagents.total_volume)
				to_chat(user, "<span class='warning'>The [initial(name)] is dry!</span>")
			else if(reagents.total_volume)
				if(user.zone_sel.selecting == "mouth" && !(M.wear_mask && M.wear_mask.item_flags & AIRTIGHT))
					user.do_attack_animation(src)
					user.visible_message("<span class='warning'>[user] is trying to brush \the [target]'s teeth \the [src]!</span>")
					playsound(loc, 'sound/effects/toothbrush.ogg', 15, 1)
					if(do_after(user, 30))
						user.visible_message("<span class='warning'>[user] has brushed \the [target]'s teeth with \the [src]!</span>")

						reagents.trans_to_mob(target, amount_per_transfer_from_this, CHEM_BREATHE)
						update_icon()
				else
					wipe_down(target, user)
			return

	return ..()

/obj/item/reagent_containers/toothbrush/afterattack(atom/A as obj|turf|area, mob/user as mob, proximity)
	if(!proximity)
		return

	if(istype(A, /obj/structure/reagent_dispensers) || istype(A, /obj/structure/mopbucket) || istype(A, /obj/item/reagent_containers/glass))
		if(!reagents.get_free_space())
			return

		if(A.reagents && A.reagents.trans_to_obj(src, reagents.maximum_volume))
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
			user.visible_message("<span class='notice'>\The [user] soaks [src] using [A].</span>", "<span class='notice'>You soak [src] using [A].</span>")
			update_icon()
		return

	if(istype(A) && (src in user))
		if(A.is_open_container() && !(A in user))
			remove_contents(user, A)
		else if(!ismob(A)) //mobs are handled in attack()
			wipe_down(A, user)
		return

/obj/item/reagent_containers/toothbrush/proc/wipe_down(atom/A, mob/user)
	if(!reagents.total_volume)
		to_chat(user, "<span class='warning'>The [initial(name)] is dry!</span>")
	else
		user.visible_message("\The [user] starts to brush down [A] with [src]!")
		playsound(loc, 'sound/effects/mop.ogg', 25, 1)
		update_icon()
		if(do_after(user, 120))
			user.visible_message("\The [user] finishes brushing off \the [A]!")
			reagents.splash(A, 5)
			A.clean_blood()

/obj/item/reagent_containers/toothbrush/green
	icon_state = "toothbrush_g"

/obj/item/reagent_containers/toothbrush/red
	icon_state = "toothbrush_r"