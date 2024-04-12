#define STATUS_INACTIVE 0
#define STATUS_ACTIVE 1
#define STATUS_BROKEN -1

#define LAYER_ATTACHED 3.2
#define LAYER_NORMAL 3

/obj/item/device/magnetic_lock
	name = "magnetic door lock"
	desc = "A large, ID locked device used for completely locking down airlocks."
	icon = 'icons/obj/magnetic_locks.dmi'
	icon_state = "inactive_CENTCOM"
	//icon_state = "inactive"
	w_class = ITEMSIZE_NORMAL
	req_access = list(ACCESS_CENT_SPECOPS)
	health = 150

	var/department = "CENTCOM"
	var/status = 0
	var/locked = 1
	var/hacked = 0
	var/invincible = FALSE
	var/processpower = TRUE
	var/constructionstate = 0
	var/drain_per_second = 3
	var/last_process_time = 0
	var/obj/machinery/door/airlock/target_node1 = null
	var/obj/machinery/door/airlock/target_node2 = null
	var/obj/machinery/door/airlock/target = null
	var/obj/item/cell/powercell

/obj/item/device/magnetic_lock/security
	department = "Security"
	icon_state = "inactive_Security"
	req_access = list(ACCESS_SECURITY)

/obj/item/device/magnetic_lock/engineering
	department = "Engineering"
	icon_state = "inactive_Engineering"
	req_access = null
	req_one_access = list(ACCESS_ENGINE_EQUIP, ACCESS_ATMOSPHERICS)

/obj/item/device/magnetic_lock/security/legion
	name = "legion magnetic door lock"
	req_access = null
	req_one_access = list(ACCESS_LEGION, ACCESS_TCAF_SHIPS)
	w_class = ITEMSIZE_SMALL

/obj/item/device/magnetic_lock/security/legion/Initialize()
	. = ..()
	desc = "A large, ID locked device used for completely locking down airlocks. This one carries the insignia of the Tau Ceti Foreign Legion."

/obj/item/device/magnetic_lock/Initialize()
	. = ..()

	powercell = new /obj/item/cell/high()

	if (istext(department))
		desc += " It is painted with [department] colors."

	update_icon()
	var/obj/machinery/door/airlock/newtarget = (locate(/obj/machinery/door/airlock) in get_turf(src))
	if(newtarget)
		var/direction = reverse_direction(dir)
		forceMove(get_step(newtarget.loc, reverse_direction(direction)))
		for (var/obj/machinery/door/airlock/A in oview(1, newtarget))
			var/rdir = get_dir(newtarget, A)
			if (istype(A, newtarget.type) && (rdir == turn(direction, -90) || rdir == turn(direction, 90)))
				if(!target_node1)
					target_node1 = A
					target_node1.bracer = src
				else
					target_node2 = A
					target_node2.bracer = src

		status = STATUS_ACTIVE
		attach(newtarget)

/obj/item/device/magnetic_lock/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()

	if (status == STATUS_BROKEN)
		. += "<span class='danger'>It looks broken!</span>"
	else
		if (powercell)
			var/power = round(powercell.charge / powercell.maxcharge * 100)
			. += "<span class='notice'>The powercell is at [power]% charge.</span>"
		else
			. += "<span class='warning'>It has no powercell to power it!"

/obj/item/device/magnetic_lock/attack_hand(var/mob/user)
	add_fingerprint(user)
	if (constructionstate == 1 && powercell)
		powercell.update_icon()
		powercell.add_fingerprint(user)
		user.put_in_active_hand(powercell)
		to_chat(user, "You remove \the [powercell].")
		powercell = null
		setconstructionstate(2)
		return TRUE
	else if (anchored)
		if (!locked)
			detach()
			return TRUE
		else
			to_chat(user, "<span class='warning'>\The [src] is locked in place!</span>")
	else
		..()

/obj/item/device/magnetic_lock/bullet_act(var/obj/item/projectile/Proj)
	takedamage(Proj.damage)
	..()

