/obj/item/paper_bin
	name = "paper bin"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper_bin1"
	item_state = "sheet-metal"
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'
	throwforce = 1
	w_class = WEIGHT_CLASS_HUGE
	throw_speed = 3
	throw_range = 7
	layer = BELOW_OBJ_LAYER
	var/amount = 30					//How much paper is in the bin.
	var/list/papers = new/list()	//List of papers put in the bin for reference.

/obj/item/paper_bin/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(is_adjacent)
		if(amount)
			. += SPAN_NOTICE("There " + (amount > 1 ? "are [amount] papers" : "is one paper") + " in the bin.")
		else
			. += SPAN_NOTICE("There are no papers in the bin.")

/obj/item/paper_bin/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	if((over == user && (!( user.restrained() ) && (!( user.stat ) && (user.contents.Find(src) || in_range(src, user))))))
		if(!istype(user, /mob/living/carbon/slime) && !istype(user, /mob/living/simple_animal))
			if( !user.get_active_hand() )		//if active hand is empty
				var/mob/living/carbon/human/H = over
				var/obj/item/organ/external/temp = H.organs_by_name[BP_R_HAND]

				if (H.hand)
					temp = H.organs_by_name[BP_L_HAND]
				if(temp && !temp.is_usable())
					to_chat(H, SPAN_NOTICE("You try to move your [temp.name], but cannot!"))
					return

				to_chat(H, SPAN_NOTICE("You pick up the [src]."))
				H.put_in_hands(src)
	return

/obj/item/paper_bin/attack_hand(mob/user as mob)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/temp = H.organs_by_name[BP_R_HAND]
		if (H.hand)
			temp = H.organs_by_name[BP_L_HAND]
		if(temp && !temp.is_usable())
			to_chat(user, SPAN_NOTICE("You try to move your [temp.name], but cannot!"))
			return
	var/response = ""
	if(!papers.len > 0)
		response = alert(user, "Do you take regular paper, or Carbon copy paper?", "Paper type request", "Regular", "Carbon-Copy", "Cancel")
		if (response != "Regular" && response != "Carbon-Copy")
			add_fingerprint(user)
			return
	if(amount >= 1)
		amount--
		if(amount==0)
			update_icon()

		var/obj/item/paper/P
		if(papers.len > 0)	//If there's any custom paper on the stack, use that instead of creating a new paper.
			P = papers[papers.len]
			papers.Remove(P)
		else
			if(response == "Regular")
				P = new /obj/item/paper
				if(Holiday == "April Fool's Day")
					if(prob(30))
						P.info = "<font face=\"[P.crayonfont]\" color=\"red\"><b>HONK HONK HONK HONK HONK HONK HONK<br>HOOOOOOOOOOOOOOOOOOOOOONK<br>APRIL FOOLS</b></font>"
						P.rigged = 1
						P.updateinfolinks()
			else if (response == "Carbon-Copy")
				P = new /obj/item/paper/carbon

		P.forceMove(user.loc)
		user.put_in_hands(P)
		to_chat(user, SPAN_NOTICE("You take [P] out of the [src]."))
	else
		to_chat(user, SPAN_NOTICE("[src] is empty!"))

	add_fingerprint(user)
	return

/obj/item/paper_bin/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/paper))
		var/obj/item/paper/i = attacking_item
		user.drop_from_inventory(i,src)
		to_chat(user, SPAN_NOTICE("You put [i] in [src]."))
		papers.Add(i)
		amount++

/obj/item/paper_bin/update_icon()
	if(amount < 1)
		icon_state = "paper_bin0"
	else
		icon_state = "paper_bin1"
