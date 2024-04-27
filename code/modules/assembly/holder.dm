/obj/item/device/assembly_holder
	name = "Assembly"
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	icon_state = "holder"
	item_state = "assembly"
	obj_flags = OBJ_FLAG_CONDUCTABLE
	movable_flags = MOVABLE_FLAG_PROXMOVE
	throwforce = 5
	w_class = ITEMSIZE_SMALL
	throw_speed = 3
	throw_range = 10

	var/secured = FALSE
	var/obj/item/device/assembly/a_left = null
	var/obj/item/device/assembly/a_right = null
	var/obj/special_assembly = null

/obj/item/device/assembly_holder/Initialize(mapload, ...)
	. = ..()
	become_hearing_sensitive()

/obj/item/device/assembly_holder/Destroy()
	lose_hearing_sensitivity()

	QDEL_NULL(a_left)
	QDEL_NULL(a_right)
	QDEL_NULL(special_assembly)

	. = ..()

/obj/item/device/assembly_holder/proc/detached()
	if(a_left)
		a_left.holder_movement()
	if(a_right)
		a_right.holder_movement()
	return

/obj/item/device/assembly_holder/IsAssemblyHolder()
	return TRUE

/obj/item/device/assembly_holder/proc/attach(var/obj/item/device/assembly/D, var/obj/item/device/assembly/D2, var/mob/user)
	if(!istype(D) || !istype(D2))
		return FALSE
	if(D.secured || D2.secured)
		return FALSE
	if(user)
		user.remove_from_mob(D)
		user.remove_from_mob(D2)
	D.holder = src
	D2.holder = src
	D.forceMove(src)
	D2.forceMove(src)
	a_left = D
	a_right = D2
	name = "[D.name]-[D2.name] assembly"
	update_icon()
	user.put_in_hands(src)
	return TRUE

/obj/item/device/assembly_holder/proc/attach_special(var/obj/O, var/mob/user)
	if(!O)
		return
	if(!O.IsSpecialAssembly())
		return FALSE

/obj/item/device/assembly_holder/update_icon()
	cut_overlays()
	if(a_left)
		add_overlay("[a_left.icon_state]_left")
		for(var/O in a_left.attached_overlays)
			add_overlay("[O]_l")
	if(a_right)
		add_overlay("[a_right.icon_state]_right")
		for(var/O in a_right.attached_overlays)
			add_overlay("[O]_r")
	if(master)
		master.update_icon()

/obj/item/device/assembly_holder/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(distance <= 1 || src.loc == user)
		if (src.secured)
			. += SPAN_NOTICE("\The [src] is ready!")
		else
			. += SPAN_NOTICE("\The [src] can be attached!")

/obj/item/device/assembly_holder/HasProximity(atom/movable/AM as mob|obj)
	if(a_left)
		a_left.HasProximity(AM)
	if(a_right)
		a_right.HasProximity(AM)
	if(special_assembly)
		special_assembly.HasProximity(AM)

/obj/item/device/assembly_holder/Crossed(atom/movable/AM as mob|obj)
	if(a_left)
		a_left.Crossed(AM)
	if(a_right)
		a_right.Crossed(AM)
	if(special_assembly)
		special_assembly.Crossed(AM)

/obj/item/device/assembly_holder/on_found(mob/finder)
	if(a_left)
		a_left.on_found(finder)
	if(a_right)
		a_right.on_found(finder)
	if(special_assembly)
		if(istype(special_assembly, /obj/item))
			var/obj/item/S = special_assembly
			S.on_found(finder)

/obj/item/device/assembly_holder/Move()
	. = ..()
	if(a_left && a_right)
		a_left.holder_movement()
		a_right.holder_movement()


/obj/item/device/assembly_holder/attack_hand()//Perhapse this should be a holder_pickup proc instead, can add if needbe I guess
	if(a_left && a_right)
		a_left.holder_movement()
		a_right.holder_movement()
	return ..()

/obj/item/device/assembly_holder/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.isscrewdriver())
		if(!a_left || !a_right)
			to_chat(user, SPAN_DANGER("BUG: Assembly part missing, please report this!"))
			return
		a_left.toggle_secure()
		a_right.toggle_secure()
		secured = !secured
		if(secured)
			to_chat(user, SPAN_NOTICE("\The [src] is ready!"))
		else
			to_chat(user, SPAN_NOTICE("\The [src] can now be taken apart!"))
		update_icon()
		return
	else if(attacking_item.IsSpecialAssembly())
		attach_special(attacking_item, user)
	else
		return ..()

