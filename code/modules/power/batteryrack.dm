//The one that works safely.
/obj/machinery/power/smes/batteryrack
	name = "power cell rack PSU"
	desc = "A rack of power cells working as a PSU."
	charge = 0 //you dont really want to make a potato PSU which already is overloaded
	output_attempt = 0
	input_level = 0
	output_level = 0
	input_level_max = 0
	output_level_max = 0
	icon_state = "gsmes"
	var/cells_amount = 0
	var/capacitors_amount = 0

	component_types = list(
		/obj/item/circuitboard/batteryrack,
		/obj/item/cell/high = 3
	)

/obj/machinery/power/smes/batteryrack/RefreshParts()
	capacitors_amount = 0
	cells_amount = 0

	var/max_level = 0 //for both input and output
	for(var/obj/item/stock_parts/capacitor/CP in component_parts)
		max_level += CP.rating
		capacitors_amount++
	input_level_max = 50000 + max_level * 20000
	output_level_max = 50000 + max_level * 20000

	var/C = 0
	for(var/obj/item/cell/PC in component_parts)
		C += PC.maxcharge
		cells_amount++
	capacity = C * 40   //Basic cells are such crap. Hyper cells needed to get on normal SMES levels.


/obj/machinery/power/smes/batteryrack/update_icon()
	cut_overlays()
	if(stat & BROKEN)	return

	if (output_attempt)
		add_overlay("gsmes_outputting")
	if(inputting)
		add_overlay("gsmes_charging")

	var/clevel = chargedisplay()
	if(clevel>0)
		add_overlay("gsmes_og[clevel]")

/obj/machinery/power/smes/batteryrack/chargedisplay()
	return round(4 * charge/(capacity ? capacity : 5e6))


/obj/machinery/power/smes/batteryrack/attackby(var/obj/item/W as obj, var/mob/user as mob) //these can only be moved by being reconstructed, solves having to remake the powernet.
	..() //SMES attackby for now handles screwdriver, cable coils and wirecutters, no need to repeat that here
	if(open_hatch)
		if(W.iscrowbar())
			if (charge < (capacity / 100))
				if (!output_attempt && !input_attempt)
					playsound(get_turf(src), 'sound/items/Crowbar.ogg', 50, 1)
					var/obj/machinery/constructable_frame/machine_frame/M = new /obj/machinery/constructable_frame/machine_frame(src.loc)
					M.state = 2
					M.icon_state = "box_1"
					for(var/obj/I in component_parts)
						I.forceMove(src.loc)
					qdel(src)
					return 1
				else
					to_chat(user, "<span class='warning'>Turn off the [src] before dismantling it.</span>")
			else
				to_chat(user, "<span class='warning'>Better let [src] discharge before dismantling it.</span>")
		else if ((istype(W, /obj/item/stock_parts/capacitor) && (capacitors_amount < 5)) || (istype(W, /obj/item/cell) && (cells_amount < 5)))
			if (charge < (capacity / 100))
				if (!output_attempt && !input_attempt)
					user.drop_from_inventory(W,src)
					component_parts += W
					RefreshParts()
					to_chat(user, "<span class='notice'>You upgrade the [src] with [W.name].</span>")
				else
					to_chat(user, "<span class='warning'>Turn off the [src] before dismantling it.</span>")
			else
				to_chat(user, "<span class='warning'>Better let [src] discharge before putting your hand inside it.</span>")
		else
			user.set_machine(src)
			interact(user)
			return 1
	return


//The shitty one that will blow up.
/obj/machinery/power/smes/batteryrack/makeshift
	name = "makeshift PSU"
	desc = "A rack of batteries connected by a mess of wires posing as a PSU."
	var/overcharge_percent = 0

	component_types = list(
		/obj/item/circuitboard/ghettosmes,
		/obj/item/cell/high = 3
	)