/obj/item/device/magnetic_lock/attackby(obj/item/attacking_item, mob/user)
	if (status == STATUS_BROKEN)
		to_chat(user, "<span class='danger'>[src] is broken beyond repair!</span>")
		return TRUE

	if (istype(attacking_item, /obj/item/card/id))
		if (!constructionstate && !hacked)
			if (check_access(attacking_item))
				locked = !locked
				playsound(src, 'sound/machines/ping.ogg', 30, 1)
				var/msg = "[attacking_item] through \the [src] and it [locked ? "locks" : "unlocks"] with a beep."
				var/pos_adj = "[user.name] swipes [user.get_pronoun("his")] "
				var/fp_adj = "You swipe your "
				user.visible_message("<span class='warning'>[addtext(pos_adj, msg)]</span>", "<span class='notice'>[addtext(fp_adj, msg)]</span>")
				update_icon()
			else
				playsound(src, 'sound/machines/buzz-sigh.ogg', 30, 1)
				to_chat(user, SPAN_WARNING("\The [src] buzzes as you swipe your [attacking_item]."))
				return
		else
			to_chat(user, "<span class='danger'>You cannot swipe your [attacking_item] through [src] with it partially dismantled!</span>")
		return TRUE

	if (istype(attacking_item, /obj/item) && user.a_intent == "harm")
		if (attacking_item.force >= 18)
			user.visible_message("<span class='danger'>[user] bashes [src] with [attacking_item]!</span>", "<span class='danger'>You strike [src] with [attacking_item], damaging it!</span>")
			takedamage(attacking_item.force)
			var/sound_to_play = pick(list('sound/weapons/genhit1.ogg', 'sound/weapons/genhit2.ogg', 'sound/weapons/genhit3.ogg'))
			playsound(loc, sound_to_play, attacking_item.force*3, 1)
			sound_to_play = pick(list('sound/effects/sparks1.ogg', 'sound/effects/sparks2.ogg', 'sound/effects/sparks3.ogg', 'sound/effects/sparks4.ogg'))
			addtimer(CALLBACK(GLOBAL_PROC, /proc/playsound, loc, sound_to_play, 30, 1), 3, TIMER_CLIENT_TIME)
		else
			user.visible_message("<span class='danger'>[user] hits [src] with [attacking_item] but fails to damage it.</span>", "<span class='warning'>You hit [src] with [attacking_item], [attacking_item.force >= 10 ? "and it almost makes a dent!" : "but it appears to have no visible effect."]</span>")
			playsound(loc, 'sound/weapons/Genhit.ogg', attacking_item.force*2.5, 1)
		return TRUE

	if(invincible)
		return TRUE
	switch (constructionstate)
		if (0)
			if (istype(attacking_item, /obj/item/card/emag))
				var/obj/item/card/emag/emagcard = attacking_item
				emagcard.uses--
				visible_message("<span class='danger'>[src] sparks and falls off the door!</span>", "<span class='danger'>You emag [src], frying its circuitry[status == STATUS_ACTIVE ? " and making it drop onto the floor" : ""]!</span>")

				status = STATUS_BROKEN
				if (target)
					detach()
					update_icon()
				return TRUE

			if (attacking_item.iswelder())
				var/obj/item/weldingtool/WT = attacking_item
				if (WT.use(2, user))
					user.visible_message(SPAN_NOTICE("[user] starts welding the metal shell of [src]."), SPAN_NOTICE("You start [hacked ? "repairing" : "welding open"] the metal covering of [src]."))
					playsound(loc, 'sound/items/Welder.ogg', 50, 1)
					add_overlay("overlay_welding")
					if(WT.use_tool(src, user, 25, volume = 50))
						to_chat(user, SPAN_NOTICE("You are able to [hacked ? "repair" : "weld through"] the metal shell of [src]."))
						if (hacked) locked = 1
						else locked = 0
						hacked = !hacked
						cut_overlay("overlay_welding")
					else
						cut_overlay("overlay_welding")
					update_icon()
				return TRUE

			if (attacking_item.iscrowbar())
				if (!locked)
					to_chat(user, SPAN_NOTICE("You pry the cover off [src]."))
					setconstructionstate(1)
				else
					to_chat(user, SPAN_NOTICE("You try to pry the cover off [src] but it doesn't budge."))
				return TRUE

		if (1)
			if (istype(attacking_item, /obj/item/cell))
				if (powercell)
					to_chat(user, SPAN_NOTICE("There's already a powercell in \the [src]."))
				return TRUE

			if (attacking_item.iscrowbar())
				to_chat(user, SPAN_NOTICE("You wedge the cover back in place."))
				setconstructionstate(0)
				return TRUE

		if (2)
			if (attacking_item.isscrewdriver())
				to_chat(user, SPAN_NOTICE("You unscrew and remove the wiring cover from \the [src]."))
				attacking_item.play_tool_sound(get_turf(src), 50)
				setconstructionstate(3)
				return TRUE

			if (attacking_item.iscrowbar())
				to_chat(user, SPAN_NOTICE("You wedge the cover back in place."))
				setconstructionstate(0)
				return TRUE

			if (istype(attacking_item, /obj/item/cell))
				if (!powercell)
					to_chat(user, SPAN_NOTICE("You place the [attacking_item] inside \the [src]."))
					user.drop_from_inventory(attacking_item,src)
					powercell = attacking_item
					setconstructionstate(1)
				return TRUE

		if (3)
			if (attacking_item.iswirecutter())
				to_chat(user, SPAN_NOTICE("You cut the wires connecting the [src]'s magnets to their internal powersupply, [target ? "making the device fall off [target] and rendering it unusable." : "rendering the device unusable."]"))
				playsound(loc, 'sound/items/Wirecutter.ogg', 50, 1)
				setconstructionstate(4)
				return TRUE

			if (attacking_item.isscrewdriver())
				to_chat(user, SPAN_NOTICE("You replace and screw tight the wiring cover from \the [src]."))
				attacking_item.play_tool_sound(get_turf(src), 50)
				setconstructionstate(2)
				return TRUE

		if (4)
			if (attacking_item.iswirecutter())
				to_chat(user, SPAN_NOTICE("You repair the wires connecting the [src]'s magnets to their internal powersupply"))
				setconstructionstate(3)
				return TRUE

