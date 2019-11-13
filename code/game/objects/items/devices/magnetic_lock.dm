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
	w_class = 3
	req_access = list(access_cent_specops)
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
	var/obj/item/cell/internal_cell

/obj/item/device/magnetic_lock/security
	department = "Security"
	icon_state = "inactive_Security"
	req_access = list(access_security)

/obj/item/device/magnetic_lock/engineering
	department = "Engineering"
	icon_state = "inactive_Engineering"
	req_access = null
	req_one_access = list(access_engine_equip, access_atmospherics)

/obj/item/device/magnetic_lock/Initialize()
	. = ..()

	powercell = new /obj/item/cell/high()
	internal_cell = new /obj/item/cell/device()

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

/obj/item/device/magnetic_lock/examine(mob/user)
	..(user)

	if (status == STATUS_BROKEN)
		to_chat(user, "<span class='danger'>It looks broken!</span>")
	else
		if (powercell)
			var/power = round(powercell.charge / powercell.maxcharge * 100)
			to_chat(user, "<span class='notice'>The powercell is at [power]% charge.</span>")
		else
			var/int_power = round(internal_cell.charge / internal_cell.maxcharge * 100)
			to_chat(user, "<span class='warning'>It has no powercell to power it! Internal cell is at [int_power]% charge.</span>")

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

/obj/item/device/magnetic_lock/attackby(var/obj/item/I, var/mob/user)
	if (status == STATUS_BROKEN)
		to_chat(user, "<span class='danger'>[src] is broken beyond repair!</span>")
		return

	if (istype(I, /obj/item/card/id))
		if (!constructionstate && !hacked)
			if (check_access(I))
				locked = !locked
				playsound(src, 'sound/machines/ping.ogg', 30, 1)
				var/msg = "[I] through \the [src] and it [locked ? "locks" : "unlocks"] with a beep."
				var/pos_adj = "[user.name] swipes \his "
				var/fp_adj = "You swipe your "
				user.visible_message("<span class='warning'>[addtext(pos_adj, msg)]</span>", "<span class='notice'>[addtext(fp_adj, msg)]</span>")
				update_icon()
			else
				playsound(src, 'sound/machines/buzz-sigh.ogg', 30, 1)
				to_chat(user, span("warning", "\The [src] buzzes as you swipe your [I]."))
				return
		else
			to_chat(user, "<span class='danger'>You cannot swipe your [I] through [src] with it partially dismantled!</span>")
		return

	if (istype(I, /obj/item) && user.a_intent == "harm")
		if (I.force >= 18)
			user.visible_message("<span class='danger'>[user] bashes [src] with [I]!</span>", "<span class='danger'>You strike [src] with [I], damaging it!</span>")
			takedamage(I.force)
			playsound(loc, "sound/weapons/genhit[rand(1,3)].ogg", I.force*3, 1)
			addtimer(CALLBACK(GLOBAL_PROC, /proc/playsound, loc, "sound/effects/sparks[rand(1,4)].ogg", 30, 1), 3, TIMER_CLIENT_TIME)
			return
		else
			user.visible_message("<span class='danger'>[user] hits [src] with [I] but fails to damage it.</span>", "<span class='warning'>You hit [src] with [I], [I.force >= 10 ? "and it almost makes a dent!" : "but it appears to have no visible effect."]</span>")
			playsound(loc, "sound/weapons/Genhit.ogg", I.force*2.5, 1)
			return

	if(invincible)
		return
	switch (constructionstate)
		if (0)
			if (istype(I, /obj/item/card/emag))
				var/obj/item/card/emag/emagcard = I
				emagcard.uses--
				visible_message("<span class='danger'>[src] sparks and falls off the door!</span>", "<span class='danger'>You emag [src], frying its circuitry[status == STATUS_ACTIVE ? " and making it drop onto the floor" : ""]!</span>")

				status = STATUS_BROKEN
				if (target)
					detach()
					update_icon()
				return

			if (I.iswelder())
				var/obj/item/weldingtool/WT = I
				if (WT.remove_fuel(2, user))
					user.visible_message(span("notice", "[user] starts welding the metal shell of [src]."), span("notice", "You start [hacked ? "repairing" : "welding open"] the metal covering of [src]."))
					playsound(loc, 'sound/items/Welder.ogg', 50, 1)
					add_overlay("overlay_welding")
					if (do_after(user, 25/I.toolspeed))
						to_chat(user, span("notice", "You are able to [hacked ? "repair" : "weld through"] the metal shell of [src]."))
						if (hacked) locked = 1
						else locked = 0
						hacked = !hacked
						cut_overlay("overlay_welding")
					else
						cut_overlay("overlay_welding")
					update_icon()
					return

			if (I.iscrowbar())
				if (!locked)
					to_chat(user, span("notice", "You pry the cover off [src]."))
					setconstructionstate(1)
				else
					to_chat(user, span("notice", "You try to pry the cover off [src] but it doesn't budge."))
				return

		if (1)
			if (istype(I, /obj/item/cell))
				if (powercell)
					to_chat(user, span("notice","There's already a powercell in \the [src]."))
				return

			if (I.iscrowbar())
				to_chat(user, span("notice", "You wedge the cover back in place."))
				setconstructionstate(0)
				return

		if (2)
			if (I.isscrewdriver())
				to_chat(user, span("notice", "You unscrew and remove the wiring cover from \the [src]."))
				playsound(loc, I.usesound, 50, 1)
				setconstructionstate(3)
				return

			if (I.iscrowbar())
				to_chat(user, span("notice", "You wedge the cover back in place."))
				setconstructionstate(0)
				return

			if (istype(I, /obj/item/cell))
				if (!powercell)
					to_chat(user, span("notice","You place the [I] inside \the [src]."))
					user.drop_from_inventory(I,src)
					powercell = I
					setconstructionstate(1)
				return

		if (3)
			if (I.iswirecutter())
				to_chat(user, span("notice", "You cut the wires connecting the [src]'s magnets to their internal powersupply, [target ? "making the device fall off [target] and rendering it unusable." : "rendering the device unusable."]"))
				playsound(loc, 'sound/items/Wirecutter.ogg', 50, 1)
				setconstructionstate(4)
				return

			if (I.isscrewdriver())
				to_chat(user, span("notice", "You replace and screw tight the wiring cover from \the [src]."))
				playsound(loc, I.usesound, 50, 1)
				setconstructionstate(2)
				return

		if (4)
			if (I.iswirecutter())
				to_chat(user, span("notice", "You repair the wires connecting the [src]'s magnets to their internal powersupply"))
				setconstructionstate(3)
				return

