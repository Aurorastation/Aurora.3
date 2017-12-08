	name = "pneumatic cannon"
	desc = "A large gas-powered cannon."
	icon_state = "pneumatic"
	item_state = "pneumatic"
	slot_flags = SLOT_BELT
	w_class = 5.0
	flags =  CONDUCT
	fire_sound_text = "a loud whoosh of moving air"
	fire_delay = 50

	var/fire_pressure                                   // Used in fire checks/pressure checks.
	var/max_w_class = 3                                 // Hopper intake size.
	var/max_storage_space = 20                       // Total internal storage size.

	var/pressure_setting = 10                           // Percentage of the gas in the tank used to fire the projectile.
	var/possible_pressure_amounts = list(5,10,20,25,50) // Possible pressure settings.
	var/force_divisor = 400                             // Force equates to speed. Speed/5 equates to a damage multiplier for whoever you hit.
	                                                    // For reference, a fully pressurized oxy tank at 50% gas release firing a health
	                                                    // analyzer with a force_divisor of 10 hit with a damage multiplier of 3000+.
	. = ..()
	item_storage = new(src)
	item_storage.name = "hopper"
	item_storage.max_w_class = max_w_class
	item_storage.max_storage_space = max_storage_space
	item_storage.use_sound = null

	set name = "Set Valve Pressure"
	set category = "Object"
	set src in range(0)
	var/N = input("Percentage of tank used per shot:","[src]") as null|anything in possible_pressure_amounts
	if (N)
		pressure_setting = N
		usr << "You dial the pressure valve to [pressure_setting]%."

	if(!tank)
		user << "There's no tank in [src]."
		return

	user << "You twist the valve and pop the tank out of [src]."
	user.put_in_hands(tank)
	tank = null
	update_icon()

	if(item_storage.contents.len > 0)
		var/obj/item/removing = item_storage.contents[item_storage.contents.len]
		item_storage.remove_from_storage(removing, src.loc)
		user.put_in_hands(removing)
		user << "You remove [removing] from the hopper."
	else
		user << "There is nothing to remove in \the [src]."

	if(user.get_inactive_hand() == src)
		unload_hopper(user)
	else
		return ..()

		user.drop_from_inventory(W, src)
		tank = W
		user.visible_message("[user] jams [W] into [src]'s valve and twists it closed.","You jam [W] into [src]'s valve and twist it closed.")
		update_icon()
	else if(istype(W) && item_storage.can_be_inserted(W))
		item_storage.handle_item_insertion(W)

	eject_tank(user)

	if(!item_storage.contents.len)
		return null
	if (!tank)
		user << "There is no gas tank in [src]!"
		return null

	var/environment_pressure = 10
	var/turf/T = get_turf(src)
	if(T)
		var/datum/gas_mixture/environment = T.return_air()
		if(environment)
			environment_pressure = environment.return_pressure()

	fire_pressure = (tank.air_contents.return_pressure() - environment_pressure)*pressure_setting/100
	if(fire_pressure < 10)
		user << "There isn't enough gas in the tank to fire [src]."
		return null

	var/obj/item/launched = item_storage.contents[1]
	item_storage.remove_from_storage(launched, src)
	return launched

	if(!..(user, 2))
		return
	user << "The valve is dialed to [pressure_setting]%."
	if(tank)
		user << "The tank dial reads [tank.air_contents.return_pressure()] kPa."
	else
		user << "Nothing is attached to the tank valve!"

	if(tank)
		release_force = ((fire_pressure*tank.volume)/projectile.w_class)/force_divisor //projectile speed.
		if(release_force > 80) release_force = 80 //damage cap.
	else
		release_force = 0

	if(tank)
		var/lost_gas_amount = tank.air_contents.total_moles*(pressure_setting/100)
		var/datum/gas_mixture/removed = tank.air_contents.remove(lost_gas_amount)

		var/turf/T = get_turf(src.loc)
		if(T) T.assume_air(removed)
	..()

	if(tank)
		icon_state = "pneumatic-tank"
		item_state = "pneumatic-tank"
	else
		icon_state = "pneumatic"
		item_state = "pneumatic"

	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_r_hand()
		M.update_inv_l_hand()

//Constructable pneumatic cannon.

	name = "pneumatic cannon frame"
	desc = "A half-finished pneumatic cannon."
	icon_state = "pneumatic0"
	item_state = "pneumatic"

	var/buildstate = 0

	icon_state = "pneumatic[buildstate]"

	..(user)
	switch(buildstate)
		if(1) user << "It has a pipe segment installed."
		if(2) user << "It has a pipe segment welded in place."
		if(3) user << "It has an outer chassis installed."
		if(4) user << "It has an outer chassis welded in place."
		if(5) user << "It has a transfer valve installed."

	if(istype(W,/obj/item/pipe))
		if(buildstate == 0)
			user.drop_from_inventory(W)
			qdel(W)
			user << "<span class='notice'>You secure the piping inside the frame.</span>"
			buildstate++
			update_icon()
			return
	else if(istype(W,/obj/item/stack/material) && W.get_material_name() == DEFAULT_WALL_MATERIAL)
		if(buildstate == 2)
			var/obj/item/stack/material/M = W
			if(M.use(5))
				user << "<span class='notice'>You assemble a chassis around the cannon frame.</span>"
				buildstate++
				update_icon()
			else
				user << "<span class='notice'>You need at least five metal sheets to complete this task.</span>"
			return
	else if(istype(W,/obj/item/device/transfer_valve))
		if(buildstate == 4)
			user.drop_from_inventory(W)
			qdel(W)
			user << "<span class='notice'>You install the transfer valve and connect it to the piping.</span>"
			buildstate++
			update_icon()
			return
	else if(iswelder(W))
		if(buildstate == 1)
			if(T.remove_fuel(0,user))
				if(!src || !T.isOn()) return
				playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)
				user << "<span class='notice'>You weld the pipe into place.</span>"
				buildstate++
				update_icon()
		if(buildstate == 3)
			if(T.remove_fuel(0,user))
				if(!src || !T.isOn()) return
				playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)
				user << "<span class='notice'>You weld the metal chassis together.</span>"
				buildstate++
				update_icon()
		if(buildstate == 5)
			if(T.remove_fuel(0,user))
				if(!src || !T.isOn()) return
				playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)
				user << "<span class='notice'>You weld the valve into place.</span>"
				qdel(src)
		return
	else
		..()

	name = "small pneumatic cannon"
	desc = "It looks smaller than your garden variety cannon"
	max_w_class = 1
	w_class = 3
