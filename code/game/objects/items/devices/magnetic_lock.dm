#define STATUS_INACTIVE 0
#define STATUS_ACTIVE 1
#define STATUS_BROKEN 2

#define LAYER_ATTACHED 3.2
#define LAYER_NORMAL 3

/obj/item/device/magnetic_lock
	name = "magnetic door lock"
	desc = "A large, ID locked device used for completely locking down airlocks."
	icon = 'icons/obj/magnetic_locks/centcom.dmi'
	icon_state = "inactive"
	w_class = 3
	req_access = list(103)
	health = 90

	var/department = "CENTCOM"
	var/status = 0
	var/constructionstate = 0
	var/drainamount = 20
	var/obj/machinery/door/airlock/target = null
	var/obj/item/weapon/cell/powercell

/obj/item/device/magnetic_lock/security
	icon = 'icons/obj/magnetic_locks/security.dmi'
	department = "Security"
	req_access = list(1)

/obj/item/device/magnetic_lock/engineering
	icon = 'icons/obj/magnetic_locks/engineering.dmi'
	department = "Engineering"
	req_access = null
	req_one_access = list(11, 24)

/obj/item/device/magnetic_lock/New()
	..()

	powercell = new /obj/item/weapon/cell/high()

/obj/item/device/magnetic_lock/examine()
	..()

	if (status == STATUS_BROKEN)
		usr << "<span class='danger'>It looks broken!</span>"
	else
		if (powercell)
			var/power = round(powercell.charge / powercell.maxcharge * 100)
			usr << "\blue The powercell is at [power]% charge."
		else
			usr << "\red It has no powercell to power it!"

/obj/item/device/magnetic_lock/attack_hand(var/mob/user)
	if (status == STATUS_ACTIVE)
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

			if (status == STATUS_ACTIVE && istype(I, /obj/item/weapon/card/id))
				if (check_access(I) && !constructionstate)
					user << "<span class='notice'>You swipe your [I] through [src], making it drop onto the floor with a thud.</span>"
					setstatus(STATUS_INACTIVE)
					return
				else if (constructionstate)
					user << "<span class='danger'>You cannot swipe your [I] through [src] with it partially dismantled!</span>"
					return
				else
					user << "<span class='danger'>A red light flashes on [src] as you swipe your [I] through it.</span>"
					flick("deny",src)
					return

			if (istype(I, /obj/item/weapon/screwdriver))
				user << "<span class='notice'>You unfasten and remove the plastic cover from [src], revealing a thick metal shell.</span>"
				playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
				setconstructionstate(1)
				return

		if (1)
			if (istype(I, /obj/item/weapon/screwdriver))
				user << "<span class='notice'>You put the metal cover of back onto [src], and screw it tight.</span>"
				playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
				setconstructionstate(0)
				return
			if (istype(I, /obj/item/weapon/cell))
				user.drop_item()
				I.loc = src
				powercell = I
				return
			if (istype(I, /obj/item/weapon/crowbar))
				user << "<span class='notice'>You remove \the [powercell] from \the [src].</span>"
				powercell.loc = loc
				powercell = null
				return
			if (istype(I, /obj/item/weapon/weldingtool))
				var/obj/item/weapon/weldingtool/WT = I
				if (WT.remove_fuel(1, user))
					user.visible_message("<span class='notice'>[user] starts welding through the metal shell of [src].</span>", "<span class='notice'>You start welding through the metal covering of [src]</span>")
					playsound(loc, 'sound/items/Welder.ogg', 50, 1)
					if (do_after(user, 25))
						user << "<span class='notice'>You are able to weld through the metal shell of [src].</span>"
						setconstructionstate(2)
						return
		if (2)
			if (istype(I, /obj/item/weapon/crowbar))
				user << "<span class='notice'>You pry off the metal covering from [src].</span>"
				playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
				setconstructionstate(3)
				return
		if (3)
			if (istype(I, /obj/item/weapon/wirecutters))
				user << "<span class='notice'>You cut the wires connecting the [src]'s magnets to their powersupply, [target ? "making the device fall off [target] and rendering it unusable." : "rendering the device unusable."]</span>"
				playsound(loc, 'sound/items/Wirecutter.ogg', 50, 1)
				setconstructionstate(4)
				return