/obj/item/device/magnetic_lock/process()
	if(!processpower)
		return
	var/obj/item/cell/C = powercell // both of these are for viewing ease
	var/obj/item/cell/BU = internal_cell
	var/delta_sec = (world.time - last_process_time) / 10
	var/drainamount = drain_per_second * delta_sec
	if (C)
		if (C.charge > drainamount)
			C.charge -= drainamount
			var/int_diff = min(drainamount, BU.maxcharge - BU.charge)
			if (C.charge > int_diff && BU.charge != BU.maxcharge)
				if (int_diff < drainamount)
					BU.charge = BU.maxcharge
					C.charge -= int_diff
				else
					BU.charge += drainamount
					C.charge -= drainamount
		else if (BU.charge > (drainamount - C.charge))
			var/diff = drainamount - C.charge
			C.charge = 0
			BU.charge -= diff
		else
			BU.charge = 0
			visible_message(span("danger", "[src] beeps loudly and falls off \the [target]; its powercell having run out of power."))
			detach(0)
	else if (BU.charge > drainamount)
		BU.charge -= drainamount
	else
		BU.charge = 0
		visible_message(span("danger", "[src] beeps loudly and falls off \the [target]; its powercell having run out of power."))
		detach(0)
	last_process_time = world.time

/obj/item/device/magnetic_lock/proc/check_target(var/obj/machinery/door/airlock/newtarget, var/mob/user as mob)
	if (status == STATUS_BROKEN)
		to_chat(user, span("danger", "[src] is damaged beyond repair! It cannot be used!"))
		return 0

	if (hacked)
		to_chat(user, span("danger", "[src] buzzes; it can't be used until you repair it!"))
		return 0

	if (!newtarget.density || newtarget.operating)
		to_chat(user, span("danger", "[newtarget] must be closed before you can attach [src] to it!"))
		return 0

	if (newtarget.p_open)
		to_chat(user, span("danger", "You must close [newtarget]'s maintenance panel before attaching [src] to it!"))
		return 0

	if (!user.Adjacent(newtarget))
		to_chat(user, span("danger", "You must stand next to [newtarget] while attaching it!"))
		return 0

	return 1

