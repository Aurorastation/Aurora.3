/* Morgue stuff
 * Contains:
 *		Morgue
 *		Morgue trays
 *		Crematorium
 *		Crematorium trays
 */

/*
 * Morgue
 */

/obj/structure/morgue
	name = "morgue"
	desc = "Used to keep bodies in until someone fetches them."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "morgue1"
	dir = EAST
	density = TRUE
	anchored = TRUE
	var/obj/structure/m_tray/connected = null

/obj/structure/morgue/Destroy()
	if(connected)
		QDEL_NULL(connected)
	return ..()

/obj/structure/morgue/update_icon()
	if(connected)
		icon_state = "morgue0"
	else
		if(contents.len)
			icon_state = "morgue2"
		else
			icon_state = "morgue1"
	return

/obj/structure/morgue/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A in src)
				A.forceMove(src.loc)
				ex_act(severity)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				for(var/atom/movable/A in src)
					A.forceMove(src.loc)
					ex_act(severity)
				qdel(src)
				return
		if(3.0)
			if(prob(5))
				for(var/atom/movable/A in src)
					A.forceMove(src.loc)
					ex_act(severity)
				qdel(src)
				return
	return

/obj/structure/morgue/attack_hand(mob/user)
	if(connected)
		for(var/atom/movable/A in connected.loc)
			if(!A.anchored)
				A.forceMove(src)
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		playsound(src, 'sound/effects/roll.ogg', 5, 1)
		QDEL_NULL(connected)
	else
		var/turf/S = get_step(src, src.dir)
		if(!S)
			return
		else
			if(S.contains_dense_objects())
				to_chat(user, SPAN_WARNING("There's something in the way of \the [src]!"))
				return
		playsound(src, 'sound/effects/roll.ogg', 5, 1)
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		connected = new /obj/structure/m_tray(src.loc)
		step(src.connected, src.dir)
		connected.layer = OBJ_LAYER - 0.1
		var/turf/T = get_step(src, src.dir)
		if(T.contents.Find(connected))
			connected.connected = src
			icon_state = "morgue0"
			for(var/atom/movable/A in src)
				A.forceMove(connected.loc)
			connected.icon_state = "morguet"
			connected.set_dir(src.dir)
		else
			QDEL_NULL(connected)
	add_fingerprint(user)
	update_icon()
	return

/obj/structure/morgue/attack_robot(var/mob/user)
	if(Adjacent(user))
		return attack_hand(user)
	else return ..()

/obj/structure/morgue/attackby(obj/P, mob/user)
	if(P.ispen())
		var/t = input(user, "What would you like the label to be?", text("[]", src.name), null)  as text
		if(user.get_active_hand() != P)
			return
		if((!in_range(src, usr) && src.loc != user))
			return
		t = sanitizeSafe(t, MAX_NAME_LEN)
		if(t)
			name = "Morgue- '[t]'"
		else
			name = "Morgue"
	add_fingerprint(user)
	return

/obj/structure/morgue/relaymove(mob/user)
	if(user.stat)
		return
	var/turf/S = get_step(src, src.dir)
	if(!S)
		return
	else
		if(S.contains_dense_objects())
			to_chat(user, SPAN_WARNING("There's something in the way of \the [src]!"))
			return
	connected = new /obj/structure/m_tray(src.loc)
	step(connected, EAST)
	connected.layer = OBJ_LAYER - 0.1
	var/turf/T = get_step(src, EAST)
	if(T.contents.Find(src.connected))
		connected.connected = src
		icon_state = "morgue0"
		for(var/atom/movable/A in src)
			A.forceMove(connected.loc)
		connected.icon_state = "morguet"
	else
		QDEL_NULL(connected)
	return


/*
 * Morgue tray
 */
/obj/structure/m_tray
	name = "morgue tray"
	desc = "Apply corpse before closing."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "morguet"
	density = TRUE
	layer = 2.0
	var/obj/structure/morgue/connected = null
	anchored = TRUE
	throwpass = TRUE

/obj/structure/m_tray/Destroy()
	if(connected?.connected == src)
		connected.connected = null
	connected = null
	return ..()