/obj/item/device/magnetic_lock/process()
	if(!processpower)
		return
	var/obj/item/cell/C = powercell
	var/delta_sec = (world.time - last_process_time) / 10
	var/drainamount = drain_per_second * delta_sec
	if (C)
		if (C.charge > drainamount)
			C.charge -= drainamount
		else
			C.charge = 0
			visible_message(SPAN_DANGER("[src] beeps loudly and falls off \the [target]; its powercell having run out of power."))
			detach(0)
	if (!C)
		visible_message(SPAN_DANGER("[src] gives two shrill beeps and falls off \the [target]. No cell appears to be installed."))
		detach(0)
	last_process_time = world.time

/obj/item/device/magnetic_lock/proc/check_target(var/obj/machinery/door/airlock/newtarget, var/mob/user as mob)
	if (status == STATUS_BROKEN)
		to_chat(user, SPAN_DANGER("[src] is damaged beyond repair! It cannot be used!"))
		return 0

	if (hacked)
		to_chat(user, SPAN_DANGER("[src] buzzes; it can't be used until you repair it!"))
		return 0

	if (!newtarget.density || newtarget.operating)
		to_chat(user, SPAN_DANGER("[newtarget] must be closed before you can attach [src] to it!"))
		return 0

	if (newtarget.p_open)
		to_chat(user, SPAN_DANGER("You must close [newtarget]'s maintenance panel before attaching [src] to it!"))
		return 0

	if (!user.Adjacent(newtarget))
		to_chat(user, SPAN_DANGER("You must stand next to [newtarget] while attaching it!"))
		return 0

	return 1

