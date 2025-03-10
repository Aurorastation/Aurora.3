/obj/item/gun/launcher/pneumatic
	name = "pneumatic cannon"
	desc = "A large gas-powered cannon."
	icon = 'icons/obj/guns/pneumatic.dmi'
	icon_state = "pneumatic"
	item_state = "pneumatic"
	slot_flags = SLOT_BELT
	w_class = WEIGHT_CLASS_HUGE
	obj_flags = OBJ_FLAG_CONDUCTABLE
	fire_sound_text = "a loud whoosh of moving air"
	fire_delay = 50
	fire_sound = 'sound/weapons/tablehit1.ogg'
	needspin = FALSE

	var/fire_pressure                                   // Used in fire checks/pressure checks.
	var/max_w_class = WEIGHT_CLASS_NORMAL                                 // Hopper intake size.
	var/max_storage_space = DEFAULT_LARGEBOX_STORAGE                      // Total internal storage size.
	var/obj/item/tank/tank = null                // Tank of gas for use in firing the cannon.

	var/obj/item/storage/item_storage
	var/pressure_setting = 10                           // Percentage of the gas in the tank used to fire the projectile.
	var/possible_pressure_amounts = list(5,10,20,25,50) // Possible pressure settings.
	var/force_divisor = 400                             // Force equates to speed. Speed/5 equates to a damage multiplier for whoever you hit.
														// For reference, a fully pressurized oxy tank at 50% gas release firing a health
														// analyzer with a force_divisor of 10 hit with a damage multiplier of 3000+.
/obj/item/gun/launcher/pneumatic/Initialize()
	. = ..()
	item_storage = new(src)
	item_storage.name = "hopper"
	item_storage.max_w_class = max_w_class
	item_storage.max_storage_space = max_storage_space
	item_storage.use_sound = null

/obj/item/gun/launcher/pneumatic/verb/set_pressure() //set amount of tank pressure.
	set name = "Set Valve Pressure"
	set category = "Object"
	set src in range(0)
	var/N = input("Percentage of tank used per shot:","[src]") as null|anything in possible_pressure_amounts
	if (N)
		pressure_setting = N
		to_chat(usr, "You dial the pressure valve to [pressure_setting]%.")

/obj/item/gun/launcher/pneumatic/proc/eject_tank(mob/user) //Remove the tank.
	if(!tank)
		to_chat(user, "There's no tank in [src].")
		return

	to_chat(user, "You twist the valve and pop the tank out of [src].")
	user.put_in_hands(tank)
	tank = null
	update_icon()

/obj/item/gun/launcher/pneumatic/proc/unload_hopper(mob/user)
	if(item_storage.contents.len > 0)
		var/obj/item/removing = item_storage.contents[item_storage.contents.len]
		item_storage.remove_from_storage(removing, src.loc)
		user.put_in_hands(removing)
		to_chat(user, "You remove [removing] from the hopper.")
	else
		to_chat(user, "There is nothing to remove in \the [src].")

/obj/item/gun/launcher/pneumatic/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		unload_hopper(user)
	else
		return ..()

/obj/item/gun/launcher/pneumatic/attackby(obj/item/attacking_item, mob/user)
	if(!tank && istype(attacking_item,/obj/item/tank))
		user.drop_from_inventory(attacking_item, src)
		tank = attacking_item
		user.visible_message("[user] jams [attacking_item] into [src]'s valve and twists it closed.",
								"You jam [attacking_item] into [src]'s valve and twist it closed.")
		update_icon()
	else if(istype(attacking_item) && item_storage.can_be_inserted(attacking_item))
		item_storage.handle_item_insertion(attacking_item)

/obj/item/gun/launcher/pneumatic/unique_action(mob/user)
	eject_tank(user)

/obj/item/gun/launcher/pneumatic/consume_next_projectile(mob/user=null)
	if(!item_storage.contents.len)
		return null
	if (!tank)
		to_chat(user, "There is no gas tank in [src]!")
		return null

	var/environment_pressure = 10
	var/turf/T = get_turf(src)
	if(T)
		var/datum/gas_mixture/environment = T.return_air()
		if(environment)
			environment_pressure = environment.return_pressure()

	fire_pressure = (tank.air_contents.return_pressure() - environment_pressure)*pressure_setting/100
	if(fire_pressure < 10)
		to_chat(user, "There isn't enough gas in the tank to fire [src].")
		return null

	var/obj/item/launched = item_storage.contents[1]
	item_storage.remove_from_storage(launched, src)
	return launched

