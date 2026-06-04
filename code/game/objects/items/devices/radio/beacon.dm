GLOBAL_LIST_EMPTY(teleportbeacons)

/obj/item/radio/beacon
	name = "tracking beacon"
	desc = "A sophisticated beacon with integrated bluespace circuitry, capable of being targetted by a teleportation hub for localized jumps."
	icon_state = "beacon"
	item_state = "signaler"
	show_modify_on_examine = FALSE
	var/code = "electronic"
	origin_tech = list(TECH_BLUESPACE = 1)

/obj/item/radio/beacon/Initialize()
	. = ..()
	GLOB.teleportbeacons += src

/obj/item/radio/beacon/Destroy()
	GLOB.teleportbeacons -= src
	return ..()

/obj/item/radio/beacon/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(anchored)
		. += SPAN_NOTICE("It's been secured to the ground with anchoring screws.")

/obj/item/radio/beacon/attack_hand(mob/user)
	if(anchored)
		return
	return ..()

/obj/item/radio/beacon/hear_talk()
	return

/obj/item/radio/beacon/send_hear()
	return null

/obj/item/radio/beacon/attackby(obj/item/attacking_item, mob/user)
	if(isturf(loc) && attacking_item.tool_behaviour == TOOL_SCREWDRIVER)
		anchored = !anchored
		user.visible_message("<b>[user]</b> [anchored ? "" : "un"]fastens \the [src] [anchored ? "to" : "from"] the floor.", "You [anchored ? "" : "un"]fasten \the [src] [anchored ? "to" : "from"] the floor.")
		return
	return ..()

/obj/item/radio/beacon/verb/alter_signal(t as text)
	set name = "Alter Beacon's Signal"
	set category = "Object.Held"
	set src in usr

	if ((usr.canmove && !( usr.restrained() )))
		src.code = t
	if (!( src.code ))
		src.code = "beacon"
	src.add_fingerprint(usr)
	return


// Probably a better way of doing this, I'm lazy.
/obj/item/radio/beacon/bacon/proc/digest_delay()
	QDEL_IN(src, 600)

/obj/item/radio/beacon/fixed
	alpha = 0
	invisibility = INVISIBILITY_MAXIMUM
	anchored = TRUE

/obj/item/radio/beacon/fixed/ex_act(severity)
	return

/obj/item/radio/beacon/fixed/emp_act(severity)
	. = ..()

	return
