/obj/item/pen/typewriter
	name = "national typist 'Adhomai Electric' experimental integrated typewriter pen"
	desc = "A mechanical pen that writes on paper inside a typewriter. How did you even get this?"

/obj/item/portable_typewriter
	name = "portable typewriter"
	desc = "A reasonably lightweight typewriter designed to be moved around."
	desc_extended = "The National Typist Company in the People's Republic of Adhomai was once the largest producer of \
	typewriters on the planet. With the introduction of human technology, however, these items - \
	which were once staples of Tajaran offices - have slowly become more uncommon. That \
	said, rural areas and less urban parts of the planet still rely heavily on these machines."
	icon_state = "typewriter"
	icon = 'icons/obj/bureaucracy.dmi'
	force = 25
	throwforce = 5
	w_class = WEIGHT_CLASS_NORMAL
	drop_sound = 'sound/items/drop/metalweapon.ogg'
	pickup_sound = 'sound/items/pickup/metalweapon.ogg'

	var/obj/item/paper/stored_paper = null
	var/obj/item/pen/pen

/obj/item/portable_typewriter/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "You can ALT-click this to eject the paper."
	. += "Click and drag \the [src] onto yourself while adjacent to type on it."

/obj/item/portable_typewriter/Initialize()
	. = ..()

	if(!pen)
		pen = new /obj/item/pen/typewriter(src)

/obj/item/portable_typewriter/Destroy()
	QDEL_NULL(stored_paper)
	QDEL_NULL(pen)

	return ..()

/obj/item/portable_typewriter/attack_self(mob/user)
	if(!stored_paper)
		to_chat(user, SPAN_ALERT("\The [src] has no paper fed for typing!"))
	else
		stored_paper.attackby(pen, user)
	. = ..()

/obj/item/portable_typewriter/proc/get_signature(var/mob/user)
	if (pen)
		pen.get_signature(user)

/obj/item/portable_typewriter/AltClick(mob/user)
	if(!Adjacent(user))
		return

	else if(stored_paper)
		var/obj/item/paper/paper = stored_paper
		if(eject_paper(user.loc))
			user.put_in_hands(paper)
	else
		. = ..()

/obj/item/portable_typewriter/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	var/mob/mob_dropped_over = over
	if(use_check_and_message(mob_dropped_over))
		return

	if(((mob_dropped_over.contents.Find(src) || in_range(src, mob_dropped_over))))
		if(isnull(stored_paper))
			to_chat(mob_dropped_over, SPAN_ALERT("\The [src] has no paper fed for typing!"))
		else
			stored_paper.attackby(pen, mob_dropped_over)
	return

/obj/item/portable_typewriter/update_icon()
	if(stored_paper)
		icon_state = "typewriter_[stored_paper.icon_state]"
	else
		icon_state = "typewriter"

/obj/item/portable_typewriter/proc/eject_paper(atom/target, mob/user)
	if(!stored_paper)
		return FALSE

	to_chat(user, SPAN_ALERT("\The [src] ejects \the [stored_paper]."))
	playsound(loc, 'sound/bureaucracy/paperfold.ogg', 60, 0)
	stored_paper.forceMove(target)
	stored_paper = null
	update_icon()
	return TRUE

/obj/item/portable_typewriter/attackby(obj/item/attacking_item, mob/user, params)
	if(istype(attacking_item, /obj/item/paper))
		if(!stored_paper)
			if(attacking_item.icon_state == "scrap")
				to_chat(user, SPAN_ALERT("\The [attacking_item] is too crumpled to feed correctly!"))
				return
			else
				user.drop_item(attacking_item)
				user.unEquip(attacking_item)
				attacking_item.forceMove(src)
				stored_paper = attacking_item
				user.visible_message(SPAN_ALERT("\The [user] sucks up \the [attacking_item] into \the [src]."), SPAN_ALERT("You suck up \the [attacking_item] into \the [src]."))
				src.update_icon()
		else
			to_chat(user, SPAN_ALERT("\The [src] already has a paper in it."))
		. = ..()

/obj/item/portable_typewriter/attack(mob/living/target_mob, mob/living/user, target_zone)
	..()

	var/mob/living/carbon/M = target_mob

	if(!istype(M))
		return

	user.visible_message(SPAN_ALERT("\The [src] shatters into metal pieces!"))
	M.Weaken(2)
	playsound(loc, 'sound/effects/metalhit.ogg', 50, 1)
	playsound(loc, 'sound/weapons/ring.ogg', 50, 1)
	new /obj/item/material/shard/shrapnel(get_turf(user))
	qdel(src)

/obj/item/typewriter_case
	name = "typewriter case"
	desc = "A large briefcase-esque place to store one's typewriter."
	desc_extended = "The National Typist Company in the People's Republic of Adhomai was once the largest producer of \
	typewriters on the planet. With the introduction of human technology, however, these items - \
	which were once staples of Tajaran offices - have slowly become more uncommon. That \
	said, rural areas and less urban parts of the planet still rely heavily on these machines."
	icon = 'icons/obj/storage/briefcase.dmi'
	icon_state = "typewriter_case_closed"
	item_state = "briefcase_black"
	contained_sprite = TRUE
	force = 15
	throwforce = 5
	throw_speed = 1
	throw_range = 4
	w_class = WEIGHT_CLASS_BULKY
	drop_sound = 'sound/items/drop/backpack.ogg'
	pickup_sound = 'sound/items/pickup/backpack.ogg'

	var/obj/item/portable_typewriter/machine
	var/opened = FALSE

/obj/item/typewriter_case/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "You can ALT-click on this case to open and close it. A typewriter can only be removed or added when it is open!"

/obj/item/typewriter_case/Initialize()
	. = ..()
	if(!machine)
		machine = new /obj/item/portable_typewriter(src)

/obj/item/typewriter_case/Destroy()
	QDEL_NULL(machine)
	return ..()

/obj/item/typewriter_case/AltClick(mob/user)
	if(!Adjacent(user))
		return

	playsound(loc, 'sound/items/storage/briefcase.ogg', 50, 0, -5)

	opened = !opened
	update_icon()

/obj/item/typewriter_case/update_icon()
	if(opened && machine)
		icon_state = "typewriter_case_open"
	else if (opened && !machine)
		icon_state = "typewriter_case_open_e"
	else if (!opened)
		icon_state = "typewriter_case_closed"

/obj/item/typewriter_case/attack_self(mob/user)
	if(use_check_and_message(user))
		return
	if(((user.contents.Find(src) || in_range(src, user))))
		if(opened)
			if(!machine)
				to_chat(user, SPAN_ALERT("\The [src] is currently empty!"))
			else
				user.put_in_hands(machine)
				machine = null
				update_icon()
		else
			to_chat(user, SPAN_ALERT("\The [src] is currently closed!"))
	return

/obj/item/typewriter_case/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	attack_self(over)

/obj/item/typewriter_case/attackby(obj/item/attacking_item, mob/user, params)
	if(istype(attacking_item, /obj/item/portable_typewriter))
		if(!machine)
			user.drop_item(attacking_item)
			user.unEquip(attacking_item)
			attacking_item.forceMove(src)
			src.machine = attacking_item
			user.visible_message(SPAN_ALERT("[user] places \the [attacking_item] into \the [src]."), SPAN_ALERT ("You store \the [attacking_item] in \the [src]."))
			src.update_icon()
		else
			to_chat(user, SPAN_ALERT("\The [src] already has a typewriter in it!"))
		. = ..()
