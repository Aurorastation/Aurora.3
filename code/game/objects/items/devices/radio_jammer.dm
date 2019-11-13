//Global list for housing active radiojammers:
var/list/active_radio_jammers = list()

proc/within_jamming_range(var/atom/test) // tests if an object is near a radio jammer
	if (active_radio_jammers && active_radio_jammers.len)
		for (var/obj/item/device/radiojammer/Jammer in active_radio_jammers)
			if (get_dist(test, Jammer) <= Jammer.radius)
				return 1

	return 0

/obj/item/device/radiojammer
	name = "radio jammer"
	desc = "A small, inconspicious looking item with an 'ON/OFF' toggle."
	icon = 'icons/obj/device.dmi'
	icon_state = "shield0"
	w_class = 2

	var/active = 0
	var/radius = 7
	var/icon_state_active = "shield1"
	var/icon_state_inactive = "shield0"

/obj/item/device/radiojammer/New()
	..()
	update()

/obj/item/device/radiojammer/Destroy()
	if (active)
		active_radio_jammers -= src
	return ..()


/obj/item/device/radiojammer/attack_self()
	toggle()


/obj/item/device/radiojammer/emp_act()
	toggle()


/obj/item/device/radiojammer/proc/toggle()
	if (active)
		to_chat(usr, "<span class='notice'>You deactivate \the [src].</span>")
	else
		to_chat(usr, "<span class='notice'>You activate \the [src].</span>")
	set_active(!active)


/obj/item/device/radiojammer/proc/set_active(var/new_value)
	active = new_value
	update()


/obj/item/device/radiojammer/proc/update()
	if (active)
		active_radio_jammers += src
		icon_state = icon_state_active
	else
		active_radio_jammers -= src
		icon_state = icon_state_inactive


/obj/item/device/radiojammer/improvised
	name = "improvised radio jammer"
	desc = "An awkward bundle of wires, batteries, and radio transmitters."
	var/obj/item/cell/cell
	var/obj/item/device/assembly_holder/assembly_holder
	// 10 seconds of operation on a standard cell. 200 (roughly 3 minutes) on a super cap.
	var/power_drain_per_second = 100
	var/last_updated = null
	radius = 5
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	icon_state_active = "improvised_jammer_active"
	icon_state_inactive = "improvised_jammer_inactive"


/obj/item/device/radiojammer/improvised/New(var/obj/item/device/assembly_holder/incoming_holder, var/obj/item/cell/incoming_cell, var/mob/user)
	..()
	cell = incoming_cell
	assembly_holder = incoming_holder

	// Spawn() required to properly move the assembly. Why? No clue!
	// This does not make any sense, but sure.
	spawn(0)
		incoming_holder.forceMove(src, 1)
		incoming_cell.forceMove(src, 1)

	user.put_in_active_hand(src)

/obj/item/device/radiojammer/improvised/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()


/obj/item/device/radiojammer/improvised/process()
	var/current = world.time // current tick
	var/delta = (current - last_updated) / 10.0 // delta in seconds
	last_updated = current
	if (!cell.use(delta * power_drain_per_second))
		set_active(0)
		cell.charge = 0 // drain the last of the battery


/obj/item/device/radiojammer/improvised/attackby(obj/item/W as obj, mob/user as mob)
	if (W.isscrewdriver())
		to_chat(user, "<span class='notice'>You disassemble the improvised signal jammer.</span>")
		user.put_in_hands(assembly_holder)
		user.put_in_hands(cell)
		qdel(src)

/obj/item/device/radiojammer/improvised/set_active(var/new_value)
	if (new_value == 1)
		if (!cell || !cell.charge)
			return

	..()

/obj/item/device/radiojammer/improvised/update()
	if (active)
		active_radio_jammers += src
		icon_state = icon_state_active
		START_PROCESSING(SSprocessing, src)

		last_updated = world.time
	else
		active_radio_jammers -= src
		icon_state = icon_state_inactive
		STOP_PROCESSING(SSprocessing, src)
