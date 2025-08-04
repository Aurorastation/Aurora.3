// the power cell
// charge from 0 to 100%
// fits in APC to provide backup power

/obj/item/cell/antagonist_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Injecting 5 units of phoron into a power cell with a syringe will rig it to explode!"
	. += "The higher the charge in the cell, the bigger and more damaging the explosion will be."
	. += "When rigged, the cell will explode immediately whenever it is next charged or discharged."

/obj/item/cell/feedback_hints(mob/user, distance, is_adjacent)
	if(distance > 1)
		return
	. = list()
	. += ..()
	. += "The manufacturer's label states this cell has a power rating of [maxcharge]J, and that you should not swallow it."
	. += "The charge meter reads [round(src.percent() )]%."

/obj/item/cell/Initialize()
	. = ..()

	charge = maxcharge

	if(self_charge_percentage)
		START_PROCESSING(SSprocessing, src)

	update_icon()

/obj/item/cell/Destroy()
	if(self_charge_percentage)
		STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/cell/process(seconds_per_tick)
	if(self_charge_percentage)
		// we wanna recharge [self_charge_percentage% of the max charge] amount every 60 seconds
		var/recharge_amount_per_minute = (maxcharge / 100) * self_charge_percentage
		// since process fires every ~2 seconds, we wanna get the recharge amount per second
		var/recharge_amount_per_second = recharge_amount_per_minute / 60
		// multiply the amount per second with how many seconds this tick took, then round it to prevent float errors
		var/recharge_for_this_process = round(recharge_amount_per_second * (seconds_per_tick / 10)) // divides seconds_per_tick by 10 to turn deciseconds into seconds
		// finally, charge the cell
		give(recharge_for_this_process)

/obj/item/cell/Created()
	//Newly built cells spawn with no charge to prevent power exploits
	charge = 0
	update_icon()

/obj/item/cell/get_cell()
	return src

/obj/item/cell/drain_power(var/drain_check, var/surge, var/power = 0)

	if(drain_check)
		return 1

	if(charge <= 0)
		return 0

	var/cell_amt = power * CELLRATE

	return use(cell_amt) / CELLRATE

/obj/item/cell/update_icon()
	ClearOverlays()
	switch(percent())
		if(95 to 100)
			AddOverlays("cell-o2")
		if(25 to 94)
			AddOverlays("cell-o1")
		if(0.05 to 25)
			AddOverlays("cell-o0")
		if(0 to 0.05)
			return

/obj/item/cell/proc/percent()		// return % charge of cell
	return maxcharge && (100.0*charge/maxcharge)

/obj/item/cell/proc/fully_charged()
	return (charge == maxcharge)

// checks if the power cell is able to provide the specified amount of charge
/obj/item/cell/proc/check_charge(var/amount)
	return (charge >= amount)

// use power from a cell, returns the amount actually used
/obj/item/cell/use(var/amount)
	if (QDELING(src))
		return 0

	if(rigged && amount > 0)
		explode()
		return 0
	var/used = min(charge, amount)
	charge -= used
	SEND_SIGNAL(src, COMSIG_CELL_CHARGE, charge)
	return used

// Checks if the specified amount can be provided. If it can, it removes the amount
// from the cell and returns 1. Otherwise drains the charge to exactly 0 and returns 0.
/obj/item/cell/proc/checked_use(var/amount)
	. = check_charge(amount)
	use(amount)

// recharge the cell
/obj/item/cell/proc/give(var/amount)
	if (QDELING(src))
		return 0

	if(rigged && amount > 0)
		explode()
		return 0

	var/amount_used = min(maxcharge-charge,amount)
	charge += amount_used
	SEND_SIGNAL(src, COMSIG_CELL_CHARGE, charge)
	return amount_used

