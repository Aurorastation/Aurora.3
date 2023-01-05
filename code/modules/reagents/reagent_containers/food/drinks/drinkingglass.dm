

/obj/item/reagent_containers/food/drinks/drinkingglass
	name = "glass"
	desc = "Your standard drinking glass."
	desc_info = "To toast with someone, aim for the right or left hand and click them on help intent with the glass in hand. They must be holding a glass in the targeted hand."
	icon_state = "glass_empty"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_food.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_food.dmi',
		)
	item_state = "glass_empty"
	amount_per_transfer_from_this = 5
	volume = 30
	unacidable = TRUE //glass
	center_of_mass = list("x"=16, "y"=10)
	drop_sound = 'sound/items/drop/drinkglass.ogg'
	pickup_sound = 'sound/items/pickup/drinkglass.ogg'
	matter = list(MATERIAL_GLASS = 300)
	drink_flags = NO_EMPTY_ICON	//This should not be removed unless a total overhaul of drink reagent sprites is done.
	fragile = 2

/obj/item/reagent_containers/food/drinks/drinkingglass/on_reagent_change()
	var/decl/reagent/R = reagents.get_primary_reagent_decl()
	if (LAZYLEN(reagents.reagent_volumes) && R)
		icon_state = R.glass_icon_state || "nothing"
		name = R.glass_name || "glass of something"
		desc = R.glass_desc || "You can't really tell what this is."
		center_of_mass = R.glass_center_of_mass || list("x"=16, "y"=10)
	else
		icon_state = "glass_empty"
		item_state = "glass_empty"
		name = "glass"
		desc = "Your standard drinking glass."
		center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/drinkingglass/afterattack(var/atom/target, var/mob/user, var/proximity, var/params)
	if(ishuman(target) && user.a_intent == I_HELP && (user.zone_sel.selecting == BP_L_HAND || user.zone_sel.selecting == BP_R_HAND))
		if(!user.Adjacent(target))
			return
		var/mob/living/carbon/human/H = target
		var/obj/item/reagent_containers/food/drinks/drinkingglass/glass = H.get_type_in_hands(/obj/item/reagent_containers/food/drinks/drinkingglass)
		if(!use_check(H))
			to_chat(user, SPAN_WARNING("[H] is in no condition to perform a toast!"))
			return
		else if(!glass)
			to_chat(user, SPAN_WARNING("[H] needs to be holding a glass to perform a toast."))
			return
		else
			user.visible_message("<b>[user]</b> holds \the [src] out for a toast with [H].")
			if(alert(H,"[user] wants to do a toast with you. Will you accept it?",,"Yes","No") == "No")
				H.visible_message("<b>[H]</b> pushes [user]'s hand away.")
				return
			if(!user.Adjacent(H))
				to_chat(user, SPAN_WARNING("You need to remain next to [H]!"))
				to_chat(H, SPAN_WARNING("You need to remain next to [user]!"))
				return
			user.visible_message("<b>[user]</b> clinks \the [src] with [H]'s [glass.name].")
			playsound(user.loc, pick('sound/items/glass_clink_1.ogg', 'sound/items/glass_clink_2.ogg', 'sound/items/glass_clink_3.ogg'), 50, 0, vary = FALSE)
			return
	..()

// for /obj/machinery/vending/sovietsoda
/obj/item/reagent_containers/food/drinks/drinkingglass/soda
	reagents_to_add = list(/decl/reagent/drink/sodawater = 50)

/obj/item/reagent_containers/food/drinks/drinkingglass/cola
	reagents_to_add = list(/decl/reagent/drink/space_cola = 50)