/obj/item/device/magnetic_lock/proc/attachto(var/obj/machinery/door/airlock/newtarget, var/mob/user as mob)
	if (!check_target(newtarget, user)) return

	user.visible_message("<span class='notice'>[user] starts mounting [src] onto [newtarget].</span>", "<span class='notice'>You begin mounting [src] onto [newtarget].</span>")

	if (do_after(user, 3.5 SECONDS))

		if (!check_target(newtarget, user)) return

		if(powercell)
			if(!powercell.charge)
				to_chat(user, "<span class='warning'>\The [src] is clearly out of power.</span>")
				return

		var/direction = get_dir(user, newtarget)
		if ((direction in GLOB.alldirs) && !(direction in GLOB.cardinal))
			direction = turn(direction, -45)
			if (check_neighbor_density(get_turf(newtarget.loc), direction))
				direction = turn(direction, 90)
				if (check_neighbor_density(get_turf(newtarget.loc), direction))
					to_chat(user, "<span class='warning'>There is something in the way of \the [newtarget]!</span>")
					return

		if (locate(/obj/machinery/door/airlock) in oview(1, newtarget))
			if (alert("Brace adjacent airlocks?",,"Yes", "No") == "Yes")
				if (!check_target(newtarget, user)) return
				for (var/obj/machinery/door/airlock/A in get_step(newtarget.loc, turn(direction, -90)))
					if (istype(A, newtarget.type))
						if (!check_target(A, user)) return
						target_node1 = A
						target_node1.bracer = src
						break
				for (var/obj/machinery/door/airlock/B in get_step(newtarget.loc, turn(direction, 90)))
					if (istype(B, newtarget.type))
						if (!check_target(B, user)) return
						target_node2 = B
						target_node2.bracer = src
						break

		user.drop_from_inventory(src, src.loc)

		forceMove(get_step(newtarget.loc, reverse_direction(direction)))
		set_dir(reverse_direction(direction))
		status = STATUS_ACTIVE
		attach(newtarget)
		user.visible_message("<span class='notice'>[user] attached [src] onto [newtarget] and flicks it on. The magnetic lock now seals [newtarget].</span>", "<span class='notice'>You attached [src] onto [newtarget] and switched on the magnetic lock.</span>")
		return


/obj/item/device/magnetic_lock/proc/setconstructionstate(var/newstate)
	if (!powercell && newstate == 1)
		setconstructionstate(2)
		return
	else if (newstate == 4)
		detach(playflick = 0)
		update_icon()
	constructionstate = newstate
	update_icon()

/obj/item/device/magnetic_lock/proc/detach(var/playflick = 1)
	if (target)

		if (playflick)
			spawn(-15) flick("release_[department]", src)

		status = STATUS_INACTIVE
		set_dir(SOUTH)
		update_icon()
		layer = LAYER_NORMAL

		target.bracer = null
		target = null
		if (target_node1)
			target_node1.bracer = null
			target_node1 = null
		if (target_node2)
			target_node2.bracer = null
			target_node2 = null
		anchored = 0

		STOP_PROCESSING(SSprocessing, src)
		last_process_time = 0

/obj/item/device/magnetic_lock/proc/attach(var/obj/machinery/door/airlock/newtarget as obj)
	layer = LAYER_ATTACHED

	newtarget.bracer = src
	target = newtarget

	last_process_time = world.time
	START_PROCESSING(SSprocessing, src)
	anchored = 1

	spawn(-15)
		flick("deploy_[department]", src)
	update_icon()