/obj/item/device/magnetic_lock/process()
	if (powercell && powercell.charge > drainamount)
		powercell.charge -= drainamount
	else
		if (powercell)
			powercell.charge = 0
		visible_message("<span class='danger'>[src] beeps loudly and falls off \the [target]; its powercell having run out of power.</span>")
		setstatus(STATUS_INACTIVE)

/obj/item/device/magnetic_lock/proc/attachto(var/obj/machinery/door/airlock/newtarget, var/mob/user as mob)
	if (status == STATUS_BROKEN)
		user << "<span class='danger'>[src] is damaged beyond repair! It cannot be used!</span>"
		return

	if (!newtarget.density || newtarget.operating)
		user << "<span class='danger'>[newtarget] must be closed before you can attach [src] to it!</span>"
		return

	if (newtarget.p_open)
		user << "<span class='danger'>You must close [newtarget]'s maintenance panel before attaching [src] to it!</span>"
		return

	user.visible_message("<span class='notice'>[user] starts mounting [src] onto [newtarget].</span>", "<span class='notice'>You begin mounting [src] onto [newtarget].</span>")
	if (do_after(user, 35, 1))
		if (status == STATUS_BROKEN)
			user << "<span class='danger'>[src] is damaged beyond repair! It cannot be used!</span>"
			return

		if (!newtarget.density)
			user << "<span class='danger'>[newtarget] must be closed before you can attach [src] to it!</span>"
			return

		if (newtarget.p_open)
			user << "<span class='danger'>You must close [newtarget]'s maintenance panel before attaching [src] to it!</span>"
			return

		user.visible_message("<span class='notice'>[user] attached [src] onto [newtarget] and flicks it on. The magnetic lock now seals [newtarget].</span>", "<span class='notice'>You attached [src] onto [newtarget] and switched on the magnetic lock.</span>")
		user.drop_item()

		setstatus(STATUS_ACTIVE, newtarget)
		return

/obj/item/device/magnetic_lock/proc/setstatus(var/newstatus, var/obj/machinery/door/airlock/newtarget as obj)
	switch (newstatus)
		if (STATUS_INACTIVE)
			if (status != STATUS_ACTIVE)
				return
			if (!target)
				return

			detach()
			icon_state = "inactive"
			status = newstatus

		if (STATUS_ACTIVE)
			if (status != STATUS_INACTIVE)
				return
			if (!newtarget)
				return

			attach(newtarget)
			icon_state = "active"
			status = newstatus

		if (STATUS_BROKEN)
			spark()

			if (target)
				var/playflick = 1
				if (constructionstate)
					playflick = 0

				detach(playflick)

			icon_state = "broken"
			status = newstatus

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

		adjustsprite(null)
		layer = LAYER_NORMAL

		target.bracer = null

		processing_objects.Remove(src)

		anchored = 0

/obj/item/device/magnetic_lock/proc/attach(var/obj/machinery/door/airlock/newtarget as obj)
	adjustsprite(newtarget)
	layer = LAYER_ATTACHED
	flick("deploy", src)

	newtarget.bracer = src
	target = newtarget

	processing_objects.Add(src)

	anchored = 1

/obj/item/device/magnetic_lock/proc/adjustsprite(var/obj/target as obj)
	if (target)
		switch (get_dir(src, target))
			if (NORTH)
				pixel_x = 0
				pixel_y = 32
			if (NORTHEAST)
				pixel_x = 32
				pixel_y = 32
			if (EAST)
				pixel_x = 32
				pixel_y = 0
			if (SOUTHEAST)
				pixel_x = 32
				pixel_y = -32
			if (SOUTH)
				pixel_x = 0
				pixel_y = -32
			if (SOUTHWEST)
				pixel_x = -32
				pixel_y = -32
			if (WEST)
				pixel_x = -32
				pixel_y = 0
			if (NORTHWEST)
				pixel_x = -32
				pixel_y = 32
	else
		pixel_x = 0
		pixel_y = 0

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
		del(s)

#undef STATUS_INACTIVE
#undef STATUS_ACTIVE
#undef STATUS_BROKEN

#undef LAYER_ATTACHED
#undef LAYER_NORMAL
