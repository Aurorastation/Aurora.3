/*
 *	Absorbs /obj/item/secstorage.
 *	Reimplements it only slightly to use existing storage functionality.
 *
 *	Contains:
 *		Secure Briefcase
 *		Wall Safe
 */

// -----------------------------
//         Generic Item
// -----------------------------
ABSTRACT_TYPE(/obj/item/storage/secure)
	name = "secstorage"
	var/icon_locking = "secureb"
	var/icon_sparking = "securespark"
	var/icon_opened = "secure0"
	var/locked = 1
	var/code = ""
	var/l_code = null
	var/l_set = 0
	var/l_setshort = 0
	var/l_hacking = 0
	var/emagged = 0
	var/open = 0
	w_class = WEIGHT_CLASS_BULKY
	max_w_class = WEIGHT_CLASS_NORMAL
	max_storage_space = DEFAULT_BOX_STORAGE
	use_sound = 'sound/items/storage/briefcase.ogg'

/obj/item/storage/secure/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(distance <= 1)
		. += "The service panel is [src.open ? "open" : "closed"]."

/obj/item/storage/secure/attackby(obj/item/attacking_item, mob/user)
	if(locked)
		if (istype(attacking_item, /obj/item/melee/energy/blade) && emag_act(INFINITY, user, "You slice through the lock of \the [src]"))
			var/obj/item/melee/energy/blade/blade = attacking_item
			blade.spark_system.queue()
			playsound(src.loc, 'sound/weapons/blade.ogg', 50, 1)
			playsound(src.loc, /singleton/sound_category/spark_sound, 50, 1)
			return

		if (attacking_item.isscrewdriver())
			if(attacking_item.use_tool(src, user, 20, volume = 50))
				src.open =! src.open
				to_chat(user, SPAN_NOTICE("You [src.open ? "open" : "close"] the service panel."))
			return
		if ((attacking_item.ismultitool()) && (src.open == 1)&& (!src.l_hacking))
			to_chat(user, SPAN_NOTICE("Now attempting to reset internal memory, please hold."))
			src.l_hacking = 1
			if (do_after(usr, 100))
				if (prob(40))
					src.l_setshort = 1
					src.l_set = 0
					to_chat(user, SPAN_NOTICE("Internal memory reset."))
					src.l_setshort = 0
					src.l_hacking = 0
				else
					to_chat(user, SPAN_WARNING("Unable to reset internal memory."))
					src.l_hacking = 0
			else	src.l_hacking = 0
			return
		//At this point you have exhausted all the special things to do when locked
		// ... but it's still locked.
		return

	// -> storage/attackby() what with handle insertion, etc
	..()


/obj/item/storage/secure/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	if (locked)
		src.add_fingerprint(user)
		return
	..()


/obj/item/storage/secure/attack_self(mob/user as mob)
	user.set_machine(src)
	var/dat = "<TT><B>[src]</B><BR>\n\nLock Status: [(src.locked ? "LOCKED" : "UNLOCKED")]"
	var/message = "Code"
	if ((src.l_set == 0) && (!src.emagged) && (!src.l_setshort))
		dat += "<p>\n<b>5-DIGIT PASSCODE NOT SET.<br>ENTER NEW PASSCODE.</b>"
	if (src.emagged)
		dat += "<p>\n<font color=red><b>LOCKING SYSTEM ERROR - 1701</b></font>"
	if (src.l_setshort)
		dat += "<p>\n<font color=red><b>ALERT: MEMORY SYSTEM ERROR - 6040 201</b></font>"
	message = "[src.code]"
	if (!src.locked)
		message = "*****"
	dat += "<HR>\n>[message]<BR>\n<A href='byond://?src=[REF(src)];type=1'>1</A>-<A href='byond://?src=[REF(src)];type=2'>2</A>-<A href='byond://?src=[REF(src)];type=3'>3</A><BR>\n<A href='byond://?src=[REF(src)];type=4'>4</A>-<A href='byond://?src=[REF(src)];type=5'>5</A>-<A href='byond://?src=[REF(src)];type=6'>6</A><BR>\n<A href='byond://?src=[REF(src)];type=7'>7</A>-<A href='byond://?src=[REF(src)];type=8'>8</A>-<A href='byond://?src=[REF(src)];type=9'>9</A><BR>\n<A href='byond://?src=[REF(src)];type=R'>R</A>-<A href='byond://?src=[REF(src)];type=0'>0</A>-<A href='byond://?src=[REF(src)];type=E'>E</A><BR>\n</TT>"

	user << browse(dat, "window=caselock;size=300x280")

