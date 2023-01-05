/obj/item/stack/material/animalhide
	name = "hide"
	desc = "The by-product of some animal farming."
	singular_name = "hide piece"
	icon_state = "sheet-hide"
	default_type = "hide"
	icon_has_variants = TRUE
	drop_sound = 'sound/items/drop/cloth.ogg'
	pickup_sound = 'sound/items/pickup/cloth.ogg'
	default_type = MATERIAL_HIDE
	var/bare = FALSE //is this hair devoid of fur, hair, scales, carapace? Prevents re-stripping. Can also apply it to a hide type if we don't want to tan, like, xeno hide.
	var/hide_type = "hair" //type of skin this animal has; scales for lizard, carapace for xeno.

/obj/item/stack/material/animalhide/human
	name = "human skin"
	desc = "The by-product of human farming."
	singular_name = "human skin piece"
	default_type = "human hide"

/obj/item/stack/material/animalhide/corgi
	name = "corgi hide"
	desc = "The by-product of corgi farming."
	singular_name = "corgi hide piece"
	icon_state = "sheet-corgi"
	default_type = "corgi hide"
	icon_has_variants = FALSE

/obj/item/stack/material/animalhide/cat
	name = "cat hide"
	desc = "The by-product of cat farming."
	icon_state = "sheet-cat"
	singular_name = "cat hide piece"
	default_type = "cat hide"
	icon_has_variants = FALSE

/obj/item/stack/material/animalhide/monkey
	name = "monkey hide"
	desc = "The by-product of monkey farming."
	singular_name = "monkey hide piece"
	icon_state = "sheet-monkey"
	default_type = "monkey hide"
	icon_has_variants = FALSE

/obj/item/stack/material/animalhide/lizard
	name = "lizard skin"
	desc = "Sssssss..."
	singular_name = "lizard skin piece"
	icon_state = "sheet-lizard"
	default_type = "lizard hide"
	icon_has_variants = FALSE
	hide_type = "scales"

/obj/item/stack/material/animalhide/barehide
	name = "bare hide"
	desc = "A hide without fur or scales. Can be tanned into leather."
	desc_info = "You can put this into a washing machine to make wet leather, which is the first step in making it into leather sheets."
	singular_name = "bare hide piece"
	icon_state = "sheet-hairlesshide"
	default_type = "bare hide"
	bare = TRUE

/obj/item/stack/material/animalhide/wetleather
	name = "wet leather"
	desc = "This leather has been cleaned but still needs to be dried."
	desc_info = "This can be dried into high-quality fine leather by exposing it to a fire of a sufficient temperature, or manually with a welding tool. You don't need eye protection for the welding tool."
	singular_name = "wet leather piece"
	icon_state = "sheet-wetleather"
	default_type = "wet leather"
	icon_has_variants = TRUE
	bare = TRUE
	var/wetness = 30 //Reduced when exposed to high temperautres or manually dried with a welding tool.
	var/drying_threshold_temperature = 500 //Kelvin to start drying from exposed fire.
	var/being_dried = FALSE //If we're manually drying this.

//Wet leather can't be used to make things. Too soggy.
/obj/item/stack/material/animalhide/wetleather/list_recipes(mob/user, recipes_sublist, var/datum/stack_recipe/sublist)
	to_chat(user, SPAN_WARNING("\The [src] isn't suitable for crafting!"))
	return


//Animal Hide to leather steps
//Step one - dehairing.
/obj/item/stack/material/animalhide/attackby(obj/item/W, mob/user)
	if(is_sharp(W) && !W.noslice && !W.iswirecutter()) //Can we cut and slice with the item? And does the hide still have something to remove? Say no to wirecutters since it's more about bladed items.
		if(bare)
			to_chat(user, SPAN_WARNING("There's nothing left to remove from \the [src]!"))
			return
		//visible message on mobs is defined as visible_message(var/message, var/self_message, var/blind_message)
		user.visible_message(SPAN_NOTICE("\The [user] starts slicing the [hide_type] from \the [src]."),
				SPAN_NOTICE("You start slicing the [hide_type] from \the [src]"),
				SPAN_NOTICE("You hear the sound of a knife scraping against flesh."))
		if(do_after(user,50, act_target = src))
			if(amount <= 0) //Ensures we don't get multiple products from queuing clicks.
				return
			use(1)
			user.visible_message(SPAN_NOTICE("[user] removes \the [hide_type] from \the [singular_name]."),
								SPAN_NOTICE("You remove \the [hide_type] from \the [singular_name]!"))
			playsound(get_turf(src), drop_sound, 50, 1)

			//Try locating an exisitng stack on the tile and add to there if possible
			if(locate(/obj/item/stack/material/animalhide/barehide) in get_turf(user))
				for(var/obj/item/stack/material/animalhide/barehide/BH in get_turf(user))
					if(BH.amount < BH.max_amount)
						BH.add(1)
						to_chat(user, SPAN_NOTICE("You add the newly-stripped hide to the stack. It now contains [BH.amount] hides."))
						break
			//if there isn't one, just make a new hide.
			else
				new /obj/item/stack/material/animalhide/barehide(get_turf(user))
	else
		..()


//Step two - washing..... it's actually in washing machine code.

//Step three - drying
/obj/item/stack/material/animalhide/wetleather/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	..()
	if(exposed_temperature >= drying_threshold_temperature)
		wetness--
		if(wetness <= 0)
			make_leather()

/obj/item/stack/material/animalhide/wetleather/attackby(obj/item/I, mob/user)
	if(I.iswelder())
		var/obj/item/weldingtool/WT = I
		if(WT.isOn())
			if(being_dried)
				to_chat(user, SPAN_WARNING("\The [src] are already being dried"))
				return
			user.visible_message(SPAN_NOTICE("\The [user] starts drying \the [src] with \the [WT]."), SPAN_NOTICE("You start drying the wet leather with \the [WT]..."))
			being_dried = TRUE
			while(do_after(user, 20, act_target = src) && wetness > 0)
				if(!WT.use(1) || !WT.isOn())
					break
				if(prob(5))
					var/msg = pick("You run the tool over \the [src]...", "The leather is drying nicely...", "You spread the heat out evenly...", "You continue to dry out \the [src].")
					to_chat(user, SPAN_NOTICE(msg))
				wetness = max(0, wetness - rand(3, 5)) //6 to 10 passes
				if(wetness <= 0)
					to_chat(user, SPAN_NOTICE("You dry \the [src] completely, making a piece of leather!"))
					make_leather()
				if(!amount || QDELETED(src)) //Safety
					break
			being_dried = FALSE

		else
			to_chat(user, SPAN_NOTICE("\The [WT] dries better when it's lit."))
			return
	else
		..()

//This will use one piece of the stack, create a piece of leather, then reset the wetness level to simulate drying the next piece of the stack.
/obj/item/stack/material/animalhide/wetleather/proc/make_leather()
	//see if there's a stack we can add to
	if(locate(/obj/item/stack/material/leather/fine) in get_turf(src))
		for(var/obj/item/stack/material/leather/fine/L in get_turf(src))
			if(L.amount < L.max_amount)
				L.add(1)
				use(1)
				wetness = initial(wetness)
				break
	//If it gets to here it means it did not find a suitable stack on the tile.
	else
		new /obj/item/stack/material/leather/fine(get_turf(src))
		use(1)
		wetness = initial(wetness)
