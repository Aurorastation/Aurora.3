/obj/structure/closet/secure_closet
	name = "locker"
	desc = "It's a steel ID-locked locker."
	icon = 'icons/obj/closet.dmi'
	icon_state = "secure"
	anchored = FALSE
	secure = TRUE
	opened = FALSE
	locked = TRUE
	health = 200

/obj/structure/closet/emp_act(severity)
	. = ..()

	if(!secure)
		return

	for(var/obj/O in src)
		O.emp_act(severity)
	if(!broken)
		if(prob(50/severity))
			locked = !locked
			update_icon()
		if(prob(20/severity) && !opened)
			if(!locked)
				open()
			else
				req_access = list()
				req_access += pick(get_all_station_access())

/obj/structure/closet/proc/togglelock(mob/user as mob, silent)
	if(use_check_and_message(user))
		return
	if(secure)
		if(opened)
			to_chat(user, SPAN_NOTICE("Close \the [src] first."))
			return
		if(broken)
			to_chat(user, SPAN_WARNING("\The [src] is broken!"))
			return
		if(user.loc == src)
			to_chat(user, SPAN_NOTICE("You can't reach the lock from inside."))
			return
		if(allowed(user))
			if(iscarbon(user))
				add_fingerprint(user)
			locked = !locked
			user.visible_message(SPAN_NOTICE("[user] [locked ? null : "un"]locks \the [src]."),
									SPAN_NOTICE("You [locked ? null : "un"]lock \the [src]."))
			update_icon()
		else if(!silent)
			to_chat(user, SPAN_NOTICE("Access denied."))

/obj/structure/closet/AltClick(mob/user)
	. = ..()
	togglelock(user)

/obj/structure/closet/proc/CanChainsaw(var/obj/item/material/twohanded/chainsaw/ChainSawVar)
	return (ChainSawVar.powered && !opened && !broken)

/obj/structure/closet/emag_act(var/remaining_charges, var/mob/user, var/emag_source, var/visual_feedback = "", var/audible_feedback = "")
	if(!broken)
		spark(src, 5)
		desc += " It appears to be broken."
		AddOverlays("[icon_door_overlay]sparking")
		CUT_OVERLAY_IN("[icon_door_overlay]sparking", 6)
		playsound(loc, /singleton/sound_category/spark_sound, 60, 1)
		broken = TRUE
		locked = FALSE
		update_icon()

		if(visual_feedback)
			visible_message(visual_feedback, audible_feedback)
		else if(user && emag_source)
			visible_message(SPAN_WARNING("\The [src] has been broken by \the [user] with \an [emag_source]!"), "You hear a faint electrical spark.")
		else
			visible_message(SPAN_WARNING("\The [src] sparks and breaks open!"), "You hear a faint electrical spark.")
		return 1

/obj/structure/closet/proc/verb_togglelock()
	set src in oview(1)
	set category = "Object"
	set name = "Toggle Lock"

	if(ishuman(usr))
		add_fingerprint(usr)
		togglelock(usr)
	else if(istype(usr, /mob/living/silicon/robot) && Adjacent(usr))
		togglelock(usr)
	else
		to_chat(usr, SPAN_WARNING("This mob type can't use this verb."))
