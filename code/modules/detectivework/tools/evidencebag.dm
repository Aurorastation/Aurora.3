//CONTAINS: Evidence bags and fingerprint cards

/obj/item/evidencebag
	name = "evidence bag"
	desc = "An empty evidence bag."
	desc_info = "Click drag this onto an object to put it inside. Click it in-hand to remove an object from it."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "evidenceobj"
	item_state = ""
	w_class = ITEMSIZE_SMALL
	var/obj/item/stored_item = null
	var/label_text = ""

/obj/item/evidencebag/Initialize()
	. = ..()
	AddComponent(/datum/component/base_name, name)

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
		to_chat(user, "<span class='notice'>You find putting a plastic bag in another plastic bag to be slightly absurd and think better of it.</span>")
		return

	if(I.w_class > 3)
		to_chat(user, "<span class='notice'>[I] won't fit in [src].</span>")
		return

	if(contents.len)
		to_chat(user, "<span class='notice'>[src] already has something inside it.</span>")
		return

	user.visible_message("<b>[user]</b> puts \the [I] into \the [src].", SPAN_NOTICE("You put \the [I] inside \the [src]."),\
	"You hear a rustle as someone puts something into a plastic bag.")
	store_item(I)

/obj/item/evidencebag/proc/store_item(obj/item/I)
	icon_state = "evidence"
	var/mutable_appearance/MA = new(I)
	MA.pixel_x = 0
	MA.pixel_y = 0
	MA.layer = FLOAT_LAYER
	add_overlay(list(MA, "evidence"))

	desc = "A plastic bag containing [I]."
	I.forceMove(src)
	stored_item = I
	w_class = I.w_class


/obj/item/evidencebag/attack_self(mob/user as mob)
	if(contents.len)
		var/obj/item/I = contents[1]
		user.visible_message("<b>[user]</b> takes \the [I] out of \the [src].", SPAN_NOTICE("You take \the [I] out of \the [src]."),\
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

/obj/item/evidencebag/attackby(obj/item/W as obj, mob/user as mob)
	if(W.ispen() || istype(W, /obj/item/device/flashlight/pen))
		var/tmp_label = sanitizeSafe(input(user, "Enter a label for [name]", "Label", label_text), MAX_NAME_LEN)
		if(length(tmp_label) > MAX_NAME_LEN)
			to_chat(user, SPAN_NOTICE("The label can be at most [MAX_NAME_LEN] characters long."))
		else
			to_chat(user, "<span class='notice'>You set the label to \"[tmp_label]\".</span>")
			label_text = tmp_label
			update_name_label()
		return
	. = ..()

/obj/item/evidencebag/proc/update_name_label(var/base_name = initial(name))
	SEND_SIGNAL(src, COMSIG_BASENAME_SETNAME, args)
	if(label_text == "")
		name = base_name
	else
		name = "[base_name] ([label_text])"
