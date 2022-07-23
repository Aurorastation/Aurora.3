//Also contains /obj/structure/closet/body_bag because I doubt anyone would think to look for bodybags in /object/structures

/obj/item/bodybag
	name = "body bag"
	desc = "A folded bag designed for the storage and transportation of cadavers."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "bodybag_folded"
	w_class = ITEMSIZE_SMALL
	drop_sound = 'sound/items/drop/cloth.ogg'
	pickup_sound = 'sound/items/pickup/cloth.ogg'
	var/deploy_type = /obj/structure/closet/body_bag

/obj/item/bodybag/attack_self(mob/user)
	deploy_bag(user, user.loc)

/obj/item/bodybag/afterattack(obj/target, mob/user, proximity)
	if(!proximity)
		return
	if(isturf(target))
		var/turf/T = target
		if(!T.density)
			deploy_bag(user, target)

/obj/item/bodybag/proc/deploy_bag(mob/user, atom/location)
	var/obj/structure/closet/body_bag/R = new deploy_type(location)
	R.add_fingerprint(user)
	tweak_bag(R)
	playsound(src, 'sound/items/drop/cloth.ogg', 30)
	qdel(src)

/obj/item/bodybag/proc/tweak_bag(var/obj/structure/closet/body_bag/BB)
	return

/obj/item/storage/box/bodybags
	name = "body bags"
	desc = "This box contains body bags."
	illustration = "bodybags"

/obj/item/storage/box/bodybags/New()
	..()
	new /obj/item/bodybag(src)
	new /obj/item/bodybag(src)
	new /obj/item/bodybag(src)
	new /obj/item/bodybag(src)
	new /obj/item/bodybag(src)
	new /obj/item/bodybag(src)
	new /obj/item/bodybag(src)

/obj/structure/closet/body_bag
	name = "body bag"
	desc = "A plastic bag designed for the storage and transportation of cadavers."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "bodybag"
	open_sound = 'sound/items/zip.ogg'
	close_sound = 'sound/items/zip.ogg'
	density = 0
	storage_capacity = 30
	var/item_path = /obj/item/bodybag
	var/contains_body = FALSE
	can_be_buckled = TRUE

/obj/structure/closet/body_bag/content_info(mob/user, content_size)
	if(!content_size && !contains_body)
		to_chat(user, "\The [src] is empty.")
	else if(storage_capacity > content_size*4)
		to_chat(user, "\The [src] is barely filled.")
	else if(storage_capacity > content_size*2)
		to_chat(user, "\The [src] is less than half full.")
	else if(storage_capacity > content_size)
		to_chat(user, "\The [src] still has some free space.")
	else
		to_chat(user, "\The [src] is full.")
	to_chat(user, "It [contains_body ? "contains" : "does not contain"] a body.")

/obj/structure/closet/body_bag/attackby(var/obj/item/W, mob/user as mob)
	if (W.ispen())
		var/t = input(user, "What would you like the label to be?", text("[]", src.name), null)  as text
		if (user.get_active_hand() != W)
			return TRUE
		if (!in_range(src, user) && src.loc != user)
			return TRUE
		t = sanitizeSafe(t, MAX_NAME_LEN)
		if (t)
			src.name = "body bag - "
			src.name += t
			playsound(src, pick('sound/bureaucracy/pen1.ogg','sound/bureaucracy/pen2.ogg'), 20)
			LAZYADD(overlays, image(icon, "bodybag_label"))
		else
			src.name = "body bag"
		return TRUE
	else if(W.iswirecutter())
		to_chat(user, "You cut the tag off the bodybag.")
		playsound(src.loc, 'sound/items/wirecutter.ogg', 50, 1)
		src.name = "body bag"
		LAZYREMOVE(overlays, image(icon, "bodybag_label"))
		return TRUE

/obj/structure/closet/body_bag/store_mobs(var/stored_units)
	contains_body = ..()
	slowdown = 0
	if(contains_body)
		for(var/mob/living/M in contents)
			if(M.stat != DEAD || M.status_flags & FAKEDEATH)
				slowdown = initial(slowdown)
				break
	return contains_body

/obj/structure/closet/body_bag/close()
	if(..())
		density = 0
		return TRUE
	return FALSE

/obj/structure/closet/body_bag/open()
	if(buckled_to)
		return 0
	return ..()

/obj/structure/closet/body_bag/dump_contents(var/stored_units)
	..()
	slowdown = initial(slowdown)

/obj/structure/closet/body_bag/MouseDrop(over_object, src_location, over_location)
	..()
	if((over_object == usr && (in_range(src, usr) || usr.contents.Find(src))))
		fold(usr)