/obj/machinery/power/smes/batteryrack/makeshift/update_icon()
	cut_overlays()
	if(stat & BROKEN)	return

	if (output_attempt)
		add_overlay("gsmes_outputting")
	if(inputting)
		add_overlay("gsmes_charging")
	if (overcharge_percent > 100)
		add_overlay("gsmes_overcharge")
	else
		var/clevel = chargedisplay()
		if(clevel>0)
			add_overlay("gsmes_og[clevel]")

//This mess of if-elses and magic numbers handles what happens if the engies don't pay attention and let it eat too much charge
//What happens depends on how much capacity has the ghetto smes and how much it is overcharged.
//Under 1.2M: 5% of ion_act() per process() tick from 125% and higher overcharges. 1.2M is achieved with 3 high cells.
//[1.2M-2.4M]: 6% ion_act from 120%. 1% of EMP from 140%.
//(2.4M-3.6M] :7% ion_act from 115%. 1% of EMP from 130%. 1% of non-hull-breaching explosion at 150%.
//(3.6M-INFI): 8% ion_act from 115%. 2% of EMP from 125%. 1% of Hull-breaching explosion from 140%.
/obj/machinery/power/smes/batteryrack/makeshift/proc/overcharge_consequences()
	switch (capacity)
		if (0 to (1.2e6-1))
			if (overcharge_percent >= 125)
				if (prob(5))
					ion_act()
		if (1.2e6 to 2.4e6)
			if (overcharge_percent >= 120)
				if (prob(6))
					ion_act()
			else
				return
			if (overcharge_percent >= 140)
				if (prob(1))
					empulse(src.loc, 3, 8, 1)
		if ((2.4e6+1) to 3.6e6)
			if (overcharge_percent >= 115)
				if (prob(7))
					ion_act()
			else
				return
			if (overcharge_percent >= 130)
				if (prob(1))
					empulse(src.loc, 3, 8, 1)
			if (overcharge_percent >= 150)
				if (prob(1))
					explosion(src.loc, 0, 1, 3, 5)
		if ((3.6e6+1) to INFINITY)
			if (overcharge_percent >= 115)
				if (prob(8))
					ion_act()
			else
				return
			if (overcharge_percent >= 125)
				if (prob(2))
					empulse(src.loc, 4, 10, 1)
			if (overcharge_percent >= 140)
				if (prob(1))
					explosion(src.loc, 1, 3, 5, 8)
		else //how the hell was this proc called for negative charge
			charge = 0


#define SMESRATE 0.05			// rate of internal charge to external power
/obj/machinery/power/smes/batteryrack/makeshift/machinery_process()
	if(stat & BROKEN)	return

	//store machine state to see if we need to update the icon overlays
	var/last_disp = chargedisplay()
	var/last_chrg = inputting
	var/last_onln = output_attempt
	var/last_overcharge = overcharge_percent

	if(terminal)
		if(input_attempt)
			var/target_load = min((capacity-charge)/SMESRATE, input_level)		// charge at set rate, limited to spare capacity
			var/actual_load = draw_power(target_load)		// add the load to the terminal side network
			charge += actual_load * SMESRATE	// increase the charge

			if (actual_load >= target_load) // did the powernet have enough power available for us?
				inputting = 1
			else
				inputting = 0

	if(output_attempt)		// if outputting
		output_used = min( charge/SMESRATE, output_level)		//limit output to that stored
		charge -= output_used*SMESRATE		// reduce the storage (may be recovered in /restore() if excessive)
		add_avail(output_used)				// add output to powernet (smes side)
		if(charge < 0.0001)
			outputting(0)					// stop output if charge falls to zero

	overcharge_percent = round((charge / capacity) * 100)
	if (overcharge_percent > 115) //115% is the minimum overcharge for anything to happen
		overcharge_consequences()

	// only update icon if state changed
	if(last_disp != chargedisplay() || last_chrg != inputting || last_onln != output_attempt || ((overcharge_percent > 100) ^ (last_overcharge > 100)))
		update_icon()
	return

#undef SMESRATE
