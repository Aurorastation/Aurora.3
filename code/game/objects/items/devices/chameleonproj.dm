/obj/item/device/chameleon
	name = "chameleon projector"
	desc = "A curious little device in a boxy frame. It has a button on the side."
	desc_antag = "This device can let you disguise as common objects. Click on an object with this in your active hand to scan it, then activate it to use it in your hand."
	icon_state = "shield0"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	item_state = "electronic"
	throwforce = 5
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_ILLEGAL = 4, TECH_MAGNET = 4)
	var/can_use = TRUE
	var/obj/effect/dummy/chameleon/active_dummy = null
	var/saved_item = /obj/item/trash/cigbutt
	var/saved_icon = 'icons/obj/clothing/masks.dmi'
	var/saved_icon_state = "cigbutt"
	var/saved_overlays

/obj/item/device/chameleon/dropped()
	disrupt()
	..()

/obj/item/device/chameleon/equipped()
	disrupt()
	..()

/obj/item/device/chameleon/attack_self()
	toggle()

/obj/item/device/chameleon/afterattack(atom/target, mob/user , proximity)
	if(!proximity)
		return
	if(!active_dummy)
		if(istype(target,/obj/item) && !istype(target, /obj/item/disk/nuclear))
			playsound(get_turf(src), 'sound/weapons/flash.ogg', 100, 1, -6)
			to_chat(user, "<span class='notice'>Scanned [target].</span>")
			saved_item = target.type
			saved_icon = target.icon
			saved_icon_state = target.icon_state
			saved_overlays = target.overlays

/obj/item/device/chameleon/proc/toggle()
	if(!can_use || !saved_item)
		return
	if(active_dummy)
		eject_all()
		playsound(get_turf(src), 'sound/effects/pop.ogg', 100, 1, -6)
		qdel(active_dummy)
		active_dummy = null
		to_chat(usr, "<span class='notice'>You deactivate \the [src].</span>")
		var/obj/effect/overlay/T = new /obj/effect/overlay(get_turf(src))
		T.icon = 'icons/effects/effects.dmi'
		flick("emppulse",T)
		QDEL_IN(T, 8)
	else
		playsound(get_turf(src), 'sound/effects/pop.ogg', 100, 1, -6)
		var/obj/O = new saved_item(src)
		if(!O)
			return
		var/obj/effect/dummy/chameleon/C = new /obj/effect/dummy/chameleon(usr.loc)
		C.activate(O, usr, saved_icon, saved_icon_state, saved_overlays, src)
		qdel(O)
		to_chat(usr, "<span class='notice'>You activate \the [src].</span>")
		var/obj/effect/overlay/T = new/obj/effect/overlay(get_turf(src))
		T.icon = 'icons/effects/effects.dmi'
		flick("emppulse",T)
		QDEL_IN(T, 8)

/obj/item/device/chameleon/proc/disrupt(var/delete_dummy = 1)
	if(active_dummy)
		spark(src, 5)
		eject_all()
		if(delete_dummy)
			qdel(active_dummy)
		active_dummy = null
		can_use = 0
		spawn(50) can_use = 1

/obj/item/device/chameleon/proc/eject_all()
	for(var/atom/movable/A in active_dummy)
		A.forceMove(active_dummy.loc)
		if(ismob(A))
			var/mob/M = A
			M.reset_view(null)

/obj/effect/dummy/chameleon
	name = ""
	desc = ""
	density = FALSE
	anchored = TRUE
	var/can_move = TRUE
	var/obj/item/device/chameleon/master = null

/obj/effect/dummy/chameleon/proc/activate(var/obj/O, var/mob/M, new_icon, new_iconstate, new_overlays, var/obj/item/device/chameleon/C)
	name = O.name
	desc = O.desc
	icon = new_icon
	icon_state = new_iconstate
	overlays = new_overlays
	set_dir(O.dir)
	M.forceMove(src)
	master = C
	master.active_dummy = src

/obj/effect/dummy/chameleon/attackby()
	for(var/mob/M in src)
		to_chat(M, "<span class='warning'>Your chameleon-projector deactivates.</span>")
	master.disrupt()

/obj/effect/dummy/chameleon/attack_hand()
	for(var/mob/M in src)
		to_chat(M, "<span class='warning'>Your chameleon-projector deactivates.</span>")
	master.disrupt()

/obj/effect/dummy/chameleon/ex_act(var/severity = 2.0)
	for(var/mob/M in src)
		to_chat(M, "<span class='warning'>Your chameleon-projector deactivates.</span>")
	master.disrupt()

/obj/effect/dummy/chameleon/bullet_act()
	for(var/mob/M in src)
		to_chat(M, "<span class='warning'>Your chameleon-projector deactivates.</span>")
	..()
	master.disrupt()

