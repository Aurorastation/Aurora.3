/obj/machinery/space_heater
	anchored = 0
	density = 1
	icon = 'icons/obj/atmos.dmi'
	icon_state = "sheater0"
	name = "space A/C"
	desc = "Made by Space Amish using traditional space techniques, this A/C unit can heat or cool a room to your liking."
	var/obj/item/cell/apc/cell
	var/on = 0
	var/set_temperature = T0C + 50	//K
	var/heating_power = 42000
	emagged = FALSE
	has_special_power_checks = TRUE
	clicksound = "switch"

/obj/machinery/space_heater/Initialize()
	. = ..()
	cell = new(src)
	update_icon()

/obj/machinery/space_heater/update_icon()
	cut_overlays()
	icon_state = "sheater[on]"
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
		return 1
	return 0

/obj/machinery/space_heater/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return
	if(cell)
		cell.emp_act(severity)
	..(severity)

/obj/machinery/space_heater/emag_act(var/remaining_charges, mob/user)
	if(!emagged)
		emagged = TRUE
		to_chat(user, span("warning", "You disable \the [src]'s temperature safety checks!"))
		spark(src, 3)
		playsound(src, "sparks", 100, 1)
		heating_power = 45000 //Overridden safeties make it stronger, and it needs to work more efficiently to make use of big temp ranges
		return 1
	else
		to_chat(user, span("danger", "\The [src]'s temperature safety checks have already been disabled!"))
		return 0

/obj/machinery/space_heater/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/cell))
		if(panel_open)
			if(cell)
				to_chat(user, "There is already a power cell inside.")
				return
			else
				// insert cell
				user.drop_from_inventory(I,src)
				cell = I
				I.add_fingerprint(user)

				visible_message(span("notice", "[user] inserts a power cell into [src]."),
					span("notice", "You insert the power cell into [src]."))
				power_change()
		else
			to_chat(user, span("notice", "The hatch must be open to insert a power cell."))
			return
	else if(I.isscrewdriver())
		panel_open = !panel_open
		user.visible_message(span("notice", "[user] [panel_open ? "opens" : "closes"] the hatch on the [src]."),
				span("notice", "You [panel_open ? "open" : "close"] the hatch on the [src]."))
		update_icon()
		return
		if(!panel_open && user.machine == src)
			user << browse(null, "window=spaceheater")
			user.unset_machine()
	else
		..()
	return

/obj/machinery/space_heater/attack_hand(mob/user)
	src.add_fingerprint(user)
	if(panel_open)
		if(cell)
			user.visible_message(span("notice", "\The [user] removes \the [cell] from \the [src]."),
				span("notice", "You remove \the [cell] from \the [src]."))
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


	var/dat
	dat = "Power cell: "
	if(cell)
		dat += "Detected<BR>"
	else
		dat += "Not Detected<BR>"
	dat += "Power: "
	if(on)
		dat += "<A href='?src=\ref[src];op=off'>On</A><BR>"
	else
		dat += "<A href='?src=\ref[src];op=on'>Off</A><BR>"

	dat += "Power Level: [cell ? round(cell.percent(),1) : 0]%<BR><BR>"

	dat += "Set Temperature: "

	dat += "<A href='?src=\ref[src];op=temp;val=-5'>-</A>"

	dat += " [set_temperature]K ([set_temperature-T0C]&deg;C)"
	dat += "<A href='?src=\ref[src];op=temp;val=5'>+</A><BR>"

	user.set_machine(src)
	user << browse("<HEAD><TITLE>Space Heater Control Panel</TITLE></HEAD><TT>[dat]</TT>", "window=spaceheater")
	onclose(user, "spaceheater")
	return // needed?



/obj/machinery/space_heater/Topic(href, href_list)
	if (usr.stat)
		return
	if ((in_range(src, usr) && istype(src.loc, /turf)) || (istype(usr, /mob/living/silicon)))
		usr.set_machine(src)

		switch(href_list["op"])

			if("temp")
				var/value = text2num(href_list["val"])

				// limit to 0-90 degC unless emagged
				if(!emagged)
					set_temperature = dd_range(T0C, T0C + 90, set_temperature + value)
				else
					set_temperature = dd_range(T0C - 100, T0C + 150, set_temperature + value)

			if("off")
				on = !on
				usr.visible_message(span("notice", "[usr] switches off the [src]."),
					span("notice", "You switch off the [src]."))
				update_icon()

			if("on")
				if(cell)
					on = !on
					usr.visible_message(span("notice", "\The [usr] switches on \the [src]."),
						span("notice", "You switch on \the [src]."))
					update_icon()
				else
					to_chat(usr, span("notice", "You can't turn it on without a cell installed!"))
					return
		updateDialog()
	else
		usr << browse(null, "window=spaceheater")
		usr.unset_machine()
	return



/obj/machinery/space_heater/machinery_process()
	if(on)
		if(cell && cell.charge)
			var/datum/gas_mixture/env = loc.return_air()
			if(env && abs(env.temperature - set_temperature) > 0.1)
				var/transfer_moles = 0.3 * env.total_moles
				var/datum/gas_mixture/removed = env.remove(transfer_moles)
				if(emagged)
					transfer_moles = 0.4 * env.total_moles //Moves a little faster for big temperature swings
				if(removed)
					var/heat_transfer = removed.get_thermal_energy_change(set_temperature)
					if(heat_transfer > 0)	//heating air
						heat_transfer = min( heat_transfer , heating_power ) //limit by the power rating of the heater

						removed.add_thermal_energy(heat_transfer)
						cell.use(heat_transfer*CELLRATE)
					else	//cooling air
						heat_transfer = abs(heat_transfer)

						//Assume the heat is being pumped into the hull which is fixed at 20 C
						var/cop = removed.temperature/T20C	//coefficient of performance from thermodynamics -> power used = heat_transfer/cop
						heat_transfer = min(heat_transfer, cop * heating_power)	//limit heat transfer by available power

						heat_transfer = removed.add_thermal_energy(-heat_transfer)	//get the actual heat transfer

						var/power_used = abs(heat_transfer)/cop
						cell.use(power_used*CELLRATE)

				env.merge(removed)
		else
			on = 0
			src.visible_message("\The [src] clicks off and whirrs slowly as it powers down.")
			power_change()
			update_icon()