/obj/structure/m_tray/attack_hand(mob/user)
	if(connected)
		for(var/atom/movable/A in src.loc)
			if(!A.anchored)
				A.forceMove(connected)
		connected.connected = null
		connected.update_icon()
		add_fingerprint(user)
		qdel(src)
		return
	return

/obj/structure/m_tray/MouseDrop_T(atom/movable/O, mob/user )
	if(!istype(O, /atom/movable) || O.anchored || get_dist(user, src) > 1 || get_dist(user, O) > 1 || user.contents.Find(src) || user.contents.Find(O))
		return
	if(!ismob(O) && !istype(O, /obj/structure/closet/body_bag))
		return
	if(!ismob(user) || user.stat || user.lying || user.stunned)
		return
	O.forceMove(src.loc)
	if(user != O)
		user.visible_message("<b>[user]</b> stuffs \the [O] into \the [src]!", SPAN_NOTICE("You stuff \the [O] into \the [src]."), range = 3)

/*
 * Crematorium
 */

/obj/structure/crematorium
	name = "crematorium"
	desc = "A human incinerator. Works well on barbeque nights."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "crema1"
	density = TRUE
	anchored = TRUE
	var/obj/structure/c_tray/connected = null
	var/cremating = FALSE
	var/locked = FALSE
	var/id = 1
	var/_wifi_id
	var/datum/wifi/receiver/button/crematorium/wifi_receiver

/obj/structure/crematorium/Initialize()
	. = ..()
	if(_wifi_id)
		wifi_receiver = new(_wifi_id, src)

/obj/structure/crematorium/Destroy()
	if(connected)
		QDEL_NULL(connected)
	if(wifi_receiver)
		QDEL_NULL(wifi_receiver)
	return ..()

/obj/structure/crematorium/update_icon()
	if(cremating)
		icon_state = "crema_active"
		return
	if(connected)
		icon_state = "crema0"
	else
		if(contents.len)
			icon_state = "crema2"
		else
			icon_state = "crema1"

/obj/structure/crematorium/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A in src)
				A.forceMove(src.loc)
				ex_act(severity)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				for(var/atom/movable/A in src)
					A.forceMove(src.loc)
					ex_act(severity)
				qdel(src)
				return
		if(3.0)
			if(prob(5))
				for(var/atom/movable/A in src)
					A.forceMove(src.loc)
					ex_act(severity)
				qdel(src)
				return
	return

/obj/structure/crematorium/attack_hand(mob/user as mob)
	if(cremating)
		to_chat(user, SPAN_WARNING("It's locked."))
		return
	if(connected && !locked)
		for(var/atom/movable/A in connected.loc)
			if(!A.anchored )
				A.forceMove(src)
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		qdel(connected)
	else if(!locked)
		var/turf/S = get_step(src, src.dir)
		if(!S)
			return
		else
			if(S.contains_dense_objects())
				to_chat(user, SPAN_WARNING("There's something in the way of \the [src]!"))
				return
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		connected = new /obj/structure/c_tray(src.loc)
		step(connected, src.dir)
		connected.layer = OBJ_LAYER - 0.1
		var/turf/T = get_step(src, src.dir)
		if(T.contents.Find(connected))
			connected.connected = src
			src.icon_state = "crema0"
			for(var/atom/movable/A in src)
				A.forceMove(connected.loc)
			connected.icon_state = "cremat"
		else
			qdel(src.connected)
	add_fingerprint(user)
	update_icon()

/obj/structure/crematorium/attackby(obj/P, mob/user as mob)
	if(P.ispen())
		var/t = input(user, "What would you like the label to be?", "[src.name]") as text
		if(user.get_active_hand() != P)
			return
		if((!in_range(src, usr) > 1 && src.loc != user))
			return
		t = sanitizeSafe(t, MAX_NAME_LEN)
		if(t)
			name = "Crematorium- '[t]'"
		else
			name = "Crematorium"
	add_fingerprint(user)
	return

