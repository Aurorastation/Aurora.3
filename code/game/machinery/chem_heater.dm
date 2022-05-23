#define SLOW_MODE_MAX_TEMP_CHANGE 2 //C

/obj/machinery/chem_heater
	name = "chemical heater"
	desc = "A simple device that can be used to heat the contents of a beaker to a precise temperature."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "mixer0b"
	use_power = POWER_USE_OFF
	idle_power_usage = 100
	density = 1
	anchored = 1
	var/obj/item/reagent_containers/container
	var/target_temperature = 300 //Measured in kelvin.
	var/accept_drinking = FALSE
	var/machine_strength = 0 //How much joules to add per process. Controlled by manipulators.
	var/should_heat = TRUE
	var/min_temperature = 100
	var/max_temperature = 600
	var/slow_mode = FALSE

	component_types = list(
		/obj/item/circuitboard/chem_heater,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/manipulator
	)

/obj/machinery/chem_heater/attack_hand(mob/user)
	user.set_machine(src)
	interact(user)

/obj/machinery/chem_heater/attackby(obj/item/O, mob/user)
	if(default_deconstruction_screwdriver(user, O))
		return TRUE
	if(default_deconstruction_crowbar(user, O))
		return TRUE
	if(default_part_replacement(user, O))
		return TRUE
	if(istype(O, /obj/item/reagent_containers/glass) || istype(O, /obj/item/reagent_containers/food))
		if(container)
			to_chat(user, SPAN_WARNING("There is already \a [container] on \the [src]!"))
			return TRUE

		var/obj/item/reagent_containers/RC = O
		if(!RC.is_open_container())
			to_chat(user, SPAN_WARNING("You don't see how \the [src] could heat up the reagents in \the [RC]."))
			return TRUE

		container =  RC
		user.drop_from_inventory(RC,src)
		to_chat(user, SPAN_NOTICE("You set \the [RC] in \the [src]."))
		updateUsrDialog()
		return TRUE

/obj/machinery/chem_heater/interact(mob/user as mob)
	if(stat & BROKEN)
		return
	user.set_machine(src)
	var/dat = "<html>"

	dat += "Power: <a href='?src=\ref[src];action=togglepower'>[use_power ? "On" : "Off"]</a>"
	dat += "<p>Slow Heating Mode: <a href='?src=\ref[src];action=slowmode'>[slow_mode ? "On" : "Off"]</a>"

	dat += "<p>Target Temp: [round(target_temperature)]K / [round(target_temperature - T0C,0.1)]C<br>"

	dat += "| "
	dat += "<a href='?src=\ref[src];action=adjusttemp;power=-100'>----</a>"
	dat += "<a href='?src=\ref[src];action=adjusttemp;power=-25'>---</a>"
	dat += "<a href='?src=\ref[src];action=adjusttemp;power=-5'>--</a>"
	dat += "<a href='?src=\ref[src];action=adjusttemp;power=-1'>-</a>"
	dat += "<a href='?src=\ref[src];action=adjusttemp;power=1'>+</a>"
	dat += "<a href='?src=\ref[src];action=adjusttemp;power=5'>++</a>"
	dat += "<a href='?src=\ref[src];action=adjusttemp;power=25'>+++</a>"
	dat += "<a href='?src=\ref[src];action=adjusttemp;power=100'>++++</a>"
	dat += "| </p>"

	if(container)
		dat += "<p>Beaker Temp: [round(container.get_temperature(),0.01)]K / [round(container.get_temperature() - T0C,0.1)]C <a href='?src=\ref[src];action=removebeaker'>Remove</a></p>"
	else
		dat += "<p>No container loaded!</p>"

	dat += "</html>"

	var/datum/browser/chem_win = new(user, "chem_heater", "Chem Heater MKI")
	chem_win.set_content(dat)
	chem_win.open()

/obj/machinery/chem_heater/Topic(href, href_list)
	if(stat & BROKEN) return
	if(usr.stat || usr.restrained()) return
	if(!in_range(src, usr)) return

	usr.set_machine(src)

	switch(href_list["action"])
		if("togglepower")
			update_use_power(!use_power)
			if(container)
				should_heat = target_temperature >= container.get_temperature()
		if("removebeaker")
			if(container)
				container.forceMove(src.loc)
				container = null
				update_icon()
		if("adjusttemp")
			target_temperature = max(min_temperature,min(target_temperature + text2num(href_list["power"]),max_temperature))
			if(container)
				should_heat = target_temperature >= container.get_temperature()
		if("slowmode")
			slow_mode = !slow_mode

	updateUsrDialog()

/obj/machinery/chem_heater/process()

	..()

	if(!use_power)
		return

	if(container && container.reagents)

		var/current_temperature = container.reagents.get_temperature()
		var/target_temperature_limited = slow_mode ? current_temperature + SLOW_MODE_MAX_TEMP_CHANGE : target_temperature

		if(should_heat && current_temperature >= target_temperature)
			update_use_power(POWER_USE_OFF)
			updateUsrDialog()
			return
		else if(!should_heat && current_temperature <= target_temperature)
			update_use_power(POWER_USE_OFF)
			updateUsrDialog()
			return

		var/joules_to_use = machine_strength * 1000
		var/mod = should_heat ? 1 : -1
		var/thermal_energy_change = 0
		var/thermal_energy_limit = container.reagents.get_thermal_energy_change(current_temperature,target_temperature_limited) //Don't go over the target temperature
		var/thermal_energy_limit2 = container.reagents.get_thermal_energy_change(current_temperature,current_temperature + machine_strength*mod*5) //So small reagents don't go from 0 to 1000 in a few seconds.
		if(mod > 0) //GOING UP
			thermal_energy_change = min(joules_to_use,thermal_energy_limit,thermal_energy_limit2)
		else //GOING DOWN
			thermal_energy_change = max(-joules_to_use,thermal_energy_limit,thermal_energy_limit2)

		container.reagents.add_thermal_energy(thermal_energy_change)
		container.reagents.handle_reactions()
		use_power_oneoff(joules_to_use)
		updateUsrDialog()

	else
		update_use_power(POWER_USE_IDLE)
		updateUsrDialog()
		return

	return 1

/obj/machinery/chem_heater/RefreshParts()
	machine_strength = initial(machine_strength)
	for(var/obj/item/stock_parts/P in component_parts)
		if(ismanipulator(P))
			machine_strength += P.rating



#undef SLOW_MODE_MAX_TEMP_CHANGE