/obj/item/gun/launcher/pneumatic/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(distance > 2)
		return
	. += "The valve is dialed to [pressure_setting]%."
	if(tank)
		. += "The tank dial reads [tank.air_contents.return_pressure()] kPa."
	else
		. += "Nothing is attached to the tank valve!"

/obj/item/gun/launcher/pneumatic/update_release_force(obj/item/projectile)
	if(tank)
		release_force = ((fire_pressure*tank.volume)/projectile.w_class)/force_divisor //projectile speed.
		if(release_force > 80) release_force = 80 //damage cap.
	else
		release_force = 0

/obj/item/gun/launcher/pneumatic/handle_post_fire()
	if(tank)
		var/lost_gas_amount = tank.air_contents.total_moles*(pressure_setting/100)
		var/datum/gas_mixture/removed = tank.air_contents.remove(lost_gas_amount)

		var/turf/T = get_turf(src.loc)
		if(T) T.assume_air(removed)
	..()

/obj/item/gun/launcher/pneumatic/update_icon()
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

/obj/item/cannonframe
	name = "pneumatic cannon frame"
	desc = "A half-finished pneumatic cannon."
	icon_state = "pneumatic0"
	item_state = "pneumatic"
	icon = 'icons/obj/weapons.dmi'
	var/buildstate = 0

/obj/item/cannonframe/update_icon()
	icon_state = "pneumatic[buildstate]"

/obj/item/cannonframe/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	switch(buildstate)
		if(1)
			. += "It has a pipe segment installed."
		if(2)
			. += "It has a pipe segment welded in place."
		if(3)
			. += "It has an outer chassis installed."
		if(4)
			. += "It has an outer chassis welded in place."
		if(5)
			. += "It has a transfer valve installed."

/obj/item/cannonframe/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/pipe))
		if(buildstate == 0)
			qdel(attacking_item)
			to_chat(user, SPAN_NOTICE("You secure the piping inside the frame."))
			buildstate++
			update_icon()
			return
	else if(istype(attacking_item, /obj/item/stack/material) && attacking_item.get_material_name() == DEFAULT_WALL_MATERIAL)
		if(buildstate == 2)
			var/obj/item/stack/material/M = attacking_item
			if(M.use(5))
				to_chat(user, SPAN_NOTICE("You assemble a chassis around the cannon frame."))
				buildstate++
				update_icon()
			else
				to_chat(user, SPAN_NOTICE("You need at least five metal sheets to complete this task."))
			return
	else if(istype(attacking_item,/obj/item/device/transfer_valve))
		if(buildstate == 4)
			qdel(attacking_item)
			to_chat(user, SPAN_NOTICE("You install the transfer valve and connect it to the piping."))
			buildstate++
			update_icon()
			return
	else if(attacking_item.iswelder())
		if(buildstate == 1)
			var/obj/item/weldingtool/T = attacking_item
			if(T.use(0,user))
				if(!src || !T.isOn()) return
				playsound(src.loc, 'sound/items/welder_pry.ogg', 100, 1)
				to_chat(user, SPAN_NOTICE("You weld the pipe into place."))
				buildstate++
				update_icon()
		if(buildstate == 3)
			var/obj/item/weldingtool/T = attacking_item
			if(T.use(0,user))
				if(!src || !T.isOn()) return
				playsound(src.loc, 'sound/items/welder_pry.ogg', 100, 1)
				to_chat(user, SPAN_NOTICE("You weld the metal chassis together."))
				buildstate++
				update_icon()
		if(buildstate == 5)
			var/obj/item/weldingtool/T = attacking_item
			if(T.use(0,user))
				if(!src || !T.isOn()) return
				playsound(src.loc, 'sound/items/welder_pry.ogg', 100, 1)
				to_chat(user, SPAN_NOTICE("You weld the valve into place."))
				new /obj/item/gun/launcher/pneumatic(get_turf(src))
				qdel(src)
		return
	else
		..()

/obj/item/gun/launcher/pneumatic/small
	name = "small pneumatic cannon"
	desc = "It looks smaller than your garden variety cannon"
	max_w_class = WEIGHT_CLASS_TINY
	w_class = WEIGHT_CLASS_NORMAL
