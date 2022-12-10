//Global list for housing active radiojammers:
var/list/active_radio_jammers = list()

// tests if an object is near a radio jammer
// if need_all_blocked is false, the jammer only needs to be on JAMMER_SYNTHETIC to work
/proc/within_jamming_range(var/atom/test, var/need_all_blocked = TRUE)
	if(length(active_radio_jammers))
		var/turf/our_turf = get_turf(test)
		for(var/obj/item/device/radiojammer/J in active_radio_jammers)
			var/turf/jammer_turf = get_turf(J)
			if(our_turf.z != jammer_turf.z)
				continue
			if(get_dist(our_turf, jammer_turf) <= J.radius)
				if(need_all_blocked && J.active != JAMMER_ALL)
					continue
				return TRUE
	return FALSE

/obj/item/device/radiojammer
	name = "radio jammer"
	desc = "A small, inconspicious looking item with an 'ON/OFF' toggle."
	desc_info = "Use in-hand to activate or deactivate, alt-click while adjacent or in-hand to toggle whether it blocks all wireless signals, or just stationbound wireless interfacing."
	icon = 'icons/obj/device.dmi'
	icon_state = "shield0"
	w_class = ITEMSIZE_SMALL
	var/active = JAMMER_OFF
	var/radius = 7
	var/icon_state_active = "shield1"
	var/icon_state_inactive = "shield0"

/obj/item/device/radiojammer/active
	active = JAMMER_ALL

/obj/item/device/radiojammer/New()
	..()
	update_icon()

/obj/item/device/radiojammer/Destroy()
	active_radio_jammers -= src
	return ..()

/obj/item/device/radiojammer/attack_self(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if(!ui)
		ui = new(user, src, "devices-jammer", 200, 200, capitalize_first_letters(name))
	ui.open()

/obj/item/device/radiojammer/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	if(!data)
		data = list()

	VUEUI_SET_CHECK(data["active"], active, ., data)

/obj/item/device/radiojammer/Topic(href, href_list)
	..()

	if(href_list["set_active"])
		active = text2num(href_list["set_active"])
		update_icon()

	var/datum/vueui/ui = SSvueui.get_open_ui(usr, src)
	ui.check_for_change()

/obj/item/device/radiojammer/emp_act()
	toggle()

/obj/item/device/radiojammer/proc/toggle(var/mob/user)
	if(active)
		if(user)
			to_chat(user, SPAN_NOTICE("You deactivate \the [src]."))
		active = JAMMER_OFF
	else
		if(user)
			to_chat(user, SPAN_NOTICE("You activate \the [src]."))
		active = JAMMER_ALL
	update_icon()

/obj/item/device/radiojammer/update_icon()
	if(active > 0)
		active_radio_jammers += src
		icon_state = icon_state_active
	else
		active_radio_jammers -= src
		icon_state = icon_state_inactive


/obj/item/device/radiojammer/improvised
	name = "improvised radio jammer"
	desc = "An awkward bundle of wires, batteries, and radio transmitters."
	desc_info = "Use in-hand to activate or deactivate."
	var/obj/item/cell/cell
	var/obj/item/device/assembly_holder/assembly_holder
	// 10 seconds of operation on a standard cell. 200 (roughly 3 minutes) on a super cap.
	var/power_drain_per_second = 100
	var/last_updated = null
	radius = 5
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	icon_state = "improvised_jammer_inactive"
	icon_state_active = "improvised_jammer_active"


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
		active = JAMMER_OFF
		cell.charge = 0 // drain the last of the battery
		update_icon()


/obj/item/device/radiojammer/improvised/attackby(obj/item/W as obj, mob/user as mob)
	if (W.isscrewdriver())
		to_chat(user, "<span class='notice'>You disassemble the improvised signal jammer.</span>")
		user.put_in_hands(assembly_holder)
		assembly_holder.detached()
		user.put_in_hands(cell)
		qdel(src)
		return TRUE

/obj/item/device/radiojammer/improvised/toggle(mob/user)
	if(!active)
		if(!cell)
			if(user)
				to_chat(user, SPAN_WARNING("\The [src] has no cell!"))
			return
		if(!cell.charge)
			if(user)
				to_chat(user, SPAN_WARNING("\The [src]'s battery is completely empty!"))
			return
	return ..()

/obj/item/device/radiojammer/improvised/update_icon()
	if(active > 0)
		active_radio_jammers += src
		icon_state = icon_state_active
		START_PROCESSING(SSprocessing, src)
		last_updated = world.time
	else
		active_radio_jammers -= src
		icon_state = initial(icon_state)
		STOP_PROCESSING(SSprocessing, src)