/obj/structure/closet/body_bag/proc/fold(var/user)
	if(!(ishuman(user)))
		return FALSE
	if(opened)
		return 0
	if(length(contents))
		return 0
	visible_message("<b>[user]</b> folds up \the [name].")
	. = new item_path(get_turf(src))
	qdel(src)

/obj/structure/closet/body_bag/update_icon()
	icon_state = "[initial(icon_state)][opened ? "_open" : "[contains_body ? "_occupied" : ""]"]"

/obj/structure/closet/body_bag/animate_door()
	flick("[initial(icon_state)]_anim_[opened ? "open" : "close"]", src)

/obj/item/bodybag/cryobag
	name = "stasis bag"
	desc = "A folded, reusable bag designed to prevent additional damage to an occupant, especially useful if short on time or in \
	a hostile enviroment."
	icon_state = "stasis_folded"
	origin_tech = list(TECH_BIO = 4)
	deploy_type = /obj/structure/closet/body_bag/cryobag
	var/stasis_power

/obj/item/bodybag/cryobag/tweak_bag(var/obj/structure/closet/body_bag/cryobag/C)
	if(stasis_power)
		C.stasis_power = stasis_power

/obj/structure/closet/body_bag/cryobag
	name = "stasis bag"
	desc = "A reusable plastic bag designed to prevent additional damage to an occupant, especially useful if short on time or in \
	a hostile enviroment."
	icon_state = "stasis"
	item_path = /obj/item/bodybag/cryobag
	var/datum/gas_mixture/airtank

	var/stasis_power = 20
	var/degradation_time = 60 // 2 minutes: 60 ticks * 2 seconds per tick

/obj/structure/closet/body_bag/cryobag/Initialize()
	. = ..()
	airtank = new()
	airtank.temperature = T0C
	airtank.adjust_gas(GAS_OXYGEN, MOLES_O2STANDARD, 0)
	airtank.adjust_gas(GAS_NITROGEN, MOLES_N2STANDARD)
	update_icon()

/obj/structure/closet/body_bag/cryobag/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	QDEL_NULL(airtank)
	return ..()

/obj/structure/closet/body_bag/cryobag/Entered(atom/movable/AM)
	if(ishuman(AM))
		START_PROCESSING(SSprocessing, src)
	..()

/obj/structure/closet/body_bag/cryobag/Exited(atom/movable/AM)
	if(ishuman(AM))
		STOP_PROCESSING(SSprocessing, src)
	. = ..()

/obj/structure/closet/body_bag/cryobag/update_icon()
	..()
	overlays.Cut()
	var/image/I = image(icon, "indicator")
	I.appearance_flags = RESET_COLOR
	var/maxstasis = initial(stasis_power)
	if(stasis_power > 0.5 * maxstasis)
		I.color = COLOR_LIME
	else if(stasis_power)
		I.color = COLOR_YELLOW
	else
		I.color = COLOR_RED
	overlays += I

/obj/structure/closet/body_bag/cryobag/proc/get_saturation()
	return -155 * (1 - stasis_power/initial(stasis_power))

/obj/structure/closet/body_bag/cryobag/fold(var/user)
	var/obj/item/bodybag/cryobag/folded = ..()
	if(istype(folded))
		folded.stasis_power = stasis_power
		folded.color = color_saturation(get_saturation())

/obj/structure/closet/body_bag/cryobag/process()
	if(stasis_power < 2)
		return PROCESS_KILL
	var/mob/living/carbon/human/H = locate() in src
	if(!H)
		return PROCESS_KILL
	degradation_time--
	if(degradation_time < 0)
		degradation_time = initial(degradation_time)
		stasis_power = round(0.75 * stasis_power)
		animate(src, color = color_saturation(get_saturation()), time = 10)
		update_icon()

	if(H.stasis_sources[STASIS_CRYOBAG] != stasis_power)
		H.SetStasis(stasis_power, STASIS_CRYOBAG)
	H.eye_blind = 3

/obj/structure/closet/body_bag/cryobag/return_air() //Used to make stasis bags protect from vacuum.
	if(airtank)
		return airtank
	..()

/obj/structure/closet/body_bag/cryobag/examine(mob/user)
	. = ..()
	to_chat(user,"The stasis meter shows '[stasis_power]x'.")
	if(Adjacent(user) && length(contents)) //The bag's rather thick and opaque from a distance.
		to_chat(user, "<span class='info'>You peer into \the [src].</span>")
		for(var/mob/living/L in contents)
			L.examine(arglist(args))

/obj/item/usedcryobag
	name = "used stasis bag"
	desc = "Pretty useless now."
	icon_state = "cryobag_used"
	icon = 'icons/obj/bodybag.dmi'
