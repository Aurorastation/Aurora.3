#define STATUS_INACTIVE 0
#define STATUS_ACTIVE 1
#define STATUS_BROKEN -1

#define LAYER_ATTACHED 3.2
#define LAYER_NORMAL 3

/obj/item/device/magnetic_lock
	name = "magnetic door lock"
	desc = "A large, ID locked device used for completely locking down airlocks. It is painted with [department] colors."
	icon = 'icons/obj/magnetic_locks/centcom.dmi'
	icon_state = "inactive"
	w_class = 3
	req_access = list(access_cent_specops)
	health = 90

	var/department = "CENTCOM"
	var/status = 0
	var/locked = 0
	var/hacked = 0
	var/constructionstate = 0
	var/drainamount = 20
	var/obj/machinery/door/airlock/target = null
	var/obj/item/weapon/cell/powercell
	var/obj/item/weapon/cell/internal_cell

/obj/item/device/magnetic_lock/security
	icon = 'icons/obj/magnetic_locks/security.dmi'
	department = "Security"
	req_access = list(access_security)

/obj/item/device/magnetic_lock/engineering
	icon = 'icons/obj/magnetic_locks/engineering.dmi'
	department = "Engineering"
	req_access = null
	req_one_access = list(access_engine_equip, access_atmospherics)

/obj/item/device/magnetic_lock/New()
	..()

	powercell = new /obj/item/weapon/cell/high()
	internal_cell = new /obj/item/weapon/cell/apc()

/obj/item/device/magnetic_lock/examine(mob/user)
	..(user)

	if (status == STATUS_BROKEN)
		user << "<span class='danger'>It looks broken!</span>"
	else
		if (powercell)
			var/power = round(powercell.charge / powercell.maxcharge * 100)
			user << "\blue The powercell is at [power]% charge."
		else
			var/int_power = round(internal_cell.charge / internal_cell.maxcharge * 100)
			user << "\red It has no powercell to power it! Internal cell is at [int_power]% charge."

/obj/item/device/magnetic_lock/attack_hand(var/mob/user)
	if (constructionstate == 1)
		ui_interact(user)
	else
		..()

/obj/item/device/magnetic_lock/bullet_act(var/obj/item/projectile/Proj)
	takedamage(Proj.damage)
	..()

/obj/item/device/magnetic_lock/attackby(var/obj/item/I, var/mob/user)
	if (status == STATUS_BROKEN)
		user << "<span class='danger'>[src] is broken beyond repair!</span>"
		return

	if (istype(I, /obj/item/weapon/card/id) && status == STATUS_ACTIVE)
		if (!constructionstate && !hacked)
			if (check_access(I))
				locked = !locked
				update_icon()
				playsound(src, 'sound/machines/ping.ogg', 30, 1)
				var/msg = "[I] through \the [src] and it [locked ? "locks" : "unlocks"] with a beep."
				var/pos_adj = "[user.name] swipes \his "
				var/fp_adj = "You swipe your "
				user.visible_message("<span class='warning'>[addtext(pos_adj, msg)]</span>", "<span class='notice'>[addtext(fp_adj, msg)]</span>")
			else
				playsound(src, 'sound/machines/buzz-sigh.ogg', 30, 1)
				user << span("warning", "\The [src] buzzes as you swipe your [I].")
				return
		else
			user << "<span class='danger'>You cannot swipe your [I] through [src] with it partially dismantled!</span>"
		return

	if (istype(I, /obj/item/weapon) && user.a_intent == "hurt")
		if (I.force >= 8)
			user.visible_message("<span class='danger'>[user] bashes [src] with [I]!</span>", "<span class='danger'>You strike [src] with [I], damaging it!</span>")
			takedamage(I.force)
			return
		else
			user.visible_message("<span class='notice'>[user] hits [src] with [I] to no visible effect.</span>", "<span class='notice'>You hit [src] with [I], but it appears to have no effect.</span>")
			return

	switch (constructionstate)
		if (0)
			if (istype(I, /obj/item/weapon/card/emag))
				var/obj/item/weapon/card/emag/emagcard = I
				emagcard.uses--
				visible_message("<span class='danger'>[src] sparks and falls off the door!</span>", "<span class='danger'>You emag [src], frying its circuitry[status == STATUS_ACTIVE ? " and making it drop onto the floor" : ""]!</span>")

				setstatus(STATUS_BROKEN)
				return

			if (iswelder(I))
				var/obj/item/weapon/weldingtool/WT = I
				if (WT.remove_fuel(2, user))
					user.visible_message(span("notice", "[user] starts welding the metal shell of [src]."), span("notice", "You start [hacked ? "repairing" : "welding open"] the metal covering of [src]."))
					playsound(loc, 'sound/items/Welder.ogg', 50, 1)
					overlays += "overlay_welding"
					if (do_after(user, 25, 1))
						user << span("notice", "You are able to [hacked ? "repair" : "weld through"] the metal shell of [src].")
						if (hacked) locked = 1
						else locked = 0
						hacked = !hacked
						overlays -= "overlay_welding"
					else
						overlays -= "overlay_welding"
					update_icon()
					return

			if (iscrowbar(I))
				if (!locked)
					user << span("notice", "You pry the cover off [src].")
					setconstructionstate(1)
				else
					user << span("notice", "You try to pry the cover off [src] but it doesn't budge.</span>")
				return

		if (1)
			if (istype(I, /obj/item/weapon/cell))
				if (powercell)
					user << span("notice","There's already a powercell in \the [src].")
				return

			if (iscrowbar(I))
				user << span("notice", "You wedge the cover back in place.")
				setconstructionstate(0)
				return

		if (2)
			if (isscrewdriver(I))
				user << span("notice", "You unscrew and remove the wiring cover from \the [src].")
				playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
				setconstructionstate(3)
				return

			if (istype(I, /obj/item/weapon/cell))
				if (!powercell)
					user << span("notice","You place the [I] inside \the [src].")
					user.drop_item()
					I.loc = src
					powercell = I
					setconstructionstate(1)
				return

		if (3)
			if (iswirecutter(I))
				user << span("notice", "You cut the wires connecting the [src]'s magnets to their internal powersupply, [target ? "making the device fall off [target] and rendering it unusable." : "rendering the device unusable."]")
				playsound(loc, 'sound/items/Wirecutter.ogg', 50, 1)
				setconstructionstate(4)
				return

			if (isscrewdriver(I))
				user << span("notice", "You replace and screw tight the wiring cover from \the [src].")
				playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
				setconstructionstate(2)
				return

		if (4)
			if (iswirecutter(I))
				user << span("notice", "You repair the wires connecting the [src]'s magnets to their internal powersupply")
				setconstructionstate(3)
				return