/obj/item/device/magnetic_lock/proc/attachto(var/obj/machinery/door/airlock/newtarget, var/mob/user as mob)
	if (!check_target(newtarget, user)) return

	user.visible_message("<span class='notice'>[user] starts mounting [src] onto [newtarget].</span>", "<span class='notice'>You begin mounting [src] onto [newtarget].</span>")

	if (do_after(user, 35))

		if (!check_target(newtarget, user)) return

		if(!internal_cell.charge)
			to_chat(user, "<span class='warning'>\The [src] looks dead and out of power.</span>")
			return

		var/direction = get_dir(user, newtarget)
		if ((direction in alldirs) && !(direction in cardinal))
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
		spark(target ? target : src, 5, alldirs)

/obj/item/device/magnetic_lock/keypad
	name = "magnetic door lock"
	desc = "A large, passcode locked device used for completely locking down airlocks."

	req_access = list(access_none)

	var/passcode = "open"
	var/configurable = TRUE

/obj/item/device/magnetic_lock/keypad/update_overlays()
	..()
	switch (status)
		if (STATUS_INACTIVE to STATUS_ACTIVE)
			if(istype(src, /obj/item/device/magnetic_lock/keypad))
				add_overlay("overlay_keypad")


/obj/item/device/magnetic_lock/keypad/attack_self(mob/user as mob)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if(!ui)
		if(locked)
			ui = new(user, src, "misc-maglock", 300, 100, "Maglock", list())
		else
			ui = new(user, src, "misc-maglock-config", 300, 100, "Maglock configuration", list("passcode" = passcode))
	
	ui.open()

/obj/item/device/magnetic_lock/keypad/attack_hand(var/mob/user)
	. = ..()
	if(. || !locked)
		return

	attack_self(user)

/obj/item/device/magnetic_lock/keypad/Topic(href, href_list)
	var/datum/vueui/ui = href_list["vueui"]
	if(!istype(ui))
		return
	if(href_list["passcode"])
		if(lowertext(href_list["passcode"]) == passcode)
			locked = !locked
			playsound(src, 'sound/machines/ping.ogg', 30, 1)
			var/msg = "buttons on \the [src] and it [locked ? "locks" : "unlocks"] with a beep."
			var/pos_adj = "[usr.name] presses "
			var/fp_adj = "You press "
			usr.visible_message("<span class='warning'>[addtext(pos_adj, msg)]</span>", "<span class='notice'>[addtext(fp_adj, msg)]</span>")
			update_icon()
			ui.close()
		else
			playsound(src, 'sound/machines/buzz-sigh.ogg', 30, 1)
			to_chat(usr, span("warning", "\The [src] buzzes as you enter passcode."))
			return
	if(href_list["set_passcode"])
		if(!locked)
			passcode = lowertext(href_list["set_passcode"])
			ui.data["passcode"] = passcode
			to_chat(usr, "New passcode has been set.")
			ui.push_change()
	if(href_list["lock"])
		if(!locked)
			locked = !locked
			playsound(src, 'sound/machines/ping.ogg', 30, 1)
			to_chat(usr, "You have locked \the [src].")
			ui.close()
			update_icon()

#undef STATUS_INACTIVE
#undef STATUS_ACTIVE
#undef STATUS_BROKEN

#undef LAYER_ATTACHED
#undef LAYER_NORMAL
