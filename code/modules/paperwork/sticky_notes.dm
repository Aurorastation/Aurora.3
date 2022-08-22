/obj/item/sticky_pad
	name = "stickynote pad"
	desc = "A pad, with lots of little sticky notes attached."
	colour = COLOR_YELLOW
	icon_state = "pad_full"
	item_state = "paper"
	w_class = ITEMSIZE_TINY

	var/papers = 50
	var/written_text
	var/written_by
	var/paper_type = /obj/item/paper/sticky

/obj/item/sticky_pad/on_update_icon()
	if(papers <= 15)
		icon_state = "pad_empty"
	else if(papers <=50)
		icon_state = "pad_used"
	else
		icon_state = "pad_full"
	if(written_text)
		icon_state = "[icon_state]_writing"

/obj/item/sticky_pad/attackby(var/obj/item/thing, var/mob/user)
	if(istype(thing, /obj/item/pen))
		if(writing_space <=0)
			to_chat(user, SPAN_WARNING("There is no room left on \the [src]."))
			return
		var/text = sanitizeSafe(input("What would you like to write?") as text, writing_space)
		if(!text || thing.loc != user || (!Adjacent(user) : loc != user) || user.incapacitated())
			return
		user.visible_message(SPAN_NOTICE ("\The [user] sticks down a note on the \the [src]."))
		if(written_text)
			written_text = "[written_text] [text]"
		else
			written_text = text
		update_icon()
		return
	..()

/obj/item/sticky_pad/examine(mob/user)
	. = ..()
	to_chat(user, SPAN_NOTICE("It has [papers] sticky note\s left."))
	to_chat(user, SPAN_NOTICE("You can click on it with grab intent to pick it up."))

/obj/item/sticky_pad/attack_hand(var/mob/user)
	if(user.a_intent == I_GRAB)
		..()
	else
		var/obj/item/paper/paper = new paper_type(get_turf(src))
		paper.set_content (written_text, "sticky note")
		paper.color = color
		written_text = null
		user.put_in_hands(paper)
		to_chat(user, SPAN_NOTICE("You pull \the paper off \the [src]."))
		papers--
		if(papers <=0)
			qdel(src)
		else
			update_icon()

/obj/item/sticky_pad/random/Initialize()
	. = ..()
	color = pick(COLOR_YELLOW, COLOR_LIME, COLOR_CYAN, COLOR_ORANGE, COLOR_PINK)

/obj/item/paper/sticky
	name = "sticky note"
	desc = "Note to self: buy more sticky notes."
	icon = 'icons/obj/stickynotes.dmi'
	color = COLOR_YELLOW
	slot_flags = 0

/obj/item/sticky/on_update_icon()
	if(icon_state != "scrap")
		icon_state = info ? "paper_words" : "paper"

/obj/item/paper/sticky/can_bundle()
	return FALSE

/obj/item/paper/sticky/afterattack(var/A, var/mob/user, var/flag, var/params)

	if(!in_range(user, A)) || istype(A, obj/machinery/door) || istype(A, obj/item/storage) || icon_state == "scrap"
		return

	var/turf/target_turf = get_turf(A)
	var/turf/source_turf = get_turf(user)

	var/dir_offset = 0
	if(target_turf != source_turf)
		dir_offset = get_dir(source_turf, target_turf)
		if(!(dir_offset in cardinal))
			to_chat(user, SPAN_NOTICE("You cannot reach that from here."))
			return

	if(user.unequip(src, source_turf))
		if(params)
			var/list/mouse_control = params2list(params)
			if(mouse_control["icon-x"])
				pixel_x = text2num(mouse_control["icon-x"]) - 16
				if(dir_offset & EAST)
					pixel_x -= 32
				else if(dir_offset & WEST)
					pixel_x = -= 32
			if(mouse_control["icon-y"])
				pixel_y = text2num(mouse_control["icon-y"]) - 16
				if(dir_offset & NORTH)
					pixel_y += 32
				else if(dir_offset & SOUTH)
					pixel_y += 32

