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
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	var/locked = FALSE
	var/obj/structure/m_tray/connected = null
	var/tray = /obj/structure/m_tray

/obj/structure/morgue/Destroy()
	if(connected)
		QDEL_NULL(connected)
	return ..()

/obj/structure/morgue/update_icon()
	if(connected)
		icon_state = "morgue0"
	else
		icon_state = "morgue1"
		var/list/searching = get_all_contents_of_type(/mob/living) // Search inside bodybags as well.
		for(var/mob/living/M in searching)
			if(iscarbon(M))
				var/mob/living/carbon/C = M
				if(C.status_flags & FAKEDEATH)
					icon_state = "morgue2"
					break
				switch(C.stat)
					if(DEAD)
						icon_state = "morgue2"
					if(UNCONSCIOUS)
						icon_state = "morgue3"
					if(CONSCIOUS)
						icon_state = "morgue4"
			break
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
	if(connected && !locked)
		for(var/atom/movable/A in connected.loc)
			if(!A.anchored)
				A.forceMove(src)
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		playsound(src, 'sound/effects/roll.ogg', 5, 1)
		QDEL_NULL(connected)
	else
		relaymove(user)
	update_icon()
	return

/obj/structure/morgue/attack_robot(var/mob/user)
	if(Adjacent(user))
		return attack_hand(user)
	else return ..()

/obj/structure/morgue/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.ispen())
		var/t = tgui_input_text(user, "What would you like the label to be?", "Morgue", "", MAX_NAME_LEN)
		if(user.get_active_hand() != attacking_item)
			return
		if((!in_range(src, usr) > 1 && src.loc != user))
			return
		if(t)
			name = "[initial(name)] - '[t]'"
		else
			name = initial(name)
	add_fingerprint(user)
	return

/obj/structure/morgue/relaymove(mob/user)
	if(user.stat || locked)
		return
	var/turf/S = get_step(src, src.dir)
	if(!S)
		return
	else
		if(S.contains_dense_objects())
			to_chat(user, SPAN_WARNING("There's something in the way of \the [src]!"))
			return
	playsound(src, 'sound/effects/roll.ogg', 5, 1)
	playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
	connected = new tray(src.loc)
	step(connected, src.dir)
	connected.layer = OBJ_LAYER - 0.1
	var/turf/T = get_step(src, src.dir)
	if(T.contents.Find(src.connected))
		connected.connected = src
		for(var/atom/movable/A in src)
			A.forceMove(connected.loc)
	else
		QDEL_NULL(connected)
	update_icon()
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
	anchored = TRUE
	throwpass = TRUE
	layer = BELOW_OBJ_LAYER
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	var/obj/structure/morgue/connected = null

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

/obj/structure/m_tray/MouseDrop_T(atom/dropping, mob/user)
	var/atom/movable/O = dropping
	if(!istype(O, /atom/movable) || O.anchored || get_dist(user, src) > 1 || get_dist(user, O) > 1 || user.contents.Find(src) || user.contents.Find(O))
		return
	if(!ismob(O) && !istype(O, /obj/structure/closet/body_bag))
		return
	if(!ismob(user) || user.stat || user.lying || user.stunned)
		return
	O.forceMove(src.loc)
	if(user != O)
		user.visible_message(SPAN_DANGER("<b>[user]</b> stuffs \the [O] into \the [src]!"), SPAN_NOTICE("You stuff \the [O] into \the [src]."), range = 3)
	add_fingerprint(user)
	return
/*
 * Crematorium
 */

/obj/structure/morgue/crematorium
	name = "crematorium"
	desc = "A human incinerator. Works well on barbeque nights."
	icon_state = "crema1"
	dir = SOUTH
	tray = /obj/structure/m_tray/c_tray
	var/cremating = FALSE
	var/id = 1
	var/_wifi_id
	var/datum/wifi/receiver/button/crematorium/wifi_receiver

/obj/structure/morgue/crematorium/Initialize()
	. = ..()
	if(_wifi_id)
		wifi_receiver = new(_wifi_id, src)

/obj/structure/morgue/crematorium/Destroy()
	..()
	if(wifi_receiver)
		QDEL_NULL(wifi_receiver)
	return ..()

/obj/structure/morgue/crematorium/update_icon()
	set_light(0)
	if(cremating)
		icon_state = "crema_active"
		set_light(3, 1, LIGHT_COLOR_FIRE)
		return
	for(var/obj/machinery/button/switch/crematorium/C in range(3, src))
		C.active = FALSE
		C.update_icon()
	if(connected)
		icon_state = "crema0"
	else
		if(contents.len)
			icon_state = "crema2"
		else
			icon_state = "crema1"

/obj/structure/morgue/crematorium/attack_hand(mob/user as mob)
	if(cremating)
		to_chat(user, SPAN_WARNING("It's locked."))
		return
	..()

