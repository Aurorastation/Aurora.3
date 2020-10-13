//Also contains /obj/structure/closet/body_bag because I doubt anyone would think to look for bodybags in /object/structures

/obj/item/bodybag
	name = "body bag"
	desc = "A folded bag designed for the storage and transportation of cadavers."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "bodybag_folded"
	w_class = ITEMSIZE_SMALL
	drop_sound = 'sound/items/drop/cloth.ogg'
	pickup_sound = 'sound/items/pickup/cloth.ogg'

/obj/item/bodybag/attack_self(mob/user)
	var/obj/structure/closet/body_bag/R = new /obj/structure/closet/body_bag(user.loc)
	R.add_fingerprint(user)
	playsound(src, 'sound/items/drop/cloth.ogg', 30)
	qdel(src)

/obj/item/storage/box/bodybags
	name = "body bags"
	desc = "This box contains body bags."
	icon_state = "bodybags"

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
	icon_state = "bodybag_closed"
	icon_closed = "bodybag_closed"
	icon_opened = "bodybag_open"
	open_sound = 'sound/items/zip.ogg'
	close_sound = 'sound/items/zip.ogg'
	density = 0
	storage_capacity = 30
	var/item_path = /obj/item/bodybag
	var/contains_body = 0
	var/shapely = TRUE

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
			return
		if (!in_range(src, user) && src.loc != user)
			return
		t = sanitizeSafe(t, MAX_NAME_LEN)
		if (t)
			src.name = "body bag - "
			src.name += t
			playsound(src, pick('sound/bureaucracy/pen1.ogg','sound/bureaucracy/pen2.ogg'), 20)
			add_overlay("bodybag_label")
		else
			src.name = "body bag"
		return
	else if(W.iswirecutter())
		to_chat(user, "You cut the tag off the bodybag.")
		playsound(src.loc, 'sound/items/wirecutter.ogg', 50, 1)
		src.name = "body bag"
		cut_overlays()

/obj/structure/closet/body_bag/store_mobs(var/stored_units)
	contains_body = ..()
	return contains_body

/obj/structure/closet/body_bag/close()
	if(..())
		density = 0
		return TRUE
	return FALSE

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
	if(opened)
		icon_state = icon_opened
	else
		if(contains_body > 0 && shapely)
			icon_state = "bodybag_closed1"
		else
			icon_state = icon_closed

/obj/item/bodybag/cryobag
	name = "stasis bag"
	desc = "A folded, reusable bag designed to prevent additional damage to an occupant, especially useful if short on time or in \
	a hostile enviroment."
	icon = 'icons/obj/cryobag.dmi'
	icon_state = "bodybag_folded"
	origin_tech = list(TECH_BIO = 4)
	var/stasis_power

/obj/item/bodybag/cryobag/attack_self(mob/user)
	var/obj/structure/closet/body_bag/cryobag/R = new /obj/structure/closet/body_bag/cryobag(user.loc)
	if(stasis_power)
		R.stasis_power = stasis_power
	R.update_icon()
	R.add_fingerprint(user)
	qdel(src)

/obj/structure/closet/body_bag/cryobag
	name = "stasis bag"
	desc = "A reusable plastic bag designed to prevent additional damage to an occupant, especially useful if short on time or in \
	a hostile enviroment."
	icon = 'icons/obj/cryobag.dmi'
	icon_opened = "stasis_open"
	icon_closed = "stasis_closed"
	item_path = /obj/item/bodybag/cryobag
	shapely = FALSE
	var/datum/gas_mixture/airtank

	var/stasis_power = 20
	var/degradation_time = 2 MINUTES //ticks until stasis power degrades

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
	var/image/I = image(icon, "indicator[opened]")
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
	desc = "Pretty useless now.."
	icon_state = "bodybag_used"
	icon = 'icons/obj/cryobag.dmi'