/obj/structure/crematorium/relaymove(mob/user)
	if(user.stat || locked)
		return
	var/turf/S = get_step(src, src.dir)
	if(!S)
		return
	else
		if(S.contains_dense_objects())
			to_chat(user, SPAN_WARNING("There's something in the way of \the [src]!"))
			return
	connected = new /obj/structure/c_tray(src.loc)
	step(connected, src.dir)
	connected.layer = OBJ_LAYER - 0.1
	var/turf/T = get_step(src, src.dir)
	if(T.contents.Find(src.connected))
		connected.connected = src
		icon_state = "crema0"
		for(var/atom/movable/A in src)
			A.forceMove(connected.loc)
		connected.icon_state = "cremat"
	else
		QDEL_NULL(connected)
	return

/obj/structure/crematorium/proc/cremate(atom/A, mob/user)
	if(cremating)
		return

	if(contents.len <= 0)
		visible_message(SPAN_WARNING("You hear a hollow crackle coming from \the [src]."), range = 3)
	else
		visible_message(SPAN_WARNING("You hear a roar as \the [src] activates."))
		cremating = TRUE
		locked = TRUE
		update_icon()

		for(var/mob/living/M in contents)
			if(M.stat < UNCONSCIOUS)
				if(!iscarbon(M))
					M.emote("scream")
				else
					var/mob/living/carbon/C = M
					if(C.can_feel_pain())
						C.emote("scream")
			M.death(1)
			M.ghostize()
			qdel(M)

		for(var/obj/O in contents) //obj instead of obj/item so that bodybags and ashes get destroyed. We dont want tons and tons of ash piling up
			qdel(O)

		var/obj/effect/decal/cleanable/ash/F = new /obj/effect/decal/cleanable/ash(src)
		F.layer = OBJ_LAYER
		sleep(30)
		cremating = FALSE
		locked = FALSE
		update_icon()
		playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
	return


/*
 * Crematorium tray
 */
/obj/structure/c_tray
	name = "crematorium tray"
	desc = "Apply body before burning."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "cremat"
	density = TRUE
	anchored = TRUE
	throwpass = TRUE
	layer = 2.0
	var/obj/structure/crematorium/connected = null

/obj/structure/c_tray/Destroy()
	if(connected?.connected == src)
		connected.connected = null
	connected = null
	return ..()

/obj/structure/c_tray/attack_hand(mob/user)
	if(connected)
		for(var/atom/movable/A in src.loc)
			if(!A.anchored)
				A.forceMove(src.connected)
		connected.connected = null
		connected.update_icon()
		add_fingerprint(user)
		qdel(src)
		return
	return

/obj/structure/c_tray/MouseDrop_T(atom/movable/O, mob/user)
	if(!istype(O, /atom/movable) || O.anchored || get_dist(user, src) > 1 || get_dist(user, O) > 1 || user.contents.Find(src) || user.contents.Find(O))
		return
	if(!ismob(O) && !istype(O, /obj/structure/closet/body_bag))
		return
	if(!ismob(user) || user.stat || user.lying || user.stunned)
		return
	O.forceMove(src.loc)
	if(user != O)
		user.visible_message("<b>[user]</b> stuffs \the [O] into \the [src]!", SPAN_NOTICE("You stuff \the [O] into \the [src]."), range = 3)
	return

/obj/machinery/button/crematorium
	name = "crematorium igniter"
	desc = "Burn baby burn!"
	icon = 'icons/obj/power.dmi'
	icon_state = "crema_switch"
	req_access = list(access_crematorium)
	id = 1
	var/cremate_dir // something for mappers, setting will make a crematorium in one step in this direction toggle

/obj/machinery/button/crematorium/update_icon()
	return

/obj/machinery/button/crematorium/attack_hand(mob/user)
	if(!allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return
	if(..())
		return

	var/list/obj/structure/crematorium/crematoriums = list()
	if(!cremate_dir)
		for(var/obj/structure/crematorium/C in range(3, src))
			if(C.id == id)
				crematoriums += C
	else
		var/turf/T = get_step(src, cremate_dir)
		var/obj/structure/crematorium/C = locate() in T
		if(C?.id == id)
			crematoriums += C
	for(var/thing in crematoriums)
		var/obj/structure/crematorium/C = thing
		if(!C.cremating)
			C.cremate(user)