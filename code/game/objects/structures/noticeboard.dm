/obj/structure/noticeboard
	name = "notice board"
	desc = "A board for pinning probably not-so-important notices upon."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "nboard0"
	density = 0
	anchored = 1
	var/notices = 0
	var/notice_limit = 20
	var/base_icon = "nboard"

/obj/structure/noticeboard/Initialize(mapload)
	if (mapload)
		add_papers_from_turf()
	. = ..()

/obj/structure/noticeboard/proc/add_papers_from_turf()
	for(var/obj/item/I in loc)
		if(notice_limit <= notices) break
		if(istype(I, /obj/item/paper))
			I.forceMove(src)
			notices++
	update_icon()

/obj/structure/noticeboard/update_icon()
	..()
	icon_state = "[base_icon][notices]"

//attaching papers!!
/obj/structure/noticeboard/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/paper))
		if(notice_limit > notices)
			attacking_item.add_fingerprint(user)
			add_fingerprint(user)
			user.drop_from_inventory(attacking_item,src)
			notices++
			update_icon()
			SSpersistence.register_track(attacking_item, ckey(usr.key)) // Add paper to persistent tracker
			to_chat(user, SPAN_NOTICE("You pin the paper to the noticeboard."))
		else
			to_chat(user, SPAN_NOTICE("You reach to pin your paper to the board but hesitate. You are certain your paper will not be seen among the many others already attached."))

/obj/structure/noticeboard/attack_hand(var/mob/user)
	examine(user)

// Since Topic() never seems to interact with usr on more than a superficial
// level, it should be fine to let anyone mess with the board other than ghosts.
/obj/structure/noticeboard/examine(mob/user, distance, is_adjacent, infix, suffix, show_extended)
	if(is_adjacent)
		var/dat = "<B>Noticeboard</B><BR>"
		for(var/obj/item/paper/P in src)
			dat += "<A href='byond://?src=[REF(src)];read=[REF(P)]'>[P.name]</A> <A href='byond://?src=[REF(src)];write=[REF(P)]'>Write</A> <A href='byond://?src=[REF(src)];remove=[REF(P)]'>Remove</A><BR>"
		user << browse("<HEAD><TITLE>Notices</TITLE></HEAD>[dat]","window=noticeboard")
		onclose(user, "noticeboard")
		return TRUE
	else
		. = ..()

/obj/structure/noticeboard/Topic(href, href_list)
	..()
	usr.set_machine(src)
	if(href_list["remove"])
		if((usr.stat || usr.restrained()))	//For when a player is handcuffed while they have the notice window open
			return
		var/obj/item/P = locate(href_list["remove"])
		if(P && P.loc == src && Adjacent(usr))
			usr.put_in_hands(P) // we are no longer clumsy fucks
			P.add_fingerprint(usr)
			add_fingerprint(usr)
			notices--
			update_icon()
			SSpersistence.deregister_track(P) // Remove paper from persistent tracker
	if(href_list["write"])
		if((usr.stat || usr.restrained())) //For when a player is handcuffed while they have the notice window open
			return
		var/obj/item/P = locate(href_list["write"])
		if((P && P.loc == src)) //ifthe paper's on the board
			var/obj/item/R = usr.r_hand
			var/obj/item/L = usr.l_hand
			if(R.ispen())
				P.attackby(R, usr)
			else if(L.ispen())
				P.attackby(L, usr)
			else
				to_chat(usr, SPAN_NOTICE("You'll need something to write with!"))
				return
			add_fingerprint(usr)
	if(href_list["read"])
		var/obj/item/paper/P = locate(href_list["read"])
		if((P && P.loc == src))
			usr << browse("<HTML><HEAD><TITLE>[P.name]</TITLE></HEAD><BODY><TT>[P.info]</TT></BODY></HTML>", "window=[P.name]")
			onclose(usr, "[P.name]")
	return

/obj/structure/noticeboard/command
	name = "command notice board"
	desc = "A board for command to pin actually important information on. As if. Can be locked and unlocked with an appropiate ID."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "comboard0"
	req_access = list(ACCESS_CAPTAIN, ACCESS_CMO, ACCESS_HOS, ACCESS_QM, ACCESS_HOS, ACCESS_CE)
	base_icon = "comboard"
	notice_limit = 6
	var/open
	var/unlocked

/obj/structure/noticeboard/command/Initialize()
	. = ..()
	update_icon()

/obj/structure/noticeboard/command/update_icon()
	..()
	ClearOverlays()
	if(unlocked)
		AddOverlays("unlocked")
	else
		AddOverlays("locked")
	if(open)
		AddOverlays("glass_open")
	else
		AddOverlays("glass")

/obj/structure/noticeboard/command/attack_hand(var/mob/user)
	if(!unlocked)
		to_chat(user, SPAN_NOTICE("\The [src] is locked."))
		return
	toggle_open(user)

/obj/structure/noticeboard/command/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.GetID() && allowed(usr))
		if(open)
			to_chat(user, SPAN_WARNING("You need to close it first."))
			return
		toggle_lock(user)
		return
	else if(open)
		return ..()

/obj/structure/noticeboard/command/proc/toggle_open(var/mob/user)
	open = !open
	to_chat(user, SPAN_NOTICE("You [open ? "open" : "close"] \the [src]."))
	update_icon()

/obj/structure/noticeboard/command/proc/toggle_lock(var/mob/user)
	if(open)
		return
	else
		to_chat(user, SPAN_NOTICE("You [unlocked ? "enable" : "disable"] \the [src]'s maglock."))
		if(!do_after(user, 5)) // So you can't spam it.
			return

		unlocked = !unlocked
		to_chat(user, SPAN_NOTICE("You [unlocked ? "disable" : "enable"] the maglock."))

	update_icon()

/obj/structure/noticeboard/command/Topic(href, href_list) // Allows to read through the closed glass of the board, but disallows removing and writing.
	if("read" in href_list)
		..()
	else if(open)
		..()
