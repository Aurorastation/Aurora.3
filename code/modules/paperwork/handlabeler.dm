/atom/var/name_unlabel = ""

// Yes, this is totally worth a new variable and a proc!
/atom/proc/remove_label()
	set name = "Remove Label"
	set category = "Object"
	set src in view(1)

	if (!usr.IsAdvancedToolUser() || usr.incapacitated())
		to_chat(usr, SPAN_NOTICE("You lack the dexerity to do this!"))
		return FALSE

	if (!name_unlabel)
		to_chat(usr, SPAN_NOTICE("You look again, unable to find the label! Perhaps your eyes need checking?"))
		src.verbs -= .proc/remove_label
		return FALSE

	var/mob/living/carbon/human/H = usr

	name = name_unlabel
	name_unlabel = ""
	src.verbs -= .proc/remove_label

	H.visible_message(SPAN_NOTICE("\The [H] removes the label from \the [src]."),
		SPAN_NOTICE("You remove the label from \the [src]."))

	return TRUE

/obj/item/device/hand_labeler
	name = "hand labeler"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "labeler0"
	item_state = "labeler0"
	w_class = ITEMSIZE_SMALL
	var/label = null
	var/labels_left = 30
	var/mode = 0	//off or on.
	matter = list(DEFAULT_WALL_MATERIAL = 120, MATERIAL_GLASS = 80)

/obj/item/device/hand_labeler/attack()
	return

/obj/item/device/hand_labeler/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity)
		return
	if(!mode)	//if it's off, give up.
		return
	if(A == loc)	// if placing the labeller into something (e.g. backpack)
		return		// don't set a label
	if(loc != user)
		return

	if(!labels_left)
		to_chat(user, SPAN_NOTICE("No labels left."))
		return
	if(!label || !length(label))
		to_chat(user, SPAN_NOTICE("No text set."))
		return
	if(length(A.name) + length(label) > 64)
		to_chat(user, SPAN_NOTICE("Label too big."))
		return
	if(ishuman(A))
		to_chat(user, SPAN_NOTICE("The label refuses to stick to [A.name]."))
		return
	if(issilicon(A))
		to_chat(user, SPAN_NOTICE("The label refuses to stick to [A.name]."))
		return
	if(isobserver(A))
		to_chat(user, SPAN_NOTICE("[src] passes through [A.name]."))
		return
	if(istype(A, /obj/item/reagent_containers/glass))
		to_chat(user, SPAN_NOTICE("The label can't stick to the [A.name]. (Try using a pen!)"))
		return
	if(istype(A, /obj/machinery/portable_atmospherics/hydroponics))
		var/obj/machinery/portable_atmospherics/hydroponics/tray = A
		if(!tray.mechanical)
			to_chat(user, SPAN_NOTICE("How are you going to label that?"))
			return
		tray.labelled = label
		spawn(1)
			tray.update_icon()

	user.visible_message("<b>[user]</b> labels [A] as <i>[label]</i>.", \
						 SPAN_NOTICE("You label [A] as <i>[label]</i>."))

	// Prevent label stacking from making name unrecoverable.
	if (!A.name_unlabel)
		A.name_unlabel = A.name
		A.verbs += /atom/proc/remove_label

	A.name = "[A.name] ([label])"

/obj/item/device/hand_labeler/attack_self(mob/user as mob)
	mode = !mode
	icon_state = "labeler[mode]"
	item_state = icon_state
	if(mode)
		to_chat(user, SPAN_NOTICE("You turn on \the [src]."))
		//Now let them chose the text.
		var/str = sanitizeSafe(input(user,"Label text?","Set label",""), MAX_NAME_LEN)
		if(!str || !length(str))
			to_chat(user, SPAN_NOTICE("Invalid text."))
			return
		label = str
		to_chat(user, SPAN_NOTICE("You set the text to '[str]'."))
	else
		to_chat(user, SPAN_NOTICE("You turn off \the [src]."))