/obj/structure/morgue/crematorium/proc/cremate(atom/A, mob/user)
	if(cremating)
		return //don't let you cremate something twice or w/e

	cremating = TRUE
	locked = TRUE

	if(contents.len <= 0)
		src.audible_message(SPAN_WARNING("You hear a hollow crackle."), 1)
		flick("crema_empty", src)
		set_light(3, 1, LIGHT_COLOR_FIRE)
		sleep(4)
		cremating = initial(cremating)
		locked = initial(locked)
		update_icon()
		return
	else
		if(length(search_contents_for(/obj/item/disk/nuclear)))
			to_chat(A, SPAN_WARNING("The crematorium buzzes, indicating that something important is inside the crematorium, and must be removed."))
			cremating = initial(cremating)
			locked = initial(locked)
			update_icon()
			return
		src.audible_message(SPAN_WARNING("You hear a roar as \the [src] activates."), 1)
		flick("crema_start", src)
		update_icon()
		var/desperation = 0

		var/list/searching = get_all_contents_of_type(/mob/living)
		for(var/mob/living/M in searching)
			admin_attack_log(A, M, "Began cremating their victim.", "Has begun being cremated.", "began cremating")
			if(iscarbon(M))
				var/mob/living/carbon/C = M
				for(var/I, I < 60, I++)
					C.bodytemperature += 50
					C.adjustFireLoss(20)
					C.adjustBrainLoss(5)

					if(!(C in searching)) //In case we are removed at any point.
						cremating = initial(cremating)
						locked = initial(locked)
						update_icon()
						continue

					sleep(0.5 SECONDS)
					if(prob(40) && (C.stat != DEAD))
						desperation = rand(1,5)
						switch(desperation) //This is messy. A better solution would probably be to make more sounds, but...
							if(1)
								playsound(src.loc, 'sound/weapons/Genhit.ogg', 45, 1)
								shake_animation(2)
								playsound(src.loc, 'sound/weapons/Genhit.ogg', 45, 1)
							if(2)
								playsound(src.loc, 'sound/effects/grillehit.ogg', 45, 1)
								shake_animation(3)
								playsound(src.loc, 'sound/effects/grillehit.ogg', 45, 1)
							if(3)
								playsound(src, 'sound/effects/bang.ogg', 45, 1)
								if(prob(50))
									playsound(src, 'sound/effects/bang.ogg', 45, 1)
									shake_animation()
								else
									shake_animation(5)
							if(4)
								playsound(src, 'sound/effects/clang.ogg', 45, 1)
								shake_animation(5)
							if(5)
								playsound(src, 'sound/weapons/smash.ogg', 50, 1)
								if(prob(50))
									playsound(src, 'sound/weapons/smash.ogg', 50, 1)
									shake_animation(9)
								else
									shake_animation()
					else
						sleep(5)

			if(M.stat == DEAD)
				if(round_is_spooky())
					if(prob(50))
						playsound(src, 'sound/effects/ghost.ogg', 10, 5)
					else
						playsound(src, 'sound/effects/ghost2.ogg', 10, 5)

				admin_attack_log(A, M, "Cremated their victim.", "Was cremated.", "cremated")
				if(desperation)
					M.audible_message("<b>[M]'s</b> screams cease, as does any movement within \the [src]. All that remains is a dull, empty silence.")
				else
					M.audible_message("\The [src] quietly shuts off. All that remains is a dull, empty silence.")
				M.dust()

		for(var/obj/O in contents) //obj instead of obj/item so that bodybags and ashes get destroyed. We dont want tons and tons of ash piling up
			qdel(O)

		var/obj/effect/decal/cleanable/ash/C = new /obj/effect/decal/cleanable/ash(src)
		C.layer = OBJ_LAYER
		sleep(30)
		cremating = initial(cremating)
		locked = initial(locked)
		update_icon()
		playsound(src.loc, 'sound/effects/spray.ogg', 50, 1)
	return

/*
 * Crematorium tray
 */
/obj/structure/m_tray/c_tray
	name = "crematorium tray"
	desc = "Apply body before burning."
	icon_state = "cremat"

/*
 * Crematorium switch
 */

/obj/machinery/button/switch/crematorium
	name = "crematorium igniter"
	desc = "Burn baby burn!"
	req_access = list(ACCESS_CREMATORIUM)
	id = 1
	var/cremate_dir // something for mappers, setting will make a crematorium in one step in this direction toggle

/obj/machinery/button/switch/crematorium/attack_hand(mob/user)
	..()
	if(!allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return

	var/list/obj/structure/morgue/crematorium/crematoriums = list()
	if(!cremate_dir)
		for(var/obj/structure/morgue/crematorium/C in range(3, src))
			if(C.id == id)
				crematoriums += C
	else
		var/turf/T = get_step(src, cremate_dir)
		var/obj/structure/morgue/crematorium/C = locate() in T
		if(C?.id == id)
			crematoriums += C
	for(var/thing in crematoriums)
		var/obj/structure/morgue/crematorium/C = thing
		if(!C.cremating && !C.connected)
			active = TRUE
			update_icon()
			C.cremate(user)
