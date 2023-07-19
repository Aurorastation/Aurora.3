/*
Plates that can hold your cooking stuff
*/
//Click with food to put on plate
//Click with cutlery to take some
//Click in hand to remove food

/obj/item/reagent_containers/bowl
	name = "bowl"
	desc = "A small bowl for serving liquid meals in."
	desc_info = "Click with food to put food on.<br>\
	- Click with cutlery to eat some.<br>\
	- Click it with the active hand to remove food."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "bowl"
	fragile = 3
	shatter_material = DEFAULT_TABLE_MATERIAL // Slight typecasting abuse here, gets converted to a material in Initialize().
	can_be_placed_into = list()
	flags = OPENCONTAINER
	var/grease = FALSE

/obj/item/reagent_containers/bowl/examine(mob/user, distance)
	. = ..()
	if(grease)
		to_chat(user, SPAN_WARNING("\The [name] looks a little unclean."))

/obj/item/reagent_containers/bowl/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/material/kitchen/utensil))
		var/obj/item/material/kitchen/utensil/U = W
		if(istype(W,/obj/item/material/kitchen/utensil/fork))
			to_chat(user, SPAN_NOTICE("You uselessly pass \the [U] through \the [src]'s contents."))
			playsound(user.loc, /singleton/sound_category/generic_pour_sound, 50, 1)
			return
		else
			if(U.scoop_food)
				if(!U.reagents)
					U.create_reagents(5)

				if(U.reagents.total_volume > 0)
					to_chat(user, SPAN_WARNING("You already have liquid on \the [U]."))
					return

				user.visible_message(
					"\The [user] scoops up some of \the [src]'s contents with \the [U]!",
					SPAN_NOTICE("You scoop up some of \the [src]'s contents with \the [U]!")
				)

				U.cut_overlays()
				U.loaded = src.name
				var/image/I = new(U.icon, "loadedfood")
				I.color = reagents.get_color()
				U.add_overlay(I)
				reagents.trans_to_obj(U, min(reagents.total_volume,U.transfer_amt))
				U.is_liquid = TRUE
				return

/obj/item/reagent_containers/bowl/on_reagent_change()
	if(!reagents.total_volume && !grease)
		grease = TRUE
	update_icon()
	return ..()

/obj/item/reagent_containers/bowl/attack(mob/living/M, mob/living/user, target_zone)
	if(grease && !reagents.total_volume && (M == user))
		user.visible_message(
			SPAN_NOTICE("[user] starts to lick \the [src] clean."),
			SPAN_NOTICE("You start to lick \the [src] clean.")
		)
		if(do_after(user, 5))
			grease = FALSE
			user.visible_message(
				SPAN_NOTICE("[user] licks everything off \the [src]."),
				SPAN_NOTICE("You lick everything off \the [src].")
			)
	else
		return ..()
	update_icon()
	return

/obj/item/reagent_containers/bowl/on_rag_wipe(obj/item/reagent_containers/glass/rag/R)
	. = ..()
	if(grease)
		grease = FALSE
		update_icon()
	return

/obj/item/reagent_containers/bowl/update_icon()
	cut_overlays()
	if(grease)
		icon_state = "[initial(icon_state)]_mess"
	else
		icon_state = initial(icon_state)
	var/list/O = list()
	if(reagents.total_volume)
		var/image/I = image(icon=icon, icon_state="[icon_state]_over")
		I.color = reagents.get_color()
		LAZYADD(O, I)
	set_overlays(O)
	return ..()

/obj/item/reagent_containers/bowl/plate
	name = "plate"
	desc = "A plate for dishing up the finest of cuisine."
	flags = null
	icon_state = "plate"
	var/obj/item/holding

/obj/item/reagent_containers/bowl/plate/Destroy()
	if(holding)
		holding = null
		qdel(holding)
	return ..()

/obj/item/reagent_containers/bowl/plate/examine(mob/user, distance)
	. = ..()
	if(holding)
		to_chat(user, "It looks like there is \a [SPAN_INFO(holding.name)] on \the [src].")
		to_chat(user, SPAN_INFO(" - [holding.desc]"))

/obj/item/reagent_containers/bowl/plate/attackby(obj/item/I, mob/user)
	if((istype(I, /obj/item/reagent_containers/food/snacks) || istype(I, /obj/item/trash)) && !holding)
		user.unEquip(I)
		I.forceMove(src)
		holding = I
		to_chat(user, SPAN_NOTICE("You place \the [holding.name] on \the [src]."))
		update_icon()
		return
	if(istype(I, /obj/item/reagent_containers/food/snacks) || istype(I, /obj/item/trash))
		to_chat(user, SPAN_WARNING("\The [src] already has something on it!"))
		return
	if(istype(I, /obj/item/material/kitchen/utensil) && istype(holding, /obj/item/reagent_containers/food/snacks))
		var/obj/item/temp_hold = holding.attackby(I, user)
		if(temp_hold != holding)
			user.unEquip(temp_hold)
			temp_hold.forceMove(src)
			holding = temp_hold
			if(!grease)
				grease = TRUE
		update_icon()
		return
	if(istype(I, /obj/item/material/kitchen/utensil) && istype(holding, /obj/item/trash))
		to_chat(user, SPAN_WARNING("You're not sure you should try to eat \the [holding.name]."))
	if(istype(I, /obj/item/material/kitchen/utensil))
		to_chat(user, SPAN_WARNING("There isn't any food on \the [name]."))
		update_icon()
		return

/obj/item/reagent_containers/bowl/plate/attack_self(mob/user)
    if(!user.get_inactive_hand())
        var/obj/item/reagent_containers/food/snacks/F = holding
        user.put_in_hands(F)
        holding = null
        update_icon()
        to_chat(user, SPAN_NOTICE("You take \the [F.name] from \the [name]."))
        return

/obj/item/reagent_containers/bowl/plate/attack(mob/living/M, mob/living/user, target_zone)
	if(istype(holding, /obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/S = holding
		S.standard_feed_mob(user, M)
	else if(grease && !holding && (M == user))
		user.visible_message(SPAN_NOTICE("[user] starts to lick \the [src] clean."), SPAN_NOTICE("You start to lick \the [src] clean."))
		if(do_after(user, 5))
			grease = FALSE
			user.visible_message(SPAN_NOTICE("[user] licks everything off \the [src]."), SPAN_NOTICE("You lick everything off \the [src]."))
	update_icon()
	return

/obj/item/reagent_containers/bowl/plate/update_icon()
	cut_overlays()
	var/list/O = list()
	if(grease)
		icon_state = "[initial(icon_state)]_mess"
	else
		icon_state = initial(icon_state)
	if(holding)
		holding.update_icon() // Just to be safe.
		LAZYADD(O, image(icon=holding.icon, icon_state=holding.icon_state))
	set_overlays(O)
