/*
Plates that can hold your cooking stuff
*/
//Click with food to put on plate
//Click with cutlery to take some
//Click in hand to remove food

/obj/item/reagent_containers/bowl
	name = "bowl"
	desc = "A small bowl for serving liquid meals in."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "bowl"
	fragile = 3
	shatter_material = DEFAULT_TABLE_MATERIAL // Slight typecasting abuse here, gets converted to a material in Initialize().
	can_be_placed_into = list()
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	var/grease = FALSE

/obj/item/reagent_containers/bowl/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Click with food to put food into it."
	. += "If it has food on it, click with cutlery to scoop some food up."
	. += "If it has food on it, click it with the active hand to remove the food."

/obj/item/reagent_containers/bowl/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(grease)
		. += SPAN_WARNING("\The [name] looks a little unclean.")

/obj/item/reagent_containers/bowl/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/material/kitchen/utensil))
		var/obj/item/material/kitchen/utensil/U = attacking_item
		if(istype(attacking_item,/obj/item/material/kitchen/utensil/fork))
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

				U.ClearOverlays()
				U.loaded = src.name
				var/image/I = new(U.icon, "loadedfood")
				I.color = reagents.get_color()
				U.AddOverlays(I)
				reagents.trans_to_obj(U, min(reagents.total_volume,U.transfer_amt))
				U.is_liquid = TRUE
				return

/obj/item/reagent_containers/bowl/on_reagent_change()
	if(!reagents.total_volume && !grease)
		grease = TRUE
	update_icon()
	return ..()

/obj/item/reagent_containers/bowl/attack(mob/living/target_mob, mob/living/user, target_zone)
	if(isipc(user))
		to_chat(user, SPAN_NOTICE("You don't have a mouth, so you can't lick \the [src] clean."))
		return
	if(grease && !reagents.total_volume && (target_mob == user))
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
	ClearOverlays()
	if(grease)
		icon_state = "[initial(icon_state)]_mess"
	else
		icon_state = initial(icon_state)
	var/list/O = list()
	if(reagents.total_volume)
		var/image/I = image(icon=icon, icon_state="[icon_state]_over")
		I.color = reagents.get_color()
		LAZYADD(O, I)
	SetOverlays(O)
	return ..()

/obj/item/reagent_containers/bowl/plate
	name = "plate"
	desc = "A plate for dishing up the finest of cuisine."
	atom_flags = 0
	icon_state = "plate"
	var/obj/item/holding

/obj/item/reagent_containers/bowl/plate/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(holding)
		. += "It looks like there is \a [SPAN_INFO(holding.name)] on \the [src]."
		. += SPAN_INFO(" - [holding.desc]")

/obj/item/reagent_containers/bowl/plate/Destroy()
	if(holding)
		holding = null
		qdel(holding)
	return ..()

/obj/item/reagent_containers/bowl/plate/attackby(obj/item/attacking_item, mob/user)
	if((istype(attacking_item, /obj/item/reagent_containers/food/snacks) || istype(attacking_item, /obj/item/trash)) && !holding)
		user.unEquip(attacking_item)
		attacking_item.forceMove(src)
		holding = attacking_item
		to_chat(user, SPAN_NOTICE("You place \the [holding.name] on \the [src]."))
		update_icon()
		return
	if(istype(attacking_item, /obj/item/reagent_containers/food/snacks) || istype(attacking_item, /obj/item/trash))
		to_chat(user, SPAN_WARNING("\The [src] already has something on it!"))
		return
	if(istype(attacking_item, /obj/item/material/kitchen/utensil) && istype(holding, /obj/item/reagent_containers/food/snacks))
		var/obj/item/temp_hold = holding.attackby(attacking_item, user)
		if(temp_hold != holding)
			user.unEquip(temp_hold)
			temp_hold.forceMove(src)
			holding = temp_hold
			if(!grease)
				grease = TRUE
		update_icon()
		return
	if(istype(attacking_item, /obj/item/material/kitchen/utensil) && istype(holding, /obj/item/trash))
		to_chat(user, SPAN_WARNING("You're not sure you should try to eat \the [holding.name]."))
	if(istype(attacking_item, /obj/item/material/kitchen/utensil))
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

/obj/item/reagent_containers/bowl/plate/attack(mob/living/target_mob, mob/living/user, target_zone)
	if(istype(holding, /obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/S = holding
		S.standard_feed_mob(user, target_mob)
	else if(grease && !holding && (target_mob == user))
		user.visible_message(SPAN_NOTICE("[user] starts to lick \the [src] clean."), SPAN_NOTICE("You start to lick \the [src] clean."))
		if(do_after(user, 5))
			grease = FALSE
			user.visible_message(SPAN_NOTICE("[user] licks everything off \the [src]."), SPAN_NOTICE("You lick everything off \the [src]."))
	update_icon()
	return

/obj/item/reagent_containers/bowl/plate/update_icon()
	ClearOverlays()
	var/list/O = list()
	if(grease)
		icon_state = "[initial(icon_state)]_mess"
	else
		icon_state = initial(icon_state)
	if(holding)
		holding.update_icon() // Just to be safe.
		LAZYADD(O, image(icon=holding.icon, icon_state=holding.icon_state))
	SetOverlays(O)

/obj/item/reagent_containers/bowl/zhukamir
	name = "\improper Zhukamir cauldron"
	desc = "A small ornamental cauldron used as an altar by the worshippers of Zhukamir, the Ma'ta'ke deity of agriculture and cooking."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "zhukamir"

/obj/item/reagent_containers/bowl/gravy_boat
	name = "gravy boat"
	desc = "Let's sail the seas of deliciousness!"
	icon_state = "gravy"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5, 10, 30)
	w_class = WEIGHT_CLASS_SMALL
	volume = 40
	force = 14
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'

/obj/item/reagent_containers/bowl/gravy_boat/afterattack(var/obj/target, var/mob/user, var/flag)
	if(!target.is_open_container() || !flag)
		return ..(target, user, flag)
	if(reagents.total_volume)
		if(!target.reagents || !REAGENTS_FREE_SPACE(target.reagents))
			to_chat(user, SPAN_NOTICE("\The [target] is full."))
			return TRUE
		var/trans = reagents.trans_to(target, amount_per_transfer_from_this) //sprinkling reagents on generic non-mobs
		user.visible_message(
			"[SPAN_BOLD("[user]")] pours onto \the [target] from \the [src].",
			SPAN_NOTICE("You transfer [trans] units of the solution.")
		)
		playsound(get_turf(user), /singleton/sound_category/generic_pour_sound, 10, TRUE)
	return TRUE

/obj/item/reagent_containers/bowl/gravy_boat/on_reagent_change()
	update_icon()

/obj/item/reagent_containers/bowl/gravy_boat/update_icon()
	ClearOverlays()
	if(!reagents.total_volume)
		return
	var/image/over = image(icon, "gravy_over")
	over.color = reagents.get_color()
	AddOverlays(over)