/obj/effect/dummy/chameleon/relaymove(var/mob/user, direction)
	if(istype(loc, /turf/space)) return //No magical space movement!

	if(can_move)
		can_move = 0
		switch(user.bodytemperature)
			if(300 to INFINITY)
				spawn(10) can_move = 1
			if(295 to 300)
				spawn(13) can_move = 1
			if(280 to 295)
				spawn(16) can_move = 1
			if(260 to 280)
				spawn(20) can_move = 1
			else
				spawn(25) can_move = 1
		step(src, direction)
	return

/obj/effect/dummy/chameleon/Destroy()
	master.disrupt(0)
	return ..()

/obj/item/device/mirage
	name = "mirage projector"
	desc = "A curious little device in a boxy frame. It has a button on the side."
	desc_antag = "This device summons a hardlight version of the user to activate it, before cloaking itself."
	icon_state = "shield0"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	item_state = "electronic"
	throwforce = 5
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_ILLEGAL = 4, TECH_MAGNET = 4)
	var/ready = TRUE
	var/cooldown = 1 MINUTE
	var/held_maptext = null
	var/obj/effect/dummy/mirage/mirage

/obj/item/device/mirage/Initialize()
	. = ..()
	held_maptext = SMALL_FONTS(7, "Ready")
	if(get(loc, /mob))
		maptext = held_maptext

/obj/item/device/mirage/proc/check_maptext(var/new_maptext)
	if(new_maptext)
		held_maptext = new_maptext
	if(ismob(loc) || ismob(loc.loc))
		maptext = held_maptext
	else
		maptext = ""

/obj/item/device/mirage/attack_self(mob/user)
	if(!ready)
		to_chat(user, SPAN_WARNING("\The [src] isn't ready to be used again!"))
		return
	activate(user)

/obj/item/device/mirage/AltClick(mob/user)
	if(use_check_and_message(user, USE_ALLOW_INCAPACITATED)) // this is to allow people to activate it while lying down to appear distressed
		return
	if(!ready)
		to_chat(user, SPAN_WARNING("\The [src] isn't ready to be used again!"))
		return
	if(!(isturf(loc) || loc == user))
		to_chat(user, SPAN_WARNING("\The [src] must be directly on your person or on the ground before you can use it!"))
		return
	activate(user)

/obj/item/device/mirage/proc/activate(var/mob/user)
	if(!ready)
		return
	to_chat(user, SPAN_NOTICE("You activate \the [src]."))
	if(loc == user)
		user.drop_from_inventory(src, get_turf(user))
	ready = FALSE
	check_maptext(SMALL_FONTS(6, "Charge"))
	addtimer(CALLBACK(src, .proc/recharge), cooldown)
	mouse_opacity = 0
	mirage = new /obj/effect/dummy/mirage(loc, user, src)
	animate(src, alpha = 0, time = 3 SECONDS)

/obj/item/device/mirage/dropped(mob/user)
	..()
	check_maptext()

/obj/item/device/mirage/throw_at()
	..()
	check_maptext()

/obj/item/device/mirage/on_give()
	check_maptext()

/obj/item/device/mirage/pickup()
	..()
	addtimer(CALLBACK(src, .proc/check_maptext), 1) // invoke async does not work here

/obj/item/device/mirage/proc/disrupt()
	if(mirage)
		QDEL_NULL(mirage)
	spark(src, 5)
	alpha = initial(alpha)
	mouse_opacity = initial(mouse_opacity)

/obj/item/device/mirage/proc/recharge()
	ready = TRUE
	check_maptext(SMALL_FONTS(7, "Ready"))

/obj/item/device/mirage/Destroy()
	disrupt()
	return ..()

/obj/effect/dummy/mirage
	var/mob/living/carbon/human/dummy/mannequin/form
	var/obj/item/device/mirage/parent

/obj/effect/dummy/mirage/Initialize(mapload, var/mob/living/carbon/human/user, var/obj/item/device/mirage/source)
	. = ..()
	parent = source
	appearance = user.appearance
	dir = user.dir
	if(istype(user))
		form = new /mob/living/carbon/human/dummy/mannequin(src)
		form.copy_appearance(user)
	alpha = 0
	animate(src, alpha = 255, time = 3 SECONDS)

/obj/effect/dummy/mirage/examine(mob/user)
	if(form)
		form.examine(user)
		return
	return ..()

/obj/effect/dummy/mirage/attack_hand(mob/living/user)
	parent.disrupt()

/obj/effect/dummy/mirage/attackby(obj/item/I, mob/user)
	parent.disrupt()

/obj/effect/dummy/mirage/Destroy()
	QDEL_NULL(form)
	parent = null
	return ..()