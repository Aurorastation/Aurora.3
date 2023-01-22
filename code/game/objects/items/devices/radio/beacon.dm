var/global/list/teleportbeacons = list()

/obj/item/device/radio/beacon
	name = "tracking beacon"
	desc = "A sophisticated beacon with integrated bluespace circuitry, capable of being targetted by a teleportation hub for local teleportation."
	icon_state = "beacon"
	item_state = "signaler"
	show_modify_on_examine = FALSE
	var/code = "electronic"
	origin_tech = list(TECH_BLUESPACE = 1)

/obj/item/device/radio/beacon/Initialize()
	. = ..()
	teleportbeacons += src

/obj/item/device/radio/beacon/Destroy()
	teleportbeacons -= src
	return ..()

/obj/item/device/radio/beacon/examine(mob/user)
	. = ..()
	if(anchored)
		to_chat(user, SPAN_NOTICE("It's been secured to the ground with anchoring screws."))

/obj/item/device/radio/beacon/attack_hand(mob/user)
	if(anchored)
		return
	return ..()

/obj/item/device/radio/beacon/hear_talk()
	return

/obj/item/device/radio/beacon/send_hear()
	return null

/obj/item/device/radio/beacon/attackby(obj/item/W, mob/user)
	if(isturf(loc) && W.isscrewdriver())
		anchored = !anchored
		user.visible_message("<b>[user]</b> [anchored ? "" : "un"]fastens \the [src] [anchored ? "to" : "from"] the floor.", "You [anchored ? "" : "un"]fasten \the [src] [anchored ? "to" : "from"] the floor.")
		return
	return ..()

/obj/item/device/radio/beacon/verb/alter_signal(t as text)
	set name = "Alter Beacon's Signal"
	set category = "Object"
	set src in usr

	if ((usr.canmove && !( usr.restrained() )))
		src.code = t
	if (!( src.code ))
		src.code = "beacon"
	src.add_fingerprint(usr)
	return


/obj/item/device/radio/beacon/bacon //Probably a better way of doing this, I'm lazy.
	proc/digest_delay()
		QDEL_IN(src, 600)

/obj/item/device/radio/beacon/fixed
	alpha = 0
	invisibility = INVISIBILITY_MAXIMUM
	anchored = TRUE

/obj/item/device/radio/beacon/fixed/ex_act(severity)
	return

/obj/item/device/radio/beacon/fixed/emp_act(severity)
	return