/obj/item/cell/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/reagent_containers/syringe))
		var/obj/item/reagent_containers/syringe/S = attacking_item

		to_chat(user, "You inject the solution into the power cell.")

		if(S.reagents.has_reagent(/singleton/reagent/toxin/phoron, 5))

			rigged = 1

			log_admin("LOG: [user.name] ([user.ckey]) injected a power cell with phoron, rigging it to explode.")
			message_admins("[key_name_admin(user)] injected a power cell with phoron, rigging it to explode.")

		S.reagents.clear_reagents()
		return
	else if(istype(attacking_item, /obj/item/device/assembly_holder))
		var/obj/item/device/assembly_holder/assembly = attacking_item
		if (istype(assembly.a_left, /obj/item/device/assembly/signaler) && istype(assembly.a_right, /obj/item/device/assembly/signaler))
			//TODO: Look into this bad code
			user.drop_item()
			user.drop_from_inventory(src)

			new /obj/item/device/radiojammer/improvised(assembly, src, user)
		else
			to_chat(user, SPAN_NOTICE("You'd need both devices to be signallers for this to work."))
		return
	else if(attacking_item.ismultitool() && ishuman(user) && user.get_inactive_hand() == src)
		if(charge < 10)
			to_chat(user, SPAN_WARNING("\The [src] doesn't have enough charge to produce sufficient current!"))
			return
		var/mob/living/carbon/human/H = user
		var/siemens_coeff = 1
		if(H.gloves)
			siemens_coeff = H.gloves.siemens_coefficient
		if(siemens_coeff >= 0.75 && prob(10 * siemens_coeff))
			to_chat(H, SPAN_WARNING("You probe \the [src] with \the [attacking_item] and feel a jolt of electricity shoot through you! It reads out that [100 * siemens_coeff]% of the current was let through."))
			H.electrocute_act(5, src, siemens_coeff, H.hand ? BP_R_HAND : BP_L_HAND) // hand holding the battery gets shocked
		else
			to_chat(H, SPAN_NOTICE("You probe \the [src] with \the [attacking_item]. It reads out that [100 * siemens_coeff]% of the current was let through."))
		return
	return ..()

/obj/item/cell/proc/explode()
	var/turf/T = get_turf(src.loc)
/*
 * 1000-cell	explosion(T, -1, 0, 1, 1)
 * 2500-cell	explosion(T, -1, 0, 1, 1)
 * 10000-cell	explosion(T, -1, 1, 3, 3)
 * 15000-cell	explosion(T, -1, 2, 4, 4)
 * */
	if (charge==0)
		return
	var/devastation_range = -1 //round(charge/11000)
	var/heavy_impact_range = round(sqrt(charge)/60)
	var/light_impact_range = round(sqrt(charge)/30)
	var/flash_range = light_impact_range
	if (light_impact_range==0)
		rigged = 0
		corrupt()
		return
	//explosion(T, 0, 1, 2, 2)

	log_admin("LOG: Rigged power cell explosion, last touched by [fingerprintslast]")
	message_admins("LOG: Rigged power cell explosion, last touched by [fingerprintslast]")

	explosion(T, devastation_range, heavy_impact_range, light_impact_range, flash_range)

	qdel(src)

/obj/item/cell/proc/corrupt()
	charge /= 2
	maxcharge /= 2
	if (prob(10))
		rigged = 1 //broken batterys are dangerous

/obj/item/cell/emp_act(severity)
	. = ..()

	//remove this once emp changes on dev are merged in
	if(isrobot(loc))
		var/mob/living/silicon/robot/R = loc
		severity *= R.cell_emp_mult

	charge -= maxcharge / severity
	if (charge < 0)
		charge = 0
	SEND_SIGNAL(src, COMSIG_CELL_CHARGE, charge)

/**
 * Drains a percentage of the power from the battery
 *
 * * divisor - The fraction to remove, after multiplication with `cell_emp_mult` if a robot, calculated as maxcharge / divisor
 */
/obj/item/cell/proc/powerdrain(divisor)
	SHOULD_NOT_SLEEP(TRUE)

	if(isrobot(loc))
		var/mob/living/silicon/robot/R = loc
		divisor *= R.cell_emp_mult

	charge -= maxcharge / divisor
	if (charge < 0)
		charge = 0
	SEND_SIGNAL(src, COMSIG_CELL_CHARGE, charge)

/obj/item/cell/ex_act(severity)

	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return
			if (prob(50))
				corrupt()
		if(3.0)
			if (prob(25))
				qdel(src)
				return
			if (prob(25))
				corrupt()
	return

/obj/item/cell/proc/get_electrocute_damage()
	switch (charge)
/*		if (9000 to INFINITY)
			return min(rand(90,150),rand(90,150))
		if (2500 to 9000-1)
			return min(rand(70,145),rand(70,145))
		if (1750 to 2500-1)
			return min(rand(35,110),rand(35,110))
		if (1500 to 1750-1)
			return min(rand(30,100),rand(30,100))
		if (750 to 1500-1)
			return min(rand(25,90),rand(25,90))
		if (250 to 750-1)
			return min(rand(20,80),rand(20,80))
		if (100 to 250-1)
			return min(rand(20,65),rand(20,65))*/
		if (1000000 to INFINITY)
			return min(rand(50,160),rand(50,160))
		if (200000 to 1000000-1)
			return min(rand(25,80),rand(25,80))
		if (100000 to 200000-1)//Ave powernet
			return min(rand(20,60),rand(20,60))
		if (50000 to 100000-1)
			return min(rand(15,40),rand(15,40))
		if (1000 to 50000-1)
			return min(rand(10,20),rand(10,20))
		else
			return 0