/obj/item/storage/secure/Topic(href, href_list)
	..()
	if ((usr.stat || usr.restrained()) || (get_dist(src, usr) > 1))
		return
	if (href_list["type"])
		if (href_list["type"] == "E")
			if ((src.l_set == 0) && (length(src.code) == 5) && (!src.l_setshort) && (src.code != "ERROR"))
				src.l_code = src.code
				src.l_set = 1
			else if ((src.code == src.l_code) && (src.emagged == 0) && (src.l_set == 1))
				src.locked = 0
				ClearOverlays()
				AddOverlays(icon_opened)
				src.code = null
			else
				src.code = "ERROR"
		else
			if ((href_list["type"] == "R") && (src.emagged == 0) && (!src.l_setshort))
				src.locked = 1
				ClearOverlays()
				src.code = null
				src.close(usr)
			else
				src.code += "[href_list["type"]]"
				if (length(src.code) > 5)
					src.code = "ERROR"
		src.add_fingerprint(usr)
		for(var/mob/M in viewers(1, src.loc))
			if ((M.client && M.machine == src))
				src.attack_self(M)
			return
	return

/obj/item/storage/secure/emag_act(var/remaining_charges, var/mob/user, var/feedback)
	if(!emagged)
		emagged = 1
		AddOverlays(icon_sparking)
		sleep(6)
		ClearOverlays()
		AddOverlays(icon_locking)
		locked = 0
		to_chat(user, (feedback ? feedback : "You short out the lock of \the [src]."))
		return 1

/obj/item/storage/secure/AltClick(/mob/user)
	if (!locked)
		return ..()

// -----------------------------
//        Secure Briefcase
// -----------------------------
/obj/item/storage/secure/briefcase
	name = "secure briefcase"
	desc = "A large briefcase with a digital locking system."
	icon = 'icons/obj/storage/briefcase.dmi'
	icon_state = "secure"
	item_state = "secure"
	contained_sprite = TRUE
	force = 18
	throw_speed = 1
	throw_range = 4
	w_class = WEIGHT_CLASS_BULKY

/obj/item/storage/secure/briefcase/attack_hand(mob/user as mob)
	if((src.loc == user) && (src.locked == 1))
		to_chat(usr, SPAN_WARNING("[src] is locked and cannot be opened!"))
	else if((src.loc == user) && (!src.locked))
		src.open(usr)
	else
		..()
		for(var/mob/M in range(1))
			if(M.s_active == src)
				src.close(M)
	src.add_fingerprint(user)
	return

// -----------------------------
//        Secure Safe
// -----------------------------

/obj/item/storage/secure/safe
	name = "secure safe"
	icon = 'icons/obj/storage/misc.dmi'
	icon_state = "safe"
	icon_opened = "safe0"
	icon_locking = "safeb"
	icon_sparking = "safespark"
	force = 18
	w_class = WEIGHT_CLASS_GIGANTIC
	max_w_class = WEIGHT_CLASS_GIGANTIC
	anchored = 1.0
	density = 0
	cant_hold = list(/obj/item/storage/secure/briefcase)
	starts_with = list(/obj/item/paper = 1, /obj/item/pen = 1)

/obj/item/storage/secure/safe/attack_hand(mob/user as mob)
	return attack_self(user)

/*obj/item/storage/secure/safe/HoS/New()
	..()
	//new /obj/item/storage/lockbox/clusterbang(src) This item is currently broken... and probably shouldnt exist to begin with (even though it's cool)
*/