/obj/item/device/magnetic_lock/update_icon()
	if (status == STATUS_ACTIVE && target)
		icon_state = "active_[department]"
		switch (dir)
			if (NORTH)
				pixel_x = 0
				pixel_y = -32
			if (EAST)
				pixel_x = -32
				pixel_y = 0
			if (SOUTH)
				pixel_x = 0
				pixel_y = 32
			if (WEST)
				pixel_x = 32
				pixel_y = 0
	else if (status >= STATUS_INACTIVE)
		icon_state = "inactive_[department]"
		pixel_x = 0
		pixel_y = 0
	else
		icon_state = "broken_[department]"
		pixel_x = 0
		pixel_y = 0
	update_overlays()

/obj/item/device/magnetic_lock/proc/update_overlays()
	cut_overlays()
	switch (status)
		if (STATUS_BROKEN)
			icon_state = "broken"
			return

		if (STATUS_INACTIVE to STATUS_ACTIVE)
			if (hacked)
				add_overlay("overlay_hacked")
			else if (locked)
				add_overlay("overlay_locked")
			else
				add_overlay("overlay_unlocked")
			switch (constructionstate)
				if (0)
					return
				if (1 to 4)
					add_overlay("overlay_deconstruct_[constructionstate]")

/obj/item/device/magnetic_lock/proc/takedamage(var/damage)
	if(invincible)
		return
	health -= rand(damage/2, damage)

	if (damage >= 40 && prob(50))
		health = 0

	if (health <= 0)
		visible_message("<span class='danger'>[src] sparks[target ? " and falls off of \the [target]!" : "!"] It is now completely unusable!</span>")
		detach(0)
		status = STATUS_BROKEN
		update_icon()
		return

	if (prob(50))
		spark(target ? target : src, 5, GLOB.alldirs)

/obj/item/device/magnetic_lock/keypad
	name = "magnetic door lock"
	desc = "A large, passcode locked device used for completely locking down airlocks."

	req_access = list(ACCESS_NONE)

	var/passcode = "open"
	var/configurable = TRUE

/obj/item/device/magnetic_lock/keypad/update_overlays()
	..()
	switch (status)
		if (STATUS_INACTIVE to STATUS_ACTIVE)
			if(istype(src, /obj/item/device/magnetic_lock/keypad))
				add_overlay("overlay_keypad")

/obj/item/device/magnetic_lock/keypad/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Maglock", "Maglock", 300, 250)
		ui.open()

/obj/item/device/magnetic_lock/keypad/attack_hand(var/mob/user)
	. = ..()
	if(.)
		return
	ui_interact(user)

/obj/item/device/magnetic_lock/keypad/ui_data(mob/user)
	var/list/data = list()
	data["locked"] = locked
	return data

/obj/item/device/magnetic_lock/keypad/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("passcode")
			if(lowertext(params["passcode"]) == passcode)
				locked = !locked
				playsound(src, 'sound/machines/ping.ogg', 30, 1)
				var/msg = "buttons on \the [src] and it [locked ? "locks" : "unlocks"] with a beep."
				var/pos_adj = "[usr.name] presses "
				var/fp_adj = "You press "
				usr.visible_message("<span class='warning'>[addtext(pos_adj, msg)]</span>", "<span class='notice'>[addtext(fp_adj, msg)]</span>")
				update_icon()
				. = TRUE
			else
				playsound(src, 'sound/machines/buzz-sigh.ogg', 30, 1)
				to_chat(usr, SPAN_WARNING("\The [src] buzzes!"))
				return
		if("set_passcode")
			if(!locked)
				passcode = lowertext(params["set_passcode"])
				to_chat(usr, SPAN_NOTICE("New passcode has been set."))
				. = TRUE
		if("lock")
			if(!locked)
				locked = !locked
				playsound(src, 'sound/machines/ping.ogg', 30, 1)
				to_chat(usr, SPAN_NOTICE("You have locked \the [src]."))
				update_icon()
				. = TRUE

#undef STATUS_INACTIVE
#undef STATUS_ACTIVE
#undef STATUS_BROKEN

#undef LAYER_ATTACHED
#undef LAYER_NORMAL
