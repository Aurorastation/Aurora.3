/obj/item/nitrilebox
	name = "nitrile gloves box"
	desc = "Contains nitrile gloves."
	icon = 'icons/obj/storage.dmi'
	icon_state = "nitrilebox"
	item_state = "sheet-metal"
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'
	throwforce = 1
	w_class = ITEMSIZE_NORMAL
	throw_speed = 3
	throw_range = 7
	layer = OBJ_LAYER - 0.1
	var/amount = 50					//How much paper is in the bin.  Gloves, actually, but this code is copied from the paper bin code.

/obj/item/nitrilebox/MouseDrop(mob/user)
	if((user == usr && (!( usr.restrained() ) && (!( usr.stat ) && (usr.contents.Find(src) || in_range(src, usr))))))
		if(!istype(usr, /mob/living/carbon/slime) && !istype(usr, /mob/living/simple_animal))
			if( !usr.get_active_hand() )		//if active hand is empty
				var/mob/living/carbon/human/H = user
				var/obj/item/organ/external/temp = H.organs_by_name[BP_R_HAND]

				if (H.hand)
					temp = H.organs_by_name[BP_L_HAND]
				if(temp && !temp.is_usable())
					to_chat(user, SPAN_NOTICE("You try to move your [temp.name], but cannot!"))
					return

				to_chat(user, SPAN_NOTICE("You pick up [src]."))
				user.put_in_hands(src)

	return

/obj/item/nitrilebox/attack_hand(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/temp = H.organs_by_name[BP_R_HAND]
		if (H.hand)
			temp = H.organs_by_name[BP_L_HAND]
		if(temp && !temp.is_usable())
			to_chat(user, SPAN_NOTICE("You try to move your [temp.name], but cannot!"))
			return
	if(amount > 0)
		var/list/glove_types = list(
			"Standard Gloves" = /obj/item/clothing/gloves/latex/nitrile,
			"Unathi Gloves" = /obj/item/clothing/gloves/latex/nitrile/unathi,
			"Tajara Gloves" = /obj/item/clothing/gloves/latex/nitrile/tajara,
			"Vaurca Gloves" = /obj/item/clothing/gloves/latex/nitrile/vaurca
		)
		var/chosen_type = input(user, "Which pair of gloves would you like?", capitalize_first_letters(name)) as null|anything in glove_types
		if(!chosen_type)
			add_fingerprint(user)
			return
		amount--
		var/chosen_path = glove_types[chosen_type]
		var/obj/item/clothing/gloves/latex/nitrile/P = new chosen_path(get_turf(src))
		user.put_in_hands(P)
		to_chat(user, SPAN_NOTICE("You take \the [P] out of \the [src]."))
	else
		to_chat(user, SPAN_NOTICE("[src] is empty!"))

	add_fingerprint(user)
	return


/obj/item/nitrilebox/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/clothing/gloves/latex/nitrile))
		to_chat(user, SPAN_WARNING("The box is designed to not allow gloves to be put back in.  Besides, it would be unsanitary."))


/obj/item/nitrilebox/examine(mob/user)
	if(get_dist(src, user) <= 1)
		if(amount)
			to_chat(user, SPAN_NOTICE("There " + (amount > 1 ? "are [amount] pairs of gloves" : "is one pair of gloves") + " in the box."))
		else
			to_chat(user, SPAN_NOTICE("There are no gloves in the box.  Time to throw it away."))
	return