/obj/item/device/assembly_holder/attack_self(mob/user)
	add_fingerprint(user)
	if(secured)
		if(!a_left || !a_right)
			to_chat(user, SPAN_WARNING("Assembly part missing!"))
			return
		if(istype(a_left, a_right.type)) //If they are the same type it causes issues due to window code
			switch(alert("Which side would you like to use?",,"Left","Right"))
				if("Left")
					a_left.attack_self(user)
				if("Right")
					a_right.attack_self(user)
			return
		else
			if(!istype(a_left, /obj/item/device/assembly/igniter))
				a_left.attack_self(user)
			if(!istype(a_right, /obj/item/device/assembly/igniter))
				a_right.attack_self(user)
	else
		var/turf/T = get_turf(src)
		if(!T)
			return FALSE

		if(a_left)
			a_left.holder = null
			a_left.forceMove(T)
			a_left = null

		if(a_right)
			a_right.holder = null
			a_right.forceMove(T)
			a_right = null

		qdel(src)


/obj/item/device/assembly_holder/proc/process_activation(var/obj/D, var/normal = 1, var/special = 1)
	if(!D)
		return FALSE
	if(!secured)
		audible_message("[icon2html(src, viewers(get_turf(src)))] *beep* *beep*", "*beep* *beep*")
	if(normal && a_right && a_left)
		if(a_right != D)
			a_right.pulsed(FALSE)
		if(a_left != D)
			a_left.pulsed(FALSE)
	if(master)
		master.receive_signal()
	return TRUE

/obj/item/device/assembly_holder/hear_talk(mob/living/M, msg, verb, datum/language/speaking)
	if(a_right)
		a_right.hear_talk(M, msg, verb, speaking)
	if(a_left)
		a_left.hear_talk(M, msg, verb, speaking)

/obj/item/device/assembly_holder/timer_igniter
	name = "timer-igniter assembly"

/obj/item/device/assembly_holder/timer_igniter/Initialize(mapload, ...)
	. = ..()

	var/obj/item/device/assembly/igniter/ign = new(src)
	ign.secured = TRUE
	ign.holder = src
	var/obj/item/device/assembly/timer/tmr = new(src)
	tmr.time = 5
	tmr.secured = TRUE
	tmr.holder = src
	START_PROCESSING(SSprocessing, tmr)
	a_left = tmr
	a_right = ign
	secured = TRUE
	update_icon()
	name = "[initial(name)] ([tmr.time] secs)"

	loc.verbs += /obj/item/device/assembly_holder/timer_igniter/verb/configure

/obj/item/device/assembly_holder/timer_igniter/detached()
	loc.verbs -= /obj/item/device/assembly_holder/timer_igniter/verb/configure
	..()

/obj/item/device/assembly_holder/timer_igniter/verb/configure()
	set name = "Set Timer"
	set category = "Object"
	set src in usr

	if(!(usr.stat || usr.restrained()))
		var/obj/item/device/assembly_holder/holder
		if(istype(src,/obj/item/grenade/chem_grenade))
			var/obj/item/grenade/chem_grenade/gren = src
			holder = gren.detonator
		var/obj/item/device/assembly/timer/tmr = holder.a_left
		if(!istype(tmr, /obj/item/device/assembly/timer))
			tmr = holder.a_right
		if(!istype(tmr, /obj/item/device/assembly/timer))
			to_chat(usr, SPAN_WARNING("This detonator has no timer."))
			return

		if(tmr.timing)
			to_chat(usr, SPAN_WARNING("The timer has already been activated."))
		else
			var/ntime = input("Enter desired time in seconds", "Time", "5") as num
			ntime = clamp(ntime, 5, 1000)
			tmr.time = ntime
			name = "[initial(name)] ([tmr.time] secs)"
			to_chat(usr, SPAN_NOTICE("Timer set to [tmr.time] seconds."))
	else
		to_chat(usr, SPAN_WARNING("You cannot do this while [usr.stat ? "unconscious/dead" : "restrained"]."))
