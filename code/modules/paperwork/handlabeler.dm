/atom/var/name_unlabel = ""

// Yes, this is totally worth a new variable and a proc!
/atom/proc/remove_label()
	set name = "Remove Label"
	set category = "Object"
	set src in view(1)

	if (!usr.IsAdvancedToolUser() || usr.incapacitated())
		to_chat(usr, "<span class='notice'>You lack the dexerity to do this!</span>")
		return FALSE

	if (!name_unlabel)
		to_chat(usr, "<span class='notice'>You look again, unable to find the label! Perhaps your eyes need checking?</span>")
		src.verbs -= .proc/remove_label
		return FALSE

	var/mob/living/carbon/human/H = usr

	name = name_unlabel
	name_unlabel = ""
	src.verbs -= .proc/remove_label

	H.visible_message("<span class='notice'>\The [H] removes the label from \the [src].</span>",
		"<span class='notice'>You remove the label from \the [src].</span>")

	return TRUE

/obj/item/hand_labeler
	name = "hand labeler"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "labeler0"
	var/label = null
	var/labels_left = 30
	var/mode = 0	//off or on.
	matter = list(DEFAULT_WALL_MATERIAL = 120, MATERIAL_GLASS = 80)

/obj/item/hand_labeler/attack()
	return

/obj/item/hand_labeler/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity)
		return
	if(!mode)	//if it's off, give up.
		return
	if(A == loc)	// if placing the labeller into something (e.g. backpack)
		return		// don't set a label

	if(!labels_left)
		to_chat(user, "<span class='notice'>No labels left.</span>")
		return
	if(!label || !length(label))
		to_chat(user, "<span class='notice'>No text set.</span>")
		return
	if(length(A.name) + length(label) > 64)
		to_chat(user, "<span class='notice'>Label too big.</span>")
		return
	if(ishuman(A))
		to_chat(user, "<span class='notice'>The label refuses to stick to [A.name].</span>")
		return
	if(issilicon(A))
		to_chat(user, "<span class='notice'>The label refuses to stick to [A.name].</span>")
		return
	if(isobserver(A))
		to_chat(user, "<span class='notice'>[src] passes through [A.name].</span>")
		return
	if(istype(A, /obj/item/reagent_containers/glass))
		to_chat(user, "<span class='notice'>The label can't stick to the [A.name].  (Try using a pen)</span>")
		return
	if(istype(A, /obj/machinery/portable_atmospherics/hydroponics))
		var/obj/machinery/portable_atmospherics/hydroponics/tray = A
		if(!tray.mechanical)
			to_chat(user, "<span class='notice'>How are you going to label that?</span>")
			return
		tray.labelled = label
		spawn(1)
			tray.update_icon()

	user.visible_message("<span class='notice'>[user] labels [A] as [label].</span>", \
						 "<span class='notice'>You label [A] as [label].</span>")

	// Prevent label stacking from making name unrecoverable.
	if (!A.name_unlabel)
		A.name_unlabel = A.name
		A.verbs += /atom/proc/remove_label

	A.name = "[A.name] ([label])"

/obj/item/hand_labeler/attack_self(mob/user as mob)
	mode = !mode
	icon_state = "labeler[mode]"
	if(mode)
		to_chat(user, "<span class='notice'>You turn on \the [src].</span>")
		//Now let them chose the text.
		var/str = sanitizeSafe(input(user,"Label text?","Set label",""), MAX_NAME_LEN)
		if(!str || !length(str))
			to_chat(user, "<span class='notice'>Invalid text.</span>")
			return
		label = str
		to_chat(user, "<span class='notice'>You set the text to '[str]'.</span>")
	else
		to_chat(user, "<span class='notice'>You turn off \the [src].</span>")
