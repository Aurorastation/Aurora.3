// -----------------------------
//        Laundry Basket
// -----------------------------
// An item designed for hauling the belongings of a character.
// So this cannot be abused for other uses, we make it two-handed and inable to have its storage looked into.
	name = "laundry basket"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "laundry-empty"
	item_state = "laundry"
	desc = "The peak of thousands of years of laundry evolution."

	w_class = 5
	max_w_class = 4
	max_storage_space = 25 //20 for clothes + a bit of additional space for non-clothing items that were worn on body
	storage_slots = 14
	use_to_pickup = 1
	allow_quick_empty = 1
	allow_quick_gather = 1
	collection_mode = 1
	var/linked


	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/temp = H.get_organ("r_hand")
		if (user.hand)
			temp = H.get_organ("l_hand")
		if(!temp)
			user << "<span class='warning'>You need two hands to pick this up!</span>"
			return

	if(user.get_inactive_hand())
		user << "<span class='warning'>You need your other hand to be empty</span>"
		return
	return ..()

	var/turf/T = get_turf(user)
	user << "<span class='notice'>You dump the [src]'s contents onto \the [T].</span>"
	return ..()

	O.name = "[name] - second hand"
	O.desc = "Your second grip on the [name]."
	O.linked = src
	user.put_in_inactive_hand(O)
	linked = O
	return

	if(contents.len)
		icon_state = "laundry-full"
	else
		icon_state = "laundry-empty"
	return


	if(over_object == usr)
		return
	else
		return ..()

	qdel(linked)
	return ..()

	return



//Offhand
	icon_state = "offhand"
	name = "second hand"
	use_to_pickup = 0

	user.drop_from_inventory(linked)
	return

