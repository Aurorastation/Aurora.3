/obj/machinery/space_heater
	name = "portable air conditioning unit"
	desc = "A portable air conditioning unit. It can heat or cool a room to your liking."
	icon = 'icons/obj/atmos.dmi'
	icon_state = "sheater-off"
	anchored = FALSE
	density = TRUE
	use_power = POWER_USE_OFF
	clicksound = /decl/sound_category/switch_sound
	var/on = FALSE
	var/active = 0
	var/heating_power = 40 KILOWATTS
	var/set_temperature = T0C + 20

	var/obj/item/cell/apc/cell

/obj/machinery/space_heater/Initialize()
	. = ..()
	cell = new(src)
	update_icon()

/obj/machinery/space_heater/update_icon()
	cut_overlays()
	if(!on)
		icon_state = "sheater-off"
		set_light(0)
	else if(active > 0)
		icon_state = "sheater-heat"
		set_light(0.7, 1, COLOR_SEDONA)
	else if(active < 0)
		icon_state = "sheater-cool"
		set_light(0.7, 1, COLOR_DEEP_SKY_BLUE)
	else
		icon_state = "sheater-standby"
		set_light(0)
	if(panel_open)
		add_overlay("sheater-open")

/obj/machinery/space_heater/examine(mob/user)
	..(user)

	to_chat(user, "The heater is [on ? "on" : "off"] and the hatch is [panel_open ? "open" : "closed"].")
	if(panel_open)
		to_chat(user, "The power cell is [cell ? "installed" : "missing"].")
	else
		to_chat(user, "The charge meter reads [cell ? round(cell.percent(),1) : 0]%")
	return

/obj/machinery/space_heater/powered()
	if(cell && cell.charge)
		return TRUE
	return FALSE

/obj/machinery/space_heater/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return
	if(cell)
		cell.emp_act(severity)
	..(severity)

/obj/machinery/space_heater/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/cell))
		if(panel_open)
			if(cell)
				to_chat(user, "There is already a power cell inside.")
			else
				// insert cell
				user.drop_from_inventory(I,src)
				cell = I
				I.add_fingerprint(user)

				visible_message(SPAN_NOTICE("[user] inserts a power cell into [src]."),
					SPAN_NOTICE("You insert the power cell into [src]."))
				power_change()
		else
			to_chat(user, SPAN_NOTICE("The hatch must be open to insert a power cell."))
		return TRUE
	else if(I.isscrewdriver())
		panel_open = !panel_open
		user.visible_message(SPAN_NOTICE("[user] [panel_open ? "opens" : "closes"] the hatch on the [src]."),
				SPAN_NOTICE("You [panel_open ? "open" : "close"] the hatch on the [src]."))
		update_icon()

		if(!panel_open && user.machine == src)
			user << browse(null, "window=spaceheater")
			user.unset_machine()

		return TRUE
	return ..()

/obj/machinery/space_heater/attack_hand(mob/user)
	src.add_fingerprint(user)
	if(panel_open)
		if(cell)
			user.visible_message(SPAN_NOTICE("\The [user] removes \the [cell] from \the [src]."),
				SPAN_NOTICE("You remove \the [cell] from \the [src]."))
			cell.update_icon()
			user.put_in_hands(cell)
			cell.add_fingerprint(user)
			cell = null
			power_change()
		else
			to_chat(user,"There's no cell to remove!")
	else
		interact(user)

/obj/machinery/space_heater/interact(mob/user)
	var/dat = "Power cell: "
	if(cell)
		dat += "Detected<br>"
	else
		dat += "Not Detected<br>"
	dat += "Power: "
	if(on)
		dat += "<A href='?src=\ref[src];op=off'>On</A><br>"
	else
		dat += "<A href='?src=\ref[src];op=on'>Off</A><br>"

	dat += "Power Level: [cell ? round(cell.percent(),1) : 0]%<br><br>"

	dat += "Set Temperature: "
	dat += "<A href='?src=\ref[src];op=temp;val=-5'>-</A>"
	dat += " [set_temperature]K ([set_temperature-T0C]&deg;C) "
	dat += "<A href='?src=\ref[src];op=temp;val=5'>+</A><br>"

	user.set_machine(src)
	var/datum/browser/heater_win = new(user, "spaceheater", "Space Heater Control Panel")
	heater_win.set_content(dat)
	heater_win.open()

/obj/machinery/space_heater/Topic(href, href_list)
	if (usr.stat)
		return
	if ((in_range(src, usr) && istype(src.loc, /turf)) || (istype(usr, /mob/living/silicon)))
		usr.set_machine(src)

		switch(href_list["op"])

			if("temp")
				var/value = text2num(href_list["val"])

				// limit to 0-90 degC
				set_temperature = dd_range(T0C, T0C + 90, set_temperature + value)

			if("off")
				on = !on
				usr.visible_message(SPAN_NOTICE("[usr] switches off the [src]."),
					SPAN_NOTICE("You switch off the [src]."))
				update_icon()

			if("on")
				if(cell)
					on = !on
					usr.visible_message(SPAN_NOTICE("\The [usr] switches on \the [src]."),
						SPAN_NOTICE("You switch on \the [src]."))
					update_icon()
				else
					to_chat(usr, SPAN_NOTICE("You can't turn it on without a cell installed!"))
					return
		updateDialog()
	else
		usr << browse(null, "window=spaceheater")
		usr.unset_machine()
	return



/obj/machinery/space_heater/process()
	if(on)
		if(cell && cell.charge)
			var/datum/gas_mixture/env = loc.return_air()
			if(env && abs(env.temperature - set_temperature) <= 0.1)
				active = FALSE
			else
				var/transfer_moles = 0.25 * env.total_moles
				var/datum/gas_mixture/removed = env.remove(transfer_moles)
				if(removed)
					var/heat_transfer = removed.get_thermal_energy_change(set_temperature)
					var/power_draw
					if(heat_transfer > 0) // Heating.
						heat_transfer = min(heat_transfer , heating_power) // Limit by the power rating of the heater.

						removed.add_thermal_energy(heat_transfer)
						power_draw = heat_transfer
					else // Cooling.
						heat_transfer = abs(heat_transfer)

						// Assume the heat is being pumped into the hull which is fixed at 20 C.
						var/cop = removed.temperature/T20C	// Co-efficient of performance from thermodynamics -> power used = heat_transfer/cop.
						heat_transfer = min(heat_transfer, cop * heating_power)	// Limit heat transfer by available power.

						heat_transfer = removed.add_thermal_energy(-heat_transfer)	// Get the actual heat transfer.

						power_draw = abs(heat_transfer)/cop
					cell.use(power_draw * CELLRATE)
					active = heat_transfer

				env.merge(removed)
		else
			on = FALSE
			active = FALSE
			power_change()
		update_icon()
