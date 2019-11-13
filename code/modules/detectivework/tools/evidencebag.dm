//CONTAINS: Evidence bags and fingerprint cards

/obj/item/evidencebag
	name = "evidence bag"
	desc = "An empty evidence bag."
	icon = 'icons/obj/storage.dmi'
	icon_state = "evidenceobj"
	item_state = ""
	w_class = 2
	var/obj/item/stored_item = null

/obj/item/evidencebag/MouseDrop(var/obj/item/I as obj)
	if (!ishuman(usr))
		return

	var/mob/living/carbon/human/user = usr

	if (!(user.l_hand == src || user.r_hand == src))
		return //bag must be in your hands to use

	if (isturf(I.loc))
		if (!user.Adjacent(I))
			return
	else
		//If it isn't on the floor. Do some checks to see if it's in our hands or a box. Otherwise give up.
		if(istype(I.loc,/obj/item/storage))	//in a container.
			var/sdepth = I.storage_depth(user)
			if (sdepth == -1 || sdepth > 1)
				return	//too deeply nested to access

			var/obj/item/storage/U = I.loc
			user.client.screen -= I
			U.contents.Remove(I)
		else if(user.l_hand == I)					//in a hand
			user.drop_l_hand()
		else if(user.r_hand == I)					//in a hand
			user.drop_r_hand()
		else
			return

	if(!istype(I) || I.anchored)
		return

	if(istype(I, /obj/item/evidencebag))
		to_chat(user, "<span class='notice'>You find putting an evidence bag in another evidence bag to be slightly absurd.</span>")
		return

	if(I.w_class > 3)
		to_chat(user, "<span class='notice'>[I] won't fit in [src].</span>")
		return

	if(contents.len)
		to_chat(user, "<span class='notice'>[src] already has something inside it.</span>")
		return

	user.visible_message("[user] puts [I] into [src]", "You put [I] inside [src].",\
	"You hear a rustle as someone puts something into a plastic bag.")

	icon_state = "evidence"

	var/mutable_appearance/MA = new(I)
	MA.pixel_x = 0
	MA.pixel_y = 0
	MA.layer = FLOAT_LAYER
	add_overlay(list(MA, "evidence"))

	desc = "An evidence bag containing [I]."
	I.forceMove(src)
	stored_item = I
	w_class = I.w_class
	return


/obj/item/evidencebag/attack_self(mob/user as mob)
	if(contents.len)
		var/obj/item/I = contents[1]
		user.visible_message("[user] takes [I] out of [src]", "You take [I] out of [src].",\
		"You hear someone rustle around in a plastic bag, and remove something.")
		cut_overlays()	//remove the overlays

		user.put_in_hands(I)
		stored_item = null

		w_class = initial(w_class)
		icon_state = "evidenceobj"
		desc = "An empty evidence bag."
	else
		to_chat(user, "[src] is empty.")
		icon_state = "evidenceobj"
	return

/obj/item/evidencebag/examine(mob/user)
	..(user)
	if (stored_item) user.examinate(stored_item)
