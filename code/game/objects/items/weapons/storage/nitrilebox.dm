/obj/item/nitrilebox
	name = "nitrile gloves box"
	icon = 'icons/obj/storage.dmi'
	icon_state = "nitrilebox"
	item_state = "sheet-metal"
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'
	throwforce = 1
	w_class = 5
	throw_speed = 3
	throw_range = 7
	layer = OBJ_LAYER - 0.1
	var/amount = 50					//How much paper is in the bin.  Gloves, actually, but this code is copied from the paper bin code.

/obj/item/nitrilebox/MouseDrop(mob/user as mob)
	if((user == usr && (!( usr.restrained() ) && (!( usr.stat ) && (usr.contents.Find(src) || in_range(src, usr))))))
		if(!istype(usr, /mob/living/carbon/slime) && !istype(usr, /mob/living/simple_animal))
			if( !usr.get_active_hand() )		//if active hand is empty
				var/mob/living/carbon/human/H = user
				var/obj/item/organ/external/temp = H.organs_by_name[BP_R_HAND]

				if (H.hand)
					temp = H.organs_by_name[BP_L_HAND]
				if(temp && !temp.is_usable())
					to_chat(user, "<span class='notice'>You try to move your [temp.name], but cannot!</span>")
					return

				to_chat(user, "<span class='notice'>You pick up the [src].</span>")
				user.put_in_hands(src)

	return

/obj/item/nitrilebox/attack_hand(mob/user as mob)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/temp = H.organs_by_name[BP_R_HAND]
		if (H.hand)
			temp = H.organs_by_name[BP_L_HAND]
		if(temp && !temp.is_usable())
			to_chat(user, "<span class='notice'>You try to move your [temp.name], but cannot!</span>")
			return
	var/response = ""
	if(amount > 0)
		response = alert(user, "Do you take a pair of gloves?", "Take gloves?", "Yes", "No")
		if (response != "Yes")
			add_fingerprint(user)
			return
		amount--
		var/obj/item/clothing/gloves/latex/nitrile/P
		if(response == "Yes")
			P = new /obj/item/clothing/gloves/latex/nitrile



		P.forceMove(user.loc)
		user.put_in_hands(P)
		to_chat(user, "<span class='notice'>You take [P] out of the [src].</span>")
	else
		to_chat(user, "<span class='notice'>[src] is empty!</span>")

	add_fingerprint(user)
	return


/obj/item/nitrilebox/attackby(obj/item/O as obj, mob/user as mob)
	if(istype(O, /obj/item/clothing/gloves/latex/nitrile))
		to_chat(user, "<span class='warning'>The box is designed to not allow gloves to be put back in.  Besides, it would be unsanitary.</span>")


/obj/item/nitrilebox/examine(mob/user)
	if(get_dist(src, user) <= 1)
		if(amount)
			to_chat(user, "<span class='notice'>There " + (amount > 1 ? "are [amount] pairs of gloves" : "is one pair of gloves") + " in the box.</span>")
		else
			to_chat(user, "<span class='notice'>There are no gloves in the box.  Time to throw it away.</span>")
	return