/obj/item/device/magnetic_lock/process()
	if (powercell && powercell.charge > drainamount)
		powercell.charge -= drainamount
	else
		if (powercell)
			powercell.charge = 0
		visible_message(span("danger", "[src] beeps loudly and falls off \the [target]; its powercell having run out of power."))
		setstatus(STATUS_INACTIVE)

/obj/item/device/magnetic_lock/proc/check_target(var/obj/machinery/door/airlock/newtarget, var/mob/user as mob)
	if (status == STATUS_BROKEN)
		user << span("danger", "[src] is damaged beyond repair! It cannot be used!")
		return 0

	if (hacked)
		user << span("danger", "[src] buzzes; it can't be used until you repair it!")
		return 0

	if (!newtarget.density || newtarget.operating)
		user << span("danger", "[newtarget] must be closed before you can attach [src] to it!")
		return 0

	if (newtarget.p_open)
		user << span("danger", "You must close [newtarget]'s maintenance panel before attaching [src] to it!")
		return 0

	return 1

/obj/item/device/magnetic_lock/proc/attachto(var/obj/machinery/door/airlock/newtarget, var/mob/user as mob)
	if (!check_target(newtarget, user)) return

	user.visible_message("<span class='notice'>[user] starts mounting [src] onto [newtarget].</span>", "<span class='notice'>You begin mounting [src] onto [newtarget].</span>")

	if (do_after(user, 35, 1))

		if (!check_target(newtarget, user)) return

		user.visible_message("<span class='notice'>[user] attached [src] onto [newtarget] and flicks it on. The magnetic lock now seals [newtarget].</span>", "<span class='notice'>You attached [src] onto [newtarget] and switched on the magnetic lock.</span>")
		user.drop_item()

		setstatus(STATUS_ACTIVE, newtarget)
		return

/obj/item/device/magnetic_lock/proc/setconstructionstate(var/newstate)
	constructionstate = newstate
	if (newstate == 0)
		if (status == STATUS_ACTIVE)
			icon_state = "active"
		else
			icon_state = "inactive"
	else if (newstate == 2)
		flick("deconstruct_2_anim", src)
	else if (newstate == 4)
		setstatus(STATUS_BROKEN)
	else
		icon_state = "deconstruct_[constructionstate]"

/obj/item/device/magnetic_lock/proc/detach(var/playflick = 1)
	if (target)

		if (playflick)
			spawn(-15) flick("release", src)

		update_icon()
		layer = LAYER_NORMAL

		target.bracer = null

		processing_objects.Remove(src)

		anchored = 0

/obj/item/device/magnetic_lock/proc/attach(var/obj/machinery/door/airlock/newtarget as obj)
	layer = LAYER_ATTACHED

	newtarget.bracer = src
	target = newtarget

	processing_objects.Add(src)

	anchored = 1

	update_icon()
	spawn(-15)
		flick("deploy", src)

/obj/item/device/magnetic_lock/update_icon()
	if (status > 0 && anchored)
		switch (dir)
			if (NORTH)
				pixel_x = 0
				pixel_y = 32
			if (EAST)
				pixel_x = 32
				pixel_y = 0
			if (SOUTH)
				pixel_x = 0
				pixel_y = -32
			if (WEST)
				pixel_x = -32
				pixel_y = 0
	else
		pixel_x = 0
		pixel_y = 0
	update_overlays()

/obj/item/device/magnetic_lock/proc/update_overlays()
	overlays.Cut()
	switch (status)
		if (STATUS_BROKEN)
			icon = "broken"
			return

		if (STATUS_INACTIVE to STATUS_ACTIVE)
			if (hacked)
				overlays += "overlay_hacked"
			else if (locked)
				overlays += "overlay_locked"
			else
				overlays += "overlay_unlocked"
			switch (constructionstate)
				if (0)
					return
				if (1 to 4)
					overlays += "overlay_deconstruct_[constructionstate]"
					return

/obj/item/device/magnetic_lock/proc/takedamage(var/damage)
	health -= damage

	if (damage >= 40 && prob(50))
		health = 0

	if (health <= 0)
		visible_message("<span class='danger'>[src] sparks[target ? " and falls off of \the [target]!" : "!"] It is now completely unusable!</span>")
		setstatus(STATUS_BROKEN)
		return

	if (prob(50))
		spark()

/obj/item/device/magnetic_lock/proc/spark()
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread

	if (target)
		s.set_up(5, 1, target)
	else
		s.set_up(5, 1, src)

	s.start()
	spawn(5)
		qdel(s)

#undef STATUS_INACTIVE
#undef STATUS_ACTIVE
#undef STATUS_BROKEN

#undef LAYER_ATTACHED
#undef LAYER_NORMAL
