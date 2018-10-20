/obj/machinery/chem_heater
	name = "chemical heater"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "mixer0b"
	use_power = 0
	idle_power_usage = 100
	density = 1
	anchored = 1
	var/obj/item/weapon/reagent_containers/container
	var/target_temperature = 300 //Measured in kelvin.
	var/accept_drinking = FALSE
	var/machine_strength = 0 //How much joules to add per process. Controlled by manipulators.
	var/should_heat = TRUE
	var/min_temperature = 50
	var/max_temperature = 1000

	component_types = list(
		/obj/item/weapon/circuitboard/chem_heater,
		/obj/item/weapon/stock_parts/manipulator,
		/obj/item/weapon/stock_parts/manipulator,
		/obj/item/weapon/stock_parts/manipulator
	)

/obj/machinery/chem_heater/attack_hand(mob/user)
	user.set_machine(src)
	interact(user)

/obj/machinery/chem_heater/attackby(obj/item/O, mob/user)
	if(default_deconstruction_screwdriver(user, O))
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return
	if(istype(O, /obj/item/weapon/reagent_containers/glass) || istype(O, /obj/item/weapon/reagent_containers/food))
		if(container)
			user << "<span class='warning'>There is already \a [container] on \the [src]!</span>"
			return

		var/obj/item/weapon/reagent_containers/RC = O

		if(!accept_drinking && istype(RC,/obj/item/weapon/reagent_containers/food))
			user << "<span class='warning'>This machine only accepts beakers!</span>"
			return

		if(!RC.is_open_container())
			user << "<span class='warning'>You don't see how \the [src] could heat up the reagents in \the [RC].</span>"
			return

		container =  RC
		user.drop_from_inventory(RC,src)
		user << "<span class='notice'>You set \the [RC] in \the [src].</span>"
		updateUsrDialog()
		return

/obj/machinery/chem_heater/interact(mob/user as mob)
	if(stat & BROKEN)
		return
	user.set_machine(src)
	var/dat ="<html>"
	dat += "<head><TITLE>Chem Heater MKI</TITLE><style>body{font-family:Garamond}</style></head>"
	dat += "<body><H1>Chem Heater MKI</H1>"

	dat += "<p>Power: <a href='?src=\ref[src];action=togglepower'>[use_power ? "On" : "Off"]</a></p>"
	dat += "<p>Target Temp: [round(target_temperature)]K / [round(target_temperature - T0C,0.1)]C<br> "

	dat += "("
	dat += "<a href='?src=\ref[src];action=adjusttemp;power=-100'>----</a>|"
	dat += "<a href='?src=\ref[src];action=adjusttemp;power=-25'>---</a>|"
	dat += "<a href='?src=\ref[src];action=adjusttemp;power=-5'>--</a>|"
	dat += "<a href='?src=\ref[src];action=adjusttemp;power=-1'>-</a>|"
	dat += "<a href='?src=\ref[src];action=adjusttemp;power=1'>+</a>|"
	dat += "<a href='?src=\ref[src];action=adjusttemp;power=5'>++</a>|"
	dat += "<a href='?src=\ref[src];action=adjusttemp;power=25'>+++</a>|"
	dat += "<a href='?src=\ref[src];action=adjusttemp;power=100'>++++</a>"
	dat += ")</p>"

	if(container)
		dat += "<p>Beaker Temp: [round(container.get_temperature(),0.01)]K / [round(container.get_temperature() - T0C,0.1)]C (<a href='?src=\ref[src];action=removebeaker'>Remove</a>)</p>"
	else
		dat += "<p>No container loaded!</p>"

	dat += "</body><html>"

	user << browse(dat, "window=chem_heater")
	onclose(user, "chem_heater")
	return

/obj/machinery/chem_heater/Topic(href, href_list)
	if(stat & BROKEN) return
	if(usr.stat || usr.restrained()) return
	if(!in_range(src, usr)) return

	usr.set_machine(src)

	switch(href_list["action"])
		if("togglepower")
			use_power = !use_power
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

	updateUsrDialog()

/obj/machinery/chem_heater/machinery_process()

	..()

	if(!use_power)
		return

	if(container && container.reagents)

		if(should_heat && container.reagents.get_temperature() >= target_temperature)
			use_power = 0
			updateUsrDialog()
			return
		else if(!should_heat && container.reagents.get_temperature() <= target_temperature)
			use_power = 0
			updateUsrDialog()
			return

		var/joules_to_use = machine_strength
		var/mod = should_heat ? 1 : -1
		var/thermal_energy_change = 0

		if(mod > 0) //GOING UP
			thermal_energy_change = min(joules_to_use,container.reagents.get_thermal_energy_change(container.reagents.get_temperature(),target_temperature))
		else //GOING DOWN
			thermal_energy_change = max(-joules_to_use,container.reagents.get_thermal_energy_change(container.reagents.get_temperature(),target_temperature))

		container.reagents.add_thermal_energy(thermal_energy_change)
		container.reagents.handle_reactions()
		use_power(joules_to_use)
		updateUsrDialog()

	else
		use_power = 0
		updateUsrDialog()
		return

	return 1

/obj/machinery/chem_heater/RefreshParts()
	machine_strength = initial(machine_strength)
	for(var/obj/item/weapon/stock_parts/P in component_parts)
		if(ismanipulator(P))
			machine_strength += P.rating * 1000



